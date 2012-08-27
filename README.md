RemoTransmission
================

A command line interface for remote transmission.

Install
-------

```sh
$ gem install remotransmission
```

Usage
-----

```sh
$ remotransmission -p PaSsWord --add 'magnet://...'
success

$ remotransmission -p PaSsWord --server 214.512.12.20 --port 9092 --list
100% - ubuntu-10.10-desktop-i386.iso
100% - ubuntu-10.10-server-i386.iso

$ remotransmission -h
Usage: remotransmission [-alsupd]

Commands:
    -a, --add=URL                    Add a torrent by its URL
    -l, --list                       List current torrents
        --help                       Show this message
        --version                    Show version

Common options:
    -s, --server=IP                  The hostname or ip of the host to bind to (default 192.168.0.254)
        --port=PORT                  The port to bind to (default 9091)
    -u, --user=USER                  User to authenticate (default freebox)
    -p, --password=PASSWORD          Password to authenticate
    -d, --debug                      Enable debug mode

Examples:
    $ remotransmission -p PaSsWord --add 'magnet://...'
    success
    $ remotransmission -p PaSsWord --server 214.512.12.20 --port 9092 --list
    100% - ubuntu-10.10-desktop-i386.iso
    100% - ubuntu-10.10-server-i386.iso
```
