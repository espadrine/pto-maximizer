require 'time'

PUBLIC_HOLIDAYS = [
  Date.new(2020, 1, 1),
  Date.new(2020, 4, 13),
  Date.new(2020, 5, 1),
  Date.new(2020, 5, 8),
  Date.new(2020, 5, 21),
  Date.new(2020, 6, 1),
  Date.new(2020, 7, 14),
  Date.new(2020, 8, 15),
  Date.new(2020, 11, 1),
  Date.new(2020, 11, 11),
  Date.new(2020, 12, 25),
  Date.new(2021, 1, 1)
]

def is_weekend(day)
  day.saturday? || day.sunday?
end

def is_public_holiday(day)
  PUBLIC_HOLIDAYS.include?(day)
end

def is_off(day)
  is_weekend(day) || is_public_holiday(day)
end

def work_days_between(start, stop)
  start.upto(stop).filter { |day| !is_off(day) }
end

def off_days_between(start, stop)
  start.upto(stop).filter { |day| is_off(day) }
end
