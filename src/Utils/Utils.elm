module Utils.Utils exposing
    ( iconLeft
    , iconOpenNewWindow
    , iconRight
    , iconX
    , logoDev
    , logoGithub
    , logoLucamug
    , logoMedium
    , logoTwitter
    )

import Element exposing (..)
import Html
import Html.Attributes
import Html.Events
import Json.Decode
import Svg
import Svg.Attributes as SA


wrapperWithViewbox_ : String -> Int -> List (Svg.Svg msg) -> Svg.Svg msg
wrapperWithViewbox_ viewbox size listSvg =
    Svg.svg
        [ SA.xmlSpace "http://www.w3.org/2000/svg"
        , SA.preserveAspectRatio "xMinYMin slice"
        , SA.viewBox viewbox
        , SA.height <| String.fromInt size
        , Html.Attributes.attribute "role" "img"
        , Html.Attributes.attribute "aria-labelledby" "catTitle catDesc"
        ]
        ([ Svg.title [ SA.id "catTitle" ] [ Svg.text "xxx1" ]
         , Svg.desc [ SA.id "catDesc" ] [ Svg.text "xxx1" ]
         ]
            ++ listSvg
        )



-- <svg version="1" id="cat" viewBox="0 0 720 800" aria-labelledby="catTitle catDesc" role="img">
--   <title id="catTitle">Pixels, My Super-friendly Cat</title>
--   <desc id="catDesc">An illustrated gray cat with bright green blinking eyes.</desc>


wrapperWithViewbox : String -> Int -> List (Svg.Svg msg) -> Element.Element msg
wrapperWithViewbox viewbox size listSvg =
    Element.html <| wrapperWithViewbox_ viewbox size listSvg


iconX : String -> Int -> Element.Element msg
iconX cl size =
    wrapperWithViewbox "0 0 32 32"
        size
        [ Svg.path [ SA.fill "none", SA.d "M0 0h32v32H0z" ] []
        , Svg.path [ SA.fill cl, SA.d "M27 6.5L25.5 5 16 14.5 6.5 5 5 6.5l9.5 9.5L5 25.5 6.5 27l9.5-9.5 9.5 9.5 1.5-1.5-9.5-9.5L27 6.5z" ] []
        ]


iconOpenNewWindow : String -> Int -> Element msg
iconOpenNewWindow cl size =
    wrapperWithViewbox
        "0 0 100 100"
        size
        [ Svg.path
            [ SA.fill cl
            , SA.fillRule "evenodd"
            , SA.d "M76 18L47 47a4 4 0 006 6l29-29v10a4 4 0 008 0V14a4 4 0 00-4-4H66a4 4 0 000 8h10zm14 40V39v41c0 6-4 10-9 10H19c-5 0-9-4-9-10V20c0-6 4-10 9-10h43-20a4 4 0 110 8H20c-1 0-2 1-2 3v58c0 2 1 3 2 3h60c1 0 2-1 2-3V58a4 4 0 118 0z"
            ]
            []
        ]


logoLucamug : Int -> Element msg
logoLucamug size =
    wrapperWithViewbox "0 0 100 100"
        size
        [ Svg.path [ SA.fill "none", SA.d "M0 0h100v100H0z" ] []
        , Svg.circle [ SA.fill "tomato", SA.cx "50", SA.cy "50", SA.r "50" ] []

        -- , Svg.circle [ SA.fill "#bbb", SA.cx "50", SA.cy "50", SA.r "50" ] []
        , Svg.path [ SA.fill "#1e90ff", SA.d "M7.08 75.56c15.99 26.67 48.3 29.6 67.15 18.12-26.07-5.25-35.78-28.79-38.08-45.75-3.78.16-10.83-.05-15.76.13-3.08 17.08-7.86 21.09-13.3 27.5z" ] []

        -- , Svg.path [ SA.fill "#000", SA.d "M7.08 75.56c15.99 26.67 48.3 29.6 67.15 18.12-26.07-5.25-35.78-28.79-38.08-45.75-3.78.16-10.83-.05-15.76.13-3.08 17.08-7.86 21.09-13.3 27.5z" ] []
        , Svg.path [ SA.fill "#fff", SA.d "M3 43h15c4 0 4-5 0-5h-5c-1 0-1-1 0-1h22c4 0 4-5 0-5H7c-3 0-3 5 0 5h3c1 0 1 1 0 1l-8.55-.01C1.17 39.25.75 41.02.48 43zM93.84 60.95l-15-.05c-4-.01-4.01 4.99-.01 5l5 .02c1 0 1 1 0 1l-22-.07c-4 0-4.02 5-.02 5l28 .08c3 .01 3.02-4.99.02-5h-3c-1 0-1-1 0-1s5 0 10.6.07c.57-1.86.9-3 1.38-5zM20.21 47.62c-1.18 9.56-3.53 14.69-7.65 21.43 4.4 3.03 8.93-15.48 10.16-14.95 1.68.08-1.97 12.74-.52 12.88 1.58-.1 2.82-8.28 4.8-8.31 1.78.29 2.3 9.16 4.12 8.7 1.85-.31-.07-12.13 2.05-13.07 1.87-.2 5.07 16.32 9.59 14.85-3.63-7.02-5.7-14.78-6.7-21.47-4.54.05-11.69-.04-15.85-.06z" ] []
        ]


