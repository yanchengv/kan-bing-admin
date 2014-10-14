class BloodFat < ActiveRecord::Base
  #:total_cholesterol    总胆固醇
  #:triglyceride       甘油三酯
  #:high_lipoprotein     高密度脂蛋白
  #:low_lipoprotein        低密度脂蛋白
  belongs_to :patient, :foreign_key => :patient_id
  # attr_accessible :patient_id,:total_cholesterol,:triglyceride,:high_lipoprotein,:low_lipoprotein,:measure_time

  def add_blood_fat  params
    blood=params
    blood_fat={}
    blood_fat[:patient_id]=blood['patient_id']
    blood_fat[:total_cholesterol]=blood['total_cholesterol']
    blood_fat[:triglyceride]=blood['triglyceride']
    blood_fat[:high_lipoprotein]=blood['high_lipoprotein']
    blood_fat[:low_lipoprotein]=blood['low_lipoprotein']
    blood_fat[:measure_time]=blood['measure_time']
    @blood_fats=BloodFat.where('patient_id=? AND measure_time=?',blood_fat[:patient_id],blood_fat[:measure_time]).first
    if @blood_fats
       @blood_fats.update_attributes(blood_fat)
    else
      @blood_fat=BloodFat.new(blood_fat)
      @blood_fat.save
    end
  end

  def all_blood_fat patient_id
    @blood_fats=BloodFat.where("patient_id=?", patient_id).order(measure_time: :asc)
    @total_cholesterol_data=[] #总胆固醇
    @triglyceride_data=[] #甘油三酯
    @high_lipoprotein_data=[] #高密度脂蛋白
    @low_lipoprotein_data=[] #低密度脂蛋白
    @blood_fats.each do |blood_fat|
      if !blood_fat.measure_time.nil?
        total_cholesterol=[blood_fat.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000, blood_fat.total_cholesterol.to_i] # 总胆固醇
        triglyceride=[blood_fat.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000, blood_fat.triglyceride.to_i] # 甘油三酯
        high_lipoprotein=[blood_fat.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000, blood_fat.high_lipoprotein.to_i] # 总胆固醇
        low_lipoprotein=[blood_fat.measure_time.strftime("%Y-%m-%d %H:%M:%S").to_time.to_i*1000, blood_fat.low_lipoprotein.to_i] # 甘油三酯
        @total_cholesterol_data.append total_cholesterol
        @triglyceride_data.append triglyceride
        @high_lipoprotein_data.append high_lipoprotein
        @low_lipoprotein_data.append low_lipoprotein
      end
    end
    {blood_fat_data:{total_cholesterol_data:@total_cholesterol_data,triglyceride_data:@triglyceride_data,high_lipoprotein_data:@high_lipoprotein_data,low_lipoprotein:@low_lipoprotein_data}}
  end
end
