[TOC]
### 创世节点

### sealer



### sealer验证失败的排查方向
P1 到p6都成功了， 但sealer报错了， sealer 报错日志； 
```
2020-07-03T18:33:27.178+0800    [[0m remote-sealer   remote/sealer.go:988    CommitPhase2 for sector 274 elapsed 1m30.027778071s
2020-07-03T18:33:27.191 INFO filcrypto::proofs::api > verify_seal: start
2020-07-03T18:33:27.191 INFO filecoin_proofs::api::seal > verify_seal:start
2020-07-03T18:33:27.191 INFO filcrypto::proofs::api > verify_seal: finish
2020-07-03T18:33:27.192+0800    [[0m sectors ffsm/fsm.go:212 Sector 274 update state: CommitFailed ...
2020-07-03T18:33:27.195+0800    [[0m serverapi       serverapi/serverapi.go:281      SectorEnd:{"code":0,"msg":"","data":null}

2020-07-03T18:33:27.206 INFO filcrypto::proofs::api > verify_seal: start
2020-07-03T18:33:27.206 INFO filecoin_proofs::api::seal > verify_seal:start
2020-07-03T18:33:27.206 INFO filcrypto::proofs::api > verify_seal: finish
2020-07-03T18:33:27.206+0800    [[0m        sectors ffsm/states_failed_force.go:120 checkCommit sanity check error: %!w(*xerrors.wrapError=&{verify seal 0xc00813c2c0 {[7946464 18776939 18804572]}})
2020-07-03T18:33:27.207+0800    [[0m sectors ffsm/fsm.go:145 terminal pledge sector 274
2020-07-03T18:33:27.207+0800    [[0m remote-sealer   remote/sealer.go:943    sector 274 finished ...
2020-07-03T18:33:27.213+0800    [[0m serverapi       serverapi/fstask_api.go:64      new-task res: {"code":0,"msg":"","data":null}

2020-07-03T18:33:27.214+0800    [[0m sectors ffsm/fsm.go:154 try to cleanup for termnated sector 274, err=<nil>
2020-07-03T18:33:27.214+0800    [[0m sectors ffsm/fsm.go:170 TerminateState sector 274 entered termnate state CommitFailed, pledging 55 dealing 0
2020-07-03T18:33:27.363+0800    [[0m sectors ffsm/garbage.go:55      will start another pledge sector asap, pledging 55
2020-07-03T18:33:27.371+0800    [[0m serverapi       serverapi/serverapi.go:231      NewSectorInfo:{"code":0,"msg":"","data":{"sectorID":299,"storageNodeID":1,"loc":"nfs/10.10.11.17"}}
```
verify报错的， 
seal > verify_seal:start 和 verify_seal: finish 两个log之间应该输出信息， 因为启动sealer时没加上：
RUST_LOG=trace RUST_BACKTRACE=full


p4 完成后， 会产生一些数据， 没有存在文件里， seal 会验证这些数据， 但是seal验证失败了， 所以sector的状态就变为commiteFailed了
#### 版本gap 问题
 sealer 和 forceworker 之间通过接口传送数据，不同sealer版本和forceworker版本接口是不变的， 但数据内容可能不一样，造成p4验证通过，sealer没过

1.ffi有点问题，下面的rust版本和remoteworker的rust版本有可能break change导致本地verifyseal会失败，这个更新了一下ffi之后本地就能过了
2.数据库里miner info的worker没有填上正确的t3地址，填了个cid 这个已经fix掉了新整个数据库小心点这个就好
3.同样的创始矿工和lotus程序的ffi有问题，不能正确的verify seal，这个也会导致即使本地能过也不能正确上链。
综合一下就是更新了ffi之后测试应该能顺利进行，白天你看到的那个什么cbor也是由于这边 节点不能正常的verify 所以那边epoch结束的cron不能正确的将它加入， commitfailed了

####  seal 
检查 /var/tmp下的证明参数文件对不对
build/proof_params/parameters.json  提供的 参数文件名 和 /var/tmp/fileconi_proof/下的是否相同， 一个相同， 就是对的， 数量少 hash不会彭窗








