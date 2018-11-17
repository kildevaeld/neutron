//
//  AppDelegate.m
//  TestApp2
//
//  Created by Rasmus Kildevæld on 14/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#import "AppDelegate.h"
#import "MacWindow.h"


@interface AppDelegate (){
    vv_app_t *a;
    AppEventHandler h;
}
@end

@implementation AppDelegate


- (instancetype)init:(vv_app_t *)app {
    
    if ((self = [self init])) {
        self->a = app;
    }
    
    return self;
}

- (void)setListener:(AppEventHandler)handler {
    self->h = [handler copy];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (self->h) {
        self->h(VV_APP_EVENT_DID_FINISH);
    }
}

- (void) dealloc {
    [super dealloc];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    if (self->h) {
        self->h(VV_APP_EVENT_WILL_TERMINATE);
    }
}


@end
