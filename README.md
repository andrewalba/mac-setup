# MacOS Setup Scripts

This is based on script I found written by [Martijn Smit](https://github.com/smitmartijn/MacOS-Setup)

These scripts complete my MacOS configuration by changing a bunch of MacOS settings (init_os_settings.sh) and installing my base applications (install_apps.sh).

These scripts will work on a freshly installed MacOS device. It uses [Homebrew](https://brew.sh) and the [Mac App Store CLI](https://github.com/mas-cli/mas) to install applications.

There's also the directory 'offline-apps/' and the install_apps.sh script runs to all downloaded .pkg files and installs them as well. At the bottom of install_apps.sh is also a list of URLs to DMG files that it will download, mount and detect whether to just move it to /Applications or use the installer cli.

# Steps

```shell
/bin/bash init_os_settings.sh
```

Reboot

```shell
/bin/bash install_apps.sh
```

Reboot
