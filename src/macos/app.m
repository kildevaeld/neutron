//
//  app.c
//  TestApp2
//
//  Created by Rasmus Kildevæld on 15/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#if ! __has_feature(objc_arc)
///  #error "ARC is off"
#endif

#include <stdio.h>
#include <neutron/app.h>
#include "app_p.h"
#include "../win-list.h"
#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"


struct app_dispatch_arg {
    vv_dispatch_cb fn;
    struct vv_app_s *app;
    void *arg;
};


vv_app_t *vv_app_create() {
    vv_app_t *a = malloc(sizeof(struct vv_app_s));
    memset(a, 0, sizeof(struct vv_app_s));
    a->pool = [NSAutoreleasePool new];
    a->delegate = [[AppDelegate alloc] init:a];
    
    [[NSApplication sharedApplication] setDelegate:a->delegate];
    
    return a;
}


void vv_app_set_data(vv_app_t *a, void *data) {
    if (!a) return;
    a->data = data;
}


void *vv_app_get_data(vv_app_t *a) {
    if (!a) return NULL;
    return a->data;
}


void vv_app_run(vv_app_t *app) {
    [[NSApplication sharedApplication] run];
}

void vv_app_listen(vv_app_t *app, vv_app_event_cb cb) {
    if (!app) return;
    [app->delegate setListener:^(vv_app_event_t ev) {
        cb(app, ev, NULL);
    }];
    
}


static void webview_dispatch_cb(void *arg) {
    struct app_dispatch_arg *context = (struct app_dispatch_arg *)arg;
    (context->fn)(context->app, context->arg);
    free(context);
}

void vv_app_dispatch(vv_app_t *app, vv_dispatch_cb fn, void *arg) {
    struct app_dispatch_arg *context = (struct app_dispatch_arg *)malloc(sizeof(struct app_dispatch_arg));
    context->app = app;
    context->arg = arg;
    context->fn = fn;
    dispatch_async_f(dispatch_get_main_queue(), context, webview_dispatch_cb);
}


void vv_app_destroy(vv_app_t *app) {
    if (!app) return;
    [app->pool release];
    app->pool = nil;
    free(app);
}

void vv_app_terminate(vv_app_t *app) {
    win_list_free(app->wl, true);
    [[NSApplication sharedApplication] terminate:nil];
}
