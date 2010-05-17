require 'craken'
require 'rails'
module Craken
  class Railtie < Rails::Railtie
    
    rake_tasks do
      load "tasks/craken.rake"
    end
  end
end