logoGithub : Int -> Element msg
logoGithub size =
    wrapperWithViewbox "0 0 256 250"
        size
        [ Svg.path [ SA.fill "#161614", SA.d "M128 0a128 128 0 00-40.5 249.5c6.4 1.1 8.8-2.8 8.8-6.2l-.2-23.8C60.5 227.2 53 204.4 53 204.4c-5.8-14.8-14.2-18.8-14.2-18.8-11.6-7.9.8-7.7.8-7.7 12.9.9 19.7 13.1 19.7 13.1 11.4 19.6 30 14 37.2 10.7 1.2-8.3 4.5-14 8.1-17.1-28.4-3.3-58.3-14.2-58.3-63.3 0-14 5-25.4 13.2-34.3a46 46 0 011.3-34S71.5 49.7 96 66.3a122.7 122.7 0 0164 0c24.5-16.6 35.2-13.1 35.2-13.1a46 46 0 011.3 33.9c8.2 9 13.2 20.3 13.2 34.3 0 49.2-30 60-58.5 63.2 4.6 4 8.7 11.7 8.7 23.7l-.2 35.1c0 3.4 2.4 7.4 8.8 6.1A128 128 0 00128 0zM48 182.3c-.3.7-1.3.9-2.3.4-.9-.4-1.4-1.3-1.1-1.9.3-.6 1.3-.8 2.2-.4 1 .4 1.5 1.3 1.1 2zm6.2 5.7c-.6.5-1.8.3-2.6-.6-.8-1-1-2.1-.4-2.7.7-.6 1.8-.3 2.7.6.8.9 1 2 .3 2.7zm4.4 7.1c-.8.6-2.1 0-2.9-1-.8-1.2-.8-2.6 0-3.1.8-.6 2 0 2.9 1 .8 1.2.8 2.6 0 3.1zm7.3 8.4c-.7.7-2.2.5-3.3-.5-1.1-1-1.5-2.5-.8-3.3.8-.8 2.3-.5 3.4.5 1 1 1.4 2.5.7 3.3zm9.4 2.8c-.3 1-1.7 1.4-3.2 1-1.4-.4-2.4-1.6-2.1-2.6.3-1 1.7-1.5 3.2-1 1.5.4 2.4 1.6 2.1 2.6zm10.7 1.2c0 1-1.1 1.9-2.7 2-1.5 0-2.7-.9-2.8-2 0-1 1.2-1.9 2.8-1.9 1.5 0 2.7.8 2.7 1.9zm10.6-.4c.2 1-.9 2-2.4 2.3-1.5.3-2.8-.3-3-1.3-.2-1.1.9-2.2 2.3-2.4 1.6-.3 3 .3 3.1 1.4z" ] []
        ]


logoMedium : Int -> Element msg
logoMedium size =
    wrapperWithViewbox "0 0 256 256"
        size
        [ Svg.path [ SA.fill "#12100E", SA.d "M0 0h256v256H0z" ] []
        , Svg.path [ SA.fill "#ffffff", SA.d "M61 86l-2-6-16-19v-3h50l38 84 34-84h48v3l-14 13-2 4v96l2 4 13 13v3h-67v-3l14-13 1-4V96l-38 98h-6L71 96v66c0 2 1 5 3 7l18 22v3H41v-3l18-22c2-2 3-5 2-7V86z" ] []
        ]


logoTwitter : Int -> Element msg
logoTwitter size =
    wrapperWithViewbox "0 0 24 24"
        size
        [ Svg.path [ SA.fill "#000000", SA.d "M24 5h-3l2-2-3 1a5 5 0 00-8 4C8 8 4 6 2 3c-2 2-1 5 1 7L1 9c0 2 2 5 4 5H3c0 2 2 3 4 3-2 2-4 3-7 3l8 2c9 0 14-8 14-15l2-2z" ] []
        ]


logoDev : Int -> Element msg
logoDev size =
    wrapperWithViewbox "0 0 132 65"
        size
        [ Svg.path [ SA.d "M0 33v32h11.3c12.5 0 17.7-1.6 21.5-6.5 3.8-4.8 4.4-9 4-28-.3-16.8-.5-18.2-2.7-21.8C30.3 2.5 26.1 1 12 1H0v32zm23.1-19.1c2.3 1.9 2.4 2.3 2.4 18.5 0 15.7-.1 16.7-2.2 18.8-1.7 1.6-3.5 2.2-7 2.2l-4.8.1-.3-20.8L11 12h4.9c3.3 0 5.6.6 7.2 1.9zm23-10.3c-2 2.6-2.1 3.9-2.1 29.6v26.9l2.5 2.4c2.3 2.4 2.9 2.5 16 2.5H76V54.1l-10.2-.3-10.3-.3v-15l6.3-.3 6.2-.3V27H55V12h21V1H62.1c-13.9 0-14 0-16 2.6zM87 15.2L94.6 44c3.2 12.3 4.3 15 7 17.7 1.9 2 4.2 3.3 5.7 3.3 3.1 0 7.1-3.1 8.5-6.7 1-2.6 15.2-55.6 15.2-56.8 0-.3-2.8-.5-6.2-.3l-6.3.3-5.6 21.5c-3.5 13.6-5.8 20.8-6.2 19.5C105.9 40 96 1.9 96 1.4c0-.2-2.9-.4-6.4-.4h-6.4L87 15.2z" ] []
        ]


iconLeft : String -> Int -> Element msg
iconLeft cl size =
    wrapperWithViewbox "0 0 443.5 443.5"
        size
        [ Svg.path [ SA.fill cl, SA.d "M143 222L336 29a17 17 0 00-24-24L107 210c-6 6-6 17 0 24l205 205a17 17 0 0024-24L143 222z" ] []
        ]


iconRight : String -> Int -> Element msg
iconRight cl size =
    wrapperWithViewbox "0 0 512 512"
        size
        [ Svg.path [ SA.fill cl, SA.d "M388 242L152 6a20 20 0 00-28 28l222 222-222 222a20 20 0 1028 28l236-236a20 20 0 000-28z" ] []
        ]
