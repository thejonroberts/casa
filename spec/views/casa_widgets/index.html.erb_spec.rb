require 'rails_helper'

RSpec.describe "casa_widgets/index", type: :view do
  before(:each) do
    assign(:casa_widgets, [
      CasaWidget.create!(
        name: "Name",
        body: "MyText",
        hidden: false,
        amount: "9.99",
        tracking_id: 2,
        email: "Email",
        password: ""
      ),
      CasaWidget.create!(
        name: "Name",
        body: "MyText",
        hidden: false,
        amount: "9.99",
        tracking_id: 2,
        email: "Email",
        password: ""
      )
    ])
  end

  it "renders a list of casa_widgets" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Email".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
