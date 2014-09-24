class Menu < ActiveRecord::Base
  has_many :admin2_menus

  def all_menus
    @menus=Menu.all

  end
end
