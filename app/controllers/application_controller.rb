class ApplicationController < ActionController::Base
    helper_method :current_user

    rescue_from CanCan::AccessDenied do |exception|
      @error_message = exception.message
      redirect_to root_url, alert: @error_message
    end
  
    def current_user
      if session[:user_id]
        @current_user ||= User.find_by_id(session[:user_id])
      else
        @current_user = nil
      end
    end
  end