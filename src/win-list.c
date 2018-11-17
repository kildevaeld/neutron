//
//  win-list.c
//  TestApp2
//
//  Created by Rasmus Kildevæld on 16/11/2018.
//  Copyright © 2018 Rasmus Kildevæld. All rights reserved.
//

#include "win-list.h"
#include <stdlib.h>
#include <stdio.h>



winlist_t *win_list_create(vv_win_t *win) {
    struct win_list *wl = malloc(sizeof(struct win_list));
    wl->win = win;
    wl->next = NULL;
    return wl;
}

winlist_t *win_list_append(winlist_t *wl, vv_win_t *win) {
    winlist_t *list = win_list_create(win);
    list->next = wl;
    return list;
}

winlist_t *win_list_remove(winlist_t *wl, vv_win_t *win) {
    winlist_t *next = wl;
    if (next->win == win) {
        winlist_t *next = wl->next;
        wl->next = NULL;
        win_list_free(wl, false);
        return next;
    }
    
    while (next) {
        winlist_t *tmp = next->next;
        if (tmp && tmp->win == win) {
            next->next = tmp->next;
            tmp->next = NULL;
            win_list_free(tmp, false);
            break;
        }
    
        next = tmp;
    
    }
    
    return wl;
}


void win_list_free(winlist_t *wl, bool free_items) {
    winlist_t *next = wl;
    
    while (next) {
        winlist_t *tmp = next->next;
        if (free_items)
            vv_win_destroy(next->win);
        free(next);
        next = tmp;
    }
}
