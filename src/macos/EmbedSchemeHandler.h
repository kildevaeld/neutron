//
//  EmbedSchemeHandler.h
//  TestApp2
//
//  Created by Rasmus Kildevæld on 16/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <Webkit/Webkit.h>
#include <neutron/app.h>

@interface EmbedSchemeHandler : NSObject <WKURLSchemeHandler>

- (instancetype)init:(vv_app_t *)app;

- (void)webView:(WKWebView *)webView
    startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask;

- (void)webView:(WKWebView *)webView
    stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask;

@end
