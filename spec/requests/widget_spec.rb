require "rails_helper"

RSpec.describe "/widgets", type: :request do
  let(:casa_org) { create :casa_org }
  let(:volunteer) { create :volunteer, casa_org: }
  let(:supervisor) { create :supervisor, casa_org: }
  let(:casa_admin) { create :casa_admin, casa_org: }
  let(:all_casa_admin) { create :all_casa_admin }
  let(:user) { volunteer } # use 'lowest' user type with access

  let(:widget) { create :widget, casa_org: }
  let(:valid_attributes) { attributes_for :widget, casa_org: }
  let(:invalid_attributes) do
    # must change `validated_attribute` to attribute with value that will fail validation
    valid_attributes.merge(validated_attribute: nil)
  end

  before { sign_in user }

  # TODO: change subjects, describe, and expectations as needed! Resourceful examples:
  # subject { get widget_path } # index
  # subject { get widget_path(widget) } # show
  # subject { get new_widget_path } # new
  # subject { delete widget_path(widget) } # destroy
  # let(:params) { {widget: valid_attributes} }
  # subject { post widget_path, params: } # create
  # subject { patch widget_path(widget), params: } # update

  describe "GET /index" do
    subject { raise "create a subject for this action" }

    it "renders a successful response" do
      subject
      expect(response).to have_http_status :success
      expect(response).to render_template :index
    end

    pending "it does something else" do
      subject
    end
  end

  describe "GET /new" do
    subject { raise "create a subject for this action" }

    it "renders a successful response" do
      subject
      expect(response).to have_http_status :success
      expect(response).to render_template :new
    end

    pending "it does something else" do
      subject
    end
  end

  describe "GET /create" do
    subject { raise "create a subject for this action" }

    it "renders a successful response" do
      subject
      expect(response).to have_http_status :success
      expect(response).to render_template :create
    end

    pending "it does something else" do
      subject
    end
  end

  describe "GET /show" do
    subject { raise "create a subject for this action" }

    it "renders a successful response" do
      subject
      expect(response).to have_http_status :success
      expect(response).to render_template :show
    end

    pending "it does something else" do
      subject
    end
  end
end
