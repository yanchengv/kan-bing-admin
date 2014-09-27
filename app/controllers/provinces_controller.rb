class ProvincesController < ApplicationController
  before_action :set_province, only: [:show, :edit, :update, :destroy]
  respond_to :js
  def index
    noOfRows = params[:rows]
    page = params[:page]
    if !params[:id].nil? && params[:id] != ''
      @provinces_all = Province.where(id:params[:id])
    else
      @provinces_all = Province.all
    end
    records=0
    @total=0
    if !@provinces_all.nil? && !@provinces_all.empty?
      # "searchField"=>"name", "searchString"=>"张", "searchOper"=>"bw", "filters"=>""
      records = @provinces_all.length
      @provinces = @provinces_all.paginate(:per_page => noOfRows, :page => page)
      if !noOfRows.nil?
        if records%noOfRows.to_i == 0
          @total = records/noOfRows.to_i
        else
          @total = (records/noOfRows.to_i)+1
        end
      end
      @rows=[]
      @provinces.each do |province|
        #province.cities.each do |city|
         # province.counties.each do |county|
        a={id:province.id,
           cell:[
               province.id,
               province.name,
               province.short_name,
               province.spell_name,
               #city.name,
               #county.name
           ]
        }
        @rows.push(a)
       # end
        # end
      end
    end
    @objJSON = {total:@total,rows:@rows,page:page,records:records}

    @objJSON.as_json
    p @objJSON.as_json
  end

  def new
    @menu_id = params[:menu_id]
    @province = Province.new
    render partial: 'provinces/form'
  end

  def edit
    @menu_id = params[:menu_id]
    @province = Province.new
    render partial: 'provinces/form'
  end

  def create
    @province = Province.create(province_params)
    render json: {success:true,data:@province}
  end

  def get_city
    @city = City.all
    if !params[:province_id].nil? && params[:province_id] != ''
      @city = City.where(province_id:params[:province_id])
    end
    render partial: 'provinces/city_partial'
  end

  def get_county
    @county = County.all
    if !params[:province_id].nil? && params[:province_id]!= ''
      @county = County.where(province_id:params[:province_id])
    else if !params[:city_id].nil? && params[:city_id]!= ''
        @county = County.where(city_id: params[:city_id])
      end
    end
    render partial: 'provinces/county_partial'
  end

  def get_search_result
    render '/provinces'
  end

  def show
  end

  def update
    respond_to do |format|
      if @province.update(province_params)
        format.html { redirect_to @province, notice: 'Province was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @province.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    ids = params[:ids]
    ids_arr = ids.split(',')
    @provinces = Province.where(id:ids_arr)
    if !@provinces.empty?
      @provinces.each do |doc|
        doc.destroy
      end
    end
    render json:{success:true}
  end

  private
  def set_province
    @province = Province.find(params[:id])
  end

  def province_params
    params.require(:province).permit(  :name, :short_name, :spell_name, :en_abbreviation )
  end

end

