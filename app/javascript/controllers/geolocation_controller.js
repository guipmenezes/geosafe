import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["latitude", "longitude", "location", "type"]

  connect() {
    this.checkCurrentType()
  }

  checkCurrentType() {
    if (this.hasTypeTarget && this.typeTarget.value === "2") {
      this.getLocation()
    }
  }

  handleTypeChange(event) {
    const value = event.target.value
    this.manuallyPicked = false
    if (value === "2") { // STREET
      this.getLocation()
    } else {
      this.clearLocation()
    }
  }

  handleLocationPicked(event) {
    this.manuallyPicked = true
    const { lat, lng } = event.detail
    
    if (this.hasLatitudeTarget) this.latitudeTarget.value = lat
    if (this.hasLongitudeTarget) this.longitudeTarget.value = lng
    
    this.fetchAddress(lat, lng)

    if (this.hasTypeTarget) {
      this.typeTarget.value = "2" // STREET
      
      // Update the select UI label if it's a select component
      const selectContainer = this.typeTarget.closest('[data-controller="select"]')
      if (selectContainer) {
        const label = selectContainer.querySelector('[data-select-target="label"]')
        if (label) {
          label.innerText = "Na Rua"
        }
      }
    }
  }

  fetchAddress(lat, lng) {
    if (this.hasLocationTarget) {
      this.locationTarget.value = "Buscando endereço..."
    }

    fetch(`/addresses/reverse_geocode?lat=${lat}&lng=${lng}`)
      .then(response => response.json())
      .then(data => {
        if (this.hasLocationTarget) {
          this.locationTarget.value = data.address || `Coordenadas: ${lat.toFixed(6)}, ${lng.toFixed(6)}`
        }
      })
      .catch(() => {
        if (this.hasLocationTarget) {
          this.locationTarget.value = `Coordenadas: ${lat.toFixed(6)}, ${lng.toFixed(6)}`
        }
      })
  }

  getLocation() {
    if ("geolocation" in navigator) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          if (this.manuallyPicked) return

          const lat = position.coords.latitude
          const lng = position.coords.longitude

          this.latitudeTarget.value = lat
          this.longitudeTarget.value = lng
          
          this.fetchAddress(lat, lng)
        },
        (error) => {
          console.error("Error getting location:", error)
          // Don't alert here to avoid annoying the user if they want to pick on map instead
        },
        {
          enableHighAccuracy: true,
          timeout: 10000,
          maximumAge: 0
        }
      )
    }
  }

  clearLocation() {
    if (this.hasLatitudeTarget) this.latitudeTarget.value = ""
    if (this.hasLongitudeTarget) this.longitudeTarget.value = ""
  }
}
