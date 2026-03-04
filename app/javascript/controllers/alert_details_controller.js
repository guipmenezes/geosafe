import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["title", "description", "location", "type", "name", "creator", "date", "modal"]

  open(event) {
    const data = event.currentTarget.dataset
    
    if (this.hasTitleTarget) this.titleTarget.textContent = data.alertTitle
    if (this.hasDescriptionTarget) this.descriptionTarget.textContent = data.alertDescription
    if (this.hasLocationTarget) this.locationTarget.textContent = data.alertLocation
    if (this.hasNameTarget) this.nameTarget.textContent = data.alertName
    if (this.hasCreatorTarget) this.creatorTarget.textContent = data.alertCreator
    if (this.hasDateTarget) this.dateTarget.textContent = data.alertDate
    
    // Type handling for colors
    if (this.hasTypeTarget) {
      this.typeTarget.textContent = data.alertTypeName
      this.typeTarget.className = `px-2.5 py-1 rounded-lg text-[10px] font-bold uppercase tracking-wider ${this.getTypeClass(data.alertType)}`
    }

    // This triggers the modal component inside the modal target
    // We look for the controller on the target itself or its first child
    const modalElement = this.modalTarget.querySelector('[data-controller="modal--modal-component"]') || this.modalTarget
    const modalController = this.application.getControllerForElementAndIdentifier(modalElement, "modal--modal-component")
    if (modalController) {
      modalController.open()
    }
  }

  getTypeClass(type) {
    switch (parseInt(type)) {
      case 1: return 'bg-green-50 text-green-700'
      case 2: return 'bg-yellow-50 text-yellow-700'
      case 3: return 'bg-red-50 text-red-700'
      default: return 'bg-grey100 text-grey700'
    }
  }
}
