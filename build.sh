#!/bin/bash

RPR_CONFIG_DIR=ME_ReaperStarterPack
RPR_INI_DIR=ini

if [ $1 ] && [ $1 = "test" ] 
then
  SUFFIX="-$( date +%Y%m%d%H%M%S )"
fi

VERSION=$( cat info/version.txt )$SUFFIX

mkdir -p build/test
mkdir -p build/release
mkdir -p build/test
mkdir -p add_to_test

# Copy base dir
rm -rf build/test/$RPR_CONFIG_DIR
cp -r $RPR_CONFIG_DIR build/test

# Copy license, version, whatsnew and about files
cp LICENSE build/test/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/LICENSE
cp info/version.txt build/test/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/version.txt
cp info/whatsnew.txt build/test/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/whatsnew.txt
cp info/about.txt build/test/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/about.txt

# Create ReaperConfigZip
ZIPNAME=$RPR_CONFIG_DIR-Update-$VERSION.ReaperConfigZip
rm build/release/$ZIPNAME
cd build/test/$RPR_CONFIG_DIR
zip -r ../../release/$ZIPNAME . --no-dir-entries -x "**/.DS_Store" -x .DS_Store
# cd ..
cd ../../..

# Create .ini files from Reaper import/export files
cp $RPR_CONFIG_DIR/KeyMaps/ImportScripts_MasteringExplained_StarterPack.ReaperKeyMap build/test/$RPR_CONFIG_DIR/reaper-kb.ini
cp $RPR_CONFIG_DIR/MenuSets/Toolbar_MasteringExplained_StarterPack.ReaperMenu build/test/$RPR_CONFIG_DIR/reaper-menu.ini
cp $RPR_CONFIG_DIR/FXChains/Monitor_FX-Chain_ME_StarterPack.RfxChain build/test/$RPR_CONFIG_DIR/reaper-hwoutfx.ini
cp $RPR_CONFIG_DIR/MouseMaps/MouseModifiers_ME_StarterPack.ReaperMouseMap build/test/$RPR_CONFIG_DIR/reaper-mouse.ini

# Copy .ini files
cp $RPR_INI_DIR/reaper.ini build/test/$RPR_CONFIG_DIR/reaper.ini
cp $RPR_INI_DIR/reaper-metadata.ini build/test/$RPR_CONFIG_DIR/reaper-metadata.ini

# Copy license, version, whatsnew and about files
cp LICENSE build/test/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/LICENSE
cp info/version.txt build/test/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/version.txt
cp info/whatsnew.txt build/test/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/whatsnew.txt
cp info/about.txt build/test/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/about.txt

# Create zip-file
cd build/test/
# ZIPNAME=StarterPack-$VERSION.ReaperConfigZip
ZIPNAME=$RPR_CONFIG_DIR-$VERSION.zip
rm ../release/$ZIPNAME
zip -r ../release/$ZIPNAME $RPR_CONFIG_DIR --no-dir-entries -x "**/.DS_Store" -x .DS_Store
cd ../..

# Create test install
cp -R add_to_test/* build/test/$RPR_CONFIG_DIR
mv build/test/$RPR_CONFIG_DIR build/test/$RPR_CONFIG_DIR-$VERSION
