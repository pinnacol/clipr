require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

ENV['GEMSPEC'] = 'clipr.gemspec'

#
# Gem specification
#

def gemspec
  data = File.read(ENV['GEMSPEC'])
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
    next if file =~ /^(rdoc|pkg|backup|vendor|test|.*\.o)/ || File.directory?(file)
    
    path = File.expand_path(file)
    files[path] = ["", file] unless files.has_key?(path)
  end
  
  # sort and output the results
  files.values.sort_by {|exists, file| file }.each do |entry| 
    puts "%-5s %s" % entry
  end
end

#
# Bundler tasks
#

desc "Bundle depenencies for the current wcis_env"
task :bundle => "vendor/gems/environment.rb"

file "vendor/gems/environment.rb" => ["Gemfile", ENV['GEMSPEC']] do
  cmd = "gem bundle"
  
  if system(cmd)
    # success -- remove the circular symlink to the pwd
    # if it exists (note this doesn't affect bundler)
    spec = gemspec
    pattern = File.join("vendor/gems/**/gems", spec.full_name)
    Dir.glob(pattern).each {|install_path| FileUtils.rm_r(install_path) }
    
  else
    # failure -- missing bundler?
    puts %Q{
Bundle fail! Are you sure bundler is installed?

  % gem install bundler

}
    exit(1)
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
# Compile tasks
#

require 'lib/clipr/constants'

makefile = "src/Makefile"
source_files = Dir.glob("src/*.c")

file makefile => source_files do
  pkg = File.basename(Clipr::DYLIB).chomp(File.extname(Clipr::DYLIB))
  Dir.chdir("src") { sh("ruby extconf.rb") }
end

file Clipr::DYLIB => makefile do
  Dir.chdir("src") { sh("make") }
end

desc "compile the clips binary"
task :compile => Clipr::DYLIB

#
issues_files = Dir.glob("test/func/issues/**/*.c")
object_files = source_files.collect {|src| src.chomp(".c") + ".o"}

issues_exes  = issues_files.collect do |src|
  obj = src.chomp(".c") + ".o"
  exe = src.chomp(".c") + ".test"
  file(obj => [Clipr::DYLIB, src]) { sh("gcc -Isrc -c #{src} -o #{obj}") }
  file(exe => obj) { sh("gcc -o '#{exe}' #{obj} #{object_files.join(' ')}") }
  exe
end

desc "compile the issues binaries"
task :compile_issues => issues_exes

#
# Test tasks
#

desc 'Default: Run tests.'
task :default => :test

desc 'Run the tests'
task :test => [Clipr::DYLIB, :compile_issues, :bundle] do  
  tests = Dir.glob('test/**/*_test.rb')
  cmd = ["ruby", "-Ilib", "-w", "-e", "ARGV.dup.each {|test| load test}"] + tests
  sh(*cmd)
end

desc 'Run the benchmarks'
task :benchmark => [Clipr::DYLIB, :bundle] do
  unless ENV['BENCHMARK'] || ENV['BENCHMARK_TEST']
    ENV['BENCHMARK'] = 'true'
  end
  
  tests = Dir.glob('test/benchmark/*_benchmark.rb')
  cmd = ["ruby", "-Ilib", "-w", "-e", "ARGV.dup.each {|test| load test}"] + tests
  sh(*cmd)
end
