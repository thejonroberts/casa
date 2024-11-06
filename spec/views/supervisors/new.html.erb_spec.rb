require "rails_helper"

RSpec.describe "supervisors/new", type: :view,
  skip: "add specs or remove file" do
  subject { render template: "supervisors/new" }

  before do
    assign :supervisor, Supervisor.new
  end

  context "while signed in as admin" do
    before do
      sign_in admin
    end
  end
end
