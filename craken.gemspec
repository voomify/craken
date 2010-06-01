# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{craken}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Doug McInnes"]
  s.date = %q{2010-06-01}
  s.description = %q{A Rails plugin for managing and installing rake-centric crontab files.}
  s.email = %q{doug@dougmcinnes.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
     "README.rdoc",
     "init.rb",
     "lib/craken.rb",
     "lib/craken/railtie.rb",
     "lib/craken/recipes.rb",
     "lib/enumeration.rb",
     "lib/raketab.rb",
     "lib/tasks/craken.rake"
  ]
  s.homepage = %q{http://www.github.com/latimes/craken}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Craken gem}
  s.test_files = [
    "spec/raketab_spec.rb",
     "spec/enumeration_spec.rb",
     "spec/craken_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

