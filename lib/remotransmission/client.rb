# The main Remote Transmission driver
class RemoTransmission::Client < RemoTransmission::Remote
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
    add = super
    puts add["result"]
  end

  # Prints all active torrents
  #
  # Example:
  #   >> transmission.list
  #   100% - ubuntu-10.10-desktop-i386.iso
  #   100% - ubuntu-10.10-server-i386.iso
  def list
    list = super
    args = list["arguments"]
    torrents = args["torrents"]
    torrents.each do |torrent|
      left = torrent["leftUntilDone"].to_f
      size = torrent["sizeWhenDone"].to_f
      pourcent = size != 0 ? ((size-left)*100/size).floor : "?"
      puts "#{pourcent}% - #{torrent["name"]}"
    end
  end
end

