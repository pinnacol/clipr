module Clips
  ROOT = File.expand_path("#{File.dirname(__FILE__)}/../..")
  DYLIB = File.join(ROOT, "bin/clips.dylib")
  
  # From constant.h
  GLOBAL_SAVE  = 0
  LOCAL_SAVE   = 1
  VISIBLE_SAVE = 2
end