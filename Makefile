
.PHONY: format
format:
	swiftgen
	synx TimeBoxed.xcodeproj
	swift-format format --in-place --recursive TimeBoxed

.PHONY:	beta
beta:
	fastlane beta

