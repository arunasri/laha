class ApplicationController < ActionController::Base

  has_mobile_fu

  helper_method :telugu?
  helper_method :hindi?
  helper_method :language
  helper_method :channel
  helper_method :language?
  helper_method :channel?

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

  protected

  def telugu?
    language.try(:==, 'te')
  end

  def hindi?
    language.try(:==, 'hi')
  end

  def language?
    language.present?
  end

  def channel?
    channel.present?
  end

  def language
    cookies[:language]
  end

  def channel
    cookies[:channel]
  end

  def language=(lng)
    cookies.permanent[:language]  = lng
  end

  def channel=(lng)
    cookies.permanent[:channel]  = lng
  end


  private

  def ensure_logged_in
    unless current_user
      render :text => 'please login first'
    end
  end

  # keep it in application controller since more than one controllers use it
  def ensure_admin_logged_in
    unless current_user.try(:admin)
      render :text => 'not authorized'
    end
  end
end
