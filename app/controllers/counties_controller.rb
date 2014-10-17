class CountiesController < ApplicationController
  before_action :set_county, only: [:show, :edit, :update, :destroy]
  def index
  end
  def test_index
    ids = params[:city_id]
    if !ids.nil? && ids !=''
      ids_arr = ids.split(',')
      @counties = County.where(city_id:ids_arr)
    else
      @counties = County.all
    end
    sql = 'true'
    if params[:county_name] && params[:county_name] != ''
      sql << " and name like '%#{params[:county_name]}%'"
      sql << " or city_id = '#{params[:county_name].to_i}'"
      sql << " or province_id = '#{params[:county_name].to_i}'"
      @counties = County.where(sql)
    end
    count = @counties.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @counties = @counties.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:counties => @counties.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_county
      destroy
    elsif params[:oper] == 'edit'
      set_county
      update
    end
  end

  def new
    @county = County.new
  end

  def edit
  end

  def create
    @county = County.new(county_params)
    @county.id = County.maximum(:id) + 1
    if @county.save
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '添加失败'}
    end
  end

  def update
    if @county.update(county_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
  end

  def destroy
    if @county.destroy
      render :json => {:success => true}
    end
  end

  private
  def set_county
    @county = County.find(params[:id])
  end
  def county_params
    params.permit(:id, :name, :city_id, :province_id)
  end
end