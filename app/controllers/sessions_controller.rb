class SessionsController < ApplicationController
  def sign_page
    render template: 'sessions/sign_in_form'
  end

  def create
    login_name = params[:session][:username]
    password = params[:session][:password]
    @flag={}
    user = nil
    if /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.match(login_name)
      user = Admin2.find_by(email:login_name)
    else
      user = Admin2.find_by(name: login_name)
    end
    if user&&user.authenticate(password)
      sign_in user
      p 'success'
      redirect_to '/'
    else
      flash.now[:error] = 'Invalid email/password combination'
      redirect_to :back
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin
    @admin = Admin2.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_params
    params.require(:admin).permit(:id, :name, :email, :photo, :password_digest, :remember_token, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip)
  end
end
