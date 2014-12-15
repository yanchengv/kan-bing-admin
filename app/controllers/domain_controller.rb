class DomainController < ApplicationController
   # after_filter :get_template,only: :create
  def show
    render partial: 'page_blocks/domain_manage'
  end
  def domain_list
    @domains = Domain.where(hospital_id:current_user.hospital_id, department_id:current_user.department_id).order('created_at desc')
    count = @domains.count
    # totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @domains = @domains.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {data: @domains.as_json}
  end
  def create
    domain={}
    domain[:name]= params[:name]
    domain[:hospital_id]=current_user.hospital_id
    domain[:department_id]=current_user.department_id
    is_domain=Domain.where(name:domain[:name])
    hos_dept=Domain.where(hospital_id:domain[:hospital_id],department_id:domain[:department_id])

    if is_domain.empty? && hos_dept.empty?
      @flag="sucess"
      @domain=Domain.new(domain)
      @domain.save
      @domain.init_template  #如果医院科室第一次添加域名则默认首页面模板
    elsif is_domain.empty? && !hos_dept.empty?
      @flag="sucess"
      @domain=Domain.new(domain)
      @domain.save
    else

      @flag="false"
    end
    render json:{flag:@flag}
  end

  def update
    @domain=Domain.find(params[:id])
    name=params[:name]
    if name!=@domain.name
      is_domain=Domain.where(name:name)
      if is_domain.empty?
        @domain.update_attributes(name:name)
        @flag="sucess"
      else
        @flag="false"
      end
    else
      @flag="sucess"
    end
    render json:{flag:@flag}
  end

  def destroy
    id=params[:id]
    @domain=Domain.find(id)
    hospital_id=@domain.hospital_id
    department_id=@domain.department_id
    Domain.destroy(id)

    @domains=Domain.where(hospital_id:hospital_id,department_id:department_id)
    if @domains.empty?
      @page_blocks=PageBlock.where(hospital_id:hospital_id,department_id:department_id)
      if  !@page_blocks.empty?
        @page_blocks.each do |page_block|
          PageBlock.destroy(page_block.id)
        end
      end


    end
    render json:{flag:"sucess"}
  end

  #操作转向
  def oper_action
    if params[:oper] == 'del'
      destroy
    end
  end

   # 获取模版
   def init_template
     block_type='jianjie'
     @block_name="科室简介"
     #添加的区块为医生列表时,默认本科室的所有医生(10条)
     if block_type == 'doctor_list'
       @doctors = doctors_default
       @doctor = @doctors[0]
     end
     @template=ApplicationController.new.render_to_string(:partial => "page_blocks/templates/#{block_type}")
     pra={}
     pra[:name]=block_type
     pra[:block_type]="科室简介"
     pra[:content]= @template
     pra[:hospital_id]=current_user.hospital_id
     pra[:department_id]=current_user.department_id
     @page_block=PageBlock.new(pra)
     @page_block.save
   end

   def save_template
     name=params[:name]
     block_type=params[:type]
     content= params[:content]
     hospital_id=current_user.hospital_id
     department_id=current_user.department_id
     @page_block=PageBlock.new(name:name,block_type:block_type,content:content,hospital_id:hospital_id,department_id:department_id)
     @page_block.save
     if block_type == 'login'
       render :partial => 'page_blocks/show'
     else
       if block_type == 'doctor_list'
         doctor_ids = []
         @docs = doctors_default
         @docs.each do |doc|
           doctor_ids.push(doc.id)
         end
         @block_content = BlockContent.new(block_id: @page_block.id, content: doctor_ids.join(","))
         @block_content.save
       end
       render partial: "block_contents/#{block_type}_manage"
     end
   end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_domain
    @domain = Domain.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def domain_params
    params.permit(:id,:name,:hospital_id,:department_id,:introduction)
  end
end
