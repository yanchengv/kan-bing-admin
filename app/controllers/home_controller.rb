class HomeController < ApplicationController
  skip_before_action :update_activity_time
  skip_before_action :session_expiry
  before_filter :session_expiry_root
  def index
    require "base64"
    require "aes"
    key = '290c3c5d812a4ba7ce33adf09598a462'
    if signed_in?
      @menus=current_user.admin2_menus
      admin_id=current_user.id
      if current_user.admin_type == '医院管理员'
        @first_menus=Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.hos_admin_show=true and parent_id is null")
        if (params[:pId].nil? || params[:pId] == '') && !@first_menus.empty?
          # params[:pId] = @first_menus.first.id
          params[:pId] = AES.encrypt(@first_menus.first.id.to_s,key)
        end
        if @first_menus.empty?
          @left_menus = nil
        else
          params[:pId] = params[:pId].gsub(/[ ]/, '+')
          p params[:pId]
          # params[:pId] = Base64.decode64 params[:pId].to_s
          params[:pId] = AES.decrypt(params[:pId].to_s,key)
          p params[:pId]
          @left_menus = Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.hos_admin_show=true and parent_id=#{params[:pId]}")
          if @left_menus.empty?
            @left_menus = Menu.where(id:params[:pId])
          end
        end
        # @left_menus=[{name: "医生管理", uri: "/doctors"},{name: "患者管理", uri: "/patients"},{name: "用户管理", uri: "/users"},{name: "管理员管理", uri: "/admin2s"},{name: "医院管理", uri: "/hospitals"},{name: "教育视频管理", uri: "/edu_videos"},{name:"留言管理",uri:"/consult_accuses"},{name:"首页管理",uri:"",children:[{name:"首界面管理",uri:"/page_blocks/page_blocks_setting"},{name:"首界面区块管理",uri:"/page_blocks"},{name:"域名管理",uri:"/domain/show"}]}]
      elsif current_user.admin_type == '科室管理员'
        @first_menus=Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.dep_admin_show=true and parent_id is null")
        if (params[:pId].nil? || params[:pId] == '') && !@first_menus.empty?
          # params[:pId] = @first_menus.first.id
          params[:pId] = AES.encrypt(@first_menus.first.id.to_s,key)
        end
        if @first_menus.empty?
          @left_menus = nil
        else
          params[:pId] = params[:pId].gsub(/[ ]/, '+')
          p params[:pId]
          # params[:pId] = Base64.decode64 params[:pId].to_s
          params[:pId] = AES.decrypt(params[:pId].to_s,key)
          p params[:pId]
          @left_menus = Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.dep_admin_show=true and parent_id=#{params[:pId]}")
          if @left_menus.empty?
            @left_menus = Menu.where(id:params[:pId])
          end
        end
        # @left_menus=[{name: "医生管理", uri: "/doctors"},{name: "患者管理", uri: "/patients"},{name: "用户管理", uri: "/users"},{name: "教育视频管理", uri: "/edu_videos"},{name:"留言管理",uri:"/consult_accuses"},{name:"首页管理",uri:"",children:[{name:"首界面管理",uri:"/page_blocks/page_blocks_setting"},{name:"首界面区块管理",uri:"/page_blocks"},{name:"域名管理",uri:"/domain/show"}]}]
      elsif current_user.admin_type == '机构管理员'
        @first_menus=Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.ins_admin_show=true and parent_id is null")
        if (params[:pId].nil? || params[:pId] == '') && !@first_menus.empty?
          # params[:pId] = Base64.encode64 @first_menus.first.id
          params[:pId] = AES.encrypt(@first_menus.first.id.to_s,key)
        end
        if @first_menus.empty?
          @left_menus = nil
        else
          params[:pId] = params[:pId].gsub(/[ ]/, '+')
          p params[:pId]
          # params[:pId] = Base64.decode64 params[:pId].to_s
          params[:pId] = AES.decrypt(params[:pId].to_s,key)
          p params[:pId]
          @left_menus = Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.ins_admin_show=true and menus.parent_id=#{params[:pId]}")
          if @left_menus.empty?
            @left_menus = Menu.where(id:params[:pId])
          end
        end
      else
        @first_menus=Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from role2s r, role2_menus rm, admin2s_role2s ar, menus where rm.role2_id=ar.role2_id and rm.menu_id=menus.id and ar.admin2_id=#{admin_id} and menus.parent_id is null GROUP BY menus.id;")
        if (params[:pId].nil? || params[:pId] == '') && !@first_menus.empty?
          params[:pId] = AES.encrypt(@first_menus.first.id.to_s,key)
        end
        if @first_menus.empty?
          @left_menus = nil
        else
          params[:pId] = params[:pId].gsub(/[ ]/, '+')
          p params[:pId]
          # params[:pId] = Base64.decode64 params[:pId].to_s
          params[:pId] = AES.decrypt(params[:pId].to_s,key)
          p params[:pId]
          @left_menus = Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from role2s r, role2_menus rm, admin2s_role2s ar, menus where rm.role2_id=ar.role2_id and rm.menu_id=menus.id and ar.admin2_id=#{admin_id} and menus.parent_id=#{params[:pId]} GROUP BY menus.id;")
          if @left_menus.empty?
            @left_menus = Menu.where(id:params[:pId])
          end
        end
        # @first_menus=Menu.new.left_menu admin_id
      end
      #  @menus= [
      # {name: '父节点1',id:'1', children: [
      #     {name: '子节点1',id:2},
      #     {name: '子节点2',id:3}
      # ]} ];
      #@menus.as_json
      render template: 'home/index'
    else
      redirect_to '/sessions/sign_in'
    end
  end
end
