module Projects exposing (..)

-- import BookType exposing (Book)


type alias Project =
    { name : String
    , url : String
    }


books : List Project
books =
    [ { name = "たべもののたび"
      , url = "https://example.com"
      }
    ]
