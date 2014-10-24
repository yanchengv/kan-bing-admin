class VideoType < ActiveRecord::Base
  has_many :edu_videos, dependent: :destroy
end
