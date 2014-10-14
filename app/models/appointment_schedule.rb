#author:wangfang
class AppointmentSchedule < ActiveRecord::Base
  before_create :set_pk_code
  after_create :mimas_sync_create
  before_update :mimas_sync_update
  before_destroy :mimas_sync_destroy
  after_create :set_time_bucket
  after_update  :update_time_bucket#, :set_time_allocation
  belongs_to :dictionary, :foreign_key => :dictionary_id
  #has_many :appointment_avalibles
  has_many :appointments,:dependent => :destroy
  has_many :appointment_arranges,:dependent => :destroy ,:foreign_key => :schedule_id
  belongs_to :doctor,:foreign_key => :doctor_id
  attr_accessible :avalailbecount, :schedule_date, :doctor_id, :start_time, :end_time, :dictionary_id ,:remaining_num ,:status

  def mimas_sync_update
    @str = {}
    self.changes.each do |k, v|
      @str[k.to_sym]=v[1]
    end
    @mimas = MimasDataSyncQueue.new(:foreign_key => self.id, :table_name => 'AppointmentSchedule',  :code => 3, :contents => @str.to_json(:except => [:updated_at]).to_s,:hospital =>self.doctor.hospital_id)
    @mimas.save
  end

  def mimas_sync_create
    @mimas = MimasDataSyncQueue.new(:foreign_key => self.id, :table_name => 'AppointmentSchedule',  :code => 1, :contents => '',:hospital =>self.doctor.hospital_id)
    @mimas.save
  end

  def mimas_sync_destroy
    @mimas = MimasDataSyncQueue.new(:foreign_key => self.id, :table_name => 'AppointmentSchedule',  :code => 2, :contents => '',:hospital =>self.doctor.hospital_id)
    @mimas.save
  end

  def set_pk_code
    self.id = pk_id_rules
  end

  def set_time_bucket
    date_cha = self.end_time.to_time - self.start_time.to_time
    step =  date_cha/ Integer(self.avalailbecount)
    while self.end_time.to_time > self.start_time.to_time do
      AppointmentArrange.create({:schedule_id => self.id,:time_arrange => self.start_time.to_time.strftime('%H:%M'), :doctor_id => self.doctor_id, :schedule_date => self.schedule_date, :status => 0})
      self.start_time = (self.start_time.to_time + Integer(step))
    end
  end

  def update_time_bucket
    if self.start_time_changed? || self.end_time_changed? || self.avalailbecount_changed?
      if self.id
        AppointmentArrange.destroy_all(:schedule_id => self.id)
      end
      date_cha = self.end_time.to_time - self.start_time.to_time
      step =  date_cha/ Integer(self.avalailbecount)
      while self.end_time.to_time > self.start_time.to_time  do
        AppointmentArrange.create({:schedule_id => self.id,:time_arrange => self.start_time.to_time.strftime('%H:%M'), :doctor_id => self.doctor_id, :schedule_date => self.schedule_date, :status => 0})
        self.start_time = (self.start_time.to_time + Integer(step))
      end
    end
  end
  #时间段分配
  #def set_time_allocation
  #  if self.remaining_num_changed?
  #    @appointment_arranges = AppointmentArrange.where(:schedule_id => self.id, :status => 0).order(:time_arrange)
  #    if !@appointment_arranges.empty?
  #      @appointment_arranges.first.update(:status => 1)
  #    end
  #  end
  #end

end
