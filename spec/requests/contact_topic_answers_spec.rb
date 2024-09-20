require "rails_helper"

RSpec.describe "/contact_topic_answers", type: :request do
  let(:casa_org) { create :casa_org }
  let(:contact_topic) { create :contact_topic, casa_org: }
  let(:volunteer) { create :volunteer, :with_single_case, casa_org: }
  let(:casa_case) { volunteer.casa_cases.first }
  let(:case_contact) { create :case_contact, casa_case:, creator: volunteer }

  let(:attributes) do
    attributes_for(:contact_topic_answer)
      .merge({contact_topic_id: contact_topic.id, case_contact_id: case_contact.id})
  end

  let(:invalid_attributes) { attributes.except(:case_contact_id) }

  let(:user) { volunteer }

  before { sign_in user }

  describe "POST /create" do
    let(:params) { {contact_topic_answer: attributes} }

    subject { post contact_topic_answers_path, params:, as: :json }

    it "creates a new ContactTopicAnswer and responds created" do
      expect { subject }.to change(ContactTopicAnswer, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it "responds success with the new contact topic answer" do
      subject
      answer = ContactTopicAnswer.last
      response_json = JSON.parse(response.body)
      expect(response_json["id"]).to eq answer.id
      expect(response_json.keys).to include("id", "contact_topic_id", "value", "case_contact_id", "selected")
    end

    context "with invalid parameters" do
      let(:params) { {contact_topic_answer: invalid_attributes} }

      it "does not create a new ContactTopicAnswer" do
        expect { subject }.not_to change(ContactTopicAnswer, :count)
      end

      it "fails authorization and renders a response with 302 found redirect" do
        subject
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:contact_topic_answer) { create :contact_topic_answer, contact_topic:, case_contact: }

    subject { delete contact_topic_answer_url(contact_topic_answer), as: :json }

    it "destroys the requested contact_topic_answer" do
      expect { subject }.to change(ContactTopicAnswer, :count).by(-1)
    end

    it "responds no content" do
      subject
      expect(response).to have_http_status(:no_content)
    end
  end
end
