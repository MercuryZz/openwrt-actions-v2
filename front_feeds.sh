git clone https://github.com/KyleRicardo/MentoHUST-OpenWrt-ipk.git package/mentohust-custom
git clone https://github.com/BoringCat/luci-app-mentohust.git package/luci-app-mentohust-custom

git clone https://github.com/openwrt-dev/po2lmo.git
pushd po2lmo
make && sudo make install
popd
