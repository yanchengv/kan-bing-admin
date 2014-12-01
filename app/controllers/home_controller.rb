class HomeController < ApplicationController
  def index
    if signed_in?
      @menus=current_user.admin2_menus
      admin_id=current_user.id
      if current_user.admin_type == '医院管理员'
        @left_menus=Menu.where(hos_admin_show: true)
        # @left_menus=[{name: "医生管理", uri: "/doctors"},{name: "患者管理", uri: "/patients"},{name: "用户管理", uri: "/users"},{name: "管理员管理", uri: "/admin2s"},{name: "医院管理", uri: "/hospitals"},{name: "教育视频管理", uri: "/edu_videos"},{name:"留言管理",uri:"/consult_accuses"},{name:"首页管理",uri:"",children:[{name:"首界面管理",uri:"/page_blocks/page_blocks_setting"},{name:"首界面区块管理",uri:"/page_blocks"}]}]
      elsif current_user.admin_type == '科室管理员'
        @left_menus=Menu.where(dep_admin_show: true)
        # @left_menus=[{name: "医生管理", uri: "/doctors"},{name: "患者管理", uri: "/patients"},{name: "用户管理", uri: "/users"},{name: "教育视频管理", uri: "/edu_videos"},{name:"留言管理",uri:"/consult_accuses"},{name:"首页管理",uri:"",children:[{name:"首界面管理",uri:"/page_blocks/page_blocks_setting"},{name:"首界面区块管理",uri:"/page_blocks"}]}]
      else
        @left_menus=Menu.new.left_menu admin_id
      end
      #  @menus= [
      # {name: '父节点1',id:'1', children: [
      #     {name: '子节点1',id:2},
      #     {name: '子节点2',id:3}
      # ]} ];
      #@menus.as_json
    else
      redirect_to '/sessions/sign_in'
    end
  end
end
