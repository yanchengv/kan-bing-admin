class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  respond_to :js
  def index
  end
  def test_index
    ids = params[:province_id]
    if !ids.nil? && ids !=''
      ids_arr = ids.split(',')
      @cities = City.where(province_id:ids_arr)
    else
      @cities = City.all
    end
    sql = 'true'
    if params[:city_name] && params[:city_name] != ''
      sql << " and name like '%#{params[:city_name]}%'"
      sql << " or province_id = '#{params[:city_name].to_i}'"
      @cities = City.where(sql)
    end
    count = @cities.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @cities = @cities.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:cities => @cities.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_city
      destroy
    elsif params[:oper] == 'edit'
      set_city
      update
    end
  end

  def new
    @city = City.new
  end
  def edit
  end

  def create
    @city = City.new(city_params)
    if @city.save
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '添加失败'}
    end
  end

  def update
    if @city.update(city_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
  end

  def destroy
    if @city.destroy
      render :json => {:success => true}
    end
  end

  private
  def set_city
    @city = City.find(params[:id])
  end

  def city_params
    params.permit(:id, :name, :province_id)
  end

end

