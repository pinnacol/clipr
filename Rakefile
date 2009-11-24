require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

#
# Gem specification
#

def gemspec
  data = File.read('clips.gemspec')
  spec = nil
  Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
  spec
end

Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.need_tar = true
end

desc 'Prints the gemspec manifest.'
task :print_manifest do
  # collect files from the gemspec, labeling 
  # with true or false corresponding to the
  # file existing or not
  files = gemspec.files.inject({}) do |files, file|
    files[File.expand_path(file)] = [File.exists?(file), file]
    files
  end
  
  # gather non-rdoc/pkg files for the project
  # and add to the files list if they are not
  # included already (marking by the absence
  # of a label)
  Dir.glob("**/*").each do |file|
    next if file =~ /^(rdoc|pkg|backup|vendor)/ || File.directory?(file)
    
    path = File.expand_path(file)
    files[path] = ["", file] unless files.has_key?(path)
  end
  
  # sort and output the results
  files.values.sort_by {|exists, file| file }.each do |entry| 
    puts "%-5s %s" % entry
  end
end

#
# Documentation tasks
#

desc 'Generate documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  spec = gemspec
  
  rdoc.rdoc_dir = 'rdoc'
  rdoc.options.concat(spec.rdoc_options)
  rdoc.rdoc_files.include( spec.extra_rdoc_files )
  
  files = spec.files.select {|file| file =~ /^lib.*\.rb$/}
  rdoc.rdoc_files.include( files )
end

#
# Test tasks
#

desc 'Default: Run tests.'
task :default => :test

desc 'Run the tests'
task :test => :check_bundle do  
  tests = Dir.glob('test/**/*_test.rb')
  cmd = ['ruby', "-w", '-rvendor/gems/environment.rb', "-e", "ARGV.dup.each {|test| load test}"] + tests
  sh(*cmd)
end

task :check_bundle do
  unless File.exists?("vendor/gems/environment.rb")
    puts %Q{
Tests cannot be run until the dependencies have been
bundled.  Use these commands and try again:

  % git submodule init
  % git submodule update
  % gem bundle

}
    exit(1)
  end
end

desc "Update bundle for CruiseControl"
task :cc_bundle do
  FileUtils.rm_r("vendor/gems") if File.exists?("vendor/gems")
  system("BUNDLE_CC='true' gem bundle")
end

desc 'Run the cc tests'
task :cc => [:cc_bundle, :test]

