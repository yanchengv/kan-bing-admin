#    身体质量指数表
class Bmi < ActiveRecord::Base

  belongs_to :patient, :foreign_key => :patient_id
  # attr_accessible :id, :patient_id,:measure_value,:measure_time,:is_true,:mdevice


  #  添加身体质量指数表
  def add_bmi  params
    bmi_params=params
    bmi={}
    bmi[:patient_id]=bmi_params['patient_id']
    bmi[:measure_value]=bmi_params['measure_value']
    bmi[:measure_time]=bmi_params['measure_time']
    @bmi=Bmi.where('patient_id=? AND measure_time=?',bmi[:patient_id],bmi[:measure_time]).first
    if @bmi
      @bmi.update_attributes(measure_value: bmi[:measure_value])
    else
      @bmi=Bmi.new(bmi)
      @bmi.save
    end
  end

  #  修改身体质量指数表
  def update_bmi  params
    bmi_params=params
    bmi={}
    bmi[:patient_id]=bmi_params['patient_id']
    bmi[:measure_value]=bmi_params['measure_value']
    bmi[:measure_time]=bmi_params['measure_time']
    @bmi=Bmi.where('patient_id=? AND measure_time=?',bmi[:patient_id],bmi[:measure_time]).first
    if @bmi
      @bmi.update_attributes(measure_value: bmi[:measure_value])
    end
  end

  #获取所有的身体质量指数
  def all_bmi_data patient_id
    @bmi=Bmi.new
    #@blood_glucoses=BloodGlucose.where("patient_id=? AND measure_date<=? AND measure_date>=?",patient_id,Date.today,Date.today-30).order(measure_date: :asc)
    @bmi_all=Bmi.where('patient_id=?',patient_id).order(measure_time: :asc)
    @bmi_data=[]
    @bmi_all.each do |bmi|
      if !bmi.measure_time.nil?
        bmi_data=[bmi.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000,bmi.measure_value.to_i]
        @bmi_data.append bmi_data
      end
    end
    @bmi_data

  end
end
