//
//  EmbedSchemeHandler.m
//  TestApp2
//
//  Created by Rasmus Kildevæld on 16/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#import "EmbedSchemeHandler.h"

@interface EmbedSchemeHandler() {
    vv_app_t *a;
}

@end

@implementation EmbedSchemeHandler

- (instancetype)init:(vv_app_t *)app {
    if ((self = [self init])) {
        self->a = app;
    }
    return self;
}

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    NSLog(@"started %@", urlSchemeTask);
    [urlSchemeTask didFinish];
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {}

@end
