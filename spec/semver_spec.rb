require 'semver'
require 'tempfile'

describe SemVer do

  it "should compare against another version versions" do
    v1 = SemVer.new 0,1,0
    v2 = SemVer.new 0,1,1
    v1.should < v2
  end

  it "should serialize to and from a file" do
    tf = Tempfile.new 'semver.spec'
    path = tf.path
    tf.close!

    v1 = SemVer.new 1,10,33
    v1.save path
    v2 = SemVer.new
    v2.load path

    v1.should == v2
  end

  it "should find an ancestral .semver" do
    SemVer.find.should be_a_kind_of(SemVer)
  end
  
  # Semantic Versioning 2.0.0-rc.1
  
  it "should format with fields" do
    v = SemVer.new 10, 33, 4, 'beta'
    v.format("v%M.%m.%p%s").should == "v10.33.4-beta"
  end

  it "should to_s with dash" do
    v = SemVer.new 4,5,63, 'alpha.45'
    v.to_s.should == 'v4.5.63-alpha.45'
  end
  
  it "should format with dash" do
    v = SemVer.new 2,5,11,'a.5'
    v.format("%M.%m.%p%s").should == '2.5.11-a.5'
  end
  
  it "should not format with dash if no special" do
    v = SemVer.new 2,5,11
    v.to_s.should == "v2.5.11"
    v.format("%M.%m.%p%s").should == "2.5.11"
  end
  
  it "should behave like the readme says" do
    v = SemVer.new(0,0,0)
    v.major                     # => "0"
    v.major += 1
    v.major                     # => "1"
    v.special = 'alpha.46'
    v.format "%M.%m.%p%s"       # => "1.1.0-alpha.46"
    v.to_s                      # => "v1.1.0"
   end
end
