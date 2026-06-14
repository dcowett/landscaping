import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "map"]

  connect() {
    console.log("Map controller connected ✅")
    this.map = null
    this.marker = null
    }
    
  open(event) {
    console.log("CLICK WORKED ✅")
    event.preventDefault()

    const lat = parseFloat(event.currentTarget.dataset.mapLat)
    const lng = parseFloat(event.currentTarget.dataset.mapLng)
    const address = event.currentTarget.dataset.mapAddress || "Location"

    if (isNaN(lat) || isNaN(lng)) {
      alert("No coordinates available")
      return
    }

    // ✅ This will now ALWAYS exist
    this.modalTarget.classList.remove("hidden")

    document.getElementById("map-title").innerText = address

    setTimeout(() => {
      if (!this.map) {
        this.map = L.map(this.mapTarget).setView([lat, lng], 15)

        L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
          attribution: "© OpenStreetMap"
        }).addTo(this.map)

        this.marker = L.marker([lat, lng]).addTo(this.map)
      }

      this.map.setView([lat, lng], 15)
      this.marker.setLatLng([lat, lng])

      this.marker
        .bindPopup(`<strong>${address}</strong>`)
        .openPopup()

      this.map.invalidateSize()
    }, 100)
  }

  close() {
    this.modalTarget.classList.add("hidden")
  }
}