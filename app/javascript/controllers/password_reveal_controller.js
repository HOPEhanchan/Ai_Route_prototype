import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["display"]
  static values = { plain: String }

  show() {
    this.displayTarget.textContent = this.plainValue || ""
  }

  hide() {
    this.displayTarget.textContent = "********"
  }
}
