# frozen_string_literal: true

# 1. The Parent Class (acting as Server::SSH)
class SSHConnector
  # Receives a code block (&received_block)
  def start_connection(user:, &received_block)
    puts "1. [Parent] Opening secure connection as user: #{user}..."

    # Simulates the SSH object
    fake_connection = 'ACTIVE_CONNECTION_123'

    puts '2. [Parent] Executing the received block...'
    # HERE is where the magic happens: The parent yields control to the child's code
    received_block.call(fake_connection)

    puts '5. [Parent] Block finished. Closing connection.'
  end
end

# 2. The Child Class (acting as Server::Deploy)
class Deployer < SSHConnector
  def perform_deploy
    puts '0. [Child] Starting process...'

    # Call the parent method.
    # Everything between 'do' and 'end' is packaged and sent as &received_block
    start_connection(user: 'root') do |ssh_connection|
      puts '   3. [Block] I am the code sent from the child!'
      puts "   4. [Block] I am using the connection: #{ssh_connection}"
      puts '   4. [Block] Running commands: apt-get update...'
    end

    puts '6. [Child] Deploy finished.'
  end
end

# Execution
Deployer.new.perform_deploy
