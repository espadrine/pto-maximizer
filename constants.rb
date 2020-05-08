require 'holidays'

def public_holidays(day, country: :fr)
  holidays = Holidays.on(day, country)
  holidays && !holidays.empty?
end

def is_weekend(day)
  day.saturday? || day.sunday?
end

def is_public_holiday(day)
  public_holidays(day)
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
