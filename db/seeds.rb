require "csv"
require 'net/http'
require "time"
require 'date'

@normalize_days = {
    "Sun" => "Sunday",
    "Mon" => "Monday",
    "Tues" => "Tuesday",
    "Weds" => "Wednesday",
    "Wed" => "Wednesday",
    "Thurs" => "Thursday",
    "Thu" => "Thursday",
    "Fri" => "Friday",
    "Sat" => "Saturday"}

@weeks = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

uri = URI('https://gist.githubusercontent.com/seahyc/7ee4da8a3fb75a13739bdf5549172b1f/raw/f1c3084250b1cb263198e433ae36ba8d7a0d9ea9/hours.csv')
csv_text = Net::HTTP.get(uri)

csv = CSV.parse(csv_text, :headers => false)

def get_sub_array(arr, start, last)
  (start > last) ? (arr[start..-1] + arr[0..last]) : arr[start..last]
end

def get_days(first, last)
  first_index = @weeks.find_index(first)
  last_index = @weeks.find_index(last)
  get_sub_array(@weeks, first_index, last_index)
end

csv.each do |row|
  restaurant_name = row[0].strip
  open_hours = row[1].strip
  @restaurant = Restaurant.create!(:name => restaurant_name, :open_hours=> open_hours)

  restaurant_opening_time_range = open_hours.split('/').map(&:strip)

  restaurant_opening_time_range.each do |days|
    # Mon-Sun 11:30 am - 9 pm
    if days.match(/^(\w{3,5}[\s]*[-][\s]*\w{3,5}[\s]*\d{1,2}[:]*[\d{1,2}]*[\s]*\w{2}\s[-]\s\d{1,2}[:]*[\d{1,2}]*\s\w{2})/)
      first_date = days.split('-')[0].strip
      last_date = days.split('-')[1].split(' ')[0].strip

      first = @normalize_days[first_date]
      last = @normalize_days[last_date]

      week_days_arr = get_days(first, last)
      last_index  = days.index(last_date) + last_date.length

      times_range = days[last_index..-1].strip.split('-').map(&:strip)
      start_time = DateTime.parse(times_range[0]).strftime("%H:%M")
      end_time = DateTime.parse(times_range[1]).strftime("%H:%M")

      puts "Stored value: #{days} day: #{week_days_arr} start time: #{start_time} and end time: #{end_time}"

      week_days_arr.each do |day|
        @restaurant.opening_hours.create!(:day_of_week => @weeks.find_index(day), :opens => start_time, :closes => end_time,)
      end
    end

    # Mon-Thu, Sun 11:30 am - 9 pm
    # Sat - Sun 8:30 am - 12:45 pm
    if days.match(/^(\w{3,4}\s*[-]\s*\w{3,5}[,]\s*\w{3,5}\s*\d{1,2}[:]*[\d{1,2}]*\s\w{2}\s[-]\s\d{1,2}[:]*[\d{1,2}]*\s\w{2})/)
      week_days_range = days.split(",")
      first_week_days_range = week_days_range.first.split('-').map(&:strip)
      first = @normalize_days[first_week_days_range[0]]
      last = @normalize_days[first_week_days_range[1]]

      week_days_arr = get_days(first, last)
      week_days = days.split(",")[1].split(' ')[0]
      week_days_arr << @normalize_days[week_days]

      times_range = days.split(' ')[2..-1].join(' ').split('-').map(&:strip)
      start_time = DateTime.parse(times_range[0]).strftime("%H:%M")
      end_time = DateTime.parse(times_range[1]).strftime("%H:%M")

      puts "Stored value: #{days} day: #{week_days_arr} start time: #{start_time} and end time: #{end_time}"

      week_days_arr.each do |day|
        @restaurant.opening_hours.create!(:day_of_week => @weeks.find_index(day), :opens => start_time, :closes => end_time,)
      end
    end

    # Sun 10 am - 11 pm
    if days.match(/^(\w{3,5}[\s]*\d{1,2}[:]*[\d{1,2}]*[\s]*\w{2}[\s]*[-][\s]*\d{1,2}[:]*[\d{1,2}]*[\s]*\w{2})/) and not days.include? ','
      week_day = @normalize_days[days.split(" ")[0]]
      times_range = days.split(' ')[1..-1].join(' ').split('-').map(&:strip)
      start_time = DateTime.parse(times_range[0]).strftime("%H:%M")
      end_time = DateTime.parse(times_range[1]).strftime("%H:%M")

      puts "Stored value: #{days} day: #{week_day} start time: #{start_time} and end time: #{end_time}"
      @restaurant.opening_hours.create!(:day_of_week => @weeks.find_index(week_day), :opens => start_time, :closes => end_time,)

    end

    # Mon, Thurs, Sat 7:15 am - 8:15 pm
    if days.match(/^(^(?:[a-zA-Z0-9 ]+,)*[a-zA-Z0-9 ]+[\s\d{1,2}][:]*[\d{1,2}]*[\s]*\w{2}[\s]*[-][\s]*\w{1,2}[:]*[\w{1,2}]*[\s]*\w{2})/) and  days.include? ','
      week_days_range = days.split(",").map(&:strip)
      last_element = week_days_range.last.split(' ').first
      week_days = week_days_range[0...-1] << last_element

      week_days_arr =  week_days.map {|day| @normalize_days[day]}
      last_index = days.index(last_element) + last_element.length

      times_range = days[last_index..-1].split('-').map(&:strip)
      start_time = DateTime.parse(times_range[0]).strftime("%H:%M")
      end_time = DateTime.parse(times_range[1]).strftime("%H:%M")

      puts "Stored value: #{days} day: #{week_days_arr} time range: #{times_range}"

      week_days_arr.each do |day|
        @restaurant.opening_hours.create!(:day_of_week => @weeks.find_index(day), :opens => start_time, :closes => end_time,)
      end
    end
  end
end