require 'spec_helper'

class ATestClass
  include DynamicMethods
end

describe DynamicMethods do
  it 'allows definition of dynamic methods' do
    ATestClass.dynamic_method /some_thing/ do
    end
    
    test_object = ATestClass.new
    test_object.should respond_to('some_thing')
    ATestClass.method_defined?(:some_thing).should be(false)
    
    proc do
      test_object.some_thing
    end.should_not raise_error(NoMethodError)
    
    ATestClass.method_defined?(:some_thing).should be(true)
  end
  
  it 'allows definition of dynamic methods with captures' do
    ATestClass.dynamic_method /some_(.*)_(.*)/ do |a, b|
      [a, b]
    end
    
    test_object = ATestClass.new
    test_object.should respond_to('some_a_b')
    
    proc do
      test_object.some_a_b
    end.should_not raise_error(NoMethodError)
    
    test_object.some_a_b.should == ['a', 'b']
  end
  
  it 'allows definition of dynamic methods with arguments' do
    ATestClass.dynamic_method /another_method/ do |a, b|
      [a, b]
    end
    
    test_object = ATestClass.new
    test_object.should respond_to('another_method')
    
    proc do
      test_object.another_method 'a', 'b'
    end.should_not raise_error(NoMethodError)
    
    test_object.another_method('a', 'b').should == ['a', 'b']
  end
  
  it 'allows definition of dynamic methods with captures and arguments' do
    ATestClass.dynamic_method /another_(.*)_(.*)/ do |a, b, c, d|
      [a, b, c, d]
    end
    
    test_object = ATestClass.new
    test_object.should respond_to('another_a_b')
    
    proc do
      test_object.another_a_b 'c', 'd'
    end.should_not raise_error(NoMethodError)
    
    test_object.another_a_b('c', 'd').should == ['a', 'b', 'c', 'd']
  end
end