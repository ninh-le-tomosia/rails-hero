## Introduction
Sometimes, configuring and deploying Rails projects can be time-consuming, but with this gem, everything becomes simpler than ever. Created with the aim of reducing the time spent configuring deployments for Rails projects, this gem simplifies the process significantly. By using straightforward commands and requiring server configuration in a single YAML file, it streamlines management and makes configuration retrieval a breeze. With its flexibility and robust utility, deploying Rails applications becomes faster and more efficient than ever before.

## Installation
All you need to do is install this gem on your machine, and you can set it up for any project you want.

```sh
gem install rails_hero
```

## Usage
Add file YAML configuration with format and directory `config/yml/capistrano.yml`:

```yaml
repo_url: https://github.com/your_repository # Your repository
app_name: app_name
deploy_to: path/to/project # You want to deploy project to directory
enable_submodule: false # default: false
linked_files:
  - config/credentials.yml.enc
  - config/master.key
  - config/database.yml
  - .env
// Stages default if your don't settings is [staging, production]
stages:
  - production
  - staging
production:
  host: host.sample
  branch: master
  ssh_key: ~/.ssh/production.pem
  username: ubuntu
  keep_releases: 5
  roles:
    - app
    - db
    - web
staging:
  host: host.sample
  branch: staging
  ssh_key: ~/.ssh/staging.pem
  username: ubuntu
  keep_releases: 2
  roles:
    - app
    - db
    - web
```

Run CMD:
```sh
rhero cap:setup
```
