# Notes

## Prerequisites / Setup

1. adb @server and @client

```shell
pamac install android-tools
```

2. manually configure in android developer options:
   * enable "usb debugging"
   * enable "rooted debugging"
   * enable "disable adb authorization timeout"
   * enable "show taps"
   * enable "pointer location"
3. using usb debugging enable adb over wifi on LineageOS 18.1 device

```shell
db root
adb shell
su
mount -o rw,remount /
echo service.adb.tcp.port=5555 >> /default.prop
reboot
```

4. go to wireless debugging setting, turn it on and *pair device with pairing code*
5. add NAT port forwarding tcp/[Port] --> [Phone-IP]
6. confirm pairing using server and displayed pairing code

```shell
adb pair [external-URL]:[Port]
```

7. remove NAT port forwarding tcp/[Port] --> [Phone-IP]
8. add NAT port forwarding tcp/5555 --> [Phone-IP]
9. connect adb using server and restart device from remote to test if connection is reestablished

```shell
adb connect [external-URL]
adb reboot
# wait for device to restart
adb devices
```

## Testing

```shell
adb shell pm list packages

adb shell pm path com.android.messaging
adb pull /system/product/app/messaging/messaging.apk /tmp/messaging.apk
```

## Tipps

```shell
adb install-multiple app.apk config.apk
```