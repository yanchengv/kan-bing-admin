#encoding:utf-8
class Admin2 < ActiveRecord::Base
  before_create :create_remember_token
  validates :name, presence: true, uniqueness: { case_sensitive: true, message: "该用户名已被使用！" }
  attr_reader :password
  has_secure_password :validations => false
  has_many :admin2_menus, :dependent => :destroy
  has_many :menu_trees, :through => :admin2_menus, :source  => :menu
  has_many :admin2s_role2s, :dependent => :destroy
  has_many :role2s, :through => :admin2s_role2s, :source  => :role2

  def t_menus     #管理员所拥有的菜单
    menus=[]
    roles = self.role2s
    roles.each do |role|
      menu_permissions = role.menu_permissions
      menu_permissions.each do |menu_permission|
        menu = menu_permission.menu
        menus.push(menu)
      end
    end
    p 'all_menus'
    p menus
    return menus.uniq
  end

  def Admin2.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Admin2.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # 用户header的菜单
  def menus id
      Admin2Menu.where(admin2_id: id)
  end
  private
  def create_remember_token
    self.remember_token=Admin2.encrypt(Admin2.new_remember_token)
  end

end
