
#Homebr3w
Download and install Homebrew Apps for 3ds easily! App based on [lpp-3ds](https://github.com/Rinnegatamante/lpp-3ds)

##Usage
Simply download the .cia file from the [releases page](/releases) and install it with your favorite .cia Installer, for example FBI. You can also just scan the QR Code from the releases page as well.

You can also use the .3ds version for a flashcard or the .3dsx version for *hax.

Note: The .3dsx version does not support launching freeShop through it, the option is disabled.

##Build instructions
The building is made possible through a `make` script, meaning you need to have `make` installed and in your path. If you already use devkitArm then you are good to go

Just run `make` (or `make all`/`make build`) to get your binaries in the build directory

`build 3ds`, `build 3dsx` and `build cia` are also available in case not all binaries need to be built.

You can also use `make clean` to remove all built files.

##Additional help
Need help with the tool? Or maybe you'd like to modify it but have no idea how or where to start? Join [This Discord channel ![](https://discordapp.com/api/servers/175668882231525376/widget.png)](https://discord.gg/AfwuX4K) which I usually hang out with and ask away, I am always happy to help.

##Credits

[Rinnegatamante](https://github.com/Rinnegatamante/) - for making [lpp-3ds](https://github.com/Rinnegatamante/lpp-3ds)

[ksanislo](https://github.com/ksanislo) - for making TitleDB.com

[yellows8](https://github.com/yellows8) - for the base of the Icon and Banner

3DSGuy - for converting the Wii HBLauncher's theme to CWAV

[TitleDB.com](https://titledb.com/) - as Database to pull the apps from

[The people from the /hbg/ Discord](https://discord.gg/0ypvBFONRRBuHD2d) - Beta testing
