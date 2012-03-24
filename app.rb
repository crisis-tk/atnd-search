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

post '/result' do
  keyword = params[:keyword].gsub!(' ', ',')
  request_url = "http://api.atnd.org/events/?format=json&keyword=#{keyword}"

  uri = URI.encode(request_url)

  json   = open(uri).read
  result = JSON.parse(json)

  @events = result['events'].collect {|event| event['title']}

  haml :result
end


