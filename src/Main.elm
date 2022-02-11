port module Main exposing (conf, main)

import Browser
import Browser.Events
import Browser.Navigation
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events as Events
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import Html.Events
import Json.Decode
import Json.Encode
import List.Extra
import Markdown
import Projects.Project as Item
import Starter.ConfMain
import Starter.SnippetJavascript
import Url
import Url.Builder
import Url.Parser exposing ((</>))
import Utils.Utils


conf : Starter.ConfMain.Conf
conf =
    { urls = [ "/" ] ++ List.map (\item -> urlBuilder (Item.id item)) Item.items
    , assetsToCache = []
    }


type alias Model =
    { route : Route }


type alias Flags =
    { locationHref : String }


locationHrefToRoute : String -> Route
locationHrefToRoute locationHref =
    locationHref
        |> Url.fromString
        |> Maybe.andThen updateRoute
        |> Maybe.withDefault RouteTop


preventDefault : msg -> Html.Attribute msg
preventDefault msg =
    Html.Events.preventDefaultOn "click" (Json.Decode.succeed ( msg, True ))


linkInternal :
    (String -> msg)
    -> List (Attribute msg)
    -> { label : Element msg, url : String }
    -> Element msg
linkInternal internalLinkClicked attrs args =
    link
        ((htmlAttribute <| preventDefault (internalLinkClicked args.url)) :: attrs)
        args


init : Flags -> ( Model, Cmd msg )
init flags =
    let
        newRoute =
            locationHrefToRoute flags.locationHref
    in
    ( { route = newRoute }
    , cmdOnRouteChange newRoute
    )


emptyUrl : Url.Url
emptyUrl =
    { protocol = Url.Https
    , host = ""
    , port_ = Nothing
    , path = ""
    , query = Nothing
    , fragment = Nothing
    }


type Route
    = RouteTop
    | RouteList
    | RouteItem String


type Msg
    = DoNothing
    | InternalLinkClicked String
    | UrlChanged Route
    | KeyDown Int
    | CloseModal


urlBuilder : String -> String
urlBuilder id =
    String.toLower <| Url.Builder.absolute [ Item.conf.urlLabel, idEncoder id ] []


urlBuilderWithoutEncoder : String -> String
urlBuilderWithoutEncoder id =
    String.toLower <| Url.Builder.absolute [ Item.conf.urlLabel, String.replace " " "_" id ] []


urlParser : Url.Parser.Parser (String -> c) c
urlParser =
    Url.Parser.s Item.conf.urlLabel </> Url.Parser.string


parseUrl : Url.Url -> Maybe String
parseUrl url =
    url
        |> (\url_ -> { url_ | path = String.replace "_" " " url_.path })
        |> Url.Parser.parse urlParser
        |> Maybe.andThen Url.percentDecode


idEncoder : String -> String
idEncoder id =
    Url.percentEncode (String.replace " " "_" id)


idDecoder : String -> String
idDecoder id =
    String.toLower <| String.replace "_" " " (Maybe.withDefault id <| Url.percentDecode id)


idToMaybeItem : String -> Maybe Item.Item
idToMaybeItem id =
    let
        decodedId =
            idDecoder id
    in
    List.head <| List.filter (\item -> String.toLower (Item.id item) == decodedId) Item.items


idToItem : String -> Item.Item
idToItem id =
    Maybe.withDefault Item.itemNotFound (idToMaybeItem id)


routex : Url.Parser.Parser (Route -> b) b
routex =
    Url.Parser.oneOf
        [ Url.Parser.map RouteList (Url.Parser.s "list")
        , Url.Parser.map RouteItem (Url.Parser.s Item.conf.urlLabel </> Url.Parser.string)
        , Url.Parser.map RouteTop Url.Parser.top
        ]


updateRoute : Url.Url -> Maybe Route
updateRoute url =
    Url.Parser.parse routex url


port modalOpen : Bool -> Cmd msg


port onUrlChange : (String -> msg) -> Sub msg


