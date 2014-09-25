class ProvincesController < ApplicationController
  before_action :set_province, only: [:show, :edit, :update, :destroy]
  respond_to :js
  def index
    @provinces = Province.all
    total = @provinces.count
    provinces = @provinces
    @json = '{"success":true,"total":' << "#{total}" << ',"provinces":' << provinces.to_json << ' }'
    respond_with(@provinces) do |format|
      format.html{render "dictionaries/index.html.erb"}
      format.json {render  :json =>@json ,:id =>true  ,:root => true  }
    end
  end

  def new
    @province = Province.new
  end
  def edit
  end

  def create
    @province = Province.new(province_params)

    respond_to do |format|
      if @province.save
        format.html { redirect_to @province, notice: 'Province was successfully created.' }
        format.json { render action: 'show', status: :created, location: @province }
      else
        format.html { render action: 'new' }
        format.json { render json: @province.errors, status: :unprocessable_entity }
      end
    end
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
    @province.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private
  def set_province
    @province = Province.find(params[:id])
  end

  def province_params
    params.require(:province).permit(  :name, :short_name, :spell_name, :en_abbreviation )
  end

end

