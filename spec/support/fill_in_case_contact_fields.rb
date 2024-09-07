module FillInCaseContactFields
  DETAILS_ID = "#contact-form-details"
  NOTES_ID = "#contact-form-notes"
  TOPIC_VALUE_CLASS = ".contact-topic-answer-input"
  TOPIC_SELECT_CLASS = ".contact-topic-id-select"
  REIMBURSEMENT_ID = "#contact-form-reimbursement"
  EXPENSE_AMOUNT_CLASS = ".expense-amount-input"
  EXPENSE_DESCRIBE_CLASS = ".expense-describe-input"

  def fill_expense_fields(amount, describe, index: nil)
    within REIMBURSEMENT_ID do
      amount_field = index.present? ? all(EXPENSE_AMOUNT_CLASS)[index] : all(EXPENSE_AMOUNT_CLASS).last
      describe_field = index.present? ? all(EXPENSE_DESCRIBE_CLASS)[index] : all(EXPENSE_DESCRIBE_CLASS).last
      amount_field.fill_in(with: amount) if amount
      describe_field.fill_in(with: describe) if describe
    end
  end

  def fill_topic_fields(question, answer, index: nil)
    within NOTES_ID do
      topic_select = index.present? ? all(TOPIC_SELECT_CLASS)[index] : all(TOPIC_SELECT_CLASS).last
      answer_field = index.present? ? all(TOPIC_VALUE_CLASS)[index] : all(TOPIC_VALUE_CLASS).last
      topic_select.select(question) if question
      answer_field.fill_in(with: answer) if answer
    end
  end

  # @param case_numbers [Array[String]]
  # @param contact_types [Array[String]]
  # @param contact_made [Boolean]
  # @param medium [String]
  # @param occurred_on [String], date in the format MM/dd/YYYY
  # @param hours [Integer]
  # @param minutes [Integer]
  def complete_details_page(
    contact_made: true, medium: "In Person", occurred_on: Time.zone.today, hours: nil, minutes: nil,
    case_numbers: [], contact_types: [], contact_topics: []
  )
    within DETAILS_ID do
      within find("#draft-case-id-selector") do
        find(".ts-control").click
      end

      Array.wrap(case_numbers).each do |case_number|
        checkbox_for_case_number = find("span", text: case_number).sibling("input")
        checkbox_for_case_number.click unless checkbox_for_case_number.checked?
      end

      within find("#draft-case-id-selector") do
        find(".ts-control").click
      end

      Array.wrap(case_numbers).each do |case_number|
        # check case_numbers have been selected
        expect(page).to have_text case_number
      end

      fill_in "case_contact_occurred_at", with: occurred_on if occurred_on

      contact_types.each do |contact_type|
        check contact_type
      end

      choose medium if medium

      within "#enter-contact-details" do
        if contact_made
          check "Contact was made"
        else
          uncheck "Contact was made"
        end
      end

      fill_in "case_contact_duration_hours", with: hours if hours
      fill_in "case_contact_duration_minutes", with: minutes if minutes
    end

    # previously answered on separate page... consolidate somehow...
    Array.wrap(contact_topics).each do |topic|
      click_on "Add Note"
      fill_topic_fields topic, nil
    end
  end
  alias_method :fill_in_contact_details, :complete_details_page

  def choose_medium(medium)
    choose medium if medium
  end

  def complete_notes_page(notes: nil, contact_topic_answers: [])
    # needs topics to already be added & selected (commplete_details_page)
    contact_topic_answers = Array.wrap(contact_topic_answers)
    if contact_topic_answers.any?
      contact_topic_answers.each_with_index do |answer, index|
        fill_topic_fields(nil, answer, index:)
      end
    end

    if notes.present?
      click_on "Add Note"
      fill_topic_fields("Additional Notes", notes)
    end
  end

  # @param miles [Integer]
  # @param want_reimbursement [Boolean]
  # @param address [String]
  def fill_in_expenses_page(miles: 0, want_reimbursement: false, address: nil)
    within REIMBURSEMENT_ID do
      if want_reimbursement
        check "Request travel or other reimbursement"
      else
        uncheck "Request travel or other reimbursement"
      end

      fill_in "case_contact_miles_driven", with: miles
      fill_in "case_contact_volunteer_address", with: address if address
    end
  end
end

RSpec.configure do |config|
  config.include FillInCaseContactFields, type: :system
end
