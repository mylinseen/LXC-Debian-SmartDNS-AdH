# ======================================================
# 🔥 LXC-Debian-SmartDNS-AdH 项目说明
# ======================================================

## 1️⃣ 项目介绍

**LXC-Debian-SmartDNS-AdH** 是一个自动化部署脚本，旨在通过 SmartDNS 和 AdGuardHome 提供以下功能：

- **高速解析**：使用 SmartDNS 实现国内 CDN 优选，网页秒开。
- **广告过滤**：通过 AdGuardHome 清理广告，保护电视、APP 等设备免受干扰。
- **透明无缝接入**：无论是 IPv4 还是 IPv6 设备，都可以轻松实现加速与广告屏蔽。

## 2️⃣ 安装说明

### 依赖环境

- PVE 虚拟化环境（支持 LXC）
- **Debian 12** / **Ubuntu 22.04** / **其他 Debian 系列系统**  
  推荐内存配置：0.5GB (足够运行 SmartDNS + AdGuardHome)

### 3️⃣ 执行安装脚本

- 在 LXC 容器中执行以下命令，直接安装 SmartDNS 和 AdGuardHome：

```bash
bash <(curl -s https://github.com/mylinseen/LXC-Debian-SmartDNS-AdH/raw/main/install.sh)
