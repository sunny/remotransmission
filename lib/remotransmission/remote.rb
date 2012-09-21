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
    options.merge!(RemoTransmission::DEFAULT_OPTIONS)
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

    def command(*cmd)
      debug *cmd
      exit_status = nil
      err = nil
      out = nil

      Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thread|
        err = stderr.gets(nil)
        out = stdout.gets(nil)
        [stdin, stdout, stderr].each { |stream|
          stream.send('close')
        }
        exit_status = wait_thread.value
      end

      if exit_status.to_i > 0
        err = err.chomp if err
        raise RemoTransmission::ShellError, err
      elsif out
        out.chomp
      else
        true
      end
    end

    def rpc(options = {})
      default_options = { arguments: { fields: ["error","errorString","eta","id","isFinished","leftUntilDone","name","peersGettingFromUs","peersSendingToUs","rateDownload","rateUpload","sizeWhenDone","status","uploadRatio"] }, tag: 4 }
      options = default_options.merge(options).to_json

      curl = command("curl -fsS -u #{@user}:#{@password} -d '#{options}' http://#{@host}:#{@port}/transmission/rpc")
      json = JSON.parse(curl)
      debug(json)
      json
    rescue RemoTransmission::ShellError => e
      puts e.message
      exit 1
    end

    def debug(*obj)
      puts *obj if @debug
    end
end

