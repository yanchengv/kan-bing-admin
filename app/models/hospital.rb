include SessionsHelper
class Hospital < ActiveRecord::Base
  belongs_to :province
  belongs_to :city
  before_save :init_msg
  before_create :set_pk_code
  def init_msg
    self.spell_code = PinYin.abbr(self.name)
    self.province_name = Province.find(self.province_id).name if self.province_id && self.province_id != ''
    self.city_name = City.find(self.city_id).name if self.city_id && self.city_id != ''
  end

  def set_pk_code
    if self.id&&self.id!=0
      self.id = id
    else
      self.id = pk_id_rules
    end
  end

  def manage_hospitals  menu_name
    @menu=Menu.where(name:menu_name).first
    @hospitals=Hospital.find_by_sql("select h.id,h.name from hospitals h,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=1 and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu.id} and mp.menu_id=menus.id and h.id=mp.hospital_id GROUP BY h.id;")
  end
end
