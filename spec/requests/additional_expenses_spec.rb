require "rails_helper"

RSpec.describe "/additional_expenses", type: :request do
  let(:casa_org) { create :casa_org }
  let(:volunteer) { create :volunteer, :with_single_case, casa_org: }
  let(:casa_case) { volunteer.casa_cases.first }
  let(:case_contact) { create :case_contact, casa_case:, creator: volunteer }

  let(:attributes) do
    attributes_for(:additional_expense)
      .merge({case_contact_id: case_contact.id})
  end

  let(:invalid_attributes) { attributes.except(:case_contact_id) }

  let(:user) { volunteer }

  before { sign_in user }

  describe "POST /create" do
    let(:params) { {additional_expense: attributes} }

    subject { post additional_expenses_path, params:, as: :json }

    it "creates a new AdditionalExpense and responds created" do
      puts params
      expect { subject }.to change(AdditionalExpense, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "responds success with the new contact topic answer" do
      subject
      answer = AdditionalExpense.last
      response_json = JSON.parse(response.body)
      expect(response_json["id"]).to eq answer.id
      expect(response_json.keys).to include("id", "case_contact_id", "other_expense_amount", "other_expenses_describe")
    end

    context "with invalid parameters" do
      let(:params) { {additional_expense: invalid_attributes} }

      it "does not create a new AdditionalExpense" do
        expect { subject }.not_to change(AdditionalExpense, :count)
      end

      it "fails authorization and renders a response with 302 found redirect" do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:additional_expense) { create :additional_expense, case_contact: }

    subject { delete additional_expense_url(additional_expense), as: :json }

    it "destroys the requested additional_expense" do
      expect { subject }.to change(AdditionalExpense, :count).by(-1)
    end

    it "responds no content" do
      subject
      expect(response).to have_http_status(:no_content)
    end
  end
end
