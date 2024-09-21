import { Controller } from '@hotwired/stimulus'

// Connects to data-controller="case-contact-form"
export default class extends Controller {
  static targets = [
    'expenseAmount',
    'expenseDescribe',
    'expenseDestroy',
    'milesDriven',
    'volunteerAddress',
    'reimbursementForm',
    'wantDrivingReimbursement'
  ]

  connect () {
    this.setReimbursementFormVisibility()
  }

  clearExpenses = () => {
    // mark for destruction. autosave has already created the record.
    // if submitted, it will be destroyed. if autosaved, it will be removed by nested form controller.
    this.expenseDestroyTargets.forEach(el => (el.value = '1'))
  }

  clearMileage = () => {
    this.milesDrivenTarget.value = 0
    this.volunteerAddressTarget.value = ''
  }

  setReimbursementFormVisibility = () => {
    if (this.wantDrivingReimbursementTarget.checked) {
      this.reimbursementFormTarget.classList.remove('d-none')
      this.expenseDestroyTargets.forEach(el => (el.value = '0'))
    } else {
      this.clearExpenses()
      this.clearMileage()
      this.reimbursementFormTarget.classList.add('d-none')
    }
  }
}
