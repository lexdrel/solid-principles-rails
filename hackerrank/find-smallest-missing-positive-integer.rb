require 'debug'

def findSmallestMissingPositive(orderNumbers = [])
  # Write your code here
  n = orderNumbers.length

  i = 0
  while i < n
    val = orderNumbers[i]
    if val > 0 && val <= n && orderNumbers[val - 1] != val
      orderNumbers[i], orderNumbers[val - 1] = orderNumbers[val - 1], orderNumbers[i]
    else
      i += 1
    end
  end
  (0...n).each do |i|
    return i + 1 if orderNumbers[i] != i + 1
  end

  n + 1
end

orderNumbers = [3, 4, -1, 1]

p findSmallestMissingPositive(orderNumbers)
