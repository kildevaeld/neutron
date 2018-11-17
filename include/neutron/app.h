#pragma once

typedef struct vv_app_s vv_app_t;

typedef enum vv_app_event_s {
  VV_APP_EVENT_DID_FINISH,
  VV_APP_EVENT_WILL_TERMINATE,
} vv_app_event_t;

typedef void (*vv_dispatch_cb)(vv_app_t *w, void *arg);
typedef void (*vv_app_event_cb)(vv_app_t *a, vv_app_event_t event, void *data);

vv_app_t *vv_app_create(void);
void vv_app_destroy(vv_app_t *app);

void vv_app_set_data(vv_app_t *a, void *data);
void *vv_app_get_data(vv_app_t *a);

void vv_app_run(vv_app_t *app);
void vv_app_dispatch(vv_app_t *app, vv_dispatch_cb cb, void *data);
void vv_app_listen(vv_app_t *app, vv_app_event_cb cb);

void vv_app_terminate(vv_app_t *app);
