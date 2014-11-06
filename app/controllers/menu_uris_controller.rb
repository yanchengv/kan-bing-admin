class MenuUrisController < ApplicationController
  before_action :set_menu_uri, only: [:show, :edit, :update, :destroy]

  # GET /menu_uris
  # GET /menu_uris.json
  def index
    # @menu_uris = MenuUri.all
    render partial: 'menu_uris/menu_uri_manage'
  end

  def show_index
    sql='true'
    @menu_uris = MenuUri.where(sql)
    count = @menu_uris.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @menu_uris = @menu_uris.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:menu_uris => @menu_uris.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_menu_uri
      destroy
    elsif params[:oper] == 'edit'
      set_menu_uri
      update
    end
  end

  # GET /menu_uris/1
  # GET /menu_uris/1.json
  def show
  end

  # GET /menu_uris/new
  def new
    @menu_uri = MenuUri.new
  end

  # GET /menu_uris/1/edit
  def edit
  end

  # POST /menu_uris
  # POST /menu_uris.json
  def create
    @menu_uri = MenuUri.new(menu_uri_params)
    if @menu_uri.save
      render json: {success:true}
    else
      render json: {success:false}
    end

    # respond_to do |format|
    #   if @menu_uri.save
    #     format.html { redirect_to @menu_uri, notice: 'Menu uri was successfully created.' }
    #     format.json { render :show, status: :created, location: @menu_uri }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @menu_uri.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /menu_uris/1
  # PATCH/PUT /menu_uris/1.json
  def update
    if @menu_uri.update(menu_uri_params)
      render json: {success:true}
    else
      render json: {success:false}
    end

    # respond_to do |format|
    #   if @menu_uri.update(menu_uri_params)
    #     format.html { redirect_to @menu_uri, notice: 'Menu uri was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @menu_uri }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @menu_uri.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /menu_uris/1
  # DELETE /menu_uris/1.json
  def destroy
    if @menu_uri.destroy
      render json:{success:true}
    else
      render json: {success:false}
    end

    # respond_to do |format|
    #   format.html { redirect_to menu_uris_url, notice: 'Menu uri was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu_uri
      @menu_uri = MenuUri.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_uri_params
      params.permit(:menu_name, :menu_uri, :instruction)
    end
end
