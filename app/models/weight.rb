class Weight < ActiveRecord::Base
  belongs_to :patient, :foreign_key => :patient_id
 # attr_accessible  :patient_id,:weight_value,:measure_time,:mdevice,:height,:bmi,:bfr,:smrwb,:vfl,:body_age,:bme

#获取所有的体重
  def all_weight_data patient_id
    @weight=Weight.new
    #@blood_glucoses=BloodGlucose.where("patient_id=? AND measure_date<=? AND measure_date>=?",patient_id,Date.today,Date.today-30).order(measure_date: :asc)
    @weight_all=Weight.where('patient_id=?',patient_id).order(measure_time: :asc)
    @weight_data=[]
    @weight_all.each do |weight|
      if !weight.measure_time.nil?
        weight_data=[weight.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000,weight.weight_value.to_i]
        @weight_data.append weight_data
      end
    end
    @weight_data

  end

#  添加体重
  def add_weight  params
    weight_params=params
    weight={}
    weight[:patient_id]=weight_params['patient_id']
    weight[:weight_value]=weight_params['weight_value']
    weight[:measure_time]=weight_params['measure_time']
    @weight=Weight.where('patient_id=? AND measure_time=?',weight[:patient_id],weight[:measure_time]).first
    if @weight
      @weight.update_attributes(weight_value: weight[:weight_value])
    else
      @weight=Weight.new(weight)
      @weight.save
    end
  end

  # 修改体重
  def update_weight  params
    weight_params=params
    weight={}
    weight[:patient_id]=weight_params['patient_id']
    weight[:weight_value]=weight_params['weight_value']
    weight[:measure_time]=weight_params['measure_time']
    @weight=Weight.where('patient_id=? AND measure_time=?',weight[:patient_id],weight[:measure_time]).first
    if @weight
      @weight.update_attributes(weight_value: weight[:weight_value])
    end
  end

  #    新瑞时智能健康网关“尔康”数据接口
    def create_json
      {_json:[
          {
          measureTime: "2012-11-12 10:24:21",
          weight: 150,
          bmi: 75,
          height: 65.0,
          bfr: 65.0,
          smrwb: 20,
          vfl: 10,
          bodyAge: 10,
          bme: 10,
          ahdId: "XXXXXX",
          mdevice: "OMRN1002"
        }
      ]
      }
    end
end
