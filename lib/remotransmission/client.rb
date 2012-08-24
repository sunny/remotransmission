# The main Remote Transmission driver
class RemoTransmission::Client
  # Initialize a remote transmission
  #
  # Arguments:
  #   host: host to connect to (String)
  #   port: port to connect to (Integer)
  #   user: username to authenticate to (String)
  #   password: password to authenticate to (String)
  #   debug: flag to turn on debugging (Integer)
  def initialize(host = "localhost", port = 9091, user = "", password = "", debug = false)
    @host = host
    @port = port
    @user = user
    @password = password
    @debug = debug
  end

  # Add a torrent to the transmission client
  # and prints output.
  #
  # Arguments:
  #   url: magnet URL or URL of torrent file
  #
  # Example:
  #   >> transmission.add("magnet://..."")
  #   success
  def add(url)
    add = rpc(
      method: "torrent-add",
      tag: 8,
      arguments: {
        filename: url,
      }
    )
    result = add["result"]
    puts result
  end

  # Prints all active torrents
  #
  # Example:
  #   >> transmission.list
  #   100% - ubuntu-10.10-desktop-i386.iso
  #   100% - ubuntu-10.10-server-i386.iso
  def list
    list = rpc(
      method: "torrent-get",
      tag: 4,
      arguments: {
        #fields: ["error","errorString","eta","id","isFinished","leftUntilDone","name","peersGettingFromUs","peersSendingToUs","rateDownload","rateUpload","sizeWhenDone","status","uploadRatio"],
        fields: ["isFinished","leftUntilDone","sizeWhenDone", "name"],
      }
    )

    args = list["arguments"]
    torrents = args["torrents"]
    torrents.each do |torrent|
      left = torrent["leftUntilDone"].to_f
      size = torrent["sizeWhenDone"].to_f
      pourcent = size != 0 ? ((size-left)*100/size).floor : "?"
      puts "#{pourcent}% - #{torrent["name"]}"
    end
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
        raise ShellError, err
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
    rescue ShellError => e
      puts e.message
      exit 1
    end

    def debug(*obj)
      puts *obj if @debug
    end
end

