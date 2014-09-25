class ProvincesController < ApplicationController
  before_action :set_province, only: [:show, :edit, :update, :destroy]
  respond_to :js
  def index
    noOfRows = params[:rows]
    page = params[:page]
    @provinces = Province.all
    records=0
    @total=0
    if !@provinces.nil? && !@provinces.empty?
      # "searchField"=>"name", "searchString"=>"张", "searchOper"=>"bw", "filters"=>""
      records = @provinces.length
      @provinces = @provinces.paginate(:per_page => noOfRows, :page => page)
      if !noOfRows.nil?
        if records%noOfRows.to_i == 0
          @total = records/noOfRows.to_i
        else
          @total = (records/noOfRows.to_i)+1
        end
      end
      @rows=[]
      @provinces.each do |doc|
        a={id:doc.id,
           cell:[
               doc.id,
               doc.name,
               doc.short_name,
               doc.spell_name,
               doc.en_abbreviation
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

