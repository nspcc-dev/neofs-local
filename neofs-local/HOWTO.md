# How to use it

## Let's pull images

```
$ make local_pull
Pulling prometheus ... done
Pulling grafana    ... done
Pulling master4    ... done
Pulling master2    ... done
Pulling master5    ... done
Pulling master3    ... done
Pulling master1    ... done
Pulling master6    ... done
Pulling holder10   ... done
Pulling holder06   ... done
Pulling holder08   ... done
Pulling holder01   ... done
Pulling cli        ... done
Pulling gate       ... done
Pulling nginx      ... done
Pulling holder05   ... done
Pulling holder03   ... done
Pulling privnet    ... done
Pulling holder02   ... done
Pulling holder04   ... done
Pulling holder09   ... done
Pulling np-prompt  ... done
Pulling holder07   ... done
```

**Note** if you see error like this, retry command (it's docker-hub error)
```
ERROR: for <service>  received unexpected HTTP status: 500 Internal Server Error
ERROR: received unexpected HTTP status: 500 Internal Server Error
make: *** [local_pull] Error 1
```

```
ERROR: error pulling image configuration: Get https://registry-1.docker.io/v2/library/nginx/blobs/sha256:<sha256>: net/http: TLS handshake timeout
```

## Neo Private Network
*If you want to use NeoFS with NeoPrivateNetwork, [**read this note**](./Blockchain.md)*

**Attention** after this steps uncomment these lines in `./neofs-local/.env`:
```
# # Indexer settings
# NEOFS_WORKERS_INDEXER_DISABLED=false
# NEOFS_INDEXER_START_FROM=4000
# NEOFS_INDEXER_ENDPOINT=http://privnet:30333
# NeoFS Smart Contract scripthash
#NEOFS_INDEXER_ADDRESSES_0=dcc5902c9e8c63286894015ffd27097fd0ac9656
```
And change `NEOFS_INDEXER_ADDRESSES_0` to SC scripthash used in NeoPrivateNetwork,
 e.g.`dcc5902c9e8c63286894015ffd27097fd0ac9656`.
 
There are operations that require user's deposit e.g. container creation.
If you want to start NeoPrivateNetwork, then you might want to do operations with actual payment:
create user's deposit, pay for the container creation, pay for the storage etc. 
To do that **comment** these lines in `./neofs-local/.env`:

```
# Disable pay of the creation containers
NEOFS_BOOKKEEPER_CONTAINER_NODE_COUNT_FACTOR=0
NEOFS_BOOKKEEPER_CONTAINER_CONTAINER_CAPACITY_FACTOR=0
```

## Let's start environment:

```
$ make local_up
⇒ Up service  
Creating network "neofs-local-net" with the default driver
Creating neofs-prometheus ... done
Creating neofs-grafana    ... done
Creating neofs-ir-01      ... done
Creating neofs-ir-02      ... done
Creating neofs-ir-03      ... done
Creating neofs-ir-04      ... done
Creating neofs-ir-05      ... done
Creating neofs-ir-06      ... done
Creating neofs-holder-06  ... done
Creating neofs-holder-02  ... done
Creating neofs-holder-03  ... done
Creating neofs-holder-07  ... done
Creating neofs-holder-10  ... done
Creating neofs-holder-05  ... done
Creating neofs-holder-09  ... done
Creating neofs-holder-08  ... done
Creating neofs-holder-01  ... done
Creating neofs-holder-04  ... done
Creating neofs-http-gate  ... done
Creating neofs-http-nginx ... done
```

## Let's run NeoFS CLI

```
$ make local_cli
Starting neofs-prometheus ... done
Starting neofs-grafana    ... done
Starting neofs-ir-06      ... done
Starting neofs-ir-03      ... done
Starting neofs-ir-01      ... done
Starting neofs-ir-05      ... done
Starting neofs-ir-02      ... done
Starting neofs-ir-04      ... done
Starting neofs-holder-01  ... done
NAME:
   neofs-cli - A new cli application

USAGE:
   neofs-cli [global options] command [command options] [arguments...]

VERSION:
   0.0.3-52-g74c1ea1e (now)

COMMANDS:
     set         set default values for key or host
     object      object manipulation
     sg          storage group manipulation
     container   container manipulation
     withdraw    withdrawals manipulation
     accounting  accounts manipulation
     help, h     Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --ttl value     request ttl (default: 0)
   --config value  config (default: ".neofs-cli.yml") [$NEOFS_CLI_CONFIG]
   --help, -h      show help
   --version, -v   print the version

bash-5.0#
```

## Let's create new **Container**

```
bash-5.0# neofs-cli container put --rule 'SELECT 3 Node'

Container created: 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n
```

**Wait until container will be accepted on Consensus**

## Let's see what I have at my `/data` folder

I've added a few files(`cat_in_space.jpeg`,`cat_in_space.mp4`, `cat_in_space.zip`) to `/data` folder so I can use them later.
```
bash-5.0# ls -lah  /data 
total 60M    
drwxr-xr-x    6 root     root         192 Sep  2 10:01 .
drwxr-xr-x    1 root     root        4.0K Sep  2 10:04 ..
-rw-r--r--    1 root     root           0 Sep  1 13:59 .gitkeep
-rw-r--r--    1 root     root      519.7K Sep  2 09:59 cat_in_space.jpeg
-rw-r--r--    1 root     root       29.2M Sep  2 10:01 cat_in_space.mp4
-rw-r--r--    1 root     root       29.6M Sep  2 10:01 cat_in_space.zip
```

## Let's upload my cat's foto 

**Attention** without creation of StorageGroup, your files will be removed in a few minutes.
How to create StorageGroup you can find [here](##Let's create StorageGroup for our files).

I have very cool foto `/data/cat_in_space.jpeg`
```
# You should pass CID from previous step
#
# neofs-cli object put --cid <cid> --file </path/to/file>

bash-5.0# neofs-cli object put --cid 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n --file /data/cat_in_space.jpeg

Storage group:  144d5258-fe70-4986-8536-82ad391c77eb
[/data/cat_in_space.jpeg] Sending header...
[/data/cat_in_space.jpeg] Sending data...
[/data/cat_in_space.jpeg] Object successfully stored
  ID: 67d79328-f33a-4896-ba15-7b2def754f94
  CID: 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n
```

## Let's download cat's photo

### For browser
Fill template with data from previous step: `http://localhost:7000/<cid>/<id>`
```
# ID: 67d79328-f33a-4896-ba15-7b2def754f94
# CID: 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n
```

in my example it's:
- `http://localhost:7000/5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n/67d79328-f33a-4896-ba15-7b2def754f94`

### For cli

```
# You should pass CID and ID from previous step
#
# neofs-cli object get --cid <cid> --oid <id> --file </path/to/out/file>

bash-5.0# neofs-cli object get --cid 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n --oid 67d79328-f33a-4896-ba15-7b2def754f94 --file /data/cat_from_space.jpeg

Waiting for data...
Object origin received: 67d79328-f33a-4896-ba15-7b2def754f94
receiving chunks: 
Object successfully fetched
```

**Oh, it's amazing!**

## Let's upload my cat's video

**Attention** without creation of StorageGroup, your files will be removed in a few minutes.
How to create StorageGroup you can find [here](##Let's create StorageGroup for our files).

I have some prepared video: `/data/cat_in_space.mp4`

```
# You should pass CID from previous step
#
# neofs-cli object put --cid <cid> --file </path/to/file>

bash-5.0# neofs-cli object --host holder01:8080 put --cid 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n --file /data/cat_in_space.mp4

Storage group:  6b8760c6-3a9c-4f05-acd4-54bb8ae3d766
[/data/cat_in_space.mp4] Sending header...
[/data/cat_in_space.mp4] Sending data...
[/data/cat_in_space.mp4] Object successfully stored
  ID: af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
  CID: 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n
```

## Let's download cat's video

### For browser 

Fill template with data from previous step: `http://localhost:7000/<cid>/<id>`
```
# ID: af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
# CID: 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n
```

in my example it's:
- `http://localhost:7000/5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n/af5416a6-9fc6-4e9f-92d3-7bb7197cd41f`

### For cli

```
# You should pass CID and ID from previous step
#
# neofs-cli object get --cid <cid> --oid <id> --file </path/to/out/file>

bash-5.0# neofs-cli object --host holder01:8080 get --cid 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n --oid af5416a6-9fc6-4e9f-92d3-7bb7197cd41f --file /data/cat_from_space.mp4

Waiting for data...
Object origin received: af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
receiving chunks: ########
Object successfully fetched
```

**It's pretty cool!**

## Let's create StorageGroup for our files

```
# CID: 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n
# First file:
# ID: 67d79328-f33a-4896-ba15-7b2def754f94
# Second file:
# ID: af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
# Getting this id's from previous steps and pass to command
#
# neofs-cli sg put --cid <cid> --oid <id1> --oid <id2>

bash-5.0# neofs-cli sg put --cid 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n --oid 67d79328-f33a-4896-ba15-7b2def754f94 --oid af5416a6-9fc6-4e9f-92d3-7bb7197cd41f

Storage group successfully stored
        ID: ab0dd79f-5f52-4846-b863-e78b5a7d84e0
        CID: 4V1cdTPmk5x4SUZnCdma7tukm9UV9zadv9DbwM25e5Rq

storage group sent to the consensus
```

**Wait until SG is accepted on consensus**

## Let's try to work with our StorageGroups

- list all our SGID's
```
bash-5.0# neofs-cli sg list --cid 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n

Container ID: Object ID
4V1cdTPmk5x4SUZnCdma7tukm9UV9zadv9DbwM25e5Rq: ab0dd79f-5f52-4846-b863-e78b5a7d84e0

```
- list all our files in SGID
```
# ab0dd79f-5f52-4846-b863-e78b5a7d84e0
# 
# Get SGID from previous step and fill command
#
# neofs-cli sg get --sgid <sgid>

bash-5.0# neofs-cli sg get --sgid ab0dd79f-5f52-4846-b863-e78b5a7d84e0 --cid 4V1cdTPmk5x4SUZnCdma7tukm9UV9zadv9DbwM25e5Rq

StorageGroupID: ab0dd79f-5f52-4846-b863-e78b5a7d84e0
---
Size: 31172363
ContainerID: 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n
OwnerID: vU6cbkQQrq4AewTPB1JVbstWc9bbFAPyrAoVzomPwtu7
Homomorphic Hash: xqASqQp5DueeJJABKe8LSknvJVF7GMSHNgoLaSmU4KnbnQHqfLRFpYqQvqvo4QNCU6AKu8XXrnBTYPQ5w6CSwbM
Additional SGID: 144d5258-fe70-4986-8536-82ad391c77eb
Additional SGID: 6b8760c6-3a9c-4f05-acd4-54bb8ae3d766
```

**Note:** if a storage group disappears after a short period of time, this means that it is not set the creation time and SG will be immediately cleaned up by the garbage collector.



## What about configuration?

**By default, environment prepared with next settings:**
```
bash-5.0# env
NEOFS_CLI_KEY=/user.key
NEOFS_CLI_ADDRESS=holder01:8080
```
*You can change key*

- Set key as hex-string, for example:
```
bash-5.0# neofs-cli set key c428b4a06f166fde9f8afcf918194acdde35aa2612ecf42fe0c94273425ded21

set new value for key: "c428b4a06f166fde9f8afcf918194acdde35aa2612ecf42fe0c94273425ded21"
```
- Set key as wif-string, for example:
```
bash-5.0# neofs-cli set key L5LDzGxboJv2CqWKp7v8UGddAMf834DZvMK7muRgNqXTSTwG8pRJ

set new value for key: "L5LDzGxboJv2CqWKp7v8UGddAMf834DZvMK7muRgNqXTSTwG8pRJ"
```
- Set key as file path, for example:
```
bash-5.0# neofs-cli set key /user.key 

set new value for key: "/user.key"
```

**Note** if you enter wrong data, application will report you about that, for example:
```
bash-5.0# neofs-cli set key this-is-something-wrong-passed-to-key
unknown key format ("this-is-something-wrong-passed-to-key"), expect: hex-string, wif or file-path

# OR 

bash-5.0# neofs-cli set key
value could not be empty
```

*You can change host-address*

- Set address for all interfaces on your host:
```
bash-5.0# neofs-cli set host :8080

set new value for host: "0.0.0.0:8080"
```
- Set address for some interface on your host:
```
bash-5.0# neofs-cli set host 127.0.0.1:8080

set new value for host: "127.0.0.1:8080"
```
- Set address for hostname and port:
```
bash-5.0# neofs-cli set host google.com:8080

set new value for host: "209.85.233.139:8080"
```

**Note** if you enter wrong data, application will report you about that, for example:
```
bash-5.0# neofs-cli set host google.com
could not fetch host/port: "google.com": address google.com: missing port in address

# OR 

bash-5.0# neofs-cli set host
value could not be empty
```


## Exit from NeoFS cli

```
bash-5.0# exit
exit

$ 
```

## Stop environment

```
$ make local_down
⇒ Stop the world 
Stopping neofs-http-nginx ... 
Stopping neofs-http-gate  ... 
Stopping neofs-holder-08  ... 
Stopping neofs-holder-02  ... 
Stopping neofs-holder-04  ... 
Stopping neofs-holder-01  ... 
Stopping neofs-holder-10  ... 
Stopping neofs-holder-07  ... 
Stopping neofs-holder-03  ... 
Stopping neofs-holder-01  ... done
Stopping neofs-holder-09  ... done
Stopping neofs-holder-05  ... done
Stopping neofs-ir-06      ... done
Stopping neofs-ir-03      ... done
Stopping neofs-ir-02      ... done
Stopping neofs-ir-04      ... done
Stopping neofs-ir-05      ... done
Stopping neofs-ir-01      ... done
Stopping neofs-grafana    ... done
Stopping neofs-prometheus ... done
Removing neofs-local_cli_run_7767cf3e42c4 ... 
Removing neofs-http-nginx                 ... 
Removing neofs-http-gate                  ... 
Removing neofs-holder-08                  ... 
Removing neofs-holder-02                  ... 
Removing neofs-holder-04                  ... 
Removing neofs-holder-01                  ... 
Removing neofs-holder-10                  ... 
Removing neofs-holder-07                  ... 
Removing neofs-holder-03                  ... 
Removing neofs-holder-03                  ... done
Removing neofs-holder-09                  ... done
Removing neofs-holder-05                  ... done
Removing neofs-ir-06                      ... done
Removing neofs-ir-03                      ... done
Removing neofs-ir-02                      ... done
Removing neofs-ir-04                      ... done
Removing neofs-ir-05                      ... done
Removing neofs-ir-01                      ... done
Removing neofs-grafana                    ... done
Removing neofs-prometheus                 ... done
Removing network neofs-local-net
```
