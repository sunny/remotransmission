# Driver for all API calls
class RemoTransmission::Remote
  # Initialize a remote transmission
  #
  # Arguments:
  #   options: hash
  #
  # Options:
  #   :host: host to connect to (String)
  #   :port: port to connect to (Integer)
  #   :user: username to authenticate to (String)
  #   :password: password to authenticate to (String)
  #   :debug: flag to turn on debugging (Integer)
  def initialize(options = {})
    defaults = RemoTransmission::DEFAULT_OPTIONS
    options = defaults.merge(options)
    @host = options[:host]
    @port = options[:port]
    @user = options[:user]
    @password = options[:password]
    @debug = options[:debug]
  end

  # Add a torrent to the transmission client
  # and returns output.
  #
  # Arguments:
  #   url: magnet URL or URL of torrent file
  #
  # Example:
  #   >> transmission.add("magnet://..."")
  #   { "result" => "success" }
  def add(url)
    rpc(
      method: "torrent-add",
      tag: 8,
      arguments: { filename: url }
    )
  end

  # Prints all active torrents
  #
  # Example:
  #   >> transmission.list
  #   { "arguments" => { "torrents" => { "leftUntilDone" => ... } }
  def list
    rpc(
      method: "torrent-get",
      tag: 4,
      arguments: {
        #fields: ["error","errorString","eta","id","isFinished","leftUntilDone","name","peersGettingFromUs","peersSendingToUs","rateDownload","rateUpload","sizeWhenDone","status","uploadRatio"],
        fields: ["isFinished","leftUntilDone","sizeWhenDone", "name"],
      }
    )
  end

  private

    def rpc(options = {})
      uri = URI("http://#{@host}:#{@port}/transmission/rpc")
      response = Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Post.new(uri.path)
        request.body = options.to_json
        request.basic_auth(@user, @password)
        http.request(request)
      end

      json = JSON.parse(response.body)
      $stderr.puts json if @debug
      json
    end
end

