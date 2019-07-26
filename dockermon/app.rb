# frozen_string_literal: true
Encoding.default_external = 'UTF-8'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra-websocket'
require 'json'

require 'async'
require 'net/http'
require 'uri'
require 'thread/pool'
require 'timers'

$mon_target = [
  { id: 'led_sudare_simulator'}
]


def get_docker_stats
  raw_stats = `docker stats -a --no-stream led_sudare_simulator`
  raw_stats = raw_stats.split("\n")[1..-1]
  stats = []
  raw_stats.each{|raw_stat|
      stat = raw_stat.split(" ")

      stats << {name:stat[1], cpu:stat[2].gsub('%', ''), mem:stat[6].gsub('%', '')}
  }
  stats
end

##
# Server program
class App < Sinatra::Base
  register Sinatra::Reloader
  enable :sessions
  set :bind, '0.0.0.0'# 外部アクセス可
  set :port, 3001
  set :sockets, []

  def initialize
    super
    timers = Timers::Group.new
    timers.every(2) {
      settings.sockets.each {|s|
        s.send get_docker_stats.to_json
      }
    }
    print "async starting"
    Thread.new do
      loop{
        timers.wait
      }
    end
    print "async started.."
  end

  get '/' do
    haml :index, locals: { title: 'Docker Container Monitor' }
  end
  get '/ws' do
    if request.websocket?
      request.websocket do |ws|
        ws.onopen do
          settings.sockets << ws
        end
        ws.onclose do
          settings.sockets.delete(ws)
        end
      end
    end
  end
end
