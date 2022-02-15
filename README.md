# PivoMap

Simple script developed to scan active hosts and ports on the network when pivoting between computers or containers.

## Usage:

### scan.sh

If you want to scan the active hosts under a network

```
$ ./scan.sh -H 172.15.0.0
```

If you want to scan the first 1,000 active ports of a specific host

```
$ ./scan.sh -H 172.15.0.18 -p 10000
```
#### **The port.sh and host.sh scripts use scan.sh as their basis.**

### host.sh

To be able to scan the entire network without having to do it manually you can run:

```
./host.sh
```

### port.sh

In order to scan all ports of all active hosts within the network without having to do it manually you can run:

```
./port.sh <top-port-range>
```
