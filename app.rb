# -*- coding: utf-8 -*-

require 'rubygems'
require 'sinatra'
require 'haml'
require 'open-uri'
require 'json'

configure :production do
end

get '/' do
  haml :index
end

def request_to(url)
  uri = URI.encode(url)
  json = open(uri).read
  result = JSON.parse(json)
  return result
end

post '/result' do
  keyword = params[:keyword]
  keyword = keyword.gsub!(' ', ',') if keyword.include?(' ')

  # ATND検索
  atnd_api = "http://api.atnd.org/events/?format=json&keyword=#{keyword}"
  atnd_result = request_to(atnd_api)
  @atnd_events = atnd_result['events'].collect {|event| event['title']}

  # Zusaar検索
  zusaar_api = "http://www.zusaar.com/api/event/?format=json&keyword=#{keyword}"
  zusaar_result  = request_to(zusaar_api)
  @zusaar_events = zusaar_result['event'].collect {|event| event['title'] }

  haml :result
end


