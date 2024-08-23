require 'rails_helper'

RSpec.describe "casa_widgets/show", type: :view do
  before(:each) do
    assign(:casa_widget, CasaWidget.create!(
      name: "Name",
      body: "MyText",
      hidden: false,
      amount: "9.99",
      tracking_id: 2,
      email: "Email",
      password: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(//)
  end
end
