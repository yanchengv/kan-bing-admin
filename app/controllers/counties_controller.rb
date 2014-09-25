class CountiesController < ApplicationController
  before_action :set_province, only: [:show, :edit, :update, :destroy]
  def index
    noOfRows = params[:rows]
    page = params[:page]
    @counties = County.all
    records=0
    @total=0
    if !@counties.nil? && !@counties.empty?
      # "searchField"=>"name", "searchString"=>"张", "searchOper"=>"bw", "filters"=>""
      records = @counties.length
      @counties = @counties.paginate(:per_page => noOfRows, :page => page)
      if !noOfRows.nil?
        if records%noOfRows.to_i == 0
          @total = records/noOfRows.to_i
        else
          @total = (records/noOfRows.to_i)+1
        end
      end
      @rows=[]
      @counties.each do |doc|
        a={id:doc.id,
           cell:[
               doc.id,
               doc.name,
               doc.province_id
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