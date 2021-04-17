module Utils.SimpleMarkdown exposing
    ( MarkDown
    , elementMarkdown
    , elementMarkdownAdvanced
    , markdown
    )

import Array
import Element exposing (..)
import Element.Font as Font
import Html
import Regex
import Utils.Utils



-- ███████ ██ ███    ███ ██████  ██      ███████     ███    ███  █████  ██████  ██   ██ ██████   ██████  ██     ██ ███    ██
-- ██      ██ ████  ████ ██   ██ ██      ██          ████  ████ ██   ██ ██   ██ ██  ██  ██   ██ ██    ██ ██     ██ ████   ██
-- ███████ ██ ██ ████ ██ ██████  ██      █████       ██ ████ ██ ███████ ██████  █████   ██   ██ ██    ██ ██  █  ██ ██ ██  ██
--      ██ ██ ██  ██  ██ ██      ██      ██          ██  ██  ██ ██   ██ ██   ██ ██  ██  ██   ██ ██    ██ ██ ███ ██ ██  ██ ██
-- ███████ ██ ██      ██ ██      ███████ ███████     ██      ██ ██   ██ ██   ██ ██   ██ ██████   ██████   ███ ███  ██   ████


type MarkDown
    = MarkDownText String
    | MarkDownLink String String
    | MarkDownBold String


maybeRegexForLinks : Maybe Regex.Regex
maybeRegexForLinks =
    -- This regex match constructs like "[Link text](Url)"
    Regex.fromString "\\[([^\\[\\]]+)\\]\\(([^()]+)\\)"


maybeRegexForBold : Maybe Regex.Regex
maybeRegexForBold =
    -- This regex match constructs like "*bold text*"
    Regex.fromString "\\*([^*]+)\\*"


markDownParseLinkData : List String -> MarkDown
markDownParseLinkData data =
    let
        text1 =
            Maybe.withDefault "" <| List.head data

        text2 =
            Maybe.withDefault "" <| List.head (Maybe.withDefault [] <| List.tail data)
    in
    MarkDownLink text1 text2


parseTextForBold : String -> List MarkDown
parseTextForBold text =
    --
    -- This function turn a bold text
    --
    -- "a*b*c"
    --
    -- into something like
    --
    -- [ MarkDownText "a"
    -- , MarkDownBold "b"
    -- , MarkDownText "c"
    -- ]
    --
    let
        ( find, split ) =
            case maybeRegexForBold of
                Just regex ->
                    ( Regex.find regex text, Regex.split regex text )

                Nothing ->
                    ( [], [] )
    in
    List.concat <|
        List.indexedMap
            (\index splitted ->
                let
                    maybeGetFinding =
                        case Array.get index (Array.fromList find) of
                            Just match ->
                                Just <|
                                    List.map
                                        (\item_ ->
                                            case item_ of
                                                Just i ->
                                                    i

                                                Nothing ->
                                                    ""
                                        )
                                        match.submatches

                            Nothing ->
                                Nothing
                in
                case maybeGetFinding of
                    Just getFinding ->
                        [ MarkDownText splitted
                        , markDownParseBoldData getFinding
                        ]

                    Nothing ->
                        [ MarkDownText splitted ]
            )
            split


markDownParseBoldData : List String -> MarkDown
markDownParseBoldData data =
    let
        text1 =
            Maybe.withDefault "" <| List.head data
    in
    MarkDownBold text1


parseTextForLinks : String -> List MarkDown
parseTextForLinks text =
    --
    -- This function turn a string like
    --
    -- "a[link1](label1)b[link2](label2)c"
    --
    -- into something like
    --
    -- [ MarkDownText "a"
    -- , MarkDownLink "link1" "label1"
    -- , MarkDownText "b"
    -- , MarkDownLink "link2" "label2"
    -- , MarkDownText "c"
    -- ]
    --
    -- It can be used to embedd links inside translations
    --
    let
        ( find, split ) =
            case maybeRegexForLinks of
                Just regex ->
                    ( Regex.find regex text, Regex.split regex text )

                Nothing ->
                    ( [], [] )
    in
    List.concat <|
        List.indexedMap
            (\index splitted ->
                let
                    maybeGetFinding =
                        case Array.get index (Array.fromList find) of
                            Just match ->
                                Just <|
                                    List.map
                                        (\item_ ->
                                            case item_ of
                                                Just i ->
                                                    i

                                                Nothing ->
                                                    ""
                                        )
                                        match.submatches

                            Nothing ->
                                Nothing
                in
                case maybeGetFinding of
                    Just getFinding ->
                        [ MarkDownText splitted
                        , markDownParseLinkData getFinding
                        ]

                    Nothing ->
                        [ MarkDownText splitted ]
            )
            split


markdown : (String -> b) -> (String -> b) -> (String -> String -> b) -> String -> List b
markdown boldGenerator textGenerator linkGenerator string =
    let
        step1 =
            parseTextForLinks string

        step2 =
            List.concat <|
                List.map
                    (\item ->
                        case item of
                            MarkDownText string_ ->
                                parseTextForBold string_

                            _ ->
                                [ item ]
                    )
                    step1
    in
    List.map
        (\item ->
            case item of
                MarkDownText text ->
                    textGenerator text

                MarkDownBold text ->
                    boldGenerator text

                MarkDownLink linkLabel url ->
                    linkGenerator linkLabel url
        )
        step2


elementBoldGenerator : String -> Element.Element msg
elementBoldGenerator string =
    el [ Font.bold ] <| Element.text string


elementTextGenerator : String -> Element.Element msg
elementTextGenerator string =
    Element.text string


elementLabelGenerator : String -> Element.Element msg
elementLabelGenerator string =
    -- Element.text string
    paragraph [] [ Element.text <| string ++ " ", Utils.Utils.iconOpenNewWindow "#0030d0" 13 ]


elementLinkGenerator : String -> String -> Element.Element msg
elementLinkGenerator linkLabel url =
    Element.newTabLink []
        { url = url
        , label =
            elementLabelGenerator linkLabel
        }


elementLinkGeneratorAdvanced :
    { a
        | link : List (Element.Attribute msg)
    }
    -> String
    -> String
    -> Element.Element msg
elementLinkGeneratorAdvanced attrs linkLabel url =
    Element.newTabLink attrs.link { url = url, label = elementLabelGenerator linkLabel }


elementMarkdown : String -> List (Element.Element msg)
elementMarkdown string =
    markdown elementBoldGenerator elementTextGenerator elementLinkGenerator string


elementMarkdownAdvanced :
    { link : List (Element.Attribute msg) }
    -> String
    -> List (Element.Element msg)
elementMarkdownAdvanced attrs string =
    let
        parts =
            String.split "\n" string
    in
    List.concat <|
        List.map
            (\part ->
                markdown elementBoldGenerator elementTextGenerator (elementLinkGeneratorAdvanced attrs) part
                    ++ [ html <| Html.br [] [] ]
            )
            parts
