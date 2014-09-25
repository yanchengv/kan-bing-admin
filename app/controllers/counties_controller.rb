class CountiesController < ApplicationController
  before_action :set_province, only: [:show, :edit, :update, :destroy]
  def index
    @city_id = params[:city_id]
    if @city_id
      @county = County.where(:city_id => @city_id)
    else
      @county = County.all
    end
    total = @county.count
    county = @county
    @json = '{"success":true,"total":' << "#{total}" << ',"county":' << county.to_json << ' }'
    respond_to do |format|
      format.json{render :json => @json}
    end
  end

  def new
    @county = County.new
  end

  def edit
  end

  def create
    @county = County.new(county_params)
    respond_to do |format|
      if @county.save
        format.html{redirect_to @county , notice: 'County was successfully created.'}
        format.json{render action: 'show',status: :created,location: @county}
      else
        format.html{render action: 'new'}
        format.json{render json: @county.errors,status: :unprocessable_entity}
      end
    end
  end
=begin
  def update
    respond_to do |format|
      if @county.update(county_params)
        format.html{redirect_to @county,notice: 'County was successfully updated.'}
        format.json{head :no_content}
      else
        format.html{render action: 'edit'}
        format.json{render json: @county.errors,status: :unprocessable_entity}
      end
    end
  end
=end
=begin
  def destroy
    @county.destroy()
    respond_to do |format|
      format.json { head :no_content }
    end
  end
=end

  private
  def set_county
    @county = County.find(params[:id])
  end
  def county_params
    params.require(:county).permit(:name, :city_id)
  end
end