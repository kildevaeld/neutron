#[macro_use]
extern crate neutron;
use neutron::prelude::*;

fn on_open(w: &mut Window) {
    println!("{}", "Hellow");
    w.eval_js("")
}

fn main() {
    let app = App::new();

    app.borrow_mut()
        .listen(AppEvent::FinishedLoaded, |app, event| {
            app.create_window("main", |win| {
                println!("{}", "HERE");

                let html = html!("<h1>Hello, World</h1>");

                win.open_url(html, on_open);
                win.center().set_title("Hello, World");

                win.on_message(|_win, msg| {
                    println!("{}", msg);
                });

                win.eval_js("window.external.invoke('Sendt message');");

                win.listen(WindowEvent::DidClose, |win, _| {
                    println!("Window did close");
                    win.app().borrow().terminate();
                });
            });
        });

    app.borrow().run();
}
