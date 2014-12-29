class GroupsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    render :partial => 'groups/groups_manage'
  end

  def show_index
    sql = 'true'
    if params[:name] && params[:name] != '' && params[:name] != 'null'
      sql << " and name like '%#{params[:name]}%'"
    end
    count = Group.where(sql).count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @groups = Group.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:groups => @groups.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_group
      destroy
    elsif params[:oper] == 'edit'
      set_group
      update
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
    render :partial => 'groups/add'
  end

  # GET /groups/1/edit
  def edit
    render :partial => 'groups/edit'
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    if current_user
      @group.create_user_id = current_user.id
      @group.create_user = current_user.name
    end
    if @group.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @group.save
    #    format.html { redirect_to @group, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @group }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @group.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    if @group.update(group_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @group.update(group_params)
    #    format.html { redirect_to @group, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @group }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @group.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
   if @group.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to groups_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @groups = Group.where("id in (#{params[:ids].join(',')})")
      if @groups.delete_all
        render :json => {:success => true}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.permit(:id, :name, :desc, :photo, :web_site, :create_user_id, :create_user, :expert_count, :sort)
    end
end
