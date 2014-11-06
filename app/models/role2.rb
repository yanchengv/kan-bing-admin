class Role2 < ActiveRecord::Base
  has_many :role2s_menu_permissions, :dependent => :destroy
  has_many :menu_permissions, :through => :role2s_menu_permissions, :source  => :menu_permission
  has_many :admin2s_role2s, :dependent => :destroy
  has_many :admin2s, :through => :admin2s_role2s, :source  => :admin2
  has_many :role2_menus, dependent: :destroy
  has_many :menus, :through => :role2_menus, :source => :menu

  def get_zTree  #指定角色菜单树的生成
    menu_permissions = self.menu_permissions
    return menu_ztree2(menu_permissions)
  end
=begin
  def menu_ztree(menu_permissions)
    if !menu_permissions.empty?
      @menus = []
      @p_menus = []
      @priorities = []
      menu_permissions.each do |menu_permission|
        @menu = menu_permission.menu
        if !@menu.nil?
          priority = menu_permission.priority
          @priority = {menu_id:@menu.id,priority:priority,menu_permission_id:menu_permission.id}.as_json
          @menu={id:@menu.id,name:@menu.name,pId:@menu.parent_id,menu_permission_id:menu_permission.id,uri:@menu.uri}.as_json
          @p_menus.push(@menu)
          @priorities.push(@priority)
        end
      end
      @p_menus.each do |menu|
        child = []
        menu_permission_id = []
        @priorities.each do |pri|
          if pri['menu_id'] == menu['id']
            if !pri['priority'].nil?
              child.push({name:pri['priority']['name'],menu_permission_id:pri['menu_permission_id']})
            end
            menu_permission_id.push(pri['menu_permission_id'])
          end
        end
        @menu = {id:menu['id'],name:menu['name'],pId:menu['pId'],menu_permission_id:menu_permission_id,uri:menu['uri'],children:child}.as_json
        @menus.push(@menu)
      end
      @all_trees=[]
      @menus=@menus.uniq
      p 'baekhyun'
      p @menus
      @menus.each do |menu|
        p '1'
        p menu['name']
        if menu['pId'].nil?
          p 'bb'
          p menu['name']
          @child_menus=[]
          @menu2=nil
          @menus.each do |menu2|
            p '2'
            p menu2['name']
            if menu2['pId'] == menu['id']
              p 'dd'
              p menu2['name']
              children = stup(@menus,menu2)
              if children.nil? || children==[]
                @menu2 = {id:menu2['id'],name:menu2['name'],pId:menu2['pId'],menu_permission_id:menu2['menu_permission_id'],children:menu2['children']}
              else
                @menu2 = {id:menu2['id'],name:menu2['name'],pId:menu2['pId'],menu_permission_id:menu2['menu_permission_id'],children:children}
              end
              p @menu2
              p 'haha'
              @child_menus.push(@menu2)
            end
          end
          if @child_menus==[]
            @all_tree = {id:menu['id'],name:menu['name'],pId:menu['pId'],menu_permission_id:menu['menu_permission_id'],children:menu['children']}
          else
            @all_tree = {id:menu['id'],name:menu['name'],pId:menu['pId'],menu_permission_id:menu['menu_permission_id'],children:@child_menus}
          end
          p 'tu'
          p @all_tree
        end
        @all_trees.push(@all_tree)
      end
      @all_trees = @all_trees.uniq
      return @all_trees
    end
  end

  def stup(menus,menu)
    i=3
    if !child_menus(menu).empty?
      @child_menus=[]
      @tree_menus=[]
      @menu2=nil
      menus.each do |menu2|
        p i
        p menu2['name']
        if menu2['pId'] == menu['id']
          p 'ch'
          children = stup(menus,menu2)
          if children.nil? || children==[]
            p 'a'
            @menu2 = {id:menu2['id'],name:menu2['name'],pId:menu2['pId'],menu_permission_id:menu2['menu_permission_id'],children:menu2['children']}
          else
            @menu2 = {id:menu2['id'],name:menu2['name'],pId:menu2['pId'],menu_permission_id:menu2['menu_permission_id'],children:children}
          end
          @child_menus.push(@menu2)
        end
      end
      @menu2=@child_menus
      @child_menus=[]
      return @menu2
    else
      return nil
    end
  end
