# NeoFS local

[**Go to main**](../README.md)

## Keys folder
*Contains pregenerated private keys for IR nodes*

## FAQ:

### Configuration

**Increase default upload file size limit:**

It is set in `.env` by `NEOFS_OBJECT_MAX_PROCESSING_SIZE` (**300MB** by default).
You can override this value.

### Run environment

```
$ make local_up
```

### Stop environment

```
$ make local_down
```

### Run NeoFS cli

```
$ make local_cli
```

*You can use `storage01:8080` as host address for connection*

## Run NeoFS DropIn service

```
$ make local_drop
```

**Once it's running, you can go to [WebUI (localhost:7001)](http://localhost:7001)**

## Run NeoFS S3 gate based on minio

S3 gate implemented as minio gateway. It has some neofs-specific limitations. 
You cannot create or delete s3 buckets because they are mapped to neofs containers.
To manage buckets use neofs-cli application. You can access objects within 
created neofs containers. 

Gateway sends requests to host `storage01:8080`.

```
$ make local_minio
```

**Minio gateway available at [localhost:9001](http://localhost:9001)**


Use wallet address as `AccessKey` and WIF as `SecretKey`. Default neofs-local user:
```
AccessKey = AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y
SecretKey = KxDgvEKzgSBPPfuVfw67oPQBSjidEiqTHURKSDL1R7yGaGYAeYnr
```
