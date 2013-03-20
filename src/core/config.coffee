### config.coffee ###

fs = require 'fs'
path = require 'path'
async = require 'async'

{readJSON, readJSONSync, fileExists, fileExistsSync} = require './utils'
console.log fileExistsSync

class Config

  defaults =
    # path to the directory containing content's to be scanned
    contents: './contents'
    # list of glob patterns to ignore
    ignore: []
    # context variables, passed to views/templates
    locals: {}
    # list of modules/files to load as plugins
    plugins: []
    # list of modules/files loaded and added to locals
    require: []
    # path to the directory containing the templates
    templates: './templates'
    # directory to load custom views from
    views: null
    # built product goes here
    output: './build'

  constructor: (options) ->
    for option, value of options
      this[option] = value
    for option, defaultValue of defaults
      this[option] ?= defaultValue

Config.fromFile = (path, callback) ->
  ### Read config from *path* as JSON and *callback* with a Config instance. ###
  async.waterfall [
    (callback) ->
      fileExists path, (exists) ->
        if exists
          readJSON path, callback
        else
          callback new Error "Config file at '#{ path }' does not exist."
    (options, callback) ->
      callback null, new Config options
  ], callback

Config.fromFileSync = (path) ->
  ### Read config from *path* as JSON return a Config instance. ###
  if not fileExistsSync path
    throw new Error "Config file at '#{ path }' does not exist."
  return new Config readJSONSync path

### Exports ###

exports.Config = Config