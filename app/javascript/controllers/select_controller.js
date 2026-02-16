import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "label", "input", "option"]

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

  select(event) {
    const value = event.currentTarget.dataset.value
    const label = event.currentTarget.dataset.label

    // Update hidden input
    this.inputTarget.value = value

    // Update display label
    this.labelTarget.innerText = label

    // Close menu
    this.menuTarget.classList.add("hidden")

    // Update active state in UI
    this.optionTargets.forEach(el => {
      el.classList.remove("bg-primary50", "text-primary700")
      if (el === event.currentTarget) {
        el.classList.add("bg-primary50", "text-primary700")
      }
    })

    // Trigger change event for form listeners
    this.inputTarget.dispatchEvent(new Event("change"))
  }

  close(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
