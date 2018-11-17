extern crate bindgen;
extern crate cc;

use std::env;
use std::path::{Path, PathBuf};

fn main() {
    let bindings = bindgen::Builder::default()
        // The input header we would like to generate
        // bindings for.
        .header("../../include/neutron/neutron.h")
        // Finish the builder and generate the bindings.
        .generate()
        // Unwrap the Result and panic on failure.
        .expect("Unable to generate bindings");

    // Write the bindings to the $OUT_DIR/bindings.rs file.
    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("bindings.rs"))
        .expect("Couldn't write bindings!");

    // cc::Build::new()
    //     .file("duktape-2.3.0/src/duktape.c")
    //     .flag_if_supported("-fomit-frame-pointer")
    //     .flag_if_supported("-fstrict-aliasing")
    //     // .flag_if_supported("-fprofile-generate")
    //     .opt_level(2)
    //     .compile("libduktape.a");

    let mut build = cc::Build::new();

    if env::var("DEBUG").is_err() {
        build.define("NDEBUG", None);
    } else {
        build.define("DEBUG", None);
    }

    let target = env::var("TARGET").unwrap();

    let ip = Path::new("../../include");

    build.include(ip);
    build.files(vec!["../../src/utils.c", "../../src/win-list.c"]);

    if target.contains("apple") {
        build
            .define("WEBVIEW_COCOA", None)
            .flag("-x")
            .flag("objective-c")
            .files(vec![
                "../../src/macos/app.m",
                "../../src/macos/AppDelegate.m",
                "../../src/macos/ApplicationMessageHandler.m",
                //"macos/EmbedSchemeHandler.m",
                "../../src/macos/MacWindow.m",
                "../../src/macos/WebViewController.m",
                "../../src/macos/win.m",
            ]);
        println!("cargo:rustc-link-lib=framework=Cocoa");
        println!("cargo:rustc-link-lib=framework=WebKit");
    } else {
        panic!("unsupported target");
    }

    build.compile("neutron");
}
