require './optimizer'

def main
  holidays = longest_pto(
    start: Date.new(2020, 1, 1),
    stop: Date.new(2021, 1, 30),
    pto_count: 45, # days
    max_holiday_size: 30,
  )

  puts holidays
  puts "Number of PTO days spent: #{holidays.pto_days.size}."
  puts "Number of holiday days: #{holidays.length}."
  puts holidays.pto_days.map(&:to_s).join("\n")
end

main
