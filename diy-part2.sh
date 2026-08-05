#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

#将原版 Argon 主题及其管理程序删除
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config

#将上述删除的程序替换为 jerrykuku 版（main 分支）
git clone https://github.com/jerrykuku/luci-theme-argon.git package/downloads/luci-theme-argon
git clone https://github.com/jerrykuku/luci-app-argon-config.git package/downloads/luci-app-argon-config

#应用默认主题为 Argon（主线分支）
#方式是取消 Bootstrap 在 Openwrt 中的依赖地位，取而代之的是 Argon（主线分支）
#但 Bootstrap 和 Argon 均会编译，在 config 中去除 Bootstrap 是无效的
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile

# GeoIP 数据，为 Nikki 初次启动预置，别换其他规则，这是 mihomo 作者的规则
mkdir -p files/etc/nikki/run
curl -L -o files/etc/nikki/run/geoip.metadb "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb"
curl -L -o files/etc/nikki/run/geoip.dat "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat"
curl -L -o files/etc/nikki/run/geosite.dat "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat"
curl -L -o files/etc/nikki/run/asn.mmdb "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb"

# zashboard 面板，为 Nikki 预置
UI_DIR="files/etc/nikki/run/ui"
TMP_DIR="/tmp/zashboard-extract"

mkdir -p "$UI_DIR"
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

curl -L -o /tmp/zashboard-dist.zip "https://github.com/Zephyruso/zashboard/releases/latest/download/dist.zip"
unzip -oq /tmp/zashboard-dist.zip -d "$TMP_DIR"

# 把 dist/ 里的内容挪到 ui/ 下(注意这里用 dist/* 而不是 dist)
mv "$TMP_DIR"/dist/* "$UI_DIR"/

rm -rf /tmp/zashboard-dist.zip "$TMP_DIR"
