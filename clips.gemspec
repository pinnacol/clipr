Gem::Specification.new do |s|
  s.name = "clips"
  s.version = "0.0.1"
  s.author = "Your Name Here"
  s.email = "your.email@pubfactory.edu"
  s.homepage = ""
  s.platform = Gem::Platform::RUBY
  s.summary = ""
  s.require_path = "lib"
  s.rubyforge_project = ""
  
  # add dependencies
  s.add_dependency("ffi", "= 0.5.0")
  s.add_dependency("tap-test", ">= 0.2.0")
  
  s.has_rdoc = true
  s.rdoc_options.concat %W{--main README -S -N --title Clips}
  
  # list extra rdoc files here.
  s.extra_rdoc_files = %W{
    History
    README
  }
  
  # list the files you want to include here.
  s.files = %W{
  }
end