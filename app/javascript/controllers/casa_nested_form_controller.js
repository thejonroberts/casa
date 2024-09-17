// https://www.stimulus-components.com/docs/stimulus-rails-nested-form/
import NestedForm from '@stimulus-components/rails-nested-form'

// NOTE: For some reason, using the base nested-form for multiple nested attribute forms in case_contacts
// did not work. This was added to fix that, even though it appears to add no functionality.
// It can be used in place of nested-form, and is particularly useful for debugging nested form events.
// Connects to data-controller="casa-nested-form"
export default class extends NestedForm {
  connect () {
    super.connect()
  }

  add = (event) => {
    super.add(event)
  }

  remove = (event) => {
    super.remove(event)
  }
}
