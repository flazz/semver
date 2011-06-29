$:.push File.expand_path("../lib", __FILE__)
require 'semver'

Gem::Specification.new do |spec|
  spec.name = "semver"
  spec.version = SemVer.find.format '%M.%m.%p'
  spec.summary = "Semantic Versioning"
  spec.description = "maintain versions as per http://semver.org"
  spec.email = "flazzarino@gmail.com"
  spec.authors = ["Francesco Lazzarino"]
  spec.homepage = 'http://github.com/flazz/semver'
  spec.executables << 'semver'
  spec.files = [".semver", "semver.gemspec", "README.md"] + Dir["lib/**/*.rb"] + Dir['bin/*']
  spec.has_rdoc = true
end
