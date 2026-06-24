import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { data: Object }

  connect() {
    if (this.hasDataValue) {
      window.dispatchEvent(new CustomEvent("alert:created", {
        detail: { alert: this.dataValue }
      }))
    }
  }
}
