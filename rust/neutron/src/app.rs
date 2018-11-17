use super::win::{create_window, Window};
use neutron_sys as neu;
use std::cell::RefCell;
use std::collections::BTreeMap;
use std::ffi::c_void;
use std::sync::Arc;
use typemap::TypeMap;

#[derive(PartialEq, PartialOrd, Ord, Eq, Copy, Clone)]
pub enum AppEvent {
    FinishedLoaded,
    WillTerminate,
}

impl AppEvent {
    pub fn from(event: neu::vv_win_event_t) -> AppEvent {
        match event {
            neu::vv_app_event_s_VV_APP_EVENT_DID_FINISH => AppEvent::FinishedLoaded,
            neu::vv_app_event_s_VV_APP_EVENT_WILL_TERMINATE => AppEvent::WillTerminate,
            _ => panic!("invalid event"),
        }
    }
}

pub struct App {
    pub(crate) app: *mut neu::vv_app_t,
    pub(crate) listeners: BTreeMap<AppEvent, Vec<Box<dyn Fn(&App, AppEvent)>>>,
}

unsafe extern "C" fn on_app_event(
    ctx: *mut neu::vv_app_t,
    event: neu::vv_app_event_t,
    data: *mut std::ffi::c_void,
) {
    let app = neu::vv_app_get_data(ctx) as *mut RefCell<App>;
    let app = Arc::from_raw(app);

    // if let Some(lis) = app.borrow().listeners.get(&AppEvent::FinishedLoaded) {
    //     for l in lis {
    //         l(&mut app.borrow(), AppEvent::FinishedLoaded);
    //     }
    // }

    let event = AppEvent::from(event);
    if let Some(lis) = app.borrow().listeners.get(&event) {
        for l in lis {
            l(&mut app.borrow(), event);
        }
    }

    Arc::into_raw(app);
}

impl App {
    pub fn new() -> Arc<RefCell<App>> {
        let app = unsafe { neu::vv_app_create() };
        let a = Arc::new(RefCell::new(App {
            app: app,
            listeners: BTreeMap::new(),
        }));

        unsafe {
            neu::vv_app_set_data(app, Arc::into_raw(a.clone()) as *mut std::ffi::c_void);
            neu::vv_app_listen(app, Some(on_app_event));
        }

        a
    }

    pub fn create_window<Str: AsRef<str>, Func>(&self, name: Str, cb: Func) -> &Self
    where
        Func: FnOnce(&mut Window),
    {
        // let win = unsafe {
        //     let win = neu::vv_win_create(self.app, name.as_ref().as_ptr() as *const i8);
        //     let tm = Box::new(TypeMap::new());
        //     neu::vv_win_set_data(win, Box::into_raw(tm) as *mut c_void);
        //     win
        // };
        let win = unsafe { create_window(self.app, name.as_ref()) };

        let mut win = Window::new(win);

        cb(&mut win);

        self
    }

    pub fn window<Str: AsRef<[u8]>, Func>(&self, name: Str, cb: Func) -> &Self
    where
        Func: FnOnce(&mut Window),
    {
        self
    }

    pub fn listen<T>(&mut self, event: AppEvent, cb: T)
    where
        T: 'static + Fn(&App, AppEvent),
    {
        if self.listeners.get(&event).is_none() {
            self.listeners.insert(event, vec![]);
        }
        self.listeners.get_mut(&event).unwrap().push(Box::new(cb));
    }

    pub fn run(&self) {
        unsafe {
            neu::vv_app_run(self.app);
        };
    }

    pub fn terminate(&self) {
        unsafe { neu::vv_app_terminate(self.app) };
    }
}

impl Drop for App {
    fn drop(&mut self) {
        unsafe {
            neu::vv_app_destroy(self.app);
        }
    }
}
