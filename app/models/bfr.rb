#   脂肪率表
class Bfr < ActiveRecord::Base
  belongs_to :patient, :foreign_key => :patient_id
  attr_accessible :id, :patient_id,:measure_value,:measure_time,:is_true,:mdevice

  #  添加脂肪率
  def add_bfr  params
    bfr_params=params
    bfr={}
    bfr[:patient_id]=bfr_params['patient_id']
    bfr[:measure_value]=bfr_params['measure_value']
    bfr[:measure_time]=bfr_params['measure_time']
    @bfr=Bfr.where('patient_id=? AND measure_time=?',bfr[:patient_id],bfr[:measure_time]).first
    if @bfr
      @bfr.update_attributes(measure_value: bfr[:measure_value])
    else
      @bfr=Bfr.new(bfr)
      @bfr.save
    end
  end

  #  修改脂肪率表
  def update_bfr  params
    bfr_params=params
    bfr={}
    bfr[:patient_id]=bfr_params['patient_id']
    bfr[:measure_value]=bfr_params['measure_value']
    bfr[:measure_time]=bfr_params['measure_time']
    @bfr=Bfr.where('patient_id=? AND measure_time=?',bfr[:patient_id],bfr[:measure_time]).first
    if @bfr
      @bfr.update_attributes(measure_value: bfr[:measure_value])
    end
  end

  #获取所有的脂肪率
  def all_bfr_data patient_id
    @bfr=Bfr.new
    #@blood_glucoses=BloodGlucose.where("patient_id=? AND measure_date<=? AND measure_date>=?",patient_id,Date.today,Date.today-30).order(measure_date: :asc)
    @bfr_all=Bfr.where('patient_id=?',patient_id).order(measure_time: :asc)
    @bfr_data=[]
    @bfr_all.each do |bfr|
      if !bfr.measure_time.nil?
        bfr_data=[bfr.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000,bfr.measure_value.to_i]
        @bfr_data.append bfr_data
      end
    end
    @bfr_data

  end
end
