class SupportForm
  include ActiveModel::Model
  include ActiveModel::Validations

  EMAIL_REGEX = /.*@.*/
  I_NEED_HELP_WITH_OPTIONS = %w[government_service_team public].freeze
  REQUEST_TYPE_OPTIONS = %w[help_using technical_issue feature_request general_question something_else].freeze

  attr_accessor :i_need_help_with, :request_type, :message, :name, :email_address

  alias_attribute :question, :message

  validates :i_need_help_with, presence: true, inclusion: { in: I_NEED_HELP_WITH_OPTIONS }
  validates :i_need_help_with, presence: true, inclusion: { in: %w[government_service_team] }, on: :submit
  validates :request_type, presence: true, on: %i[request_type submit], if: :government_service_team?
  validates :request_type, inclusion: { in: REQUEST_TYPE_OPTIONS }, on: %i[request_type submit], if: :government_service_team?, allow_blank: true
  validates :email_address, presence: true, format: { with: EMAIL_REGEX, message: :invalid_email }, on: :submit
  validates :name, presence: true, on: :submit
  validates :message, presence: true, on: :submit, unless: :general_question?
  validates :question, presence: true, on: :submit, if: :general_question?

  def government_service_team?
    i_need_help_with.to_s == "government_service_team"
  end

  def general_question?
    request_type.to_s == "general_question"
  end

  def support_message_attribute
    general_question? ? :question : :message
  end

  def support_page_title
    return I18n.t("page_titles.support.request_details.#{request_type}") if request_type_selected?

    I18n.t("page_titles.support.form")
  end

  def support_message_label
    return I18n.t("helpers.label.support_form.request_details.#{request_type}") if request_type_selected?

    I18n.t("helpers.label.support_form.message")
  end

  def support_message_hint
    return unless request_type_selected?

    I18n.t("helpers.hint.support_form.request_details.#{request_type}", default: nil)
  end

  def submit
    return false if invalid?(:submit)

    tags = {
      "general_question" => %w[govuk_forms_enquiries],
    }.fetch(request_type, %w[govuk_forms_support])
    tags << request_type if request_type.present?

    ZendeskTicketService.create!(
      comment: { body: zendesk_message },
      requester: { name:, email: email_address },
      tags:,
    )
  end

private

  def zendesk_message
    <<~MESSAGE
      Request type: #{request_type_label}

      #{support_message_label}:

      #{message}
    MESSAGE
  end

  def request_type_label
    I18n.t("helpers.label.support_form.request_type_options.#{request_type}")
  end

  def request_type_selected?
    government_service_team? && REQUEST_TYPE_OPTIONS.include?(request_type.to_s)
  end
end
