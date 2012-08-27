RemoTransmission
================

A command line interface for remote transmission.

Can add a torrent and list the current torrents with their percentage.

Install
-------

```sh
$ gem install remotransmission
```

Usage
-----

```sh
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
```

Examples
--------

Adding a magnet URL with the default host and port and user (`192.168.0.254`,
`9091` and `freebox`) and specifying a password:

```sh
$ remotransmission -p PaSsWord --add 'magnet://...'
success
```

List all current torrents by specifying the hostname, user and password:

```sh
$ remotransmission -u bob -p PaSsWord -s 214.512.12.20 --list
100% - ubuntu-10.10-desktop-i386.iso
80% - ubuntu-10.10-server-i386.iso
```
