#!/usr/bin/env ruby

require 'bundler'
Bundler.require

class JessePinkman < Sinatra::Base
  if development?
    Bundler.require :development
    register Sinatra::Reloader
  end
end

require './app.rb'

run JessePinkman
