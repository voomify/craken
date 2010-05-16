require 'socket'
require "#{File.dirname(__FILE__)}/raketab"

module Craken
 require 'craken/railtie' if defined?(Rails)

  def determine_raketab_files
    if File.directory?("#{deploy_path}/config/craken/") # Use hostname specific raketab first.
      raketabs = Dir["#{deploy_path}/config/craken/*raketab*"].partition {|f| f =~ %r[/raketab.*$] }
      raketabs.last.empty? ? raketabs.first : raketabs.last.grep(/#{hostname}_raketab/)
    else
      Dir["#{deploy_path}/config/raketab*"]
    end
  end

  def hostname
    Socket.gethostname.split('.').first.downcase.strip    
  end
 
  def deploy_path
    Craken.deploy_path
  end

 def self.deploy_path
     ENV['deploy_path'] || (Rails.root.to_s  if defined?(Rails))
 end

def raketab_files
   ENV['raketab_files'].split(":") rescue determine_raketab_files
end

def crontab_exe
  ENV['crontab_exe'] || "/usr/bin/crontab"
end

def rake_exe
  Craken.rake_exe
end

 def self.rake_exe
   ENV['rake_exe'] || (rake = `which rake`.strip and rake.empty?) ? "/usr/bin/rake" : rake
 end

 def self.raketab_rails_env
   ENV['raketab_rails_env'] || RAILS_ENV
 end

def raketab_rails_env
  Craken.raketab_rails_env
end

  # assumes root of app is name of app, also takes into account 
  # capistrano deployments

def app_name
  ENV['app_name'] || (deploy_path =~ /\/([^\/]*)\/releases\/\d*$/ ? $1 : File.basename(deploy_path))
end

 
  # see here: http://unixhelp.ed.ac.uk/CGI/man-cgi?crontab+5
  SPECIAL_STRINGS   = %w[@reboot @yearly @annually @monthly @weekly @daily @midnight @hourly]

  # strip out the existing raketab cron tasks for this project
  def load_and_strip
    crontab = ''
    old = false
    `#{crontab_exe} -l`.each_line do |line|
      line.strip!
      if old || line == "### #{app_name} raketab"
        old = line != "### #{app_name} raketab end"
      else
        crontab << line
        crontab << "\n"
      end
    end
    crontab
  end

  def append_tasks(crontab, raketab)
    crontab << "### #{app_name} raketab\n"
    raketab.each_line do |line|
      line.strip!
      unless line =~ /^#/ || line.empty? # ignore comments and blank lines
        sp = line.split
        if SPECIAL_STRINGS.include?(sp.first)
          crontab << sp.shift
          tasks = sp
        else
          crontab << sp[0,5].join(' ')
          tasks = sp[5,sp.size]
        end
        crontab << " cd #{deploy_path} && #{rake_exe} --silent RAILS_ENV=#{raketab_rails_env}"
        tasks.each do |task|
          crontab << " #{task}"
        end
        crontab << "\n"
      end
    end
    crontab << "### #{app_name} raketab end\n"
    crontab
  end

  # install new crontab
  def install(crontab)
    filename = ".crontab#{rand(9999)}" 
    File.open(filename, 'w') { |f| f.write crontab }
    `#{crontab_exe} #{filename}`
    FileUtils.rm filename
  end
  
  def raketab(files=raketab_files)    
    files.map do |file|
      next unless File.exist?(file)
      builder = file =~ /.(\w+)$/ ? "build_raketab_from_#{$1}" : "build_raketab"
      send(builder.to_sym, file)
    end.join("\n")
  end
  
  private
    def build_raketab_from_rb(file)
      eval(File.new(file).read).tabs
    end
  
    def build_raketab_from_yml(file)
      yml = YAML::load(ERB.new(File.read(file)).result(binding))
      yml.map do |name,tab|
        format = []
        format << (tab['min'] || tab['minute'] || '0')
        format << (tab['hour'] || '0')
        format << (tab['day'] || '*')
        format << (tab['month'] =~ /^\d+$/ ? tab['month'] : Date._parse(tab['month'].to_s)[:mon] || '*')
        format << ((day = tab['weekday'] || tab['wday'] and day =~ /^\d+$/ ? day : Date._parse(day.to_s)[:wday]) || '*')
        format << tab['command']
        format.join(' ')        
      end.join("\n")
    end
    alias_method :build_raketab_from_yaml, :build_raketab_from_yml
    
    def build_raketab(file)
      ERB.new(File.read(file)).result(binding)
    end

    def method_missing(method, *args)
      method.to_s =~ /^build_raketab/ ? build_raketab(*args) : super
    end

end
