import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu" ]

  connect() {
    this.close = this.close.bind(this)
    document.addEventListener("click", this.close)
  }

  disconnect() {
    document.removeEventListener("click", this.close)
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  close(event) {
    if (this.element.contains(event.target)) {
      return
    }

    this.menuTarget.classList.add("hidden")
  }
}
