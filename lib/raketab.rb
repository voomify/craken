require 'date'

class Raketab  
  def initialize(&block)
    @@tabs = []
    yield self
  end
  
  def schedule(command, options={})
    month, wday, mday, hour, min = options[:month]   || options[:months]   || options[:mon], 
                                   options[:weekday] || options[:weekdays] || options[:wday], 
                                   options[:day]     || options[:days]     || options[:mday],
                                   options[:hour]    || options[:hours],
                                   options[:minute]  || options[:minutes]  || options[:min]

    [:each, :every, :on, :in, :at, :the].each do |type|
      if options[type]
         parse = Date._parse(options[type].to_s.gsub(/s$/i, ''))
         month ||= parse[:mon]
         wday  ||= parse[:wday]
         mday  ||= parse[:mday]
         hour  ||= parse[:hour]
         min   ||= parse[:min]      
      end
    end

    # deal with any arrays and ranges
    min, hour, mday, wday, month = [min, hour, mday, wday, month].map do |type| 
     type.respond_to?(:map) ? type.map.join(',') : type    
    end

    # special cases with hours
    hour ||= options[:at].to_i if options[:at] # :at => "5 o'clock" 

    # fill missing items
    hour, min         = [hour, min].map { |t| t || '0' }
    month, wday, mday = [month, wday, mday].map { |t| t || '*' }
    
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
