class PageBlock < ActiveRecord::Base
  has_many :block_contents, :foreign_key => :block_id, :dependent => :destroy
  include SessionsHelper
  before_create :set_pk_code
  # before_save :set_default_value
  def set_pk_code
    if self.id&&self.id!=0
      self.id = id
    else
      self.id = pk_id_rules
    end
  end

  def get_template  block_type,block_name,current_user
    block_type=block_type
    @block_name=block_name

    #添加的区块为医生列表模板时,默认本科室的所有医生(10条)
    if block_type == 'doctor_list'
      @doctors = doctors_default current_user
      @doctor = @doctors[0]
    end

    # 等同于controller 中的render partial:'page_blocks/templates/jianjie' 的功能
    template = ActionView::Base.new(Rails.configuration.paths['app/views']).render(
        :partial => "page_blocks/templates/#{block_type}",
        :formats => :html,
        :handlers => :erb,
        # :object =>@block_name,
        :locals => {:@block_name=>@block_name,:@doctors=>@doctors,:@doctor=>@doctor}

    )
    pra={}
    pra[:name]=@block_name
    pra[:block_type]=block_type
    pra[:content]= template
    pra[:hospital_id]=current_user.hospital_id
    pra[:department_id]=current_user.department_id
    pra[:is_show]=false
    @page_block=PageBlock.new(pra)
    @flag=@page_block.save

    # 如果是医生列表模板则保存医生id到block_cotent
     save_doctors_to_block_content  block_type,@doctors,@page_block
     data={page_block:@page_block}
     return  data

  end

  #获取科室或医院的前十条医生信息
  def doctors_default  current_user
    if !current_user.nil?
      sql = 'true'
      if !current_user.hospital_id.nil? && !current_user.hospital_id != ''
        sql << " and hospital_id = #{current_user.hospital_id}"
      end
      if !current_user.department_id.nil? && !current_user.department_id != ''
        sql << " and department_id = #{current_user.department_id}"
      end
      return Doctor.where(sql).limit(10)
    else
      return Doctor.where('1 != 1')
    end
  end

  # 如果是医生列表模板则保存医生id到block_cotent
  def save_doctors_to_block_content block_type,doctors ,page_block
    if block_type == 'doctor_list'
      doctor_ids = []
      doctors.each do |doc|
        doctor_ids.push(doc.id)
      end
      @block_content = BlockContent.new(block_id: page_block.id, content: doctor_ids.join(","))
      @block_content.save
    end
    return @block_content
  end
  def set_default_value
    @hospital = Hospital.where(:id => self.hospital_id)
    self.hospital_name = @hospital.first.name if !@hospital.first.nil?
    @department = Department.where(:id => self.department_id)
    self.department_name = @department.first.name if !@department.first.nil?
  end
end
