# 基础代谢
class Bme < ActiveRecord::Base

  belongs_to :patient, :foreign_key => :patient_id
  attr_accessible :id, :patient_id,:measure_value,:measure_time,:is_true,:mdevice

  #  添加基础代谢
  def add_bme  params
    bme_params=params
    bme={}
    bme[:patient_id]=bme_params['patient_id']
    bme[:measure_value]=bme_params['measure_value']
    bme[:measure_time]=bme_params['measure_time']
    @bme=Bme.where('patient_id=? AND measure_time=?',bme[:patient_id],bme[:measure_time]).first
    if @bme
      @bme.update_attributes(measure_value: bme[:measure_value])
    else
      @bme=Bme.new(bme)
      @bme.save
    end
  end

  #  修改基础代谢
  def update_bme  params
    bme_params=params
    bme={}
    bme[:patient_id]=bme_params['patient_id']
    bme[:measure_value]=bme_params['measure_value']
    bme[:measure_time]=bme_params['measure_time']
    @bme=Bme.where('patient_id=? AND measure_time=?',bme[:patient_id],bme[:measure_time]).first
    if @bme
      @bme.update_attributes(measure_value: bme[:measure_value])
    end
  end

  #获取所有的基础代谢
  def all_bme_data patient_id
    @bme=Bme.new
    #@blood_glucoses=BloodGlucose.where("patient_id=? AND measure_date<=? AND measure_date>=?",patient_id,Date.today,Date.today-30).order(measure_date: :asc)
    @bme_all=Bme.where('patient_id=?',patient_id).order(measure_time: :asc)
    @bme_data=[]
    @bme_all.each do |bme|
      if !bme.measure_time.nil?
        bme_data=[bme.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000,bme.measure_value.to_i]
        @bme_data.append bme_data
      end
    end
    @bme_data

  end
end
