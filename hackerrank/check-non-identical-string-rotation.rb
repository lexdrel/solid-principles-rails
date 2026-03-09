#!/bin/ruby

require 'json'
require 'stringio'

#
# Complete the 'isNonTrivialRotation' function below.
#
# The function is expected to return a BOOLEAN.
# The function accepts following parameters:
#  1. STRING s1
#  2. STRING s2
#

def isNonTrivialRotation(s1, s2)
  return false if s1 == s2 || s1.length != s2.length

  (s1 + s1).include?(s2)
end

# Example usage:
puts isNonTrivialRotation('abcde', 'cdeab')
puts isNonTrivialRotation('a', 'a')
puts isNonTrivialRotation('a', 'b')
