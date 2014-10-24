class DictionariesController < ApplicationController
  before_action :set_dictionary, only: [:show, :edit, :update, :destroy]

  # GET /dictionaries
  # GET /dictionaries.json
  def index
    render partial: 'dictionaries/basic_dictionary'
  end

  def show_index
    sql = 'true'
    if !params[:dictionary_type_id].nil? && params[:dictionary_type_id] != '0' && params[:dictionary_type_id] != 'null'
      sql << " and dictionary_type_id = #{params[:dictionary_type_id]}"
    end
    @dictionaries = Dictionary.where(sql)
    count = @dictionaries.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @dictionaries = @dictionaries.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:dictionaries => @dictionaries.as_json(:include => [{:dictionary_type => {:only => [:id, :name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_dictionary
      destroy
    elsif params[:oper] == 'edit'
      set_dictionary
      update
    end
  end

  # GET /dictionaries/1
  # GET /dictionaries/1.json
  def show
  end

  # GET /dictionaries/new
  def new
    @dictionary = Dictionary.new
  end

  # GET /dictionaries/1/edit
  def edit
  end

  # POST /dictionaries
  # POST /dictionaries.json
  def create
    @dictionary = Dictionary.new(dictionary_params)
    if @dictionary.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @dictionary.save
    #    format.html { redirect_to @dictionary, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @dictionary }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @dictionary.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /dictionaries/1
  # PATCH/PUT /dictionaries/1.json
  def update
    if @dictionary.update(dictionary_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @dictionary.update(dictionary_params)
    #    format.html { redirect_to @dictionary, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @dictionary }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @dictionary.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /dictionaries/1
  # DELETE /dictionaries/1.json
  def destroy
   if @dictionary.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to dictionaries_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end


  def setting
    render template: 'dictionaries/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dictionary
      @dictionary = Dictionary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dictionary_params
      params.permit(:id,:dictionary_type_id, :name, :code, :description)
    end
end
