Rails.application.routes.draw do
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
      get 'get_provinces', to:'hospitals#get_provinces'
      get 'get_cities', to: 'hospitals#get_cities'
      post 'oper_action', to: 'hospitals#oper_action'
      get 'get_ranks', to:'hospitals#hospital_rank'
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
      get 'index_show', to: 'home_pages#show_index'
      post 'oper_action', to: 'home_pages#oper_action'
      post 'upload' => 'home_pages#upload'
      get 'home_page_manage',to:'home_pages#home_page_manage'
      post 'update',to:'home_pages#update'
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
      post 'save_template',to:'page_blocks#save_template'
      post 'update_template',to:'page_blocks#update_template'
      get 'get_doctors', to:'page_blocks#get_doctor_not_in_content'
    end
  end
  resources :apk_versions do
    collection do
      get 'index_show', to: 'apk_versions#show_index'
      post 'oper_action', to: 'apk_versions#oper_action'
      post 'batch_delete', to: 'apk_versions#batch_delete'
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
    end

  end
  resources :treatment_relationships do
    collection do
      get 'index_show', to: 'treatment_relationships#show_index'
      get 'get_patients', to: 'treatment_relationships#get_patients'
      post 'oper_action', to: 'treatment_relationships#oper_action'
      post 'batch_delete', to: 'treatment_relationships#batch_delete'
      get 'get_doctors', to: 'treatment_relationships#get_doctors'
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
      get 'get_hospitals', to:'doctors#get_hospitals'
      get 'get_departments', to:'doctors#get_departments'
      get 'get_doctor_to_page', to: 'doctors#get_doctor_to_page'
      get 'search_city', to:'doctors#search_city'
      get 'search_hospital', to:'doctors#search_hospital'
      get 'show_oth_doc', to:'doctors#show_oth_doc'
      get 'forDoctors', to: 'doctors#forDoctors'
      get 'matchDoctor', to: 'doctors#matchDoctor'
    end
  end

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
    end
  end

  resource :photos

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
