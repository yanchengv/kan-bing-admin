class BloodPressure < ActiveRecord::Base
  belongs_to :patient, :foreign_key => :patient_id
  attr_accessible :id, :patient_id, :measure_value,:heart_rate, :measure_date,:measure_time,:systolic_pressure,:diastolic_pressure,:mdevice

  #添加血糖
  def add_blood_pressure (params)
    pre=params
    pressure={}
    pressure[:patient_id]=pre['patient_id']
    pressure[:systolic_pressure]=pre['systolic_pressure']
    pressure[:diastolic_pressure]=pre['diastolic_pressure']
    pressure[:measure_time]=pre['measure_time']
    @blo_pre=BloodPressure.where('patient_id=? AND measure_time=?',pressure[:patient_id],pressure[:measure_time]).first
    if @blo_pre
      @blo_pre.update_attributes(systolic_pressure:pressure[:systolic_pressure],diastolic_pressure:pressure[:diastolic_pressure])
    else
      @blood_pressure=BloodPressure.new(pressure)
      @blood_pressure.save
    end
  end

  #修改血压
  def update_blood_pressure (params)
    pre=params
    pressure={}
    pressure[:patient_id]=pre['patient_id']
    pressure[:systolic_pressure]=pre['systolic_pressure']
    pressure[:diastolic_pressure]=pre['diastolic_pressure']
    pressure[:measure_time]=pre['measure_time']
    @blo_pre=BloodPressure.where('patient_id=? AND measure_time=?',pressure[:patient_id],pressure[:measure_time]).first
    if @blo_pre
      @blo_pre.update_attributes(systolic_pressure:pressure[:systolic_pressure],diastolic_pressure:pressure[:diastolic_pressure])
    end
  end

  #获取最近30天的血压
  def get_blood_pressure (patient_id)
    @blood_pressure=BloodPressure.where("patient_id=? AND measure_time<=? AND measure_time>=?", patient_id, Date.today, Date.today-30).order(measure_time: :asc)
    @systolic_pressure_data=[] #收缩压数据
    @diastolic_pressure_data=[] #舒张压数据
    @blood_pressure.each do |pressure|
      if !pressure.measure_time.nil?
        systolic_pres=[pressure.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000, pressure.systolic_pressure.to_i] # 收缩压
        diastolic_pres=[pressure.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000, pressure.diastolic_pressure.to_i] # 舒张压
        @systolic_pressure_data.append systolic_pres
        @diastolic_pressure_data.append diastolic_pres
      end
    end
    {pressure_data:{systolic_pressure_data:@systolic_pressure_data,diastolic_pressure_data:@diastolic_pressure_data}}
  end




  def all_blood_pressure (patient_id)
    @blood_pressure=BloodPressure.where("patient_id=?", patient_id).order(measure_time: :asc)
    @systolic_pressure_data=[] #收缩压数据
    @diastolic_pressure_data=[] #舒张压数据
    @blood_pressure.each do |pressure|
      if !pressure.measure_time.nil?
        systolic_pres=[pressure.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000, pressure.systolic_pressure.to_i] # 收缩压
        diastolic_pres=[pressure.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000, pressure.diastolic_pressure.to_i] # 舒张压
        @systolic_pressure_data.append systolic_pres
        @diastolic_pressure_data.append diastolic_pres
      end
    end
    {pressure_data:{systolic_pressure_data:@systolic_pressure_data,diastolic_pressure_data:@diastolic_pressure_data}}
  end

  #    新瑞时智能健康网关“尔康”数据接口
  def create_json
    {_json:[
        {
            measureTime: "2012-11-12 10:24:21",
            systolic: 150,
            diastolic: 75,
            heartRate: 65,
            ahdId: "XXXXXX",
            mdevice: "OMRN1001"
        },
        {
            measureTime: "2012-11-08 16:12:21",
            systolic: 190,
            diastolic: 100,
            heartRate: 120,
            ahdId: "XXXXXX",
            mdevice: "OMRN1001" }
    ]
    }
  end
end
