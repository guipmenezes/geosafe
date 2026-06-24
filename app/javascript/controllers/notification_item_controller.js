import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    alertId: String,
    url: String
  }

  handleClick(event) {
    const mapElement = document.querySelector('[data-controller~="map"]')
    if (mapElement) {
      // We are on the homepage, open the alert dynamically without reloading
      event.preventDefault()

      // Close the dropdown if it is inside one
      const dropdownElement = this.element.closest('[data-controller="dropdown"]')
      if (dropdownElement) {
        const dropdownController = this.application.getControllerForElementAndIdentifier(dropdownElement, "dropdown")
        if (dropdownController) {
          dropdownController.menuTarget.classList.add("hidden")
          dropdownController.element.style.zIndex = ""
        }
      }

      // Find the map controller and pan/open the alert
      const mapController = this.application.getControllerForElementAndIdentifier(mapElement, "map")
      if (mapController) {
        const alertId = this.alertIdValue
        const alert = mapController.allAlerts.find(a => a.id.toString() === alertId.toString())
        if (alert) {
          const position = { lat: parseFloat(alert.latitude), lng: parseFloat(alert.longitude) }
          mapController.map.setCenter(position)
          mapController.map.setZoom(17)
          mapController.updateSafetyScore(new google.maps.LatLng(alert.latitude, alert.longitude))
          setTimeout(() => {
            mapController.scrollToAlert(alertId)
          }, 300)
        }
      }

      // Mark the notification as read in the background
      if (this.hasUrlValue) {
        fetch(this.urlValue, {
          method: "PATCH",
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
            "Accept": "text/vnd.turbo-stream.html"
          }
        }).then(response => {
          if (response.ok) {
            return response.text()
          }
        }).then(html => {
          if (html && window.Turbo) {
            window.Turbo.renderStreamMessage(html)
          }
        }).catch(err => console.error("Error marking notification as read:", err))
      }
    }
  }
}
