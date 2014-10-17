Rails.application.routes.draw do
  resources :menu_permissions

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
      get 'show',to:'menus#show_menus'
      get 'menus_to_user',to:'menus#menus_to_user'
      match 'show_all_menus',to:'menus#show_all_menus', via: [:get, :post]
      get 'permissions_list',to:'menus#permissions_list'
      post 'drag', to:'menus#drag'
      get 'show_index', to:'menus#show_index'
      post 'oper_action', to: 'menus#oper_action'
      post 'remove_nodes', to: 'menus#remove_nodes'
      get 'form_name',to:'menus#form_name'
      get 'form_parent_menu', to:'menus#form_parent_menu'
      get 'form_priority',to:'menus#form_priority'
      get 'get_department', to:'menus#get_department'
    end
  end

  resources :role2s do
    collection do
      get 'show_index', to:'role2s#show_index'
      post 'oper_action', to:'role2s#oper_action'
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
