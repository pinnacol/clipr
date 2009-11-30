require 'digest/sha1'

module Clips
  module Construct
    def reset
      @sha = nil
      @content = nil
    end
    
    def sha
      @sha ||= Digest::SHA1.hexdigest(content).to_sym
    end
    
    def content
      raise NotImplementedError
    end
  end
end