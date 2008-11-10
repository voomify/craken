describe Raketab do
  it "should have defaults (0 for hour, minutes and * for days and months)" do
   Raketab.new { |t| t.run 'test' }.tabs.should == '0 0 * * * test'
  end

  it "should set all the fields by name" do
    Raketab.new { |t| t.run 'test', :min => 1 }.tabs.should     == "1 0 * * * test"
    Raketab.new { |t| t.run 'test', :minute => 1 }.tabs.should  == "1 0 * * * test"
    Raketab.new { |t| t.run 'test', :hour => 1 }.tabs.should    == "0 1 * * * test"
    Raketab.new { |t| t.run 'test', :day => 1 }.tabs.should     == "0 0 1 * * test"
    Raketab.new { |t| t.run 'test', :mday => 1 }.tabs.should    == "0 0 1 * * test"
    Raketab.new { |t| t.run 'test', :month => 1 }.tabs.should   == "0 0 * 1 * test"
    Raketab.new { |t| t.run 'test', :mon => 1 }.tabs.should     == "0 0 * 1 * test"
    Raketab.new { |t| t.run 'test', :wday => 1 }.tabs.should    == "0 0 * * 1 test"
    Raketab.new { |t| t.run 'test', :weekday => 1 }.tabs.should == "0 0 * * 1 test"
  end
    
  it "should set the fields by comma string" do
    Raketab.new { |t| t.run 'test', :minutes => '1,2,3' }.tabs.should  == "1,2,3 0 * * * test"
    Raketab.new { |t| t.run 'test', :hours => '1,2,3' }.tabs.should    == "0 1,2,3 * * * test"
    Raketab.new { |t| t.run 'test', :days => '1,2,3' }.tabs.should     == "0 0 1,2,3 * * test"
    Raketab.new { |t| t.run 'test', :months => '1,2,3' }.tabs.should   == "0 0 * 1,2,3 * test"
    Raketab.new { |t| t.run 'test', :weekdays => '1,2,3' }.tabs.should == "0 0 * * 1,2,3 test"
  end

  it "should set the fields by array" do
    Raketab.new { |t| t.run 'test', :minutes => [1,2,3] }.tabs.should  == "1,2,3 0 * * * test"
    Raketab.new { |t| t.run 'test', :hours => [1,2,3] }.tabs.should    == "0 1,2,3 * * * test"
    Raketab.new { |t| t.run 'test', :days => [1,2,3] }.tabs.should     == "0 0 1,2,3 * * test"
    Raketab.new { |t| t.run 'test', :months => [1,2,3] }.tabs.should   == "0 0 * 1,2,3 * test"
    Raketab.new { |t| t.run 'test', :weekdays => [1,2,3] }.tabs.should == "0 0 * * 1,2,3 test"
  end

  it "should set the fields by inclusive ranges" do
    Raketab.new { |t| t.run 'test', :minutes => 1..3 }.tabs.should  == "1,2,3 0 * * * test"
    Raketab.new { |t| t.run 'test', :hours => 1..3 }.tabs.should    == "0 1,2,3 * * * test"
    Raketab.new { |t| t.run 'test', :days => 1..3 }.tabs.should     == "0 0 1,2,3 * * test"
    Raketab.new { |t| t.run 'test', :months => 1..3 }.tabs.should   == "0 0 * 1,2,3 * test"
    Raketab.new { |t| t.run 'test', :weekdays => 1..3 }.tabs.should == "0 0 * * 1,2,3 test"
  end

  it "should set the fields by exclusive ranges" do
    Raketab.new { |t| t.run 'test', :minutes => 1...4 }.tabs.should  == "1,2,3 0 * * * test"
    Raketab.new { |t| t.run 'test', :hours => 1...4 }.tabs.should    == "0 1,2,3 * * * test"
    Raketab.new { |t| t.run 'test', :days => 1...4 }.tabs.should     == "0 0 1,2,3 * * test"
    Raketab.new { |t| t.run 'test', :months => 1...4 }.tabs.should   == "0 0 * 1,2,3 * test"
    Raketab.new { |t| t.run 'test', :weekdays => 1...4 }.tabs.should == "0 0 * * 1,2,3 test"
  end

  it "should set weekday with symbol or string of the day name or abbreviation" do
    Raketab.new { |t| t.run 'test', :on => :thursday }.tabs.should  == '0 0 * * 4 test'
    Raketab.new { |t| t.run 'test', :on => 'Thursday' }.tabs.should == '0 0 * * 4 test'
    Raketab.new { |t| t.run 'test', :on => :thu }.tabs.should       == '0 0 * * 4 test'
    Raketab.new { |t| t.run 'test', :on => 'Thurs' }.tabs.should    == '0 0 * * 4 test'
  end


  it "should set month with symbol or string of the month name or abbreviation" do
    Raketab.new { |t| t.run 'test', :on => :september }.tabs.should  == '0 0 * 9 * test'
    Raketab.new { |t| t.run 'test', :on => 'September' }.tabs.should == '0 0 * 9 * test'
    Raketab.new { |t| t.run 'test', :on => :sep }.tabs.should        == '0 0 * 9 * test'
    Raketab.new { |t| t.run 'test', :on => 'Sep' }.tabs.should       == '0 0 * 9 * test'
  end

  it "should set month with any syntactic sugar" do
    Raketab.new { |t| t.run 'test', :every => :september }.tabs.should == '0 0 * 9 * test'
    Raketab.new { |t| t.run 'test', :each => :september }.tabs.should  == '0 0 * 9 * test'
    Raketab.new { |t| t.run 'test', :on => :september }.tabs.should    == '0 0 * 9 * test'
    Raketab.new { |t| t.run 'test', :in => :september }.tabs.should    == '0 0 * 9 * test'
  end

  it "should set day with any syntactic sugar" do
    Raketab.new { |t| t.run 'test', :every => '1st' }.tabs.should == '0 0 1 * * test'
    Raketab.new { |t| t.run 'test', :each => '2nd' }.tabs.should  == '0 0 2 * * test'
    Raketab.new { |t| t.run 'test', :the => '3rd' }.tabs.should   == '0 0 3 * * test'
  end

  it "should set the time of day, with AM/PM or military time" do
    Raketab.new { |t| t.run 'test', :at => '12:30' }.tabs.should      == '30 12 * * * test'
    Raketab.new { |t| t.run 'test', :at => '12:30AM' }.tabs.should    == '30 0 * * * test'
    Raketab.new { |t| t.run 'test', :at => '12:30PM' }.tabs.should    == '30 12 * * * test'
    Raketab.new { |t| t.run 'test', :at => '23:30PM' }.tabs.should    == '30 23 * * * test'
  end

  it "should work with bare numbers for at"

  it "should set all the fields if they are all provided" do
    Raketab.new do |t| 
      t.run 'test', :every => :sep, :the => '1st', :on => :thursdays, :at => "12:30" 
    end.tabs.should == "30 12 1 9 4 test"
  end
end
