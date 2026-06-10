import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sheet", "handle", "content"]

  connect() {
    this.startY = 0
    this.currentY = 0
    this.isDragging = false
    this.state = "collapsed" // collapsed, partial, expanded
    
    this.setupInitialState()
  }

  setupInitialState() {
    // Mobile only initialization
    if (window.innerWidth >= 1024) return
    
    this.sheetTarget.style.transform = `translateY(calc(100% - 80px))`
  }

  toggle() {
    if (this.state === "collapsed") {
      this.expand()
    } else {
      this.collapse()
    }
  }

  expand() {
    this.state = "expanded"
    this.sheetTarget.style.transform = `translateY(0px)`
    this.sheetTarget.classList.add("duration-300")
  }

  collapse() {
    this.state = "collapsed"
    this.sheetTarget.style.transform = `translateY(calc(100% - 80px))`
    this.sheetTarget.classList.add("duration-300")
  }

  // Touch handlers for the "drag" feel
  touchStart(e) {
    this.startY = e.touches[0].clientY
    this.isDragging = true
    this.sheetTarget.classList.remove("duration-300")
  }

  touchMove(e) {
    if (!this.isDragging) return
    
    const deltaY = e.touches[0].clientY - this.startY
    if (this.state === "collapsed" && deltaY > 0) return
    
    const newY = this.state === "expanded" ? Math.max(0, deltaY) : Math.min(window.innerHeight - 80, window.innerHeight - 80 + deltaY)
    
    this.sheetTarget.style.transform = `translateY(${newY}px)`
  }

  touchEnd(e) {
    this.isDragging = false
    const endY = e.changedTouches[0].clientY
    const diff = this.startY - endY

    if (Math.abs(diff) > 50) {
      if (diff > 0) {
        this.expand()
      } else {
        this.collapse()
      }
    } else {
      // Snap back to current state
      this.state === "expanded" ? this.expand() : this.collapse()
    }
  }
}
