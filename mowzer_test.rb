require 'mowzer'

module MowzerTestHelperMethods
end

describe Mowzer do 
  include MowzerTestHelperMethods
  before(:all) do 
    
  end
  it "should not blow up on init" do
    mowzer_power = Mowzer.new()
  end
  it "should stub stuff"
end
