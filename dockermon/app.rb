# frozen_string_literal: true
Encoding.default_external = 'UTF-8'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra-websocket'
require 'json'

require 'net/http'
require 'uri'
require 'thread/pool'
require 'timers'


def get_docker_stats(targets)
  stats = []

  targets.each{|t|
    raw_stats = `#{t[:command]} stats --no-stream #{t[:name]}`
    raw_stat = raw_stats.split("\n")[1]
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
    @mon_targets = [
      { name: 'led_sudare_simulator', command: 'docker'},
    ]
    timers = Timers::Group.new
    timers.every(2) {
      settings.sockets.each {|s|
        s.send get_docker_stats(@mon_targets).to_json
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
  get '/containers' do
    @mon_targets.to_json
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
