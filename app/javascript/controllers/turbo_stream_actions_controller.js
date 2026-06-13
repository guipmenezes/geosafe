import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  connect() {
    const url = this.element.getAttribute("url")
    const action = this.element.getAttribute("action")

    // Find all open modals and close them
    document.querySelectorAll('[data-controller="modal--modal-component"]').forEach(modalEl => {
      const controller = this.application.getControllerForElementAndIdentifier(modalEl, "modal--modal-component")
      if (controller) controller.forceClose()
    })

    if (url) {
      Turbo.visit(url)
    }
  }
}
