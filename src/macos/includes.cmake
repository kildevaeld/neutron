

set(SOURCES
    macos/app.m
    macos/AppDelegate.m
    macos/ApplicationMessageHandler.m
    #macos/EmbedSchemeHandler.m
    macos/MacWindow.m
    macos/WebViewController.m
    macos/win.m
)

set(LIBRARIES
    "-framework Cocoa"
    "-framework AppKit"
    "-framework Foundation"
    "-framework WebKit"
)