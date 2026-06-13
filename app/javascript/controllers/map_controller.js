import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  open(event) {
    event.preventDefault()

    const lat = parseFloat(event.currentTarget.dataset.mapLat)
    const lng = parseFloat(event.currentTarget.dataset.mapLng)

    if (isNaN(lat) || isNaN(lng)) {
      alert("No coordinates available for this property")
      return
    }

    const address = event.currentTarget.dataset.mapAddress

    const modal = document.getElementById("map-modal")
    const mapEl = document.getElementById("map")

    modal.classList.remove("hidden")
    document.getElementById("map-title").innerText = address

    // reset map container
    mapEl.innerHTML = ""

    const map = L.map("map").setView([lat, lng], 15)

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: "&copy; OpenStreetMap"
    }).addTo(map)

    L.marker([lat, lng])
      .addTo(map)
      .bindPopup(`<strong>${address}</strong>`)
      .openPopup()

    setTimeout(() => {
      map.invalidateSize()
    }, 100)
  }

  close() {
    document.getElementById("map-modal").classList.add("hidden")
  }
}