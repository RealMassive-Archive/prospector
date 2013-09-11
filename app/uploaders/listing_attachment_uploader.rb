# encoding: utf-8

class ListingAttachmentUploader < CarrierWave::Uploader::Base
# Include RMagick or MiniMagick support:
# include CarrierWave::RMagick
# include CarrierWave::MiniMagick

  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  # storage :fog
  # storage :file

  def cache_dir
    '/tmp/listing-attachment-cache'
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    if Rails.env.development? || Rails.env.test?
      dir_stub = "tmp/#{Rails.env}/"
    else
      dir_stub = ""
    end
    "#{dir_stub}listing_attachments/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))

    #{}"/images/fallback/" + [version_name, "default.png"].compact.join('_')
    "https://s3.amazonaws.com/realmassive_nuggets/image_not_found.jpg"
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # correctly orient the image
  def auto_orient
    manipulate! do |image|
      image.auto_orient
      image
    end
  end
  #process :auto_orient

  # no matter how big original was we're just going to standardize its size
  process resize_to_fit: [nil,600]

  version :retina, :if => :image? do
    process :resize_to_fit => [nil, 1200]

    def full_filename(for_file = ListingAttachment.file.file)
      super.tap do |file_name|
        file_name.gsub!('.', '@2x.').gsub!('retina_', '')
      end
    end
  end

  version :medium, :if => :image? do
    process resize_to_fit: [nil,300]
  end

  version :retina_medium, :from_version => :retina do
    process :resize_to_fit => [nil, 600]

    def full_filename(for_file = ListingAttachment.file.file)
      super.tap do |file_name|
        file_name.gsub!('.', '@2x.').gsub!('retina_', '')
      end
    end
  end

  version :small, :from_version => :medium do
    process resize_to_fit: [nil,150]
  end

  version :retina_small, :from_version => :retina_medium do
    process :resize_to_fit => [nil, 300]

    def full_filename(for_file = ListingAttachment.file.file)
      super.tap do |file_name|
        file_name.gsub!('.', '@2x.').gsub!('retina_', '')
      end
    end
  end

  version :thumb, :from_version => :small do
    process resize_to_fit: [nil,75]
  end

  version :retina_thumb, :from_version => :retina_small do
    process :resize_to_fit => [nil, 150]

    def full_filename(for_file = ListingAttachment.file.file)
      super.tap do |file_name|
        file_name.gsub!('.', '@2x.').gsub!('retina_', '')
      end
    end
  end

  version :tiny, :from_version => :thumb do
    process resize_to_fit: [nil,50]
  end

  version :retina_tiny, :from_version => :retina_thumb do
    process :resize_to_fit => [nil, 100]

    def full_filename(for_file = ListingAttachment.file.file)
      super.tap do |file_name|
        file_name.gsub!('.', '@2x.').gsub!('retina_', '')
      end
    end
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png gif doc pdf docx)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  protected
  #check if the file type is image!
  def image?(new_file)
    #new_file.content_type.include? 'image'
    true
  end


  private
  def strip_exif_data
    manipulate! do |img|
      img.strip
      img = yield(img) if block_given?
      img
    end
  end

end
