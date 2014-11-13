class PageBlock < ActiveRecord::Base
  belongs_to :home_page, :foreign_key => :page_id
end
