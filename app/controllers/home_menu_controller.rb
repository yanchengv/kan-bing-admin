class HomeMenuController < ApplicationController
  def create

  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_home_page
    @home_menu = HomeMenu.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def home_page_params
    params.permit(:id,:name,:parent_id,:hospital_id,:department_id,:content,:show_in_menu,:link_url,:skip_to_first_child,:show_in_header,:show_in_footer,:depth)
  end
end
