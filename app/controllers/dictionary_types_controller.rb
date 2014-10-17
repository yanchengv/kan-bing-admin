class DictionaryTypesController < ApplicationController
  before_action :set_dictionary_type, only: [:show, :edit, :update, :destroy]

  # GET /dictionary_types
  # GET /dictionary_types.json
  def index
  end

  def show_index
    sql = 'true'
    @dictionary_types = DictionaryType.where(sql)
    count = @dictionary_types.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @dictionary_types = @dictionary_types.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:dictionary_types => @dictionary_types.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_dictionary_type
      destroy
    elsif params[:oper] == 'edit'
      set_dictionary_type
      update
    end
  end

  # GET /dictionary_types/1
  # GET /dictionary_types/1.json
  def show
  end

  # GET /dictionary_types/new
  def new
    @dictionary_type = DictionaryType.new
  end

  # GET /dictionary_types/1/edit
  def edit
  end

  # POST /dictionary_types
  # POST /dictionary_types.json
  def create
    @dictionary_type = DictionaryType.new(dictionary_type_params)
    if @dictionary_type.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @dictionary_type.save
    #    format.html { redirect_to @dictionary_type, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @dictionary_type }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @dictionary_type.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /dictionary_types/1
  # PATCH/PUT /dictionary_types/1.json
  def update
    if @dictionary_type.update(dictionary_type_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @dictionary_type.update(dictionary_type_params)
    #    format.html { redirect_to @dictionary_type, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @dictionary_type }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @dictionary_type.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /dictionary_types/1
  # DELETE /dictionary_types/1.json
  def destroy
   if @dictionary_type.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to dictionary_types_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def setting
    render template: 'dictionary_types/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dictionary_type
      @dictionary_type = DictionaryType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dictionary_type_params
      params.permit(:id, :name, :code, :description)
    end
end
