CarrierWave.configure do |config|
  if Rails.env.development? || Rails.env.test?
    config.storage = :file
  else
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => 'AKIAJNYGBKJOOKTZDGJQ',
      :aws_secret_access_key  => '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',
    }
    config.fog_directory  = 'realmassive_nuggets'
  end
end