### message
#### Message的执行的结果就是状态机的全局状态
Filecoin网络中的区块是由一个个的Message组成。你可以把Message想象成以太坊的交易。  
一个Message由发起地址，目标地址，金额，调用的函数以及参数组成。  
Message的执行的结果就是状态机的全局状态。  
Filecoin网络的全局状态就是映射表：Actor的地址和Actor的状态/信息。  
以太坊的全局信息是通过leveldb数据库存储。  
Filecoin的全局状态是使用IPLD HAMT(Hash-Array Mapped Trie) 存储。
一次消息类似于以太坊的一次交易transactions

Message的定义在types/message.go中。

#### message Pool
所有的交易在节点间同步到每个节点的“Message Pool”中。
经过“Expected Consensus”共识机制，
当选为Leader的一个或者多个节点从“Message Pool”中挑选Message，并打包。  
被打包的区块，会同步给其他节点。  
打包的区块中的交易（Message）会被Filecoin虚拟机执行，更新各个Actor的状态。   
所有的区块数据，Actor的状态是通过IPFS/IPLD进行存储。


### 地址
在深入其他逻辑之前，先介绍一下Filecoin网络中的地址生成逻辑。
Filecoin的地址总共为41个字节，比如fcqphnea72vq5yynshuur33pfnnksjsn5sle75rxc。fc代表是主网，tf代表是测试网络。
 在address/constants.go文件中定义了一些参数，并预制了一些固定地址：Filecoin的铸币地址，存储市场地址，支付通道地址等等。
 

### centos编译Lotos
1 操作系统差异 
   一开始使用的是亚马逊的虚拟机来编译，系统是amzn2.x86_64，不是centos。导致编译环境的依赖项装不上
2 openCL 依赖
   这个问题 通过执行 yum install epel-release （波波提供的方法）来解决
3 golang版本
   为了方便就用yum install go 来安装go, 这样安装的版本现在是1.13.13。可以完成编译，生成的lotus等二进制文件也可用。但是在做私链时，lotus 起不来，报错说不能创建lp2p的host。
   后来把go卸载了 装上1.14.3版后重新编译后，运行正常
Lotus
Lotus is an implementation of the Filecoin Distributed Storage Network. A Lotus node syncs blockchains that follow the Filecoin protocol, validating the blocks and state transitions. The specification for the Filecoin protocol can be found here.

For information on how to setup and operate a Lotus node, please follow the instructions here.

Components
At a high level, a Lotus node comprises the following components:
包括以下组件：

FIXME: No mention of block production here, cross-reference with schomatis's miner doc

### P2P
P2P stuff (FIXME missing libp2p listed under other PL dependencies)? allows hello, blocksync, retrieval, storage
libp2p 协议实现： 
node/hello/hello:  节点之间的互联


### api cli
API / CLI 
api/client/client.go 注册api jsonrpc服务




### Tipsets


#### 一个区块的信息主要包括：

打包者的地址信息

区块的高度/权重信息

区块中包括的交易信息/更新后新的Root信息

Ticket信息以及Ticket的PoSt的证明信息

一个Tip，就是一个区块。一个TipSet，就是多个区块信息的集合，这些区块拥有同一个父亲区块。所谓的TipSet，就是一个区块的多个子区块，定义在types/tipset.go文件中：

#### 链的权重
一个长的链可能比一个短的链的权重小， 因为短的链， 可能每个tipset容纳了更多的块. 

允许空的tipsets,  
链上最重的tipset叫做链的头

#### tipset 的生成
Filecoin的共识算法叫Expected Consensus，简称EC共识机制。  
Expected Consensus实现的相关代码在consensus目录。  
除了区块链数据外，Expected Consensus每一轮会生成一个Ticket，每个节点通过一定的计算，确定是否是该轮的Leader。  
如果选为Leader，节点可以打包区块。也就是说，每一轮可能没有Leader（所有节点都不符合Leader的条件），或者多个Leader（有多个节点符合Leader）。
Filecoin使用TipSet的概念，表明一轮中多个Leader产生的指向同一个父亲区块的区块集合。

