import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sheet", "handle", "content"]

  connect() {
    this.startY = 0
    this.isDragging = false
    this.state = "collapsed" // collapsed, expanded
    
    this.setupInitialState()
  }

  setupInitialState() {
    if (window.innerWidth >= 1024) {
      this.sheetTarget.style.transform = ''
      return
    }
    
    this.calculateCollapsedY()
    this.collapse()
    
    // Handle resize events to recalculate heights
    this.resizeHandler = () => {
      if (window.innerWidth >= 1024) {
        this.sheetTarget.style.transform = ''
      } else {
        this.calculateCollapsedY()
        this.state === "expanded" ? this.expand() : this.collapse()
      }
    }
    window.addEventListener('resize', this.resizeHandler)
  }

  disconnect() {
    if (this.resizeHandler) {
      window.removeEventListener('resize', this.resizeHandler)
    }
  }

  calculateCollapsedY() {
    // 80px of the sheet is visible when collapsed.
    const visibleHeight = 80
    this.collapsedY = this.sheetTarget.offsetHeight - visibleHeight
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
    this.sheetTarget.classList.add("transition-transform", "duration-300", "ease-out")
  }

  collapse() {
    this.state = "collapsed"
    this.calculateCollapsedY()
    this.sheetTarget.style.transform = `translateY(${this.collapsedY}px)`
    this.sheetTarget.classList.add("transition-transform", "duration-300", "ease-out")
  }

  touchStart(e) {
    if (window.innerWidth >= 1024) return
    this.startY = e.touches[0].clientY
    this.startTimeStamp = e.timeStamp
    this.isDragging = true
    this.calculateCollapsedY()
    
    // Remove transition for 1-to-1 tracking
    this.sheetTarget.classList.remove("transition-transform", "duration-300", "ease-out")
    
    this.startTransformY = this.state === "expanded" ? 0 : this.collapsedY
  }

  touchMove(e) {
    if (!this.isDragging || window.innerWidth >= 1024) return
    
    const deltaY = e.touches[0].clientY - this.startY
    let newY = this.startTransformY + deltaY
    
    // Add resistance (rubber band effect) if pulling up past the top
    if (newY < 0) {
      newY = newY * 0.3 
    } else {
      // Bound the translation to not go below the collapsed state
      newY = Math.min(newY, this.collapsedY)
    }
    
    this.sheetTarget.style.transform = `translateY(${newY}px)`
  }

  touchEnd(e) {
    if (!this.isDragging || window.innerWidth >= 1024) return
    this.isDragging = false
    
    const deltaY = e.changedTouches[0].clientY - this.startY
    const deltaTime = e.timeStamp - this.startTimeStamp
    const velocity = deltaY / (deltaTime || 1)
    
    // Restore transitions for the snap animation
    this.sheetTarget.classList.add("transition-transform", "duration-300", "ease-out")

    if (this.state === "expanded") {
      // If we drag down enough or fast enough, collapse it
      if (deltaY > 50 || velocity > 0.5) {
        this.collapse()
      } else {
        this.expand() // Snap back up
      }
    } else {
      // If we drag up enough or fast enough, expand it
      if (deltaY < -50 || velocity < -0.5) {
        this.expand()
      } else {
        this.collapse() // Snap back down
      }
    }
  }
}
