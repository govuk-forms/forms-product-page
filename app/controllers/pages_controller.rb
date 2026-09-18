class PagesController < ApplicationController
  include PerformanceData

  layout "pages_with_sub_navigation", except: %i[index accessibility cookies privacy terms_of_use]

  # Homepage
  def index
    fetch_data
    render layout: "homepage"
  end

  # Pages without sub navigation
  def accessibility; end
  def cookies; end
  def privacy; end
  def terms_of_use; end

  # Get started pages
  def get_started; end

  # About pages
  def about; end
  def features; end
  def forthcoming_features; end
  def create_good_forms; end
  def processing_completed_form_submissions; end
  def data_protection_security; end
  def using_routes; end
end
