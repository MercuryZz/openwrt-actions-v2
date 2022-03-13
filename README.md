# openwrt-actions-v2
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
git clone https://github.com/BoringCat/luci-app-mentohust.git package/luci-app-mentohust-custom

wget https://github.com/vernesong/OpenClash/archive/master.tar.gz
tar -zxvf master.tar.gz
cp -r OpenClash-master/luci-app-openclash package

git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/luci-app-smartdns-custom

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
