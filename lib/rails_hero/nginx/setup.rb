require 'tty-prompt'

module RailsHero
  module Nginx
    class Setup
      def execute
        TTY::Prompt.new.say("Set up Nginx configuration by Rails Hero")
      end
    end
  end
end
