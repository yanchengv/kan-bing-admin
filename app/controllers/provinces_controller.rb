class ProvincesController < ApplicationController
  before_filter :signed_in_user
  before_action :set_province, only: [:show, :edit, :update, :destroy]
  respond_to :js

  def index
    render partial: 'provinces/province_manage'
  end
  def test_index
    sql = 'true'
    if params[:province_name] && params[:province_name] != ''
      sql << " and name like '%#{params[:province_name]}%'"
      sql << " or short_name like '%#{params[:province_name]}%'"
      sql << " or spell_name like '%#{params[:province_name]}%'"
    end
    @provinces = Province.where(sql)
    count = @provinces.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @provinces = @provinces.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:provinces => @provinces.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_province
      destroy
    elsif params[:oper] == 'edit'
      set_province
      update
    end
  end

  def new
    @province = Province.new
  end

  def edit
  end

  def create
    @province = Province.new(province_params)
    if @province.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end
  end

  def show
  end

  def update
    if @province.update(province_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
  end

  def destroy
    if @province.destroy
      render :json => {:success => true}
    end
  end

  private
  def set_province
    @province = Province.find(params[:id])
  end

  def province_params
    params.permit(:id, :name, :short_name, :spell_name, :en_abbreviation )
  end

end

