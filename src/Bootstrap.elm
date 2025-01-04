port module Bootstrap exposing (Flags, main)

import Json.Decode
import Json.Encode
import Projects.Project


main : Program Flags () msg
main =
    Platform.worker
        { init = \flags -> ( (), dataFromElmToJavascript (main_ flags) )
        , subscriptions = \_ -> Sub.none
        , update = \_ () -> ( (), Cmd.none )
        }


type alias Flags =
    { commit : String
    , env : String
    , version : String
    }


type alias Model =
    { commit : String
    , version : String
    }


cmdGeneratedFolder : String
cmdGeneratedFolder =
    "cmd-generated"


fileName : BuildScript -> String
fileName buildScript =
    case buildScript of
        BuildPortal ->
            "build-portal"

        BuildWebComponents ->
            "build-wc"


type BuildScript
    = BuildPortal
    | BuildWebComponents


port dataFromElmToJavascript : Json.Encode.Value -> Cmd msg


folder : String
folder =
    "docs/"


main_ : Flags -> Json.Encode.Value
main_ flags =
    Json.Encode.object
        [ ( "removeFolders"
          , Json.Encode.list Json.Encode.string []
          )
        , ( "addFiles"
          , Json.Encode.object (List.map (Tuple.mapSecond Json.Encode.string) files)
          )
        ]


files : List ( String, String )
files =
    [ ( "README.md", readme ) ]


readme : String
readme =
    Projects.Project.items
        |> List.map itemToString
        |> String.join " ⟡ "


itemToString : Projects.Project.Item -> String
itemToString item =
    "[" ++ item.title ++ "](" ++ item.url ++ ")"
