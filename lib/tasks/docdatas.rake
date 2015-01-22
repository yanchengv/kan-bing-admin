namespace :db do
  desc "遍历所有的医院 更新所有的医生对应的省市 "
  task hospeach: :environment do
      Hospital.all.each do |  hosp|
        hospid = hosp.id
         hospital_name = hosp.name
         province_id = hosp.province_id
         province_name = hosp.province_name
         city_id = hosp.city_id
         city_name = hosp.city_name

         #更新医生对应的省 市  id name  医院name
         #docs =  Doctor.where(:hospital_id => hospid)
         #if docs.count > 0
         #  count =   docs.update_all(:hospital_name =>hospital_name,
         #                            :province_name => province_name,
         #                            :province_id => province_id,
         #                            :city_id => city_id,
         #                            :city_name => city_name)
         #  p "#{hospid} ----#{hospital_name}---#{province_id} ----#{province_name}----#{hospid} ----#{city_id}------#{city_name}---#{count}"
         #else
         #  p "#{hospid} --------#{hospital_name}-------0"
         #end
         index = hospital_name.index("（")
         if index.nil?
           index = hospital_name.index("(")
         end


        if !index.nil?
          newname =hospital_name[0,index]
          short_name = hospital_name[index,100]

          if !newname.nil?
            hosp.update(:name => newname )
          end

          if !short_name.nil?
            hosp.update(:short_name => short_name )
          end
        end



      end

  end




  task docsp: :environment do
    p "开始更新省份"
    Province.all.each  do | provin|
       pid = provin.id
       pname = provin.name

       docs = Doctor.where(:province_id => pid)
       if docs.count > 0
          count =   docs.update_all(:province_name => pname)
          p "#{pid} --------#{pname}-------#{count}"
       else
          p "#{pid} --------#{pname}-------0"
       end
    end
  end

  task docsc: :environment do
  City.all.each  do | city|
    city_id = city.id
    city_name = city.name
    docs = Doctor.where(:city_id => city_id)
    if docs.count > 0
      countc = docs.update_all(:city_name => city_name)
      city_name
      p "#{city_id} --------#{city_name}-------#{countc}"
    else
      p "#{city_id} --------#{city_name}-------0"
    end
  end
  end


  #通过科室更新对应的
  task  docupdatebyDep: :environment do
    Department.all.each  do |dep|
      department_id = dep.id
      department_name = dep.name

      doctors = Doctor.where(:department_id => department_id)
      if doctors.count > 0
        if !department_name.nil?
          doctors.update_all(:department_name => department_name)
        end
      end
    end

  end

  def tmp
    arr = %w(五指山市  文昌市   琼海市  万宁市  儋州市  东方市 白沙黎族   昌江黎族   乐东黎族   陵水黎族   保亭黎族苗族   琼中黎族苗族 洋浦经济)
    h = Hospital
    arr.each do  |city|
      hs = h.where("name like '%#{city}%'   or address  like   '%#{city}%'  ")
      if hs.count >0
        hs.update_all(:city_id => '7567' ,:city_name => '省直辖县级行政区')
        p " #{city} --------#{hs.count}}  "
      else
        p " #{city} --------0}  "
      end

    end
########################################################################################

    h.where("name like '%昆明%' or address like '%昆明%' ").update_all(
        :city_id => '7957',
        :city_name => '昆明市'
    )
########################################################################################
    c = "青岛"

    def rep(c)
      h = Hospital
      cname = "%#{c}%"
      city = City.where("name like '#{cname}'").first
      if !city.nil?

        cid = city.id
        province_name = city.province.name
        province_id = city.province.id
        h.where("name like '#{cname}' or address like '#{cname}' ").update_all(
            :city_id => cid ,
            :city_name => "#{c}市",
            :province_name => province_name,
            :province_id => province_id

        )
      end

    end







########################################################################################
    cid = 6615
    h.where("name like '%胶州%' or address like '%胶州%' ").update_all(
        :city_id => cid ,
        :city_name => "青岛市"
    )
########################################################################################


    h.where(" name like '%辽宁省%' or address like '%辽宁省%'  ").update_all(
        province_id: 4780,province_name:'辽宁省'
    )

  end



########################################################################################
  # Doctor.where("birthday like '2014%' and  (province_id is null or city_id is null  or  hospital_name is null  )    ").update_all(
  #     :province_id => 5648 ,
  #     :city_id => 8103,
  #     :province_name =>'北京市' ,
  #     :city_name =>  '石景山区',
  #     :hospital_id =>1 ,
  #     :hospital_name =>'清华大学玉泉医院' )
  #
  #
  # Doctor.where("hospital_id is nil")


end