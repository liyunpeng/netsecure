指导文件： https://www.cnblogs.com/sparkdev/p/10369313.html

### 一. 准备好前提条件，这里为创建好需要的目录
需要创建的目标目录：
```
rootca
rootca/certs/           # 存放新建的证书
rootca/db/              # spenssl 用来存放信息的目录
rootca/private/         # 存放私钥
rootca/crl/                                 
rootca/csr/             # csr是certificate signing request表示存放的是证书签名请求文件
rootca/newcerts/
rootca/db/index
rootca/db/serial
rootca/db/crlnumber
```
用脚本createOpensslDir.sh完成以上目录的创建：

Filscan 钱包消息接口增加args字段
Forcepool 用户服务条款 增加对新注册用户逻辑处理， 完善用户表搜索
Forcepool 排查某个用户重复打款问题




```
$ cat createOpensslDir.sh
#!/bin/bash
# create rootca dir certs db private crl newcerts under rootca dir
if [ ! -d rootca ]; then
    mkdir -p rootca
fi
if [ ! -d rootca/certs ]; then
    mkdir -p rootca/certs
fi
if [ ! -d rootca/csr ]; then
    mkdir -p rootca/csr
fi
if [ ! -d rootca/db ]; then
    mkdir -p rootca/db
    touch rootca/db/index
    openssl rand -hex 16 > rootca/db/serial
    echo 1001 > rootca/db/crlnumber
fi
if [ ! -d rootca/private ]; then
    mkdir -p rootca/private
    chmod 700 rootca/private
fi
if [ ! -d rootca/crl ]; then
    mkdir -p rootca/crl
fi
if [ ! -d rootca/newcerts ]; then
    mkdir -p rootca/newcerts
fi

```
执行命令， 查看结果
```
$ ./createOpensslDir.sh  

$ ls *   
createOpensslDir.sh

rootca:
certs csr crl  db  newcerts  private  rootca.cnf 
```
---
### 二. 创建rootca.cnf配置文件
```
$ cat rootca.cnf
# OpenSSL root CA configuration file.
# v1
[ ca ]
# `man ca`
default_ca = CA_default
[ CA_default ]
# Directory and file locations.
dir = /home/lwx838779/nick/out/empty/ca2/rootca
certs = $dir/certs
crl_dir = $dir/crl
new_certs_dir = $dir/newcerts
database = $dir/db/index
serial = $dir/db/serial
RANDFILE = $dir/private/random
# The root key and root certificate.
private_key = $dir/private/rootca.key.pem
certificate = $dir/certs/rootca.cert.pem
# For certificate revocation lists.
crlnumber = $dir/db/crlnumber
crl = $dir/crl/rootca.crl.pem
crl_extensions = crl_ext
default_crl_days = 30
# SHA-1 is deprecated, so use SHA-2 instead.
default_md = sha256
name_opt = ca_default
cert_opt = ca_default
default_days = 3750
preserve = no
policy = policy_strict
[ policy_strict ]
# The root CA should only sign intermediate certificates that match.
# See the POLICY FORMAT section of `man ca`.
countryName = match
stateOrProvinceName = match
organizationName = match
organizationalUnitName = optional
commonName = supplied
emailAddress = optional
[ req ]
# Options for the `req` tool (`man req`).
# Optionally, specify some defaults.
prompt = no
input_password = 123456

default_bits = 2048
distinguished_name = req_distinguished_name
string_mask = utf8only
# SHA-1 is deprecated, so use SHA-2 instead.
default_md = sha256
# Extension to add when the -x509 option is used.
# make sure use x509_extensions, do not use req_extensions.
x509_extensions = v3_ca
# use the req_extensions not work.
#req_extensions = v3_ca
[ req_distinguished_name ]
# See <https://en.wikipedia.org/wiki/Certificate_signing_request>.
countryName = CN
stateOrProvinceName = ShaanXi
localityName = Xian
organizationName = NickLi Ltd
organizationalUnitName = NickLi Ltd CA
commonName = NickLi Root CA
emailAddress = ljfpower@163.com
[ v3_ca ]
# Extensions for a typical CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
[ v3_intermediate_ca ]
# Extensions for a typical intermediate CA (`man x509v3_config`).
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints = critical, CA:true, pathlen:0
keyUsage = critical, digitalSignature, cRLSign, keyCertSign
[ crl_ext ]
# Extension for CRLs (`man x509v3_config`).
authorityKeyIdentifier=keyid:always
[ ocsp ]
# Extension for OCSP signing certificates (`man ocsp`).
basicConstraints = CA:FALSE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
keyUsage = critical, digitalSignature
extendedKeyUsage = critical, OCSPSigning
```

