#pragma once

#include "app.h"

typedef struct vv_win_s vv_win_t;

typedef enum vv_win_event_s {
  VV_WIN_DID_CLOSE,
} vv_win_event_t;

typedef void (*vv_webivew_open_url_cb)(vv_win_t *, const char *url,
                                       const char *err);
typedef void (*vv_webview_msg_cb)(vv_win_t *, const char *msg);
typedef void (*vv_webview_eval_js_cb)(vv_win_t *, const char *err);

typedef void (*vv_win_event_cb)(vv_win_t *, vv_win_event_t ev);

vv_win_t *vv_win_create(vv_app_t *app, const char *name);
void vv_win_destroy(vv_win_t *win);
vv_app_t *vv_win_app(vv_win_t *w);
void vv_win_set_data(vv_win_t *app, void *data);
void *vv_win_get_data(vv_win_t *app);

void vv_win_hide(vv_win_t *win);
void vv_win_show(vv_win_t *win);
void vv_win_set_size(vv_win_t *win, int w, int h);
void vv_win_get_size(vv_win_t *win, int *w, int *h);
void vv_win_set_center(vv_win_t *win);

void vv_win_set_title(vv_win_t *win, const char *title);

void vv_win_open_url(vv_win_t *win, const char *url, vv_webivew_open_url_cb cb);
void vv_win_set_message_handler(vv_win_t *win, vv_webview_msg_cb cb);
void vv_win_eval_js(vv_win_t *win, const char *script,
                    vv_webview_eval_js_cb cb);
void vv_win_listen(vv_win_t *win, vv_win_event_cb cb);
void vv_win_send(vv_win_t *win, const char *msg);
