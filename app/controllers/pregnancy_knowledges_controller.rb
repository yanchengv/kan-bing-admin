class PregnancyKnowledgesController < ApplicationController
  before_filter :signed_in_user
  before_action :set_pregnancy_knowledge, only: [:show, :edit, :update, :destroy]

  # GET /pregnancy_knowledges
  # GET /pregnancy_knowledges.json
  def index
    render :partial => 'pregnancy_knowledges/pregnancy_knowledges_manage'
  end

  def show_index
    sql = 'true'
    if !params[:parent_id].nil? && params[:parent_id] != '0' && params[:parent_id] != 'null'
      sql << " and parent_id = #{params[:parent_id]}"
    else
      if params[:str] == 'knowledge_type'
        sql << ' and parent_id is null'
      end
      if params[:str] == 'knowledge'
        sql << ' and parent_id is not null'
      end
    end
    if !params[:title].nil? && params[:title] != '' && params[:title] != 'null'
      sql << " and title like '%#{params[:title]}%'"
    end
    @pregnancy_knowledges = PregnancyKnowledge.where(sql).order('created_at desc')
    count = @pregnancy_knowledges.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @pregnancy_knowledges = @pregnancy_knowledges.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:pregnancy_knowledges => @pregnancy_knowledges.as_json(:include => [{:parent => {:only => [:id, :title]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_pregnancy_knowledge
      destroy
    elsif params[:oper] == 'edit'
      set_pregnancy_knowledge
      update
    end
  end

  # GET /pregnancy_knowledges/1
  # GET /pregnancy_knowledges/1.json
  def show
  end

  # GET /pregnancy_knowledges/new
  def new
    @pregnancy_knowledge = PregnancyKnowledge.new
  end

  # GET /pregnancy_knowledges/1/edit
  def edit
  end

  # POST /pregnancy_knowledges
  # POST /pregnancy_knowledges.json
  def create
    @pregnancy_knowledge = PregnancyKnowledge.new(pregnancy_knowledge_params)
    if @pregnancy_knowledge.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @pregnancy_knowledge.save
    #    format.html { redirect_to @pregnancy_knowledge, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @pregnancy_knowledge }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @pregnancy_knowledge.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /pregnancy_knowledges/1
  # PATCH/PUT /pregnancy_knowledges/1.json
  def update
    if @pregnancy_knowledge.update(pregnancy_knowledge_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @pregnancy_knowledge.update(pregnancy_knowledge_params)
    #    format.html { redirect_to @pregnancy_knowledge, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @pregnancy_knowledge }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @pregnancy_knowledge.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /pregnancy_knowledges/1
  # DELETE /pregnancy_knowledges/1.json
  def destroy
    @pregnancy_knowledges = PregnancyKnowledge.where(:parent_id => @pregnancy_knowledge.id).delete_all
   if @pregnancy_knowledge.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to pregnancy_knowledges_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end


  def setting
    render template: 'pregnancy_knowledges/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pregnancy_knowledge
      @pregnancy_knowledge = PregnancyKnowledge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pregnancy_knowledge_params
      params.permit(:id, :parent_id, :title, :content)
    end
end
