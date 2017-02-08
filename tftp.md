Ubuntu Einträge

```
label ubuntu16.04_i386_ps
  menu label Ubuntu 16.04 i386 Preseed
  kernel /ubuntu16.04/i386/linux
  append initrd=/ubuntu16.04/i386/initrd.gz vga=normal ramdisk_size=16384 root=/dev/ram rw preseed/url=ftp://mirror.home.lan/pub/linux/preseed/xenial.seed debian-installer/locale=de_DE keyboard-configuration/layoutcode=de localechooser/translation/warn-light=true localechooser/translation/warn-severe=true netcfg/choose_interface=auto netcfg/get_hostname=ubuntu --

label ubuntu16.04_amd64_ps
  menu label Ubuntu 16.04 amd64 Preseed
  kernel /ubuntu16.04/amd64/linux
  append initrd=/ubuntu16.04/amd64/initrd.gz vga=normal ramdisk_size=16384 root=/dev/ram rw preseed/url=ftp://mirror.home.lan/pub/linux/preseed/xenial.seed debian-installer/locale=de_DE keyboard-configuration/layoutcode=de localechooser/translation/warn-light=true localechooser/translation/warn-severe=true netcfg/choose_interface=auto netcfg/get_hostname=ubuntu --
```

Source: 
* http://www.gtkdb.de/index_34_2792.html