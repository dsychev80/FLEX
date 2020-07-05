#!/bin/bash

TXTCOLOR_DEFAULT="\033[0;m"
TXTCOLOR_GREEN="\033[0;32m"
TXTCOLOR_RED='\033[0;31m'
TXTCOLOR_YELLOW='\x1b[33m'

FRAMEWORK="${1}"
MACH_O=$2 # mh_dylib, staticlib
if [[ -z "$MACH_O" ]];then
    MACH_O=staticlib
fi

echo -e $TXTCOLOR_GREEN"➤_ Building with mach-o ${MACH_O}"$TXTCOLOR_DEFAULT

rm -rf build &> /dev/null
rm -rf Product &> /dev/null

echo -e $TXTCOLOR_GREEN"➤_ Compiling iphonesimulator ..."$TXTCOLOR_DEFAULT
xcodebuild -configuration "Release" -target "${FRAMEWORK}" -sdk iphonesimulator MACH_O_TYPE=$MACH_O | xcpretty
if [[ ! $? -eq 0 ]]; then
    exit 1
fi
  
echo -e $TXTCOLOR_GREEN"➤_ Compiling iphoneos ..."$TXTCOLOR_DEFAULT
xcodebuild -configuration "Release" -target "$FRAMEWORK" -sdk iphoneos MACH_O_TYPE=$MACH_O | xcpretty
if [[ ! $? -eq 0 ]];then
    exit 1
fi

mkdir -p Product/$FRAMEWORK.framework

cp -r build/Release-iphoneos/$FRAMEWORK.framework/Headers Product/$FRAMEWORK.framework
cp -r build/Release-iphoneos/$FRAMEWORK.framework/PrivateHeaders Product/$FRAMEWORK.framework &> /dev/null
cp -r build/Release-iphoneos/$FRAMEWORK.framework/Modules Product/$FRAMEWORK.framework &> /dev/null
cp build/Release-iphoneos/$FRAMEWORK.framework/Info.plist Product/$FRAMEWORK.framework &> /dev/null

lipo -create build/Release-iphoneos/$FRAMEWORK.framework/$FRAMEWORK build/Release-iphonesimulator/$FRAMEWORK.framework/$FRAMEWORK -output Product/$FRAMEWORK.framework/Fatbuild

xcrun bitcode_strip -r Product/$FRAMEWORK.framework/Fatbuild -o Product/$FRAMEWORK.framework/$FRAMEWORK
rm Product/$FRAMEWORK.framework/Fatbuild

# Save history
touch Product/$FRAMEWORK.framework/fmwk.history
echo "$(git remote -v | awk 'NR == 1 {print $2}')" >> Product/$FRAMEWORK.framework/fmwk.history
echo "$(git rev-parse --short HEAD)" >> Product/$FRAMEWORK.framework/fmwk.history
echo "$(git rev-parse --abbrev-ref HEAD)" >> Product/$FRAMEWORK.framework/fmwk.history
echo "$(date)" >> Product/$FRAMEWORK.framework/fmwk.history
md5 -q Product/$FRAMEWORK.framework/$FRAMEWORK >> Product/$FRAMEWORK.framework/fmwk.history

echo -e $TXTCOLOR_GREEN"➤_ Framework path: $(pwd)/Product/$FRAMEWORK.framework"$TXTCOLOR_DEFAULT