class SupportController < ApplicationController
  def support
    @support_form = SupportForm.new
  end

  def new
    @support_form = SupportForm.new(support_form_params)

    if @support_form.invalid?
      render :support and return
    end

    case @support_form.i_need_help_with.to_sym
    when :government_service_team
      redirect_to :support_request_type
    when :public
      redirect_to "https://www.gov.uk/contact", status: :see_other, allow_other_host: true
    end
  end

  def request_type
    @support_form = SupportForm.new(i_need_help_with: "government_service_team")
  end

  def select_request_type
    @support_form = SupportForm.new(government_service_team_params)

    if @support_form.invalid?(:request_type)
      render :request_type and return
    end

    redirect_to support_form_path(request_type: @support_form.request_type)
  end

  def form
    @support_form = SupportForm.new(i_need_help_with: "government_service_team", request_type: params[:request_type])

    if @support_form.invalid?(:request_type)
      redirect_to :support_request_type and return
    end

    render :form
  end

  def submit
    @support_form = SupportForm.new(government_service_team_params)

    if @support_form.invalid?(:request_type)
      redirect_to :support_request_type and return
    end

    if @support_form.submit
      render :confirmation
    else
      render :form
    end
  end

private

  def support_form_params
    params
      .require(:support_form)
      .permit(:i_need_help_with, :request_type, :message, :question, :name, :email_address)
  end

  def government_service_team_params
    support_form_params.merge(i_need_help_with: "government_service_team")
  end
end