下一轮的Ticket是通过前一轮的区块的Proof以及节点的地址的Hash计算的结果，具体看consensus/expected.go中的CreateTicket函数。

#### Leader的选择：
在每个Ticket生成的基础上，进行Leader的选择，具体查看consensus/expected.go中的IsWinningTicket函数。  
也就是说，如果Ticket的数值小于当前节点的有效存储的比例的话，该节点在该轮就是Leader。


#### Weight的计算：


### Actors
#### actor内容
每个Actor有自己的地址，余额，也可以维护自己的状态。
同时Actor提供一些函数调用（也正是这些函数调用触发Actor的状态变化）。
Filecoin的状态机，包括了所有Actor的状态。

Actor内部包括：账户信息（Balance），类型（Code），以及序号（Nonce）。
Actor的定义在actor/actor.go中。

actor类似于以太坊的智能合约

filecoin不允许用户自己定义actor,  但是可以选择内建的actor, 这些actor可以理解为事先编译好的和约。 

#### gas费用
执行Actor的函数需要消耗Gas。Actor的函数调用有两种方式：
1/ 用户发起签名后的Message（指定调用某个Actor的某个函数），并支付矿工Gas费用（类似以太坊的Gas费用）。
2/ Actor之间调用。Actor之间调用也必须是用户发起。


### 同步器
The Syncer, which manages the process of syncing the blockchain
同步器：  管理区块链的同步过程
chain/sync.go. syncer类负责链同步


Sync

lotus节点会监控他所peer到的不同的链，  选择其中权重最重的一个链，  请求选定链上的块， 验证链上的每一个块，  同时运行状态转换。 

同步的大多数工作 在syncer完成， 内部由syncmanager管理



We now discuss the various stages of the sync process.
#### 同步的不同阶段
#### 1。 Sync setup

When a Lotus node connects to a new peer, we exchange the head of our chain with the new peer through the hello protocol. If the peer's head is heavier than ours, we try to sync to it. Note that we do NOT update our chain head at this stage.
一个Lotus链接到一个新的peer时， 通过Hello协议，将本地链的头和新的peer的头交换信息， 如果新的Peer的头比本地链的头重， 就会同步这个peer. 在这个阶段， 不会更新本地链的头。 

#### 2. 获取并持久化链的头部
Fetching and Persisting Block Headers

Note: The API refers to these stages as StageHeaders and StagePersistHeaders.
与这个阶段相关的api为StageHeaders和StagePersistHeaders。 

We proceed in the sync process by requesting block headers from the peer, moving back from their head, until we reach a tipset that we have in common (such a common tipset must exist, thought it may simply be the genesis block). The functionality can be found in Syncer::collectHeaders().
同步的过程为： 请求获取peer的head， 在peer上，从这个head不断往后移， 一直找到与本地链相同的tipset相同的位置， 这个tipset必须存在， 即使是创世块genesis. 


If the common tipset is our head, we treat the sync as a "fast-forward", else we must drop part of our chain to connect to the peer's head (referred to as "forking").

如果这个相同的tipset是本地链的head,  同步就可以直接向前推进， 即fast-forward,  如果不是， 就必须删除本地链中和相同tipset相同这一段之前的所有的快， 以避免分叉。 

FIXME: This next para might be best replaced with a link to the validation doc Some of the possible causes of failure in this stage include:

The chain is linked to a block that we have previously marked as bad, and stored in a BadBlockCache.

