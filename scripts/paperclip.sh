#!/usr/bin/env bash

(
set -e
basedir="$(cd "$1" && pwd -P)"
workdir="$basedir/base/Paper/"
mcver=$(cat "$workdir/BuildData/info.json" | grep minecraftVersion | cut -d '"' -f 4)
paperjar="$basedir/ArcadePaper-Server/target/arcadepaper-$mcver-R0.1-SNAPSHOT.jar"
vanillajar="$workdir/work/$mcver/$mcver.jar"

(
    cd "$basedir/Paperclip"
    mvn clean package "-Dmcver=$mcver" "-Dpaperjar=$paperjar" "-Dvanillajar=$vanillajar"
)
cp "$basedir/Paperclip/assembly/target/paperclip-${mcver}.jar" "$basedir/arcade-paperclip.jar"

echo ""
echo ""
echo ""
echo "Build success!"
echo "Copied final jar to $(cd "$basedir" && pwd -P)/arcade-paperclip.jar"
) || exit 1