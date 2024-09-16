import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="case-contact-form"
export default class extends Controller {
  static targets = [
    'reimbursementForm',
    'wantDrivingReimbursement'
  ]

  connect () {
    this.setReimbursementFormVisibility()
  }

  clearExpenses = () => {
    this.element.querySelectorAll('.expense-amount-input').forEach(el => (el.value = ''))
    this.element.querySelectorAll('.expense-describe-input').forEach(el => (el.value = ''))
    this.element.querySelector('#case_contact_miles_driven').value = 0
  }

  clearMileage = () => {
    this.element.querySelector('#case_contact_miles_driven').value = 0
    this.element.querySelector('#case_contact_volunteer_address').value = ''
  }

  setReimbursementFormVisibility = () => {
    if (this.wantDrivingReimbursementTarget.checked) {
      this.reimbursementFormTarget.classList.remove('d-none')
    } else {
      this.clearExpenses()
      this.clearMileage()
      this.reimbursementFormTarget.classList.add('d-none')
    }
  }
}
