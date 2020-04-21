# zfs-optimisation
List of steps for ZFS filesystem (pools) optimization. Also in regards to L2ARC

# How to create good ZFS performance?
Please read, read and read about it. There is plenty of discussion on the forums across internet about every settings and variables - the more you know the better system you can build.

Well built architecture of file system based on ZFS is not so simple, take your pool size, available RAM and data usage case into considiration.

# Enviroment
Commands used here were tested and applied on budget:
- Proxmox
- small ZFS pool with SSD on main pool
- Intel PCIe NVMe as L2ARC
- 72GB RAM (default ARC limit)
- lz4 compression turned on

# Fell free to contribute
If you want to contribute, just comment, pull request or reach me by message.
If you want to see automated script to apply all settings by .sh, also say so.

# PRECAUTIONS
At this state, initiated commands in .sh file are raw with little portion of comments - please do know that using it as recles at its written without understanding how they works may lead to some data loss

