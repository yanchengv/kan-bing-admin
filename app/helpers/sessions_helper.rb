module SessionsHelper
  def sign_in(user)
    # 单点登录
    # remember_token = Admin2.new_remember_token
    # cookies.permanent[:remember_token] = remember_token
    # user.update_attribute(:remember_token, Admin2.encrypt(remember_token))
    # user.update_attribute(:sign_in_count,user.sign_in_count+1)
    # self.current_user = user

     # 多点登录
     if !user.remember_token.nil?&&user.remember_token!=''
       cookies.permanent[:remember_token] = user.remember_token
     else
       remember_token = Admin2.new_remember_token
       cookies.permanent[:remember_token] = remember_token
       user.update_attribute(:remember_token, Admin2.encrypt(remember_token))
     end

    user.update_attribute(:sign_in_count,user.sign_in_count+1)
    self.current_user = user
  end
  def signed_in?
    !current_user.nil?
  end


  def current_user=(user)
    @current_user = user
  end


  def current_user
    if params[:token]
      cookies.permanent[:remember_token] = params[:token]
    end
    if params[:remember_token]
      remember_token = params[:remember_token]
    else
      # remember_token = Admin2.encrypt(cookies[:remember_token])  #单点登录
      remember_token = cookies[:remember_token]#多点登录
    end
    @current_user ||= Admin2.find_by(remember_token:remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in_user

    unless signed_in?
      store_location
      redirect_to root_path, notice: "Please sign in."
    end
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def store_location
    session[:return_to] = request.url
  end

  def checksignedin
    if current_user.nil?
      flash[:success] = 'please sign in'
      redirect_to root_path
      return false
    else
      return true
    end
  end

  def pk_id_rules
    require 'securerandom'
    num0 = rand(100)*rand(100)
    num1 = num0*rand(100)
    num2 = rand(num1)
    random=SecureRandom.random_number(num1)+SecureRandom.random_number(num2)+SecureRandom.random_number(num0)
    time=Time.now.to_i
    id=(Settings.hospital_code.yuquan+time.to_s+random.to_s).to_i
    return id
  end
end

