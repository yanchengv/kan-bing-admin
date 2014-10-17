class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def access_flag
    menu_name = params[:menu_name]
    flag=false
    @menu_permissions = MenuPermission.joins(role2s_menu_permissions:[{role2: [{admin2s_role2s: :admin2}]}]).where(admin2s:{id:current_user.id})
    if !@menu_permissions.empty?
      @menu_permissions.each do |menu_permission|
        if menu_permission.menu.name == menu_name
          flag = true
        end
      end
    end
    return flag
  end

  def access_control
    unless access_flag
      store_location
      redirect_to root_path, notice: "Please sign in."
    end

  end

end
