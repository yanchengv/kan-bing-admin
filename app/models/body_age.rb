# 身体年龄
class BodyAge < ActiveRecord::Base
  belongs_to :patient, :foreign_key => :patient_id
  # attr_accessible :id, :patient_id,:measure_value,:measure_time,:is_true,:mdevice


  #  添加基础代谢
  def add_body_age  params
    body_age_params=params
    body_age={}
    body_age[:patient_id]=body_age_params['patient_id']
    body_age[:measure_value]=body_age_params['measure_value']
    body_age[:measure_time]=body_age_params['measure_time']
    @body_age=BodyAge.where('patient_id=? AND measure_time=?',body_age[:patient_id],body_age[:measure_time]).first
    if @body_age
      @body_age.update_attributes(measure_value: body_age[:measure_value])
    else
      @body_age=BodyAge.new(body_age)
      @body_age.save
    end
  end

  #  修改基础代谢
  def update_body_age  params
    body_age_params=params
    body_age={}
    body_age[:patient_id]=body_age_params['patient_id']
    body_age[:measure_value]=body_age_params['measure_value']
    body_age[:measure_time]=body_age_params['measure_time']
    @body_age=BodyAge.where('patient_id=? AND measure_time=?',body_age[:patient_id],body_age[:measure_time]).first
    if @body_age
      @body_age.update_attributes(measure_value: body_age[:measure_value])
    end
  end

  #获取所有的基础代谢
  def all_body_age_data patient_id
    @body_age=BodyAge.new
    #@blood_glucoses=BloodGlucose.where("patient_id=? AND measure_date<=? AND measure_date>=?",patient_id,Date.today,Date.today-30).order(measure_date: :asc)
    @body_age_all=BodyAge.where('patient_id=?',patient_id).order(measure_time: :asc)
    @body_age_data=[]
    @body_age_all.each do |body_age|
      if !body_age.measure_time.nil?
        body_age_data=[body_age.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000,body_age.measure_value.to_i]
        @body_age_data.append body_age_data
      end
    end
    @body_age_data

  end
end
