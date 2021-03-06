# How prepare NEO PrivateNetwork for using it with NeoFS Local 

## Up environment
```
→ make local_privnet
Creating network "neofs-local-net" with the default driver
Creating neofs-privnet ... done
[I 190902 13:20:24 Settings:331] Created 'Chains' directory at /root/.neopython/Chains 
[I 190902 13:20:24 LevelDBBlockchain:112] Created Blockchain DB at /root/.neopython/Chains/privnet 
[I 190902 13:20:24 NotificationDB:73] Created Notification DB At /root/.neopython/Chains/privnet_notif 
NEO cli. Type 'help' to get started


neo>
```

## Deploy smart-contracts

- open wallet in the neo-python CLI (**pass: coz**): 
```
neo> wallet open neo-privnet.wallet

[password]> ***
Opened wallet at neo-privnet.wallet
```
- deploy CGAS smart-contract (**pass: coz**)
```
neo> sc deploy /sc/cgas.avm True True True 0710 05 --fee=0.1

Please fill out the following contract details:
[Contract Name] >
[Contract Version] >
[Contract Author] >
[Contract Email] >
[Contract Description] >
Creating smart contract....

// ...

Enter your password to continue and deploy this contract
[password]> ***

// ...

Relayed Tx: d7bcfb1637f21d9e1e74858d9d78bae436eafd3513ca418aff200345ae5b7a22 
```

- deploy NeoFS smart-contract (**pass: coz**)
```
neo> sc deploy /sc/neofs_privnet.avm True True True 0710 05 --fee=0.1

Please fill out the following contract details:
[Contract Name] >
[Contract Version] >
[Contract Author] >
[Contract Email] >
[Contract Description] >

Creating smart contract....

 "hash": "0xb545c2f3beacb1a7d3d21f72b32a45f1c76a8907",
 "script": "......",

// ...

Enter your password to continue and deploy this contract
[password]> ***

// ...

Relayed Tx: ba34a9cf4b18dc50c990f501187067ec48fac8bfdf350aa181e7fb803987be39 
```
Save hash `0xb545c2f3beacb1a7d3d21f72b32a45f1c76a8907` for later.

**Wait until tx's will be approved**

## Invoke smart-contracts

- import token (**pass: coz**)
```
neo> wallet import token 0x9bcd6be0f0d2b731977640d14d7edf7a6b59ea77
// ...
added token {
    "name": "Gas as NEP5",
    "symbol": "FSGAS",
    "decimals": 8,
    "script_hash": "0x9bcd6be0f0d2b731977640d14d7edf7a6b59ea77",
    "contract_address": "AShvoCbSZ7VfRiPkVb1tEcBLiJrcbts1tt"
}
```
- invoke deploying for CGas (**pass: coz**)
```
neo> sc invoke 0x9bcd6be0f0d2b731977640d14d7edf7a6b59ea77 Deploy []

// ...

Enter your password to continue and deploy this contract
[password]> ***

// ...

Relayed Tx: 1edaca74312868d0ee5af68c49b8fcbdc60846c5446c6755987f0eb1eedad8a5 
```
- invoke deploying for NeoFS SC with public keys of inner ring nodes(**pass: coz**)

*Use previously saved hash `0xb545c2f3beacb1a7d3d21f72b32a45f1c76a8907`* for invoking Deploy.
```
neo> sc invoke 0xb545c2f3beacb1a7d3d21f72b32a45f1c76a8907 Deploy ["/dns4/master1/tcp/8080", b'03012d47e76210aec73be39ab3d186e0a40fe8d86bfa3d4fabfda57ba13b88f96a', "/dns4/master2/tcp/8080", b'02f7528ce97c9a93558efe7d4f62577aabdf771c931f54a71be6ad21e7d9cc1777', "/dns4/master3/tcp/8080", b'023e00f03a16e8707ce045eb42ee80d392451541ee510dc18e1c8befbac54d7426', "/dns4/master4/tcp/8080", b'0340750b92789821683283bcb98e32b7e032b94f267b6964613fc31a7ce5813fdd']

// ...

Enter your password to continue and deploy this contract
[password]> ***

// ...

Relayed Tx: b4569faed23f9208cada1b39e2525cc789ae40e16397003c0b2af9813c6f3162
```
- invoke deposit for NeoFS SC (**pass: coz**)
```
neo> sc invoke 0xb545c2f3beacb1a7d3d21f72b32a45f1c76a8907 Deposit [b'031a6c6fbbdf02ca351745fa86b9ba5a9452d785ac4f7fc2b7548ca2a46c4fcf4a', 1000]

// ...

Enter your password to continue and deploy this contract
[password]> ***

// ...

Relayed Tx: ef06dd1a4a42df4a624828d67fa857cbf1dafdcc4383e0faef275d3274bfa3d6 
```
- **Wait until tx's will be approved**
- exit from np-prompt
```
neo> exit

Shutting down. This may take a bit...
Closed wallet neo-privnet.wallet
```

**now we can continue** [how to](./HOWTO.md)
