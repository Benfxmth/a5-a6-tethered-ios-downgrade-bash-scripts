# A5/A6 iOS tethered downgrade bash scripts

### Disclaimer

This is BETA software. This may boot loop or brick your device if you don't know what you're doing. This is a tethered up/downgrade, since there is no iBoot/bootROM exploit to boot the device after a reboot, so you'll have to restore your device to a signed iOS version.

***
### Contents

These bash scripts are an attempt to make tether-up/downgrading an A5/A6 device to (almost) any iOS easier. The original tutorial can be found here:
https://www.reddit.com/r/jailbreak/comments/7v6pxu/release_tutorial_how_to_downgrade_any_32_bit/

These are the contents:

* restore_iphone4s_ios6.sh - for up/downgrading an iPhone 4S to iOS 5.0-6.1.3**

* restore_iphone4s_ios7.sh - for up/downgrading an iPhone 4S to iOS 7.0-8.4.1*

* restore_iphone4s_ios9.sh - for up/downgrading an iPhone 4S to iOS 9.0-9.3.5***

* restore_iphone5_ios6.sh - for up/downgrading an iPhone 5 to iOS 6.0-6.1.4

* restore_iphone5_ios7.sh - for up/downgrading an iPhone 5 to iOS 7.0-8.4.1*

* restore_iphone5_ios9.sh - for up/downgrading an iPhone 5 to iOS 9.0-10.3.3***

* restore_iphone5c_ios7.sh - for up/downgrading an iPhone 5C to iOS 7.0-8.4.1

* restore_iphone5c_ios9.sh - for up/downgrading an iPhone 5C to iOS 9.0-10.3.3***

* restore_ipad2_ios6.sh - for up/downgrading an iPad 2 (Wi-Fi or Cellular) to iOS 5.0-6.1.3**

* restore_ipad2_ios7.sh - for up/downgrading an iPad 2 (Wi-Fi or Cellular) to iOS 7.0-8.4.1*

* restore_ipad2_ios9.sh - for up/downgrading an iPad 2 (Wi-Fi or Cellular) to iOS 9.0-9.3.5***

* restore_ipad3_ios6.sh - for up/downgrading an iPad 3/4/mini 1 (Wi-Fi) to iOS 5.1-6.1.3. Can be used on the iPod touch 5.

* restore_ipad3_ios7.sh - for up/downgrading an iPad 3/4/mini 1 (Wi-Fi) to iOS 7.0-8.4.1. Can be used on the iPod touch 5.*

* restore_ipad3_ios9.sh - for up/downgrading an iPad 3/4/mini 1 (Wi-Fi) to iOS 9.0-9.3.5. Can be used on the iPod touch 5.***

* restore_ipad3_cellular_ios6.sh - for up/downgrading an iPad 3 (Cellular) to iOS 5.1-6.1.3

* restore_ipad3_cellular_ios7.sh - for up/downgrading an iPad 3 (Cellular) to iOS 7.0-8.4.1*

* restore_ipad3_cellular_ios9.sh - for up/downgrading an iPad 3 (Cellular) to iOS 9.0-9.3.5***

* restore_ipad4_cellular_ios6.sh - for up/downgrading an iPad 4/mini 1 (Cellular) to iOS 6.0-6.1.3

* restore_ipad4_cellular_ios7.sh - for up/downgrading an iPad 4/mini 1 (Cellular) to iOS 7.0-8.4.1*

* restore_ipad4_cellular_ios9.sh - for up/downgrading an iPad 4/mini 1 (Cellular) to iOS 9.0-10.3.3***

\* iOS 8.4.1 is OTA-signed for most compatible 32 bit devices except for iPhone 5C.

** iOS 6.1.3 is signed for iPhone 4S and iPad 2 (except iPad2,4). 

\*** iOS 9.3.5 and 10.3.3 is the latest version for A5/A6 devices respectively. 

64-bit devices are not compatible with this method.

Note: if you are up/downgrading to iOS 9.0 beta 1-4 use the restore_<device>_ios7.sh since the contents of `/var` on iOS 9.0 beta 1-4 root filesystems are larger than on iOS 9.0 beta 5 and newer.

### How to use

1. Download the ipsw of the firmware you want to up/downgrade to, decrypt the root filesystem, iBSS, iBEC, apple logo, device tree, and kernel cache, dual boot using CoolBooter to iOS 6.1.3 if you’re up/downgrading to iOS 6.1.3 or earlier or to iOS 7.1.2 if you’re installing iOS 7.0 or newer in the same way as the original tutorial, and open `BuildManifest.plist`. Alternatively, you can decrypt a ramdisk (it doesn't matter if it is restore or update ramdisk) using xpwntool, mount the ramdisk, and open `/usr/local/share/restore/options.plist`, search for `SystemPartitionSize` and `SystemPartitionPadding`.

2. Download the scripts and open the the one appropriate for your device/iOS version mentioned before, replace `<system_partition_size>` with the value of `SystemPartitionSize` from before, `<system_partition_padding>` with the value for your device capacity, e.g. if you have a 64 GB device replace it with `640`, or if you have a 16 GB device, replace it with `160`, and `<system_partition_padding_bytes>` with the `SystemPartitionPadding` value multiplied by 1048576, e.g. if the value was 640 it should be 671088640, or if the value was 160 it should be 167772160.

3. Once you have dual booted using CoolBooter and added values to the script, download @nyan_satan's dualbootstuff.deb from [here] (https://github.com/NyanSatan/nyansatan.github.io/blob/master/apt/deb_files/dualbootstuff.deb?raw=true), copy the script you edited before, dualbootstuff.deb, the decrypted kernel cache (it must be named "kernelcache"), apticket.der (if you are upgrading from iOS ≤6.1.3 to iOS ≥7.0), the decrypted and patched iBSS (or iBEC if you're using an iPad) to the root directory and the decrypted root filesystem (it must be named "UDZO.dmg") to `/var`.

4. SSH into your device, if it says "Are you sure you want to continue connecting", type `yes`. The default root password is `alpine`. Then type `chmod +x /restore_<device>_iosx.sh`, and type `/restore_<device>_iosx.sh` to start installing the target iOS. It'll automatically partition the device, flash the filesystem, and kloader the iBSS or iBEC.

5. Unplug and replug the device or press the home button and upload the files using irecovery in this sequence:

`irecovery -f iBEC`*

`irecovery -f applelogo`

`irecovery -c setpicture`

`irecovery -c 'bgcolor 0 0 0'`

`irecovery -f devicetree`

`irecovery -c devicetree`

`irecovery -f kernelcache`

`irecovery -c bootx`

If all worked, the device should successfully boot into iOS.

\* Skip that command if you're using an iPad.
