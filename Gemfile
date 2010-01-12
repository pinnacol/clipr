unless ENV['GEMSPEC']
  puts "this project bundles through rake... try:\n  % rake bundle"
  exit(1)
end

gemspec = eval File.read(ENV['GEMSPEC'])
gemspec.dependencies.each {|dep| gem dep.name, dep.version_requirements }
gem(gemspec.name, gemspec.version)

directory ".", :glob => ENV['GEMSPEC']

bin_path "vendor/gems/bin"
disable_system_gems