---
### 三. 创建root私钥
```
$ cd rootca
$ openssl genrsa -aes256 -out private/rootca.key.pem 4096
Generating RSA private key, 4096 bit long modulus
.........................++
...............................................++
e is 65537 (0x10001)
Enter pass phrase for private/rootca.key.pem:  输入123456 即设置一个密码， 用这个私钥去生成公钥或证书时，要用到这个密码
Verifying - Enter pass phrase for private/rootca.key.pem:  重复输入123456 确认
```
命令参数解释：   
* genrsa 表示生成rsa私钥，
* -aes256表示对私钥用aes256进行加密。  
理解一下加密算法，
* rsa是非对称加密， 即加解密用的钥匙不一样。rsa用时较多
* aes是对称加密， 即加密和解密的钥匙相同。 aes是des的改进， des在早期加解密使用，因为容易破解，已经被aes取代，des和aes都是对称加密，
   

查看结果：
```        
$ cat private/rootca.key.pem
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-256-CBC,DA8E0F08E733FD9B2C007453590759D7
省略中间大段字符串
-----END RSA PRIVATE KEY-----
```
---
### 四. 用rootca.cnf配置文件创建根证书请求文件 
根证书请求文件英文名为Certificate Signing Requests(csr) 
#### 生成pem格式的证书请求文件
```
$ openssl req -new -config rootca.cnf -sha256 -key private/rootca.key.pem -out csr/rootca.csr.pem
```
命令参数解释, 因为使用了配置文件，命令中省去了很多参数。 
  * req -new 表示生成的请求文件。  
  * 因为rootca.cnf指定了： 
```
x509_extensions = v3_ca
```  
所以命令不需写-x509，请求的证书也是x509格式，  
>解释下x509，x509标准规定了证书需要包括的信息和信息的格式。  
>具体x509格式的证书要包括以下内容：  
>版本号（integer）、序列号（integer）、签名算法（object）、  
>颁布者（set）、有效期（utc_time）、主体（set）、主体公钥（bit_string）、
>主体公钥算法（object）、签名值（bit_string）。

  * 因为rootca.cnf指定了：  
```  
default_days = 3750
```  
所以命令中不需写-days 3750， 证书的有效期为3750天， k8s的证书设置356天，k8s的证书也是这个参数。

   * 因为rootca.cnf里有这些内容：
```
[ req_distinguished_name ]
countryName = CN
stateOrProvinceName = ShaanXi
localityName = Xian
organizationName = NickLi Ltd
organizationalUnitName = NickLi Ltd CA
commonName = NickLi Root CA
emailAddress = ljfpower@163.com
```
所以就不需要手动输入国家名，城市，公司名，用户名，邮箱等证书需要的用户信息。   

