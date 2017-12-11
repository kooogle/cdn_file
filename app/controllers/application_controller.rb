class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  # before_action :allow_page_caching
  before_action :redirect_to_origin

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      respond_to do |format|
        format.html { redirect_to root_path }
      end
    else
      respond_to do |format|
        format.html { redirect_to sign_in_path }
      end
    end
  end

  def redirect_to_origin
    if Rails.env.production?
      unless request.host.include?('koogle.cc')
        redirect_to "http://#{request.host}"
      end
    end
  end

  private

  def allow_page_caching
    expires_in(5.minutes, public: true) unless Rails.env.development?
  end

end