port pushUrl : String -> Cmd msg


port changeMeta : ( String, String, String ) -> Cmd msg


cmdOnRouteChange : Route -> Cmd msg
cmdOnRouteChange route =
    case isItemShowing route of
        Nothing ->
            modalOpen False

        Just _ ->
            modalOpen True


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        InternalLinkClicked path ->
            ( model, pushUrl path )

        UrlChanged route ->
            ( { model | route = route }
            , Cmd.batch
                [ cmdOnRouteChange route
                , changeMeta ( "title", "innerHTML", "new Title" )
                ]
            )

        CloseModal ->
            closeModal model

        KeyDown key ->
            if key == 27 then
                -- Close the modal if the escape button is pressed and
                -- a modal is open
                closeModal model

            else if key == 37 || key == 38 then
                let
                    ( previous, next ) =
                        case isItemShowing model.route of
                            Just id ->
                                previousNext id

                            Nothing ->
                                ( Nothing, Nothing )
                in
                case previous of
                    Just url ->
                        ( model, pushUrl url )

                    Nothing ->
                        ( model, Cmd.none )

            else if key == 39 || key == 40 then
                let
                    ( previous, next ) =
                        case isItemShowing model.route of
                            Just id ->
                                previousNext id

                            Nothing ->
                                ( Nothing, Nothing )
                in
                case next of
                    Just url ->
                        ( model, pushUrl url )

                    Nothing ->
                        ( model, Cmd.none )

            else
                ( model, Cmd.none )


closeModal : Model -> ( Model, Cmd Msg )
closeModal model =
    case model.route of
        RouteItem itemItem ->
            ( model
            , pushUrl "/"
            )

        _ ->
            ( model, Cmd.none )


isItemShowing : Route -> Maybe String
isItemShowing route =
    case route of
        RouteTop ->
            Nothing

        RouteList ->
            Nothing

        RouteItem id ->
            Just id


previousNext : String -> ( Maybe String, Maybe String )
previousNext id =
    let
        item =
            idToItem id

        presentIndex =
            List.Extra.elemIndex item Item.items

        previous =
            case presentIndex of
                Just index ->
                    if index > 0 then
                        List.Extra.getAt (index - 1) Item.items
                            |> Maybe.map Item.id
                            |> Maybe.map urlBuilder

                    else
                        Nothing

                Nothing ->
                    Nothing

        next =
            case presentIndex of
                Just index ->
                    if index < List.length Item.items then
                        List.Extra.getAt (index + 1) Item.items
                            |> Maybe.map Item.id
                            |> Maybe.map urlBuilder

                    else
                        Nothing

                Nothing ->
                    Nothing
    in
    ( previous, next )


view : Model -> Html.Html Msg
view model =
    Html.div
        [ Html.Attributes.id "elm" ]
        (case model.route of
            RouteList ->
                List.indexedMap
                    (\index item ->
                        Html.div []
                            [ Html.h3 [] [ Html.text <| String.fromInt (index + 1) ++ ". " ++ item.title ]
                            , Html.p []
                                [ Html.text item.review
                                ]
                            ]
                    )
                    Item.items

            _ ->
                [ Html.a [ Html.Attributes.class "skip-link", Html.Attributes.href "#main" ]
                    [ Html.text "Skip to main" ]
                , layout
                    ([ Font.size 16
                     , case isItemShowing model.route of
                        Nothing ->
                            htmlAttribute <| Html.Attributes.class ""

                        Just _ ->
                            htmlAttribute <| Html.Attributes.class "modal-open"
                     , case isItemShowing model.route of
                        Nothing ->
                            inFront none

                        Just _ ->
                            inFront <|
                                el
                                    [ Background.color <| rgba 0 0 0 0.3
                                    , width fill
                                    , height fill
                                    , Events.onClick CloseModal
                                    ]
                                <|
                                    none
                     ]
                        ++ (case isItemShowing model.route of
                                Nothing ->
                                    []

                                Just id ->
                                    viewOverlay id
                           )
                    )
                  <|
                    viewMainPage model
                ]
        )


