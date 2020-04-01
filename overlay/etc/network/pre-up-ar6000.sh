#!/bin/sh

LOG=/var/log/messages
INTERFACE=eth0
KERNEL_CONFIG=/proc/config.gz

echo "    Checking kernel configuration"
if [ ! -e $KERNEL_CONFIG ]
then
  echo "      $KERNEL_CONFIG is not present, are you using the correct kernel?"
  exit 1
fi
echo "      $KERNEL_CONFIG is present"
if ! zcat $KERNEL_CONFIG | grep -q "CONFIG_CFG80211=y"
then
  echo "      CFG80211 not compiled in kernel"
  exit 1
fi
echo "      CFG80211 compiled in kernel"

echo "    Powering down wifi"
om wifi power 0
while ! tail $LOG | grep -q "s3c2440-sdi: powered down"
do
  echo "      waiting"
  sleep 1
done
echo "    Powering up wifi"
om wifi power 1
while ! tail $LOG | grep -q "AR6000 Reg Code = 0x40000060"
do
  if dmesg | tail -n 5 | grep -q "ar6000_activate: Failed to activate"
  then
    echo "      failed to activate ar6000, will reboot in 5 seconds"
    sleep 5
    reboot
  fi
  echo "      waiting"
  sleep 1
done
echo "    Setting up $INTERFACE"
ifconfig $INTERFACE up
if [ $? -ne 0 ]
then
  echo "      ifconfig failed"
  exit 1
fi
while ! ifconfig $INTERFACE | grep -q $INTERFACE
do
  echo "      waiting"
  sleep 1
done
echo "    Maxperfing eth0"
om wifi maxperf eth0 1
echo "    Starting wpa_supplicant"
wpa_supplicant -B w -D wext -i $INTERFACE -c /etc/wpa_supplicant.conf > /dev/null
while ! tail $LOG | grep -q "AR6000 connected event"
do
  echo "      waiting"
  sleep 1
done