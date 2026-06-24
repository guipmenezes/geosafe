import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "title", "description", "location", "type", "name", "creatorLevel", "date", 
    "modal", "singleView", "listView", "itemTemplate", "backButton"
  ]

  open(event) {
    const data = event.currentTarget.dataset
    this.isGroupMode = false
    this.showSingle(data)
  }

  showSingle(data) {
    if (this.hasSingleViewTarget) this.singleViewTarget.classList.remove("hidden")
    if (this.hasListViewTarget) this.listViewTarget.classList.add("hidden")
    
    if (this.hasBackButtonTarget) {
      if (this.isGroupMode) {
        this.backButtonTarget.classList.remove("hidden")
      } else {
        this.backButtonTarget.classList.add("hidden")
      }
    }

    if (this.hasTitleTarget) this.titleTarget.textContent = data.alertTitle
    if (this.hasDescriptionTarget) this.descriptionTarget.textContent = data.alertDescription
    if (this.hasLocationTarget) this.locationTarget.textContent = data.alertLocation
    if (this.hasNameTarget) this.nameTarget.textContent = data.alertName
    if (this.hasDateTarget) this.dateTarget.textContent = data.alertDate
    
    if (this.hasCreatorLevelTarget) {
      this.creatorLevelTarget.textContent = data.alertCreatorLevel
      this.creatorLevelTarget.className = `px-1.5 py-0.5 rounded text-[9px] font-bold uppercase tracking-wider ${data.alertCreatorBadgeColor}`
    }
    
    // Type handling for colors
    if (this.hasTypeTarget) {
      this.typeTarget.textContent = data.alertTypeName
      this.typeTarget.className = `px-2.5 py-1 rounded-lg text-[10px] font-bold uppercase tracking-wider ${this.getTypeClass(data.alertType)}`
    }

    this.openModal()
  }

  openGroup(alerts) {
    this.isGroupMode = true
    if (this.hasSingleViewTarget) this.singleViewTarget.classList.add("hidden")
    if (this.hasListViewTarget) {
      this.listViewTarget.classList.remove("hidden")
      this.listViewTarget.innerHTML = ""
      
      alerts.forEach(alert => {
        const clone = this.itemTemplateTarget.content.cloneNode(true)
        
        clone.querySelector(".js-name").textContent = alert.alert_name
        clone.querySelector(".js-title").textContent = alert.title
        clone.querySelector(".js-description").textContent = alert.description
        clone.querySelector(".js-location").textContent = alert.location
        clone.querySelector(".js-date").textContent = alert.date
        
        const typeBadge = clone.querySelector(".js-type-badge")
        typeBadge.textContent = alert.alert_type_name
        typeBadge.className = `js-type-badge px-2.5 py-1 rounded-lg text-[10px] font-bold uppercase tracking-wider ${this.getTypeClass(alert.alert_type)}`
        
        // Make item clickable to show details
        const item = clone.querySelector("div")
        item.addEventListener("click", () => {
          this.showSingle({
            alertTitle: alert.title,
            alertDescription: alert.description,
            alertLocation: alert.location,
            alertName: alert.alert_name,
            alertTypeName: alert.alert_type_name,
            alertType: alert.alert_type,
            alertCreatorLevel: alert.creator_level,
            alertCreatorBadgeColor: alert.creator_badge_color,
            alertDate: alert.date
          })
        })
        
        this.listViewTarget.appendChild(clone)
      })
    }

    this.openModal()
  }

  backToList() {
    if (this.hasSingleViewTarget) this.singleViewTarget.classList.add("hidden")
    if (this.hasListViewTarget) this.listViewTarget.classList.remove("hidden")
  }

  openModal() {
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
