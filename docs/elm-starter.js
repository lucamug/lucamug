(function () {
    "use strict";

    var color = {
        default: "background: #eee; color: gray; font-family: monospace",
        love: "background: red; color: #eee",
        elm: "background: #77d7ef; color: #00479a"
    };
    var emptyLine = " ".repeat(49);
    var message = [
        "",
        "%c",
        emptyLine,
        "    m a d e   w i t h   %c ❤ %c   a n d   %c e l m %c    ",
        emptyLine,
        "",
        ""
    ].join("\n");

    console.info(
        message,
        color.default,
        color.love,
        color.default,
        color.elm,
        color.default
    );

    var node = document.querySelector('elm')
    var app = Elm.Main.init({
        node: node,
        flags: {
            width: window.innerWidth,
            height: window.innerHeight,
            language: window.navigator.userLanguage || window.navigator.language || "",
            locationHref: location.href
        }
    });

    app.ports.modalOpen.subscribe(function (modalOpen) {
        if (modalOpen) {
            document.body.classList.add('modal-open');
        } else {
            document.body.classList.remove('modal-open');
        }
    });
})();