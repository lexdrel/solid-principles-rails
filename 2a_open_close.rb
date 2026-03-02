# frozen_string_literal: true

# This file demonstrates the Open/Closed Principle using a simple example of a Server class that can be extended
# to support different cloud providers without modifying the existing code.
class Server
  def initialize(type)
    klass = case type
            when 'aws'
              AwsProvider
            when 'gcp'
              GcpProvider
            end
  end
end
