class ApplicationController < ActionController::Base

  has_mobile_fu

  protect_from_forgery

  helper_method :current_user

  # Do not make this method private. admin_data uses it
  def current_user(user_id = nil)
    if user_id
      session[:user_id] = user_id
    end

    session[:user_id] && @_user ||= User.find(session[:user_id])
  end

  def current_videos_path
    session[:videos_path]
  end

  def set_current_videos_path
    session[:videos_path] = request.path
  end

  private

  def ensure_logged_in
    unless current_user
      redirect_to admin_path
    end
  end

  # keep it in application controller since more than one controllers use it
  def ensure_admin_logged_in
    return true if Rails.env.development?
    unless current_user.try(:admin)
      render :text => 'you are not admin'
    end
  end
end
