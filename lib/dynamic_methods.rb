require 'active_support/core_ext/class/inheritable_attributes'
require 'ruby-debug'

module DynamicMethods
  class DynamicMethod
    attr_accessor :pattern, :definition, :receiver
    
    # Create new DynamicMethod. Excepts a RegEx pattern as first argument
    # and the method definition as block argument.
    def initialize receiver, pattern, &definition
      @receiver, @pattern, @definition = receiver, pattern, definition
    end
    
    # If method hasn't been defined, define method in receiver's class
    def define name, captures
      return if receiver.method_defined? name

      method_definition = @definition
      receiver.send :define_method, name do |*args|
        instance_exec *(captures + args), &method_definition
      end
    end
    
    # Define and call method.
    def define_and_call object, name, captures, *args, &block
      define name, captures
      object.send name, *args, &block
    end
    
    # Match name against this DynamicMethods pattern
    def match name
      pattern.match name.to_s
    end
  end
  
  
  module ClassMethods      
    # Define a dynamic method, accepts a RegEx pattern (optionally with captures)
    # and a block which defines the method body. The block should expect at least
    # as many arguments as capture groups are in the RegEx.
    # e.g.
    # 
    #   dynamic_method /render_(\w+)_(\w+) do |capture1, capture2, argument1, argument2|
    #     # do something
    #   end
    #
    def dynamic_method pattern, &method_definition
      DynamicMethod.new(self, pattern, &method_definition).tap do |dynamic_method|
        dynamic_methods << dynamic_method
      end
    end
  end
  
  module InstanceMethods
    def respond_to? name, include_private = false #:nodoc:
      !!lookup_dynamic_method(name) || super
    end
    
    protected
    def method_missing name, *args, &block #:nodoc:
      matching_method, captures = lookup_dynamic_method name
      
      if matching_method
        matching_method.define_and_call self, name, captures, *args, &block
      else
        super
      end
    end
    
    private
    def lookup_dynamic_method name #:nodoc:
      match = nil
      matching_method = dynamic_methods.find do |dynamic_method|
        match = dynamic_method.match(name)
      end
      
      if matching_method
        [matching_method, match.captures]
      else
        nil
      end
    end
  end
  
  def self.included receiver #:nodoc:
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
    
    receiver.send :class_inheritable_array, :dynamic_methods
    receiver.dynamic_methods = []
  end
end
