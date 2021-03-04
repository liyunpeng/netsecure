子仓库版本号， 没有更新导致 actor Getcode在旧的子仓库找不到

接口报invalid toc错误：

![-w732](media/16148458286975.jpg)

```
ChainInfo git:(filscan-msg) ✗ git status .
位于分支 filscan-msg
尚未暂存以备提交的变更：
  （使用 "git add <文件>..." 更新要提交的内容）
  （使用 "git restore <文件>..." 丢弃工作区的改动）
  （提交或丢弃子模组中未跟踪或修改的内容）
	修改：     extern/ChainSyncer (新提交, 未跟踪的内容)

➜  ChainInfo git:(filscan-msg) ✗ git diff extern/ChainSyncer
diff --git a/extern/ChainSyncer b/extern/ChainSyncer
index db065f4c..cad23205 160000
--- a/extern/ChainSyncer
+++ b/extern/ChainSyncer
@@ -1 +1 @@
-Subproject commit cad232053fb8bcdbd75f372829cacd38d79ab8a6
+Subproject commit db065f4c4c4c53114b5b654ee975d7139jsidjod-dirty
```
需要把子仓库更新到最新的版本号， 与做这个仓库代码的人， 确定最新的版本号， 即git log里看到的， 这里版本号为cad232053fb8bcdbd75f372829cacd38d79ab8a6, 要想把子仓库这个版本号提交上， 不是修改文件， 要需要到子仓库目录，git checkout 版本号 得到的。 

### 出现dirty，和解决办法
```shell
➜  ChainInfo git:(filscan-msg) ✗ cd extern 
➜  ChainInfo git:(filscan-msg) ✗ rm -rf extern

➜  ChainInfo git:(filscan-msg) ✗ git submodule update --init --recursive
子模组路径 'extern/ChainSyncer'：检出 'db065f4c4c4c53114b5b654ee975d713950379c9'
fatal: 无法访问 'https://github.com/filecoin-project/filecoin-ffi.git/'：Failed to connect to github.com port 443: Operation timed out
无法在子模组路径 'extern/ChainSyncer/extern/filecoin-ffi' 中获取，尝试直接获取 b6e0b35fb49ed0fedb6a6a473b222e3b8a7d7f17：
remote: Enumerating objects: 7, done.
remote: Counting objects: 100% (7/7), done.
remote: Total 9 (delta 7), reused 7 (delta 7), pack-reused 2
展开对象中: 100% (9/9), 3.18 KiB | 171.00 KiB/s, 完成.
来自 https://github.com/filecoin-project/filecoin-ffi
 * branch            b6e0b35fb49ed0fedb6a6a473b222e3b8a7d7f17 -> FETCH_HEAD
子模组路径 'extern/ChainSyncer/extern/filecoin-ffi'：检出 'b6e0b35fb49ed0fedb6a6a473b222e3b8a7d7f17'
子模组路径 'extern/ChainSyncer/extern/serialization-vectors'：检出 '5bfb928910b01ac8b940a693af2884f7f8276211'
子模组路径 'extern/ChainSyncer/extern/test-vectors'：检出 'd9a75a7873aee0db28b87e3970d2ea16a2f37c6a'
子模组路径 'extern/ChainSyncer/extern/test-vectors/gen/extern/fil-blst'：检出 '5f93488fc0dbfb450f2355269f18fc67010d59bb'
子模组路径 'extern/ChainSyncer/extern/test-vectors/gen/extern/filecoin-ffi'：检出 'f640612a1a1f7a2dd8b3a49e1531db0aa0f63447'
这时extern下又有了代码仓库， 

cd extern/ChainSyncer

git pull

git checkout db065f4c4c4c53114b5b654ee975d713950379c9

命令提示显示当前分支或定位到的点是 db065f4c4， 是版本号的前8位

➜  ChainSyncer git:(db065f4c4) cd ../.. 

git diff extern/ChainSyncer
-Subproject commit cad232053fb8bcdbd75f372829cacd38d79ab8a6
+Subproject commit db065f4c4c4c53114b5b654ee975d713950379c9
这时就可以提交了
git commit extern/ChainSyncer -m “更新子仓库版本号到db065f4c4c4c53114b5b654ee975d713950379c9. 
```