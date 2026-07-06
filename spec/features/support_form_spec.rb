require "rails_helper"

describe "Support form", type: :system do
  context "when requests need to be funneled to Zendesk" do
    before do
      stub_request(:post, "https://changeme.zendesk.com/api/v2/tickets.json")
        .to_return { |request| { status: 201, body: request.body } }

      visit support_path
    end

    it "asks users who they are" do
      expect(page).to have_text "Support"
      expect(page).to have_text "Who are you?"
      expect(page).to have_field("support_form[i_need_help_with]", type: :radio, visible: :all).exactly(2).times
    end

    scenario "a government service team member asks a general question about GOV.UK Forms" do
      choose "I work in a government service team", visible: :all
      click_button "Continue"

      expect(page).to have_text "What is your request about?"
      choose "A general question about GOV.UK Forms", visible: :all
      click_button "Continue"

      expect(page).to have_text "Question about GOV.UK Forms"
      fill_in "What is your question?", with: "How does GOV.UK Forms work?"
      fill_in "Your name", with: "Test User"
      fill_in "Your email address", with: "test@example.com"
      click_button "Send"

      expect(page).to have_text "Message sent"
    end

    scenario "a government service team member suggests an improvement" do
      choose "I work in a government service team", visible: :all
      click_button "Continue"

      expect(page).to have_text "What is your request about?"
      choose "Suggesting a new feature or improvement", visible: :all
      click_button "Continue"

      expect(page).to have_text "Suggest a feature or improvement to GOV.UK Forms"
      fill_in "What would you like to change or improve?", with: "Add a way to duplicate questions"
      fill_in "Your name", with: "Test User"
      fill_in "Your email address", with: "test@example.com"
      click_button "Send"

      expect(page).to have_text "Message sent"
    end
  end

  scenario "a member of the public is redirected to the contact page" do
    visit support_path
    choose "I’m a member of the public with a question about a government form or service", visible: :all
    click_button "Continue"

    expect(page).to have_current_path("https://www.gov.uk/contact", url: true)
  end
end
