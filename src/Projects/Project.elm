module Projects.Project exposing
    ( Item
    , cardWrapper
    , conf
    , id
    , itemNotFound
    , items
    , viewCard
    , viewDetails
    , viewTitle
    )

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html.Attributes
import Utils.SimpleMarkdown
import Utils.Utils


id : { b | review : a } -> a
id =
    .review


conf :
    { backgroundColor : Color
    , fontColor : Color
    , spacingSize : number
    , title : String
    , urlLabel : String
    , description : String
    }
conf =
    { title = "lucamug"
    , urlLabel = "project"
    , description = "Lucamug's Projects"
    , backgroundColor = rgb255 255 255 255
    , fontColor = rgb 0 0 0
    , spacingSize = 50
    }


type alias Item =
    Project


type alias Project =
    { title : String
    , review : String
    , desc : String
    , url : String
    , code : String
    , demo : String
    , date : String
    , image : String
    }


imagesLocation : String
imagesLocation =
    "/images/"


linkAttrs : List (Attr () msg)
linkAttrs =
    [ Font.color <| rgb 0 0.2 0.8
    , Border.width 1
    , Border.rounded 10
    , padding 10
    ]


viewDetails : Project -> Element.Element msg
viewDetails project =
    column [ width (fill |> maximum 600) ]
        [ image [ width fill ] { src = imagesLocation ++ project.image, description = project.title }
        , column [ padding 20, spacing 20 ]
            ([]
                ++ [ paragraph [ Font.size 30, Font.bold ] [ text project.title ] ]
                ++ [ wrappedRow [ spacing 20 ]
                        ([]
                            ++ createLinkIfNotEmpty project.url "Link"
                            ++ createLinkIfNotEmpty project.code "Code"
                            ++ createLinkIfNotEmpty project.demo "Demo"
                        )
                   ]
                ++ (if String.isEmpty project.desc then
                        []

                    else
                        [ paragraph [ spacing 7 ] <|
                            Utils.SimpleMarkdown.elementMarkdownAdvanced { link = linkAttrs } project.desc
                        ]
                   )
            )
        ]


viewTitle : Element msg
viewTitle =
    column []
        [ el [ Font.size 80, Font.family [ Font.typeface "Bad Script" ] ] <| text conf.title
        , row [ spacing 20 ]
            [ el [] <| Utils.Utils.logoLucamug 30
            , el [] <| Utils.Utils.logoTwitter 30
            , el [] <| Utils.Utils.logoMedium 30
            , el [] <| Utils.Utils.logoGithub 30
            , el [] <| Utils.Utils.logoDev 30
            ]
        ]


createLinkIfNotEmpty : String -> String -> List (Element msg)
createLinkIfNotEmpty url label =
    if String.isEmpty url then
        []

    else
        [ newTabLink linkAttrs
            { url = url
            , label = row [ spacing 10 ] [ text label, el [] <| Utils.Utils.iconOpenNewWindow "#0030d0" 16 ]
            }
        ]


cardWrapper :
    (List (Attr () msg) -> { label : Element msg, url : String } -> Element msg)
    -> Int
    -> Project
    -> String
    -> Element msg
cardWrapper linkInternal index item url =
    el
        [ width (fill |> minimum 250)
        , htmlAttribute <| Html.Attributes.class "card"
        , mouseOver
            [ Border.shadow { offset = ( 0, 20 ), size = 5, blur = 10, color = rgba 0 0 0 0.1 }
            , Border.color <| rgba 0 0 0 0.1
            , Background.color <| rgb 0.3 0.5 0.3
            , moveUp 10
            ]
        ]
        (linkInternal
            [ Background.color <| rgba 0 0 0 0.0
            , height fill
            , width fill
            ]
            { label = viewCard item
            , url = url
            }
        )


viewCard : Project -> Element msg
viewCard project =
    el
        ([ width fill ]
            ++ (if String.isEmpty project.image then
                    []

                else
                    [ Background.image <| imagesLocation ++ project.image
                    ]
               )
        )
    <|
        column
            [ width fill
            , height (fill |> minimum 150)
            , Background.gradient { angle = 0, steps = [ rgba 0 0 0 0.5, rgba 0 0 0 0 ] }
            ]
            [ paragraph
                [ padding 15
                , Font.center
                , Font.bold
                , Font.size 20
                , Font.color <| rgb 1 1 1
                , alignBottom
                ]
                [ text project.title ]
            ]


