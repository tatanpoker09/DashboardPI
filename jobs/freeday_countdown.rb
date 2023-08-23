# require "json"
# require "time"
#
# class FreedayCountdown
#
#   DEBUG = 0
#   CONFIG_FILE = 'assets/config/freeday_countdown_settings.json'
#
#   def debug
#     DEBUG
#   end
#
#   def configFile
#     CONFIG_FILE
#   end
#
#   # function to validate json
#   def valid_json? (json)
#     JSON.parse(json)
#     return true
#   rescue JSON::ParserError
#     return false
#   end
#
#   def get_start_date
#     Date.today
#   end
#
#   def get_end_date
#     Date.today.next_month(2)
#   end
#
#   def get_saturdays
#     days = []
#     (get_start_date .. get_end_date).select { |d| d.wday.eql? 6 }.each do |d|
#       days.push({ :date => d, :name => "Week's #{d.cweek.to_s} End" })
#     end
#     days
#   end
#
#   def get_holidays(region)
#     Holidays.between(get_start_date, get_end_date, region)
#   end
#
#   def get_freedays(region)
#     hols = get_holidays(region)
#     return get_saturdays if !hols or hols.empty?
#     # sort by date and name, make it unique
#     # remove sundays - no one's in office.
#     # remove free mondays - they go together with weekend
#     wdays_to_reject = [0, 1]
#     hols = (hols + get_saturdays).sort_by { |o| [o[:date], o[:name]] }.uniq { |o| o[:date] }.reject { |d| wdays_to_reject.include? d[:date].wday }
#     # also, remove free days in the middle of free period, e.g. long Christmas weekend on 2014
#     hols.select.with_index { |d, i| i == 0 || (i > 0 && hols[i - 1][:date] != d[:date]-1)}
#   end
#
#   def get_next_freeday_with_time(region, settings)
#     frees = get_freedays(region.to_sym)
#     free = frees.first
#     time = settings["workdayEndHour"]
#     time = settings["workdayEndHourBeforeHoliday"] if !free[:name].start_with?("Week's ")
#     result = { "date" => Time.parse((free[:date]-1).to_s + " " + time), "name" => free[:name] }
#     puts result if DEBUG > 1
#     result
#   end
#
# end
#
#
# @FC = FreedayCountdown.new()
#
# SCHEDULER.every '1h', :first_in => 0 do |job|
#   str = IO.read(@FC.configFile)
#   if str and @FC.valid_json?(str)
#     JSON.parse(str).each do |region, settings|
#       puts DateTime.now.to_s+" Countdown is working with #{region}" if @FC.debug > 0
#       puts [countdown: @FC.get_next_freeday_with_time(region, settings), region: region, settings: settings] if @FC.debug > 1
#       send_event("freeday_countdown_#{region}", {countdown: @FC.get_next_freeday_with_time(region, settings), region: region, settings: settings})
#     end
#   end
# end
