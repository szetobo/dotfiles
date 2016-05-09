#!/usr/bin/env bash
#
# bootstrap script for rsync-client
#

sudo -i

if ! getent passwd rsync > /dev/null 2>&1; then
  # create user for rsync server to login
  adduser --gecos "Rsync" --disabled-password rsync
fi

# allow user to sudo without password
touch /etc/sudoers.d/rsync
echo 'rsync ALL=(ALL) NOPASSWD: /usr/bin/rsync --server --sender -logDtprze.iLs --numeric-ids . /' > /etc/sudoers.d/rsync

# prepare key-based only login
mkdir -p /home/rsync/.ssh
chmod 700 /home/rsync/.ssh
touch /home/rsync/.ssh/authorized_keys
echo 'command="/usr/bin/sudo /usr/bin/rsync --server --sender -logDtprze.iLs --numeric-ids . /" replace_rsync_server_key_here' > /home/rsync/.ssh/authorized_keys
chown -R rsync:rsync /home/rsync/.ssh
