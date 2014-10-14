#author:wangfang
class AppointmentCancelSchedule < ActiveRecord::Base
  attr_accessible :canceltimeblock, :canceldate, :canceldoctor_id,:appointment_schedule_id
end
