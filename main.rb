require 'time'
require './optimizer'

longest_holidays = longest_pto(
  start: Date.today,
  stop: Date.today + 365,
  pto_count: 35, # days
  max_holiday_size: 20, # days
)

max_holidays = max_holiday_days(
  start: Date.today,
  stop: Date.today + 365,
  pto_count: 35, # days
  min_holiday_size: 4, # days
)

puts longest_holidays
puts "Number of PTO days spent: #{longest_holidays.pto_days.size}."
puts "Number of holiday days: #{longest_holidays.length}."
puts max_holidays
puts "Number of PTO days spent: #{max_holidays.pto_days.size}."
puts "Number of holiday days: #{max_holidays.length}."
# puts holidays.pto_days.sort.map(&:to_s).join("\n")
