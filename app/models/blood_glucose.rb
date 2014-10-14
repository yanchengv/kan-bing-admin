class BloodGlucose < ActiveRecord::Base
  belongs_to :patient, :foreign_key => :patient_id
  attr_accessible :id, :patient_id,:measure_value,:measure_date,:measure_time,:mdevice


  #添加血糖
  def add_blood_glucose  params
    blood= params
    glucose={}
    glucose[:patient_id]=blood['patient_id']
    glucose[:measure_value]=blood['measure_value']
    glucose[:measure_date]=blood['measure_date']
    @blu_glu=BloodGlucose.where('patient_id=? AND measure_date=?',glucose[:patient_id],glucose[:measure_date]).first
    if @blu_glu
      @blu_glu.update_attributes(measure_value: glucose[:measure_value])
    else
      @blood_glucose=BloodGlucose.new(glucose)
      @blood_glucose.save
    end

  end


  #获取最近30天的血糖
  def get_blood_glucoses patient_id
    @blood_glucoses=BloodGlucose.where("patient_id=? AND measure_date<=? AND measure_date>=?",patient_id,Date.today,Date.today-30).order(measure_date: :asc)
    @glucose_data=[]
    @blood_glucoses.each do |blood|
      if !blood.measure_date.nil?
        blood_glu=[blood.measure_date.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000,blood.measure_value.to_i]
        @glucose_data.append blood_glu
      end
    end
    @glucose_data

  end

  def all_blood_glucoses patient_id
    @blood_glucoses=BloodGlucose.where("patient_id=?",patient_id).order(measure_date: :asc)
    @glucose_data=[]
    @blood_glucoses.each do |blood|
      if !blood.measure_date.nil?
        blood_glu=[blood.measure_date.strftime("%Y-%m-%d").to_time.to_i*1000,blood.measure_value.to_i]
        @glucose_data.append blood_glu
      end
    end
    @glucose_data
  end

  #修改血糖
  def update_blood_glucose

  end



#    新瑞时智能健康网关“尔康”数据接口



  def create_json

    { _json:[
        {
        measureTime: "2013-11-12 10:24:21",
        bgValue: 7.0,
        mdevice: "YICH8002",
        scanCode:113932081081001
    }   ,
        {
            measureTime: "2013-11-12 10:24:21",
            bgValue: 7.0,
            mdevice: "YICH8002",
            scanCode:113932081081001
        }

    ],
    scanCode:124545
    }
  end
end
