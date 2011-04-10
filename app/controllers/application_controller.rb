class ApplicationController < ActionController::Base

  has_mobile_fu

  protect_from_forgery

  #before_filter :ensure_logged_in
  #before_filter :ensure_admin_logged_in

  helper_method :current_user


  # Do not make this method private. admin_data uses it
  def current_user(user_id = nil)
    session[:user_id] = user_id if user_id
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  def current_videos_path
    session[:videos_path]
  end

  def set_current_videos_path
    session[:videos_path] = request.path
  end

  private

  def ensure_logged_in
    return true if Rails.env.development?
    unless current_user
      render :text => 'please login first'
    end
  end

  # keep it in application controller since more than one controllers use it
  def ensure_admin_logged_in
    return true if Rails.env.development?
    unless current_user.try(:admin)
      render :text => 'not authorized'
    end
  end
end
