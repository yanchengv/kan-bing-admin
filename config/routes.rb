Rails.application.routes.draw do

  get 'home_menu/create'
  resources :role2_menus do
    collection do
      get 'menus_to_roles', to: 'role2_menus#menus_to_roles'
    end
  end

  resources :menu_uris do
    collection do
      get 'show_index', to:'menu_uris#show_index'
      post 'oper_action', to: 'menu_uris#oper_action'
    end
  end

  resources :admin2s_role2s do
    collection do
      post 'authorization_create', to:'admin2s_role2s#authorization_create'
      delete 'remove_nodes', to:'admin2s_role2s#remove_nodes'
      get 'get_role2s', to:'admin2s_role2s#get_role2s'
    end
  end

  resources :menu_permissions do
    collection do
      post 'create_by_menu', to:'menu_permissions#create_by_menu'
    end
  end

  resources :admin2_menus do
    collection do
      post 'delete_nodes',to:'admin2_menus#delete_nodes'
    end
  end
  resources :hospitals do
    collection do
      get 'index_show', to:'hospitals#show_index'
      get 'index_show2',to:'hospitals#show_index_search'
      get 'get_provinces', to:'hospitals#get_provinces'
      get 'get_cities', to: 'hospitals#get_cities'
      post 'oper_action', to: 'hospitals#oper_action'
      get 'get_ranks', to:'hospitals#hospital_rank'
      post 'change_index_page', to: 'hospitals#change_index_page'
    end
  end
  resources :block_models do
    collection do
      get 'index_show', to: 'block_models#show_index'
      post 'oper_action', to: 'block_models#oper_action'
      post 'batch_delete', to: 'block_models#batch_delete'
    end
  end
  resources :block_contents do
    collection do
      get 'index_show', to: 'block_contents#show_index'
      post 'oper_action', to: 'block_contents#oper_action'
      post 'batch_delete', to: 'block_contents#batch_delete'
     # post 'save_content_to_block', to: 'block_contents#save_content_to_block'
      post 'save_pic', to: 'block_contents#save_pic'
      post 'save_pic_content', to: 'block_contents#save_pic_content'
      post 'save_doctors', to: 'block_contents#save_doctors'
      post 'edit_pic', to: 'block_contents#edit_pic'
      post 'upload_image', to: 'block_contents#upload_image'
      get 'get_doctors', to: 'block_contents#get_doctors'
      post 'delete_doctor', to:'block_contents#delete_doctor'
      post 'editor_upload' => 'block_contents#editor_upload'
      post 'save_alzs', to: 'block_contents#save_alzs'
      get 'edit_content', to:'block_contents#edit_content'
    end
  end
  resources :edu_videos do
    collection do
      get 'index_show', to: 'edu_videos#show_index'
      post 'oper_action', to: 'edu_videos#oper_action'
      post 'upload_image', to: 'edu_videos#upload_image'
      post 'upload_video', to: 'edu_videos#upload_video'
      get 'get_doctors', to: 'edu_videos#get_doctors'
      get 'get_video_types', to:'edu_videos#get_video_types'
      post 'upload', to: 'edu_videos#upload'
      post 'upload_image', to: 'edu_videos#upload_image'
      get 'new_video', to:'edu_videos#new_video'
      post 'edit_video', to: 'edu_videos#edit_video'
      post 'video_edit', to:'edu_videos#video_edit'
      post 'upload_video2', to: 'edu_videos#upload_video2'
      post 'video_delete', to:'edu_videos#video_delete'
      get 'search_department', to:'edu_videos#search_department'
      get 'search_doctor', to:'edu_videos#search_doctor'
    end
  end
  resources :video_types do
    collection do
      get 'index_show', to: 'video_types#show_index'
      post 'oper_action', to: 'video_types#oper_action'
    end
  end
  resources :home_pages do
    collection do
=begin
      get 'index_show', to: 'home_pages#show_index'
      post 'oper_action', to: 'home_pages#oper_action'
      post 'upload' => 'home_pages#upload'
      get 'home_page_manage',to:'home_pages#home_page_manage'
      post 'update',to:'home_pages#update'
