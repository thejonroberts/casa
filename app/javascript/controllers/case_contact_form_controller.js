import { Controller } from '@hotwired/stimulus'
import { template } from 'lodash'
// import bootstrap from 'bootstrap'

// Connects to data-controller="case-contact-form"
export default class extends Controller {
  static targets = [
    'expenseDestroy',
    'milesDriven',
    'volunteerAddress',
    'reimbursementForm',
    'topicDetails',
    'topicDetailsTemplate',
    'topicSelect',
    'wantDrivingReimbursement'
  ]

  connect () {
    this.setReimbursementFormVisibility()
    this.topicDetailsTemplate = template(this.topicDetailsTemplateTarget.innerHTML)
    // $('[data-toggle="tooltip"]').tooltip({selector: '.details-tooltip'})
    // $('.details-tooltip').tooltip({selector: '.details-tooltip'})
    this.onTopicSelect()
  }

  clearExpenses = () => {
    // mark as _destroy: true. autosave has already created the records.
    // if autosaved again, nested form controller will remove destroy: true items
    // if the form is submitted, expense will be destroyed.
    this.expenseDestroyTargets.forEach(el => (el.value = '1'))
  }

  clearMileage = () => {
    this.milesDrivenTarget.value = 0
    this.volunteerAddressTarget.value = ''
  }

  onTopicSelect = (e) => {
    // get rid of existing tooltips?
    this.topicSelectTargets.forEach(select => {
      const details = select.querySelector(`option[value="${select.value}"]`).dataset.details
      select.nextElementSibling.querySelector('i').setAttribute('data-bs-title', details)
    })
    const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]')
    tooltipTriggerList.forEach(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl))
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
