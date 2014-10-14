class Channel < ActiveRecord::Base
  has_many :messages, :dependent => :destroy
  belongs_to :consultation

  validates :consultation, :presence => { :message => "Room must belong to a consultation"}
end
