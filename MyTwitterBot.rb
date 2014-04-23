# -*- coding: utf-8 -*-
require './TwitterBot.rb' # TwitterBot.rbの読み込み
require './Calender2.rb'
require "rubygems"
require "oauth"
require 'json'
require 'rexml/document'
require 'yaml'
require 'date'

#---------- MyTwitterBot -----------                
class MyTwitterBot < TwitterBot
  # 機能を追加
  def mytwitter
    weather = Weather.new
    calender2 = Calender2.new
    
    twt = get_tweet
    twt_message = twt.first["message"]
    twt_user_id = twt.first["user_id"]
    
    puts twt_message
    
    todays_weather = weather.today_weather
    puts todays_weather

    calender2.calender
    
    if /「(.*)」と言って/ =~ twt_message
      puts $1
      say_message = $1
      say_message << "by Ichikawa's TwitterBot "
      
      if say_message.length > 140
        puts "Message is longer than 140 characters. Message is not tweet."
      else
        tweet("@"+twt_user_id+" "+say_message)
      end
    end
    
    if /今日の天気/ =~ twt_message
      puts twt_user_id
      weather_tweet = "@"+twt_user_id+" "+
            "今日の天気は"+ todays_weather + "です．"

      

      tweet(weather_tweet)
    end
    
    if /今月の予定/ =~ twt_message
      puts twt_user_id
      say = calender2.calender
      tweet("@"+twt_user_id+" "+say)
    end
  end
end
class Weather
  def get_time
    now_time = DateTime.now
    return now_time
  end

  def date
    now_time = self.get_time
    /: (.*)-(.*)-(.*)T/ =~ now_time.inspect
    
    @year = $1
    @month = $2
    @day = $3
    
  end
  
  def today_weather
    weather_xml = `curl http://www.drk7.jp/weather/xml/33.xml`
    weather_resource = REXML::Document.new(weather_xml)
    
    self.date
    
    weather = weather_resource.root.elements["pref id='岡山県'/"].elements["area id='北部'"].elements["info date='#{@year}/#{@month}/#{@day}'"].elements["weather"].text
    return weather
  end
end

mytwitterbot = MyTwitterBot.new
mytwitterbot.mytwitter
