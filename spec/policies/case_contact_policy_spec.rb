require "rails_helper"

RSpec.describe CaseContactPolicy do
  subject { described_class }

  let(:casa_admin) { build(:casa_admin) }
  let(:case_contact) { build(:case_contact) }
  let(:volunteer) { build(:volunteer) }
  let(:supervisor) { build(:supervisor) }

  permissions :index? do
    it "allows casa_admins" do
      expect(subject).to permit(casa_admin)
    end

    it "allows supervisor" do
      expect(subject).to permit(supervisor)
    end

    it "allows volunteer" do
      expect(subject).to permit(volunteer)
    end
  end

  permissions :show? do
    it "allows casa_admins" do
      expect(subject).to permit(casa_admin, case_contact)
    end

    context "when volunteer is the creator" do
      let(:case_contact) { build_stubbed(:case_contact, creator: volunteer) }

      it "allows the volunteer" do
        expect(subject).to permit(volunteer, case_contact)
      end
    end

    context "when volunteer is not the creator" do
      it "does not allow the volunteer" do
        expect(subject).not_to permit(volunteer, case_contact)
      end
    end
  end

  permissions :edit? do
    it "allows casa_admins" do
      expect(subject).to permit(casa_admin, case_contact)
    end

    it "allows supervisors" do
      expect(subject).to permit(supervisor, case_contact)
    end

    context "when volunteer is assigned" do
      it "allows the volunteer" do
        case_contact = build_stubbed(:case_contact, creator: volunteer)

        expect(subject).to permit(volunteer, case_contact)
      end
    end

    context "when volunteer is not the creator" do
      it "does not allow the volunteer" do
        expect(subject).not_to permit(volunteer, case_contact)
      end
    end
  end

  permissions :new? do
    it "allows casa_admins" do
      expect(subject).to permit(casa_admin)
    end

    it "does allow volunteers" do
      expect(subject).to permit(volunteer, CaseContact.new)
    end
  end

  permissions :update?, :drafts? do
    it "allows casa_admins" do
      expect(subject).to permit(casa_admin, case_contact)
    end

    it "allows supervisors" do
      expect(subject).to permit(supervisor, case_contact)
    end

    it "does not allow volunteers" do
      expect(subject).not_to permit(volunteer, case_contact)
    end
  end

  permissions :destroy? do
    it "allows casa_admins" do
      expect(subject).to permit(casa_admin, case_contact)
    end

    context "when volunteer is assigned" do
      context "case_contact is a draft" do
        let(:case_contact) { build_stubbed(:case_contact, :started_status, creator: volunteer) }

        it { is_expected.to permit(volunteer, case_contact) }
      end

      context "case_contact is not a draft" do
        let(:case_contact) { build_stubbed(:case_contact, :active, creator: volunteer) }

        it { is_expected.not_to permit(volunteer, case_contact) }
      end
    end

    context "when volunteer is not assigned" do
      context "case_contact is a draft" do
        let(:case_contact) { build_stubbed(:case_contact, :started_status, creator: build_stubbed(:volunteer)) }

        it { is_expected.not_to permit(volunteer, case_contact) }
      end

      context "case_contact is not a draft" do
        let(:case_contact) { build_stubbed(:case_contact, :active, creator: build_stubbed(:volunteer)) }

        it { is_expected.not_to permit(volunteer, case_contact) }
      end
    end
  end
end
