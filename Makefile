
.PHONY: format
format:
	swiftgen
	synx TimeBoxed.xcodeproj
	swiftlint autocorrect

.PHONY:	beta
beta:
	fastlane beta

