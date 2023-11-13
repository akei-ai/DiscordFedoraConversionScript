#!/bin/bash
# Script was based on Valinwolf's post on Discord Community Forums
# See https://support.discord.com/hc/en-us/community/posts/360039113131/comments/360004958612
# This script modifies the commands so that it is more automated and doesn't break as much with
# any Discord updates

# Being safe and not touching the ~/ directory
mkdir ~/Discord-RPM-Build
cd ~/Discord-RPM-Build || exit 1
rm -rf ~/Discord-RPM-Build/*
# Create Cache to Download the current Discord Debian Package
mkdir cache
wget 'https://discordapp.com/api/download?platform=linux&format=deb' -O cache/discord.deb

fakeroot alien --scripts -r -v -g cache/discord.deb

# Clear cache after use
rm -rf cache

# Know where the current location
DISCORD_FOLDER_LOCATION=$(pwd)/$(ls -d -- *iscord*)
DISCORD_SPEC_LOCATION=$(ls -d  "$DISCORD_FOLDER_LOCATION"/discord*.spec)

echo '#############################################################'
echo "Folder is located at: $DISCORD_FOLDER_LOCATION"
echo "Alien is located at : $DISCORD_SPEC_LOCATION"
echo '#############################################################'


# Execute said sed commands

fakeroot sed -i 's#%dir "/"##' "$DISCORD_SPEC_LOCATION"
fakeroot sed -i 's#%dir "/usr/bin/"##' "$DISCORD_SPEC_LOCATION"
# Finally, Build the package from the rubble
cd "$DISCORD_FOLDER_LOCATION" || exit 1
echo '#############################################################'
echo 'Commencing Discord Deb -> RPM. This should take a while'
echo '#############################################################'
sleep 5
fakeroot rpmbuild --target=x86_64 --buildroot "$DISCORD_FOLDER_LOCATION" -bb "$DISCORD_SPEC_LOCATION"
# Installation of said commands
DISCORD_RPM_LOCATION=~$(ls ~/Discord-RPM-Build/discord*.rpm)
echo '#############################################################'
echo 'Build Complete. Installing. sudo will ask for your password'
echo 'Wait for a few seconds'
echo "RPM Location : $DISCORD_RPM_LOCATION"
echo '#############################################################'
sleep 5

sudo yum install "$DISCORD_RPM_LOCATION"

echo '#############################################################'
echo 'Discord should now be installed'
echo '#############################################################'



exit 0