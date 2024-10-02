require "rails_helper"

RSpec.describe CasaAdminPolicy do
  subject { described_class }

  let(:organization) { build(:casa_org) }
  let(:casa_admin) { create(:casa_admin, casa_org: organization) }
  let(:volunteer) { build(:volunteer, casa_org: organization) }
  let(:supervisor) { build(:supervisor, casa_org: organization) }

  permissions :edit? do
    context "same org" do
      let(:record) { build_stubbed(:casa_admin, casa_org: casa_admin.casa_org) }

      it "allows editing admin" do
        expect(subject).to permit(casa_admin, record)
      end
    end

    context "different org" do
      let(:record) { build_stubbed(:casa_admin, casa_org: build_stubbed(:casa_org)) }

      it "does not allow editing admin" do
        expect(subject).not_to permit(casa_admin, record)
      end
    end
  end

  permissions :index?, :new?, :create?, :update?, :activate?, :resend_invitation?, :change_to_supervisor? do
    it "allows casa_admins" do
      expect(subject).to permit(casa_admin)
    end
  end

  permissions :index?, :edit?, :new?, :create?, :update?, :activate?, :resend_invitation?, :change_to_supervisor? do
    it "does not permit supervisor" do
      expect(subject).to_not permit(supervisor)
    end

    it "does not permit volunteer" do
      expect(subject).to_not permit(volunteer)
    end
  end

  permissions :deactivate? do
    context "when user is a casa admin" do
      let(:admin_inactive) { build_stubbed(:casa_admin, active: false, casa_org: organization) }

      it "does not permit if is a inactive user" do
        expect(subject).not_to permit(admin_inactive, :casa_admin)
      end

      it "does not permit if is the only admin" do
        expect(subject).not_to permit(casa_admin, :casa_admin)
      end

      it "permits if is a active user and exist other casa admins" do
        create(:casa_admin, casa_org: organization)
        expect(subject).to permit(casa_admin, :casa_admin)
      end
    end

    context "when user is a supervisor" do
      it "does not permit" do
        expect(subject).not_to permit(supervisor, :casa_admin)
      end
    end

    context "when user is a volunteer" do
      it "does not permit" do
        expect(subject).not_to permit(volunteer)
      end
    end
  end
end
