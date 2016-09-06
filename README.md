#Homebr3w
Download and install Homebrew Apps for 3ds easily! App based on [lpp-3ds](https://github.com/Rinnegatamante/lpp-3ds)

##Usage
Simply download the .cia file from the [releases page](https://github.com/Wolvan/Homebr3w/releases) and install it with your favorite .cia Installer, for example FBI. You can also just scan the QR Code from the releases page as well.

You can also use the .3ds version for a flashcard or the .3dsx version for *hax.

Note: The .3dsx version does not support launching freeShop through it, the option is disabled.

## Nightlies
Nightlies are available at [the official automatic Nightly build page](https://wolvan.github.io/Homebr3w/build/) and build whenever changes get pushed to the `master` branch

##Analytics
This app generates a UUID for each Homebr3w client on first launch which will then be sent to TitleDB.com.

The UUID will be used to collect pseudo-anonymous data to get an idea of how many people use this app, how much people install apps and the like. **If you do not want to be tracked using this, you can turn the UUID sending off in the Settings Menu!**

You can also regenerate the UUID if you delete the `client_uuid` entry from `SDMC:/3ds/data/Homebr3w/data.json`, which causes a new ID to be generated for you.

## Differences between Builds
There are 2 different builds available, the `.3ds`/`.cia` build and the `.3dsx` NH(2) Build.

`.3ds` for Flashcards and `.cia` to install to Homemenu are identical in functionality and have the full set of features available.

`.3dsx` is slightly limited in its functionality as it is not able to install or launch `.cia`'s from the Homemenu. The functionality is automatically disabled in the `.3dsx` builds.

##Build instructions
The building is made possible through a `make` script, meaning you need to have `make` installed and in your path. If you already use devkitArm then you are good to go

Just run `make` (or `make all`/`make build`) to get your binaries in the build directory

`build 3ds` and `build cia` are also available in case not all binaries need to be built. `built 3dsx` is currently not available due to conflicts with lpp-3ds's networking features on *hax.

You can also use `make clean` to remove all built files.

##Credits
[Rinnegatamante](https://github.com/Rinnegatamante/) - for making [lpp-3ds](https://github.com/Rinnegatamante/lpp-3ds)

[ksanislo](https://github.com/ksanislo) - for making TitleDB.com

[yellows8](https://github.com/yellows8) - for the base of the Icon and Banner

3DSGuy - for converting the Wii HBLauncher's theme to CWAV

[TitleDB.com](https://titledb.com/) - as Database to pull the apps from

The people from the /hbg/ Discord - Beta testing
