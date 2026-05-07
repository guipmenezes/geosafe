import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { alert: Object }

  connect() {
    if (this.hasAlertValue) {
      window.dispatchEvent(new CustomEvent("alert:created", {
        detail: { alert: this.alertValue }
      }))
    }
  }
}
