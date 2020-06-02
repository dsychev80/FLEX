#!/bin/bash

FRAMEWORK=$1

rm -rf build &> /dev/null

xcodebuild -configuration "Release" -target "$FRAMEWORK" -sdk iphonesimulator

xcodebuild -configuration "Release" -target "$FRAMEWORK" -sdk iphoneos

mkdir -p Product/$FRAMEWORK.framework

cp -r build/Release-iphoneos/$FRAMEWORK.framework/Headers Product/$FRAMEWORK.framework
cp -r build/Release-iphoneos/$FRAMEWORK.framework/PrivateHeaders Product/$FRAMEWORK.framework &> /dev/null
cp -r build/Release-iphoneos/$FRAMEWORK.framework/Modules Product/$FRAMEWORK.framework &> /dev/null
cp build/Release-iphoneos/$FRAMEWORK.framework/Info.plist Product/$FRAMEWORK.framework &> /dev/null

lipo -create build/Release-iphoneos/$FRAMEWORK.framework/$FRAMEWORK build/Release-iphonesimulator/$FRAMEWORK.framework/$FRAMEWORK -output Product/$FRAMEWORK.framework/Fatbuild

xcrun bitcode_strip -r Product/$FRAMEWORK.framework/Fatbuild -o Product/$FRAMEWORK.framework/$FRAMEWORK
rm Product/$FRAMEWORK.framework/Fatbuild