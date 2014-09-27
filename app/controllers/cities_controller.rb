class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  respond_to :js
  def index
    noOfRows = params[:rows]
    page = params[:page]
    ids = params[:province_id]
    if !ids.nil? && ids !=''
      ids_arr = ids.split(',')
      @cities = City.where(province_id:ids_arr)
    else
      @cities = City.all
    end
    records=0
    @total=0
    if !@cities.nil? && !@cities.empty?
      # "searchField"=>"name", "searchString"=>"张", "searchOper"=>"bw", "filters"=>""
      records = @cities.length
      @cities = @cities.paginate(:per_page => noOfRows, :page => page)
      if !noOfRows.nil?
        if records%noOfRows.to_i == 0
          @total = records/noOfRows.to_i
        else
          @total = (records/noOfRows.to_i)+1
        end
      end
      @rows=[]
      @cities.each do |doc|
        a={id:doc.id,
           cell:[
               doc.id,
               doc.name,
               doc.province_id,
           ]
        }
        @rows.push(a)
        end
    end
    @objJSON = {total:@total,rows:@rows,page:page,records:records}

    @objJSON.as_json
    p @objJSON.as_json
  end

  def new
    @city = City.new
  end
  def edit
  end

  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render action: 'show', status: :created, location: @city }
      else
        format.html { render action: 'new' }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @city.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  def set_city
    @city = City.find(params[:id])
  end

  def city_params
    params.require(:city).permit( :name, :province_id)
  end

end

