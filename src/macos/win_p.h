//
//  win_p.h
//  TestApp2
//
//  Created by Rasmus Kildevæld on 15/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#ifndef win_p_h
#define win_p_h

#import "MacWindow.h"
#import <Cocoa/Cocoa.h>
#include <neutron/win.h>

struct vv_win_s {
  vv_app_t *app;
  MacWindow *win;
  vv_webview_msg_cb cb;
  void *data;
  const char *name;
};

#endif /* win_p_h */
