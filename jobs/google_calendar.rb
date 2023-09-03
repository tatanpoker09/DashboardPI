# encoding: UTF-8

require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require 'json'

# Constants
CALENDAR_ID = 'ceilersg@andrew.cmu.edu' # Replace with your Calendar ID
CREDENTIALS_PATH = './creds/treeassistant-tatan-54ea00e027d5.json'
TOKEN_PATH = './creds/token.yaml'
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

# Ensure client secrets file exists at CREDENTIALS_PATH
unless File.exist?(CREDENTIALS_PATH)
  puts "Missing client secrets file at #{CREDENTIALS_PATH}"
  exit 1
end

# Initialize the Google Calendar API
service = Google::Apis::CalendarV3::CalendarService.new
service.client_options.application_name = 'Dashing Calendar Widget'
service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open(CREDENTIALS_PATH),
  scope: SCOPE
)

# Load token or authorize if necessary
service.authorization.fetch_access_token!

# Start the scheduler
SCHEDULER.every '15m', first_in: 4 do |job|
  time_min = (Time.now - 15 * 60).iso8601 # 15 minutes ago

  # Fetch events from the calendar
  events = service.list_events(
    CALENDAR_ID,
    max_results: 6,
    single_events: true,
    order_by: 'startTime',
    time_min: time_min,
  )

  send_event('google_calendar', {events: events})
end
