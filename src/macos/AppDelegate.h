//
//  AppDelegate.h
//  TestApp2
//
//  Created by Rasmus Kildevæld on 14/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <neutron/app.h>

typedef void (^AppEventHandler)(vv_app_event_t ev);

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(readonly) vv_app_t *app;

- (instancetype)init:(vv_app_t *)app;

- (void)setListener:(AppEventHandler)handler;

@end
