// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Registrar o Service Worker para o PWA
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/service-worker.js").then(
      (registration) => {
        console.log("ServiceWorker registrado com sucesso com o escopo: ", registration.scope);
      },
      (err) => {
        console.log("Falha no registro do ServiceWorker: ", err);
      }
    );
  });
}
