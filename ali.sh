#!/bin/sh
# OpenWrt Setup Script: Theme + v2ray installation + WiFi configuration + IP Change
clear

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}  بدء الإعداد الكامل للراوتر${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"

# ==================== Argon Theme Installation ====================
echo -e "${YELLOW}[القسم الأولي: تثبيت ثيم Argon]${NC}\n"

echo -e "${GREEN}[1/3] تحميل ثيم Argon...${NC}"
cd /tmp
wget --no-check-certificate -O luci-theme-argon_2.3.2-r20250207_all.ipk  https://github.com/jerrykuku/luci-theme-argon/releases/download/v2.3.2/luci-theme-argon_2.3.2-r20250207_all.ipk >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تحميل ثيم Argon بنجاح${NC}\n"

echo -e "${GREEN}[2/3] تحميل إعدادات ثيم Argon...${NC}"
wget --no-check-certificate -O luci-app-argon-config_0.9-20220424_all.ipk https://github.com/jerrykuku/luci-theme-argon/releases/download/v1.8.4/luci-app-argon-config_0.9-20220424_all.ipk >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تحميل إعدادات Argon بنجاح${NC}\n"

echo -e "${GREEN}[3/3] تثبيت الثيم والإعدادات...${NC}"
opkg install /tmp/luci-theme-argon_2.3.2-r20250207_all.ipk >/dev/null 2>&1
opkg install /tmp/luci-app-argon-config_0.9-20220424_all.ipk >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت ثيم Argon بنجاح${NC}\n"

# تنظيف الملفات المؤقتة
rm -f /tmp/luci-theme-argon_2.3.2-r20250207_all.ipk >/dev/null 2>&1
rm -f /tmp/luci-app-argon-config_0.9-20220424_all >/dev/null 2>&1

# ==================== Network IP Configuration ====================
echo -e "${YELLOW}[القسم الثاني: تغيير IP الراوتر]${NC}\n"

echo -e "${GREEN}[1/3] تكوين عنوان IP الجديد...${NC}"
uci set network.lan.ipaddr='192.168.11.1' >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تعيين IP إلى 192.168.11.1${NC}\n"

echo -e "${GREEN}[2/3] تكوين نطاق DHCP...${NC}"
uci set dhcp.lan.start='100' >/dev/null 2>&1
uci set dhcp.lan.limit='150' >/dev/null 2>&1
uci set dhcp.lan.leasetime='12h' >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تكوين DHCP (192.168.11.100 - 192.168.11.250)${NC}\n"

echo -e "${GREEN}[3/3] حفظ الإعدادات...${NC}"
uci commit network >/dev/null 2>&1
uci commit dhcp >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم حفظ إعدادات الشبكة${NC}\n"

# ==================== V2Ray Installation ====================
echo -e "${BLUE}[القسم الثالث: تثبيت V2Ray]${NC}\n"

echo -e "${GREEN}[1/9] تحميل المفتاح العام...${NC}"
wget -q https://downloads.sourceforge.net/project/v2raya/openwrt/v2raya.pub -O /etc/opkg/keys/94cc2a834fb0aa03 2>&1 && \
echo -e "${GREEN}✓ تم تحميل المفتاح العام بنجاح${NC}\n"

echo -e "${GREEN}[2/9] إضافة مصدر التحديث...${NC}"
echo "src/gz v2raya https://downloads.sourceforge.net/project/v2raya/openwrt/$(. /etc/openwrt_release && echo \"$DISTRIB_ARCH\")" >> /etc/opkg/customfeeds.conf 2>/dev/null && \
echo -e "${GREEN}✓ تم إضافة مصدر التحديث بنجاح${NC}\n"

echo -e "${GREEN}[3/9] تحديث قائمة الحزم...${NC}"
opkg update >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تحديث قائمة الحزم بنجاح${NC}\n"

echo -e "${GREEN}[4/9] تثبيت v2raya...${NC}"
opkg install v2raya >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت v2raya بنجاح${NC}\n"

echo -e "${GREEN}[5/9] تثبيت kmod-nft-tproxy...${NC}"
opkg install kmod-nft-tproxy >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت kmod-nft-tproxy بنجاح${NC}\n"

echo -e "${GREEN}[6/9] تثبيت xray-core...${NC}"
opkg install xray-core >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت xray-core بنجاح${NC}\n"

echo -e "${GREEN}[7/9] تثبيت v2fly-geoip و v2fly-geosite...${NC}"
opkg install v2fly-geoip v2fly-geosite >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت v2fly-geoip و v2fly-geosite بنجاح${NC}\n"

echo -e "${GREEN}[8/9] تثبيت luci-app-v2raya...${NC}"
opkg install luci-app-v2raya >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تثبيت luci-app-v2raya بنجاح${NC}\n"

echo -e "${GREEN}[9/9] تكوين وبدء الخدمة...${NC}"
uci set v2raya.config.enabled='1' >/dev/null 2>&1
uci commit v2raya >/dev/null 2>&1
/etc/init.d/v2raya start >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم تكوين وبدء الخدمة بنجاح${NC}\n"

opkg install openssh-sftp-server >/dev/null 2>&1 && \

echo -e "${GREEN}إعداد إعدادات الشبكة...${NC}"
mkdir -p /usr/share/nftables.d/chain-pre/mangle_postrouting/ >/dev/null 2>&1
echo "ip ttl set 65" > /usr/share/nftables.d/chain-pre/mangle_postrouting/01-set-ttl.nft 2>/dev/null
fw4 reload >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم إعداد إعدادات الشبكة بنجاح${NC}\n"

# ==================== WiFi Configuration ====================
echo -e "${BLUE}[القسم الرابع: إعداد شبكات WiFi]${NC}\n"

echo -e "${GREEN}إعداد شبكة WiFi...${NC}"
uci batch << EOF
# إعداد الشبكة الأولى (2.4GHz)
set wireless.default_radio0=wifi-iface
set wireless.default_radio0.device='radio0'
set wireless.default_radio0.network='lan'
set wireless.default_radio0.mode='ap'
set wireless.default_radio0.ssid='eSimIRAQ'
set wireless.default_radio0.encryption='psk2'
set wireless.default_radio0.key='eSimIRAQ'

# إعداد الشبكة الثانية (5GHz)
set wireless.default_radio1=wifi-iface
set wireless.default_radio1.device='radio1'
set wireless.default_radio1.network='lan'
set wireless.default_radio1.mode='ap'
set wireless.default_radio1.ssid='eSimIRAQ 5G'
set wireless.default_radio1.encryption='psk2'
set wireless.default_radio1.key='eSimIRAQ'

# تفعيل الراديو
set wireless.radio0.disabled='0'
set wireless.radio1.disabled='0'

commit wireless
EOF

echo -e "${GREEN}✓ تم إعداد شبكات WiFi بنجاح${NC}\n"

echo -e "${GREEN}إعادة تشغيل الشبكة اللاسلكية...${NC}"
wifi reload >/dev/null 2>&1 && \
echo -e "${GREEN}✓ تم إعادة تشغيل WiFi بنجاح${NC}\n"

# ==================== Apply Network Changes ====================
echo -e "${YELLOW}[إعادة تشغيل الشبكة لتطبيق IP الجديد]${NC}\n"
echo -e "${YELLOW}⚠️  سيتم تطبيق التغييرات خلال 5 ثوانٍ...${NC}"
echo -e "${YELLOW}⚠️  ملاحظة: بعد إعادة التشغيل، استخدم العنوان الجديد:${NC}"
echo -e "${GREEN}   http://192.168.11.1${NC}\n"
sleep 5

/etc/init.d/network restart >/dev/null 2>&1

# ==================== Cleanup ====================
rm -- "$0" >/dev/null 2>&1

# ==================== Final Message ====================
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${GREEN}  ✓ تم إكمال التثبيت بنجاح!${NC}"
echo -e "${GREEN}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  🎨 تم تثبيت ثيم Argon${NC}"
echo -e "${GREEN}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  🌐 عنوان الراوتر الجديد:${NC}"
echo -e "${GREEN}     • IP: 192.168.11.1${NC}"
echo -e "${GREEN}     • الدخول: http://192.168.11.1${NC}"
echo -e "${GREEN}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  📡 الشبكات المضبوطة:${NC}"
echo -e "${GREEN}     • eSimIRAQ (2.4GHz)${NC}"
echo -e "${GREEN}     • eSimIRAQ 5G (5GHz)${NC}"
echo -e "${GREEN}     • كلمة المرور: eSimIRAQ${NC}"
echo -e "${GREEN}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Powered by Aloky ⚡${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}\n"