#### 查看生成的证书请求文件的内容
查看生成的证书请求文件rootca.csr.pem具体内容，就是最后证书的实际内容，请求代表预演一下。
```
$ openssl req -text -noout -in csr/rootca.csr.pem
Certificate Request:
    Data:
        Version: 0 (0x0)
        Subject: C=CN, ST=ShaanXi, L=Xian, O=NickLi Ltd, OU=NickLi Ltd CA, CN=NickLi Root CA/emailAddress=ljfpower@163.com
        # 以上是主体用户信息，在openssl生成证书请求时，要么手动输入，要么配置文件指定
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (4096 bit)   #即1024个字节， RSA公钥必须是1024个字节，想要破解这1024字节，据说要万年以上的时间
                Modulus:  公钥，证书请求文件里的公钥，和由此请求文件生成的证书中的公钥是相同的
                    00:a5:4e:29:6b:8d:1e:c9:d9:2c:7c:a9:2d:25:5f:
                    1b:d1:ae:fd:56:fd:dd:55:26:b9:37:ee:0c:f9:4a:
                    06:63:b2:7a:0f:4d:75:3d:b1:8d:83:3e:a8:71:cb:
                    cf:03:7b:30:26:6d:8f:0e:3b:93:21:af:94:d7:d7:
                    b0:70:0f:f8:78:01:44:84:26:29:70:16:b9:87:b6:
                    6b:dc:ad:0a:8c:f3:c6:b0:f3:d3:8a:83:f9:cb:39:
                    ba:83:ed:60:6c:40:cd:a1:12:9b:1d:53:a2:21:3f:
                    24:32:51:f3:8d:31:66:36:2b:6a:be:6f:94:f3:ae:
                    b4:ea:a3:fb:87:98:7c:f7:3e:ff:29:36:a3:0f:ba:
                    c1:db:b4:a3:1a:26:e3:ae:99:33:49:6a:bc:71:4d:
                    d2:f3:67:d2:b0:30:60:9e:d6:f8:b1:7e:c7:23:f5:
                    ce:06:c5:b8:67:8f:ac:ce:26:dd:4e:e0:6d:4f:81:
                    34:94:b0:f9:93:d4:b1:a0:53:d7:16:ab:ff:84:0e:
                    84:5e:5c:bf:f7:ba:20:7d:50:09:29:dd:cc:fe:c0:
                    3d:4f:24:81:73:49:ef:9c:86:41:42:0d:13:f2:a3:
                    93:8e:43:a2:51:12:a6:0c:68:ea:95:85:3c:f4:dd:
                    ec:1a:96:72:17:54:d3:12:a0:04:68:a0:c5:b0:86:
                    12:92:a6:77:e9:67:eb:ff:71:45:27:11:48:2c:54:
                    66:c1:f2:cc:78:5b:c6:14:c7:d3:3e:48:98:26:92:
                    97:38:91:c7:9b:1b:f6:8c:aa:35:b8:1c:9d:c9:8a:
                    be:67:11:b1:b1:84:f2:54:2a:9d:e2:da:9c:c9:04:
                    13:a8:c6:4e:92:cf:3d:a6:f0:62:91:ac:6f:65:64:
                    b8:9f:08:fb:85:d3:b8:d9:91:4b:74:fc:60:18:9e:
                    f4:06:3d:8f:4a:81:16:2f:79:fa:bd:3f:41:44:54:
                    fc:db:0a:71:cb:2a:d2:e9:4e:ef:4b:14:24:d4:b6:
                    62:b8:4a:76:a8:30:3f:b2:b3:32:56:17:e5:26:f3:
                    05:88:35:63:6f:e5:90:8d:df:57:be:11:80:31:d4:
                    0f:83:fa:d4:57:9f:6b:1a:07:b0:bf:fa:f9:43:11:
                    4c:6f:e1:e0:0a:e9:e9:25:28:0b:ba:ca:ae:07:1e:
                    35:79:20:dd:95:de:8b:01:ba:3d:3f:8c:23:cd:05:
                    9e:7f:37:1d:68:b9:c7:7b:a2:11:b4:d1:b3:6e:7a:
                    bf:88:1d:cb:b8:4b:54:14:5b:f4:e1:a7:f7:2b:b3:
                    dc:4e:3e:3d:13:36:f6:b5:74:a2:a3:75:1f:d1:aa:
                    49:d7:84:ec:03:40:fc:12:f9:bd:f4:3a:c4:31:00:
                    e3:35:2d
                Exponent: 65537 (0x10001)
        Attributes:
            a0:00
    Signature Algorithm: sha256WithRSAEncryption
         43:b5:f9:8c:29:81:73:79:32:b1:4b:ef:2e:c6:4e:90:a7:4a:
         87:46:09:e3:a0:d3:c8:dd:19:04:ff:05:73:dd:07:9a:ee:cd:
         91:4e:1c:54:7a:62:bc:ea:78:57:f6:4f:d0:68:ec:e0:67:6f:
         c5:6b:47:ae:eb:29:3c:dc:a2:dd:83:17:85:05:58:01:3f:a2:
         72:8d:cb:06:4c:53:e7:17:35:dd:e8:16:2e:c6:31:c5:86:7a:
         26:a7:33:3c:96:02:fd:07:c5:6c:fb:3e:9e:6d:0d:38:61:21:
         c1:e8:d8:12:a5:f6:10:ed:15:73:a7:0e:91:89:ec:fd:fe:58:
         43:1e:f7:64:5f:6e:41:dc:08:c3:3c:a2:ea:c3:b2:1c:c3:e9:
         f3:f8:9e:98:8a:f1:ca:bd:46:6a:7e:d4:da:87:d7:a8:f4:39:
         df:fa:dc:d8:db:4b:3b:1b:7d:f1:21:87:79:a5:bf:fa:cf:03:
         96:fc:71:f6:cd:04:1b:55:be:73:7d:5a:b5:11:82:c6:de:50:
         b6:f2:f1:c8:dd:81:73:b7:12:3b:94:90:14:19:4e:fe:ac:f3:
         a7:23:c0:e4:d0:54:22:80:57:ae:4f:f8:6a:65:c0:4b:01:19:
         8a:ef:c0:b6:f2:22:6f:93:e8:fd:52:cc:9e:be:86:d1:5c:27:
         f9:65:ac:56:3a:c3:c1:1e:f3:92:76:e2:ec:57:e2:75:ce:f2:
         66:04:61:88:ab:66:64:7e:6e:08:16:1f:40:a0:0d:46:56:d4:
         71:52:ae:de:8c:13:7d:e9:35:4d:45:ed:fa:0d:57:29:39:42:
         1a:97:e9:d8:3a:a3:30:b9:5e:f3:25:8f:9f:63:11:48:b8:ac:
         9c:73:37:0d:2a:c4:95:7e:25:fb:f0:87:16:95:77:d8:11:c8:
         c2:a5:cd:1d:a2:94:d2:69:fa:6f:c1:9f:29:61:b0:30:5b:bb:
         7e:ef:0e:b5:22:9d:cd:96:3f:7d:65:ef:3a:a7:31:e7:f0:a3:
         30:0c:20:db:62:65:dd:1d:9b:20:5e:a8:6a:56:67:b7:9a:55:
         d7:2e:e6:d9:cb:e0:3b:ea:8c:89:4e:5e:4a:2f:09:9e:a2:bb:
         f2:52:32:ec:4e:4f:e0:80:77:bd:74:3d:84:62:4a:e4:6a:20:
         8e:b3:29:43:13:3f:ea:d3:d3:3f:9b:b0:72:62:1d:36:3e:71:
         c0:13:52:60:9e:f0:39:a7:98:76:3d:56:41:84:8f:13:6c:5b:
         03:da:fc:ba:8f:0e:0d:af:c3:93:d3:42:28:3c:c8:91:45:68:
         00:05:9d:4c:b2:3f:dc:2b:1d:fd:c4:8b:53:ff:df:e5:38:56:
         e2:9d:d2:c6:7b:26:ce:f2
```
---
### 五. 创建CA的根证书
#### 用之前生成的rootca.csr.pem证书请求文件创建根证书：
```
/rootca$  openssl ca -selfsign \
>     -config rootca.cnf \
>     -in csr/rootca.csr.pem \
>     -extensions v3_ca \
>     -days 7300 \
>     -out certs/rootca.cert.pem
Using configuration from rootca.cnf
Enter pass phrase for /home/lwx838779/nick/out/empty/ca2/rootca/private/rootca.key.pem:
Check that the request matches the signature
Signature ok
Certificate Details:
        Serial Number:
            68:30:d7:ca:ec:9d:73:32:b6:c1:9f:ea:e8:8b:ff:ad
        Validity
            Not Before: Jan  9 07:48:57 2020 GMT
            Not After : Jan  4 07:48:57 2040 GMT
        Subject:
            countryName               = CN
            stateOrProvinceName       = ShaanXi
            organizationName          = NickLi Ltd
            organizationalUnitName    = NickLi Ltd CA
            commonName                = NickLi Root CA
            emailAddress              = ljfpower@163.com
        X509v3 extensions:
            X509v3 Subject Key Identifier:
                D1:9A:C2:55:26:1B:D4:5C:83:C2:E6:9D:7E:0E:67:1C:B6:00:16:03
            X509v3 Authority Key Identifier:
                keyid:D1:9A:C2:55:26:1B:D4:5C:83:C2:E6:9D:7E:0E:67:1C:B6:00:16:03

            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Key Usage: critical
                Digital Signature, Certificate Sign, CRL Sign
Certificate is to be certified until Jan  4 07:48:57 2040 GMT (7300 days)
Sign the certificate? [y/n]:y
1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
```
上面在Enter pass phrase的提示中输入私钥的密码 123456，并同意其它的确认提示，后面都选y。     
最终完成了根证书的生成操作。

