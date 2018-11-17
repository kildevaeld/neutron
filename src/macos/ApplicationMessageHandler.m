//
//  ApplicationMessageHandler.m
//  TestApp2
//
//  Created by Rasmus Kildevæld on 16/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#import "ApplicationMessageHandler.h"

@interface ApplicationMessageHandler() {
    vv_app_t *a;
}

@end

@implementation ApplicationMessageHandler

- (instancetype)init:(vv_app_t*)a {
    if ((self = [super init])) {
        self->a = a;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

@end
