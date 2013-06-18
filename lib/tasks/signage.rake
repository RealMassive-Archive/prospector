namespace :signage do
  desc "merge two old style nugget signages, so that survivor gets both nuggets' images and non-survivor is then removed"
  task :merge_two_old_nuggets => :environment do
    # AS OF 28 MARCH 2013 THIS MAY NO LONGER WORK. WE FINISHED CONVERTING OLD NUGGETS AND REMOVED SEVERAL NUGGET FIELDS NO LONGER IN USE
    # leaving code in here so that a New Nugget Merge can later be written

    # the first nugget should be the primary who survives, and the
    # second nugget have its image copied over to the primary.
    # also since we changed the uploader as part of the transition from an old nugget to a new nugget
    # this process depends on the TWO carrierwave uploaders in apps/uploaders/nugget_signage_uploader.rb and apps/uploaders/signage_uploader.rb
    # since we have to read the old nugget signage and then re-create it as new nugget signage

    # use:
    # rake signage:merge_two_old_nuggets primary=X [secondary=Y]
    #
    # if no secondary is specified, this task simply converts the old nugget to a new nugget.

    # based almost completely on code from:
    # https://gist.github.com/421736/3a50eb22b8ec2ffff20f0abc59c7433f353ea42f
    # be sure to read the comments and notes.
    # Might need to use .path for local file storange and .url for S3.
    # Also beware encoding.

    ENV['primary'] ||= nil
    ENV['secondary'] ||= nil
    puts "primary   is #{ENV['primary']}"
    puts "secondary is #{ENV['secondary']}"
    next if ENV['primary'].nil?

    # Load in the OPEN URI library to be able
    # to pull down and store the original file in a temp directory
    require 'open-uri'

    # Default constants
    TMP_PATH          = "#{Rails.root}/tmp/carrierwave"

    # Set environment constants
    CLASS             = 'Nugget'
    #ASSOCIATION       = 'signage' || nil
    ASSOCIATION       = nil
    MOUNTED_UPLOADER  = 'signage'.to_sym
    VERSIONS          = Array.new

    # Find the Model
    MODEL = Kernel.const_get(CLASS)

    # Create the temp directory
    %x(mkdir -p "#{TMP_PATH}")

    # Find all records for the provided Model
    if ENV['secondary'].nil?
      records = Nugget.where('id = ?', ENV['primary'].to_i)
    else
      records = Nugget.where('id = ? OR id = ?', ENV['primary'].to_i, ENV['secondary'].to_i)
    end

    # Run through all records
    records.each do |record|
      # Set the mounted uploader object
      # If it has a one-to-one association (singular) then that object
      # will be returned and wrapped in an array so we can "iterate" through it below.
      #
      # If it has a one-to-many association then it will return the array of associated objects
      #
      # If no association is specified, it assumes the amounted uploader is attached to the specified CLASS
      if ASSOCIATION
        if ASSOCIATION.singular?
          objects = [record.send(ASSOCIATION)]
        else
          objects = record.send(ASSOCIATION)
        end
      else
        objects = [record]
      end

      # Iterates through the objects
      objects.each do |object|

        #puts "object id: #{object.id}"
        #puts "object.signage.present? #{object.signage.present?}"
        #puts object.signage

        if object.signage.present?
          # Returns the mounted uploader object
          mounted_object = object.signage

          # Retrieve Filename
          filename = mounted_object.path.split('/').last

          # Read out the original file from the remote location
          # and write it out to the temp directory (TMP_PATH)
          # This file will be used as the base file to reprocess
          # the versions. Once all versions have been processed,
          # this temp file will be directly removed.

          # note use mounted_object.path in DEVELOPMENT and TEST
          # but use mounted_object.url in PRODUCTION
          # if Rails.env.test?  etc
          if Rails.env.test? || Rails.env.development?
            mnt = mounted_object.path
          else
            mnt = mounted_object.url
          end
          open(mnt) do |original_object|
            File.open(File.join(TMP_PATH, filename), 'w') do |temp_file|
              temp_file.binmode
              temp_file.write(original_object.read)
            end
          end

          # By default it will add all available versions to the versions variable
          # which means that all available versions will be reprocessed.
          # If the "versions" argument has been provided, then only the specified
          # version(s) will be set to the versions variable, and thus, only these
          # will be reprocessed.
          versions = mounted_object.versions.map {|version| version[0]}
          versions = VERSIONS unless VERSIONS.empty?
          puts "processing versions for #{object.id}: "
          puts versions.to_s

          # Reprocesses the versions
          ns = NuggetSignage.create( nugget_id: ENV['primary'].to_i, signage: mounted_object )
          new_mounted_object = ns.signage
          versions.each do |version|
            new_mounted_object.send(version).cache!(File.open(File.join(TMP_PATH, filename)))
            new_mounted_object.send(version).store!
          end

          # Removes the temp file
          %x(rm "#{TMP_PATH}/#{filename}")
        end

        # remove the original
        if object.id == ENV['primary'].to_i
          object.remove_signage!
          object.signage = nil
          object.is_new_multisignage_nugget = true
          object.save
        else
          object.is_new_multisignage_nugget = true
          object.destroy
        end
      end

    end
  end

  desc "merge two or more nuggets"
  task :merge_nuggets => :environmoent do
    # not written yet
    # the first nugget should be the primary who survives, and all
    # remaining nuggets should have their data subsumed. Likely, that just
    # means merging their images over to the primary.
    # note that this depends on the  carrierwave uploader in apps/uploaders/nugget_signage_uploader.rb
  end

  desc "given a Nugget, regenerate the versions"
  task :regenerate_versions => :environment do
  end

  desc "move signage to signage2"
  task :move_signages => :environment do
    puts "move images for the #{Rails.env} environment"
    path = Rails.env=="development" ? "http://localhost:3000" : ""
    NuggetSignage.all.each do |s|
      s.remote_signage2_url = path+s.signage.url
      s.save
      puts s.id
      puts "old signage path were=>"+s.signage.url.to_s
      puts "new signage2 path is=>"+s.signage2.url.to_s
      puts ""
    end
  end

end