The beacon entries in a block are inconsistent (FIXME: more details about what is validated here wouldn't be bad).
Switching to this new chain would involve a chain reorganization beyond the allowed threshold (SPECK-CHECK).

##### 3. 获取并验证块的阶段

与这个阶段相关的api为StageMessages

Having acquired the headers and found a common tipset, we then move forward, requesting the full blocks, including the messages.
找到了相同的tipset, 下一步就是请求获取全部的块

For each block, we first confirm the syntactic validity of the block (SPECK-CHECK), which includes the syntactic validity of messages included in the block. We then apply the messages, running all the state transitions, and compare the state root we calculate with the provided state root.
对于每一个快， 都要对块做合法性检查， 然后就发布消息， 这些消息会使状态撞扁。 

你给我出了个难题


FIXME: This next para might be best replaced with a link to the validation doc Some of the possible causes of failure in this stage include:

a block is syntactically invalid (including potentially containing syntactically invalid messages)
the computed state root after applying the block doesn't match the block's state root
FIXME: Check what's covered by syntactic validity, and add anything important that isn't (like proof validity, future checks, etc.)
The core functionality can be found in Syncer::ValidateTipset(), with Syncer::checkBlockMessages() performing syntactic validation of messages.

这个阶段失败的可能原因： 
没通过块的合法性检查， 
发布消息后，计算出的状态根没有和块的状态根匹配上

Syncer::checkBlockMessages() 对消息块检查， 核心函数是Syncer::ValidateTipset()

#### 4. Setting the head

Note: The API refers to this stage as StageSyncComplete.
与这个阶段相关的api是StageSyncComplete

If all validations pass we will now set that head as our heaviest tipset in ChainStore. We already have the full state, since we calculated it during the sync process.

如果验证通过了， 设置head为最重的tipset.  

FIXME (aayush) I don't fuilly understand the next 2 paragraphs, but it seems important. Confirm and polish. Relevant issue in IPFS: https://github.com/ipfs/ipfs-docs/issues/264

It is important to note at this point that similar to the IPFS architecture of addressing by content and not by location/address (FIXME: check and link to IPFS docs) the "actual" chain stored in the node repo is relative to which CID we look for. 
通过内容寻址， 而不是通过地址或位置寻址。 

We always have stored a series of Filecoin blocks pointing to other blocks, each a potential chain in itself by following its parent's reference, and its parent's parent, and so on up to the genesis block. (FIXME: We need a diagram here, one of the Filecoin blog entries might have something similar to what we are describing here.) It only depends on where (location) do we start to look for. The only address/location reference we hold of the chain, a relative reference, is the heaviest pointer. This is reflected by the fact that we don't store it in the Blockstore by a fixed, absolute, CID that reflects its contents, as this will change each time we sync to a new head (FIXME: link to the immutability IPFS doc that I need to write).

在blockstore不会存储 固定的，绝对的cid. 因为每次同步到新的head时，都会改变

FIXME: Create a further reading appendix, move this next para to it, along with other extraneous content This is one of the few items we store in Datastore by key, location, allowing its contents to change on every sync. This is reflected in the (*ChainStore) writeHead() function (called by takeHeaviestTipSet() above) where we reference the pointer by the explicit chainHeadKey address (the string "head", not a hash embedded in a CID), and similarly in (*ChainStore).Load() when we start the node and create the ChainStore. Compare this to a Filecoin block or message which are immutable, stored in the Blockstore by CID, once created they never change.

允许他的内容， 在每次同步之后后会改变， 
这个在(*ChainStore) writeHead() 里可以看到.


#### 5. Keeping up with the chain
如果我们验证了块的父tipset， 把这个块增加到tipset, 会形成一个更重的块， 这样我们验证并添加一个快， 



### State
Filecoin的状态机，主要是维护如下一些状态信息：支付情况，存储市场情况，各个节点的Power（算力）等等。

状态管理器：  根据链的给定状态，计算出下一个状态。 

In Filecoin, the chain state at any given point is a collection of data stored under a root CID encapsulated in the StateTree, and accessed through the StateManager. The state at the chain's head is thus easily tracked and updated in a state root CID. (FIXME: Talk about CIDs somewhere, we might want to explain some of the modify/flush/update-root mechanism here.))

根的cid, 会封装在状态树里， 通过statemanager来访问 
连的头部的状态可以很容易被更总， 并且在状态根cid得到更新。 




#### 1. Calculating a Tipset State

Recall that a tipset is a set of blocks that have identical parents (that is, that are built on top of the same tipset). The genesis tipset comprises the genesis block(s), and has some state corresponding to it.

The methods TipSetState() and computeTipSetState() in StateManager are responsible for computing the state that results from applying a tipset. This involves applying all the messages included in the tipset, and performing implicit operations like awarding block rewards.
StateManager 里的TipSetState和computeTipSetState 用来计算 在施加消息后， tipset的状态变化， 这会消费掉tipset的所有消息， 并且分配奖励的隐士操作。 



Any valid block built on top of a tipset ts should have its Parent State Root equal to the result of calculating the tipset state of ts. 
在tipset上的状态根， 应该和计算出的状态根相等。 

Note that this means that all blocks in a tipset must have the same Parent State Root (which is to be expected, since they have the same parent tipset)



#### 2. Preparing to apply a tipset

When StateManager::computeTipsetState() is called with a tipset, ts, it retrieves the parent state root of the blocks in ts. It also creates a list of BlockMessages, which wraps the BLS and SecP messages in a block along with the miner that produced the block.

Control then flows to StateManager::ApplyBlocks(), which builds a VM to apply the messages given to it. The VM is initialized with the parent state root of the blocks in ts. We apply the blocks in ts in order (see FIXME for ordering of blocks in a tipset).




#### 3.  Applying a block

For each block, we prepare to apply the ordered messages (first BLS, then SecP). Before applying a message, we check if we have already applied a message with that CID within the scope of this method. If so, we simply skip that message; this is how duplicate messages included in the same tipset are skipped (with only the miner of the "first" block to include the message getting the reward). For the actual process of message application, see FIXME (need an internal link here), for now we simply assume that the outcome of the VM applying a message is either an error, or a MessageReceipt and some other information.

We treat an error from the VM as a showstopper; there is no recovery, and no meaningful state can be computed for ts. Given a successful receipt, we add the rewards and penalties to what the miner has earned so far. Once all the messages included in a block have been applied (or skipped if they're a duplicate), we use an implicit message to call the Reward Actor. This awards the miner their reward for having won a block, and also awards / penalizes them based on the message rewards and penalties we tracked.

We then proceed to apply the next block in ts, using the same VM. This means that the state changes that result from applying a message are visible when applying all subsequent messages, even if they are included in a different block.

##### 4. Finishing up

Having applied all the blocks, we send one more implicit message, to the Cron Actor, which handles operations that must be performed at the end of every epoch (see FIXME for more). The resulting state after calling the Cron Actor is the computed state of the tipset.

### Virtual Machine

在Filecoin虚拟机执行具体某个Message的时候（Actor的某个Method），会准备VMContext，提供Actor的执行环境：


Filecoin虚拟机相关的代码在vm的目录下。所有的区块数据以及Actor状态数据存储是通过IPFS/IPLD实现。



The Virtual Machine (VM) is responsible for executing messages. 


The Lotus Virtual Machine invokes the appropriate methods in the builtin actors, 
and provides a Runtime interface to the builtin actors that exposes their state, 
allows them to take certain actions, and meters their gas usage. 
The VM also performs balance transfers, creates new account actors as needed, 
and tracks the gas reward, penalty, return value, and exit code.

The Virtual Machine (VM), which executes messages
The Repository, where all data is stored

所有的数据保存在一个仓库里， 执行传送到这个仓库的消息
chain/vm/vm.go.   虚拟机执行消息
#### 虚拟机提供的函数

Message（）函数提供了当前交易Message的信息

BlockHeight（）函数提供了当前区块高度信息

Stoage/ReadStorage/WriteStorage提供对当前目标地址的存储访问信息

Charge()函数提供油费耗费的调用

CreateNewActor/AddressForNewActor/IsFromAcccountActor函数提供了对Actor地址的创建以及基本查询功能

Rand函数提供了随机数能力

Send函数提供了调用其他Actor函数的能力


#### 1. Applying a Message

The primary entrypoint of the VM is the ApplyMessage() method. This method should not return an error unless something goes unrecoverably wrong.

The first thing this method does is assess if the message provided meets any of the penalty criteria. If so, a penalty is issued, and the method returns. Next, the entire gas cost of the message is transferred to a temporary gas holder account. It is from this gas holder that gas will be deducted; if it runs out of gas, the message fails. Any unused gas in this holder will be refunded to the message's sender at the end of message execution.

The VM then increments the sender's nonce, takes a snapshot of the state, and invokes VM::send().

The send() method creates a Runtime for the subsequent message execution. It then transfers the message's value to the recipient, creating a new account actor if needed.

#### 2. Method Invocation

We use reflection to translate a Filecoin message for the VM to an actual Go function, relying on the VM's invoker structure. Each actor has its own set of codes defined in specs-actors/actors/builtin/methods.go. The invoker structure maps the builtin actors' CIDs to a list of invokeFunc (one per exported method), which each take the Runtime (for state manipulation) and the serialized input parameters.

FIXME (aayush) Polish this next para.

The basic layout (without reflection details) of (*invoker).transform() is as follows. From each actor registered in NewInvoker() we take its Exports() methods converting them to invokeFuncs. The actual method is wrapped in another function that takes care of decoding the serialized parameters and the runtime, this function is passed to shimCall() that will encapsulate the actors code being run inside a defer function to recover() from panics (we fail in the actors code with panics to unwrap the stack). The return values will then be (CBOR) marshaled and returned to the VM.

#### 3. Returning from the VM

Once method invocation is complete (including any subcalls), we return to ApplyMessage(), which receives the serialized response and the ActorError. The sender will be charged the appropriate amount of gas for the returned response, which gets put into the MessageReceipt.

The method then refunds any unused gas to the sender, sets up the gas reward for the miner, and wraps all of this into an ApplyRet, which is returned.

### Building a Lotus node
When we launch a Lotus node with the command ./lotus daemon (see here for more), the node is created through dependency injection. This relies on reflection, which makes some of the references hard to follow. The node sets up all of the subsystems it needs to run, such as the repository, the network connections, thechain sync service, etc. This setup is orchestrated through calls to the node.Override function. The structure of each call indicates the type of component it will set up (many defined in node/modules/dtypes/), and the function that will provide it. The dependency is implicit in the argument of the provider function.

当启动一个lotus节点时，lotus daemon, 这个节点通过依赖注入来创建。 

lotus节点的创建会运行他所需要的所有子系统， 包括：
仓库， 
网络连接， 
链同步服务， 

As an example, consider the modules.ChainStore() function that provides the ChainStore structure. It takes as one of its parameters the ChainBlockstore type, which becomes one of its dependencies. For the node to be built successfully the ChainBlockstore will need to be provided before ChainStore, a requirement that is made explicit in another Override() call that sets the provider of that type as the ChainBlockstore() function.
modules.ChainStore()  

modules.ChainStore()  提供了ChainStore结构， 


### 1. The Repository

The repo is the directory where all of a node's information is stored. The node is entirely defined by its repo, which makes it easy to port to another location. This one-to-one relationship means we can speak of the node as the repo it is associated with, instead of the daemon process that runs from that repo.

Only one daemon can run be running with an associated repo at a time. A process signals that it is running a node associated with a particular repo, by creating and acquiring a repo.lock.

```
lsof ~/.lotus/repo.lock
# COMMAND   PID
# lotus   52356
```

Trying to launch a second daemon hooked to the same repo leads to a repo is already locked (lotus daemon already running) error.

The node.Repo() function (node/builder.go) contains most of the dependencies (specified as Override() calls) needed to properly set up the node's repo. We list the most salient ones here.

#### 1.1 Datastore

Datastore and ChainBlockstore: Data related to the node state is saved in the repo's Datastore, an IPFS interface defined here. Lotus creates this interface from a Badger DB in FsRepo. Every piece of data is fundamentally a key-value pair in the datastore directory of the repo. There are several abstractions laid on top of it that appear through the code depending on how we access it, but it is important to remember that we're always accessing it from the same place.

FIXME: Maybe mention the Batching interface as the developer will stumble upon it before reaching the Datastore one.

#### 1.2 Blocks

FIXME: IPFS blocks vs Filecoin blocks ideally happens before this / here




The Blockstore interface structures the key-value pair into the CID format for the key and the Block interface for the value. The Block value is just a raw string of bytes addressed by its hash, which is included in the CID key.



ChainBlockstore creates a Blockstore in the repo under the /blocks namespace. Every key stored there will have the blocks prefix so that it does not collide with other stores that use the same repo.

FIXME: Link to IPFS documentation about DAG, CID, and related, especially we need a diagram that shows how do we wrap each datastore inside the next layer (datastore, batching, block store, gc, etc).

Metadata

modules.Datastore() creates a dtypes.MetadataDS, which is an alias for the basic Datastore interface. Metadata is stored here under the /metadata prefix. (FIXME: Explain what is metadata in contrast with the block store, namely we store the pointer to the heaviest chain, we might just link to that unwritten section here later.)

FIXME: Explain the key store related calls (maybe remove, per Schomatis)

LockedRepo

LockedRepo(): This method doesn't create or initialize any new structures, but rather registers an OnStop hook that will close the locked repository associated with it on shutdown.

Repo types / Node types

FIXME: This section needs to be clarified / corrected...I don't fully understand the config differences (what do they have in common, if anything?)

At the end of the Repo() function we see two mutually exclusive configuration calls based on the RepoType (node/repo/fsrepo.go).

			ApplyIf(isType(repo.FullNode), ConfigFullNode(c)),
			ApplyIf(isType(repo.StorageMiner), ConfigStorageMiner(c)),
As we said, the repo fully identifies the node so a repo type is also a node type, in this case a full node or a storage miner. (FIXME: What is the difference between the two, does full imply miner?) In this case the daemon command will create a FullNode, this is specified in the command logic itself in main.DaemonCmd(), the FsRepo created (and passed to node.Repo()) will be initiated with that type (see (*FsRepo).Init(t RepoType)).

Online

FIXME: Much of this might need to be subsumed into the p2p section

The node.Online() configuration function (node/builder.go) initializes components that involve connecting to, or interacting with, the Filecoin network. These connections are managed through the libp2p stack (FIXME link to this section when it exists). We discuss some of the components found in the full node type (that is, included in the ApplyIf(isType(repo.FullNode), call).

Chainstore

modules.ChainStore() creates the store.ChainStore) that wraps the stores previously instantiated in Repo(). It is the main point of entry for the node to all chain-related data (FIXME: this is incorrect, we sometimes access its underlying block store directly, and probably shouldn't). It also holds the crucial heaviest pointer, which indicates the current head of the chain.

ChainExchange and ChainBlockservice

ChainExchange() and ChainBlockservice() establish a BitSwap connection (FIXME libp2p link) to exchange chain information in the form of blocks.Blocks stored in the repo. (See sync section for more details, the Filecoin blocks and messages are backed by these raw IPFS blocks that together form the different structures that define the state of the current/heaviest chain.)

Incoming handlers

HandleIncomingBlocks() and HandleIncomingMessages() start the services in charge of processing new Filecoin blocks and messages from the network (see <undefined> for more information about the topics the node is subscribed to, FIXME: should that be part of the libp2p section or should we expand on gossipsub separately?).

Hello

RunHello(): starts the services to both send ((*Service).SayHello()) and receive ((*Service).HandleStream(), node/hello/hello.go) hello messages. When nodes establish a new connection with each other, they exchange these messages to share chain-related information (namely their genesis block and their heaviest tipset).

Syncer

NewSyncer() creates the Syncer structure and starts the services related to the chain sync process (FIXME link).

Ordering the dependencies

We can establish the dependency relations by looking at the parameters that each function needs and by understanding the architecture of the node and how the different components relate to each other (the chief purpose of this document).

As an example, the sync mechanism depends on the node being able to exchange different IPFS blocks with the network, so as to be able to request the "missing pieces" needed to construct the chain. This dependency is reflected by NewSyncer() having a blocksync.BlockSync parameter, which in turn depends on ChainBlockservice() and ChainExchange(). The chain exchange service further depends on the chain store to save and retrieve chain data, which is reflected in ChainExchange() having ChainGCBlockstore as a parameter (which is just a wrapper around ChainBlockstore capable of garbage collection).

This block store is the same store underlying the chain store, which is an indirect dependency of NewSyncer() (through the StateManager). (FIXME: This last line is flaky, we need to resolve the hierarchy better, we sometimes refer to the chain store and sometimes to its underlying block store. We need a diagram to visualize all the different components just mentioned otherwise it is too hard to follow. We probably even need to skip some of the connections mentioned.)