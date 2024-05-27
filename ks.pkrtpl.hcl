# Preseed configuration for automated installation

# Localization and Time Zone
d-i debian-installer/locale string en_US.UTF-8
d-i console-setup/ask_detect boolean false
d-i console-setup/layoutcode string us

# Clock and Time Zone Setup
d-i clock-setup/utc boolean true
d-i time/zone string UTC

# Network Configuration
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string kali
d-i netcfg/get_domain string
d-i netcfg/dhcp_timeout string 60
d-i netcfg/dhcp_failed note
d-i netcfg/dhcp_options select Configure network manually
d-i netcfg/get_nameservers string 8.8.8.8
d-i netcfg/get_ipaddress string 192.168.1.100
d-i netcfg/get_netmask string 255.255.255.0
d-i netcfg/get_gateway string 192.168.1.1

# Mirror Settings
d-i mirror/country string manual
d-i mirror/http/hostname string http.kali.org
d-i mirror/http/directory string /kali
d-i mirror/http/proxy string

# Account Setup
d-i passwd/root-login boolean false
d-i passwd/make-user boolean true
d-i passwd/user-fullname string Kali User
d-i passwd/username string kali
d-i passwd/user-password password kali
d-i passwd/user-password-again password kali

# Disable CDROM Entries After Install
d-i apt-setup/disable-cdrom-entries boolean true

# Enable contrib and non-free Repositories
d-i apt-setup/non-free boolean true
d-i apt-setup/contrib boolean true

# Add Kali Security Mirror
d-i apt-setup/local0/repository string http://http.kali.org/kali kali-rolling main contrib non-free non-free-firmware
d-i apt-setup/local0/comment string Security updates
d-i apt-setup/local0/source boolean false

# Partitioning
d-i partman-auto/disk string /dev/sda
d-i partman-auto/method string regular
d-i partman-auto/choose_recipe select atomic
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

d-i partman-auto/expert_recipe string                         \
      boot-root ::                                            \
        1000 5000 10000 ext3                                  \
            $primary{ } $bootable{ }                          \
            method{ format } format{ }                        \
            use_filesystem{ } filesystem{ ext3 }              \
            mountpoint{ /boot }                               \
        .                                                     \
        2000 10000 1000000000 ext4                            \
            method{ format } format{ }                        \
            use_filesystem{ } filesystem{ ext4 }              \
            mountpoint{ / }                                   \
        .                                                     \
        500 1000 100% linux-swap                              \
            method{ swap } format{ }                          \
        .

d-i partman/confirm_write_new_label boolean true
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# GRUB Boot Loader
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean false
d-i grub-installer/bootdev string /dev/sda

# Software selection
tasksel tasksel/first multiselect standard, kde-desktop
d-i pkgsel/include string kali-linux-core, kali-desktop-xfce
d-i pkgsel/upgrade select none
d-i pkgsel/update-policy select none

# Miscellaneous
popularity-contest popularity-contest/participate boolean false
d-i pkgsel/include string kali-root-login

d-i finish-install/reboot_in_progress note

# Late Command to Install Additional Software and Configure Network
d-i preseed/late_command string \
    in-target sh -c 'echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list; \
                      apt-get update -y || true; \
                      apt-get install -y kali-linux-default kali-desktop-xfce network-manager openssh-server || true; \
                      systemctl enable NetworkManager; \
                      systemctl start NetworkManager; \
                      systemctl enable ssh; \
                      systemctl start ssh'

# Prevent prompts from halting the installation
d-i debconf debconf/frontend select Noninteractive
d-i debian-installer/allow_unauthenticated_ssl boolean true
d-i debian-installer/splash boolean false
d-i debconf debconf/priority select critical
