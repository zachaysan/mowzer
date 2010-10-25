require 'rubygems'
require File.expand_path(File.join(File.dirname(__FILE__),'mowzer.rb'))

module MowzerTestHelperMethods
end

describe Mowzer do 
  include MowzerTestHelperMethods
  before(:all) do 
    
  end
  it "should not blow up on init" do
    mowzer_power = Mowzer.new
  end
  it "should find overlap" do
    mowzer_power = Mowzer.new
    mowzer_power.send(:any_overlap?, [2,3,5], [3,5]).should == true
  end
  it "should find overlap even when identical" do
    mowzer_power = Mowzer.new
    mowzer_power.send(:any_overlap?, [1,2], [2,1]).should == true
  end
  it "should not find overlap when there is none" do
    mowzer_power = Mowzer.new
    mowzer_power.send(:any_overlap?, [1,2], [4,5]).should == false
  end
  it "should find out if one of the two point sets fully encloses the other" do
    mowzer_power = Mowzer.new
    mowzer_power.send(:enclosed?, [1,2,3,4], [2,4]).should == true
  end
  it "should not say that sets are enclosed if there is only overlap" do
    mowzer_power = Mowzer.new
    mowzer_power.send(:enclosed?, [1,2,3,4], [2,4,7]).should == false
  end
  it "should not say that sets are enclosed if there are no shared points" do
    mowzer_power = Mowzer.new
    mowzer_power.send(:enclosed?, [1,2,3,4], [55,66]).should == false
  end
  it "shou" do
    
  end
end
