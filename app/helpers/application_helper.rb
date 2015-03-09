module ApplicationHelper
  def page_title
    params[:controller].humanize
  end
end
