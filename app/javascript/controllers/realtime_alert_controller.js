import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { data: Object }

  connect() {
    // Only dispatch once per element to prevent infinite loops when elements are moved/sorted in the DOM
    if (this.hasDataValue && !this.element.dataset.alertDispatched) {
      this.element.dataset.alertDispatched = "true"
      window.dispatchEvent(new CustomEvent("alert:created", {
        detail: { alert: this.dataValue }
      }))
    }
  }
}
