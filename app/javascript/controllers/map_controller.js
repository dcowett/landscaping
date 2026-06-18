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
      delete L.Icon.Default.prototype._getIconUrl
      L.Icon.Default.mergeOptions({
        iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
        iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
        shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
      })

      if (!this.map) {
        this.map = L.map(this.mapTarget, {
          zoomControl: true,
          scrollWheelZoom: true,
          dragging: true,
          doubleClickZoom: true
        }).setView([lat, lng], 17)

        L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
          attribution: "© OpenStreetMap",
          maxZoom: 19
        }).addTo(this.map)

        this.marker = L.marker([lat, lng]).addTo(this.map)
      }

      this.map.invalidateSize()
      this.map.setView([lat, lng], 17)
      this.marker.setLatLng([lat, lng])
      this.marker.bindPopup(`<strong>${address}</strong>`).openPopup()
    }, 150)
  }

  close(event) {
    if (event.target === event.currentTarget) {
      this.modalTarget.classList.add("hidden")
    }
  }

  stopPropagation(event) {
    event.stopPropagation()
  }
}