require "rails_helper"

RSpec.describe PatchNotePolicy, type: :policy do
  let(:user) { User.new }
  let(:volunteer) { create(:volunteer) }
  let(:supervisor) { create(:supervisor) }
  let(:casa_admin) { create(:casa_admin) }
  let(:all_casa_admin) { create(:all_casa_admin) }

  subject { described_class }

  permissions :index? do
    it { is_expected.to_not permit(nil, :patch_note) }
    it { is_expected.to permit(volunteer, :patch_note) }
    it { is_expected.to permit(supervisor, :patch_note) }
    it { is_expected.to permit(casa_admin, :patch_note) }
    it { is_expected.to permit(all_casa_admin, :patch_note) }
  end

  describe "Scope#resolve" do
    let!(:all_user_patch_note) { create :patch_note }
    let!(:supervisor_and_admin_note) { create :patch_note, :only_supervisors_and_admins }
    let!(:no_users_note) { create :patch_note, :no_user_groups }

    subject { described_class::Scope.new(user, PatchNote.all).resolve }

    before do
      # only patch notes before latest deploy time are returned (model scope)
      Health.instance.update_attribute(:latest_deploy_time, Date.tomorrow)
    end

    context "when user is nil" do
      let(:user) { nil }

      it "does not return any patch notes" do
        expect(subject).to be_empty
      end
    end

    context "when user is volunteer" do
      let(:user) { volunteer }

      it "does not return any patch notes" do
        expect(subject).to include(all_user_patch_note)
        expect(subject).to_not include(supervisor_and_admin_note)
        expect(subject).to_not include(no_users_note)
      end
    end

    context "when user is supervisor" do
      let(:user) { supervisor }

      it "returns all supervisor group patch notes" do
        expect(subject).to include(all_user_patch_note, supervisor_and_admin_note)
        expect(subject).not_to include(no_users_note)
      end
    end

    context "when user is admin" do
      let(:user) { casa_admin }

      it "returns all admin group patch notes" do
        expect(subject).to include(all_user_patch_note, supervisor_and_admin_note)
        expect(subject).not_to include(no_users_note)
      end
    end

    context "when user is all casa admin" do
      let(:user) { all_casa_admin }

      it "returns all patch notes" do
        expect(subject).to include(all_user_patch_note, supervisor_and_admin_note, no_users_note)
      end
    end
  end
end
