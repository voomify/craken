class Raketab  
  def initialize(&block)
    @@tabs = []
    yield self
  end
  
  def schedule(command, options)    
    options = options.with_indifferent_access
    month, wday, mday, hour, min = options[:month] || options[:mon], 
                                   options[:weekday] || options[:wday], 
                                   options[:month] || options[:mon],
                                   options[:hour],
                                   options[:minute] || options[:min]

    [:each, :every, :on, :in, :at, :the].each do |type|
      if options[type]
         parse = Date._parse(options[type].to_s.singularize)
         month ||= parse[:mon]
         wday  ||= parse[:wday]
         mday  ||= parse[:mday]
         hour  ||= parse[:hour]
         min   ||= parse[:min]      
      end
    end

    # special cases with hours
    hour ||= options[:at].to_i if options[:at] # :at => "5 o'clock" 

    # fill missing items
    month, wday, mday, hour, min = [month, wday, mday, hour, min].map { |t| t || '*' }
    
    # put it together
    @@tabs << "#{min} #{hour} #{mday} #{month} #{wday} #{command}"
  end  
  alias_method :run, :schedule

  def self.tabs
    @@tabs.join("\n")
  end
  
  def tabs
    self.class.tabs
  end
end  
