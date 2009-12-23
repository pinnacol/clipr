gem("ffi", "= 0.5.0")
gem("tap-test", ">= 0.3.0", :only => :test)

if ENV['BUNDLE_CC'] == "true"
  clear_sources
  cc_dir = ENV['CRUISE_DATA_ROOT'] || File.dirname(__FILE__) + "/../../.."
  directory cc_dir, :glob => "projects/*/work/*.gemspec"
  directory cc_dir, :glob => "gems/gems/*/*.gemspec"
else
  directory File.dirname(__FILE__), :glob => "clipr.gemspec"
  directory File.dirname(__FILE__), :glob => "vendor/*/*.gemspec"
end

bin_path "vendor/gems/bin"
disable_system_gems

