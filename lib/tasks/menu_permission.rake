#encoding:utf-8
namespace :db do
  task seed: :environment do
    meun_data
  end
end
def meun_data
  Menu.delete_all
  @menu1=Menu.create(
      name: '医生管理',
      parent_id:@menu4,
      table_name: 'doctors',
      model_class:'Doctor'

  )
  @menu2=Menu.create(
      name: '患者管理',
      parent_id:@menu4,
      table_name: 'patients',
      model_class:'Patient'
  )
  @menu3=Menu.create(
      name: '字典管理'
  )
  @menu4=Menu.create(
      name: '用户管理'
  )
  @menu5=Menu.create(
      name: '医院管理',
      table_name: 'hospitals',
      model_class:'Hospital'
  )
  @menu6=Menu.create(
      name: '科室管理',
      table_name: 'departments',
      model_class:'Doctor'
  )
  @menu7=Menu.create(
      name: '视频管理',
      table_name: 'edu_videos',
      model_class:'EduVideo'
  )
  @menu8=Menu.create(
      name: '文章管理',
      table_name: ''
  )
  @menu9=Menu.create(
      name: '孕育知识管理',
      table_name: ''
  )
  @menu10=Menu.create(
      name: '留言管理',
      table_name: ''
  )
  Admin2Menu.delete_all
  @menu_admin_1=Admin2Menu.create(
      admin2_id: @admin1,
      menu_id: @menu1
  )
  @menu_admin_2=Admin2Menu.create(
      admin2_id: @admin1,
      menu_id: @menu2
  )
  @menu_admin_3=Admin2Menu.create(
      admin2_id: @admin1,
      menu_id: @menu3
  )
  @menu_admin_4=Admin2Menu.create(
      admin2_id: @admin1,
      menu_id: @menu4
  )
  @menu_admin_5=Admin2Menu.create(
      admin2_id: @admin1,
      menu_id: @menu5
  )
  @menu_admin_6=Admin2Menu.create(
      admin2_id: @admin1,
      menu_id: @menu6
  )
  @menu_admin_7=Admin2Menu.create(
      admin2_id: @admin1,
      menu_id: @menu7
  )
  @menu_admin_8=Admin2Menu.create(
      admin2_id: @admin1,
      menu_id: @menu8
  )
  @menu_admin_9=Admin2Menu.create(
      admin2_id: @admin1,
      menu_id: @menu9
  )
  @menu_admin_10=Admin2Menu.create(
      admin2_id: @admin1,
      menu_id: @menu10
  )
  MenuPermission.delete_all
  @menu_permission1 = MenuPermission.create(
      admin2_id: @admin1,
      menu_id: @menu1,
      # is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1,
      menu_id: @menu2,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1,
      menu_id: @menu3,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1,
      menu_id: @menu4,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1,
      menu_id: @menu5,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1,
      menu_id: @menu6,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1,
      menu_id: @menu7,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1,
      menu_id: @menu8,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1,
      menu_id: @menu9,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1,
      menu_id: @menu10,
      is_manage:true
  )




end