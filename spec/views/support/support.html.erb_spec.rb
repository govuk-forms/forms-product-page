require "rails_helper"

describe "support/support.html.erb", type: :view do
  let(:support_form) { SupportForm.new }

  before do
    assign(:support_form, support_form)

    render template: "support/support"
  end

  it "asks what the user needs help with" do
    expect(rendered).to have_css("legend", text: I18n.t("helpers.legend.support_form.i_need_help_with"))
    expect(rendered).to have_field(I18n.t("helpers.label.support_form.i_need_help_with_options.about_forms"), type: "radio")
    expect(rendered).to have_field(I18n.t("helpers.label.support_form.i_need_help_with_options.other_government_service"), type: "radio")
    expect(rendered).to have_field(I18n.t("helpers.label.support_form.i_need_help_with_options.using_forms"), type: "radio")
  end

  it "renders the title" do
    expect(view.content_for(:title)).to eq "Support"
  end

  context "when there is a validation error" do
    let(:support_form) do
      form = SupportForm.new
      form.valid?(:submit)
      form
    end

    it "renders the title with 'Error:' prefix" do
      expect(view.content_for(:title)).to eq "Error: Support"
    end

    it "renders the error summary" do
      expect(rendered).to have_text("There is a problem")
      expect(rendered).to have_link(href: "#support-form-i-need-help-with-field-error", text: I18n.t("activemodel.errors.models.support_form.attributes.i_need_help_with.blank"))
    end

    it "renders a validation error on the field" do
      expect(rendered).to have_css(".govuk-error-message", text: I18n.t("activemodel.errors.models.support_form.attributes.i_need_help_with.blank"))
    end
  end
end
