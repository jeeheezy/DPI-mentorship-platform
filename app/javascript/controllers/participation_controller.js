// Good!
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "role", "questions", "allRoleCards" ]
  assignRole(event) {
    const roleSelect = this.roleTarget
    const chosenRoleDiv = event.currentTarget
    const chosenRoleDivContent = chosenRoleDiv.querySelector(".role-text").textContent.toLowerCase()
    const roleCards = this.allRoleCardsTargets

    roleSelect.value = chosenRoleDivContent

    if (chosenRoleDivContent === "mentor") {
      this.questionsTarget.style.display = "block"
    } else {
      this.questionsTarget.style.display = "none"
    }

    roleCards.forEach(roleCard => {
      roleCard.classList.remove("chosen-role")
    })
    chosenRoleDiv.classList.add("chosen-role")
  }
}
