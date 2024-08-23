require 'rails_helper'

RSpec.describe "casa_widgets/edit", type: :view do
  let(:casa_widget) {
    CasaWidget.create!(
      name: "MyString",
      body: "MyText",
      hidden: false,
      amount: "9.99",
      tracking_id: 1,
      email: "MyString",
      password: ""
    )
  }

  before(:each) do
    assign(:casa_widget, casa_widget)
  end

  it "renders the edit casa_widget form" do
    render

    assert_select "form[action=?][method=?]", casa_widget_path(casa_widget), "post" do

      assert_select "input[name=?]", "casa_widget[name]"

      assert_select "textarea[name=?]", "casa_widget[body]"

      assert_select "input[name=?]", "casa_widget[hidden]"

      assert_select "input[name=?]", "casa_widget[amount]"

      assert_select "input[name=?]", "casa_widget[tracking_id]"

      assert_select "input[name=?]", "casa_widget[email]"

      assert_select "input[name=?]", "casa_widget[password]"
    end
  end
end
