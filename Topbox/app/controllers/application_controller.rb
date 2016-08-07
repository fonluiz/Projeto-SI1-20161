class ApplicationController < ActionController::Base
  include ApplicationHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :show_navbar

  helper_method :current_user, :current_folder, :set_current_folder
  helper_method :redirect_to_mytopbox, :find_mytopbox, :get_user_folders, :get_not_children_folders

  @@current_folder #The Current folder should remain the same.

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_folder
    return (@@current_folder ||= Folder.find_by(name: MAIN_FOLDER_NAME, user_id: current_user.id))
  end

  def set_current_folder(folder)
    @@current_folder = folder
  end

  def require_user
    redirect_to LOGIN_URL unless current_user
  end

  def has_active_session?
    if session[:user_id]
      redirect_to_mytopbox
      return false
    else
      return true
    end
  end

  def log_out
    session[:user_id] = nil
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !current_user.nil?
  end

  def get_not_children_folders(children)
    @result = []
    folders = get_user_folders.where('id != ?', current_folder.id)
    get_children_folders(children.to_ary)
    return folders - @result
  end

  private
  def get_children_folders(children)
    if children.length != 0
      children.each do |c|
        child = []
        child.push(c)
        @result += child
        get_children_folders(c.children.to_ary)
      end
    end
  end

  protected
  def show_navbar
    @show_navbar = true
  end

  def redirect_to_mytopbox
    my_topbox = Folder.find_by(name: MAIN_FOLDER_NAME, user_id: current_user.id)
    my_topbox_id = my_topbox.id.to_s
    redirect_to MAIN_FOLDER_PATH + my_topbox_id
  end

  def find_mytopbox
    Folder.find_by(name: MAIN_FOLDER_NAME, user_id: current_user.id)
  end

  def get_user_folders
    Folder.where(user_id: current_user.id)
  end

end

