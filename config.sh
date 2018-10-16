##########################################################################################
#
# Magisk Module Template Config Script
# by topjohnwu
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure the settings in this file (config.sh)
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Configs
##########################################################################################

# Set to true if you need to enable Magic Mount
# Most mods would like it to be enabled
AUTOMOUNT=true

# Set to true if you need to load system.prop
PROPFILE=true

# Set to true if you need post-fs-data script
POSTFSDATA=false

# Set to true if you need late_start service script
LATESTARTSERVICE=true

##########################################################################################
# Installation Message
##########################################################################################

# Set what you want to show when installing your mod

print_modname() {
  ui_print "*******************************"
  ui_print "            Custom DNS      "
  ui_print "            for Magisk v17+    "
  ui_print "*******************************"
}

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info about how Magic Mount works, and why you need this

# This is an example
REPLACE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here, it will override the example above
# !DO NOT! remove this if you don't need to replace anything, leave it empty as it is now
REPLACE="
"

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  # Only some special files require specific permissions
  # The default permissions should be good enough for most cases

  # Here are some examples for the set_perm functions:

  # set_perm_recursive  <dirname>                <owner> <group> <dirpermission> <filepermission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm_recursive  $MODPATH/system/lib       0       0       0755            0644

  # set_perm  <filename>                         <owner> <group> <permission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm  $MODPATH/system/bin/app_process32   0       2000    0755         u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0       2000    0755         u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0       0       0644

  # The following is default permissions, DO NOT remove
  set_perm_recursive  $MODPATH  0  0  0755  0644
}

##########################################################################################
# Custom Functions
##########################################################################################

# This file (config.sh) will be sourced by the main flash script after util_functions.sh
# If you need custom logic, please add them here as functions, and call these functions in
# update-binary. Refrain from adding code directly into update-binary, as it will make it
# difficult for you to migrate your modules to newer template versions.
# Make update-binary as clean as possible, try to only do function calls in it.

# Edit the resolv conf file if it exist

ipv4_or_v6() {
echo -e "Detect if IPv4 or IPv6 is used\n"
IP=`curl -s checkip.amazonaws.com`

if [[ $string =~ .*:.* ]]
then
	echo "IPv6 used"
	IPVERSION=`echo "v6"`
else
	echo "IPv4 used"
	IPVERSION=`echo "v4"`
else
	echo "You must to be connected to Internet !"
	exit 1
fi
}

dns_choice() {

SERVICESH=$INSTALLER/config.sh

echo -e "Please type the name of the DNS you want to use:\n\n- Google DNS\n- CloudFlare DNS\n- OpenDNS"
read -p $dns_user_choice
echo "Your choice: ${dns_user_choice}"

case $dns_user_choice in
 *google*|*Google*|*GOOGLE*) [ "$IPVERSION" = "v4"] | sed -i -r -e 's/firstdns/8.8.8.8/' -i -r -e 's/seconddns/8.4.4.8/' $SERVICESH || sed -i -r -e 's/firstdns/2001:4860:4860::8888/' -i -r -e 's/seconddns/2001:4860:4860::8844/' $SERVICESH; fi
 *CloudFlare*|*cloudFlare*|*CLOUDFLARE*) [ "$IPVERSION" = "v4"] | sed -i -r -e 's/firstdns/1.1.1.1/' -i -r -e 's/seconddns/1.0.0.1/' $SERVICESH || sed -i -r -e 's/firstdns2606:4700:4700::1111/' -i -r -e 's/seconddns/2606:4700:4700::1001/' $SERVICESH; fi
 *OpenDNS*|*opendns*|*OPENDNS*) [ "$IPVERSION" = "v4"] | sed -i -r -e 's/firstdns/208.67.222.222/' -i -r -e 's/seconddns/208.67.220.220/' $SERVICESH || sed -i -r -e 's/firstdns/2620:119:35::35/' -i -r -e 's/seconddns/2620:119:53::53/' $SERVICESH; fi
esac

echo -e "DNS applied systemlessly\n\nPlease reboot your device"

}