itemNotFound : Item
itemNotFound =
    { title = "NOT FOUND"
    , review = ""
    , desc = ""
    , url = ""
    , code = ""
    , demo = ""
    , date = ""
    , image = ""
    }


items : List Item
items =
    [ { title = "Rakuten Sign In"
      , review = "Rakuten Sign In"
      , desc = "The entire Front-end part of Rakuten Taiwan Sign In and Registration system. I talked about this system at the [2019 Oslo Elm Day conference](https://www.youtube.com/watch?v=yH6o322S8XQ)."
      , url = "https://login.account.rakuten.com/sso/register?client_id=rakuten_tw01&redirect_uri=https%3A%2F%2Fwww.rakuten.com.tw%2Fmember%2Fdelegate&response_type=code&scope=openid+profile+email#/registration/1"
      , code = ""
      , demo = ""
      , date = ""
      , image = "rakuten_signin.jpg"
      }
    , { title = "Rakuten Open Source"
      , review = "Rakuten Open Source"
      , desc = "The Open Source page of Rakuten got a new re-write in March 2019. It is now completely written in Elm. It combines Rakuten Open Source project coming from 11 different Github accounts. The structure of the app is not an usual Elm structure. It is organized in a way that also engineer that are now familiar with Elm can maitain the website. The main `src` folder contain the configuration and the main views. The website logic (The Elm Architecture) is \"hidden\" in the `internal` folder."
      , url = "https://rakutentech.github.io/"
      , code = "https://github.com/rakutentech/rakutentech.github.io"
      , demo = ""
      , date = ""
      , image = "rakuten_open_source.jpg"
      }
    , { title = "Rakuten Security"
      , review = "Rakuten Security"
      , desc = "A single Elm page that works also without Javascript and is SEO friendly."
      , url = "https://static.id.rakuten.co.jp/static/about_security/jpn/"
      , code = ""
      , demo = ""
      , date = ""
      , image = "rakuten_security.jpg"
      }
    , { title = "elm-live collaboration"
      , review = "elm-live"
      , desc = """I enjoyed collaborating with William King to add few feature to elm-live, including

* Errors in console
* Errors in browser
* Colored errors
* Hot reload implementations (Using [elm-hot](https://github.com/klazuka/elm-hot))
* QRCode for mobile testing ([pending](https://github.com/wking-io/elm-live/issues/204))
* Link in browser that open IDE directly ([pending](https://github.com/wking-io/elm-live/issues/204))"""
      , url = "https://www.npmjs.com/package/elm-live"
      , code = "https://github.com/wking-io/elm-live"
      , demo = ""
      , date = ""
      , image = "elm_live.jpg"
      }
    , { title = "Elm vs Svelte"
      , review = "Elm vs Svelte"
      , desc = "A biased and superficial comparison between two frameworks that compile to Javascript"
      , url = "https://medium.com/@l.mugnaini/elm-vs-svelte-d8e6f0abf667"
      , code = ""
      , demo = ""
      , date = ""
      , image = "elm_vs_svelte-80.jpg"
      }
    , { title = "Simple masonry layout in 50 lines of Elm code"
      , review = "Masonry Layout"
      , desc = "A Masonry layout is a way to fit together elements of possibly different sizes without gaps."
      , url = "https://medium.com/@l.mugnaini/simple-masonry-layout-in-50-lines-of-elm-code-304ea9e9475c"
      , code = ""
      , demo = ""
      , date = ""
      , image = "masonry.jpg"
      }
    , { title = "Elm Japan 2020"
      , review = "Elm Japan"
      , desc = "Lead organizer of the first Elm conference in the Asia-Pacific region"
      , url = "https://elmjapan.org/"
      , code = "https://github.com/lucamug/elm-japan"
      , demo = ""
      , date = ""
      , image = "elm_japan.jpg"
      }
    , { title = "Speaker at the 2019 Oslo Elm Day Conference"
      , review = "Oslo Elm Day"
      , desc = ""
      , url = ""
      , code = ""
      , demo = ""
      , date = ""
      , image = "oslo_conference.jpg"
      }
    , { title = "Elm Resources"
      , review = "Elm Resources"
      , desc = ""
      , url = "https://elm-resources.guupa.com/"
      , code = "https://github.com/lucamug/elm-resources"
      , demo = ""
      , date = ""
      , image = "elm_resources.jpg"
      }
    , { title = "Events"
      , review = "Events and Workshops"
      , desc = """Talking about Front-end and Elm is always fun. Some of the most recent events:

* [Fighting Front-End Fatigue: Introduction to Elm | Workshop](https://www.meetup.com/CodeChrysalis/events/268496917/)
* [Elm at large (companies)](https://webhack.connpass.com/event/122871/)
* [Elm, a delightful language for reliable webapps](https://webhack.connpass.com/event/112206/)
* [Iro iro: One year of Elm in 50 slides](https://elm-jp.connpass.com/event/156016/)
* [Front-end Innovation: Fast and Curious](https://tech.rakuten.co.jp/sessions/front-end-innovation-fast-and-curious/)"""
      , url = ""
      , code = ""
      , demo = ""
      , date = ""
      , image = "events.jpg"
      }
    , { title = "Basic 3D rendering in SVG: elm-playground-3d"
      , review = "3D SVG"
      , desc = "An introduction to a simple Elm library to build animated three dimensional models"
      , url = "https://medium.com/@l.mugnaini/basic-3d-rendering-in-svg-elm-playground-3d-d1e8846cd06e"
      , code = ""
      , demo = ""
      , date = ""
      , image = "3d_svg.jpg"
      }
    , { title = "How to build a responsive layout without a single CSS line*"
      , review = "How to build a responsive layout without a single CSS line*"
      , desc = "This is a tutorial on how to build a mildly complex web layout without any knowledge of CSS (and also any knowledge of Javascript and HTML…"
      , url = "https://medium.com/@l.mugnaini/how-to-build-a-responsive-layout-without-a-single-css-line-afbdfe89bb6d"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Time in Elm"
      , review = "Time in Elm"
      , desc = "Handling time in Elm seems to be a scaring thing for beginners."
      , url = "https://medium.com/@l.mugnaini/time-in-elm-42f08b8973f3"
      , code = ""
      , demo = ""
      , date = ""
      , image = "time_in_elm.jpg"
      }
    , { title = "Beginner Tutorials: How to build a game in Elm\u{200A}—\u{200A}Part 3"
      , review = "Beginner Tutorials: How to build a game in Elm\u{200A}—\u{200A}Part 3"
      , desc = "Part 3of 12\u{200A}—\u{200A}Add the Pause"
      , url = "https://medium.com/@l.mugnaini/beginner-tutorials-how-to-build-a-game-in-elm-part-3-fe62c51f7510"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Beginner Tutorials: How to build a game in Elm\u{200A}—\u{200A}Part 2"
      , review = "Beginner Tutorials: How to build a game in Elm\u{200A}—\u{200A}Part 2"
      , desc = "Part 2 of 12\u{200A}—\u{200A}Add Keyboard"
      , url = "https://medium.com/@l.mugnaini/beginner-tutorials-how-to-build-a-game-in-elm-part-2-ae26eef8610b"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Tutorial: Real Time Collaboration and Free Hosting with glitch.com"
      , review = "Tutorial: Real Time Collaboration and Free Hosting with glitch.com"
      , desc = "Note: This is a step by step tutorial about hosting an Elm application on glitch.com but most of the concepts are applicable to other…"
      , url = "https://medium.com/@l.mugnaini/tutorial-real-time-collaboration-and-free-hosting-with-glitch-com-307b0c7398c6"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Terminal Pixel Art"
      , review = "Terminal Pixel Art"
      , desc = "If you find yourself often running scripts in the terminal, why not adding some colored pixel art to them?"
      , url = "https://medium.com/@l.mugnaini/terminal-pixel-art-ad386d186dad"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Beginner Tutorials: How to build a game in Elm"
      , review = "Beginner Tutorials: How to build a game in Elm"
      , desc = "Part 1 of 12\u{200A}—\u{200A}The Game Loop"
      , url = "https://medium.com/@l.mugnaini/beginner-tutorials-how-to-build-a-game-in-elm-5491d6de8f25"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Things that can go wrong without a strictly typed language\u{200A}—\u{200A}Part II"
      , review = "Things that can go wrong without a strictly typed language\u{200A}—\u{200A}Part II"
      , desc = "a.k.a. “Los tipos son buena gente”"
      , url = "https://medium.com/@l.mugnaini/things-that-can-go-wrong-without-a-strictly-typed-language-part-ii-8b239a85f35a"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Things that can go wrong without a strictly typed language\u{200A}—\u{200A}Part I"
      , review = "Things that can go wrong without a strictly typed language\u{200A}—\u{200A}Part I"
      , desc = "What happen when an Elm developer write a Vue application"
      , url = "https://itnext.io/things-that-can-go-wrong-without-a-strictly-typed-language-d91d418a53a1"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Mocking APIs from inside Elm"
      , review = "Mocking APIs from inside Elm"
      , desc = "I wanted to have a simple way to test all possible scenario of an http responses. There are tools like Mountebank but it is an extra thing…"
      , url = "https://medium.com/@l.mugnaini/mocking-apis-from-inside-elm-5efda32ee9fe"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Monads without talking about Monads, in Elm"
      , review = "Monads without talking about Monads, in Elm"
      , desc = "In Functional Programming we build programs only using functions. These functions, for simplicity, can return only one value."
      , url = "https://medium.com/@l.mugnaini/monads-without-talking-about-monads-in-elm-4b9b6ffd5ad5"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "The Elm Architecture (TEA) animation"
      , review = "The Elm Architecture (TEA) animation"
      , desc = "The “game loop” of Elm"
      , url = "https://medium.com/@l.mugnaini/the-elm-architecture-tea-animation-3efc555e8faf"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Functors, Applicatives, And Monads In Pictures (In Elm)"
      , review = "Functors, Applicatives, And Monads In Pictures (In Elm)"
      , desc = "Elm Version"
      , url = "https://medium.com/@l.mugnaini/functors-applicatives-and-monads-in-pictures-784c2b5786f7"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Proposal for a Style Framework in Elm"
      , review = "Proposal for a Style Framework in Elm"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/proposal-for-a-style-framework-in-elm-f5a1919ab425"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Media queries in Elm"
      , review = "Media queries in Elm"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/media-queries-in-elm-7b8f75cabc72"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Unbreakable JSON"
      , review = "Unbreakable JSON"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/unbreakable-json-95637300176c"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Undo and Redo using browsers history"
      , review = "Undo and Redo using browsers history"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/undo-and-redo-using-browsers-history-1f1f963bf722"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "CSS Nirvana"
      , review = "CSS Nirvana"
      , desc = "Do you remember when I told you that separating layout from style was a good thing? Well, forget about it!"
      , url = "https://medium.com/front-end-weekly/css-nirvana-a92ba04cca06"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Is the future of Front-end development without HTML, CSS and Javascript?"
      , review = "Is the future of Front-end development without HTML, CSS and Javascript?"
      , desc = "Before artificial intelligence is taking over our Front-end jobs (here and here) let’s think some way to make our life less miserables."
      , url = "https://medium.com/@l.mugnaini/is-the-future-of-front-end-development-without-html-css-and-javascript-e7bb0877980e"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Single Page Application Boilerplate for Elm"
      , review = "Single Page Application Boilerplate for Elm"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/single-page-application-boilerplate-for-elm-160bb5f3eec2"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Zero-maintenance Always-up-to-date Living Style Guide in Elm!"
      , review = "Zero-maintenance Always-up-to-date Living Style Guide in Elm!"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/zero-maintenance-always-up-to-date-living-style-guide-in-elm-dbf236d07522"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Living Website Style Guide and Documentation in Elm"
      , review = "Living Website Style Guide and Documentation in Elm"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/living-website-style-guide-and-documentation-in-elm-2f99b6d61da9"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Autocomplete widget in Elm"
      , review = "Autocomplete widget in Elm"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/autocomplete-widget-in-elm-4927b8e275db"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Forms in Elm — Validation, Tutorial and Examples — Part 3"
      , review = "Forms in Elm — Validation, Tutorial and Examples — Part 3"
      , desc = "Part 3 — Spinner, Floating Labels, Checkboxes, Date Picker, Autocomplete"
      , url = "https://medium.com/@l.mugnaini/forms-in-elm-validation-tutorial-and-examples-part-3-5f66f9c87679"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Forms in Elm — Validation, Tutorial and Examples — Part 2"
      , review = "Forms in Elm — Validation, Tutorial and Examples — Part 2"
      , desc = "Part 2 — Removing <form>, on-the-fly validation, Focus detection, Show/Hide the password"
      , url = "https://medium.com/@l.mugnaini/forms-in-elm-validation-tutorial-and-examples-part-2-1b978437b5db"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Forms in Elm —Validation, Tutorial and Examples — Part 1"
      , review = "Forms in Elm —Validation, Tutorial and Examples — Part 1"
      , desc = "Sometime Elm’s newcomers complain about the complexity and the large amount of boilerplate needed to create forms."
      , url = "https://medium.com/@l.mugnaini/i-believe-css-is-more-about-separation-of-presentation-and-content-42bd0435005"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Commands and Subscriptions in Elm"
      , review = "Commands and Subscriptions in Elm"
      , desc = "Aggregated documentation of Elm Commands and Subscription"
      , url = "https://medium.com/@l.mugnaini/commands-and-subscriptions-in-elm-9ff506e75d2d"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Brief beginners guide to Maybe and Result types in Elm"
      , review = "Brief beginners guide to Maybe and Result types in Elm"
      , desc = "There are concepts in Elm, as in other Functional Languages, that are simple, fun and elegant at the same time."
      , url = "https://medium.com/@l.mugnaini/brief-beginners-guide-to-maybe-and-result-types-in-elm-7649d2c3b970"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Record and replay individual visitor interaction with Elm"
      , review = "Record and replay individual visitor interaction with Elm"
      , desc = "I wanted to replay the user interaction with an Elm app, including the scrolling of the pages."
      , url = "https://medium.com/@l.mugnaini/record-and-replay-individual-visitor-interaction-with-elm-625814965508"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Separation of Layout and Style in Elm"
      , review = "Separation of Layout and Style in Elm"
      , desc = "I am intrigued with the concept of separating Layout and Style. Usually layout is defined using a mixture of html and css while style is…"
      , url = "https://medium.com/@l.mugnaini/separation-of-layout-and-style-in-elm-882a3cbe1e7f"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Lessons learned about Elm from Slack"
      , review = "Lessons learned about Elm from Slack"
      , desc = "I share here my personal notes that I took from Slack Elm https://elmlang.slack.com"
      , url = "https://medium.com/@l.mugnaini/lessons-learned-about-elm-from-slack-1d807d5d3627"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Images Zoom in Elm"
      , review = "Images Zoom in Elm"
      , desc = "Simple experiment for Images Zooming"
      , url = "https://medium.com/@l.mugnaini/images-zoom-in-elm-ffb8c27b305e"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Faceted Variants in Elm"
      , review = "Faceted Variants in Elm"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/faceted-variants-in-elm-c38b4d661355"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "SPA and SEO: Google (Googlebot) properly renders Single Page Application and execute Ajax calls"
      , review = "SPA and SEO: Google (Googlebot) properly renders Single Page Application and execute Ajax calls"
      , desc = "I run some test to understand how Google Search Engine handle a Single Page Application. I built the website for running the test in Elm…"
      , url = "https://medium.com/@l.mugnaini/spa-and-seo-is-googlebot-able-to-render-a-single-page-application-1f74e706ab11"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Tutorial — Permutations and Recursions in Elm"
      , review = "Tutorial — Permutations and Recursions in Elm"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/tutorial-permutations-and-recursions-in-elm-ad15e2288567"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Scroll and Resize events in Elm"
      , review = "Scroll and Resize events in Elm"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/scroll-and-resize-events-in-elm-ac4f0589f42"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Server Side Rendering with Elm"
      , review = "Server Side Rendering with Elm"
      , desc = "I know that the good Evan is going to release soon the version 0.19 that probably will implement the server side rendering."
      , url = "https://medium.com/@l.mugnaini/server-side-rendering-with-elm-9064170eb3cf"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Data Structures in Elm"
      , review = "Data Structures in Elm"
      , desc = "In the process of getting familiar with Data Structures in Elm I started to compile a table to compare all different types: Record, List…"
      , url = "https://medium.com/@l.mugnaini/data-structures-in-elm-3dd609be1fa3"
      , code = ""
      , demo = ""
      , date = ""
      , image = ""
      }
    , { title = "Elm Events Testing"
      , review = "Elm Events Testing"
      , desc = "A simple script to visualise some events in Elm"
      , url = "https://medium.com/@l.mugnaini/elm-events-testing-a812dfbcb21"
      , code = ""
      , demo = ""
      , date = "Jul 12, 2017"
      , image = ""
      }
    , { title = "Mobile Parallax Scrolling"
      , review = "Mobile Parallax Scrolling"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/mobile-parallax-scrolling-523c23f248c9"
      , code = ""
      , demo = "https://lucamug.github.io/mobile-parallax-scrolling/mobile-parallax-scrolling.html"
      , date = "Jul 2, 2017"
      , image = ""
      }
    , { title = "Kana Overlapping"
      , review = "Kana Overlapping"
      , desc = ""
      , demo = "https://lucamug.github.io/kana-overlapping/"
      , date = "Jun 16, 2017"
      , url = "https://codeburst.io/kana-overlapping-8a89d23109ec?source=your_stories_page---------------------------"
      , code = ""
      , image = ""
      }
    , { title = "Decoding Json that contain Json using Elm"
      , review = "Decoding Json that contain Json using Elm"
      , desc = ""
      , url = "https://medium.com/@l.mugnaini/decoding-json-that-contain-json-using-elm-be66d0dec0ff?source=your_stories_page---------------------------"
      , code = ""
      , demo = "https://lucamug.github.io/elm-meta-json-decoder/"
      , date = "Jun 15, 2017"
      , image = ""
      }
    , { title = "Carousel plugin in Elm"
      , review = "Carousel plugin in Elm"
      , desc = "This is a simple example of how is possible to implement a third party Carousel plugin in a Single Page Application (SPA) made in Elm."
      , url = "https://medium.com/@l.mugnaini/carousel-plugin-in-elm-46e89272b185?source=your_stories_page---------------------------"
      , code = ""
      , demo = ""
      , date = "Jun 4, 2017"
      , image = ""
      }
    , { title = "A ready-to-use Elm Presentation to impress your colleagues"
      , review = "A ready-to-use Elm Presentation to impress your colleagues"
      , desc = "I need to introduce Elm to some colleague and I was looking for a presentation that I could recycle. A while ago I remember seeing and…"
      , url = "https://medium.com/@l.mugnaini/a-ready-to-use-elm-presentation-to-impress-your-colleagues-ee71cac8fe14?source=your_stories_page---------------------------"
      , code = ""
      , demo = ""
      , date = "May 29, 2017"
      , image = ""
      }
    , { title = "A Neural Network in 11 lines of Javascript"
      , review = "A Neural Network in 11 lines of Javascript"
      , desc = "This is a port from Python to Javascript of the neural network implementation to describe the inner workings of backpropagation. This is…"
      , url = "https://aboveintelligent.com/a-neural-network-in-11-lines-of-javascript-d58b38330178?source=your_stories_page---------------------------"
      , code = ""
      , demo = ""
      , date = "May 25, 2017"
      , image = ""
      }
    , { title = "Self documenting API specifications"
      , review = "Self documenting API specifications"
      , desc = "I wanted to prepare the API specification for the backend developers in the most efficient way possible. Elm code is quite self…"
      , url = "https://medium.com/@l.mugnaini/self-documenting-api-specifications-41be58ec64a1?source=your_stories_page---------------------------"
      , code = ""
      , demo = ""
      , date = "on May 15, 2017"
      , image = ""
      }
    , { title = "A tool to generate and maintain a blog using Google spreadsheets"
      , review = "A tool to generate and maintain a blog using Google spreadsheets"
      , url = "https://medium.com/@l.mugnaini/a-tool-to-generate-and-maintain-a-blog-using-google-spreadsheets-a38367a94323?source=your_stories_page---------------------------"
      , code = ""
      , desc = "This tool automatically download data from Google Drive and generate all the posts of the Blog."
      , date = "May 9, 2017"
      , demo = ""
      , image = ""
      }
    , { title = "Bad* Javascript vs Bad* Elm"
      , review = "Bad* Javascript vs Bad* Elm"
      , url = "https://medium.com/@l.mugnaini/bad-javascript-vs-bad-elm-6dc9661d109?source=your_stories_page---------------------------"
      , code = ""
      , desc = "*Bad in the sense that i wrote it, ignoring the most basic good practices"
      , date = "May 9, 2017"
      , demo = ""
      , image = ""
      }
    , { title = "Experimental reuse of code in Elm, Part III — Counters Bonanza"
      , review = "Experimental reuse of code in Elm, Part III — Counters Bonanza"
      , url = "https://medium.com/@l.mugnaini/counters-bonanza-5e67855c0b83?source=your_stories_page---------------------------"
      , code = ""
      , desc = "Experimenting with recycling Elm code transforming it in a module"
      , date = "May 6, 2017"
      , demo = ""
      , image = ""
      }
    , { title = "Experimental reuse of code in Elm, Part II — The counter"
      , review = "Experimental reuse of code in Elm, Part II — The counter"
      , url = "https://medium.com/@l.mugnaini/recycling-elm-code-transforming-it-in-a-module-4946d5ccd3cd?source=your_stories_page---------------------------"
      , code = ""
      , desc = "This is the second part of a series:"
      , date = "May 6, 2017"
      , demo = ""
      , image = ""
      }
    , { title = "Simple Ecommerce Shopping Cart written in Elm"
      , review = "Simple Ecommerce Shopping Cart written in Elm"
      , url = "https://medium.com/@l.mugnaini/simple-e-commerce-shopping-cart-written-in-elm-7fe31c6bf13d?source=your_stories_page---------------------------"
      , code = ""
      , desc = "A simple Shopping Cart written while experimenting with Elm"
      , date = "May 3, 2017"
      , demo = ""
      , image = ""
      }
    , { title = "Experimental reuse of code in Elm, Part I — Page with list of products"
      , review = "Experimental reuse of code in Elm, Part I — Page with list of products"
      , url = "https://medium.com/@l.mugnaini/tutorial-how-to-recycle-in-elm-89b13b6c0bab?source=your_stories_page---------------------------"
      , code = ""
      , desc = "This is the first port of a series:"
      , date = "Apr 29, 2017"
      , demo = ""
      , image = ""
      }
    , { title = "Elm flow in the console"
      , review = "Elm flow in the console"
      , url = "https://medium.com/@l.mugnaini/elm-flow-in-the-console-16e6ceb4ce90?source=your_stories_page---------------------------"
      , code = ""
      , desc = "Try this code if you want to see how elm behave in the console:"
      , date = "Mar 28, 2017"
      , demo = ""
      , image = ""
      }
    , { title = "10 Criteria to Judge a Good Milk Container"
      , review = "10 Criteria to Judge a Good Milk Container"
      , url = "https://medium.com/@l.mugnaini/10-criteria-to-judge-a-good-milk-container-52a94d3d8202?source=your_stories_page---------------------------"
      , code = ""
      , desc = ""
      , date = "Jan 19, 2017"
      , demo = ""
      , image = ""
      }
    , { title = "DEC64 — Douglas Crockford’s Decimal Notation"
      , review = "DEC64 — Douglas Crockford’s Decimal Notation"
      , url = "https://medium.com/@l.mugnaini/dec64-douglas-crockfords-decimal-notation-b25f19348d63?source=your_stories_page---------------------------"
      , code = ""
      , desc = "I know this is a bit old, but today, watching an old Douglas Crockford’s video I was interested in his proposal of a new way of defining a…"
      , date = "Jan 18, 2017"
      , demo = ""
      , image = ""
      }
    , { title = "Introduction to Functional Programming"
      , review = "Introduction to Functional Programming"
      , url = "https://medium.com/@l.mugnaini/introduction-to-functional-programming-49c9e5c31df4?source=your_stories_page---------------------------"
      , code = ""
      , desc = "Among several videos that I have been watching about functional programming, I found these two quite interesting and entertaining:"
      , date = "Jan 17, 2017"
      , demo = ""
      , image = ""
      }
    , { title = "Javascript snippet to download a multi-sheets-Google-Spreadsheet in JSON"
      , review = "Javascript snippet to download a multi-sheets-Google-Spreadsheet in JSON"
      , url = "https://medium.com/@l.mugnaini/a-small-script-to-download-a-google-spreadsheet-with-multiple-worksheet-in-javascript-dafb14c65bae?source=your_stories_page---------------------------"
      , code = ""
      , desc = "Would you like to download your multi-sheets-Google-spreadsheet in a simple format like this?"
      , date = "Jan 17, 2017"
      , demo = ""
      , image = ""
      }
    ]
