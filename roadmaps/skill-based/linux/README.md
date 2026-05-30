---
title: Linux
track: linux
category: Skill-based
tags: [roadmap, linux]
---

# Linux

> roadmap.sh: https://roadmap.sh/linux

Suggested path through the **Linux** nodes. Each node links to its lesson when written.

## Nodes

### Foundations
- What is Linux?
- Linux vs other operating systems
- Linux distributions (Debian, Ubuntu, Fedora, RHEL, Arch)
- Choosing and installing a distribution
- The Linux kernel
- Open source and the GPL license
- The Filesystem Hierarchy Standard (FHS)

### Shell basics
- What is a shell?
- Terminal vs shell vs console
- Common shells (bash, zsh, fish)
- Navigating the filesystem (cd, ls, pwd)
- Working with files and directories (cp, mv, rm, mkdir, touch)
- Reading files (cat, less, more, head, tail)
- Finding files (find, locate, which, whereis)
- Getting help (man, info, --help, tldr)

### Text processing
- grep and regular expressions
- sed (stream editor)
- awk
- cut, sort, uniq, wc
- tr and column
- Pipes and redirection
- Standard input, output, and error
- Text editors (vim, nano, emacs)

### Users and permissions
- Users and groups
- /etc/passwd, /etc/shadow, /etc/group
- File permissions (rwx, chmod)
- Ownership (chown, chgrp)
- Special permissions (setuid, setgid, sticky bit)
- sudo and the sudoers file
- su and switching users
- Access Control Lists (ACLs)

### Processes and jobs
- Viewing processes (ps, top, htop)
- Process states and signals
- Killing processes (kill, killall, pkill)
- Foreground and background jobs (jobs, fg, bg, &)
- nohup and disown
- Process priority (nice, renice)
- systemd and services (systemctl)
- init systems (systemd, SysVinit)

### Package management
- apt and dpkg (Debian/Ubuntu)
- yum and dnf (RHEL/Fedora)
- pacman (Arch)
- Snap, Flatpak, and AppImage
- Building from source (make, configure)
- Repositories and PPAs

### Filesystem and storage
- Disks and partitions (fdisk, parted, lsblk)
- Filesystems (ext4, xfs, btrfs)
- Mounting and unmounting (mount, umount, /etc/fstab)
- Disk usage (df, du)
- Logical Volume Manager (LVM)
- Swap space
- Symbolic and hard links (ln)
- Archiving and compression (tar, gzip, zip)

### Networking
- Network interfaces (ip, ifconfig)
- DNS and /etc/hosts
- Testing connectivity (ping, traceroute, mtr)
- Ports and sockets (ss, netstat)
- Transferring files (scp, rsync, curl, wget)
- SSH and key-based authentication
- Firewalls (iptables, nftables, ufw, firewalld)
- DHCP and static IP configuration

### System administration
- Boot process and GRUB
- Runlevels and targets
- Scheduling tasks (cron, at, systemd timers)
- Logging and journald (journalctl, /var/log)
- Environment variables and shell config
- Kernel modules (lsmod, modprobe)
- Performance monitoring (vmstat, iostat, sar)
- Backups and recovery

### Security and hardening
- SSH hardening
- SELinux and AppArmor
- User and password policies
- fail2ban
- System updates and patching
- Auditing (auditd)

### Scripting and automation
- Shell scripting basics
- Bash variables and conditionals
- Loops and functions
- Automating administrative tasks
- Configuration management overview (Ansible)

## Resources
See [resources.md](./resources.md).

## Project ideas
- Provision a fresh VM and write a bootstrap shell script that creates users, hardens SSH, configures a firewall, and installs your baseline packages.
- Build a system health dashboard that collects CPU, memory, disk, and network stats via `/proc` and cron, then logs them to a file with rotation.
- Set up an automated, incremental backup of a directory to a remote host using `rsync` over SSH on a systemd timer.