=end
    end
  end
  resources :page_blocks do
    collection do
      get 'index_show', to: 'page_blocks#show_index'
      post 'oper_action', to: 'page_blocks#oper_action'
      get 'page_block_manage', to: 'page_blocks#page_blocks_manage'
      post 'update',to:'page_blocks#update'
      post 'update_position',to:'page_blocks#update_position'
      get 'page_blocks_setting',to:'page_blocks#page_blocks_setting'
      post 'change_is_show', to: 'page_blocks#change_is_show'
      get 'get_template',to:'page_blocks#get_template'
      get 'add_content',to:'page_blocks#add_content_template'
      get 'add_content2',to:'page_blocks#add_content_template'
      post 'save_template',to:'page_blocks#save_template'
      post 'update_template',to:'page_blocks#update_template'
      get 'get_doctors', to:'page_blocks#get_doctor_not_in_content'
      get 'get_doctor_list', to:'page_blocks#get_doctor_list'
    end
  end
  resources :apk_versions do
    collection do
      get 'index_show', to: 'apk_versions#show_index'
      post 'oper_action', to: 'apk_versions#oper_action'
      post 'batch_delete', to: 'apk_versions#batch_delete'
    end
  end
  resources :organizations do
    collection do
      get 'index_show', to: 'organizations#show_index'
      post 'oper_action', to: 'organizations#oper_action'
      post 'batch_delete', to: 'organizations#batch_delete'
    end
  end
  resources :advice_types do
    collection do
      get 'index_show', to: 'advice_types#show_index'
      post 'oper_action', to: 'advice_types#oper_action'
    end
  end
  resources :diagnose_types do
    collection do
      get 'index_show', to: 'diagnose_types#show_index'
      post 'oper_action', to: 'diagnose_types#oper_action'
    end
  end
  resources :medical_advices do
    collection do
      get 'index_show', to: 'medical_advices#show_index'
      post 'oper_action', to: 'medical_advices#oper_action'
      post 'batch_delete', to: 'medical_advices#batch_delete'
      get 'get_advice_types', to: 'medical_advices#get_advice_types'
    end
  end
  resources :medical_diagnoses do
    collection do
      get 'index_show', to: 'medical_diagnoses#show_index'
      post 'oper_action', to: 'medical_diagnoses#oper_action'
      post 'batch_delete', to: 'medical_diagnoses#batch_delete'
      get 'get_diagnose_types', to: 'medical_diagnoses#get_diagnose_types'
    end
  end
  resources :skills do
    collection do
      get 'index_show', to: 'skills#show_index'
      post 'oper_action', to: 'skills#oper_action'
      post 'batch_delete', to: 'skills#batch_delete'
      get 'get_groups', to: 'skills#get_groups'
      get 'group_list', to:'skills#group_list'
      get 'get_unrelated_groups', to: 'skills#get_unrelated_groups'
      get 'doctor_list', to:'skills#doctor_list'
      post 'add_skill_group', to: 'skills#add_skill_group'
      post 'del_group_skill', to: 'skills#del_group_skill'
      get 'get_unrelated_doctors', to: 'skills#get_unrelated_doctors'
      post 'save_doctors', to: 'skills#save_doctors'
      get 'get_doctors', to: 'skills#get_doctors'
      post 'del_doctor_skill', to: 'skills#del_doctor_skill'
    end
  end
  resources :groups do
    collection do
      get 'index_show', to: 'groups#show_index'
      post 'oper_action', to: 'groups#oper_action'
      post 'batch_delete', to: 'groups#batch_delete'
      get 'doctor_list', to: 'groups#doctor_list'
      get 'get_doctors', to: 'groups#get_doctors'
      get 'get_unrelated_doctors', to: 'groups#get_unrelated_doctors'
      post 'save_doctors', to: 'groups#save_doctors'
      post 'del_doctor_group', to: 'groups#del_doctor_group'
    end
  end
  resources :departments do
    collection do
      get 'index_show', to: 'departments#show_index'
      post 'oper_action', to: 'departments#oper_action'
    end
  end
  resources :users do
    collection do
      get 'index_show', to: 'users#show_index'
      post 'oper_action', to: 'users#oper_action'
      get 'get_doctors', to: 'users#get_doctors'
      get 'get_patients', to: 'users#get_patients'
      post 'change_state', to: 'users#change_state'
      post 'batch_delete', to: 'users#batch_delete'
    end
  end
  resources :menus do
    collection do
      get 'show',to:'menus#role_manage'
      get 'menus_to_user',to:'menus#menus_to_user'
      match 'show_all_menus',to:'menus#show_all_menus', via: [:get, :post]
      get 'permissions_list',to:'menus#permissions_list'
      post 'drag', to:'menus#drag'
      get 'show_index', to:'menus#show_index'
      post 'oper_action', to: 'menus#oper_action'
      delete 'remove_nodes', to: 'menus#remove_nodes'
      get 'form_name',to:'menus#form_name'
      get 'form_parent_menu', to:'menus#form_parent_menu'
      get 'form_priority',to:'menus#form_priority'
      get 'get_department', to:'menus#get_department'
      put 'update_menu', to:'menus#update_menu'
      delete 'remove_nodes2', to: 'menus#remove_nodes2'
      post 'drag2', to:'menus#drag2'
      get 'left_menu',to:'menus#left_menu'
      get 'set_menus_show',to:'menus#set_menus_show'
    end
  end

  resources :role2s do
    collection do
      get 'role2_show',to:'role2s#curr_roles'
      get 'show_index', to:'role2s#show_index'
      post 'oper_action', to:'role2s#oper_action'
      put 'update_name', to:'role2s#update_name'
    end
  end

  resources :consult_accuses do
    collection do
      get 'get_accuses', to: 'consult_accuses#get_accuses'
      get 'index_accuses', to:'consult_accuses#index_accuses'
      get 'index_results', to:'consult_accuses#index_results'
      post 'cusult_oper_action', to: 'consult_accuses#oper_action'
    end

  end
  resources :doctor_friendships do
    collection do
      get 'index_show', to: 'doctor_friendships#show_index'
      post 'oper_action', to:'doctor_friendships#oper_action'
      post 'batch_delete', to: 'doctor_friendships#batch_delete'
      get 'get_doctors', to: 'doctor_friendships#get_doctors'
      get 'get_provinces', to: 'doctor_friendships#get_provinces'
      get 'get_cities', to: 'doctor_friendships#get_cities'
      get 'get_hospitals', to: 'doctor_friendships#get_hospitals'
      get 'get_departments', to: 'doctor_friendships#get_departments'
      post 'save_friendship', to: 'doctor_friendships#save_friendship'
    end

  end
  resources :treatment_relationships do
    collection do
      get 'index_show', to: 'treatment_relationships#show_index'
      get 'get_patients', to: 'treatment_relationships#get_patients'
      post 'oper_action', to: 'treatment_relationships#oper_action'
      post 'batch_delete', to: 'treatment_relationships#batch_delete'
      post 'save_relationship', to: 'treatment_relationships#save_relationship'
      get 'get_main_relations', to: 'treatment_relationships#get_main_relations'
      post 'delete_main_associate', to: 'treatment_relationships#delete_main_associate'
    end

  end
  resources :dictionaries do
    collection do
      get 'index_show', to: 'dictionaries#show_index'
      post 'oper_action', to: 'dictionaries#oper_action'
    end
  end
  resources :dictionary_types do
    collection do
      get 'index_show', to: 'dictionary_types#show_index'
      post 'oper_action', to: 'dictionary_types#oper_action'
    end
  end
  resources :national_informations do
    collection do
      get 'index_show', to: 'national_informations#show_index'
      post 'oper_action', to: 'national_informations#oper_action'
      get 'get_nationality', to:'national_informations#get_nationality'
    end
  end
  resources :pregnancy_knowledges do
    collection do
      get 'index_show', to: 'pregnancy_knowledges#show_index'
      post 'oper_action', to: 'pregnancy_knowledges#oper_action'
    end
  end
  resources :provinces do
    collection do
      get 'test_index', to:'provinces#test_index'
      post 'oper_action', to:'provinces#oper_action'
    end
  end

  resources :cities do
    collection do
      get 'cities/:province_id', to: 'cities#index'
      get 'test_index', to:'cities#test_index'
      post 'oper_action', to:'cities#oper_action'
    end
  end

  resources :counties do
    collection do
      get 'counties/:city_id', to: 'counties#index'
      get 'test_index', to:'counties#test_index'
      post 'oper_action', to:'counties#oper_action'
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'home#index'
  resources :sessions do
    collection do
      delete 'sign_out',to:'sessions#destroy'
      post 'create'
      get 'sign_in',to:'sessions#sign_page'
    end
  end
  get 'home/index2',to:'home#index2'
  resources :admin2s do
    collection do
      get 'setting', to:'admin2s#setting'
      post 'password_update', to:'admin2s#password_update'
      get 'test_index', to:'admin2s#test_index'
      post 'oper_action', to:'admin2s#oper_action'
      get 'get_by_email', to:'admin2s#get_by_email'
      get 'get_admin2', to:'admin2s#get_admin2'
      get 'get_admin_type', to: 'admin2s#get_admin_type'
      get 'web_admin_show', to:'admin2s#web_admin_show'
      get 'check_old_pwd', to:'admin2s#check_old_pwd'
      get 'get_ins_hos', to:'admin2s#get_ins_hos'
    end
  end

  resources :doctors do
    collection do
      get 'get_department', to:'doctors#get_department'
      get 'get_hospital', to:'doctors#get_hospital'
      get 'get_city', to:'doctors#get_city'
      get 'is_executable', to:'doctors#is_executable'
      get 'send_email', to:'doctors#send_email'
      get 'send_phone', to:'doctors#send_phone'
      get 'search_department', to:'doctors#search_department'
      get 'is_permission', to:'doctors#is_permission'
      get 'show_index', to:'doctors#show_index'
      get 'get_doc_by_priority', to:'doctors#get_doc_by_priority'
      get 'check_phone', to:'doctors#check_phone'
      get 'check_email', to:'doctors#check_email'
      get 'check_credential_type_number', to:'doctors#check_credential_type_number'
      get 'get_organizations', to:'doctors#get_organizations'
      get 'get_hospitals', to:'doctors#get_hospitals'
      get 'get_departments', to:'doctors#get_departments'
      get 'get_doctor_to_page', to: 'doctors#get_doctor_to_page'
      get 'search_city', to:'doctors#search_city'
      get 'search_hospital', to:'doctors#search_hospital'
      get 'show_oth_doc', to:'doctors#show_oth_doc'
      get 'forDoctors', to: 'doctors#forDoctors'
      get 'matchDoctor', to: 'doctors#matchDoctor'
      post 'delete_image', to:'doctors#delete_image'
    end
  end
  mount Jsdicom::Engine, :at => '/dicom'
  resources :patients do
    collection do
      get 'get_department', to:'doctors#get_department'
      get 'get_hospital', to:'doctors#get_hospital'
      get 'get_city', to:'doctors#get_city'
      get 'is_executable', to:'patients#is_executable'
      get 'send_email', to:'patients#send_email'
      get 'send_phone', to:'patients#send_phone'
      get 'search_department', to:'patients#search_department'
      get 'is_permission', to:'patients#is_permission'
      get 'show_index', to:'patients#show_index'
      get 'check_phone', to:'patients#check_phone'
      get 'check_email', to:'patients#check_email'
      get 'check_credential_type_number', to:'patients#check_credential_type_number'
      post 'delete_image', to:'patients#delete_image'
      get 'show_oth_pat', to:'patients#show_oth_pat'
      get 'forPatients', to: 'patients#forPatients'
      get 'matchPatient', to: 'patients#matchPatient'
    end
  end

  resource :domain do
    collection do
        post 'create',to:'domain#create'
        get 'destroy',to:'domain#destroy'
        post 'update',to:'domain#update'
       get 'show',to:'domain#show'
      get 'domain_list',to:'domain#domain_list'
      post 'oper_action',to:'domain#oper_action'
      post 'upload_logo',to:'domain#upload_logo'
      post 'save_logo',to:'domain#save_logo'
      post 'update_footer',to:'domain#update_footer'
    end
  end

  resource :photos

  resource :home_menu do
  collection do
    get 'new',to:'home_menu#new'
    get 'show',to:'home_menu#show'
    post 'create',to:'home_menu#create'
    get 'edit',to:'home_menu#edit'
    post 'save',to: 'home_menu#save'
    delete 'destroy',to:'home_menu#destroy'
    get 'check_url', to:'home_menu#check_url'
  end
  end
  resource :home_pages

  resources :health_records do
    collection do
      get 'index', to:'health_records#index'
      get 'show_index', to:'health_records#show_index'

      post '/ct2',to: 'health_records#ct2'
      post '/mri2',to: 'health_records#mri2'
      post '/ultrasound2',to: 'health_records#ultrasound2'
      post '/inspection_report2',to: 'health_records#inspection_report2'
      post '/ecg2',to: 'health_records#ecg2'
      post '/dicom',to:'health_records#dicom'
      post '/get_data',to: 'health_records#get_data'
      # post '/undefined_other', to: 'health_records#undefined_other'

      get 'go_where', to: 'health_records#go_where'
      get '/play_video', to: 'health_records#play_video'
      get '/ct', to: 'health_records#ct'
      get '/get_video', to: 'health_records#get_video'
      get '/inspection_report', to: 'health_records#inspection_report'
      get 'mri',to:'health_records#mri'
      get '/ultrasound', to: 'health_records#ultrasound'

      post '/health_record_new', to: 'health_records#health_record_new'
      post '/ultrasound_save', to: 'health_records#ultrasound_save'
      get 'health_record_edit', to: 'health_records#health_record_edit'
      post '/ultrasound_update', to: 'health_records#ultrasound_update'
      post 'upload_dicom',to:'health_records#upload_dicom'
      get 'show_upload_dicom',to:'health_records#show_upload_dicom'

      delete 'ultrasound_delete', to:'health_records#ultrasound_delete'
    end
  end

  # 心电图
  resource :ecg do
    collection do
      get 'show2',to:'ecg#show2'
      post 'ecg_list',to:'ecg#ecg_list'
      get 'show',to:'ecg#show'
      post 'create',to:'ecg#create'
      get 'delete',to:'ecg#delete'
    end
  end


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
