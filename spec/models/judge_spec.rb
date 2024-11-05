require "rails_helper"

RSpec.describe Judge, type: :model do
  it { is_expected.to belong_to(:casa_org) }
  it { is_expected.to validate_presence_of(:name) }

  describe ".for_organization" do
    it "returns only records matching the specified organization" do
      casa_org_1 = create(:casa_org)
      casa_org_2 = create(:casa_org)
      record_1 = create(:judge, casa_org: casa_org_1)
      record_2 = create(:judge, casa_org: casa_org_2)

      expect(described_class.for_organization(casa_org_1)).to eq([record_1])
      expect(described_class.for_organization(casa_org_2)).to eq([record_2])
    end
  end

  describe "default scope" do
    let(:casa_org) { create(:casa_org) }

    it "orders alphabetically by name" do
      judge1 = create(:judge, name: "Gamma", casa_org:)
      judge2 = create(:judge, name: "Alpha", casa_org:)
      judge3 = create(:judge, name: "Epsilon", casa_org:)

      expect(described_class.for_organization(casa_org)).to eq [judge2, judge3, judge1]
    end
  end
end
