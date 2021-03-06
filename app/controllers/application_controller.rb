class ApplicationController < ActionController::Base
  include Pundit
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  after_action :store_location
  # after_filter :verify_authorized, except: [:index, :show, :new, :edit]

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end



  #helper_method :current_user

  #def current_user
    #@current_user ||= User.find(session[:user_id]) if session[:user_id]
  #end

  def verify_admin
    admin_is_logged_in? || not_found
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    return dashboard_path if resource.admin?
    root_path
  end

  private

  def admin_is_logged_in?
    authenticate_user! && current_user.admin?
  end




end
