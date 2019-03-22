//
//  WebView.h
//  TestApp2
//
//  Created by Rasmus Kildevæld on 14/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Webkit/Webkit.h>

// typedef void (*ContentLoadedCB)(void);

// typedef enum {
//    vv_webview_nav_started_ev,
//    vv_webview_nav_commited_ev,
//    vv_webview_nav_javascript_ev,
//} vv_webview_event_t;

typedef void (^OpenUrlCompletionHandler)(NSURLRequest *__nonnull,
                                         NSError *__nullable);
typedef void (^JavascriptCompletionHandler)(id __nullable, NSError *__nullable);

@interface WebViewController : NSObject <WKUIDelegate, WKNavigationDelegate>

- (instancetype)initWith:(WKWebViewConfiguration *_Nonnull)cfg;

- (nonnull WKWebView *)webView;

- (void)loadRequest:(nonnull NSURLRequest *)request
    completionHandler:(nullable OpenUrlCompletionHandler)handler;

- (void)evaluateJavaScript:(nonnull NSString *)javaScriptString
         completionHandler:(nullable JavascriptCompletionHandler)handler;

@end
