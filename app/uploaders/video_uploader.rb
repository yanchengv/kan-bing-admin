# encoding: utf-8

class VideoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #p  model.instance_values
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    #"/dfs/#{uuid[0,3]}/#{uuid[4,2]}/#{uuid[7,2]}"
    #"/dfs/#{model.instance_values["attributes"]["video_path"][1, 2]}/#{model.instance_values["attributes"]["video_path"][4, 2]}/#{model.instance_values["attributes"]["video_path"][7, 2]}"
     "/dfs/flv/#{model.instance_values["attributes"]["video_url"][1,2]}/#{model.instance_values["attributes"]["video_url"][4,2]}/#{model.instance_values["attributes"]["video_url"][7,2]}/"

  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename

    if  original_filename
      if @uuid
        if model.instance_values['attributes']['id']
          "#{@uuid[10,100]}.flv"
        else
          "#{@uuid}.flv"
        end

      else
        @uuid = UUIDTools::UUID.random_create.to_s
        @uuid = @uuid.gsub('-','')
        #uuid = uuid[1,2]+'/'+uuid[4,2]+'/'+uuid[7,2]+'/'+uuid[10,100]
        "#{@uuid}.flv"
      end
    end
  end

end
