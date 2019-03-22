//
//  Window.m
//  TestApp2
//
//  Created by Rasmus Kildevæld on 14/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#import "MacWindow.h"
#import "WebViewController.h"
#import "MacWindow.h"
#import "win_p.h"
#import "EmbedSchemeHandler.h"

@interface WebViewMessage() {
    vv_win_t *w;
}

@end


@implementation WebViewMessage



- (instancetype)init:(vv_win_t*)w {
    if ((self = [super init])) {
        self->w = w;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self->w->cb) {
        self->w->cb(self->w,[message.body UTF8String]);
    }
}

@end



@interface MacWindow() {
    //vv_win_t *w;
    WebViewController *ctrl;
    id<WindowEventHandler> *cb;
    NSMutableDictionary *callbacks;
    NSMapTable *callbacks2;
}

- (void)commonInit:(NSRect)contentRect;

@end

@implementation MacWindow

@synthesize controller = ctrl;
@synthesize ptr = w;




- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag {
    if ((self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag])) {
        [self commonInit:contentRect];
    }
    return self;
    
}

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag screen:(NSScreen *)screen {
    if ((self = [super initWithContentRect:contentRect styleMask:style backing:backingStoreType defer:flag screen:screen])) {
        [self commonInit:contentRect];
    }
    return self;
}

- (instancetype)initWith:(vv_win_t*)win andContentRect: (NSRect)rect {
    unsigned int style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
    NSWindowStyleMaskMiniaturizable;
    //if (w->resizable) {
    style = style | NSWindowStyleMaskResizable;
    
    if ((self = [super initWithContentRect:rect styleMask:style backing:NSBackingStoreBuffered defer:false])) {
        self->w = win;
        [self commonInit:rect];
    }
    
    return self;
}

// - (void)awakeFromNib {
//     NSLog(@"Awake from nib");
//     for (id child in self.contentView.subviews) {
//         [child removeFromSuperview];
//     }
//     self->ctrl.webView.frame = self.contentView.bounds;
//     [self.contentView addSubview:self->ctrl.webView];
// }


- (void)commonInit:(NSRect)contentRect {
    
    WKWebViewConfiguration *cfg = [WKWebViewConfiguration new];
    WebViewMessage *msg = [[WebViewMessage alloc] init:self->w];
    
    WKUserContentController *user = [[WKUserContentController alloc] init];
    
    WKUserScript *script = [[WKUserScript alloc] initWithSource:@"window.external = this; invoke = function(arg){ webkit.messageHandlers.channel.postMessage(arg); };" injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:false];
    
    EmbedSchemeHandler *hld = [[EmbedSchemeHandler alloc] init:vv_win_app(self->w)];
    [cfg setURLSchemeHandler:hld forURLScheme:@"embed"];
    
    [user addUserScript:script];
    [user addScriptMessageHandler:msg name:@"channel"];
    //[msg release];
    [cfg setUserContentController:user];
    
    self->ctrl = [[WebViewController alloc] initWith:cfg];
    [self->ctrl.webView setFrame:contentRect];
    [[self contentView] addSubview: self->ctrl.webView];
    [self orderFrontRegardless];
    self->callbacks = [NSMutableDictionary new];
    self.delegate = self;
}



- (void)dealloc {
    NSLog(@"release");
    [self.controller release];
    for (id object in self->callbacks) {
        [object release];
    }
    [self->callbacks  release];
    [super dealloc];
}


- (void)windowWillClose:(NSNotification *)notification {    
    if (self->cb) {
        [self->cb executeEvent:VV_WIN_DID_CLOSE onWindow:self];
    }
}

- (void)setListener:(id<WindowEventHandler>)handler {
    self->cb = handler;
}

@end

@interface WWFuncEventHandler() {
    vv_win_event_cb cb;
}

@end


@implementation WWFuncEventHandler


- (void)executeEvent:(vv_win_event_t)event onWindow:(MacWindow *)win { 
    self->cb(win.ptr,event);
}

- (instancetype)initWith:(vv_win_event_cb)cb {
    if ((self = [super init])) {
        self->cb = cb;
    }
    return self;;
}

- (void)dealloc {
    [super dealloc];
    NSLog(@"dealloc from window event a");
}

@end
