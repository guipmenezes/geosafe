import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.backgroundHtml = this.backgroundHTML()
  }

  backgroundHTML() {
    return `<div id="modal-background" class="fixed top-0 left-0 w-full h-full" style="background-color: rgba(0,0,0,0.5); z-index: 40;" data-action="click->modal--modal-component#close"></div>`
  }

  open(event) {
    event.preventDefault();
    const modal = this.modalTarget;
    modal.classList.remove("hidden");
    document.body.insertAdjacentHTML('beforeend', this.backgroundHtml)
    document.body.classList.add("overflow-hidden");
  }

  close(event) {
    if (event && event.type === "turbo:submit-end" && !event.detail.success) {
      return;
    }

    this.modalTarget.classList.add("hidden");
    const background = document.getElementById("modal-background")
    if (background) {
      background.remove()
    }
    document.body.classList.remove("overflow-hidden");
  }
}