=end

  def child_menus(menus,menu)  #判断指定菜单是否有子菜单
    @menu = Menu.where(id:menu['id']).first
    @menus = []
    menus.each do |m|
      if m['pId'] == @menu.id
        @menus.push(m)
      end
    end
    return @menus
  end

  def menu_ztree2(menu_permissions)   #生成菜单权限树
    @menus = []
    @p_menus = []
    @priorities = []
    menu_permissions.each do |menu_permission|
      @menu = menu_permission.menu
      if !@menu.nil?
        priority = menu_permission.priority
        @priority = {menu_id:@menu.id,priority:priority,menu_permission_id:menu_permission.id}.as_json
        @menu={id:@menu.id,name:@menu.name,pId:@menu.parent_id,menu_permission_id:menu_permission.id,uri:@menu.uri,hospital_id:menu_permission.hospital_id}.as_json
        @p_menus.push(@menu)
        @priorities.push(@priority)
      end
    end
    @p_menus.each do |menu|
      child = []
      menu_permission_id = []
      priority_ids = []
      @priorities.each do |pri|
        if pri['menu_id'] == menu['id']
          if !pri['priority'].nil?
            priority = {:id => menu['id'].to_s+'_'+pri['priority']['id'].to_s,:pId => menu['id'],:name => pri['priority']['name'],:menu_permission_id => [pri['menu_permission_id']]}.as_json
            child.push(priority)
            priority_ids.push(pri['priority']['id'])
          end
          menu_permission_id.push(pri['menu_permission_id'])
        end
      end
      @menu = {id:menu['id'],name:menu['name'],pId:menu['pId'],menu_permission_id:menu_permission_id,uri:menu['uri'],hospital_id:menu['hospital_id'],priority_ids:priority_ids,children:child}.as_json
      @menus.push(@menu)
    end
    @menus=@menus.uniq
    @all_trees=[]
    @all = @menus
    @menus.each do |menu|
      if menu['pId'].nil?
        if child_menus(@all,menu).empty?
          @all_tree = {id:menu['id'],name:menu['name'],pId:menu['pId'],menu_permission_id:menu['menu_permission_id'],uri:menu['uri'],hospital_id:menu['hospital_id'],priority_ids:menu['priority_ids'],children:menu['children']}
        else
          @all_tree = {id:menu['id'],name:menu['name'],pId:menu['pId'],menu_permission_id:menu['menu_permission_id'],uri:menu['uri'],hospital_id:menu['hospital_id'],priority_ids:menu['priority_ids'],children:stup2(@all,menu)}
        end
        @all_trees.push(@all_tree)
      end
    end
    return @all_trees
  end

  def stup2(menus,menu)   #递归生成菜单权限子树
    child_menus=[]
    @all = menus
    menus.each do |menu2|
      if menu2['pId'].to_i == menu['id'].to_i
        if child_menus(@all,menu2).empty?
          @menus = {id:menu2['id'],name:menu2['name'],pId:menu2['pId'],menu_permission_id:menu2['menu_permission_id'],uri:menu2['uri'],hospital_id:menu2['hospital_id'],priority_ids:menu2['priority_ids'],children:menu2['children']}
        else
          @menus = {id:menu2['id'],name:menu2['name'],pId:menu2['pId'],menu_permission_id:menu2['menu_permission_id'],uri:menu2['uri'],hospital_id:menu2['hospital_id'],priority_ids:menu2['priority_ids'],children:stup2(@all,menu2)}
        end
        child_menus.push(@menus)
      end
    end
    child_tree = child_menus
    child_menus = []
    return child_tree
  end

  def menu_tree
    menus = self.menus
    root_tree(menus)
  end

  def root_tree(menus)
    @menus = menus
    @menus=@menus.uniq
    @all_trees=[]
    @all = @menus
    @menus.each do |menu|
      if menu.parent_id.nil?
        if menu.child_menus.empty?
          @all_tree = {id:menu.id,name:menu.name,pId:menu.parent_id,uri:menu.uri}
        else
          @all_tree = {id:menu.id,name:menu.name,pId:menu.parent_id,uri:menu.uri,children:child_tree(@all,menu)}
        end
        @all_trees.push(@all_tree)
      end
    end
    return @all_trees
  end

  def child_tree(menus,menu)
    child_menus=[]
    @all = menus
    menus.each do |menu2|
      if menu2.parent_id.to_i == menu.id.to_i
        if menu2.child_menus.empty?
          @menus = {id:menu2.id,name:menu2.name,pId:menu2.parent_id,uri:menu2.uri}
        else
          @menus = {id:menu2.id,name:menu2.name,pId:menu2.parent_id,uri:menu2.uri,children:child_tree(@all,menu2)}
        end
        child_menus.push(@menus)
      end
    end
    child_tree = child_menus
    child_menus = []
    return child_tree
  end

end
