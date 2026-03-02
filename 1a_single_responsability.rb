# This is the original code that violates the Single Responsibility Principle.
# The Server class is responsible for both managing server information and handling SSH connections for setup and deployment.
class Server < ApplicationRecord
  has_many :apps
  validates :name, presence: true

  def setup
    start_ssh self, as: 'root' do |ssh|
      ssh.execute "apt install ruby"
      ssh.execute "git clone git@github.com:username/repo.git"
    end
  end

  def deploy
    start_ssh self, as: 'root' do |ssh|
      ssh.execute "cd repo"
      ssh.execute "git remote update"
      ssh.execute "touch tmp/restart.txt"
    end
  end

  def start_ssh(server, as:)
    Net::SSH.start(server.ip, as) do |ssh|
      block.call(ssh)
    end
  end
end
