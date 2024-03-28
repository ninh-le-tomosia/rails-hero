require "rails/generators"
require "fileutils"
require "yaml"
require "erb"
require "bundler"

class CapistranoGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def load_configuration
    capistrano_config_path = "./config/yaml/capistrano.yml".freeze

    if File.exist?(capistrano_config_path)
      @_config ||= YAML.load_file(capistrano_config_path)
    else
      if !File.exist?(File.join("config", "yaml", "capistrano.yml.sample"))
        template "yaml/capistrano.yml", File.join("config", "yaml", "capistrano.yml.sample")
      end
      warn "Config file capistrano.yml from directory config/yaml with format like file config/yaml/capistrano.yml.sample"
      raise "No such file or directory config/yaml/capistrano.yml"
    end
  end

  def load_original_specs
    @_original_specs = loaded_specs
  end

  def add_capistrano_gems
    if !gem_exist?('capistrano')
      gem 'capistrano', '~> 3.10'
    end

    if !gem_exist?('capistrano-rails')
      gem 'capistrano-rails', '~> 1.6'
    end

    if @_config.has_key?("enable_submodule") && @_config.fetch("enable_submodule") && !gem_exist?('capistrano-git-with-submodules')
      gem 'capistrano-git-with-submodules', '~> 2.0'
    end

    if ENV['rvm_version'] && !ENV['rvm_version'].empty?
      if !gem_exist?('capistrano-rvm')
        gem 'capistrano-rvm', '~> 0.1'
      end
    else
      if !gem_exist?('capistrano-rvm')
        gem 'capistrano-rbenv', '~> 2.2'
      end
    end
  end

  def bundle_gemspecs
    system("bundle install")
  end

  def copy_templates
    capistrano_version = find_gem_version('capistrano')

    config_dir = Pathname.new("config")
    deploy_dir = config_dir.join("deploy")

    deploy_rb = File.expand_path("../templates/capistrano/deploy.rb.erb", __FILE__)
    stage_rb  = File.expand_path("../templates/capistrano/stage.rb.erb", __FILE__)
    capfile   = File.expand_path("../templates/capistrano/Capfile", __FILE__)

    FileUtils.mkdir_p deploy_dir

    entries  = [{ template: deploy_rb, file: config_dir.join("deploy.rb") }]
    entries += stages.map { |stage| { template: stage_rb, file: deploy_dir.join("#{stage}.rb"), stage: stage } }

    entries.each do |entry|
      if File.exist?(entry[:file])
        warn "[skip] #{entry[:file]} already exists"
      else
        puts "create #{entry[:file]}"
        stage = entry[:stage]
        File.open(entry[:file], "w+") do |f|
          f.write(ERB.new(File.read(entry[:template])).result(binding).lstrip)
        end
      end
    end

    if File.exist?("Capfile")
      warn "[skip] Capfile already exists"
    else
      puts "create Capfile"
      FileUtils.cp_r(capfile, "Capfile")
    end
  end

  private

  def gem_exist?(gem_name)
    @_original_specs.any? { |spec| spec.name == gem_name }
  end

  def stages
    @_config["stages"] || %w(production staging)
  end

  def find_gem_version(gem_name)
    @_specs ||= loaded_specs
    gem_spec  = @_specs.find { |spec| spec.name === gem_name }

    !gem_spec.nil? ? gem_spec.version : nil
  end

  def loaded_specs
    lockfile = Bundler::LockfileParser.new(Bundler.read_file(Bundler.default_lockfile))
    lockfile.specs
  end
end
