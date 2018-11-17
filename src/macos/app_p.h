//
//  app_p.h
//  TestApp2
//
//  Created by Rasmus Kildevæld on 16/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#ifndef app_p_h
#define app_p_h

#import "../win-list.h"
#import "AppDelegate.h"
#import <Cocoa/Cocoa.h>

struct vv_app_s {
  NSAutoreleasePool *pool;
  AppDelegate *delegate;
  winlist_t *wl;
  void *data;
};

#endif /* app_p_h */
