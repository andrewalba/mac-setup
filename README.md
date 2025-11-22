# MacOS Setup Scripts

This is based on script I found written by [Martijn Smit](https://github.com/smitmartijn/MacOS-Setup)

These scripts complete my MacOS configuration by changing several MacOS settings (init_os_settings.sh) and installing my base applications (install_apps.sh).

These scripts will work on a freshly installed MacOS device. We rely on [Homebrew](https://brew.sh) to install most applications.

**Note**: The previous version of `install_app.sh` used the Mac App Store `mas` command to install App Store software. The command no longer works on the latest Apple OS so we have removed it.

We have replaced the brew install bash commands with `Brewfile` to handle software installation.

There's also the directory 'offline-apps/' and the install_apps.sh script runs to all downloaded .pkg files and installs them as well. At the bottom of install_apps.sh is also a list of URLs to DMG files that it will download, mount and detect whether to just move it to /Applications or use the installer cli.

**Note** Be prepared to enter your password while the following scripts are run.

# Steps

```shell
/bin/bash init_os_settings.sh
```

Reboot

```shell
/bin/bash install_apps.sh
```

Reboot. Enjoy!
