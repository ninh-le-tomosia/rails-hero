# frozen_string_literal: true

require_relative "rails_hero/version"
require_relative "rails_hero/capistrano/setup"
require "tty-prompt"
require "thor"

module RailsHero
  class Error < StandardError; end

  class CLI < Thor
    ENV['THOR_SILENCE_DEPRECATION'] = 'true'

    desc 'version [-v, --version]', 'Show version'
    map %w[-v --version] => :version
    def version
      TTY::Prompt.new.say("Rails Hero version #{RailsHero::VERSION}")
    end

    desc "capistrano:setup", "Set up Capistrano configuration"
    map "capistrano:setup" => :capistrano_setup
    def capistrano_setup
      # Gọi task Capistrano đã được định nghĩa trong gem của bạn
      RailsHero::Capistrano::Setup.new.execute
    end

    desc "nginx:setup", "Set up Nginx configuration"
    map "nginx:setup" => :nginx_setup
    def nginx_setup
      # Gọi task Capistrano đã được định nghĩa trong gem của bạn
      RailsHero::Nginx::Setup.new.execute
    end
  end
end
