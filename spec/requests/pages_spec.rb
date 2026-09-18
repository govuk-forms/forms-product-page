require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /index" do
    before do
      get root_path
    end

    it "returns ok" do
      expect(response).to have_http_status(:ok)
    end

    it "has the correct title" do
      expect(Capybara.string(response.body).title).to eq("Create online forms for GOV.UK – GOV.UK Forms")
    end
  end

  %w[
    accessibility
    privacy
    support
    terms-of-use
    get-started
    about
    about/features
    about/forthcoming-features
    about/create-good-forms
    about/processing-completed-form-submissions
    about/data-protection-security
    about/using-routes
  ].each do |page|
    describe "GET /#{page}" do
      it "returns ok" do
        get "/#{page}"
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /cookies" do
    before do
      get cookies_path
    end

    it "returns ok" do
      expect(response).to have_http_status(:ok)
    end

    it "does not contain the cookie banner" do
      expect(Capybara.string(response.body)).not_to have_selector("#cookie-banner")
    end
  end
end
