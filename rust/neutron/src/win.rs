use super::app::App;
use neutron_sys as neu;
use std::cell::RefCell;
use std::collections::BTreeMap;
use std::ffi::c_void;
use std::ffi::{CStr, CString};
use std::ptr;
use std::str;
use std::sync::Arc;
use typemap::{Key, TypeMap};

#[derive(PartialEq, PartialOrd, Ord, Eq, Copy, Clone)]
pub enum WindowEvent {
    DidClose,
}

impl WindowEvent {
    pub fn from(event: neu::vv_win_event_t) -> WindowEvent {
        match event {
            neu::vv_win_event_s_VV_WIN_DID_CLOSE => WindowEvent::DidClose,
            _ => panic!("should not happen"),
        }
    }
}

unsafe extern "C" fn on_win_event(win: *mut neu::vv_win_t, event: neu::vv_win_event_t) {
    let w = Window::new(win);
    let event = WindowEvent::from(event);
    let listeners = w.data().unwrap().get::<OnEventKey>().unwrap();

    if let Some(lis) = listeners.get(&event) {
        for l in lis {
            let mut w = Window::new(win);
            l(&mut w, event);
        }
    }
}

unsafe extern "C" fn on_win_message(win: *mut neu::vv_win_t, message: *const i8) {
    let w = Window::new(win);
    if let Some(cb) = w.data().unwrap().get::<OnMessageKey>() {
        let msg = CStr::from_ptr(message);
        let mut w = Window::new(win);
        cb(&mut w, msg.to_str().unwrap());
    }
}

pub(crate) unsafe extern "C" fn create_window(
    app: *mut neu::vv_app_t,
    name: &str,
) -> *mut neu::vv_win_t {
    let name = CString::new(name).unwrap();
    let win = neu::vv_win_create(app, name.as_c_str().as_ptr());

    let mut tm = Box::new(TypeMap::new());
    tm.insert::<OpenUrlCB>(BTreeMap::new());
    tm.insert::<OnEventKey>(BTreeMap::new());

    neu::vv_win_set_data(win, Box::into_raw(tm) as *mut c_void);

    neu::vv_win_listen(win, Some(on_win_event));
    neu::vv_win_set_message_handler(win, Some(on_win_message));

    win
}

struct OpenUrlCB;
impl Key for OpenUrlCB {
    type Value = BTreeMap<String, Box<Fn(&mut Window)>>;
}

unsafe extern "C" fn on_open_url(win: *mut neu::vv_win_t, url: *const i8, err: *const i8) {
    let mut win = Window::new(win);
    let callbackes = win.data_mut().unwrap().get_mut::<OpenUrlCB>().unwrap();
    let url = CStr::from_ptr(url).to_str().unwrap();
    if let Some(cb) = callbackes.remove(url) {
        cb(&mut win)
    }
}

struct OnMessageKey;
impl Key for OnMessageKey {
    type Value = Box<Fn(&mut Window, &str)>;
}

struct OnEventKey;
impl Key for OnEventKey {
    type Value = BTreeMap<WindowEvent, Vec<Box<Fn(&mut Window, WindowEvent)>>>;
}

pub struct Window {
    win: *mut neu::vv_win_t,
    data: *mut TypeMap,
}

impl Window {
    pub(crate) fn new(w: *mut neu::vv_win_t) -> Window {
        let data = unsafe { neu::vv_win_get_data(w) as *mut TypeMap };
        unsafe {
            if (&*data).get::<OpenUrlCB>().is_none() {
                (&mut *data).insert::<OpenUrlCB>(BTreeMap::new());
            }
        }
        Window { win: w, data }
    }

    pub fn set_size(&mut self, w: i32, h: i32) -> &mut Self {
        unsafe { neu::vv_win_set_size(self.win, w, h) };
        self
    }

    pub fn set_title<T: AsRef<[u8]>>(&mut self, title: T) -> &mut Self {
        let s = CString::new(title.as_ref()).unwrap();
        unsafe { neu::vv_win_set_title(self.win, s.as_ptr()) };
        self
    }

    pub fn center(&mut self) -> &mut Self {
        unsafe { neu::vv_win_set_center(self.win) };
        self
    }

    pub fn eval_js<T: AsRef<str>>(&self, script: T) {
        let s = CString::new(script.as_ref()).unwrap();
        unsafe { neu::vv_win_eval_js(self.win, s.as_ptr(), None) }
    }

    pub fn open_url<T: AsRef<str>, Func: 'static + Fn(&mut Window)>(&self, url: T, cb: Func) {
        let bt = self.data_mut().unwrap().get_mut::<OpenUrlCB>().unwrap();
        let u = url.as_ref().to_owned();
        bt.insert(u, Box::new(cb));
        let s = CString::new(url.as_ref()).unwrap();
        unsafe { neu::vv_win_open_url(self.win, s.as_c_str().as_ptr(), Some(on_open_url)) };
    }

    pub fn data<'a>(&'a self) -> Option<&'a TypeMap> {
        unsafe {
            if self.data.is_null() {
                return None;
            }
            Some(&*self.data)
        }
    }

    pub fn data_mut<'a>(&'a self) -> Option<&'a mut TypeMap> {
        unsafe {
            if self.data.is_null() {
                return None;
            }
            Some(&mut *self.data)
        }
    }

    pub fn on_message<Func: 'static>(&mut self, cb: Func)
    where
        Func: Fn(&mut Window, &str),
    {
        self.data_mut()
            .unwrap()
            .insert::<OnMessageKey>(Box::new(cb));
    }

    pub fn listen<Func: 'static>(&mut self, event: WindowEvent, cb: Func) -> &mut Self
    where
        Func: Fn(&mut Window, WindowEvent),
    {
        let callbacks = self.data_mut().unwrap().get_mut::<OnEventKey>().unwrap();
        if callbacks.get(&event).is_none() {
            callbacks.insert(event, vec![]);
        }
        callbacks.get_mut(&event).unwrap().push(Box::new(cb));
        self
    }

    pub fn app(&self) -> &RefCell<App> {
        unsafe {
            let app = neu::vv_win_app(self.win);
            let app = neu::vv_app_get_data(app) as *mut RefCell<App>;
            &*app
        }
    }
}
