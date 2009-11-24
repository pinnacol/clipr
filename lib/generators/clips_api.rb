require 'tap/generator/base'
require 'clips/constants'

module Generators
  # :startdoc::generator generates the CLIPS API classes
  class ClipsApi < Tap::Generator::Base
    FUNCTIONS_FILE = "#{Clips::ROOT}/doc/functions.txt"
    
    def manifest(m, *inputs)
      # make a directory
      m.directory "lib/clips/api"
      m.directory "test/clips/api"
      
      # make a template
      functions.each_pair do |const, clips_methods|
        locals = {:const => const, :clips_methods => clips_methods}
        m.template "lib/clips/api/#{const.downcase}.rb", "api.erb", locals
        m.template "test/clips/api/#{const.downcase}_test.rb", "api_test.erb", locals
      end
    end
    
    # parses function names from the FUNCTIONS_FILE
    def functions
      functions = {}
      current = []
      
      lines = File.read(FUNCTIONS_FILE).split("\n")
      lines.each do |line|
        case line
        when / (\w+) Functions /
          current = functions[$1] = []
        when / (\w+) /
          current << $1
        else
          next
        end
      end
      
      functions
    end
  end 
end
