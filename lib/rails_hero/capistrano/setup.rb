require 'tty-prompt'

module RailsHero
  module Capistrano
    class Setup
      def execute
        TTY::Prompt.new.say("Set up Capistrano configuration by Rails Hero")
      end
    end
  end
end
