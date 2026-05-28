import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "confirmation", "length", "uppercase", "lowercase", "number", "special", "match"]

  connect() {
    this.validate()
  }

  validate() {
    const password = this.passwordTarget.value
    const confirmation = this.confirmationTarget.value

    // Rules
    const rules = {
      length: password.length >= 12,
      uppercase: /[A-Z]/.test(password),
      lowercase: /[a-z]/.test(password),
      number: /[0-9]/.test(password),
      special: /[!@#$%^&*(),.?":{}|<>]/.test(password)
    }

    // Update rule indicators
    this.updateRule(this.lengthTarget, rules.length)
    this.updateRule(this.uppercaseTarget, rules.uppercase)
    this.updateRule(this.lowercaseTarget, rules.lowercase)
    this.updateRule(this.numberTarget, rules.number)
    this.updateRule(this.specialTarget, rules.special)

    // Check match
    if (confirmation.length > 0) {
      this.updateRule(this.matchTarget, password === confirmation && password.length > 0)
    } else {
      this.resetRule(this.matchTarget)
    }
  }

  updateRule(element, isValid) {
    const icon = element.querySelector('.rule-icon')
    const text = element.querySelector('.rule-text')

    if (isValid) {
      element.classList.remove('text-red-500', 'text-grey500')
      element.classList.add('text-green-600')
      if (icon) icon.innerHTML = '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>'
    } else {
      element.classList.remove('text-green-600', 'text-grey500')
      element.classList.add('text-red-500')
      if (icon) icon.innerHTML = '<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M6 18L18 6M6 6l12 12"></path></svg>'
    }
  }

  resetRule(element) {
    const icon = element.querySelector('.rule-icon')
    element.classList.remove('text-green-600', 'text-red-500')
    element.classList.add('text-grey500')
    if (icon) icon.innerHTML = '<div class="w-4 h-4 rounded-full border-2 border-grey300"></div>'
  }
}
