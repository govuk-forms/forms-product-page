require "rails_helper"

describe "support/request_type.html.erb", type: :view do
  before do
    assign(:support_form, SupportForm.new(i_need_help_with: "government_service_team"))

    render template: "support/request_type"
  end

  it "asks what the request is about" do
    expect(rendered).to have_text "What is your request about?"
    expect(rendered).to have_field("support_form[request_type]", type: :radio, visible: :all).exactly(5).times
    expect(rendered).to have_text "Getting help using GOV.UK Forms"
    expect(rendered).to have_text "A technical problem or something is not working as expected"
    expect(rendered).to have_text "Suggesting a new feature or improvement"
    expect(rendered).to have_text "A general question about GOV.UK Forms"
    expect(rendered).to have_text "Something else"
  end

  it "shows an error summary when a request type has not been selected" do
    support_form = SupportForm.new(i_need_help_with: "government_service_team")
    support_form.invalid?(:request_type)
    assign(:support_form, support_form)

    render template: "support/request_type"

    expect(rendered).to have_css ".govuk-error-summary"
    expect(rendered).to have_text "Select what your request is about"
  end
end
