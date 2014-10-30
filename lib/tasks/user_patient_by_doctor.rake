#encoding:utf-8
namespace :db do
  task save_patient2user: :environment do
    save_user
    save_patient
  end
end

def save_user
  @doctors = Doctor.where('id not in (select doctor_id from users where doctor_id is not null)')
  @doctors.each do |doc|
    User.create( :name => doc.name, :password => 'mimas365', :password_confirmation => 'mimas365', :patient_id => nil, :doctor_id => doc.id, :nurse_id => nil, :is_enabled => true, :nick_name => doc.name, :real_name => doc.name, :verification_code => doc.credential_type_number, :mobile_phone => doc.mobile_phone, :email => doc.email, :credential_type_number => doc.credential_type)
  end
end

def save_patient
  @doctors = Doctor.where('patient_id is null')
  @doctors.each do |doc|
    @patient = Patient.create(:name => doc.name, :credential_type => doc.credential_type, :credential_type_number => doc.credential_type_number, :gender => doc.gender,
                              :birthday => doc.birthday, :birthplace => doc.birthplace, :province_id => doc.province_id, :city_id => doc.city_id, :hospital_id => doc.hospital_id,
                              :department_id => doc.department_id, :address => doc.address, :nationality => doc.nationality, :citizenship => doc.citizenship, :photo => doc.photo,
                              :marriage => doc.marriage, :mobile_phone => doc.mobile_phone, :home_phone => doc.home_phone, :home_address => doc.home_address, :contact => doc.contact,
                              :contact_phone => doc.contact_phone, :home_postcode => doc.home_postcode, :email => doc.email, :introduction => doc.introduction, :verify_code => doc.verify_code,
                              :is_checked => doc.is_checked, :is_activated => doc.is_activated, :is_public => doc.is_public, :spell_code => doc.spell_code, :province => doc.province_name)

    doc.update_attributes(:patient_id => @patient.id)
  end
end