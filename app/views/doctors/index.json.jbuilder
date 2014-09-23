json.array!(@doctors) do |doctor|
  json.extract! doctor, :id, :name, :credential_type, :credential_type_number, :gender, :birthday, :birthplace, :province_id, :city_id,:hospital_id,:department_id,:mobile_phone,:email,:professional_title,:introduction
  json.url doctor_url(doctor, format: :json)
end
