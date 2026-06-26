import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { vapidPublicKey: String }

  connect() {
    if (!("serviceWorker" in navigator) || !("PushManager" in window)) {
      this.element.classList.add("hidden")
      return
    }

    this.checkPermission()
  }

  checkPermission() {
    if (Notification.permission === "granted") {
      this.element.classList.add("hidden")
      this.subscribe() // Assegura que está inscrito
    } else if (Notification.permission === "default") {
      // Exibe o prompt se não foi concedido nem bloqueado
      this.element.classList.remove("hidden")
    } else {
      // "denied"
      this.element.classList.add("hidden")
    }
  }

  requestPermission(event) {
    if (event) event.preventDefault()

    Notification.requestPermission().then((permission) => {
      if (permission === "granted") {
        this.element.classList.add("hidden")
        this.subscribe()
      }
    })
  }

  subscribe() {
    navigator.serviceWorker.ready.then((serviceWorkerRegistration) => {
      serviceWorkerRegistration.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: this.urlBase64ToUint8Array(this.vapidPublicKeyValue)
      }).then((subscription) => {
        this.saveSubscription(subscription)
      }).catch((e) => {
        if (Notification.permission === 'default') {
          console.warn('Permissão cancelada pelo usuário.')
        } else {
          console.error('Falha ao inscrever no PushManager', e)
        }
      })
    })
  }

  saveSubscription(subscription) {
    const subJSON = subscription.toJSON()
    
    fetch("/push_subscriptions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({
        push_subscription: {
          endpoint: subJSON.endpoint,
          p256dh: subJSON.keys.p256dh,
          auth: subJSON.keys.auth,
          user_agent: navigator.userAgent
        }
      })
    })
  }

  urlBase64ToUint8Array(base64String) {
    const padding = '='.repeat((4 - base64String.length % 4) % 4)
    const base64 = (base64String + padding)
      .replace(/\-/g, '+')
      .replace(/_/g, '/')

    const rawData = window.atob(base64)
    const outputArray = new Uint8Array(rawData.length)

    for (let i = 0; i < rawData.length; ++i) {
      outputArray[i] = rawData.charCodeAt(i)
    }
    return outputArray
  }
}