viewOverlay : String -> List (Attribute Msg)
viewOverlay id =
    let
        item =
            idToItem id

        ( previous_, next_ ) =
            previousNext id

        previous =
            case previous_ of
                Just url ->
                    linkInternal
                        InternalLinkClicked
                        [ alignLeft
                        , centerY
                        , moveRight 10
                        , padding 20
                        , Background.color <| rgba 1 1 1 0.5
                        , Border.rounded 50
                        , htmlAttribute <| Html.Attributes.name "Previous"
                        ]
                        { url = url
                        , label = Utils.Utils.iconLeft "#000" 48
                        }

                Nothing ->
                    none

        next =
            case next_ of
                Just url ->
                    linkInternal
                        InternalLinkClicked
                        [ alignRight
                        , centerY
                        , moveLeft 10
                        , padding 20
                        , Background.color <| rgba 1 1 1 0.5
                        , Border.rounded 50
                        , htmlAttribute <| Html.Attributes.name "Next"
                        ]
                        { url = url
                        , label = Utils.Utils.iconRight "#000" 48
                        }

                Nothing ->
                    none
    in
    [ inFront <|
        el
            [ centerX
            , moveDown 20
            , htmlAttribute <| Html.Attributes.style "height" "calc(100vh - 40px)"
            , htmlAttribute <| Html.Attributes.style "max-width" "min(600px, calc(100vw - 40px))"
            , Border.rounded 10
            , Border.shadow { offset = ( 0, 4 ), size = 0, blur = 10, color = rgba 0 0 0 0.2 }
            , scrollbarY
            , Background.color <| rgb 1 1 1
            ]
        <|
            Item.viewDetails item
    , inFront <| previous
    , inFront <| next
    , inFront <|
        linkInternal
            InternalLinkClicked
            [ alignRight
            , htmlAttribute <| Html.Attributes.name "Close"
            , htmlAttribute <| Html.Attributes.title "Close"
            ]
            { url = "/"
            , label =
                el
                    [ padding 20
                    , Background.color <| rgba 1 1 1 0.5
                    , Border.roundEach { topLeft = 0, topRight = 0, bottomLeft = 20, bottomRight = 0 }
                    ]
                <|
                    Utils.Utils.iconX "" 30
            }
    ]


viewMainPage : Model -> Element Msg
viewMainPage model =
    case model.route of
        -- RoutePageGeneratorOptions ->
        --     html <| Html.pre [] [ Html.text sitemapGenerator ]
        _ ->
            column
                [ padding Item.conf.spacingSize
                , spacing Item.conf.spacingSize
                , Background.color <| Item.conf.backgroundColor -- rgb255 239 168 25
                , Font.color <| Item.conf.fontColor -- rgb 1 1 1
                , htmlAttribute <| Html.Attributes.id "main"
                ]
                [ html <| Html.node "style" [] [ Html.text css ]
                , column [] [ Item.viewTitle ]
                , wrappedRow [ spacing Item.conf.spacingSize ] <|
                    List.indexedMap
                        (\index item ->
                            Item.cardWrapper (linkInternal InternalLinkClicked) index item (urlBuilder (Item.id item))
                        )
                        Item.items
                ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ onUrlChange (locationHrefToRoute >> UrlChanged)
        , Browser.Events.onKeyDown (Json.Decode.map KeyDown Html.Events.keyCode)
        ]


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


css : String
css =
    """
body.modal-open {
    height: 100vh;
    overflow-y: hidden;
}

.card {
    transition: 1s;
    letter-spacing: 0.5px;
}

.card:hover {
    transition: 0.1s;
}

.skip-link {
  position: absolute;
  top: -40px;
  left: 0;
  background: #000000;
  color: white;
  padding: 8px;
  z-index: 100;
}

.skip-link:focus {
  top: 0;
}"""
