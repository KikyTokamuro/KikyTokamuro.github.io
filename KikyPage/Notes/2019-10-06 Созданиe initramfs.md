#linux #kernel

Initramfs, сокращенно от “initial RAM file system”, является приемником initrd (initial ramdisk). Это cpio (copy in and out) архив исходной файловой системы, который загружается в память во время процесса запуска Linux. Linux копирует содержимое архива в rootfs (которая может быть основана на ramfs либо на tmpfs), а затем запускает init. Init предназначен для выполнения определенных задач до того, как реальная или финальная файловая система будет установлена поверх rootfs. Таким образом, initramfs должен содержать все драйвера устройств и инструменты, необходимые для установки конечной корневой файловой системы.

Скачиваем busybox (вы можете скачать более новую версию):
```shell
wget https://busybox.net/downloads/busybox-1.26.2.tar.bz2
tar -xvf busybox-1.26.2.tar.bz2
```

Собираем busybox из исходников:
```shell
cd busybox-1.26.2
make defconfig
make menuconfig
```

В меню Busybox Settings выбираем Build Options, и ставим галочку напротив Build BusyBox as a static binary (no shared libs). Далее указываем выходную папку для бинарников и собираем busybox.
```shell
make
make CONFIG_PREFIX=./../busybox_rootfs install
```

Создаем иерархию каталогов для initramfs:
```shell
mkdir -p initramfs/{bin,dev,etc,home,mnt,proc,sys,usr}
cd initramfs/dev
sudo mknod sda b 8 0
sudo mknod console c 5 1
```

Так же копируем все из папки busybox_rootfs в папку initramfs. Дальше создаем в корне initramfs файл init, и пишем в него следующее:
```shell
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
exec /bin/sh
```

И даем ему права на исполнение:
```shell
chmod +x init
```

Создаем сам initramfs:
```shell
find . -print0 | cpio --null -ov --format=newc > initramfs.cpio
gzip ./initramfs.cpio
```

Скачиваем и собираем ядро (вы можете скачать более новую версию):
```shell
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.11.6.tar.xz
tar -xvf linux-4.11.6.tar.xz
make x86_64_defconfig
make kvmconfig
make -j2
```

Образ ядра будет лежать в /arch/x86_64/boot/bzImage.

Дальше копируем куда-то наш initramfs и ядро, заходим в эту директорию и запускаем qemu:
```shell
qemu-system-x86_64 -kernel ./bzImage -initrd ./initramfs.cpio.gz -nographic -append "console=ttyS0"
```

Если все было выполнено правильно, то загрузится ядро и запустится shell.