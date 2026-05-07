import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
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
      this.placePickMarker(new google.maps.LatLng(lat, lng))
      this.map.panTo({ lat, lng })
    }
    
    window.addEventListener("alert:created", this.alertCreatedHandler)
    window.addEventListener("map:move-marker", this.moveMarkerHandler)
  }

  disconnect() {
    window.removeEventListener("alert:created", this.alertCreatedHandler)
    window.removeEventListener("map:move-marker", this.moveMarkerHandler)
  }

  initMap() {
    if (typeof google === 'undefined') {
      setTimeout(() => this.initMap(), 100)
      return
    }

    const defaultCenter = { lat: -15.7942, lng: -47.8822 } // Brasília
    
    this.map = new google.maps.Map(this.containerTarget, {
      center: defaultCenter,
      zoom: 15,
      mapId: 'GEOSAFE_MAP_ID'
    })

    this.markers = []
    this.refreshMarkers()
    this.getUserLocation()
    this.processQueuedAlerts()
    
    this.map.addListener("click", (event) => {
      this.handleMapClick(event.latLng)
    })
  }

  processQueuedAlerts() {
    if (this.queuedAlerts && this.queuedAlerts.length > 0) {
      console.log(`Processing ${this.queuedAlerts.length} queued alerts`)
      this.queuedAlerts.forEach(alert => this.addAlertMarker(alert))
      this.queuedAlerts = []
    }
  }

  refreshMarkers() {
    this.clearMarkers()
    
    const groupedAlerts = this.groupAlertsByPosition(this.allAlerts)
    
    Object.keys(groupedAlerts).forEach(key => {
      const group = groupedAlerts[key]
      // Sort group by ID descending to have newest first
      group.sort((a, b) => b.id - a.id)
      const marker = this.createGroupMarker(group)
      if (marker) this.markers.push(marker)
    })
  }

  groupAlertsByPosition(alerts) {
    const groups = {}
    alerts.forEach(alert => {
      if (!alert.latitude || !alert.longitude) return
      const key = `${parseFloat(alert.latitude).toFixed(6)},${parseFloat(alert.longitude).toFixed(6)}`
      if (!groups[key]) groups[key] = []
      groups[key].push(alert)
    })
    return groups
  }

  createGroupMarker(alerts, options = {}) {
    const newestAlert = alerts[0]
    const position = { lat: parseFloat(newestAlert.latitude), lng: parseFloat(newestAlert.longitude) }
    const count = alerts.length
    
    const marker = new google.maps.Marker({
      position: position,
      map: this.map,
      title: count > 1 ? `${count} alertas neste local` : newestAlert.title,
      icon: this.getGroupMarkerIcon(alerts),
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

  getGroupMarkerIcon(alerts) {
    if (alerts.length === 1) {
      return this.getMarkerIcon(alerts[0].alert_type)
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
      fillOpacity: 0.9,
      strokeWeight: 2,
      strokeColor: "#ffffff",
      scale: 15
    }
  }

  getMarkerIcon(type) {
    const colors = {
      1: "#10b981", // GOOD
      2: "#f59e0b", // ALERT
      3: "#ef4444"  // DANGER
    }
    const color = colors[type] || "#6b7280"
    
    return {
      path: google.maps.SymbolPath.BACKWARD_CLOSED_ARROW,
      fillColor: color,
      fillOpacity: 0.9,
      strokeWeight: 2,
      strokeColor: "#ffffff",
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
    this.refreshMarkers()
    
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
}
