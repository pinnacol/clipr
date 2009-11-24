require 'ffi'
require 'clips/constants'

Dir.glob("#{File.dirname(__FILE__)}/api/*").each do |api_file|
  require api_file
end