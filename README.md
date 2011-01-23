DynamicMethods
==============

Define dynamic instance methods with captures and arguments:

    require 'rubygems'
    require 'dynamic_methods'

    class FriendlyGuy
      include DynamicMethods

      dynamic_method /say_hello_to_(.*)/ do |person|
        puts "Hello #{person}"
      end

      dynamic_method /say_(.*)_to/ do |word, person|
        puts "#{word} #{person}"
      end
    end

    guy = FriendlyGuy.new

    guy.say_hello_to_bob
    # => Hello bob

    guy.say_bye_to 'bob'
    # => bye bob

The block should expect enough arguments to receive the patterns captures plus additional arguments.