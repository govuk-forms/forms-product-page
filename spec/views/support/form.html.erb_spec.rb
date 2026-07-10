require "rails_helper"

describe "support/form.html.erb", type: :view do
  let(:i_need_help_with) { "using_forms" }
  let(:support_form) { SupportForm.new(i_need_help_with:) }

  before do
    assign(:support_form, support_form)

    render template: "support/form"
  end

  context "when the user needs help using GOV.UK Forms" do
    let(:i_need_help_with) { "using_forms" }

    it "asks for a message" do
      expect(rendered).to have_field "support_form[message]" do |field|
        expect(field.tag_name).to eq "textarea"
        expect(field[:spellcheck]).to eq "true"
      end
    end

    context "when there is a validation error" do
      let(:support_form) do
        form = SupportForm.new(i_need_help_with:)
        form.valid?(:submit)
        form
      end

      it "renders the title with 'Error:' prefix" do
        expect(view.content_for(:title)).to eq "Error: Help using GOV.UK Forms"
      end

      it "renders the error summary" do
        expect(rendered).to have_text("There is a problem")
        expect(rendered).to have_link(href: "#support-form-name-field-error", text: I18n.t("activemodel.errors.models.support_form.attributes.name.blank"))
      end

      it "renders a validation error on the field" do
        expect(rendered).to have_css(".govuk-error-message", text: I18n.t("activemodel.errors.models.support_form.attributes.name.blank"))
      end
    end
  end

  context "when the user has a question about GOV.UK Forms" do
    let(:i_need_help_with) { "about_forms" }

    it "asks for a question" do
      expect(rendered).to have_field "support_form[question]" do |field|
        expect(field.tag_name).to eq "textarea"
        expect(field[:spellcheck]).to eq "true"
      end
    end
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

  context "when there is a validation error" do
    let(:support_form) do
      form = SupportForm.new(i_need_help_with:)
      form.valid?(:submit)
      form
    end

    it "renders the title with 'Error:' prefix" do
      expect(view.content_for(:title)).to eq "Error: Help using GOV.UK Forms"
    end

    it "renders the error summary" do
      expect(rendered).to have_text("There is a problem")
      expect(rendered).to have_link(href: "#support-form-name-field-error", text: I18n.t("activemodel.errors.models.support_form.attributes.name.blank"))
    end

    it "renders a validation error on the field" do
      expect(rendered).to have_css(".govuk-error-message", text: I18n.t("activemodel.errors.models.support_form.attributes.name.blank"))
    end
  end
end
