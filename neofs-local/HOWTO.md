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
Pulling storage10   ... done
Pulling storage06   ... done
Pulling storage08   ... done
Pulling storage01   ... done
Pulling cli        ... done
Pulling gate       ... done
Pulling nginx      ... done
Pulling storage05   ... done
Pulling storage03   ... done
Pulling privnet    ... done
Pulling storage02   ... done
Pulling storage04   ... done
Pulling storage09   ... done
Pulling np-prompt  ... done
Pulling storage07   ... done
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

# Do not delete unpaid objects
NEOFS_GC_DEBTORS_APPARITOR_ENABLED=false
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
Creating neofs storage-06  ... done
Creating neofs storage-02  ... done
Creating neofs storage-03  ... done
Creating neofs storage-07  ... done
Creating neofs storage-10  ... done
Creating neofs storage-05  ... done
Creating neofs storage-09  ... done
Creating neofs storage-08  ... done
Creating neofs storage-01  ... done
Creating neofs storage-04  ... done
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
Starting neofs storage-10  ... done

NAME:
   neofs-cli - A new cli application

USAGE:
   neofs-cli [global options] command [command options] [arguments...]

VERSION:
   0.1.1 (now)

COMMANDS:
   set         set default values for key or host
   object      object manipulation
   sg          storage group manipulation
   container   container manipulation
   withdraw    withdrawals manipulation
   accounting  accounts manipulation
   journal     journal manipulation
   help, h     Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --ttl value     request ttl (default: 0)
   --config value  config (default: ".neofs-cli.yml") [$NEOFS_CLI_CONFIG]
   --help, -h      show help
   --version, -v   print the version

bash-5.0#
```

## Let's create new **Container**

**Command will await until container will be accepted on Consensus**

```
bash-5.0# neofs-cli container put --rule 'SELECT 3 Node'

Container processed: 2jXnpixkV3VhXws2rNtJJp5kTumct3TaJYf6h9Tb4zer

Trying to wait until container will be accepted on consensus...
......
Success! Container <2jXnpixkV3VhXws2rNtJJp5kTumct3TaJYf6h9Tb4zer> created.

```


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

## Let's upload my cat's photo 

**Attention** without creation of StorageGroup, your files will be removed in a few minutes.
How to create StorageGroup you can find [here](##Let's create StorageGroup for our files).

I have photo `/data/cat_in_space.jpeg`
```
# You should pass CID from previous step
#
# neofs-cli object put --cid <cid> --file </path/to/file>

bash-5.0# neofs-cli object put --cid 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n --file /data/cat_in_space.jpeg

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

## Let's upload my cat's video

**Attention** without creation of StorageGroup, your files will be removed in a few minutes.
How to create StorageGroup you can find [here](##Let's create StorageGroup for our files).

I have some prepared video: `/data/cat_in_space.mp4`

```
# You should pass CID from previous step
#
# neofs-cli object put --cid <cid> --file </path/to/file>

bash-5.0# neofs-cli object --host storage01:8080 put --cid 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n --file /data/cat_in_space.mp4

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

bash-5.0# neofs-cli object --host storage01:8080 get --cid 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n --oid af5416a6-9fc6-4e9f-92d3-7bb7197cd41f --file /data/cat_from_space.mp4

Waiting for data...
Object origin received: af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
receiving chunks: ########
Object successfully fetched
```

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
```


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

bash-5.0# neofs-cli sg get --sgid bb010029-5aa1-45e7-92ab-453bf46a348d --cid 2jXnpixkV3VhXws2rNtJJp5kTumct3TaJYf6h9Tb4zer
System headers:
  Object ID   : bb010029-5aa1-45e7-92ab-453bf46a348d
  Owner ID    : AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y
  Container ID: 2jXnpixkV3VhXws2rNtJJp5kTumct3TaJYf6h9Tb4zer
  Payload Size: 0
  Version     : 1
  Created at  : epoch #51, 2019-10-07 16:19:09 +0000 UTC
Other headers:
  Link:<type:StorageGroup ID:9d401af5-b89e-4d12-867e-987b0ba87519 > 
  StorageGroup:<ValidationDataSize:101 ValidationHash:2ejFo82mm1AgywJcHpYsTCuazoT84tmkzFPmrtZ3y6hTbx7tcbMgzaYk8sPgUah6654G1zHEkueAW1xC1p24Wiwq > 
  Verify:<PublicKey:"\002>p/o\230\223p\372Ep^\274\2608Yc\304\334\216\374\254\343\020\233\244j\2006iLCp" KeySignature:"\004\312Rb{&\350j\374\177\265k\036\007~./\306\226\266\351\302\360Thx\271g\342aT\035\373\345\244\245L-Yo\000!\371\273\236A\356\037q\207\225\303)\030\005mb\226\0031\035\360?\200E" > 
  SGID:74d7e443-cacd-45cd-b6fe-3646e738d83a 
  HomoHash:111111111111111APfNaWmCGXxjPYJGZwiKpdX3EUk7VxXnyV7eGd74S7ukPHSnf3F7dPU4kqdaB6DuXv 
  PayloadChecksum:"\343\260\304B\230\374\034\024\232\373\364\310\231o\271$'\256A\344d\233\223L\244\225\231\033xR\270U" 
  Integrity:<HeadersChecksum:"<\177oq\363\275\335\230}[\013P^+\323e}B\252Rc'\342\223\273h\035\0312\034\357g" ChecksumSignature:"\004I\315\323H\252\004n[N9\374\354\266\253\022\224\340\377\366\206\323\355\243`;\243\250\357\263uR\310\3337\377\277\234\207\022\365\023\3621B\310!@\035D0\252um\201\345\251\202P\202xBf\334\206" >
```


## What about configuration?

**By default, environment prepared with next settings:**
```
bash-5.0# env
NEOFS_CLI_KEY=/user.key
NEOFS_CLI_ADDRESS storage01:8080
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
Stopping neofs storage-08  ... 
Stopping neofs storage-02  ... 
Stopping neofs storage-04  ... 
Stopping neofs storage-01  ... 
Stopping neofs storage-10  ... 
Stopping neofs storage-07  ... 
Stopping neofs storage-03  ... 
Stopping neofs storage-01  ... done
Stopping neofs storage-09  ... done
Stopping neofs storage-05  ... done
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
Removing neofs storage-08                  ... 
Removing neofs storage-02                  ... 
Removing neofs storage-04                  ... 
Removing neofs storage-01                  ... 
Removing neofs storage-10                  ... 
Removing neofs storage-07                  ... 
Removing neofs storage-03                  ... 
Removing neofs storage-03                  ... done
Removing neofs storage-09                  ... done
Removing neofs storage-05                  ... done
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
