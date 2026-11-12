XCODEBUILD := xcodebuild
BUILD_FLAGS = -scheme "$(SCHEME)" -destination $(DESTINATION)

SCHEME ?= $(TARGET)-$(PLATFORM)
TARGET ?= Kickstarter-Framework
PLATFORM ?= iOS
RELEASE ?= itunes
# Keep simulator in sync with `Library/TestHelpers/TestCase.swift` and `.circleci/config.yml`
IOS_VERSION ?= 18.6
IPHONE_NAME ?= iPad mini (A17 Pro)
BRANCH ?= main
DIST_BRANCH = $(RELEASE)-dist
COMMIT ?= $(CIRCLE_SHA1)
CURRENT_BRANCH ?= $(CIRCLE_BRANCH)

ifeq ($(PLATFORM),iOS)
	DESTINATION ?= 'platform=iOS Simulator,name=$(IPHONE_NAME),OS=$(IOS_VERSION)'
endif

XCPRETTY_BUILD :=
ifneq ($(CIRCLE_ARTIFACTS),)
	XCPRETTY_BUILD += | tee $${CIRCLE_ARTIFACTS}/xcode_raw_$(SCHEME).log
endif
ifneq ($(shell type -p xcpretty),)
	XCPRETTY_BUILD += | xcpretty -c && exit $${PIPESTATUS[0]}
endif

XCPRETTY_TEST :=
ifneq ($(shell type -p xcpretty),)
	ifneq ($(CIRCLE_ARTIFACTS),)
		XCPRETTY_TEST += | tee $${CIRCLE_ARTIFACTS}/xcode_raw_$(SCHEME).log | xcpretty -c --report junit --output $${CIRCLE_ARTIFACTS}/test_results.xml && exit $${PIPESTATUS[0]}
	else
		XCPRETTY_TEST += | xcpretty -c && exit $${PIPESTATUS[0]}
	endif
endif

build: dependencies
	$(XCODEBUILD) $(BUILD_FLAGS) $(XCPRETTY_BUILD)

test-all: test-app test-modules

test-app:
	PLATFORM=iOS "$(MAKE)" test

test-modules: test-kds test-ksapi test-library test-kickstarter-framework

test-kds:
	PLATFORM=iOS PACKAGE=KDS SCHEME=KDS "$(MAKE)" test-spm

test-ksapi:
	PLATFORM=iOS PACKAGE=KsApi SCHEME=KsApi-Package "$(MAKE)" test-spm

AX_SPECS ?= -only-testing:KsApiTests/CheckoutModuleSpec \
	-only-testing:KsApiTests/BackingModuleSpec \
	-only-testing:KsApiTests/PaymentsModuleSpec \
	-only-testing:KsApiTests/CommentsModuleSpec \
	-only-testing:KsApiTests/AccountModuleSpec \
	-only-testing:KsApiTests/EngagementModuleSpec \
	-only-testing:KsApiTests/AuthModuleSpec \
	-only-testing:KsApiTests/AttributionModuleSpec \
	-only-testing:KsApiTests/MessagingModuleSpec \
	-only-testing:KsApiTests/DiscoveryModuleSpec \
	-only-testing:KsApiTests/CreatorUpdatesModuleSpec \
	-only-testing:KsApiTests/PledgeManagementModuleSpec \
	-only-testing:KsApiTests/SocialModuleSpec \
	-only-testing:KsApiTests/NotificationsModuleSpec \
	-only-testing:KsApiTests/ShippingModuleSpec \
	-only-testing:KsApiTests/RegistryModuleSpec

test-ax: dependencies
	(cd KsApi && $(XCODEBUILD) test -scheme "KsApi-Package" -sdk iphonesimulator -destination $(DESTINATION) $(AX_SPECS) $(XCPRETTY_TEST))
	(cd GraphAPI && $(XCODEBUILD) test -scheme "GraphAPI-Package" -sdk iphonesimulator -destination $(DESTINATION) -only-testing:GraphAPITests/GraphScalarsModuleSpec $(XCPRETTY_TEST))
	(cd Experimentation && $(XCODEBUILD) test -scheme "Experimentation-Package" -sdk iphonesimulator -destination $(DESTINATION) -only-testing:ExperimentationTests/FeatureGatesModuleSpec $(XCPRETTY_TEST))
	(cd KDS && $(XCODEBUILD) test -scheme "KDS" -sdk iphonesimulator -destination $(DESTINATION) -only-testing:KDSTests/DesignTokensModuleSpec $(XCPRETTY_TEST))
	(cd ServerDrivenUI && $(XCODEBUILD) test -scheme "ServerDrivenUI-Package" -sdk iphonesimulator -destination $(DESTINATION) -only-testing:ServerDrivenUITests/RichTextModuleSpec $(XCPRETTY_TEST))

test-ax-all: test-ax
	(cd Library && $(XCODEBUILD) test -scheme "Library-Package" -sdk iphonesimulator -destination $(DESTINATION) -only-testing:Library-Tests/NavigationRouterModuleSpec -only-testing:Library-Tests/LocalStorageModuleSpec -only-testing:Library-Tests/AnalyticsTelemetryModuleSpec $(XCPRETTY_TEST))
	(cd Kickstarter-Framework && $(XCODEBUILD) test -scheme "Kickstarter-Framework" -sdk iphonesimulator -destination $(DESTINATION) -only-testing:Kickstarter-Framework-Tests/AppLifecycleModuleSpec $(XCPRETTY_TEST))

