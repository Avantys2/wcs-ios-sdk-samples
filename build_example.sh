#!/bin/sh

# Get location of the script itself .. thanks SO ! http://stackoverflow.com/a/246128
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
PROJECT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

CONFIGURATION="Release"
PROVISIONING_PROFILE=$1

rm -rf out-build
mkdir out-build

#install deps
pod install

#build and export
xcodebuild -workspace 'WCSExample.xcworkspace' -scheme "TwoWayStreaming" -configuration="Release" clean archive OBJROOT=$(PWD)/out-build/TwoWayStreaming -archivePath out-build/TwoWayStreaming
xcodebuild -exportArchive -exportFormat ipa -archivePath out-build/TwoWayStreaming.xcarchive -exportPath out-build/TwoWayStreaming.ipa -exportProvisioningProfile "$PROVISIONING_PROFILE"

echo "Build complete"

