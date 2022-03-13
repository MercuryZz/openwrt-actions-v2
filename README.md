# openwrt-actions-v2
## 实现单线程编译openwrt源码，再通过二次编译实现固件定制
## 请右上角fork使用
### 借鉴自[P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt)
### Actions默认使用[coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)源码编译，有其他需求可修改如下部分
```yml
   env:
     REPO_URL: https://github.com/coolsnowwolf/lede
     REPO_BRANCH: master
```
### 需要自己准备如下
- arch.config --> 仅作架构修改的配置文件，知道自己机器架构的可直接按项目内文件修改
- .config --> 用于二次编译的自定义配置文件
- front_feeds.sh --> feeds更新下载前脚本
- after_feeds.sh --> feeds更新下载后脚本
- feeds.conf.default --> 用于添加自定义软件包，于二次编译中使用
---
- [ ] 实现可选单次编译或二次编译
- [ ] 正在找寻免验证的临时网盘当跳板
---
### 准备配置文件所需步骤的记录，其中包含整个编译过程，有条件也可直接物理机编译
```shell
sudo apt-get update
sudo apt-get -y install build-essential asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch python3 python2.7 unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev xmlto qemu-utils upx libelf-dev autoconf automake libtool autopoint device-tree-compiler g++-multilib antlr3 gperf wget curl swig rsync

git clone https://github.com/coolsnowwolf/lede
cd lede

./scripts/feeds update -a
./scripts/feeds install -a

make menuconfig

make download -j8 V=s
find dl -size -1024c -exec ls -l {} \;
make -j1 V=s

###############################################################################################
sudo sh -c "apt update && apt upgrade -y"
git pull
# 删除执行make menuconfig后产生的一些临时文件，包括一些软件包的检索信息
# 删除后会重新加载package目录下的软件包，若不删除会导致一些新加入的软件包不显示
rm -rf tmp
rm -f .config

git clone https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk.git package/mentohust-custom
git clone https://github.com/BoringCat/luci-app-mentohust.git package/luci-app-mentohust

wget https://github.com/vernesong/OpenClash/archive/master.tar.gz
tar -zxvf master.tar.gz
cp -r OpenClash-master/luci-app-openclash package

git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns

vim feeds.conf.default
# src-git helloworld https://github.com/fw876/helloworld
# src-git passwall https://github.com/xiaorouji/openwrt-passwall

cd package/lean
git clone https://github.com/jerrykuku/lua-maxminddb.git
git clone https://github.com/jerrykuku/luci-app-vssr.git
cd .. & cd ..


git clone https://github.com/openwrt-dev/po2lmo.git
pushd po2lmo
make && sudo make install
popd

./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig

Target System -> MediaTek Ralink MIPS
Subtarget -> MT7621 based boards
Target Profile -> Xiaomi Mi Router AC2100
Target Images -> tar.gz
Luci -> Modules -> luci-compat
     -> Applications -> luci-app-adbyby-plus
     			    -> luci-app-frpc
     			    -> luci-app-guest-wifi
     			    -> luci-app-ipsec-vpnd
     			    -> luci-app-mentohust
     			    -> luci-app-netdata `problem`
     			    -> luci-app-openclash
     			    -> luci-app-samba
     			    -> luci-app-smartdns-custom
     			    -> luci-app-statistics
     			    -> luci-app-transmission
     			    -> luci-app-vssr
     			        Include Xray
     			        Include Trojan
     			        Include Shadowsocks Xray Plugin
     			        Include ShadowsocksR Libev Server
     			    -> luci-app-wifischedule
     			    -> luci-app-wireguard ``
     			    -> luci-app-zerotier
     -> Themes -> luci-theme-argon
     		  -> luci-theme-material
     		  -> luci-theme-netgear
     -> Network -> Ruijie -> mentohust

####
unlockmusic `problem`
####

make download -j8 V=s
find dl -size -1024c -exec ls -l {} \;
make -j$(nproc) || make -j1 || make -j1 V=s
```
