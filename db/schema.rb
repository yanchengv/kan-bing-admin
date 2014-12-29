# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141229024447) do

  create_table "admin2_menus", force: true do |t|
    t.integer  "admin2_id"
    t.integer  "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admin2s", force: true do |t|
    t.string   "name",                             default: "", null: false
    t.string   "mobile_phone"
    t.string   "password_digest",                  default: "", null: false
    t.string   "remember_token"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                  default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo"
    t.string   "email"
    t.integer  "hospital_id",            limit: 8
    t.integer  "department_id",          limit: 8
    t.string   "admin_type"
    t.string   "introduction"
  end

  add_index "admin2s", ["confirmation_token"], name: "index_admin2s_on_confirmation_token", unique: true, using: :btree
  add_index "admin2s", ["name"], name: "index_admin2s_on_name", unique: true, using: :btree
  add_index "admin2s", ["reset_password_token"], name: "index_admin2s_on_reset_password_token", unique: true, using: :btree
  add_index "admin2s", ["unlock_token"], name: "index_admin2s_on_unlock_token", unique: true, using: :btree

  create_table "admin2s_role2s", force: true do |t|
    t.integer  "admin2_id"
    t.integer  "role2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "admins_roles", id: false, force: true do |t|
    t.integer "admin_id"
    t.integer "role_id"
  end

  add_index "admins_roles", ["admin_id", "role_id"], name: "index_admins_roles_on_admin_id_and_role_id", using: :btree

  create_table "adresults", force: true do |t|
    t.integer  "doctor_id",     limit: 8
    t.string   "hosp_name"
    t.string   "province_name"
    t.string   "city_name"
    t.string   "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apk_versions", force: true do |t|
    t.string   "version_num"
    t.string   "version_url"
    t.text     "description"
    t.datetime "update_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointment_arranges", force: true do |t|
    t.integer  "schedule_id",        limit: 8
    t.string   "time_arrange"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doctor_id",          limit: 8
    t.date     "schedule_date"
    t.integer  "status"
    t.integer  "modality_device_id"
  end

  create_table "appointment_avalibles", force: true do |t|
    t.integer  "avalibledoctor_id",       limit: 8
    t.date     "avalibleappointmentdate"
    t.integer  "avalibletimeblock"
    t.integer  "avaliblecount"
    t.integer  "schedule_id"
    t.integer  "dictionary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointment_schedules", force: true do |t|
    t.integer  "doctor_id",      limit: 8
    t.date     "schedule_date"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "avalailbecount"
    t.integer  "status",                   default: 1
    t.integer  "remaining_num"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointmentblacklists", force: true do |t|
    t.integer  "patient_id",  limit: 8
    t.datetime "unlock_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "appointments", force: true do |t|
    t.integer  "patient_id",              limit: 8
    t.integer  "doctor_id",               limit: 8
    t.date     "appointment_day"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "status"
    t.integer  "hospital_id"
    t.integer  "department_id"
    t.integer  "appointment_schedule_id", limit: 8
    t.integer  "dictionary_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "appointment_arrange_id",  limit: 8
    t.string   "patient_name"
    t.string   "doctor_name"
    t.string   "hospital_name"
    t.string   "department_name"
    t.string   "dictionary_name"
  end

  add_index "appointments", ["appointment_arrange_id"], name: "index_appointments_on_appointment_arrange_id", using: :btree

  create_table "archive_queues", force: true do |t|
    t.integer  "upload_user_id",   limit: 8
    t.string   "upload_user_name"
    t.string   "parent_type"
    t.string   "child_type"
    t.string   "filename"
    t.string   "filesize"
    t.string   "extname"
    t.integer  "hospital_id",      limit: 8
    t.string   "hospital_name"
    t.integer  "department_id",    limit: 8
    t.string   "department_name"
    t.integer  "doctor_id",        limit: 8
    t.string   "doctor_name"
    t.integer  "patient_id",       limit: 8
    t.string   "patient_name"
    t.integer  "status",                     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assessments", force: true do |t|
    t.integer  "user_id",         limit: 8
    t.integer  "empirical_value"
    t.text     "note"
    t.string   "type",                      default: "Assessment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "basic_health_records", force: true do |t|
    t.integer  "patient_id",           limit: 8, null: false
    t.string   "blood_type"
    t.string   "allergy_history"
    t.string   "vaccination_history"
    t.string   "disease_history"
    t.string   "heredopathia_history"
    t.string   "health_risk_factor"
    t.boolean  "is_handicapped"
    t.string   "handicap_card_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stature"
  end

  add_index "basic_health_records", ["patient_id"], name: "index_basic_health_records_on_patient_id", using: :btree

  create_table "bfrs", force: true do |t|
    t.integer  "patient_id",    limit: 8
    t.string   "measure_value"
    t.datetime "measure_time"
    t.string   "mdevice"
    t.boolean  "is_true"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "block_contents", force: true do |t|
    t.string   "block_name"
    t.string   "title"
    t.text     "content"
    t.string   "url"
    t.string   "block_type"
    t.date     "create_date"
    t.integer  "block_id",    limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_url"
    t.string   "subtitle"
  end

  create_table "block_models", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "desc"
    t.text     "example"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blood_fats", force: true do |t|
    t.integer  "patient_id",        limit: 8
    t.string   "total_cholesterol"
    t.string   "triglyceride"
    t.string   "high_lipoprotein"
    t.string   "low_lipoprotein"
    t.date     "measure_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_sure",                     default: true
  end

  create_table "blood_glucoses", force: true do |t|
    t.integer  "patient_id",    limit: 8
    t.string   "measure_value"
    t.date     "measure_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mdevice"
    t.datetime "measure_time"
    t.boolean  "is_sure",                 default: true
  end

  create_table "blood_oxygens", force: true do |t|
    t.integer  "patient_id",   limit: 8
    t.string   "pulse_rate"
    t.string   "o_saturation"
    t.string   "pi"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mdevice"
    t.datetime "measure_time"
    t.boolean  "is_sure",                default: true
  end

  create_table "blood_pressures", force: true do |t|
    t.integer  "patient_id",         limit: 8
    t.string   "systolic_pressure"
    t.date     "measure_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "diastolic_pressure"
    t.string   "mdevice"
    t.datetime "measure_time"
    t.string   "heart_rate"
    t.boolean  "is_sure",                      default: true
  end

  create_table "bmes", force: true do |t|
    t.integer  "patient_id",    limit: 8
    t.string   "measure_value"
    t.datetime "measure_time"
    t.string   "mdevice"
    t.boolean  "is_true"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bmis", force: true do |t|
    t.integer  "patient_id",    limit: 8
    t.string   "measure_value"
    t.datetime "measure_time"
    t.string   "mdevice"
    t.boolean  "is_true"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "body_ages", force: true do |t|
    t.integer  "patient_id",    limit: 8
    t.string   "measure_value"
    t.datetime "measure_time"
    t.string   "mdevice"
    t.boolean  "is_true"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", force: true do |t|
    t.integer  "consultation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cons_orders", force: true do |t|
    t.text     "reason"
    t.string   "status"
    t.string   "status_description"
    t.integer  "owner_id",           limit: 8
    t.integer  "consignee_id",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cons_reports", force: true do |t|
    t.integer  "consultation_id"
    t.text     "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consult_accuses", force: true do |t|
    t.text     "reason"
    t.integer  "created_by",  limit: 8
    t.integer  "question_id"
    t.integer  "result_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consult_questions", force: true do |t|
    t.text     "consult_content"
    t.integer  "consulting_by",    limit: 8
    t.integer  "created_by",       limit: 8
    t.integer  "consult_identity"
    t.integer  "privilege_view",             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consult_results", force: true do |t|
    t.text     "respond_content"
    t.integer  "created_by",       limit: 8
    t.integer  "respond_identity"
    t.integer  "consult_id"
    t.integer  "privilege_view",             default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consultation_create_records", force: true do |t|
    t.integer  "consultation_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consultation_create_records", ["consultation_id"], name: "index_consultation_create_records_on_consultation_id", using: :btree

  create_table "consultations", force: true do |t|
    t.integer  "owner_id",           limit: 8
    t.integer  "patient_id",         limit: 8
    t.string   "name"
    t.text     "init_info"
    t.text     "purpose"
    t.string   "status"
    t.string   "status_description"
    t.string   "number"
    t.datetime "start_time"
    t.datetime "schedule_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "counties", force: true do |t|
    t.string   "name"
    t.integer  "city_id"
    t.integer  "province_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name",                      null: false
    t.string   "short_name"
    t.integer  "hospital_id",     limit: 8
    t.text     "description"
    t.string   "phone_number"
    t.string   "spell_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_type"
    t.integer  "state"
    t.integer  "sort"
    t.integer  "province_id"
    t.integer  "city_id"
  end

  add_index "departments", ["hospital_id"], name: "index_departments_on_hospital_id", using: :btree
  add_index "departments", ["name"], name: "index_departments_on_name", using: :btree
  add_index "departments", ["short_name"], name: "index_departments_on_short_name", using: :btree
  add_index "departments", ["spell_code"], name: "index_departments_on_spell_code", using: :btree

  create_table "departments_managers", force: true do |t|
    t.integer  "department_id", limit: 8
    t.integer  "manager_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dictionaries", force: true do |t|
    t.integer  "dictionary_type_id"
    t.string   "name"
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dictionary_types", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doc_list_for_orders", force: true do |t|
    t.integer  "docmember_id",  limit: 8
    t.integer  "cons_order_id"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doc_list_for_orders", ["docmember_id", "cons_order_id"], name: "index_doc_list_for_orders_on_docmember_id_and_cons_order_id", unique: true, using: :btree
  add_index "doc_list_for_orders", ["docmember_id"], name: "index_doc_list_for_orders_on_docmember_id", using: :btree

  create_table "doctor_friendships", force: true do |t|
    t.integer  "doctor1_id", limit: 8
    t.integer  "doctor2_id", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doctor_friendships", ["doctor1_id"], name: "index_doctor_friendships_on_doctor1_id", using: :btree
  add_index "doctor_friendships", ["doctor2_id"], name: "index_doctor_friendships_on_doctor2_id", using: :btree

  create_table "doctor_lists", force: true do |t|
    t.integer  "docmember_id",    limit: 8
    t.integer  "consultation_id"
    t.boolean  "confirmed",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doctor_lists", ["consultation_id"], name: "index_doctor_lists_on_consultation_id", using: :btree
  add_index "doctor_lists", ["docmember_id", "consultation_id"], name: "index_doctor_lists_on_docmember_id_and_consultation_id", unique: true, using: :btree

  create_table "doctors", force: true do |t|
    t.string   "name",                                                null: false
    t.string   "spell_code"
    t.string   "credential_type"
    t.string   "credential_type_number"
    t.string   "gender",                           default: "男",      null: false
    t.date     "birthday"
    t.string   "birthplace"
    t.string   "address"
    t.string   "nationality"
    t.string   "citizenship"
    t.string   "province"
    t.string   "county"
    t.string   "photo"
    t.string   "marriage"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "home_address"
    t.string   "contact"
    t.string   "contact_phone"
    t.string   "home_postcode"
    t.string   "email"
    t.text     "introduction"
    t.integer  "hospital_id",            limit: 8
    t.integer  "department_id",          limit: 8
    t.string   "professional_title"
    t.string   "position"
    t.date     "hire_date"
    t.string   "certificate_number"
    t.text     "expertise"
    t.text     "degree"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_control",                       default: false
    t.string   "type",                             default: "Doctor"
    t.string   "code"
    t.string   "dictionary_ids"
    t.string   "photo_path"
    t.string   "graduated_from"
    t.date     "graduated_at"
    t.text     "research_paper"
    t.string   "wechat"
    t.integer  "is_public",                        default: 0
    t.string   "hospital_name"
    t.string   "department_name"
    t.string   "province_name"
    t.string   "city_name"
    t.text     "rewards"
    t.string   "verify_code"
    t.integer  "is_activated",                     default: 0
    t.integer  "is_checked"
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "patient_id",             limit: 8
    t.integer  "is_expert"
    t.string   "other_links"
    t.integer  "sort"
    t.boolean  "indexpage"
  end

  add_index "doctors", ["credential_type_number"], name: "index_doctors_on_credential_type_number", using: :btree
  add_index "doctors", ["department_id"], name: "index_doctors_on_department_id", using: :btree
  add_index "doctors", ["gender"], name: "index_doctors_on_gender", using: :btree
  add_index "doctors", ["hospital_id"], name: "index_doctors_on_hospital_id", using: :btree
  add_index "doctors", ["mobile_phone"], name: "index_doctors_on_mobile_phone", using: :btree
  add_index "doctors", ["name"], name: "index_doctors_on_name", using: :btree
  add_index "doctors", ["professional_title"], name: "index_doctors_on_professional_title", using: :btree
  add_index "doctors", ["spell_code"], name: "index_doctors_on_spell_code", using: :btree
  add_index "doctors", ["wechat"], name: "index_doctors_on_wechat", using: :btree

  create_table "doctors_skills", id: false, force: true do |t|
    t.integer "doctor_id"
    t.integer "skill_id"
  end

  create_table "document_categories", force: true do |t|
    t.string   "ids"
    t.string   "name"
    t.boolean  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_templates", force: true do |t|
    t.integer  "department_id", null: false
    t.string   "name",          null: false
    t.string   "category",      null: false
    t.string   "sub_category",  null: false
    t.text     "content",       null: false
    t.integer  "creator",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "document_templates", ["category"], name: "index_document_templates_on_category", using: :btree
  add_index "document_templates", ["creator"], name: "index_document_templates_on_creator", using: :btree
  add_index "document_templates", ["department_id"], name: "index_document_templates_on_department_id", using: :btree
  add_index "document_templates", ["name"], name: "index_document_templates_on_name", using: :btree
  add_index "document_templates", ["sub_category"], name: "index_document_templates_on_sub_category", using: :btree

  create_table "documents", force: true do |t|
    t.string   "name"
    t.integer  "surgery_id"
    t.string   "path"
    t.string   "type"
    t.string   "stage",      default: "pre-operation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "domains", force: true do |t|
    t.string   "name"
    t.integer  "hospital_id",   limit: 8
    t.integer  "department_id", limit: 8
    t.string   "introduction"
    t.string   "logo_url"
    t.text     "footer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "duty_schedule_lists", force: true do |t|
    t.integer  "doctor_id",          limit: 8
    t.string   "doctor_name"
    t.integer  "department_id",      limit: 8
    t.string   "department_name"
    t.integer  "modality_device_id"
    t.string   "station_aet"
    t.integer  "year"
    t.integer  "month"
    t.string   "day1"
    t.string   "day2"
    t.string   "day3"
    t.string   "day4"
    t.string   "day5"
    t.string   "day6"
    t.string   "day7"
    t.string   "day8"
    t.string   "day9"
    t.string   "day10"
    t.string   "day11"
    t.string   "day12"
    t.string   "day13"
    t.string   "day14"
    t.string   "day15"
    t.string   "day16"
    t.string   "day17"
    t.string   "day18"
    t.string   "day19"
    t.string   "day20"
    t.string   "day21"
    t.string   "day22"
    t.string   "day23"
    t.string   "day24"
    t.string   "day25"
    t.string   "day26"
    t.string   "day27"
    t.string   "day28"
    t.string   "day29"
    t.string   "day30"
    t.string   "day31"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "duty_schedule_templates", force: true do |t|
    t.integer  "doctor_id",          limit: 8
    t.string   "doctor_name"
    t.integer  "modality_device_id"
    t.string   "station_aet"
    t.string   "mon"
    t.string   "tue"
    t.string   "weds"
    t.string   "thu"
    t.string   "fri"
    t.string   "sat"
    t.string   "sun"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "duty_schedules", force: true do |t|
    t.integer  "doctor_id",          limit: 8
    t.string   "doctor_name"
    t.integer  "department_id",      limit: 8
    t.string   "department_name"
    t.integer  "modality_device_id"
    t.string   "station_aet"
    t.date     "work_time"
    t.string   "duty_type"
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ecgs", force: true do |t|
    t.text     "ecg_img"
    t.string   "device_type"
    t.datetime "measure_time"
    t.string   "ahdId"
    t.string   "mdevice"
    t.boolean  "is_true"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "int_ecg_img"
    t.text     "bit_ecg_img"
    t.integer  "patient_id",   limit: 8
    t.string   "hospital"
    t.string   "department"
    t.string   "doctor"
    t.string   "parent_type"
    t.string   "child_type"
  end

  create_table "edu_videos", force: true do |t|
    t.string   "name"
    t.string   "content"
    t.string   "image_url"
    t.string   "video_url"
    t.integer  "doctor_id",     limit: 8
    t.string   "doctor_name"
    t.string   "video_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "video_type_id"
    t.integer  "hospital_id",   limit: 8
    t.integer  "department_id", limit: 8
  end

  add_index "edu_videos", ["video_type_id"], name: "index_edu_videos_on_video_type_id", using: :btree

  create_table "examined_items", force: true do |t|
    t.string   "item"
    t.float    "fee",                  limit: 24
    t.integer  "examined_position_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "time_length",                     default: 0
    t.integer  "item_type"
  end

  create_table "examined_positions", force: true do |t|
    t.string   "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "file_sync_queues", force: true do |t|
    t.string   "fileid"
    t.datetime "starttime"
    t.string   "md5"
    t.string   "suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority"
  end

  create_table "file_sync_results", force: true do |t|
    t.string   "fileid"
    t.datetime "starttime"
    t.datetime "endtime"
    t.string   "md5"
    t.string   "suffix"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority"
  end

  create_table "functions", force: true do |t|
    t.string   "name",                         null: false
    t.string   "desc"
    t.string   "icon"
    t.string   "spell_code"
    t.string   "action"
    t.boolean  "disabled",     default: false
    t.integer  "viewpanel_id",                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_users", force: true do |t|
    t.integer  "group_id",               null: false
    t.integer  "user_id",     limit: 8,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doctor_id",   limit: 8
    t.string   "doctor_name", limit: 20
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "desc"
    t.string   "photo"
    t.string   "web_site"
    t.integer  "create_user_id", limit: 8
    t.string   "create_user"
    t.integer  "expert_count"
    t.integer  "hospital_id",    limit: 8
    t.integer  "sort"
    t.datetime "created_at"
    t.integer  "doctor_id"
    t.datetime "updated_at"
    t.string   "doctor_name",    limit: 20
  end

  create_table "home_menus", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "hospital_id",         limit: 8
    t.integer  "department_id",       limit: 8
    t.boolean  "show_in_menu"
    t.string   "link_url"
    t.integer  "skip_to_first_child"
    t.boolean  "show_in_header"
    t.boolean  "show_in_footer"
    t.integer  "depth"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "redirect_url"
  end

  create_table "home_pages", force: true do |t|
    t.integer  "home_menu_id"
    t.string   "name"
    t.text     "content"
    t.integer  "hospital_id",   limit: 8
    t.integer  "department_id", limit: 8
    t.integer  "position"
    t.string   "link_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "redirect_url"
  end

  create_table "hospitals", force: true do |t|
    t.string   "name",             null: false
    t.string   "short_name"
    t.string   "spell_code"
    t.string   "address"
    t.string   "phone"
    t.text     "description"
    t.string   "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "province_id"
    t.string   "province_name"
    t.integer  "city_id"
    t.string   "city_name"
    t.string   "key_departments"
    t.string   "operation_mode"
    t.string   "email"
    t.string   "hospital_site"
    t.string   "fax_number"
    t.string   "ids"
    t.string   "short_spell"
    t.string   "longitude"
    t.string   "latitude"
    t.string   "area"
    t.integer  "department_count"
    t.integer  "doctor_count"
    t.boolean  "indexpage"
    t.integer  "sort"
  end

  add_index "hospitals", ["name"], name: "index_hospitals_on_name", using: :btree
  add_index "hospitals", ["rank"], name: "index_hospitals_on_rank", using: :btree
  add_index "hospitals", ["short_name"], name: "index_hospitals_on_short_name", using: :btree
  add_index "hospitals", ["spell_code"], name: "index_hospitals_on_spell_code", using: :btree

  create_table "hospitals_skills", id: false, force: true do |t|
    t.integer "hospital_id"
    t.integer "skill_id"
  end

  create_table "inpatient_records", force: true do |t|
    t.integer  "patient_id",            limit: 8, null: false
    t.datetime "admitted_date",                   null: false
    t.string   "inpatient_number",                null: false
    t.integer  "department_id",                   null: false
    t.integer  "inpatient_area_id",               null: false
    t.integer  "bed",                             null: false
    t.date     "confirmed_date"
    t.boolean  "is_under_treatment",              null: false
    t.date     "discharge_date"
    t.text     "discharge_diagnose"
    t.text     "discharge_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inspection_cts", force: true do |t|
    t.integer  "patient_id",       limit: 8
    t.string   "parent_type"
    t.string   "child_type"
    t.string   "thumbnail"
    t.string   "identifier"
    t.string   "doctor"
    t.string   "hospital"
    t.string   "department"
    t.date     "checked_at"
    t.integer  "upload_user_id",   limit: 8
    t.string   "upload_user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_list"
    t.string   "video_list"
    t.text     "study_body"
  end

  create_table "inspection_data", force: true do |t|
    t.integer  "patient_id",       limit: 8
    t.string   "parent_type"
    t.string   "child_type"
    t.string   "thumbnail"
    t.string   "identifier"
    t.string   "doctor"
    t.string   "hospital"
    t.string   "department"
    t.date     "checked_at"
    t.integer  "upload_user_id",   limit: 8
    t.string   "upload_user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_list"
    t.string   "video_list"
    t.text     "study_body"
  end

  create_table "inspection_nuclear_magnetics", force: true do |t|
    t.integer  "patient_id",       limit: 8
    t.string   "parent_type"
    t.string   "child_type"
    t.string   "thumbnail"
    t.string   "identifier"
    t.string   "doctor"
    t.string   "hospital"
    t.string   "department"
    t.date     "checked_at"
    t.integer  "upload_user_id",   limit: 8
    t.string   "upload_user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_list"
    t.string   "video_list"
    t.text     "study_body"
  end

  create_table "inspection_reports", force: true do |t|
    t.integer  "patient_id",       limit: 8
    t.string   "parent_type"
    t.string   "child_type"
    t.string   "thumbnail"
    t.string   "identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "doctor"
    t.string   "hospital"
    t.string   "department"
    t.date     "checked_at"
    t.integer  "child_id",         limit: 8
    t.integer  "upload_user_id",   limit: 8
    t.string   "upload_user_name"
    t.string   "image_list"
    t.string   "video_list"
    t.text     "study_body"
  end

  create_table "inspection_ultrasounds", force: true do |t|
    t.integer  "patient_id",       limit: 8
    t.string   "parent_type"
    t.string   "child_type"
    t.string   "thumbnail"
    t.string   "identifier"
    t.string   "doctor"
    t.string   "hospital"
    t.string   "department"
    t.date     "checked_at"
    t.integer  "upload_user_id",   limit: 8
    t.string   "upload_user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_list"
    t.string   "video_list"
    t.text     "study_body"
  end

  create_table "item_users", force: true do |t|
    t.integer  "user_id",    limit: 8
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "photo"
    t.integer  "user_id"
    t.string   "create_user"
    t.integer  "group_id"
    t.string   "group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kindeditor_assets", force: true do |t|
    t.string   "asset"
    t.integer  "file_size"
    t.string   "file_type"
    t.integer  "owner_id"
    t.string   "asset_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leave_messages", force: true do |t|
    t.integer  "user_id",      limit: 8
    t.string   "owner"
    t.string   "title"
    t.text     "content"
    t.string   "message_type"
    t.integer  "view_count",             default: 0
    t.integer  "like_count",             default: 0
    t.integer  "reply_count",            default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "leave_messages", ["user_id"], name: "index_leave_messages_on_user_id", using: :btree

  create_table "login_logs", force: true do |t|
    t.string   "user_name"
    t.string   "ip_address"
    t.datetime "login_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "login_result"
  end

  create_table "logos", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "hospital_id",    limit: 8
    t.integer  "department_id",  limit: 8
    t.string   "footer_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "managers", force: true do |t|
    t.string   "name",                                 null: false
    t.string   "spell_code"
    t.string   "credential_type"
    t.string   "credential_type_number",               null: false
    t.string   "gender",                 default: "男", null: false
    t.date     "birthday"
    t.string   "birthplace"
    t.string   "address"
    t.string   "nationality"
    t.string   "citizenship"
    t.string   "province"
    t.string   "country"
    t.string   "photo"
    t.string   "marriage"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "home_address"
    t.string   "contact"
    t.string   "contact_phone"
    t.string   "home_postcode"
    t.string   "email"
    t.string   "introduction"
    t.string   "qq"
    t.string   "weixin"
    t.integer  "level"
    t.datetime "expired_time"
    t.string   "manager_number",                       null: false
    t.string   "authorities"
    t.string   "created_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "managers", ["credential_type_number"], name: "index_managers_on_credential_type_number", using: :btree
  add_index "managers", ["gender"], name: "index_managers_on_gender", using: :btree
  add_index "managers", ["mobile_phone"], name: "index_managers_on_mobile_phone", using: :btree
  add_index "managers", ["name"], name: "index_managers_on_name", using: :btree
  add_index "managers", ["spell_code"], name: "index_managers_on_spell_code", using: :btree

  create_table "medical_records", force: true do |t|
    t.integer  "patient_id",      limit: 8, null: false
    t.string   "service_type_id",           null: false
    t.string   "visit_number",              null: false
    t.integer  "department_id",             null: false
    t.integer  "doctor_id",       limit: 8, null: false
    t.datetime "visit_at",                  null: false
    t.text     "visit"
    t.integer  "pay_type_id"
    t.boolean  "is_admitted"
    t.boolean  "is_closed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medical_surgical_grades", force: true do |t|
    t.integer  "department_id"
    t.string   "name"
    t.string   "category"
    t.string   "doctor_seniority"
    t.string   "nurse_seniority"
    t.string   "note"
    t.string   "spell_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "risk_factor",           limit: 24, default: 0.0
    t.boolean  "is_pollute"
    t.boolean  "is_minimally_invasive"
    t.boolean  "is_isolation"
    t.string   "is_infect"
  end

  create_table "menu_permissions", force: true do |t|
    t.integer  "menu_id"
    t.integer  "admin2_id"
    t.string   "hospital_id"
    t.string   "department_id"
    t.boolean  "is_show",       default: true
    t.boolean  "is_edit",       default: false
    t.boolean  "is_add",        default: false
    t.boolean  "is_delete",     default: false
    t.boolean  "is_manage",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "priority_id"
  end

  create_table "menu_uris", force: true do |t|
    t.string   "menu_name"
    t.string   "menu_uri"
    t.text     "instruction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.string   "uri"
    t.string   "table_name"
    t.string   "model_class"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_show"
    t.boolean  "dep_admin_show"
    t.boolean  "hos_admin_show"
    t.boolean  "ins_admin_show"
  end

  create_table "message_likes", force: true do |t|
    t.integer  "user_id",          limit: 8
    t.integer  "leave_message_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_likes", ["leave_message_id"], name: "index_message_likes_on_leave_message_id", using: :btree
  add_index "message_likes", ["user_id"], name: "index_message_likes_on_user_id", using: :btree

  create_table "messages", force: true do |t|
    t.text     "content"
    t.integer  "channel_id"
    t.integer  "user_id",    limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mimas_data_sync_queues", force: true do |t|
    t.integer  "foreign_key",   limit: 8
    t.string   "table_name"
    t.integer  "code"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hospital"
    t.string   "department"
    t.boolean  "is_processing",           default: false
    t.boolean  "is_finallevel",           default: false
    t.string   "file_id"
    t.integer  "priority",                default: 0
  end

  create_table "mimas_datasync_results", force: true do |t|
    t.integer  "fk",          limit: 8
    t.string   "status"
    t.string   "data_source"
    t.string   "table_name"
    t.string   "hospital"
    t.string   "department"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "code"
  end

  create_table "modality_devices", force: true do |t|
    t.string   "station_name"
    t.string   "station_aet"
    t.string   "modality"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id"
    t.string   "operation_frequence"
  end

  create_table "narcotic_drugs", force: true do |t|
    t.string   "drug_code"
    t.string   "name"
    t.string   "spell_code"
    t.string   "product_name"
    t.string   "english_name"
    t.string   "category"
    t.string   "dosage_forms"
    t.string   "quantity_per"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "national_informations", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "net_configs", force: true do |t|
    t.string   "protocol"
    t.string   "host"
    t.string   "port"
    t.string   "config_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "note_admireds", force: true do |t|
    t.integer  "user_id",    limit: 8
    t.integer  "note_id",    limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "note_comments", force: true do |t|
    t.integer  "user_id",    limit: 8
    t.string   "name"
    t.integer  "note_id",    limit: 8
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "note_forwardings", force: true do |t|
    t.integer  "user_id",    limit: 8
    t.integer  "note_id",    limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "note_tags", force: true do |t|
    t.integer "note_id",       limit: 8
    t.string  "tag_name"
    t.integer "created_by_id", limit: 8
  end

  create_table "note_types", force: true do |t|
    t.string  "name"
    t.integer "create_by_id", limit: 8
    t.integer "notes_count"
    t.integer "source_by"
  end

  create_table "notes", force: true do |t|
    t.string   "head"
    t.string   "subhead"
    t.text     "content"
    t.datetime "deleted_at"
    t.boolean  "is_public"
    t.boolean  "is_top"
    t.boolean  "is_allow_comment"
    t.boolean  "is_visible"
    t.integer  "who_deleted",      limit: 8
    t.string   "created_by"
    t.integer  "created_by_id",    limit: 8
    t.string   "update_by"
    t.integer  "update_by_id",     limit: 8
    t.string   "audit_by"
    t.datetime "audit_time"
    t.string   "pubstatus"
    t.boolean  "excellent"
    t.boolean  "indexpage"
    t.string   "site"
    t.integer  "pageview"
    t.integer  "replies_count"
    t.integer  "doctor_id",        limit: 8
    t.integer  "share_count",                default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "archtype",                   default: 0
  end

  add_index "notes", ["created_by"], name: "index_notes_on_created_by", using: :btree
  add_index "notes", ["created_by_id"], name: "index_notes_on_created_by_id", using: :btree
  add_index "notes", ["id"], name: "index_notes_on_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id",      limit: 8, null: false
    t.text     "content"
    t.datetime "start_time"
    t.datetime "expired_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "code"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "nurse_groups", force: true do |t|
    t.integer  "empirical_value"
    t.string   "name"
    t.string   "slogan"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "on_duty_date"
    t.integer  "on_duty_of_month"
  end

  create_table "nurses", force: true do |t|
    t.string   "name",                                     null: false
    t.string   "spell_code"
    t.string   "credential_type"
    t.string   "credential_type_number"
    t.string   "gender",                 default: "男",     null: false
    t.date     "birthday",                                 null: false
    t.string   "birthplace"
    t.string   "address"
    t.string   "nationality"
    t.string   "citizenship"
    t.string   "province"
    t.string   "county"
    t.string   "photo"
    t.string   "marriage"
    t.string   "mobile_phone",                             null: false
    t.string   "home_phone"
    t.string   "home_address"
    t.string   "contact"
    t.string   "contact_phone"
    t.string   "home_postcode"
    t.string   "email"
    t.text     "introduction"
    t.string   "professional_title"
    t.integer  "hospital_id"
    t.integer  "department_id"
    t.date     "hire_date"
    t.string   "certificate_number"
    t.string   "degree"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                   default: "Nurse"
    t.integer  "nurse_group_id"
    t.string   "wechat"
  end

  add_index "nurses", ["credential_type_number"], name: "index_nurses_on_credential_type_number", using: :btree
  add_index "nurses", ["department_id"], name: "index_nurses_on_department_id", using: :btree
  add_index "nurses", ["gender"], name: "index_nurses_on_gender", using: :btree
  add_index "nurses", ["hospital_id"], name: "index_nurses_on_hospital_id", using: :btree
  add_index "nurses", ["mobile_phone"], name: "index_nurses_on_mobile_phone", using: :btree
  add_index "nurses", ["name"], name: "index_nurses_on_name", using: :btree
  add_index "nurses", ["professional_title"], name: "index_nurses_on_professional_title", using: :btree
  add_index "nurses", ["spell_code"], name: "index_nurses_on_spell_code", using: :btree
  add_index "nurses", ["wechat"], name: "index_nurses_on_wechat", using: :btree

  create_table "online_services", force: true do |t|
    t.integer  "service_id"
    t.string   "service_name"
    t.string   "service_type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operating_rooms", force: true do |t|
    t.string   "name"
    t.string   "room_location"
    t.string   "cleanliness_level"
    t.string   "description"
    t.string   "categery"
    t.string   "spell_code"
    t.string   "ventilator"
    t.string   "anesthesia_machine"
    t.string   "specification"
    t.string   "note"
    t.boolean  "is_used",            default: false
    t.text     "configs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operating_rooms_nurse_groups", force: true do |t|
    t.integer  "operating_room_id"
    t.integer  "nurse_group_id"
    t.date     "on_duty_date"
    t.integer  "on_duty_of_week"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "operating_rooms_video_sources", force: true do |t|
    t.integer  "operating_room_id"
    t.integer  "video_source_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pacs_data_sync_queues", force: true do |t|
    t.integer  "task_id"
    t.integer  "super_task_id"
    t.string   "pacs_type"
    t.string   "content"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_blocks", force: true do |t|
    t.string   "name"
    t.text     "content"
    t.integer  "created_id",      limit: 8
    t.string   "created_name"
    t.integer  "updated_id",      limit: 8
    t.string   "updated_name"
    t.integer  "page_id",         limit: 8
    t.integer  "hospital_id",     limit: 8
    t.string   "hospital_name"
    t.integer  "department_id",   limit: 8
    t.string   "department_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position",                  default: 0
    t.boolean  "is_show",                   default: false
    t.string   "block_type"
  end

  create_table "patient_surgery_risks", force: true do |t|
    t.integer  "surgery_id"
    t.integer  "upper_limit"
    t.integer  "lower_limit"
    t.float    "risk_factor", limit: 24
    t.boolean  "gender"
    t.integer  "habitus"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patients", force: true do |t|
    t.string   "name"
    t.string   "spell_code"
    t.string   "credential_type"
    t.string   "credential_type_number"
    t.string   "gender"
    t.date     "birthday"
    t.string   "birthplace"
    t.string   "address"
    t.string   "nationality"
    t.string   "citizenship"
    t.string   "province"
    t.string   "county"
    t.string   "photo"
    t.string   "marriage"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "home_address"
    t.string   "contact"
    t.string   "contact_phone"
    t.string   "home_postcode"
    t.string   "email"
    t.text     "introduction"
    t.string   "patient_ids"
    t.string   "education"
    t.string   "household"
    t.string   "occupation"
    t.string   "orgnization"
    t.string   "orgnization_address"
    t.string   "insurance_type"
    t.string   "insurance_number"
    t.integer  "doctor_id",              limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "p_user_id",              limit: 8
    t.string   "wechat"
    t.date     "last_treat_time"
    t.string   "diseases_type"
    t.integer  "is_public",                        default: 0
    t.date     "childbirth_date"
    t.string   "scan_code"
    t.string   "height"
    t.string   "verify_code"
    t.integer  "is_activated",                     default: 0
    t.integer  "is_checked",                       default: 0
    t.integer  "verify_code_prit_count",           default: 0
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "hospital_id",            limit: 8
    t.integer  "department_id",          limit: 8
  end

  add_index "patients", ["wechat"], name: "index_patients_on_wechat", using: :btree

  create_table "pay_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", force: true do |t|
    t.string   "action"
    t.string   "subject_class"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["action", "subject_class", "role_id"], name: "index_permissions_on_action_and_subject_class_and_role_id", using: :btree

  create_table "pregnancy_knowledges", force: true do |t|
    t.integer  "parent_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pregnancy_knowledges", ["parent_id"], name: "index_pregnancy_knowledges_on_parent_id", using: :btree

  create_table "priorities", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provinces", force: true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "spell_name"
    t.string   "en_abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort"
    t.boolean  "indexpage"
  end

  create_table "qualification_certificates", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "spell_code"
    t.string   "certificate_type"
    t.string   "issuing_agency"
    t.date     "issuing_date"
    t.text     "description"
    t.string   "person_type"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recorded_videos", force: true do |t|
    t.integer  "video_source_id"
    t.string   "video_id"
    t.datetime "record_time"
    t.integer  "duration"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "surgery_id"
    t.string   "name"
  end

  create_table "role2_menus", force: true do |t|
    t.integer  "role2_id"
    t.integer  "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role2s", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.text     "instruction"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "role2s_menu_permissions", force: true do |t|
    t.integer "role2_id"
    t.integer "menu_permission_id"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "schedule_templates", force: true do |t|
    t.integer  "doctor_id",  limit: 8
    t.integer  "dayofweek"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedule_templates", ["dayofweek"], name: "index_schedule_templates_on_dayofweek", using: :btree
  add_index "schedule_templates", ["doctor_id"], name: "index_schedule_templates_on_doctor_id", using: :btree

  create_table "service_position_items", force: true do |t|
    t.integer  "service_id"
    t.string   "service_name"
    t.integer  "position_id"
    t.string   "position_name"
    t.integer  "item_id"
    t.string   "item_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shares", force: true do |t|
    t.integer  "note_id",         limit: 8
    t.integer  "from_user_id",    limit: 8
    t.string   "from_user_name"
    t.integer  "share_user_id",   limit: 8
    t.string   "share_user_name"
    t.string   "share_type"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shares", ["from_user_id"], name: "index_shares_on_from_user_id", using: :btree
  add_index "shares", ["note_id"], name: "index_shares_on_note_id", using: :btree
  add_index "shares", ["share_user_id"], name: "index_shares_on_share_user_id", using: :btree

  create_table "skills", force: true do |t|
    t.string   "name"
    t.string   "photo"
    t.string   "keywords"
    t.string   "short_name"
    t.string   "spell_code"
    t.string   "short_spell"
    t.text     "desc",            limit: 2147483647
    t.text     "detail",          limit: 2147483647
    t.string   "period"
    t.string   "from"
    t.string   "create_by_user"
    t.integer  "sort"
    t.boolean  "index_page_show"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "skills", ["name"], name: "index_skills_on_name", using: :btree

  create_table "smrwbs", force: true do |t|
    t.integer  "patient_id",    limit: 8
    t.string   "measure_value"
    t.datetime "measure_time"
    t.string   "mdevice"
    t.boolean  "is_true"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surgeries", force: true do |t|
    t.string   "name"
    t.integer  "department_id"
    t.string   "surgery_level"
    t.boolean  "is_minimally_invasive"
    t.boolean  "is_pollute"
    t.boolean  "is_isolation"
    t.boolean  "is_infect"
    t.string   "nurse_visited_uids"
    t.string   "anaesthesia_visited_uids"
    t.datetime "schedule_time"
    t.decimal  "duration",                            precision: 10, scale: 0
    t.integer  "inpatient_record_id"
    t.integer  "patient_id",                limit: 8
    t.text     "preoperative_diagnosis"
    t.integer  "master_doctor_id",          limit: 8
    t.string   "assistant_doctor_id"
    t.boolean  "is_emgency"
    t.integer  "doctor_advice_id",          limit: 8
    t.datetime "apply_time",                                                   default: '2014-12-03 15:51:25'
    t.integer  "apply_doctor_id",           limit: 8
    t.text     "notes"
    t.integer  "arranger_doctor_id",        limit: 8
    t.integer  "anesthesia_doctor_id",      limit: 8
    t.datetime "surgery_time"
    t.integer  "operating_room_id"
    t.integer  "anaesthesia_plan_id"
    t.integer  "patrol_nurse_id",           limit: 8
    t.integer  "appliance_nurse_id",        limit: 8
    t.datetime "actual_start_time"
    t.datetime "actual_end_time"
    t.string   "surgery_status"
    t.boolean  "is_ended"
    t.string   "ended_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "check_uids"
    t.integer  "medical_record_id"
    t.string   "type",                                                         default: "Surgery"
    t.integer  "medical_surgical_grade_id"
  end

  create_table "surgeries_operating_rooms", force: true do |t|
    t.integer  "surgery_id",                     null: false
    t.integer  "operating_room_id",              null: false
    t.integer  "anesthesia_doctor_id", limit: 8
    t.integer  "arranger_doctor_id",   limit: 8
    t.datetime "started_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surgery_doctors", force: true do |t|
    t.integer  "surgery_id"
    t.integer  "doctor_id",   limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "doctor_name"
  end

  create_table "surgery_documents", force: true do |t|
    t.integer  "surgery_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surgery_drug_dosages", force: true do |t|
    t.string   "drug_name"
    t.string   "drug_no"
    t.decimal  "usage_amount", precision: 10, scale: 0
    t.string   "quantity_per"
    t.string   "created_by"
    t.string   "updated_by"
    t.integer  "surgery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surgery_drugs", force: true do |t|
    t.integer  "surgery_id"
    t.string   "drug_name"
    t.string   "drug_unit"
    t.decimal  "drug_dosage", precision: 10, scale: 0
    t.datetime "drug_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surgery_logs", force: true do |t|
    t.integer  "surgery_id"
    t.string   "surgery_name"
    t.integer  "patient_id",      limit: 8
    t.string   "patient_name"
    t.string   "operate_action"
    t.integer  "operate_by_id",   limit: 8
    t.string   "operate_by_name"
    t.string   "msg_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "related_model"
    t.text     "log_detail"
  end

  create_table "surgery_nurses", force: true do |t|
    t.integer  "surgery_id"
    t.integer  "nurse_id",           limit: 8
    t.integer  "appliance_nurse_id", limit: 8
    t.datetime "started_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surgery_type_operating_rooms", force: true do |t|
    t.integer  "surgery_id"
    t.integer  "operating_room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surgical_instrument_instances", force: true do |t|
    t.integer  "surgical_instrument_id"
    t.integer  "operating_room_id"
    t.string   "equipment_code"
    t.string   "name"
    t.string   "spell_code"
    t.string   "product_name"
    t.string   "english_name"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surgical_instruments", force: true do |t|
    t.string   "equipment_code"
    t.string   "name"
    t.string   "spell_code"
    t.string   "product_name"
    t.string   "english_name"
    t.string   "category"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "operating_room_id"
  end

  create_table "sys_nodes", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "default_workspace"
    t.string   "desc"
    t.string   "icon"
    t.string   "spell_code"
    t.string   "phone"
    t.string   "mobile"
    t.string   "license_key"
    t.string   "long_term_support"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sys_nodes", ["code"], name: "index_sys_nodes_on_code", using: :btree
  add_index "sys_nodes", ["default_workspace"], name: "index_sys_nodes_on_default_workspace", using: :btree
  add_index "sys_nodes", ["name"], name: "index_sys_nodes_on_name", using: :btree

  create_table "systems", force: true do |t|
    t.string   "name",       null: false
    t.string   "desc"
    t.string   "icon"
    t.string   "spell_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "technicians", force: true do |t|
    t.string   "name"
    t.string   "spell_code"
    t.string   "credential_type"
    t.string   "credential_type_number"
    t.string   "gender",                 default: "男",   null: false
    t.date     "birthday",                               null: false
    t.string   "birthplace"
    t.string   "address"
    t.string   "nationality"
    t.string   "citizenship"
    t.string   "province"
    t.string   "county"
    t.string   "photo"
    t.string   "marriage"
    t.string   "mobile_phone"
    t.string   "home_phone"
    t.string   "home_address"
    t.string   "contact"
    t.string   "contact_phone"
    t.string   "home_postcode"
    t.string   "email"
    t.string   "introduction"
    t.integer  "hospital_id"
    t.integer  "department_id"
    t.string   "professional_title"
    t.string   "position"
    t.date     "hire_date"
    t.string   "certificate_number"
    t.string   "expertise"
    t.string   "degree"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_public",              default: false
    t.string   "wechat"
  end

  add_index "technicians", ["credential_type_number"], name: "index_technicians_on_credential_type_number", using: :btree
  add_index "technicians", ["department_id"], name: "index_technicians_on_department_id", using: :btree
  add_index "technicians", ["gender"], name: "index_technicians_on_gender", using: :btree
  add_index "technicians", ["hospital_id"], name: "index_technicians_on_hospital_id", using: :btree
  add_index "technicians", ["is_public"], name: "index_technicians_on_is_public", using: :btree
  add_index "technicians", ["mobile_phone"], name: "index_technicians_on_mobile_phone", using: :btree
  add_index "technicians", ["name"], name: "index_technicians_on_name", using: :btree
  add_index "technicians", ["professional_title"], name: "index_technicians_on_professional_title", using: :btree
  add_index "technicians", ["spell_code"], name: "index_technicians_on_spell_code", using: :btree
  add_index "technicians", ["wechat"], name: "index_technicians_on_wechat", using: :btree

  create_table "treatment_relationships", force: true do |t|
    t.integer  "doctor_id",  limit: 8
    t.integer  "patient_id", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "us_quality_controls", force: true do |t|
    t.integer  "report_id",     limit: 8, null: false
    t.integer  "operator_id",   limit: 8, null: false
    t.string   "operate_event",           null: false
    t.text     "description"
    t.string   "document_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "operator_name"
  end

  add_index "us_quality_controls", ["document_id"], name: "index_us_quality_controls_on_document_id", using: :btree
  add_index "us_quality_controls", ["operator_id"], name: "index_us_quality_controls_on_operator_id", using: :btree
  add_index "us_quality_controls", ["report_id"], name: "index_us_quality_controls_on_report_id", using: :btree

  create_table "us_report_doc_logs", force: true do |t|
    t.integer  "report_id",  limit: 8
    t.integer  "doc_uuid",   limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "us_reports", force: true do |t|
    t.integer  "patient_id",            limit: 8
    t.string   "patient_ids",                                      null: false
    t.integer  "apply_department_id",                              null: false
    t.integer  "apply_doctor_id",       limit: 8,                  null: false
    t.integer  "consulting_room_id"
    t.datetime "appointment_time"
    t.integer  "apply_source",                     default: 0
    t.string   "source_code",                                      null: false
    t.integer  "bed_no"
    t.integer  "examined_part_id",                                 null: false
    t.integer  "examined_item_id",                                 null: false
    t.integer  "charge_type_id"
    t.float    "charge",                limit: 24
    t.integer  "examine_doctor_id",     limit: 8
    t.boolean  "is_emergency",                     default: false
    t.string   "created_by",                                       null: false
    t.string   "modality"
    t.string   "positive_grade"
    t.text     "initial_diagnosis"
    t.integer  "equipment"
    t.integer  "approval_status",                  default: 0
    t.datetime "check_start_time"
    t.datetime "check_end_time"
    t.string   "report_document_id"
    t.integer  "controller_by",         limit: 8
    t.text     "follow_up_result"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "print_total",                      default: 0
    t.integer  "notification_id"
    t.integer  "technician_id",         limit: 8
    t.integer  "is_public",                        default: 0
    t.string   "patient_name"
    t.string   "apply_department_name"
    t.string   "apply_doctor_name"
    t.string   "consulting_room_name"
    t.string   "examined_part_name"
    t.string   "examined_item_name"
    t.string   "examine_doctor_name"
    t.string   "created_by_name"
    t.string   "controller_by_name"
    t.string   "technician_name"
    t.string   "patient_code"
    t.string   "examine_doctor_code"
    t.integer  "report_type"
    t.integer  "hospital_id"
    t.string   "hospital_name"
  end

  add_index "us_reports", ["apply_department_id"], name: "index_us_reports_on_apply_department_id", using: :btree
  add_index "us_reports", ["apply_doctor_id"], name: "index_us_reports_on_apply_doctor_id", using: :btree
  add_index "us_reports", ["apply_source"], name: "index_us_reports_on_apply_source", using: :btree
  add_index "us_reports", ["appointment_time"], name: "index_us_reports_on_appointment_time", using: :btree
  add_index "us_reports", ["approval_status"], name: "index_us_reports_on_approval_status", using: :btree
  add_index "us_reports", ["charge_type_id"], name: "index_us_reports_on_charge_type_id", using: :btree
  add_index "us_reports", ["check_start_time"], name: "index_us_reports_on_check_start_time", using: :btree
  add_index "us_reports", ["consulting_room_id"], name: "index_us_reports_on_consulting_room_id", using: :btree
  add_index "us_reports", ["controller_by"], name: "index_us_reports_on_controller_by", using: :btree
  add_index "us_reports", ["created_by"], name: "index_us_reports_on_created_by", using: :btree
  add_index "us_reports", ["examine_doctor_id"], name: "index_us_reports_on_examine_doctor_id", using: :btree
  add_index "us_reports", ["examined_item_id"], name: "index_us_reports_on_examined_item_id", using: :btree
  add_index "us_reports", ["examined_part_id"], name: "index_us_reports_on_examined_part_id", using: :btree
  add_index "us_reports", ["is_emergency"], name: "index_us_reports_on_is_emergency", using: :btree
  add_index "us_reports", ["patient_id"], name: "index_us_reports_on_patient_id", using: :btree
  add_index "us_reports", ["patient_ids"], name: "index_us_reports_on_patient_ids", using: :btree
  add_index "us_reports", ["report_document_id"], name: "index_us_reports_on_report_document_id", using: :btree
  add_index "us_reports", ["report_type"], name: "index_us_reports_on_report_type", using: :btree
  add_index "us_reports", ["technician_id"], name: "index_us_reports_on_technician_id", using: :btree

  create_table "us_worklist_logs", force: true do |t|
    t.integer  "us_worklist_id"
    t.text     "change_contents"
    t.integer  "created_by",      limit: 8
    t.string   "created_by_name"
    t.string   "worklist_type"
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "us_worklists", id: false, force: true do |t|
    t.integer  "id",                    limit: 8
    t.integer  "patient_id",            limit: 8,                  null: false
    t.string   "patient_ids"
    t.integer  "apply_department_id"
    t.integer  "apply_doctor_id",       limit: 8
    t.integer  "consulting_room_id"
    t.datetime "appointment_time"
    t.integer  "apply_source",                     default: 0
    t.string   "source_code"
    t.integer  "bed_no"
    t.integer  "examined_part_id"
    t.integer  "examined_item_id"
    t.float    "charge",                limit: 24, default: 0.0
    t.integer  "examine_doctor_id",     limit: 8
    t.boolean  "is_emergency",                     default: false
    t.string   "created_by"
    t.string   "update_by"
    t.text     "description"
    t.string   "study_iuid"
    t.integer  "status",                           default: 0
    t.string   "modality"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "worklist_code"
    t.integer  "technician_id",         limit: 8
    t.integer  "motherhood"
    t.date     "lastMenstrual"
    t.integer  "cycle"
    t.string   "patient_name"
    t.string   "patient_code"
    t.string   "apply_department_name"
    t.string   "apply_doctor_name"
    t.string   "consulting_room_name"
    t.string   "examined_part_name"
    t.string   "examined_item_name"
    t.string   "examine_doctor_name"
    t.string   "examine_doctor_code"
    t.string   "created_by_name"
    t.string   "update_by_name"
    t.string   "technician_name"
    t.string   "time_interval"
    t.integer  "hospital_id"
    t.string   "hospital_name"
    t.integer  "reservation_number",    limit: 8,  default: 0
  end

  add_index "us_worklists", ["apply_department_id"], name: "index_us_worklists_on_apply_department_id", using: :btree
  add_index "us_worklists", ["apply_doctor_id"], name: "index_us_worklists_on_apply_doctor_id", using: :btree
  add_index "us_worklists", ["apply_source"], name: "index_us_worklists_on_apply_source", using: :btree
  add_index "us_worklists", ["appointment_time"], name: "index_us_worklists_on_appointment_time", using: :btree
  add_index "us_worklists", ["consulting_room_id"], name: "index_us_worklists_on_consulting_room_id", using: :btree
  add_index "us_worklists", ["created_by"], name: "index_us_worklists_on_created_by", using: :btree
  add_index "us_worklists", ["examine_doctor_id"], name: "index_us_worklists_on_examine_doctor_id", using: :btree
  add_index "us_worklists", ["examined_item_id"], name: "index_us_worklists_on_examined_item_id", using: :btree
  add_index "us_worklists", ["examined_part_id"], name: "index_us_worklists_on_examined_part_id", using: :btree
  add_index "us_worklists", ["is_emergency"], name: "index_us_worklists_on_is_emergency", using: :btree
  add_index "us_worklists", ["modality"], name: "index_us_worklists_on_modality", using: :btree
  add_index "us_worklists", ["patient_id"], name: "index_us_worklists_on_patient_id", using: :btree
  add_index "us_worklists", ["patient_ids"], name: "index_us_worklists_on_patient_ids", using: :btree
  add_index "us_worklists", ["status"], name: "index_us_worklists_on_status", using: :btree
  add_index "us_worklists", ["study_iuid"], name: "index_us_worklists_on_study_iuid", using: :btree

  create_table "user_feedbacks", force: true do |t|
    t.integer  "user_id",          limit: 8
    t.text     "feedback_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_replies", force: true do |t|
    t.integer  "user_id",          limit: 8
    t.string   "reply_user"
    t.integer  "leave_message_id"
    t.text     "reply_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_replies", ["leave_message_id"], name: "index_user_replies_on_leave_message_id", using: :btree
  add_index "user_replies", ["user_id"], name: "index_user_replies_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                                                null: false
    t.string   "password_digest",                  default: "123456", null: false
    t.integer  "patient_id",             limit: 8
    t.integer  "doctor_id",              limit: 8
    t.integer  "nurse_id",               limit: 8
    t.boolean  "is_enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.string   "created_by"
    t.integer  "level"
    t.integer  "manager_id"
    t.integer  "technician_id",          limit: 8
    t.string   "credential_type_number"
    t.string   "mobile_phone"
    t.string   "email"
    t.string   "md5id"
    t.string   "mobile_token"
    t.string   "nick_name"
    t.string   "verification_code"
    t.string   "real_name"
    t.string   "registered_hospital"
  end

  add_index "users", ["doctor_id"], name: "index_users_on_doctor_id", using: :btree
  add_index "users", ["manager_id"], name: "index_users_on_manager_id", using: :btree
  add_index "users", ["mobile_token"], name: "index_users_on_mobile_token", using: :btree
  add_index "users", ["nurse_id"], name: "index_users_on_nurse_id", using: :btree
  add_index "users", ["patient_id"], name: "index_users_on_patient_id", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree
  add_index "users", ["technician_id"], name: "index_users_on_technician_id", using: :btree

  create_table "users_workspaces", force: true do |t|
    t.integer  "user_id",      limit: 8
    t.integer  "workspace_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_default",             default: false
  end

  create_table "versions", force: true do |t|
    t.string   "version_num"
    t.string   "url"
    t.datetime "update_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "change_content"
  end

  create_table "vfls", force: true do |t|
    t.integer  "patient_id",    limit: 8
    t.string   "measure_value"
    t.datetime "measure_time"
    t.string   "mdevice"
    t.boolean  "is_true"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "video_sources", force: true do |t|
    t.integer  "sid"
    t.string   "name"
    t.string   "address"
    t.string   "video_id"
    t.integer  "state",               default: 0
    t.string   "pid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "stop_recording_time", default: 0
  end

  add_index "video_sources", ["sid"], name: "index_video_sources_on_sid", unique: true, using: :btree

  create_table "video_types", force: true do |t|
    t.string   "type_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "viewpanels", force: true do |t|
    t.string   "name",                              null: false
    t.string   "desc"
    t.string   "icon"
    t.string   "spell_code"
    t.string   "action_url",                        null: false
    t.integer  "system_id",                         null: false
    t.string   "v_controller"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_support_mobile", default: false
  end

  create_table "website_agreements", force: true do |t|
    t.string   "title"
    t.string   "doc_type"
    t.text     "content"
    t.string   "brief"
    t.integer  "create_by_id",   limit: 8
    t.string   "create_by_name"
    t.integer  "update_by_id",   limit: 8
    t.string   "update_by_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "weights", force: true do |t|
    t.integer  "patient_id",   limit: 8
    t.string   "weight_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mdevice"
    t.string   "height"
    t.string   "bmi"
    t.string   "bfr"
    t.string   "smrwb"
    t.string   "vfl"
    t.string   "body_age"
    t.string   "bme"
    t.datetime "measure_time"
    t.boolean  "is_sure",                default: true
  end

  create_table "weixin_users", force: true do |t|
    t.string   "openid"
    t.integer  "patient_id", limit: 8
    t.integer  "doctor_id",  limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weixin_users", ["doctor_id"], name: "index_weixin_users_on_doctor_id", using: :btree
  add_index "weixin_users", ["openid"], name: "index_weixin_users_on_openid", using: :btree
  add_index "weixin_users", ["patient_id"], name: "index_weixin_users_on_patient_id", using: :btree

  create_table "workspaces", force: true do |t|
    t.string   "name",                               null: false
    t.string   "desc"
    t.string   "icon"
    t.string   "default_view_panel"
    t.text     "menu"
    t.text     "shortcut"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.boolean  "is_support_mobile",  default: false
    t.text     "mobile_menu"
    t.integer  "department_id"
    t.integer  "sysnode_id"
    t.string   "sysnode_name"
  end

end
