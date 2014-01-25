$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), "vendor"))
require 'rubygems'
require 'rest-client'
require 'puppet'
require 'git'
require 'api/rest'
require 'api/certs'
require 'api/code'