test-library:
	PLATFORM=iOS PACKAGE=Library SCHEME=Library-Package "$(MAKE)" test-spm

test-kickstarter-framework:
	PLATFORM=iOS PACKAGE=Kickstarter-Framework SCHEME=Kickstarter-Framework "$(MAKE)" test-spm

test: bootstrap
	$(XCODEBUILD) test $(BUILD_FLAGS) $(XCPRETTY_TEST)

test-spm: bootstrap
	(cd $(PACKAGE) && $(XCODEBUILD) test -scheme "$(SCHEME)" -sdk iphonesimulator -destination $(DESTINATION) $(XCPRETTY_TEST))

clean:
	$(XCODEBUILD) clean $(BUILD_FLAGS) $(XCPRETTY_BUILD)

dependencies: configs secrets

bootstrap: hooks dependencies

configs = $(basename $(wildcard Kickstarter-iOS/Configs/*.example))
$(configs):
	cp $@.example $@

configs: $(configs)

hooks = $(addprefix .git/,$(wildcard hooks/*))
$(hooks):
	@test -d .git/hooks && ln -fnsv $(patsubst .git/%,$(PWD)/%,$@) $@ \
		|| echo "skipping git hook installation: .git/hooks does not exist" >&2 1>/dev/null

hooks: $(hooks)

deploy:
	@echo "Deploying private/$(BRANCH) to $(RELEASE)..."

	@git fetch oss
	@git fetch private

	@if test -n "`git rev-list private/$(BRANCH)..oss/$(BRANCH)`"; \
	then \
		echo "There are commits in oss/$(BRANCH) that are not in private/$(BRANCH). Please sync the remotes before deploying."; \
		exit 1; \
	fi
	@if test "$(RELEASE)" != "itunes"; \
	then \
		echo "RELEASE must be 'itunes'."; \
		exit 1; \
	fi
	@if test "$(RELEASE)" = "itunes" && test "$(BRANCH)" != "main"; \
	then \
		echo "BRANCH must be 'main' for iTunes releases."; \
		exit 1; \
	fi

	@git branch -f $(DIST_BRANCH) private/$(BRANCH)
	@git push -f private $(DIST_BRANCH)
	@git branch -d $(DIST_BRANCH)

	@echo "Deploy has been kicked off to CircleCI!"

alpha:
	@echo "Adding remotes..."
	@git remote add oss https://github.com/kickstarter/ios-oss
	@git remote add private https://github.com/kickstarter/ios-private

	@echo "Deploying private/alpha-dist-$(CURRENT_BRANCH)-$(COMMIT)..."

	@git branch -f alpha-dist-$(CURRENT_BRANCH)-$(COMMIT)
	@git push -f private alpha-dist-$(CURRENT_BRANCH)-$(COMMIT)
	@git branch -d alpha-dist-$(CURRENT_BRANCH)-$(COMMIT)

	@echo "Deploy has been kicked off to CircleCI!"

beta:
	@echo "Adding remotes..."
	@git remote add oss https://github.com/kickstarter/ios-oss
	@git remote add private https://github.com/kickstarter/ios-private

	@echo "Deploying private/beta-dist-$(COMMIT)..."

	@git branch -f beta-dist-$(COMMIT)
	@git push -f private beta-dist-$(COMMIT)
	@git branch -d beta-dist-$(COMMIT)

	@echo "Deploy has been kicked off to CircleCI!"

sync:
	@echo "Syncing oss and private remotes..."

	@git checkout $(BRANCH)
	@git pull oss $(BRANCH)
	@git push private $(BRANCH)

	@echo "private and oss remotes are now synced!"

cleanup:
	@echo "Adding remotes..."
	@git remote add oss git@github.com:kickstarter/ios-oss
	@git remote add private git@github.com:kickstarter/ios-private

	@echo "Deleting temporary branch: $(CIRCLE_BRANCH)"

	@git push -d private $(CIRCLE_BRANCH)

strings:
	cp Frameworks/native-secrets/ios/Secrets.swift bin/StringsScript/Sources/StringsScriptCore
	./bin/strings-script "./Library/Sources/Library/Library/Strings.swift" "./Library/Sources/Library/Resources/Locales"

secrets:
	-@rm -rf Frameworks/native-secrets
	-@git clone git@github.com:kickstarter/native-secrets Frameworks/native-secrets 2>/dev/null || echo '(Skipping secrets.)'
	if [ ! -d Frameworks/native-secrets ]; \
	then \
		mkdir -p Frameworks/native-secrets/ios \
		&& cp -n Configs/Secrets.swift.example Frameworks/native-secrets/ios/Secrets.swift \
		&& cp -n Configs/Secrets.swift.example KsApi/Sources/KsApi/Secrets.swift \
		|| true; \
	else \
		cp -n Frameworks/native-secrets/ios/Secrets.swift KsApi/Sources/KsApi/Secrets.swift || true; \
	fi

.PHONY: test-all test clean dependencies submodules deploy secrets strings
