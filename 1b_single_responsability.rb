# This is the original code that violates the Single Responsibility Principle.
# The Server class is responsible for both managing server information and handling SSH connections for setup and deployment.
class Server < ApplicationRecord
  has_many :apps
  validates :name, presence: true
end

# app/scripts/app/deploy.rb
class App::Deploy
  def perform
    app.servers.each do |server|
      Server::Deploy.new(server).deploy
    end
  end
end

# app/scripts/server/setup.rb
class Server::Setup < Server::SSH
  def perform
    start_ssh self, as: 'root' do |ssh|
      ssh.execute 'apt install ruby'
      ssh.execute 'git clone git@github.com:username/repo.git'
    end
  end
end

# app/scripts/server/deploy.rb
class Server::Deploy < Server::SSH
  def deploy
    start_ssh self, as: 'root' do |ssh|
      ssh.execute 'cd repo'
      ssh.execute 'git remote update'
      ssh.execute 'touch tmp/restart.txt'
    end
  end
end

# app/scripts/server/ssh.rb
class Server::SSH
  def start_ssh(as: 'deploy', &block)
    Net::SSH.start ip do |ssh|
      block.call(ssh)
    end
  end

  def logger
  end
end
