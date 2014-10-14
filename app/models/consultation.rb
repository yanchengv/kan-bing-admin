# encoding: utf-8

class Consultation < ActiveRecord::Base
  # attr_accessible :id,
  #                 :owner_id,
  #                 :patient_id,
  #                 :init_info,
  #                 :purpose,
  #                 :name,
  #                 :status,
  #                 :number,
  #                 :status_description,
  #                 :created_at,
  #                 :start_time,
  #                 :schedule_time,
  #                 :end_time

  belongs_to :owner, class_name: "Doctor"
  belongs_to :patient
  has_one :channel, :dependent => :destroy
  has_one :consultation, :dependent => :destroy
  has_many :doctor_lists,:dependent => :destroy
  has_many :docmembers, class_name: "Doctor", :through => :doctor_lists
  has_many :consultation_create_records

end
