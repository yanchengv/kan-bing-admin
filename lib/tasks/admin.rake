#encoding:utf-8
namespace :db do
  task seed: :environment do
    admin_data
  end
end

def admin_data
  Admin2.delete_all
  @admin1=Admin2.create(
      name: 'admin',
      email:'773198076@qq.com',
      password:'mimas365'
  )

end