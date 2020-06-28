#!/bin/bash

TXTCOLOR_DEFAULT="\033[0;m"
TXTCOLOR_GREEN="\033[0;32m"
TXTCOLOR_RED='\033[0;31m'
TXTCOLOR_YELLOW='\x1b[33m'

FRAMEWORK=$1
FLAVOR=$2

rm -rf build &> /dev/null

echo -e $TXTCOLOR_GREEN"➤_ Compiling iphonesimulator ..."$TXTCOLOR_DEFAULT
xcodebuild -configuration "Release" -target "$FRAMEWORK" -sdk iphonesimulator
if [[ ! $? -eq 0 ]];then
    exit 1
fi

echo -e $TXTCOLOR_GREEN"➤_ Compiling iphoneos ..."$TXTCOLOR_DEFAULT
xcodebuild -configuration "Release" -target "$FRAMEWORK" -sdk iphoneos
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

echo -e $TXTCOLOR_GREEN"➤_ Framework path: $(pwd)/Product/$FRAMEWORK.framework"$TXTCOLOR_DEFAULT