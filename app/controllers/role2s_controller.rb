class Role2sController < ApplicationController
  before_filter :signed_in_user#,:access_control
  before_action :set_role2, only: [:show, :edit, :update, :destroy]

  # GET /role2s
  # GET /role2s.json
  def index
    # @role2s = Role2.all
  end

  # GET /role2s/1
  # GET /role2s/1.json

  def show_index
    sql = 'true'
    # if params[:name] && params[:name] != ''
    #   sql << " and name like '%#{params[:name]}%'"
    # end
    # if params[:email] && params[:email] != ''
    #   sql << " and email like '%#{params[:email]}%'"
    # end
    # if params[:photo] && params[:photo] != ''
    #   sql << " and name like '%#{params[:photo]}%'"
    # end
    @role2s = Role2.where(sql)
    count = @role2s.count
    p count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @role2s = @role2s.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:role2s => @role2s.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      destroy
    elsif params[:oper] == 'edit'
      update
    end
  end

  def show
  end

  # GET /role2s/new
  def new
    @role2 = Role2.new
  end

  # GET /role2s/1/edit
  def edit
  end

  # POST /role2s
  # POST /role2s.json
  def create
    @role2s = Role2.where(name:params[:name])
    if params[:name] == ''
      render :json => {success:false,error:'角色名不可为空!'}
    elsif !@role2s.empty?
      render :json => {success:false,error:'角色名不可重复!'}
    else
      @role2 = Role2.new(role2_params)
      if @role2.save
        @role2 = {id:'role-'+@role2.id.to_s,name:@role2.name,pId:0,menu_permission_id:'',open:true}
        render :json => {success:true,data:@role2}
      else
        render :json => {success:false,error:'保存失败!'}
      end
    end
    # respond_to do |format|
    #   if @role2.save
    #     format.html { redirect_to @role2, notice: 'Role2 was successfully created.' }
    #     format.json { render :show, status: :created, location: @role2 }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @role2.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /role2s/1
  # PATCH/PUT /role2s/1.json
  def update
    @role2 = Role2.find(params[:id])
    if @role2.update(role2_params)
      render :json => {success:true}
    else
      render :json => {success:false,error:'更新失败!'}
    end
    # respond_to do |format|
    #   if @role2.update(role2_params)
    #     format.html { redirect_to @role2, notice: 'Role2 was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @role2 }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @role2.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def update_name
    p_role_id = params[:id]
    role_id = p_role_id[p_role_id.index('-')+1,p_role_id.length]
    @role2 = Role2.find_by(id:role_id)
    if !@role2.nil?
      @role2.update(name:params[:name])
    end
    render json: @role2
  end

  # DELETE /role2s/1
  # DELETE /role2s/1.json
  def destroy
    @role2 = Role2.find(params[:id])
    if @role2.destroy
      render :json => {success:true}
    else
      render :json => {success:false,error:'删除失败!'}
    end
    # respond_to do |format|
    #   format.html { redirect_to role2s_url, notice: 'Role2 was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role2
      @role2 = Role2.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role2_params
      params.permit(:name, :code, :instruction)
    end
end
