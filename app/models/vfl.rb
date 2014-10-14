# 内脏脂肪指数
class Vfl < ActiveRecord::Base
  belongs_to :patient, :foreign_key => :patient_id
  # attr_accessible :id, :patient_id,:measure_value,:measure_time,:is_true,:mdevice


  #  添加内脏脂肪指数
  def add_vfl  params
    vfl_params=params
    vfl={}
    vfl[:patient_id]=vfl_params['patient_id']
    vfl[:measure_value]=vfl_params['measure_value']
    vfl[:measure_time]=vfl_params['measure_time']
    @vfl=Vfl.where('patient_id=? AND measure_time=?',vfl[:patient_id],vfl[:measure_time]).first
    if @vfl
      @vfl.update_attributes(measure_value: vfl[:measure_value])
    else
      @vfl=Vfl.new(vfl)
      @vfl.save
    end
  end

  #  修改内脏脂肪指数
  def update_vfl  params
    vfl_params=params
    vfl={}
    vfl[:patient_id]=vfl_params['patient_id']
    vfl[:measure_value]=vfl_params['measure_value']
    vfl[:measure_time]=vfl_params['measure_time']
    @vfl=Vfl.where('patient_id=? AND measure_time=?',vfl[:patient_id],vfl[:measure_time]).first
    if @vfl
      @vfl.update_attributes(measure_value: vfl[:measure_value])
    end
  end

  #获取所有的内脏脂肪指数
  def all_vfl_data patient_id
    @vfl=Vfl.new
    #@blood_glucoses=BloodGlucose.where("patient_id=? AND measure_date<=? AND measure_date>=?",patient_id,Date.today,Date.today-30).order(measure_date: :asc)
    @vfl_all=Vfl.where('patient_id=?',patient_id).order(measure_time: :asc)
    @vfl_data=[]
    @vfl_all.each do |vfl|
      if !vfl.measure_time.nil?
        vfl_data=[vfl.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000,vfl.measure_value.to_i]
        @vfl_data.append vfl_data
      end
    end
    @vfl_data

  end
end
