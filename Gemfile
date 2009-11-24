gemspec('clips.gemspec')

if ENV['BUNDLE_CC'] == "true"
  clear_sources
  cc_dir = ENV['CRUISE_DATA_ROOT'] || File.dirname(__FILE__) + "/../../.."
  directory cc_dir, :glob => "projects/*/work/*.gemspec"
  directory cc_dir, :glob => "gems/gems/*/*.gemspec"
else
  source "http://gems.github.com"
  directory File.dirname(__FILE__), :glob => "clips.gemspec"
  directory File.dirname(__FILE__), :glob => "vendor/*/*.gemspec"
end

bin_path "vendor/gems/bin"
disable_system_gems
