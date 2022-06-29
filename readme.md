# The Mastering Starter Pack for Reaper

A configuration for the [Reaper DAW](https://www.reaper.fm) made for learning audio mastering. It is primarily used in the online course [Audio Mastering Fundamentals](https://www.masteringexplained.com/mastering-course/).

The starter pack is distributed as a portable installation of Reaper without the [Reaper binaries](https://www.reaper.fm/download.php). 

## Features

* Automated loudness matching
* A project template for mastering
* Tweaked settings and custom scripts that will improve the mastering workflow
* A custom toolbar to help you get started in Reaper

## Building

The building process will produce a zip file with the directory containing the portable installation. Pre-built zip-files and installation instructions can be [found here](https://www.masteringexplained.com/starterpack/).

The zip file is built by a bash script. This is only tested on MacOS, but might work in Linux or Windows (using WSL) as well. 

1. Clone the repo and enter the directory

```
git clone ...
cd reaper_mastering_starter_pack
```

2. The build script will leave a copy of the installation directory under `build/test/`. Files in the `add_to_test/` directory will also be added to this test directory. Place for example `REAPER.app/`, `reaper-vstplugins64.ini` etc here to be able to quickly test the build. This is optional.

```
reaper_mastering_starter_pack/
├── add_to_test/
    ├── REAPER.app/
    ├── reaper-auplugins64-bc.ini
    ├── reaper-auplugins64.ini
    ├── reaper-vstplugins64.ini
    ├── reaper-vstshells64.ini
```

3. Run the build script

```
./build.sh
```

4. If all goes well, the zip file can be found in `build/release/` and the test installation directory in `build/test/`.

