#encoding:utf-8
namespace :db do
  task seed: :environment do
    # meun_data
  end
end
def meun_data
  Menu.delete_all
  @menu1=Menu.create(
      name: '基础信息',
      parent_id: @menu6.id,
      table_name: 'dictionaries',
      model_class: 'Dictionary',
      uri: '/dictionaries'

  )
  @menu3=Menu.create(
      name: '医生管理',
      parent_id: @menu17.id,
      table_name: 'doctors',
      model_class: 'Doctor',
      uri: '/doctors'

  )
  @menu18=Menu.create(
      name: '用户管理',
      parent_id:@menu17.id,
      table_name: 'users',
      model_class:'User',
      uri:'/users'
  )

  @menu4=Menu.create(
      name: '患者管理',
      parent_id: @menu17.id,
      table_name: 'patients',
      model_class:'Patient',
      uri:'/patients'
  )
  @menu5=Menu.create(
      name: '管理员管理',
      parent_id: @menu17.id,
      table_name: 'admin2s',
      model_class:'Admin2',
      uri: '/admin2s'
  )
  @menu6=Menu.create(
      name: '字典管理'
  )

  @menu7=Menu.create(
      name: '医院管理',
      parent_id: @menu6.id,
      table_name: 'hospitals',
      model_class:'Hospital'
  )
  #@menu6=Menu.create(
  #    name: '科室管理',
  #    table_name: 'departments',
  #    model_class:'Doctor'
  #)
  @menu9=Menu.create(
      name: '视频管理',
      parent_id: @menu10.id,
      table_name: 'edu_videos',
      model_class:'EduVideo'
  )
  @menu10=Menu.create(
      name: '文章管理',
      table_name: ''
  )
  @menu11=Menu.create(
      parent_id: @menu10.id,
      name: '孕育知识管理',
      table_name: ''
  )
  @menu12=Menu.create(
      name: '留言管理',
      parent_id: @menu10.id,
      table_name: 'consult_accuses',
      model_class: 'ConsultAccuse',
      uri: '/consult_accuses'
  )
  @menu13=Menu.create(
      name: '权限管理',
      table_name: 'menus',
      model_class:'Menu',
      uri:'/'
  )
  @menu14=Menu.create(
      name: '模块管理',
      parent_id:@menu13.id,
      table_name: 'menus',
      model_class:'Menu',
      uri:'/menus/show'
  )
  @menu15=Menu.create(
      name: '角色管理',
      parent_id:@menu13.id,
      table_name: 'menus',
      model_class:'Menu',
      uri:'/'
  )
  @menu16=Menu.create(
      name: '地域信息管理',
      parent_id: @menu6.id,
      table_name: 'menus',
      model_class: 'Menu',
      uri: '/provinces'
  )
  @menu17=Menu.create(
      name: '人员管理'
  )
  @menu18=Menu.create(
      name: '用户管理',
      parent_id: @menu17.id,
      table_name: 'users',
      model_class: 'User',
      uri: '/users'
  )
  @menu19=Menu.create(
      name: '用户关系'
  )
  @menu20=Menu.create(
      name: '医友关系',
      parent_id: @menu19.id,
      table_name: 'doctor_friendships',
      model_class: 'DoctorFriendships',
      uri: '/doctor_friendships'
  )
  @menu21=Menu.create(
      name: '医患关系',
      parent_id: @menu19.id,
      table_name: 'treatment_relationships',
      model_class: 'TreatmentRelationships',
      uri: '/treatment_relationships'
  )
  @menu23=Menu.create(
      name: '移动端管理'
  )
  @menu22=Menu.create(
      name: 'apk版本管理',
      parent_id: @menu23.id,
      table_name: 'apk_versions',
      model_class: 'ApkVersions',
      uri: '/apk_versions'
  )
  @menu24=Menu.create(
      name: '国家信息',
      parent_id: @menu6.id,
      table_name: 'national_informations',
      model_class: 'NationalInformation',
      uri: '/national_informations'
  )
  @menu27=Menu.create(
      name: '视频管理'
  )
  @menu28=Menu.create(
      name: '视频类型管理',
      parent_id: @menu27.id,
      table_name: 'video_types',
      model_class: 'VideoType',
      uri: '/video_types'
  )
  @menu29=Menu.create(
      name: '教育视频管理',
      parent_id: @menu27.id,
      table_name: 'edu_videos',
      model_class: 'EduVideo',
      uri: '/edu_videos'
  )
  Admin2Menu.delete_all
  @menu_admin_1=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu3.id
  )
  @menu_admin_2=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu4.id
  )
  @menu_admin_3=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu6.id
  )
  @menu_admin_4=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu17.id
  )
  @menu_admin_5=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu7.id
  )
  @menu_admin_6=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu10.id
  )
  @menu_admin_7=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu12.id
  )
  @menu_admin_8=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu13.id
  )
  @menu_admin_9=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu5.id
  )
  @menu_admin_10=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu14.id
  )
  @menu_admin_11=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu15.id
  )
  @menu_admin_12=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu9.id
  )
  @menu_admin_13=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu11.id
  )

  @menu_admin_14=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu16.id
  )
  @menu_admin_15=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu27.id
  )
  @menu_admin_16=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu28.id
  )
  @menu_admin_17=Admin2Menu.create(
      admin2_id: @admin1.id,
      menu_id: @menu29.id
  )
  MenuPermission.delete_all
  @menu_permission1 = MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu3.id,
      hospital_id:2
      # is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu3.id,
      is_manage:true,
      hospital_id:1
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu4.id,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu6.id,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu1.id,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu7.id,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu8.id,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu9.id,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu10.id,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu11.id,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu12.id,
      is_manage:true
  )

  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu13.id,
      is_manage:true
  )

  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu2.id,
      is_manage:true
  )

  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu5.id,
      is_manage:true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu17.id,
      is_manage: true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu18.id,
      is_manage: true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu19.id,
      is_manage: true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu20.id,
      is_manage: true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu21.id,
      is_manage: true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu22.id,
      is_manage: true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu23.id,
      is_manage: true
  )
  MenuPermission.create(
      admin2_id: @admin1.id,
      menu_id: @menu24.id,
      is_manage: true
  )

end