require 'rails_helper'

RSpec.describe "casa_widgets/new", type: :view do
  before(:each) do
    assign(:casa_widget, CasaWidget.new(
      name: "MyString",
      body: "MyText",
      hidden: false,
      amount: "9.99",
      tracking_id: 1,
      email: "MyString",
      password: ""
    ))
  end

  it "renders new casa_widget form" do
    render

    assert_select "form[action=?][method=?]", casa_widgets_path, "post" do

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
