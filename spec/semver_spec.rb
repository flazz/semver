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

  it "should format with fields" do
    v = SemVer.new 10, 33, 4, 'beta'
    v.format("v%M.%m.%p%s").should == "v10.33.4beta"
  end

end
