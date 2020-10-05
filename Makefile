
.PHONY: format
format:
	swift-format format --in-place --recursive TimeBoxed

.PHONY:	beta
beta:
	fastlane beta

