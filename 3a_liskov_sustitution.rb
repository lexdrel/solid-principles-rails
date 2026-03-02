# frozen_string_literal: true

# not all birds can fly
class Bird
  def walk
    p 'Walking...'
  end
end

# this class is an extension
class FlyingBird < Bird
  def fly
    p 'Flying...'
  end
end

class Penguin < Bird
end

class Sparrow < FlyingBird
end

def migrate_south
  flying_birds.each(&:fly)
end
