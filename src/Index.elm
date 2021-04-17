module Index exposing (htmlToReinject, index)

import Html.String exposing (..)
import Html.String.Attributes exposing (..)
import Html.String.Extra exposing (..)
import Main
import Projects.Project as Item
import Starter.ConfMeta
import Starter.FileNames
import Starter.Flags
import Starter.Icon
import Starter.SnippetCss
import Starter.SnippetHtml
import Starter.SnippetJavascript


conf :
    { author : String
    , description : String
    , domain : String
    , snapshotFileName : String
    , snapshotHeight : number
    , snapshotWidth : number1
    , themeColor : String
    , title : String
    , twitterHandle : String
    , twitterSite : String
    }
conf =
    { title = Item.conf.title
    , description = Item.conf.description
    , domain = "https://mekke.guupa.com/"
    , twitterSite = ""
    , twitterHandle = ""
    , themeColor = "#bf0000"
    , author = "Ritsuko"
    , snapshotFileName = "snapshot.jpg"
    , snapshotWidth = 700
    , snapshotHeight = 350
    }


index : Starter.Flags.Flags -> Html msg
index flags =
    let
        relative =
            Starter.Flags.toRelative flags

        fileNames =
            Starter.FileNames.fileNames flags.version flags.commit
    in
    html
        [ lang "en" ]
        [ head []
            ([]
                ++ [ title_ [] [ text conf.title ]
                   , meta [ charset "utf-8" ] []
                   , meta [ name "author", content conf.author ] []
                   , meta [ name "description", content conf.description ] []
                   , meta [ name "viewport", content "width=device-width, initial-scale=1, shrink-to-fit=no" ] []
                   , meta [ httpEquiv "x-ua-compatible", content "ie=edge" ] []
                   , link [ rel "icon", href (Starter.Icon.iconFileName relative 64) ] []
                   , link [ rel "apple-touch-icon", href (Starter.Icon.iconFileName relative 152) ] []
                   , style_ []
                        [ text "body {margin: 0px;}"
                        ]
                   ]
                ++ Starter.SnippetHtml.messagesStyle
                ++ Starter.SnippetHtml.pwa
                    { commit = flags.commit
                    , relative = relative
                    , themeColor = Starter.Flags.toThemeColor flags
                    , version = flags.version
                    }
                ++ Starter.SnippetHtml.previewCards
                    { commit = flags.commit
                    , flags = flags
                    , mainConf = Main.conf
                    , version = flags.version
                    }
            )
        , body []
            ([]
                -- Friendly message in case Javascript is disabled
                ++ (if flags.env == "dev" then
                        Starter.SnippetHtml.messageYouNeedToEnableJavascript

                    else
                        Starter.SnippetHtml.messageEnableJavascriptForBetterExperience
                   )
                -- "Loading..." message
                ++ Starter.SnippetHtml.messageLoading
                -- The DOM node that Elm will take over
                ++ [ div [ id "elm" ] [] ]
                -- Activating the "Loading..." message
                ++ Starter.SnippetHtml.messageLoadingOn
                -- Loading Elm code
                ++ [ script [ src (relative ++ fileNames.outputCompiledJsProd) ] [] ]
                -- Elm finished to load, de-activating the "Loading..." message
                ++ Starter.SnippetHtml.messageLoadingOff
                -- Signature "Made with ❤ and Elm"
                ++ [ script [] [ textUnescaped Starter.SnippetJavascript.signature ] ]
                -- Initializing "window.ElmStarter"
                ++ [ script [] [ textUnescaped <| Starter.SnippetJavascript.metaInfo flags ] ]
                -- Let's start Elm!
                ++ [ Html.String.Extra.script []
                        [ Html.String.textUnescaped
                            ("""
                            var node = document.getElementById('elm');
                            window.ElmApp = Elm.Main.init(
                                { node: node
                                , flags:
                                    { commit: ElmStarter.commit
                                    , branch: ElmStarter.branch
                                    , env: ElmStarter.env
                                    , version: ElmStarter.version
                                    , width: window.innerWidth
                                    , height: window.innerHeight
                                    , languages: window.navigator.userLanguages || window.navigator.languages || []
                                    , locationHref: location.href
                                    }
                                }
                            );
                            ElmApp.ports.modalOpen.subscribe(function (modalOpen) {
                                if (modalOpen) {
                                    document.body.classList.add('modal-open');
                                } else {
                                    document.body.classList.remove('modal-open');
                                }
                            });
                            """
                                ++ Starter.SnippetJavascript.portOnUrlChange
                                ++ Starter.SnippetJavascript.portPushUrl
                                ++ Starter.SnippetJavascript.portChangeMeta
                            )
                        ]
                   ]
                -- Register the Service Worker, we are a PWA!
                ++ [ script [] [ textUnescaped (Starter.SnippetJavascript.registerServiceWorker relative) ] ]
            )
        ]


htmlToReinject : a -> List b
htmlToReinject _ =
    []



--
-- , javascriptThatStartsElm =
--     """
--         var node = document.getElementById('elm');
--         var app = Elm.Main.init(
--             { node: node
--             , flags:
--                 { commit: window.ElmStarter.commit
--                 , branch: window.ElmStarter.branch
--                 , env: window.ElmStarter.env
--                 , version: window.ElmStarter.version
--                 , versionElmStart: window.ElmStarter.versionElmStart
--                 //
--                 , width: window.innerWidth
--                 , height: window.innerHeight
--                 , languages: window.navigator.languages
--                 , locationHref: location.href
--                 }
--             }
--         );
--         app.ports.modalOpen.subscribe(function (modalOpen) {
--             if (modalOpen) {
--                 document.body.classList.add('modal-open');
--             } else {
--                 document.body.classList.remove('modal-open');
--             }
--         });
--     """
--         ++ Starter.SnippetJavascript.portChangeMeta
--         ++ Starter.SnippetJavascript.portOnUrlChange
--         ++ Starter.SnippetJavascript.portPushUrl
--
-- -- port onUrlChange : (String -> msg) -> Sub msg
-- -- port pushUrl : String -> Cmd msg


prefix : String
prefix =
    "elm-start-"


tag : { loader : String, notification : String }
tag =
    { notification = prefix ++ "notification"
    , loader = prefix ++ "loader"
    }
