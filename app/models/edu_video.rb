class EduVideo < ActiveRecord::Base
  mount_uploader :video_url, VideoUploader
  belongs_to :video_type, :foreign_key => :video_type_id
  belongs_to :doctor
end
