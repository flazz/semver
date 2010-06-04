require 'yaml'

class NoSemVerError < StandardError; end

class SemVer

  FILE_NAME = '.semver'

  def SemVer.find dir=nil
    v = SemVer.new
    v.load
    v
  end

  def SemVer.find_file dir=nil
    dir ||= Dir.pwd
    raise "#{dir} is not a directory" unless File.directory? dir
    path = FILE_NAME

    Dir.chdir dir do

      loop do

        if File.dirname(File.expand_path(path)) == '/'
          raise NoSemVerError, "#{dir} is not semantic versioned"
        elsif Dir[FILE_NAME].empty?
          path = File.join '..', path
          next
        else
          path = File.expand_path path
          return path
        end

      end

    end
  end

  class << self

    def attr_writer_pattern pattern, symbol

      define_method("#{symbol}=".to_sym) do |str|

        if str =~ pattern || str.empty?
          instance_variable_set "@#{symbol}".to_sym, str
        else
          raise "#{symbol}: #{str} does not match pattern #{pattern}"
        end

      end

    end

  end

  attr_writer_pattern /\d+/, :major
  attr_writer_pattern /\d+/, :minor
  attr_writer_pattern /\d+/, :patch
  attr_writer_pattern /[A-Za-z][0-9A-Za-z-]+/, :special
  attr_reader :major, :minor, :patch, :special

  def initialize major='0', minor='0', patch='0', special=''
    self.major, self.minor, self.patch, self.special = major.to_s, minor.to_s, patch.to_s, special.to_s
  end

  def load file=SemVer.find_file
    hash = open(file) { |io| YAML::load io.read } || {}
    self.major = hash[:major] || '0'
    self.minor = hash[:minor] || '0'
    self.patch = hash[:patch] || '0'
    self.special = hash[:special] || ''
  end

  def save file=SemVer.find_file

    hash = {
      :major => @major,
      :minor => @minor,
      :patch => @patch,
      :special => @special
    }

    yaml = YAML::dump hash
    open(file, 'w') { |io| io.write yaml }
  end

  def format fmt
    fmt.gsub! '%M', @major
    fmt.gsub! '%m', @minor
    fmt.gsub! '%p', @patch
    fmt.gsub! '%s', @special
    fmt
  end

  def <=> other
    maj = major.to_i <=> other.major.to_i
    return maj unless maj == 0

    min = minor.to_i <=> other.minor.to_i
    return min unless min == 0

    pat = patch.to_i <=> other.patch.to_i
    return pat unless pat == 0

    spe = special <=> other.special
    return spec unless spe == 0

    0
  end

  include Comparable
end
