import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  show() {
    this.inputTarget.type = "text"
  }

  hide() {
    this.inputTarget.type = "password"
  }
}
