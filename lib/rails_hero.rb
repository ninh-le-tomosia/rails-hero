# frozen_string_literal: true

require "thor"
require_relative "rails_hero/version"
require_relative "generators/rails_hero/capistrano_generator"

module RailsHero
  class Error < StandardError; end

  class CLI < Thor
    ENV['THOR_SILENCE_DEPRECATION'] = 'true'

    desc 'version [-v, --version]', 'Show version'
    map %w[-v --version] => :version
    def version
      p "Rails Hero version #{RailsHero::VERSION}"
    end


    desc "cap:setup", "Set up Capistrano configuration"
    map "cap:setup" => :capistrano_setup
    def capistrano_setup
      p "Setup capistrano"
      CapistranoGenerator.start(ARGV)
    end

    desc "nginx:setup", "Set up Nginx configuration"
    map "nginx:setup" => :nginx_setup
    def nginx_setup
      p "Setup nginx"
      # RailsHero::Nginx.setup
    end
  end
end
