.PHONY: clean firebase migrate gen build_android_dev  build_android_prod build_ios_dev build_ios_prod help

# Variables
file := pubspec.yaml
version := $(shell yq e '.environment.flutter' ${file})

##@
##@ Clean commands and install dependencies
##@

clean:  ##@ clean project and run pub get
	fvm flutter clean && fvm flutter pub get

icon:  ##@ generate app icons
	 fvm flutter pub run flutter_launcher_icons:main

firebase: ##@ install firebase CLI and configure project for firebase (run after make migrate)
	dart pub global activate flutterfire_cli && flutterfire configure


migrate: ##@ install fvm and migrate to flutter version in pubspec.yaml 
	dart pub global activate fvm && fvm install $(version) && fvm use $(version) && fvm flutter doctor && make clean


gen: ##@ generate code using build_runner and delete conflicting outputs
	fvm flutter pub run build_runner build --delete-conflicting-outputs

loc: ##@ generate localization files
	fvm flutter pub global run intl_utils:generate

watch: ##@ generate code using build_runner and delete conflicting outputs
	fvm flutter pub run build_runner watch --delete-conflicting-outputs


##@
##@ Build commands
##@

build_android_dev: ##@ build android debug (dev)
	fvm flutter build apk --debug

build_android_prod: ##@ build android release (prod)
	fvm flutter build apk --release

build_ios_dev:  ##@ build ios debug (dev)
	fvm flutter build ios --debug

build_ios_prod: ##@ build ios release (prod)
	fvm flutter build ios --release



##@
##@ Misc commands
##@


################################################################################
# Help target
################################################################################
help: ##@ (Default) Print listing of key targets with their descriptions
	@printf "\nUsage: make <command>\n"
	@grep -F -h "##@" $(MAKEFILE_LIST) | grep -F -v grep -F | sed -e 's/\\$$//' | awk 'BEGIN {FS = ":*[[:space:]]*##@[[:space:]]*"}; \
	{ \
		if($$2 == "") \
			printf ""; \
		else if($$0 ~ /^#/) \
			printf "\n%s\n", $$2; \
		else if($$1 == "") \
			printf "     %-20s%s\n", "", $$2; \
		else \
			printf "\n    \033[34m%-20s\033[0m %s\n", $$1, $$2; \
	}'