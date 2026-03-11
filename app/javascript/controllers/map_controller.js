import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = {
    alerts: Array
  }

  connect() {
    this.initMap()
    this.alertCreatedHandler = (event) => {
      this.addAlertMarker(event.detail.alert)
    }
    window.addEventListener("alert:created", this.alertCreatedHandler)
  }

  disconnect() {
    window.removeEventListener("alert:created", this.alertCreatedHandler)
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

    this.addMarkers()
    this.getUserLocation()
    
    this.map.addListener("click", (event) => {
      this.handleMapClick(event.latLng)
    })
  }

  addAlertMarker(alert) {
    if (!alert.latitude || !alert.longitude) return

    const position = { lat: parseFloat(alert.latitude), lng: parseFloat(alert.longitude) }
    const marker = new google.maps.Marker({
      position: position,
      map: this.map,
      title: alert.title,
      icon: this.getMarkerIcon(alert.alert_type),
      animation: google.maps.Animation.DROP
    })

    marker.addListener("click", () => {
      const alertElement = document.getElementById(`alert_${alert.id}`)
      if (alertElement) {
        alertElement.click()
      }
    })

    this.markers.push(marker)
    this.map.panTo(position)
    
    // Clear the pick marker if it exists
    if (this.pickMarker) {
      this.pickMarker.setMap(null)
      this.pickMarker = null
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
          if (this.alertsValue.length > 0) {
            this.fitBounds()
          }
        }
      )
    } else {
      if (this.alertsValue.length > 0) {
        this.fitBounds()
      }
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

    // Dispatch event to update the form
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

  addMarkers() {
    this.markers = this.alertsValue.map(alert => {
      if (!alert.latitude || !alert.longitude) return null

      const marker = new google.maps.Marker({
        position: { lat: parseFloat(alert.latitude), lng: parseFloat(alert.longitude) },
        map: this.map,
        title: alert.title,
        icon: this.getMarkerIcon(alert.alert_type)
      })

      marker.addListener("click", () => {
        const alertElement = document.getElementById(`alert_${alert.id}`)
        if (alertElement) {
          alertElement.click()
        }
      })

      return marker
    }).filter(m => m !== null)
  }

  fitBounds() {
    const bounds = new google.maps.LatLngBounds()
    this.markers.forEach(marker => bounds.extend(marker.getPosition()))
    this.map.fitBounds(bounds)
  }

  getMarkerIcon(type) {
    const colors = {
      1: "#10b981", // GOOD (green)
      2: "#f59e0b", // ALERT (yellow)
      3: "#ef4444"  // DANGER (red)
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
}
