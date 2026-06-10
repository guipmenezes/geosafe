import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "searchInput", "safetyScore", "scoreValue", "scoreBar", "scoreDescription"]
  static values = {
    alerts: Array,
    currentUserId: String
  }

  connect() {
    this.allAlerts = [...this.alertsValue]
    this.initMap()
    
    this.alertCreatedHandler = (event) => {
      console.log("Alert received in map controller:", event.detail.alert)
      this.addAlertMarker(event.detail.alert)
    }
    this.moveMarkerHandler = (event) => {
      const { lat, lng } = event.detail
      const latLng = new google.maps.LatLng(lat, lng)
      this.placePickMarker(latLng)
      this.map.panTo(latLng)
      this.updateSafetyScore(latLng)
    }
    
    window.addEventListener("alert:created", this.alertCreatedHandler)
    window.addEventListener("map:move-marker", this.moveMarkerHandler)
  }

  disconnect() {
    window.removeEventListener("alert:created", this.alertCreatedHandler)
    window.removeEventListener("map:move-marker", this.moveMarkerHandler)
  }

  initMap() {
    if (typeof google === 'undefined' || typeof google.maps.places === 'undefined') {
      setTimeout(() => this.initMap(), 100)
      return
    }

    const defaultCenter = { lat: -15.7942, lng: -47.8822 } // Brasília
    
    this.map = new google.maps.Map(this.containerTarget, {
      center: defaultCenter,
      zoom: 15,
      mapId: 'GEOSAFE_MAP_ID',
      mapTypeControl: false,
      fullscreenControl: false,
      streetViewControl: false
    })

    this.markers = []
    this.initAutocomplete()
    this.refreshMarkers()
    this.getUserLocation()
    this.processQueuedAlerts()
    
    this.map.addListener("click", (event) => {
      this.handleMapClick(event.latLng)
    })
  }

  initAutocomplete() {
    const options = {
      fields: ["geometry", "name", "formatted_address"],
      strictBounds: false,
      types: ["geocode", "establishment"]
    }

    this.autocomplete = new google.maps.places.Autocomplete(this.searchInputTarget, options)
    this.autocomplete.bindTo("bounds", this.map)

    this.autocomplete.addListener("place_changed", () => {
      const place = this.autocomplete.getPlace()

      if (!place.geometry || !place.geometry.location) {
        return
      }

      this.currentSearchLocation = place.geometry.location
      this.map.setCenter(place.geometry.location)
      this.map.setZoom(17)
      this.updateSafetyScore(place.geometry.location)
    })
  }

  updateSafetyScore(location) {
    if (typeof google.maps.geometry === 'undefined') {
      console.error("Google Maps Geometry library not loaded.")
      return
    }

    const radius = 10000 // 10km filter radius for search
    const scoreRadius = 1000 // 1km for score calculation (Updated from 500m)
    const now = Math.floor(Date.now() / 1000)
    
    // Filter alerts by proximity to show only those in the 10km radius
    this.filteredAlerts = this.allAlerts.filter(alert => {
      const alertPos = new google.maps.LatLng(alert.latitude, alert.longitude)
      const distance = google.maps.geometry.spherical.computeDistanceBetween(location, alertPos)
      return distance <= radius
    })

    // Calculate score based on 1km radius
    const scoreAlerts = this.filteredAlerts.filter(alert => {
      const alertPos = new google.maps.LatLng(alert.latitude, alert.longitude)
      const distance = google.maps.geometry.spherical.computeDistanceBetween(location, alertPos)
      const isRecent = (now - alert.timestamp) < (24 * 60 * 60) // Score still looks at 24h
      return distance <= scoreRadius && isRecent
    })

    console.log(`Filtering: ${this.filteredAlerts.length} alerts in 10km. Score: ${scoreAlerts.length} alerts in 1km.`)
    
    this.refreshMarkers(this.filteredAlerts)
    this.drawRadiusCircle(location, scoreRadius)
    this.renderSafetyScore(scoreAlerts)
  }

  drawRadiusCircle(center, radius) {
    if (this.currentRadiusCircle) {
      this.currentRadiusCircle.setMap(null)
    }

    this.currentRadiusCircle = new google.maps.Circle({
      strokeColor: "#6366f1",
      strokeOpacity: 0.8,
      strokeWeight: 2,
      fillColor: "#6366f1",
      fillOpacity: 0.1,
      map: this.map,
      center: center,
      radius: radius,
      clickable: false
    })
  }

  renderSafetyScore(alerts) {
    this.safetyScoreTarget.classList.remove("hidden")
    
    let score = 100
    
    alerts.forEach(alert => {
      if (alert.alert_type === 3) { // DANGER
        score -= 30
      } else if (alert.alert_type === 2) { // ALERT
        score -= 15
      }
    })

    score = Math.max(0, score)
    
    // Update UI
    this.scoreBarTarget.style.width = `${score}%`
    
    if (score > 80) {
      this.scoreValueTarget.innerText = "Seguro"
      this.scoreValueTarget.className = "text-sm font-bold text-green-600"
      this.scoreBarTarget.className = "h-full bg-green-500 transition-all duration-1000"
      this.scoreDescriptionTarget.innerText = "Região tranquila nas últimas 24h."
    } else if (score > 40) {
      this.scoreValueTarget.innerText = "Atenção"
      this.scoreValueTarget.className = "text-sm font-bold text-yellow-600"
      this.scoreBarTarget.className = "h-full bg-yellow-500 transition-all duration-1000"
      this.scoreDescriptionTarget.innerText = `${alerts.length} alertas detectados recentemente.`
    } else {
      this.scoreValueTarget.innerText = "Risco Alto"
      this.scoreValueTarget.className = "text-sm font-bold text-red-600"
      this.scoreBarTarget.className = "h-full bg-red-500 transition-all duration-1000"
      this.scoreDescriptionTarget.innerText = "Múltiplos alertas de perigo na região."
    }
  }

  refreshMarkers(alertsToDisplay = null) {
    this.clearMarkers()
    
    // Default to all alerts if no specific list is provided
    let alerts = alertsToDisplay || this.allAlerts
    
    const now = Math.floor(Date.now() / 1000)
    const maxAgeSeconds = 30 * 24 * 60 * 60 // 30 days

    // Temporal filter: Only show alerts created within the last 30 days
    alerts = alerts.filter(alert => {
      const ageInSeconds = now - alert.timestamp
      return ageInSeconds <= maxAgeSeconds
    })

    const groupedAlerts = this.groupAlertsByPosition(alerts)
    
    Object.keys(groupedAlerts).forEach(key => {
      const group = groupedAlerts[key]
      group.sort((a, b) => b.id - a.id)
      const marker = this.createGroupMarker(group)
      if (marker) this.markers.push(marker)
    })
  }

  createGroupMarker(alerts, options = {}) {
    const newestAlert = alerts[0]
    const position = { lat: parseFloat(newestAlert.latitude), lng: parseFloat(newestAlert.longitude) }
    const count = alerts.length
    
    // Temporal Relevance: Calculate opacity based on age (now 30 days / 720 hours)
    const now = Math.floor(Date.now() / 1000)
    const ageInHours = (now - newestAlert.timestamp) / 3600
    const maxAgeHours = 720 // 30 days
    const opacity = Math.max(0.4, 1 - (ageInHours / maxAgeHours))
    
    const marker = new google.maps.Marker({
      position: position,
      map: this.map,
      title: count > 1 ? `${count} alertas neste local` : newestAlert.title,
      icon: this.getGroupMarkerIcon(alerts, opacity),
      opacity: opacity,
      label: count > 1 ? {
        text: count.toString(),
        color: "#ffffff",
        fontWeight: "bold"
      } : null,
      ...options
    })

    marker.addListener("click", () => {
      this.handleGroupClick(alerts, position)
    })

    return marker
  }

  getGroupMarkerIcon(alerts, opacity = 1) {
    if (alerts.length === 1) {
      return this.getMarkerIcon(alerts[0].alert_type, opacity)
    }

    const maxType = Math.max(...alerts.map(a => a.alert_type))
    const colors = {
      1: "#10b981", // GOOD
      2: "#f59e0b", // ALERT
      3: "#ef4444"  // DANGER
    }
    const color = colors[maxType] || "#6b7280"

    return {
      path: google.maps.SymbolPath.CIRCLE,
      fillColor: color,
      fillOpacity: 0.9 * opacity,
      strokeWeight: 2,
      strokeColor: "#ffffff",
      strokeOpacity: opacity,
      scale: 15
    }
  }

  getMarkerIcon(type, opacity = 1) {
    const colors = {
      1: "#10b981", // GOOD
      2: "#f59e0b", // ALERT
      3: "#ef4444"  // DANGER
    }
    const color = colors[type] || "#6b7280"
    
    return {
      path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
      fillColor: color,
      fillOpacity: 0.9 * opacity,
      strokeWeight: 2,
      strokeColor: "#ffffff",
      strokeOpacity: opacity,
      scale: 10
    }
  }

  handleGroupClick(alerts, position) {
    if (alerts.length > 1) {
      const alertsContainer = document.getElementById("alerts")
      const detailsController = this.application.getControllerForElementAndIdentifier(alertsContainer, "alert-details")
      if (detailsController) {
        detailsController.openGroup(alerts)
      }
    } else {
      // Scroll to and open the single alert
      this.scrollToAlert(alerts[0].id)
    }
    
    if (this.map.getZoom() < 18) {
      this.map.setZoom(this.map.getZoom() + 1)
      this.map.panTo(position)
    }
  }

  scrollToAlert(alertId) {
    const alertElement = document.getElementById(`alert_${alertId}`)
    if (alertElement) {
      alertElement.scrollIntoView({ behavior: 'smooth', block: 'center' })
      const clickable = alertElement.querySelector('[data-action*="alert-details#open"]')
      if (clickable) {
        clickable.click()
      }
    }
  }

  addAlertMarker(alert) {
    if (!this.map || !this.markers) {
      if (!this.queuedAlerts) this.queuedAlerts = []
      this.queuedAlerts.push(alert)
      return
    }

    // Check if alert already exists to avoid duplicates
    if (this.allAlerts.find(a => a.id === alert.id)) {
      return
    }
    
    this.allAlerts.push(alert)
    
    // Re-apply current filtering state
    if (this.currentSearchLocation) {
      this.updateSafetyScore(this.currentSearchLocation)
    } else {
      this.refreshMarkers()
    }
    
    const position = { lat: parseFloat(alert.latitude), lng: parseFloat(alert.longitude) }
    
    // Only pan if it's the current user's alert
    if (this.hasCurrentUserIdValue && alert.user_id == this.currentUserIdValue) {
      this.map.panTo(position)
    }
    
    if (this.pickMarker) {
      this.pickMarker.setMap(null)
      this.pickMarker = null
    }
  }

  clearMarkers() {
    if (this.markers) {
      this.markers.forEach(m => m.setMap(null))
      this.markers = []
    }
  }

  getUserLocation() {
    if ("geolocation" in navigator) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const userPos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          }
          this.map.setCenter(userPos)
          this.addUserMarker(userPos)
        },
        () => {
          console.warn("Geolocation permission denied or error.")
          if (this.allAlerts.length > 0) {
            this.fitBounds()
          }
        }
      )
    } else if (this.allAlerts.length > 0) {
      this.fitBounds()
    }
  }

  addUserMarker(position) {
    if (this.userMarker) {
      this.userMarker.setPosition(position)
    } else {
      this.userMarker = new google.maps.Marker({
        position: position,
        map: this.map,
        icon: {
          path: google.maps.SymbolPath.CIRCLE,
          scale: 10,
          fillColor: "#4285F4",
          fillOpacity: 1,
          strokeWeight: 2,
          strokeColor: "#ffffff",
        },
        title: "Sua localização"
      })
    }
  }

  handleMapClick(latLng) {
    const lat = latLng.lat()
    const lng = latLng.lng()
    this.placePickMarker(latLng)
    this.dispatch("location-picked", { detail: { lat, lng } })
  }

  placePickMarker(latLng) {
    if (this.pickMarker) {
      this.pickMarker.setPosition(latLng)
    } else {
      this.pickMarker = new google.maps.Marker({
        position: latLng,
        map: this.map,
        draggable: true,
        animation: google.maps.Animation.DROP,
        icon: {
          path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
          scale: 8,
          fillColor: "#000000",
          fillOpacity: 0.8,
          strokeWeight: 1,
          strokeColor: "#ffffff",
        }
      })
      this.pickMarker.addListener("dragend", (event) => {
        this.handleMapClick(event.latLng)
      })
    }
  }

  fitBounds() {
    const bounds = new google.maps.LatLngBounds()
    this.markers.forEach(marker => bounds.extend(marker.getPosition()))
    if (!bounds.isEmpty()) {
      this.map.fitBounds(bounds)
    }
  }

  groupAlertsByPosition(alerts) {
    const groups = {}
    alerts.forEach(alert => {
      const key = `${parseFloat(alert.latitude).toFixed(5)},${parseFloat(alert.longitude).toFixed(5)}`
      if (!groups[key]) {
        groups[key] = []
      }
      groups[key].push(alert)
    })
    return groups
  }

  processQueuedAlerts() {
    if (this.queuedAlerts && this.queuedAlerts.length > 0) {
      this.queuedAlerts.forEach(alert => this.addAlertMarker(alert))
      this.queuedAlerts = []
    }
  }
}
