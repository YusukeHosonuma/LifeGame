build:
	swift build

test:
	swift test --enable-test-discovery --enable-code-coverage

xcode:
	swift package generate-xcodeproj
