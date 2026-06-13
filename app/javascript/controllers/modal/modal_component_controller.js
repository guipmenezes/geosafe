import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]
  static values = { open: Boolean }

  connect() {
    if (this.openValue) {
      this.open()
    }
  }

  disconnect() {
    document.body.classList.remove("overflow-hidden")
  }

  open(event) {
    if (event) event.preventDefault()
    this.modalTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
  }

  close(event) {
    // Only block closing if it's a failed turbo submission
    if (event && event.type === "turbo:submit-end" && !event.detail.success) {
      return
    }

    this.modalTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }

  // Action to close from external sources
  forceClose() {
    this.close()
  }
}
