class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]
  respond_to :js
  def index
    @province_id = params[:province_id]
    if @province_id
      @cities = City.where(:province_id => @province_id)
    else
      @cities = City.all
    end
    total = @cities.count
    cities = @cities
    @json = '{"success":true,"total":' << "#{total}" << ',"cities":' << cities.to_json << ' }'
    respond_to do |format|
      format.json {render  :json =>@json}
    end
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

