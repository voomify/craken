require "craken"

namespace :craken do

  desc "Install raketab script"
  task :install do    
    require 'erb'
    include Craken
    unless Craken.raketab_files.empty?
      files = (plural = Craken.raketab_files.size > 1) ? Craken.raketab_files.join(", ") : Craken.raketab_files.first
      puts "craken:install => Using raketab file#{plural ? 's' : ''} #{files}" 
      crontab = append_tasks(load_and_strip, raketab)
      install crontab
    end
  end

  desc "Uninstall cron jobs associated with application"
  task :uninstall do
    include Craken
    # install stripped cron
    install load_and_strip
  end

end
