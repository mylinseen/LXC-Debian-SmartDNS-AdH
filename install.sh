#!/bin/bash
# ======================================================
# 🔥 SmartDNS + AdGuardHome 最优部署脚本
# 适合高速解析 + 视频流畅 + 广告过滤
# ======================================================

echo ">>> 更新系统软件..."
apt update -y && apt upgrade -y

# ========== 安装 SmartDNS ==========
echo ">>> 安装 SmartDNS..."
apt install -y smartdns || { echo "[错误] SmartDNS安装失败"; exit 1; }

# SmartDNS配置
cat >/etc/smartdns/smartdns.conf <<EOF
bind :6053
cache-size 1024
log-level info

# 国内 DNS（优先）
server 223.5.5.5 -bootstrap-dns
server 119.29.29.29 -bootstrap-dns

# 国外 DNS 加密解析
server-https https://dns.google/dns-query
server-https https://cloudflare-dns.com/dns-query
server-tls 1.1.1.1:853
server-tls 8.8.8.8:853

force-AAAA-SOA yes
prefetch-domain yes
serve-expired yes
speed-check-mode ping,tcp:443
EOF

systemctl enable smartdns
systemctl restart smartdns
echo "[OK] SmartDNS 已运行 → 端口 6053"

# ========== 安装 AdGuardHome ==========
echo ">>> 下载并安装 AdGuardHome..."
cd /opt && wget -O AdGuardHome.tar.gz \
"https://static.adguard.com/adguardhome/release/AdGuardHome_linux_amd64.tar.gz"

tar -xzf AdGuardHome.tar.gz && rm -f AdGuardHome.tar.gz
cd AdGuardHome
./AdGuardHome -s install

# 🔥 接入 SmartDNS 作为上游
sed -i 's/127.0.0.1:53/127.0.0.1:6053/g' /opt/AdGuardHome/AdGuardHome.yaml
systemctl restart AdGuardHome

echo "===================== 部署完成 ====================="
echo "📍 AdGuardHome 面板   → http://LXC_IP:3000"
echo "📍 AGH DNS监听        → 53"
echo "📍 SmartDNS高速解析   → 6053 (已作为AGH上游)"
echo "===================== 下一步 ======================"
echo "⭐ AGH 面板 → Filters → 勾选以下规则订阅："
echo "1. AdGuard 基础过滤  → https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt"
echo "2. AdGuard 移动APP规则 → https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter_mobile.txt"
echo "3. Anti-AD 国内去广告 → https://anti-ad.net/easylist.txt"
echo "✅ 可选：StevenBlack Hosts → https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
echo "===================================================="
echo "💡 DNS 结构：设备 → AdGuardHome:53 → SmartDNS:6053 → 上游DNS"
echo "💡 爱快 DHCP DNS 可改为 AGH IP，全局享受加速+广告过滤"
