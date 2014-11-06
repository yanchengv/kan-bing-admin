class Menu < ActiveRecord::Base
  has_many :admin2_menus,dependent: :destroy
  has_many :menu_permissions,dependent: :destroy
  belongs_to :parent_menu,foreign_key: :parent_id,class_name:"Menu"
  has_many :child_menus, foreign_key: :parent_id,class_name:"Menu" ,dependent: :destroy
  has_many :priorities, :through => :menu_permissions, :source  => :priority
  has_many :role2_menus, dependent: :destroy
  has_many :role2s, :through => :role2_menus, :source => :role2

  def all_menus
    @menus=Menu.all

  end

  def priority_ids    #当前菜单所具有的权限的id集合
    priority_ids=[]
    if !self.priorities.empty?
      self.priorities.each do |priority|
        priority_ids.push(priority.id)
      end
    end
    p priority_ids
    return priority_ids
  end

  def all_child(menus)  #在指定菜单列表menus中获得当前menu的所有子菜单
    @all_childs = []
    get_child(self,menus,@all_childs)
    p 'baekhyun'
    p @all_childs.uniq
    return @all_childs.uniq
  end

  def get_child(menu,menus,the_menus) #递归获取子菜单
    if !menu.child_menus.empty?
      menu.child_menus.each do |menu2|
        if !menu2.child_menus.empty?
          get_child(menu2,menus,the_menus)
        end
        menus.each do |menu3|
          if menu2.id==menu3.id
            the_menus.push(menu2)
          end
        end
      end
    end
    p 'baek'
    p the_menus
    return the_menus
  end
  # 左侧导航
  def  left_menu admin_id
    @menus=Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,mp.hospital_id,mp.department_id from role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp,menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{admin_id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.is_show is null GROUP BY menus.id;")
  end
end
