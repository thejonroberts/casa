require "rails_helper"

RSpec.describe MileageRatePolicy, :aggregate_failures, type: :policy do
  let(:casa_org) { create :casa_org }
  let(:volunteer) { create :volunteer, casa_org: }
  let(:supervisor) { create :supervisor, casa_org: }
  let(:casa_admin) { create :casa_admin, casa_org: }
  let(:all_casa_admin) { create :all_casa_admin }

  # may need to create other records/modify factory to assign org
  let(:mileage_rate) { create :mileage_rate, casa_org: }
  # modify to assign to volunteer user or remove if not applicable
  # let(:volunteer_mileage_rate) { create :mileage_rate, casa_org:, volunteer: }

  subject { described_class }

  # NOTE: `permissions :action_one?, :action_two?, :action_three? do` for same behavior per method
  # - may need to move collection methods to the other permissions block, this generator only checks for 'index',

  permissions :new?, :show?, :create?, :edit?, :update?, :destroy? do
    # Usage for action(s) on a single record (check user and record info to authorize)
    it "does not permit a nil user" do
      expect(described_class).not_to permit(nil, mileage_rate)
    end

    it "does not permit a volunteer" do
      expect(described_class).not_to permit(volunteer, mileage_rate)
    end

    it "permits a supervisor" do
      expect(described_class).to permit(supervisor, mileage_rate)
    end

    it "does not permit a supervisor for a different casa org" do
      other_org_supervisor = create :supervisor, casa_org: create(:casa_org)
      expect(described_class).not_to permit(other_org_supervisor, mileage_rate)
    end

    it "permits a casa admin" do
      expect(described_class).to permit(casa_admin, mileage_rate)
    end

    it "does not permit a casa admin for a different casa org" do
      other_org_casa_admin = create :casa_admin, casa_org: create(:casa_org)
      expect(described_class).not_to permit(other_org_casa_admin, mileage_rate)
    end

    it "does not permit an all casa admin" do
      expect(described_class).not_to permit(all_casa_admin, mileage_rate)
    end
  end

  permissions :see_mileage_rate? do
    it "does not allow volunters" do
      is_expected.not_to permit(volunteer)
    end

    it "does not allow supervisors" do
      is_expected.not_to permit(supervisor)
    end

    it "allow casa_admins for same org" do
      is_expected.to permit(casa_admin)
    end

    context "when org reimbursement is disabled" do
      before do
        casa_org.show_driving_reimbursement = false
      end

      it "does not allow casa_admins" do
        is_expected.not_to permit(casa_admin)
      end
    end
  end


  permissions :index? do
    # Usage for action(s) on a collection of records (no single record to authorize, check user only)
    it "permits CasaAdmins of the same CasaOrg" do
      expect(described_class).to permit(casa_admin, :mileage_rate)
      expect(described_class).to_not permit(nil, :mileage_rate)
      expect(described_class).to_not permit(volunteer, :mileage_rate)
      expect(described_class).to_not permit(supervisor, :mileage_rate)
      expect(described_class).to_not permit(all_casa_admin, :mileage_rate)
    end
  end

  describe "Scope#resolve" do
    let!(:casa_org_mileage_rate) { create :mileage_rate, casa_org: }
    let!(:other_casa_org_mileage_rate) { create :mileage_rate, casa_org: create(:casa_org) }

    subject { described_class::Scope.new(user, MileageRate.all).resolve }

    context "when user is a visitor" do
      let(:user) { nil }

      it { is_expected.not_to include(casa_org_mileage_rate) }
      it { is_expected.not_to include(other_casa_org_mileage_rate) }
    end

    context "when user is a volunteer" do
      let(:user) { volunteer }
      # let!(:user_mileage_rate) { volunteer_mileage_rate }

      # it { is_expected.to include(user_mileage_rate) }
      it { is_expected.not_to include(casa_org_mileage_rate) }
      it { is_expected.not_to include(other_casa_org_mileage_rate) }
    end

    context "when user is a supervisor" do
      let(:user) { supervisor }

      it { is_expected.to include(casa_org_mileage_rate) }
      it { is_expected.not_to include(other_casa_org_mileage_rate) }
    end

    context "when user is a casa_admin" do
      let(:user) { casa_admin }

      it { is_expected.to include(casa_org_mileage_rate) }
      it { is_expected.not_to include(other_casa_org_mileage_rate) }
    end

    context "when user is an all_casa_admin" do
      let(:user) { all_casa_admin }

      it { is_expected.not_to include(casa_org_mileage_rate) }
      it { is_expected.not_to include(other_casa_org_mileage_rate) }
    end
  end
end
