######################## SAFETY START
if [[ $EUID -eq 0 ]]; then
    error "Do not run this as the root user"
    echo "This is not intended to be run as bulk bash commands"
    exit 1
fi
######################## SAFETY END

########################
######## status commands
########################

# general zfs pools check
zfs list

# all zpool status
zpool status
# certain pool status
zpool status zpool-name-here

########################
######## add L2ARC cache disk (SSD or NVMe) to zpool
########################

#### note: L2ARC need to be clean from any partition
#### to clear (destroy) partition from cache disk use:

# step 1) list and locate ssd/nvme disk
# in our example we have device under path /dev/nvme0n1
lsblk

# step 2) use utility 'fdisk' on your disk 
fdisk /dev/nvme0n1

# step 2a) destroy partition by command 'd', repeat until you see: 'No partition is defined yet!'
d

# step 2b) write changes to disk
w

# step 2c) exit 'fdisk' utility (however you like)
ctrl + c

# step 3) attach cache device to pool
zpool add zpool-name-here cache nvme0n1

# step 4) confirm that cache is attached by using 'zpool status'
zpool status zpool-name-here

# you should see your cache device under column NAME -> cache. You now have L2ARC device
# shutdown and start again active VMs machines

########################
######## ZFS file system variables optimisation for speed, performance, IOPS
########################

# check (list) current zpool settings
zfs get all zpool-name-here

# 'sync' - disabled means that data gets synced either every 5 seconds or every 64M IIRC. If you're willing to risk the last ~5 seconds you can run with this.
zfs set sync=disabled zpool-name-here

# 'axttr' - you can use the xattr property to disable or enable extended attributes for a specific ZFS file system. The default value is on
zfs set xattr=sa zpool-name-here

# 'secondarycache' - (L2ARC) - if set to 'all', both user data and metadata are cached. If set to 'none', neither user data nor metadata is cached. If set to 'metadata', only metadata is cached.
zfs set secondarycache=all

########################
######## ZFS L2ARC optimisation
########################

# bellow optimization commands need to be inside zfs.conf file. It's probably empty by default
nano /etc/modprobe.d/zfs.conf

# l2arc_noprefetch' enables (0/zero is not a mistake) L2ARC prefetching - read stream from pool is cached inside L2ARC so this acts as aggressive cache method. Usefull when you have relatively large L2ARC device and enough RAM for standard ARC.
options zfs l2arc_noprefetch=0

# 
options zfs l2arc_write_max=8388608
options zfs l2arc_write_boost=8388608


########################
######## misc/other helpful commands
########################

# lower the tendence to swappines - stay on ARC/L2ARC reads more than 'swap' (which is on slower disk)
# bellow optimization commands need to be inside sysctl.conf

# step 1)
nano /etc/sysctl.conf

# step 1b )
vm.swappiness=10
