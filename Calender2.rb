# -*- coding: utf-8 -*-
require 'google/api_client'
require "yaml"
require "time"

# Initialize OAuth 2.0 client
# authorization

#---------Calender2------------
class Calender2
  
  def initialize
    oauth_yaml = YAML.load_file('.google-api.yaml')

    @calendar_id = oauth_yaml["calendar_id"]

    @client = Google::APIClient.new(
                                 :application_name => 'calendar',
                                 :application_version => 'v3'
                                 )
    @client.authorization.client_id = oauth_yaml["client_id"]
    @client.authorization.client_secret = oauth_yaml["client_secret"]
    @client.authorization.scope = oauth_yaml["scope"]
    @client.authorization.refresh_token = oauth_yaml["refresh_token"]
    @client.authorization.access_token = oauth_yaml["access_token"]
    @client.authorization.fetch_access_token!
    
    @cal = @client.discovered_api('calendar', 'v3')
    puts @mailaddress
  end  


  def calender

    # 時間を格納

    date = Date.today
    
    year = date.year
    month = date.month
    day = date.day
    
    time_min = Time.utc(year, month, day, 0).iso8601
    time_max = Time.utc(year, month, 31, 0).iso8601
    
    
    # イベントの取得
    params = {'calendarId' => @calendar_id,
      'orderBy' => 'startTime',
      'timeMax' => time_max,
      'timeMin' => time_min,
      'singleEvents' => 'True'}
    
    result = @client.execute(:api_method => @cal.events.list,
                             :parameters => params)
    
    # イベントの格納
    events = []
    result.data.items.each do |item|
      events << item
    end

    # 出力
    say = "今月の予定は"

    events.each do |event|
      say << event.summary
      say << ","
    end
    say << "です．"

    puts say
    return say
  end
end
