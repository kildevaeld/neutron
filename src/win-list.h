//
//  win-list.h
//  TestApp2
//
//  Created by Rasmus Kildevæld on 16/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#ifndef win_list_h
#define win_list_h

#include <neutron/win.h>
#include <stdbool.h>

typedef struct win_list
{
  vv_win_t *win;
  struct win_list *next;
} winlist_t;

winlist_t *win_list_create(vv_win_t *win);
winlist_t *win_list_append(winlist_t *wl, vv_win_t *win);
winlist_t *win_list_remove(winlist_t *wl, vv_win_t *win);
void win_list_free(winlist_t *wl, bool free_items);

#endif /* win_list_h */
