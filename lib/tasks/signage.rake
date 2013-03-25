namespace :signage do
  desc "merge two old style nugget signages, so that survivor gets both nuggets' images and non-survivor is then removed"
  task :merge_two_oldies => :environment do
    puts "survivor is #{ENV['opt1']}"
  end

  desc "given a Nugget, regenerate the versions"
  task :regenerate_versions => :environment do
  end

end
