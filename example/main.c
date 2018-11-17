#include <neutron/neutron.h>
#include <stdio.h>

void on_url_loaded(vv_win_t *win, const char *url, const char *err) {
  vv_win_show(win);
}

void on_app_event(vv_app_t *app, vv_app_event_t event) {

  vv_win_t *win = vv_win_create(app, "main");
  vv_win_hide(win);
  vv_win_set_center(win);

  char *url = vv_app_get_data(app);
  vv_app_set_data(app, NULL);
  vv_win_open_url(win, url, on_url_loaded);
  free(url);
}

int main(int argc, char **argv) {

  if (argc < 2) {
    printf("  usage: %s <path>\n", argv[0]);
    return 1;
  }

  char *buf = malloc(7 + strlen(argv[1]) + 1);
  memcpy(buf, "file://", 7);
  strcpy(buf + 7, argv[1]);

  vv_app_t *app = vv_app_create();
  vv_app_listen(app, on_app_event);

  vv_app_set_data(app, buf);

  vv_app_run(app);
  vv_app_destroy(app);

  return 0;
}