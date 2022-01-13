  # Login as root
xbps-install -Suy
  # run again
xbps-install -Suy

  # Core installation
  # Seat manager: elogind (includes dbus by default)
  # Policy Manager: polkit
xbps-install -S elogind polkit

  # Link the services to enable them
ln -s /etc/sv/{dbus,elogind,polkitd} /var/service/
