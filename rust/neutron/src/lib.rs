extern crate neutron_sys;
extern crate typemap;
pub extern crate url;

mod app;
mod win;

pub use self::app::*;
pub use self::win::*;

#[macro_export]
macro_rules! html {
    ($inp: expr) => {{
        use $crate::url::percent_encoding::{utf8_percent_encode, DEFAULT_ENCODE_SET};
        format!(
            "data:text/html,{}",
            utf8_percent_encode($inp, DEFAULT_ENCODE_SET)
        )
    }};
}

pub mod prelude {
    pub use super::app::*;
    pub use super::win::*;
}
