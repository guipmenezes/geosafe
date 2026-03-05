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
    if (value === "2") { // STREET
      this.getLocation()
    } else {
      this.clearLocation()
    }
  }

  getLocation() {
    if ("geolocation" in navigator) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          this.latitudeTarget.value = position.coords.latitude
          this.longitudeTarget.value = position.coords.longitude
          
          if (this.hasLocationTarget && !this.locationTarget.value) {
            this.locationTarget.value = "Minha localização atual"
          }
        },
        (error) => {
          console.error("Error getting location:", error)
          alert("Não foi possível obter a sua localização. Por favor, verifique as permissões do seu navegador.")
        },
        {
          enableHighAccuracy: true,
          timeout: 10000,
          maximumAge: 0
        }
      )
    } else {
      alert("Geolocalização não é suportada pelo seu navegador.")
    }
  }

  clearLocation() {
    if (this.hasLatitudeTarget) this.latitudeTarget.value = ""
    if (this.hasLongitudeTarget) this.longitudeTarget.value = ""
  }
}
