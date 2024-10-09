require "rails_helper"

RSpec.describe LanguagesController do
  describe "POST /create" do
    context "when request params are valid" do
      it "creates a new language" do
        organization = create(:casa_org)
        admin = create(:casa_admin, casa_org: organization)

        sign_in admin
        post languages_path, params: {
          language: {
            name: "Spanish"
          }
        }

        expect(response).to have_http_status :found
        expect(response).to redirect_to(edit_casa_org_path(organization.id))
        expect(flash[:notice]).to eq "Language was successfully created."
      end
    end
  end

  describe "PATCH /update" do
    context "when request params are valid" do
      it "creates a new language" do
        organization = create(:casa_org)
        admin = create(:casa_admin, casa_org: organization)
        language = create(:language, casa_org: organization)

        sign_in admin
        patch language_path(language), params: {
          language: {
            name: "Spanishes"
          }
        }

        expect(response).to have_http_status :found
        expect(response).to redirect_to(edit_casa_org_path(organization.id))
        expect(flash[:notice]).to eq "Language was successfully updated."
      end
    end
  end
end
