require "rails_helper"

RSpec.describe Address do
  describe "validate associations" do
    it { is_expected.to belong_to(:user) }
  end
end
