#encoding:utf-8
class Admin2 < ActiveRecord::Base
  before_create :create_remember_token
  validates :name, presence: true, uniqueness: { case_sensitive: true, message: "该用户名已被使用！" }
  attr_reader :password
  has_secure_password :validations => false
  def Admin2.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Admin2.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
  def create_remember_token
    self.remember_token=Admin2.encrypt(Admin2.new_remember_token)
  end

end
