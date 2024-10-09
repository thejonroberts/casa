require "rails_helper"

RSpec.describe AdditionalExpense do
  it { is_expected.to belong_to(:case_contact) }
end
