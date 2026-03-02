# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/object/with_options'

# notifier.rb
class Notifier
  def send_email(to:, subject:, from:, reply_to: nil)
    puts "EMAIL  to=#{to} from=#{from} reply_to=#{reply_to} subject=#{subject}"
  end

  def send_sms(to:, from:, body:)
    puts "SMS    to=#{to} from=#{from} body=#{body}"
  end
end

# app.rb
notifier = Notifier.new

# DRY: these defaults will be merged into each call inside the block [1](https://www.delftstack.com/howto/ruby/ruby-require-vs-include/)
notifier.with_options(from: 'noreply@example.com', reply_to: 'support@example.com') do |n|
  n.send_email(to: 'alex@example.com', subject: 'Welcome!')
  n.send_email(to: 'team@example.com', subject: 'Daily report')
end

# Another with_options block (different defaults)
notifier.with_options(from: '+1555000111') do |n|
  n.send_sms(to: '+15551234567', body: 'Your code is 123456')
  n.send_sms(to: '+15557654321', body: 'Your build finished')
end
