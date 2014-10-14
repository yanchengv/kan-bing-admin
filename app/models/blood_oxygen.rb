class BloodOxygen < ActiveRecord::Base
  #pulse_rate:脉率、o_saturation:血氧饱和度、灌注指数（PI）
  belongs_to :patient, :foreign_key => :patient_id
  attr_accessible :patient_id,:pulse_rate,:o_saturation,:pi,:measure_time,:mdevice

  #获取所有的血氧
  def all_blood_oxygen patient_id
    #@blood_glucoses=BloodGlucose.where("patient_id=? AND measure_date<=? AND measure_date>=?",patient_id,Date.today,Date.today-30).order(measure_date: :asc)
    @blood_oxygen_all=BloodOxygen.where('patient_id=?',patient_id).order(measure_time: :asc)
    @blood_oxygen_data=[]
    @blood_oxygen_all.each do |blood_oxygen|
      if !blood_oxygen.measure_time.nil?
        blood_oxygen_data=[blood_oxygen.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000,blood_oxygen.o_saturation.to_i]
        @blood_oxygen_data.append blood_oxygen_data
      end
    end
    @blood_oxygen_data

  end

#  添加血氧
  def add_blood_oxygen  params
    oxygen_params=params
    blood_oxygen={}
    blood_oxygen[:patient_id]=oxygen_params['patient_id']
    blood_oxygen[:o_saturation]=oxygen_params['o_saturation']
    blood_oxygen[:measure_time]=oxygen_params['measure_time']
    @blood_oxygen=BloodOxygen.where('patient_id=? AND measure_time=?',blood_oxygen[:patient_id],blood_oxygen[:measure_time]).first
    if @blood_oxygen
      @blood_oxygen.update_attributes(o_saturation: blood_oxygen[:o_saturation])
    else
      @blood_oxygen=BloodOxygen.new(blood_oxygen)
      @blood_oxygen.save
    end
  end

  #    新瑞时智能健康网关“尔康”数据接口

  def create_json
    {_json:[
        {
          measureTime: "2012-11-12 10:24:21",
          spo2: 98,
          heartRate: 90,
          ahdId: "XXXXXX",
          mdevice: "ETCO3002" }
    ]
    }
  end
end
