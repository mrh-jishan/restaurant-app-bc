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
  @restaurant = Restaurant.create(:name => restaurant_name)

  restaurant_opening_time_range = row[1].split('/').map(&:strip)


  restaurant_opening_time_range.each do |days|
    # Mon-Sun 11:30 am - 9 pm
    if days.match(/^(\w{3,5}[-]\w{3,5}\s\d{1,2}[:]*[\d{1,2}]*\s\w{2}\s[-]\s\d{1,2}[:]*[\d{1,2}]*\s\w{2})/)
      week_days_range = days.split(" ").first.split('-')
      first = @normalize_days[week_days_range[0]]
      last = @normalize_days[week_days_range[1]]

      puts "Range: #{days} first: #{first} and last: #{last}"
      week_days_arr = get_days(first, last)

      times_range = days.split(' ')[1..-1].join(' ').split('-').map(&:strip)
      start_time = DateTime.parse(times_range[0]).strftime("%H:%M")
      end_time = DateTime.parse(times_range[1]).strftime("%H:%M")

      week_days_arr.each do |day|
        @restaurant.opening_hours.create(:day_of_week => day, :opens => start_time, :closes => end_time,)
      end
    end

    # Mon-Thu, Sun 11:30 am - 9 pm
    if days.match(/^(\w{3,4}\s*[-]\s*\w{3,5}[,]\s*\w{3,5}\s*\d{1,2}[:]*[\d{1,2}]*\s\w{2}\s[-]\s\d{1,2}[:]*[\d{1,2}]*\s\w{2})/)
      week_days_range = days.split(",")
      first_week_days_range = week_days_range.first.split('-').map(&:strip)
      first = @normalize_days[first_week_days_range[0]]
      last = @normalize_days[first_week_days_range[1]]

      puts "Range: #{days} first: #{first} and last: #{last}"

      week_days_arr = get_days(first, last)

      week_days = days.split(" ")[1]
      week_days_arr << @normalize_days[week_days]


      times_range = days.split(' ')[2..-1].join(' ').split('-').map(&:strip)
      start_time = DateTime.parse(times_range[0]).strftime("%H:%M")
      end_time = DateTime.parse(times_range[1]).strftime("%H:%M")

      week_days_arr.each do |day|
        @restaurant.opening_hours.create(:day_of_week => day, :opens => start_time, :closes => end_time,)
      end
    end
  end
end