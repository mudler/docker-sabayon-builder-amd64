#!/bin/bash

PACKAGES_TO_REMOVE=(
    "app-admin/sudo"
    "x11-libs/gtk+:3"
    "x11-libs/gtk+:2"
    "dev-db/mariadb"
    "sys-fs/ntfs3g"
    "app-accessibility/at-spi2-core"
    "app-accessibility/at-spi2-atk"
    "sys-devel/base-gcc:4.7"
    "sys-devel/gcc:4.7"
    "net-print/cups"
    "dev-util/gtk-update-icon-cache"
    "dev-qt/qtscript"
    "dev-qt/qtchooser"
    "dev-qt/qtcore"
    "app-shells/zsh"
    "app-shells/zsh-pol-config"
    "dev-db/mysql-init-scripts"
    "dev-lang/ruby"
    "app-editors/vim"
    "dev-util/gtk-doc-am"
    "media-gfx/graphite2"
    "x11-apps/xset"
    "x11-themes/hicolor-icon-theme"
    "media-libs/tiff"
    "app-eselect/eselect-lcdfilter"
    "app-eselect/eselect-mesa"
    "app-eselect/eselect-opengl"
    "app-eselect/eselect-qtgraphicssystem"
    "x11-libs/pixman"
    "x11-libs/libvdpau"
    "x11-libs/libxshmfence"
    "x11-libs/libXxf86vm"
    "x11-libs/libXinerama"
    "x11-libs/libXdamage"
    "x11-libs/libXcursor"
    "x11-libs/libXfixes"
    "x11-libs/libXv"
    "x11-libs/libXcomposite"
    "x11-libs/libXrandr"
    "media-libs/jbig2dec"
    "dev-libs/libcroco"
    "app-text/qpdf"
    "media-fonts/urw-fonts"
    "app-text/libpaper"
    "dev-python/snakeoil"
    "dev-libs/atk"
    "dev-perl/DBI"
    "app-text/sgml-common"
    "sys-power/upower"
)

FILES_TO_REMOVE=(
   "/.viminfo"
   "/.history"
   "/.zcompdump"
   "/var/log/emerge.log"
   "/var/log/emerge-fetch.log"
)

PACKAGES_TO_ADD=(
    "app-text/pastebunz"
    "app-admin/perl-cleaner"
    "sys-apps/grep"
    "sys-kernel/sabayon-sources"
    "app-misc/sabayon-version"
    "app-portage/layman"
    "app-portage/eix"
    "net-misc/rsync"
    "app-crypt/gnupg"
)

rsync -av -H -A -X --delete-during "rsync://rsync.at.gentoo.org/gentoo-portage/licenses/" "/usr/portage/licenses/"
ls /usr/portage/licenses -1 | xargs -0 > /etc/entropy/packages/license.accept

# Handling install/removal of packages specified in env
equo rm --deep --configfiles --force-system "${PACKAGES_TO_REMOVE[@]}"
equo i "${PACKAGES_TO_ADD[@]}"

# Configuring layman
mkdir /etc/portage/repos.conf/
layman-updater -R

# Merging defaults configurations
echo -5 | equo conf update

# Writing package list file
equo q list installed -qv > /etc/sabayon-pkglist

# Cleaning equo package cache
equo cleanup

# Cleanup Perl cruft
perl-cleaner --ph-clean

# remove SSH keys
rm -rf /etc/ssh/*_key*

# Configuring for build
echo "*" > /etc/eix-sync.conf
eix-sync
layman -a sabayon
echo "y" | layman -a sabayon-distro

# remove LDAP keys
rm -f /etc/openldap/ssl/ldap.pem /etc/openldap/ssl/ldap.key \
/etc/openldap/ssl/ldap.csr /etc/openldap/ssl/ldap.crt

# Remove scripts
rm -rf /post-upgrade.sh

# Cleanup
rm -rf "${FILES_TO_REMOVE[@]}"
