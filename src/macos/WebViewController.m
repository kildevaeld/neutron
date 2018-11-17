//
//  WebView.m
//  TestApp2
//
//  Created by Rasmus Kildevæld on 14/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#import "WebViewController.h"






@interface WebViewController() {
    WKWebViewConfiguration *_cfg;
    WKWebView *_webView;
    NSMutableDictionary *_callbacks;
}



- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation;

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;

- (void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;

- (void) webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error;

@end

@implementation WebViewController


//- (instancetype)init {
//    if ((self = [super init])) {
//        self->_callbacks = [NSMutableDictionary new];
//    }
//    return self;
//}

- (instancetype)initWith:(WKWebViewConfiguration*)cfg {
    if ((self = [super init])) {
        self->_callbacks = [NSMutableDictionary new];
        self->_cfg = cfg; //[cfg retain];
    }
    return self;
}


- (void) dealloc {
    [self->_cfg release];
    [super dealloc];
}

- (WKWebView *)webView {
    if (self->_webView == nil) {
        NSLog(@"create webview");
        
        self->_webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self->_cfg];
        //[self->_webView autorelease];
        [self->_webView setAutoresizesSubviews: true];
        [self->_webView setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
        [self->_webView setUIDelegate:self];
        [self->_webView setNavigationDelegate:self];
        
        
    }
    return self->_webView;
}


- (void)loadRequest:(NSURLRequest*)request completionHandler: (nullable OpenUrlCompletionHandler)handler {
    id no = [self->_webView loadRequest:request];
    if (handler) {
        NSMutableDictionary *k = [NSMutableDictionary new];
        k[@"request"] = request;
        k[@"handler"] = [handler copy];
        [self->_callbacks setObject:k forKey:@([no hash])];
    }
}




- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error { 
    NSLog(@"Got error %@", error);
}


// UI


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { 
    NSMutableDictionary *k = [self->_callbacks objectForKey:@([navigation hash])];
    
    if (k) {
        OpenUrlCompletionHandler cb = k[@"handler"];
        NSURLRequest *req = k[@"request"];
        cb(req, nil);
        [self->_callbacks removeObjectForKey:@([navigation hash])];
        [req release];
        [k release];
    }
   
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation { 
    ;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSMutableDictionary *k = [self->_callbacks objectForKey:@([navigation hash])];
    
    if (k) {
        OpenUrlCompletionHandler cb = k[@"handler"];
        NSURLRequest *req = k[@"request"];
        cb(req, error);
        [self->_callbacks removeObjectForKey:@([navigation hash])];
        [req release];
        [k release];
        [error release];
    }
}



- (void)evaluateJavaScript:(nonnull NSString *)javaScriptString
         completionHandler:(nullable JavascriptCompletionHandler)handler {
    [self.webView evaluateJavaScript:javaScriptString completionHandler:handler];
}

@end



