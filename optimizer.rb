require 'set'
require './constants'

class Holiday
  attr_reader :work_day_before, :work_day_after, :pto_days
  def initialize(work_day_before, work_day_back, pto_days)
    @work_day_before = work_day_before
    @work_day_back = work_day_back
    @pto_days = pto_days
  end

  def first_day
    @work_day_before.next_day
  end

  def last_day
    @work_day_back.prev_day
  end

  def length
    ((@work_day_back - @work_day_before) - 1).to_i
  end

  def to_s
    "Holiday: #{length} days from #{first_day.to_s} to #{last_day.to_s} " \
      "(#{pto_days.size} PTO days spent)."
  end
end

class HolidaySet
  attr_reader :holidays
  def initialize()
    @holidays = ::Set.new
  end
  def add(holiday)
    @holidays.add(holiday)
  end
  def pto_days
    @holidays.reduce([]) { |a, h| a + h.pto_days }
  end
  def length
    @holidays.sum(&:length)
  end
  def to_s
    @holidays.map { |h| h.to_s }.join("\n")
  end
end

# Return a holiday spanning `span` days,
# that spend less than `pto_count` days among `work_days`.
# We assume that the day before `start` and the day after `stop` are worked.
def find_holiday_span(span, work_days, start, stop, pto_count)
  null_holiday = Holiday.new(start, start, [])
  return null_holiday if pto_count <= 0 || span <= 0
  best_holiday = null_holiday

  work_days.each_with_index do |start_day, span_start|
    pto_count.downto(1).each do |pto_spent|
      work_day_before = work_days[span_start - 1] || start.prev_day
      span_end = span_start + pto_spent
      work_day_back = work_days[span_end] || stop.next_day
      holiday = Holiday.new(work_day_before, work_day_back,
        work_days[span_start..span_end-1])
      best_holiday_size = best_holiday.pto_days.size
      if holiday.length == span && (best_holiday_size <= 0 ||
                                    holiday.pto_days.size <= best_holiday_size)
        best_holiday = holiday
      end
    end
  end

  best_holiday
end

# Return the list of holidays to take
# if you have `pto_count` days of PTO in the year.
# It maximizes the length of holidays.
def longest_pto(start: Date.new(2020, 1, 1),
                stop: Date.new(2021, 1, 1),
                pto_count: 20,
                max_holiday_size: pto_count * 2)
  work_days = work_days_between(start, stop)
  holidays = HolidaySet.new

  max_holiday_size.downto(1).each do |span|
    # Find all holiday spans of this length.
    loop do
      holiday = find_holiday_span(span, work_days, start, stop, pto_count)
      break if holiday.pto_days.size == 0
      holidays.add(holiday)
      work_days -= holiday.pto_days
      pto_count -= holiday.pto_days.size
    end
  end

  holidays
end
