# == Schema Information
#
# Table name: messages
#
#  id         :integer          not null, primary key
#  content    :text
#  channel_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Message < ActiveRecord::Base
=begin
  attr_accessible :content,:channel_id,:user_id
=end
  belongs_to :user
  belongs_to :channel
end
