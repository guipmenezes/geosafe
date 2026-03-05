import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = {
    alerts: Array
  }

  connect() {
    this.initMap()
  }

  initMap() {
    if (typeof google === 'undefined') {
      // If google maps hasn't loaded yet, try again in 100ms
      setTimeout(() => this.initMap(), 100)
      return
    }

    const defaultCenter = { lat: -15.7942, lng: -47.8822 } // Brasília
    
    this.map = new google.maps.Map(this.containerTarget, {
      center: defaultCenter,
      zoom: 12,
      mapId: 'GEOSAFE_MAP_ID' // Optional
    })

    this.addMarkers()
    
    if (this.alertsValue.length > 0) {
      this.fitBounds()
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
        // Find the alert card and trigger it if needed
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
    // Custom marker colors based on alert type
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
