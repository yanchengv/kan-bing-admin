class DomainController < ApplicationController

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
    if is_domain.empty?
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
    Domain.destroy(id)
    render json:{flag:"sucess"}
  end

  #操作转向
  def oper_action
    if params[:oper] == 'del'
      destroy
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
