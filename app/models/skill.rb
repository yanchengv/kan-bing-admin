class Skill < ActiveRecord::Base


  before_save :default_values

  default_scope { where sort: 'desc' }
  scope :index_scope, ->{ where(index_page_show: true) }

  validates :name, :photo, :desc, presence: true

  def default_values
    self.sort ||= 0
    self.index_page_show ||= 0
  end



end
