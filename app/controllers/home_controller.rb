class HomeController < ApplicationController
  def index
    if signed_in?
      @menus=current_user.admin2_menus
      p     @header_menus
      #  @menus= [
      # {name: '父节点1',id:'1', children: [
      #     {name: '子节点1',id:2},
      #     {name: '子节点2',id:3}
      # ]} ];
      #@menus.as_json
    else
      redirect_to '/sessions/sign_in'
    end
  end
end
