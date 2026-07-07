require "rails_helper"

describe SupportForm, type: :model do
  describe "validations" do
    SupportForm::I_NEED_HELP_WITH_OPTIONS.each do |option|
      it "is valid if i_need_help_with is set to #{option}" do
        expect(described_class.new(i_need_help_with: option)).to be_valid
      end
    end

    it "is valid to submit if all attributes are present" do
      expect(described_class.new(
               i_need_help_with: "government_service_team",
               request_type: "feature_request",
               message: "Add an autosave feature",
               name: "A. User",
               email_address: "test@example.com",
             )).to be_valid(:submit)
    end

    %i[i_need_help_with request_type message name email_address].each do |attr|
      it "is not valid to submit if #{attr} is not present" do
        attrs = {
          i_need_help_with: "government_service_team",
          request_type: "feature_request",
          message: "Add an autosave feature",
          name: "A. User",
          email_address: "test@example.com",
        }
        attrs.delete(attr)

        support_form = described_class.new(**attrs)

        expect(support_form).not_to be_valid(:submit)
        expect(support_form.errors).to be_added(attr, :blank)
      end
    end

    it "is valid to continue from the request type step when a request type is selected" do
      expect(described_class.new(
               i_need_help_with: "government_service_team",
               request_type: "feature_request",
             )).to be_valid(:request_type)
    end

    it "is not valid to continue from the request type step without a request type" do
      support_form = described_class.new(i_need_help_with: "government_service_team")

      expect(support_form).not_to be_valid(:request_type)
      expect(support_form.errors).to be_added(:request_type, :blank)
    end

    it "is not valid to submit if i_need_help_with is public" do
      expect(described_class.new(
               i_need_help_with: "public",
               message: "I need help with a form",
               name: "A. User",
               email_address: "test@example.com",
             )).not_to be_valid(:submit)
    end

    it "is not valid to submit if email_address is not an email address" do
      support_form = described_class.new(
        i_need_help_with: "government_service_team",
        request_type: "feature_request",
        message: "Add an autosave feature",
        name: "A. User",
        email_address: "not_an_email_address",
      )

      expect(support_form).not_to be_valid(:submit)
      expect(support_form.errors.where(:email_address, message: :invalid_email)).to be_truthy
    end

    it "is not valid to submit a general question without a question" do
      support_form = described_class.new(
        i_need_help_with: "government_service_team",
        request_type: "general_question",
        name: "A. User",
        email_address: "test@example.com",
      )

      expect(support_form).not_to be_valid(:submit)
      expect(support_form.errors).to be_added(:question, :blank)
    end
  end

  describe "#submit" do
    before do
      allow(ZendeskTicketService).to receive(:create!).and_return(true)
    end

    it "does not submit if the user is a member of the public" do
      support_form = described_class.new(
        i_need_help_with: "public",
        message: "I need help with a form",
        name: "A. User",
        email_address: "test@example.com",
      )

      expect(support_form.submit).to be_falsey
      expect(ZendeskTicketService).not_to have_received(:create!)
    end

    it "submits the user's message as a Zendesk ticket" do
      support_form = described_class.new(
        i_need_help_with: "government_service_team",
        request_type: "feature_request",
        message: "Add an autosave feature",
        name: "A. User",
        email_address: "test@example.com",
      )

      expect(support_form.submit).to be_truthy
      expect(ZendeskTicketService).to have_received(:create!).with(
        hash_including(
          comment: {
            body: <<~MESSAGE,
              Request type: Suggesting a new feature or improvement

              What would you like to change or improve?:

              Add an autosave feature
            MESSAGE
          },
          requester: { name: "A. User", email: "test@example.com" },
        ),
      )
    end

    it "tags general questions as enquiries" do
      described_class.new(
        i_need_help_with: "government_service_team",
        request_type: "general_question",
        question: "How does GOV.UK Forms work?",
        name: "A. User",
        email_address: "test@example.com",
      ).submit

      expect(ZendeskTicketService).to have_received(:create!).with(
        hash_including(
          tags: %w[govuk_forms_enquiries general_question],
        ),
      )
    end

    it "tags support requests with the support tag" do
      described_class.new(
        i_need_help_with: "government_service_team",
        request_type: "technical_issue",
        message: "My form is not loading",
        name: "A. User",
        email_address: "test@example.com",
      ).submit

      expect(ZendeskTicketService).to have_received(:create!).with(
        hash_including(
          tags: %w[govuk_forms_support technical_issue],
        ),
      )
    end
  end
end
