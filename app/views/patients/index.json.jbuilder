json.extract! @objJSON, :total,:rows,:page,:records
# json.array!(@patients) do |patient|
#   json.extract! patient, :id, :id, :name, :spell_code, :credential_type, :credential_type_number, :gender, :birthday, :birthplace, :address, :nationality, :citizenship, :province, :county, :photo, :marriage, :mobile_phone, :home_phone, :home_address, :contact, :contact_phone, :home_postcode, :email, :introduction, :patient_ids, :education, :household, :occupation, :orgnization, :orgnization_address, :insurance_type, :insurance_number, :doctor_id, :p_user_id, :wechat, :last_treat_time, :diseases_type, :is_public, :childbirth_date, :scan_code, :height, :verify_code, :is_activated, :is_checked, :verify_code_prit_count, :province_id, :city_id
#   json.url patient_url(patient, format: :json)
# end
