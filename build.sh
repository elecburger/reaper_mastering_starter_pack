#!/bin/bash

RPR_CONFIG_DIR=ME_ReaperStarterPack
RPR_INI_DIR=ini
VERSION=$( cat info/version.txt )

mkdir -p build/tmp
mkdir -p build/release
mkdir -p build/test

# Copy base dir
rm -rf build/tmp/$RPR_CONFIG_DIR
cp -r $RPR_CONFIG_DIR build/tmp

# TODO Create ReaperConfigZip here

# Create .ini files from Reaper import/export files
cp $RPR_CONFIG_DIR/KeyMaps/ImportScripts_MasteringExplained_StarterPack.ReaperKeyMap build/tmp/$RPR_CONFIG_DIR/reaper-kb.ini
cp $RPR_CONFIG_DIR/MenuSets/Toolbar_MasteringExplained_StarterPack.ReaperMenu build/tmp/$RPR_CONFIG_DIR/reaper-menu.ini
cp $RPR_CONFIG_DIR/FXChains/Monitor_FX-Chain_ME_StarterPack.RfxChain build/tmp/$RPR_CONFIG_DIR/reaper-hwoutfx.ini
cp $RPR_CONFIG_DIR/MouseMaps/MouseModifiers_ME_StarterPack.ReaperMouseMap_ITEMFADE build/tmp/$RPR_CONFIG_DIR/reaper-mouse.ini

# Copy .ini files
cp $RPR_INI_DIR/reaper.ini build/tmp/$RPR_CONFIG_DIR/reaper.ini

# Copy license, version, whatsnew and about files
cp LICENSE build/tmp/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/LICENSE
cp info/version.txt build/tmp/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/version.txt
cp info/whatsnew.txt build/tmp/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/whatsnew.txt
cp info/about.txt build/tmp/$RPR_CONFIG_DIR/Scripts/MasteringExplained_StarterPack/lib/about.txt

# Create zip-file
cd build/tmp/
# ZIPNAME=StarterPack-$VERSION.ReaperConfigZip
ZIPNAME=$RPR_CONFIG_DIR-$VERSION.zip
rm ../release/$ZIPNAME
zip -r ../release/$ZIPNAME $RPR_CONFIG_DIR --no-dir-entries -x "**/.DS_Store" -x .DS_Store
cd ../..

# Create test install
cp -R add_to_test/* build/tmp/$RPR_CONFIG_DIR
mv build/tmp/$RPR_CONFIG_DIR build/tmp/$RPR_CONFIG_DIR-$VERSION
