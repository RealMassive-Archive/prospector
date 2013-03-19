CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.test?
    config.storage = :file
  else
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJNYGBKJOOKTZDGJQ',
      :aws_secret_access_key  => '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'
    }
    config.fog_directory  = 'realmassive_nuggets'
  end
end

module CarrierWave
  module MiniMagick

    # Rotates the image based on the EXIF Orientation
    def fix_exif_rotation
      manipulate! do |img|
        img.auto_orient  #note: if switching to RMagick, make this "auto_orient!" (bang at end)
        img = yield(img) if block_given?
        img
      end
    end

    # Strips out all embedded information from the image
    def strip
      manipulate! do |img|
        img.strip #note: if switching to RMagick, make this "strip!" (bang at end)
        img = yield(img) if block_given?
        img
      end
    end

  end
end

