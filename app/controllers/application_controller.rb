class ApplicationController < ActionController::Base
  rescue_from ActionView::MissingTemplate do |exception|
    if request.format && request.format != :html
      head :not_acceptable
    else
      raise exception
    end
  end

  def append_info_to_payload(payload)
    super
    payload[:request_host] = request.host
    payload[:request_id] = request.request_id
    payload[:trace_id] = request.env["HTTP_X_AMZN_TRACE_ID"].presence
    payload[:user_ip] = user_ip(request.env.fetch("HTTP_X_FORWARDED_FOR", ""))
  end

  def user_ip(forwarded_for = "")
    first_ip_string = forwarded_for.split(",").first
    Regexp.union([Resolv::IPv4::Regex, Resolv::IPv6::Regex]).match(first_ip_string) && first_ip_string
  end
end
