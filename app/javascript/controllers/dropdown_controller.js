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
    const isHidden = this.menuTarget.classList.toggle("hidden")
    if (isHidden) {
      this.element.style.zIndex = ""
    } else {
      this.element.style.zIndex = "9999"
    }
  }

  close(event) {
    if (this.element.contains(event.target)) {
      return
    }

    this.menuTarget.classList.add("hidden")
    this.element.style.zIndex = ""
  }
}
