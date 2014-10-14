#author:wangfang
class AppointmentAvalible < ActiveRecord::Base
  belongs_to :dictionary, foreign_key: :dictionary_id
  # attr_accessible :avalibletimeblock, :avalibleappointmentdate, :avaliblecount, :avalibledoctor_id, :schedule_id, :dictionary_id
end
