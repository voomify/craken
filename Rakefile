require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: run unit tests.'
task :default => :spec

desc 'Generate documentation for the craken plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Craken'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Run all specs"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = FileList['spec']
  t.libs << 'lib'
end


namespace :gem do
  begin
    require 'jeweler'
    gem_name = 'craken'

    Jeweler::Tasks.new do |gem|
      gem.name = gem_name
      gem.summary = 'Craken gem'
      gem.files = Dir['{lib}/**/*', '{tasks}/**/*', '{recipes}/**/*','init.rb','MIT-LICENSE', 'README.rdoc']
      gem.author = 'Doug McInnes'
      gem.email =  'doug@dougmcinnes.com'
      gem.description = 'A Rails plugin for managing and installing rake-centric crontab files.'
      gem.homepage = 'http://www.github.com/latimes/craken'
      # other fields that would normally go in your gemspec also be included here
    end
  rescue
    puts 'Jeweler or one of its dependencies is not installed.'
  end

   task :uninstall do
    sh "gem uninstall #{gem_name}"
  end

  task :reinstall =>[:uninstall,:install]
end
