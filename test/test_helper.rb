# Filter warnings from vendored projects
module WarnFilter
  VENDOR_DIR = File.expand_path(File.join(File.dirname(__FILE__), "../vendor/gems/gems"))

  def write(obj)
    super unless obj.rindex(VENDOR_DIR) == 0
  end
  
  unless ENV['WARN_FILTER'] == "false"
    $stderr.extend(self)
  end
end unless Object.const_defined?(:WarnFilter)

require 'tap/test/unit'

module BlockHelpers
  def setup_block
    block = lambda {}
    oid = block.object_id
    [block, oid]
  end
end unless Object.const_defined?(:BlockHelpers)