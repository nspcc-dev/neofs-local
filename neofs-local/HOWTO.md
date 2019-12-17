# How to use neofs-local

## Pull images
First of all pull available docker images.

```
$ make local_pull 
Pulling privnet      ... done
Pulling prometheus   ... done
Pulling grafana      ... done
Pulling master2      ... done
Pulling master3      ... done
Pulling master4      ... done
Pulling master1      ... done
Pulling storage09    ... done
Pulling storage07    ... done
Pulling storage02    ... done
Pulling storage10    ... done
Pulling cli          ... done
Pulling storage05    ... done
Pulling storage04    ... done
Pulling storage08    ... done
Pulling storage01    ... done
Pulling gw-backend   ... done
Pulling gw-nginx     ... done
Pulling drop-backend ... done
Pulling storage03    ... done
Pulling drop-ui      ... done
Pulling drop-nginx   ... done
Pulling waiter       ... done
Pulling np-prompt    ... done
Pulling storage06    ... done

```

**Note:** if you see error like this, retry command (it's docker-hub error)
```
ERROR: for <service>  received unexpected HTTP status: 500 Internal Server Error
ERROR: received unexpected HTTP status: 500 Internal Server Error
make: *** [local_pull] Error 1
```

```
ERROR: error pulling image configuration: Get https://registry-1.docker.io/v2/library/nginx/blobs/sha256:<sha256>: net/http: TLS handshake timeout
```

## Neo Private Network
*If you want to use NeoFS with NeoPrivateNetwork, [**read this note**](./Blockchain.md).*

**Attention!** To start NeoFS with blockchain indexer uncomment these lines in `./neofs-local/.env`:

```
## Indexer settings
#NEOFS_WORKERS_INDEXER_DISABLED=false
#NEOFS_INDEXER_START_FROM=4000
#NEOFS_INDEXER_ENDPOINT=http://privnet:30333
## NeoFS Smart Contract scripthash
#NEOFS_SMART_CONTRACT_HASH=0xdcc5902c9e8c63286894015ffd27097fd0ac9656
```

**Note:** don't forget to change `NEOFS_SMART_CONTRACT_HASH` variable to 
NeoFS smart contract scripthash used in NeoPrivateNetwork,
 e.g.`dcc5902c9e8c63286894015ffd27097fd0ac9656`.
 
There are operations that require user's deposit.
Comment these lines in `./neofs-local/.env` to **activate** storage payment and 
container creation payment.
```
# Disable pay of the creation containers
NEOFS_BOOKKEEPER_CONTAINER_NODE_COUNT_FACTOR=0
NEOFS_BOOKKEEPER_CONTAINER_CONTAINER_CAPACITY_FACTOR=0
NEOFS_GC_DEBTORS_APPARITOR_ENABLED=false
```

## Start environment

```
$ make local_up                                                    
⇒ Up service                                                                                  
Creating neofs-prometheus ... done                                        
Creating neofs-grafana    ... done                                           
Creating neofs-ir-01      ... done                                                        
Creating neofs-ir-02      ... done                                                                                                                   
Creating neofs-ir-04      ... done                                                                                                                                                                                                             Creating neofs-ir-03      ... done                                                                   
Creating neofs-storage-02 ... done                                                                                                                                                                     
Creating neofs-storage-07 ... done                                                                                    
Creating neofs-storage-10 ... done                                                                                                                                                                                                             Creating neofs-storage-08 ... done                                                      
Creating neofs-storage-09 ... done                                                                                                                                                                     
Creating neofs-storage-01 ... done                                       
Creating neofs-storage-05 ... done                                                                                                     
Creating neofs-storage-03 ... done                             
Creating neofs-storage-04 ... done                                                                                                                                                                     
Creating neofs-storage-06 ... done          
Creating neofs-gw-backend ... done                                            
Creating neofs-gw-nginx   ... done
```

## Run NeoFS CLI
NeoFS CLI is available in a separate github repository. More examples 
and detailed description available [there](https://github.com/nspcc-dev/neofs-cli).


```
$ make local_cli
Starting neofs-prometheus ... done
Starting neofs-grafana    ... done
Starting neofs-ir-01      ... done
Starting neofs-ir-04      ... done
Starting neofs-ir-03      ... done
Starting neofs-storage-10 ... done
NAME:
   neofs-cli - Example of tool that provides basic interactions with NeoFS

USAGE:
   neofs-cli [global options] command [command options] [arguments...]

VERSION:
   0.2.2 (2019-12-16T12:04:13)

COMMANDS:
   set         set default values for key or host
   object      object manipulation
   sg          storage group manipulation
   container   container manipulation
   withdraw    withdrawals manipulation
   accounting  accounts manipulation
   status      node status info
   help, h     Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --ttl value     request ttl (default: 2)
   --config value  config (default: ".neofs-cli.yml") [$NEOFS_CLI_CONFIG]
   --key value     user private key in hex, wif formats or path to file (default: "/user.key") [$NEOFS_CLI_KEY]
   --host value    host net address (default: "storage10:8080") [$NEOFS_CLI_ADDRESS]
   --verbose       verbose gRPC connection (default: false)
   --help, -h      show help (default: false)
   --version, -v   print the version (default: false)
```

## Container creation

**Note:** Command will await until container will be accepted by consensus in
inner ring nodes.

```

# neofs-cli container put --rule 'SELECT 2 Node'                                                   
Container processed: 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi                             
                                                                                                               
Trying to wait until container will be accepted on consensus...                               
........................                                                                                                                                                                               
Success! Container <3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi> created.
```


## Data upload and download

To demonstrate data uploading we've added a few files(`cat_in_space.jpeg`,`cat_in_space.mp4`, `cat_in_space.zip`) 
to `data` dir. This dir is mounted to the neofs-cli container.

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

### Image upload 

**Attention!** Without storage group files will be removed in a few minutes.
Look how to create storage [here](##Create storage group).

We have file with a photo `/data/cat_in_space.jpeg`
```
# You should pass CID from previous step
#
# neofs-cli object put --cid <cid> --file </path/to/file>

bash-5.0# neofs-cli object put --cid 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi --file /data/cat_in_space.jpeg
[/data/cat_in_space.jpeg] Sending header...
[/data/cat_in_space.jpeg] Sending data...
[/data/cat_in_space.jpeg] Object successfully stored
  ID: 67d79328-f33a-4896-ba15-7b2def754f94
  CID: 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi
```

### Image download

#### With browser
Use address `http://localhost:7000/<cid>/<id>` with data from previous step: 

In this example it is:
```
  ID: 67d79328-f33a-4896-ba15-7b2def754f94
  CID: 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi

  http://localhost:7000/3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi/67d79328-f33a-4896-ba15-7b2def754f94
```

#### With CLI

```
# You should pass CID and ID from previous step
#
# neofs-cli object get --cid <cid> --oid <id> --file </path/to/out/file>

bash-5.0# neofs-cli object get --cid 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi --oid 67d79328-f33a-4896-ba15-7b2def754f94 --file /data/cat_from_space.jpeg
Waiting for data...
Object origin received: 67d79328-f33a-4896-ba15-7b2def754f94
receiving chunks: 
Object successfully fetched
```

### Video upload

**Attention!** Without storage group files will be removed in a few minutes.
Look how to create storage [here](##Create storage group).

We also have larger file with video: `/data/cat_in_space.mp4`. Let's send 
request to the non default neofs node.

```
# You should pass CID from previous step
#
# neofs-cli object put --cid <cid> --file </path/to/file>

bash-5.0# neofs-cli --host storage01:8080 object put --cid 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi --file /data/cat_in_space.mp4
[/data/cat_in_space.mp4] Sending header...
[/data/cat_in_space.mp4] Sending data...
[/data/cat_in_space.mp4] Object successfully stored
  ID: af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
  CID: 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi
```

### Video download

#### With browser 

Use address `http://localhost:7000/<cid>/<id>` with data from previous step: 

In this example it is:
```
  ID: af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
  CID: 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi

  http://localhost:7000/3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi/af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
```

### With CLI

```
# You should pass CID and ID from previous step
#
# neofs-cli object get --cid <cid> --oid <id> --file </path/to/out/file>

bash-5.0# neofs-cli --host storage01:8080 object get --cid 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi --oid af5416a6-9fc6-4e9f-92d3-7bb7197cd41f --file /data/cat_from_space.mp4
Waiting for data...
Object origin received: af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
receiving chunks: ########
Object successfully fetched
```

## Create storage group
```
# CID: 5nSrsLLoSfT5UfCUwxYyCeHkhda2VbBLDmuoVrNqLL1n
# First file:
# ID: 67d79328-f33a-4896-ba15-7b2def754f94
# Second file:
# ID: af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
# Create storage groups for these files
#
# neofs-cli sg put --cid <cid> --oid <id1> --oid <id2>

bash-5.0# neofs-cli sg put --cid 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi --oid 67d79328-f33a-4896-ba15-7b2def754f94 --oid af5416a6-9fc6-4e9f-92d3-7bb7197cd41f
Storage group successfully stored
        ID: ab0dd79f-5f52-4846-b863-e78b5a7d84e0
        CID: 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi
```

## Manage storage group

### List created storage groups in container
```
bash-5.0# neofs-cli sg list --cid 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi
Container ID: Object ID
3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi: ab0dd79f-5f52-4846-b863-e78b5a7d84e0
```

### Get information about storage group
Storage groups are stored as objects in the NeoFS. Storage group meta
information is stored in the object header. You can obtain it with object
head request.

```
# CID: 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi
# ID: ab0dd79f-5f52-4846-b863-e78b5a7d84e0
# 
# Get data from previous step and fill command
#
# neofs-cli object head --cid <cid> --oid <id> --full-headers

bash-5.0# neofs-cli object get --cid 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi --oid ab0dd79f-5f52-4846-b863-e78b5a7d84e0 --full-headers
System headers:
  Object ID   : ab0dd79f-5f52-4846-b863-e78b5a7d84e0
  Owner ID    : AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y
  Container ID: 3FYucPGPa2NFZz3J4VTsmoeSxexLxpcwV7CJYX5Asrdi
  Payload Size: 0
  Version     : 1
  Created at  : epoch #51, 2019-10-07 16:19:09 +0000 UTC
Other headers:
  Link:<type:StorageGroup ID: 67d79328-f33a-4896-ba15-7b2def754f94 > 
  Link:<type:StorageGroup ID: af5416a6-9fc6-4e9f-92d3-7bb7197cd41f > 
  StorageGroup:<ValidationDataSize:101 ValidationHash:2ejFo82mm1AgywJcHpYsTCuazoT84tmkzFPmrtZ3y6hTbx7tcbMgzaYk8sPgUah6654G1zHEkueAW1xC1p24Wiwq > 
  Verify:<PublicKey:"..." KeySignature:"..." > 
  HomoHash:...
  PayloadChecksum:"..." 
  Integrity:<HeadersChecksum:"..." ChecksumSignature:"..." >
```


## NeoFS DropIn service

To run local copy of send.NeoFS start DropIn service.

```
$ make local_drop
```

Once it's running, you can go to [WebUI (localhost:7001)](http://localhost:7001)


## Default configuration

Environment prepared with this default config:
```
bash-5.0# env
NEOFS_CLI_KEY=/user.key
NEOFS_CLI_ADDRESS=storage10:8080
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


## Exit from NeoFS CLI

```
bash-5.0# exit
exit

$ 
```

## Stop environment

```
$ make local_down
⇒ Stop the world 
Stopping neofs-drop-nginx   ... done
Stopping neofs-drop-backend ... done
Stopping neofs-drop-ui      ... done
Stopping neofs-gw-nginx     ... done
Stopping neofs-gw-backend   ... done
Stopping neofs-storage-05   ... done
Stopping neofs-storage-10   ... done
Stopping neofs-storage-04   ... done
Stopping neofs-storage-07   ... done
Stopping neofs-storage-01   ... done
Stopping neofs-storage-09   ... done
Stopping neofs-storage-08   ... done
Stopping neofs-storage-06   ... done
Stopping neofs-storage-03   ... done
Stopping neofs-storage-02   ... done
Stopping neofs-ir-03        ... done
Stopping neofs-ir-04        ... done
Stopping neofs-ir-01        ... done
Stopping neofs-ir-02        ... done
Stopping neofs-grafana      ... done
Stopping neofs-prometheus   ... done
```
