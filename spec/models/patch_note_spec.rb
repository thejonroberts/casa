require "rails_helper"

RSpec.describe PatchNote, type: :model do
  let!(:patch_note) { create(:patch_note) }

  it { is_expected.to belong_to(:patch_note_group) }
  it { is_expected.to belong_to(:patch_note_type) }
  it { is_expected.to validate_presence_of(:note) }

  describe ".notes_available_for_user" do
    let!(:all_users_note) { create :patch_note }
    let!(:supervisor_and_admin_note) { create :patch_note, :only_supervisors_and_admins }
    let!(:invalid_group_patch_note) { create :patch_note, :no_user_groups }

    let(:user) { create :casa_admin }

    subject { described_class.notes_available_for_user user }

    context "patch note created before latest deploy time" do
      before do
        Health.instance.update_attribute(:latest_deploy_time, Date.tomorrow)
      end

      it "returns all user group patch notes" do
        expect(subject).to include(all_users_note, supervisor_and_admin_note)
      end

      it "does not return patch notes from invalid groups" do
        expect(subject).to_not include(invalid_group_patch_note)
      end

      context "user is volunteer" do
        let(:user) { create :volunteer }

        it "returns patch notes for all users" do
          expect(subject).to include(all_users_note)
        end

        it "does not return patch notes for admins/supervisors" do
          expect(subject).to_not include(supervisor_and_admin_note)
        end
      end
    end

    context "patch note created after latest deploy time" do
      before do
        Health.instance.update_attribute(:latest_deploy_time, Date.yesterday)
      end

      it "returns no patch notes" do
        expect(subject).to be_empty
      end
    end
  end
end
