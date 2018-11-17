//
//  win.c
//  TestApp2
//
//  Created by Rasmus Kildevæld on 15/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#include <stdio.h>
#include <neutron/win.h>
#include "MacWindow.h"
#import <Cocoa/Cocoa.h>
#include "win_p.h"
#include "app_p.h"



vv_win_t *vv_win_create(vv_app_t *app, const char *name) {
    struct vv_win_s *w = malloc(sizeof(struct vv_win_s));
    memset(w, 0, sizeof(struct vv_win_s));
    w->app = app;
    if (app->wl) {
        app->wl = win_list_append(app->wl, w);
    } else {
        app->wl = win_list_create(w);
    }
    w->win = [[MacWindow alloc] initWith:w andContentRect:NSMakeRect(0,0,800,600)];
    if (name) {
        w->name = strdup(name);
    }
    
    return (vv_win_t*)w;
}

void vv_win_destroy(vv_win_t *w) {
    if (!w) return;
    w->app->wl = win_list_remove(w->app->wl, w);
    [w->win close];
    [w->win release];
    if (w->name) free((void *)w->name);
    free(w);
}

vv_app_t *vv_win_app(vv_win_t *w) {
    if (!w) return NULL;
    return w->app;
}

void vv_win_set_data(vv_win_t *w, void * data) {
    if (!w) return;
    w->data = data;
}
void *vv_win_get_data(vv_win_t *w) {
    if (!w) return NULL;
    return w->data;
}


void vv_win_hide(vv_win_t *win) {
    if (!win) return;
    [win->win orderOut:win->win];

}

void vv_win_show(vv_win_t *win) {
    if (!win) return;
    [win->win makeKeyAndOrderFront:win->win];
    [NSApp activateIgnoringOtherApps:YES];
}

void vv_win_set_size(vv_win_t *win, int w, int h) {
    NSRect frame = win->win.frame;
    frame.size = CGSizeMake((CGFloat)w, (CGFloat)h);
    [win->win setFrame:frame display:YES];
}
void vv_win_get_size(vv_win_t *win, int *w, int *h) {}

void vv_win_set_center(vv_win_t *win) {
    [win->win center];
}

void vv_win_set_title(vv_win_t *win, const char *title) {
    [win->win setTitle:@(title)];
}


void vv_win_open_url(vv_win_t *win, const char *u, vv_webivew_open_url_cb cb) {
    if (!win) return;
    
    printf("URL %s\n", u);
    NSString *urls = @(u);
    NSURL *url = [NSURL URLWithString:urls];
    //[urls release];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    //[url release];
    
    [win->win.controller loadRequest:req completionHandler:^(NSURLRequest * _Nonnull req, NSError * _Nullable err) {
     if (cb) {
        cb(win, req.URL.absoluteString.UTF8String, err.description.UTF8String);
     }
    }];
    
    //[req release];
    
}


void vv_win_set_message_handler(vv_win_t *win, vv_webview_msg_cb cb) {
    if (!win) return;
    win->cb = cb;
}

void vv_win_eval_js(vv_win_t *win, const char *script, vv_webview_eval_js_cb cb) {
     if (!win) return;
    NSString *s = [NSString stringWithUTF8String:script];
    [win->win.controller evaluateJavaScript:s completionHandler:^(id _Nullable data, NSError * _Nullable err) {
     if (cb) {
     cb(win, err ? err.description.UTF8String : NULL);
     }
    }];
}

void vv_win_listen(vv_win_t *win, vv_win_event_cb cb) {
    if (!win) return;
    [win->win setListener:[[WWFuncEventHandler alloc] initWith:cb]];
}

void vv_win_send(vv_win_t *win, const char *msg) {
    NSString *str = [NSString stringWithFormat:@"if (typeof window.external.onmessage === 'function') { window.external.onmessage(\"%s\"); }", msg];
    [win->win.controller evaluateJavaScript:str completionHandler:nil];
}

