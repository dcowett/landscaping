import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "map"]

  connect() {
    console.log("Map controller connected ✅")
    this.map = null
    this.marker = null
  }
    
  open(event) {
    event.preventDefault()

    const lat = parseFloat(event.currentTarget.dataset.mapLat)
    const lng = parseFloat(event.currentTarget.dataset.mapLng)
    const address = event.currentTarget.dataset.mapAddress || "Location"

    if (isNaN(lat) || isNaN(lng)) {
      alert("No coordinates available")
      return
    }

    this.modalTarget.classList.remove("hidden")
    document.getElementById("map-title").innerText = address

    setTimeout(() => {
      if (!this.map) {
        this.map = L.map(this.mapTarget, {
          zoomControl: true,
          scrollWheelZoom: true,
          dragging: true,
          doubleClickZoom: true
        }).setView([lat, lng], 15)

        L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
          attribution: "© OpenStreetMap",
          maxZoom: 19
        }).addTo(this.map)

        this.marker = L.marker([lat, lng]).addTo(this.map)
      }

      this.map.invalidateSize()           // must come before setView
      this.map.setView([lat, lng], 15)
      this.marker.setLatLng([lat, lng])
      this.marker.bindPopup(`<strong>${address}</strong>`).openPopup()
    }, 150)  // slight bump to ensure modal is fully visible before Leaflet measures it
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  close() {
    this.modalTarget.classList.add("hidden")
  }
}