#!/bin/sh

LOG=/var/log/messages
INTERFACE=eth0

echo Powering down wifi
om wifi power 0
while ! tail $LOG | grep -q "s3c2440-sdi: powered down"
do
  echo "  waiting"
  sleep 1
done
echo Powering up wifi
om wifi power 1
while ! tail $LOG | grep -q "AR6000 Reg Code = 0x40000060"
do
  echo "  waiting"
  sleep 1
done
echo Setting up $INTERFACE
ifconfig $INTERFACE up
while ! ifconfig $INTERFACE | grep -q $INTERFACE
do
  echo "  waiting"
  sleep 1
done
echo Maxperfing eth0
om wifi maxperf eth0 1
echo Starting wpa_supplicant
wpa_supplicant -B w -D wext -i $INTERFACE -c /etc/wpa_supplicant.conf > /dev/null
while ! tail $LOG | grep -q "AR6000 connected event"
do
  echo "  waiting"
  sleep 1
done