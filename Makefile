SDK_VERSION=4.3
SDK=/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator$(SDK_VERSION).sdk/

TODAY:=$(shell date +"%Y%m%d")
TARGET:="bertha:/home/fermigier/public_public_html/iNuxeo"

.PHONY: build test clean zip push

test:
	xcodebuild -target "Unit Tests" -sdk $(SDK) -configuration "Debug"

build:
	xcodebuild -target "iNuxeo" -sdk $(SDK) -configuration "Release"

clean:
	rm -rf build *~

zip:
	cd build/Release-iphoneos/ ; zip -r iNuxeo-$(TODAY).zip iNuxeo.app

push: zip
	rsync -e ssh -avz build/Release-iphoneos/iNuxeo-$(TODAY).zip \
		$(TARGET)

