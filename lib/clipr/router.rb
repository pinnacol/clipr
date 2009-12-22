autoload(:StringIO, 'stringio')

module Clipr
  
  # Implements the API for a Router as described in the 'I/O Router System'
  # section of the apg.pdf.
  #
  # ==== Implementation Detail
  #
  # The router functions are stored in a dedicated instance variable and
  # frozen to ensure that they will not fall out of scope so long as the
  # router itself exists.  These precautions ensure the method procs will not
  # be gc'd; otherwise the internal CLIPS router could be left pointing to a
  # missing callback.
  #
  # As a result, it is not a good idea to modify routers once they are created
  # and so the extend method is overridden to 'freeze' the instance.  Calling
  # extend on a router raises an error.
  #
  class Router
    
    class << self
      def strio_devices
        devices = {}
        STANDARD_DEVICES.each do |name|
          devices[name] = StringIO.new
        end
        devices
      end
    end
    
    STANDARD_DEVICES = %w{stdin stdout wprompt wdialog wdisplay werror wwarning wtrace}
    
    # Returns an array of methods suitable for adding self as a router via
    # the Api::Router.EnvAddRouter method.
    attr_reader :functions
    
    def initialize(devices={})
      @devices = {}
      @functions = [:query, :print, :getc, :ungetc, :exit]
      @functions.collect! {|method_name| method(method_name) }.freeze
      
      devices.each_pair do |name, device|
        self[name] = device
      end
    end
    
    def [](name)
      @devices[name.to_s] 
    end
    
    def []=(name, device)
      validate(device)
      
      name = name.to_s
      if @devices.has_key?(name)
        @devices[name].close
      end
      
      @devices[name] = device
    end
    
    def has?(name)
      @devices.has_key?(name.to_s)
    end
    
    def devices
      @devices.keys
    end
    
    def device(name)
      self[name] or raise("unknown device: #{name.inspect}")
    end
    
    # Captures any output to the specified device for the duration of the
    # block; the capture device is yielded to the block.  Returns the block
    # result.
    def capture(name, device=StringIO.new) # :yields: device
      name = name.to_s
      current = @devices[name]
      
      begin
        @devices[name] = device
        yield(device)
      ensure
        @devices[name] = current
      end
    end
    
    def extend(*args)
      raise "router may not be extended"
    end
    
    # CLIPS Router API (see apg.pdg 'AddRouter')
    
    # Returns either 1 or 0 depending upon whether this router recognizes the
    # logical name.
    def query(ptr, name)
      self[name] ? 1 : 0
    end
    
    # Prints the string to the device specified by the logical name.
    def print(ptr, name, str)
      device(name).print(str)
    end
    
    # Gets a char from the device specified by the logical name.
    def getc(ptr, name)
      device(name).getc
    end
    
    # Ungets the char onto the device specified by the logical name.
    def ungetc(ptr, c, name)
      device(name).ungetc(c)
    end
    
    # Closes all the devices.  Accepts an exit code.
    def exit(ptr, code)
      devices.each_value do |device|
        device.close
      end
      
      return 1
    end
    
    protected
    
    def validate(device) # :nodoc:
      missing = [:print, :getc, :ungetc, :close].select do |method_name|
        !device.respond_to?(method_name)
      end
      
      unless missing.empty?
        raise "invalid device: #{device.inspect} (missing: #{missing.join(', ')})"
      end
    end
  end
end