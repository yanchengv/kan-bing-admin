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
    return menus.uniq
  end

  def Admin2.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def admin_priority menu_id
    add_flag=false
    delete_flag=false
    update_flag=false
    show_flag=false
    @menu_permissions = MenuPermission.find_by_sql("select mp.priority_id from menu_permissions mp,role2s_menu_permissions rmp,admin2s_role2s ar,admin2s a where rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=a.id and a.id=#{self.id} and mp.menu_id=#{menu_id}")
    if !@menu_permissions.empty?
      @menu_permissions.each do |menu_permission|
        if menu_permission.priority_id == 1
          add_flag = true
        end
        if menu_permission.priority_id == 2
          delete_flag = true
        end
        if menu_permission.priority_id == 3
          update_flag = true
        end
        if menu_permission.priority_id == 4
          show_flag = true
        end
      end
    end
    return {add_flag:add_flag,delete_flag:delete_flag,update_flag:update_flag,show_flag:show_flag}
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
