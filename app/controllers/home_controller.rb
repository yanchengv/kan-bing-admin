class HomeController < ApplicationController
  def index
    if signed_in?

    else
      redirect_to '/sessions/sign_in'
    end
  end
end
