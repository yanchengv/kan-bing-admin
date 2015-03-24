# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( ui-dialog.css )
Rails.application.config.assets.precompile += %w( dialog-min.js )
Rails.application.config.assets.precompile += %w( update_password.js )
Rails.application.config.assets.precompile += %w( ajax_image_crop_upload.js )
Rails.application.config.assets.precompile += %w( pat_ajax_image_crop_upload.js)
Rails.application.config.assets.precompile += %w( health_records.js)
Rails.application.config.assets.precompile += %w( paginate.js)
Rails.application.config.assets.precompile += ['jquery.fancybox-1.3.1.pack.js','fancybox.css','aes.js']
# Rails.application.config.assets.precompile += %w(  domain_manage.js)

Rails.application.config.assets.precompile += ['page_blocks/*','domain_manage.js','home_menu/*','menus/*']
