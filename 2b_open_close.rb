# frozen_string_literal: true

require 'active_support/core_ext/string'
require 'debug'

# This file demonstrates the Open/Closed Principle using a simple example of a Server class that can be extended
# to support different cloud providers without modifying the existing code.
class Server
  def initialize(type)
    klass = "Provider::#{type.classify}".safe_constantize
    # debugger
    @provider = klass.new
    @provider.add_ssh_key
    @provider.create
    @provider.status('server_id_123')
  end
end

# Provider class should exist to hold all provider classes and avoid namespace pollution
class Provider
  p 'Provider namespace created to hold all provider classes'
end

# app/providers/base.rb
class Provider::Base
  def add_ssh_key
    raise NotImplementedError, 'This method should be implemented by subclasses'
  end

  def create
    raise NotImplementedError, 'This method should be implemented by subclasses'
  end

  def status(id)
    raise NotImplementedError, 'This method should be implemented by subclasses'
  end
end

# app/providers/azure.rb
class Provider::Azure < Provider::Base
  def add_ssh_key
    puts 'Adding SSH key to Azure...'
  end

  def create
    puts 'Creating Azure server...'
  end

  def status(id)
    puts "Checking status of Azure server with ID: #{id}..."
  end
end

# app/providers/gcp.rb
class Provider::Gcp < Provider::Base
  def add_ssh_key
    puts 'Adding SSH key to GCP...'
  end

  def create
    puts 'Creating GCP server...'
  end

  def status(id)
    puts "Checking status of GCP server with ID: #{id}..."
  end
end

server1 = Server.new('azure')
server2 = Server.new('gcp')
