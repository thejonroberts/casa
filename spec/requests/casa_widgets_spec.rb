require "rails_helper"

RSpec.describe "/casa_widgets", type: :request do
  let(:casa_org) { create :casa_org }
  let(:volunteer) { create :volunteer, casa_org: }
  let(:supervisor) { create :supervisor, casa_org: }
  let(:casa_admin) { create :casa_admin, casa_org: }
  let(:all_casa_admin) { create :all_casa_admin }
  let(:user) { volunteer } # use 'lowest' user type with access

  let(:casa_widget) { create :casa_widget, casa_org: }
  let(:valid_attributes) { attributes_for :casa_widget, casa_org: }
  let(:invalid_attributes) do
    # must change validated_attribute to attribute with value that will fail validation
    valid_attributes.merge(validated_attribute: nil)
  end

  before { sign_in user }

  describe "GET /index" do
    let!(:casa_widgets) { create_list :casa_widget, 2, casa_org: }

    subject { get casa_widgets_path }

    it "renders a successful response" do
      subject
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end

    it "displays information of the records" do
      subject
      pending "specify what information is displayed if applicable"
      expect(response.body).to include(*casa_widgets.map(&:name))
    end
  end

  describe "GET /new" do
    subject { get new_casa_widget_path }

    it "renders a successful response" do
      subject
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe "POST /create" do
    let(:params) { {casa_widget: valid_attributes} }

    subject { post casa_widgets_path, params: }

    it "creates new record" do
      expect { subject }.to change(CasaWidget, :count).by(1)
    end

    it "redirects to the created record" do
      subject
      expect(response).to redirect_to(casa_widget_path(CasaWidget.last))
    end

    context "with invalid params" do
      let(:params) { {casa_widget: invalid_attributes} }

      it "does not create a new record" do
        expect { subject }.to change(CasaWidget, :count).by(0)
      end

      it "renders new template" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET show" do
    let(:casa_widget) { create :casa_widget, casa_org: }

    subject { get casa_widget_path(casa_widget) }

    it "renders a successful response" do
      subject
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end
  end

  describe "GET edit" do
    let(:casa_widget) { create :casa_widget, casa_org: }

    subject { get edit_casa_widget_path(casa_widget) }

    it "renders a successful response" do
      subject
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH /update" do
    let(:params) { {casa_widget: valid_attributes} }

    subject { patch casa_widget_path(casa_widget), params: }

    it "updates the requested record" do
      pending("Add assertions for attributes that should change")
      expect(casa_widget.attribute).not_to eq(valid_attributes[:attribute])
      subject
      casa_widget.reload
      expect(casa_widget.attribute).to eq(valid_attributes[:attribute])
    end

    it "redirects to the updated record" do
      subject
      expect(response).to redirect_to(casa_widget_path(casa_widget))
    end

    context "with invalid params" do
      let(:params) { {casa_widget: invalid_attributes} }

      it "renders edit template" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE destroy" do
    let!(:casa_widget) { create :casa_widget, casa_org: }

    subject { delete casa_widget_path(casa_widget) }

    it "destroys the requested record" do
      expect { subject }.to change(CasaWidget, :count).by(-1)
    end

    it "redirects to the casa_widgets index" do
      subject
      expect(response).to redirect_to(casa_widgets_path)
    end
  end
end
