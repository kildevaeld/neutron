//
//  Window.h
//  TestApp2
//
//  Created by Rasmus Kildevæld on 14/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#import "WebViewController.h"
#import <Cocoa/Cocoa.h>
#include <neutron/win.h>

@interface WebViewMessage : NSObject <WKScriptMessageHandler>

- (instancetype)init:(vv_win_t *)w;

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message;

@end

@protocol WindowEventHandler;

@interface MacWindow : NSWindow <NSWindowDelegate> {
  vv_win_t *w;
}

@property(readonly) WebViewController *controller;
@property(readonly) vv_win_t *ptr;

- (instancetype)initWith:(vv_win_t *)win andContentRect:(NSRect)rect;

- (void)windowWillClose:(NSNotification *)notification;

- (void)setListener:(id<WindowEventHandler>)handler;

@end

@protocol WindowEventHandler
- (void)executeEvent:(vv_win_event_t)event onWindow:(MacWindow *)win;
@end

@interface WWFuncEventHandler : NSObject <WindowEventHandler>

- (instancetype)initWith:(vv_win_event_cb)cb;

- (void)executeEvent:(vv_win_event_t)event onWindow:(MacWindow *)win;

@end
