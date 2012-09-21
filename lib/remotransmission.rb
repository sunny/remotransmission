require 'json'
require 'net/http'
require 'remotransmission/version'
require 'remotransmission/remote'
require 'remotransmission/client'

module RemoTransmission
  DEFAULT_OPTIONS = {
    host: "localhost",
    port: 9091,
    user: "freebox",
    password: "",
    debug: false
  }.freeze

  # Returns the default options hash, optionnaly pulled from the given
  # configuration file.
  #
  # Arguments:
  #   file: path to JSON configuration file
  def self.default_options(file = nil)
    defaults = DEFAULT_OPTIONS

    if file and file = File.expand_path(file) and File.exists?(file)
      config = JSON.parse(File.read(file))

      # symbolize keys
      config = config.inject({}) do |options, (key, value)|
        options[key.to_sym] = value
        options
      end

      defaults = defaults.merge(config)
    end

    defaults
  end
end

