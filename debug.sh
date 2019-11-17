#!/bin/bash

make clean && make package && mv .theos/_/Library/MobileSubstrate/DynamicLibraries/ForceReset.dylib . && ldid -SEntitlements.plist ForceReset.dylib

exit 0
