import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu", "button" ]

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }
}
