def isAlphabeticPalindrome(code)
  # Write your code here
  code = code.downcase.gsub(/[^a-z]/, '')
  code == code.reverse
end

code = 'A1b2B! a'

puts isAlphabeticPalindrome(code)

# Summary:
# the gsub replaces everything that matches in the first parameter, with the second parameter, ie:
# irb(main):007> "Hello".gsub("e","*")
# => "H*llo"
#
# but the regexp indicates with '^' that 'not' replace from a-z but everything else does
