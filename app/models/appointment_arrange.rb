class AppointmentArrange < ActiveRecord::Base
  before_create :set_pk_code
  after_create :mimas_sync_create
  before_update :mimas_sync_update
  before_destroy :mimas_sync_destroy
  # attr_accessible :id,
  #                 :schedule_id,
  #                 :time_arrange,
  #                 :doctor_id,
  #                 :schedule_date,
  #                 :status,
  #                 :modality_device_id
  has_one :appointment,:dependent => :destroy
  belongs_to :doctor, :foreign_key => :doctor_id
  belongs_to :appointment_schedule, :foreign_key => :schedule_id
  def set_pk_code
    self.id = pk_id_rules
  end

  def mimas_sync_update
    @str = {}
    self.changes.each do |k, v|
      @str[k.to_sym]=v[1]
    end
    @mimas = MimasDataSyncQueue.new(:foreign_key => self.id, :table_name => 'AppointmentArrange',  :code => 3, :contents => @str.to_json(:except => [:updated_at]).to_s,:hospital =>self.doctor.hospital_id)
    @mimas.save
  end

  def mimas_sync_create
    @mimas = MimasDataSyncQueue.new(:foreign_key => self.id, :table_name => 'AppointmentArrange',  :code => 1, :contents => '',:hospital =>self.doctor.hospital_id)
    @mimas.save
  end

  def mimas_sync_destroy
    @mimas = MimasDataSyncQueue.new(:foreign_key => self.id, :table_name => 'AppointmentArrange',  :code => 2, :contents => '',:hospital =>self.doctor.hospital_id)
    @mimas.save
  end
end
