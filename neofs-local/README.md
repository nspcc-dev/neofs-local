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

*You can use `holder01:8080` as host address for connection*

## Run NeoFS DropIn service

```
$ make local_drop
```

**Once it's running, you can go to [WebUI (localhost:7001)](http://localhost:7001)**