#### 查看根证书的信息：
```
/rootca$ openssl x509 -noout -text -in certs/rootca.cert.pem
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            68:30:d7:ca:ec:9d:73:32:b6:c1:9f:ea:e8:8b:ff:ad
    Signature Algorithm: sha256WithRSAEncryption
    #Signature Algorithm 表示签名算法是 对明文进行了sha256摘要算法，得到hash串，然后对此串做RSA加密，加密得到结果就是签名
        
        Issuer: C=CN, ST=ShaanXi, O=NickLi Ltd, OU=NickLi Ltd CA, CN=NickLi Root CA/emailAddress=ljfpower@163.com
        #Issurer 是签发方，即签署证书的实体；然后是公钥信息；Subject 指明证书自身的信息，这里 Issurer 和 Subject 的信息是一样的
        
        Validity
        #Validity 指明证书的有效期为 2020-1-9 号至 2040-1-4 号；
            Not Before: Jan  9 07:48:57 2020 GMT
            Not After : Jan  4 07:48:57 2040 GMT
        Subject: C=CN, ST=ShaanXi, O=NickLi Ltd, OU=NickLi Ltd CA, CN=NickLi Root CA/emailAddress=ljfpower@163.com
        Subject Public Key Info:                 公钥信息
            Public Key Algorithm: rsaEncryption
                Public-Key: (4096 bit)
                Modulus:                         具体的公钥                   
                    00:a5:4e:29:6b:8d:1e:c9:d9:2c:7c:a9:2d:25:5f:
                    1b:d1:ae:fd:56:fd:dd:55:26:b9:37:ee:0c:f9:4a:
                    06:63:b2:7a:0f:4d:75:3d:b1:8d:83:3e:a8:71:cb:
                    cf:03:7b:30:26:6d:8f:0e:3b:93:21:af:94:d7:d7:
                    b0:70:0f:f8:78:01:44:84:26:29:70:16:b9:87:b6:
                    6b:dc:ad:0a:8c:f3:c6:b0:f3:d3:8a:83:f9:cb:39:
                    ba:83:ed:60:6c:40:cd:a1:12:9b:1d:53:a2:21:3f:
                    24:32:51:f3:8d:31:66:36:2b:6a:be:6f:94:f3:ae:
                    b4:ea:a3:fb:87:98:7c:f7:3e:ff:29:36:a3:0f:ba:
                    c1:db:b4:a3:1a:26:e3:ae:99:33:49:6a:bc:71:4d:
                    d2:f3:67:d2:b0:30:60:9e:d6:f8:b1:7e:c7:23:f5:
                    ce:06:c5:b8:67:8f:ac:ce:26:dd:4e:e0:6d:4f:81:
                    34:94:b0:f9:93:d4:b1:a0:53:d7:16:ab:ff:84:0e:
                    84:5e:5c:bf:f7:ba:20:7d:50:09:29:dd:cc:fe:c0:
                    3d:4f:24:81:73:49:ef:9c:86:41:42:0d:13:f2:a3:
                    93:8e:43:a2:51:12:a6:0c:68:ea:95:85:3c:f4:dd:
                    ec:1a:96:72:17:54:d3:12:a0:04:68:a0:c5:b0:86:
                    12:92:a6:77:e9:67:eb:ff:71:45:27:11:48:2c:54:
                    66:c1:f2:cc:78:5b:c6:14:c7:d3:3e:48:98:26:92:
                    97:38:91:c7:9b:1b:f6:8c:aa:35:b8:1c:9d:c9:8a:
                    be:67:11:b1:b1:84:f2:54:2a:9d:e2:da:9c:c9:04:
                    13:a8:c6:4e:92:cf:3d:a6:f0:62:91:ac:6f:65:64:
                    b8:9f:08:fb:85:d3:b8:d9:91:4b:74:fc:60:18:9e:
                    f4:06:3d:8f:4a:81:16:2f:79:fa:bd:3f:41:44:54:
                    fc:db:0a:71:cb:2a:d2:e9:4e:ef:4b:14:24:d4:b6:
                    62:b8:4a:76:a8:30:3f:b2:b3:32:56:17:e5:26:f3:
                    05:88:35:63:6f:e5:90:8d:df:57:be:11:80:31:d4:
                    0f:83:fa:d4:57:9f:6b:1a:07:b0:bf:fa:f9:43:11:
                    4c:6f:e1:e0:0a:e9:e9:25:28:0b:ba:ca:ae:07:1e:
                    35:79:20:dd:95:de:8b:01:ba:3d:3f:8c:23:cd:05:
                    9e:7f:37:1d:68:b9:c7:7b:a2:11:b4:d1:b3:6e:7a:
                    bf:88:1d:cb:b8:4b:54:14:5b:f4:e1:a7:f7:2b:b3:
                    dc:4e:3e:3d:13:36:f6:b5:74:a2:a3:75:1f:d1:aa:
                    49:d7:84:ec:03:40:fc:12:f9:bd:f4:3a:c4:31:00:
                    e3:35:2d
                Exponent: 65537 (0x10001)
        X509v3 extensions: 
        #下面是X509 协议相关的信息，这部分信息由配置文件 rootca.cnf 中的 [ v3_ca ] 段控制
            X509v3 Subject Key Identifier:
                D1:9A:C2:55:26:1B:D4:5C:83:C2:E6:9D:7E:0E:67:1C:B6:00:16:03
            X509v3 Authority Key Identifier:
                keyid:D1:9A:C2:55:26:1B:D4:5C:83:C2:E6:9D:7E:0E:67:1C:B6:00:16:03
            X509v3 Basic Constraints: critical
                CA:TRUE  表示是根证书。
            X509v3 Key Usage: critical
                Digital Signature, Certificate Sign, CRL Sign
    Signature Algorithm: sha256WithRSAEncryption                   签名，签名都是RSA加密的，需要证书中的公钥对签名解密
         99:57:22:31:07:b0:ca:c3:27:81:4a:db:63:dd:16:b9:cc:a5:
         67:a4:b3:c0:55:75:85:3f:4b:43:fd:24:08:aa:72:f9:6b:a1:
         ff:2d:d9:d1:27:0c:a1:d1:a1:be:d1:c0:0c:d7:83:95:b4:ae:
         5a:40:13:9b:08:00:69:85:15:e7:ea:bf:0b:5c:74:ff:d9:7e:
         1b:f3:55:4d:7e:8d:cf:53:1e:72:14:d0:f6:e5:e2:72:87:eb:
         be:83:52:bc:0b:6d:81:16:b7:3d:9f:6e:67:46:7e:7d:bf:95:
         33:19:9b:51:67:03:75:cb:95:8c:c3:1b:8f:d1:bd:36:33:f4:
         a8:b0:87:af:43:6d:dc:b4:f5:7a:56:cc:5b:27:8d:0c:a1:e3:
         94:1c:9d:fc:b3:a7:bd:d7:c5:04:9a:39:1c:83:8c:c0:14:cb:
         4f:ba:6e:e7:f4:fc:bf:91:c4:ec:76:2a:9a:d3:90:65:e3:2e:
         bb:18:b2:a2:97:dc:c5:9b:5e:d8:87:77:f7:a4:ac:60:f1:47:
         89:9b:14:05:88:5b:47:98:7e:23:80:f7:3a:35:ce:35:71:2f:
         50:0c:e8:77:c5:5c:60:d0:5b:ee:15:7f:20:2a:96:52:89:87:
         0f:65:c9:c4:69:23:1f:79:e4:90:63:98:0d:dc:16:1f:d1:a8:
         ed:3b:56:74:fe:71:f1:ed:bc:02:1b:52:7c:cd:90:06:5d:8b:
         bd:b4:3c:c9:20:43:cb:20:4b:c9:e6:55:07:ce:37:77:eb:6b:
         0f:9f:81:ba:9f:14:49:8a:43:03:30:39:4c:3b:97:4f:22:cd:
         94:f7:66:4a:0f:c6:d9:8d:56:b6:3a:63:69:42:05:f1:89:e9:
         ba:8f:d6:d4:3c:c6:52:45:a7:c8:b7:77:7f:f5:a6:99:90:dd:
         e6:fd:2f:cf:c1:de:f7:67:95:4f:2e:a9:dc:01:e8:19:ba:3e:
         68:82:e9:ed:dc:32:64:ce:50:87:00:63:11:aa:bb:0d:8d:3e:
         a9:5b:5c:a1:86:58:2a:a7:1c:d3:db:d6:eb:c0:2c:aa:e2:35:
         4c:3a:df:c2:d1:4c:4f:81:7e:35:f2:80:84:f5:d3:3c:61:6b:
         ea:8b:9c:ab:48:ca:26:18:42:ac:2b:53:3c:dd:bb:8f:52:75:
         b5:41:d1:82:eb:2c:17:55:74:77:a7:ce:89:01:ad:65:2c:16:
         8a:cf:41:b7:01:a8:b7:35:93:6f:dc:a4:d7:8a:42:a8:29:59:
         e2:10:4b:98:6e:31:0d:ae:1a:ef:b8:f5:ed:b3:d7:21:6b:a6:
         ef:94:d4:06:97:43:51:c1:02:0c:9d:65:88:5a:52:78:eb:06:
         28:6d:14:2f:58:4a:13:4a
```

---
### 六. 列出所有生成的文件
```
$ find
.
./rootca
./rootca/newcerts
./rootca/newcerts/6830D7CAEC9D7332B6C19FEAE88BFFAD.pem
./rootca/crl
./rootca/private
./rootca/private/rootca.key.pem  根证书的私钥文件
./rootca/csr
./rootca/csr/rootca.csr.pem      根证书请求文件
./rootca/certs
./rootca/certs/rootca.cert.pem   根证书文件
./rootca/db
./rootca/db/crlnumber
./rootca/db/index.old
./rootca/db/index.attr
./rootca/db/serial
./rootca/db/serial.old
./rootca/db/index
./rootca/rootca.cnf               
./createOpensslDir.sh
```
    总结生成的顺序，先生成私钥文件，由私钥文件生成根证书的请求文件，由根证书请求文件生成根证书
