import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "icon", "toggleButton" ]

  toggleIcon() {
    const icon = this.iconTarget.classList
    const currentState = this.toggleButtonTarget.classList
    if (currentState.contains("collapsed")) {
      icon.add("fa-angle-up")
      icon.remove("fa-angle-down")
    } else {
      icon.add("fa-angle-down")
      icon.remove("fa-angle-up")
    }
  }
}
