require "rails_helper"

describe "support/form.html.erb", type: :view do
  let(:request_type) { "help_using" }

  before do
    assign(:support_form, SupportForm.new(i_need_help_with: "government_service_team", request_type:))

    render template: "support/form"
  end

  context "when the request is a feature request" do
    let(:request_type) { "feature_request" }

    it "asks for the change they need" do
      expect(rendered).to have_text "Suggest a feature or improvement to GOV.UK Forms"

      expect(rendered).to have_field "support_form[message]" do |field|
        expect(field.tag_name).to eq "textarea"
        expect(field[:spellcheck]).to eq "true"
      end

      expect(rendered).to have_text "What would you like to change or improve?"
      expect(rendered).to have_text "Tell us what you want to change or improve and why it would help."
    end
  end

  context "when the request is a technical issue" do
    let(:request_type) { "technical_issue" }

    it "asks for the problem details" do
      expect(rendered).to have_text "Report a technical problem with GOV.UK Forms"
      expect(rendered).to have_text "What is the problem?"
      expect(rendered).to have_text "Tell us what happened, what you expected to happen and which form you were using."
    end
  end

  context "when the request is getting help using GOV.UK Forms" do
    let(:request_type) { "help_using" }

    it "asks what the user needs help to do" do
      expect(rendered).to have_text "Help using GOV.UK Forms"
      expect(rendered).to have_text "What do you need help to do?"
      expect(rendered).to have_text "Tell us what you want to do and where you got stuck."
    end
  end

  context "when the request is a general question" do
    let(:request_type) { "general_question" }

    it "asks for a question" do
      expect(rendered).to have_text "Question about GOV.UK Forms"

      expect(rendered).to have_field "support_form[question]" do |field|
        expect(field.tag_name).to eq "textarea"
        expect(field[:spellcheck]).to eq "true"
      end

      expect(rendered).to have_text "What is your question?"
    end
  end

  context "when the request is something else" do
    let(:request_type) { "something_else" }

    it "asks for general request details" do
      expect(rendered).to have_text "Contact GOV.UK Forms support"
      expect(rendered).to have_text "Tell us what your request is about"
    end
  end

  it "includes the selected request type as a hidden field" do
    expect(rendered).to have_field("support_form[request_type]", type: "hidden", with: request_type)
  end

  it "asks for a name" do
    expect(rendered).to have_field "support_form[name]" do |field|
      expect(field[:autocomplete]).to eq "name"
      expect(field[:spellcheck]).to eq "false"
    end
  end

  it "asks for an email address" do
    expect(rendered).to have_field "support_form[email_address]" do |field|
      expect(field[:autocomplete]).to eq "email"
      expect(field[:type]).to eq "email"
      expect(field[:spellcheck]).to eq "false"
    end
  end
end
