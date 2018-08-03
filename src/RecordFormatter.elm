module RecordFormatter exposing (toString)

{-| Module to format Elm Records

# Parse a record into a String
@docs toString

Examples can be found on the dmo hosted on Github Pages: https://ryan-senn.github.io/elm-record-formatter-demo

-}

import String

{-| Parse a record into a String.

This comes in handy when trying to print a record to the screen, especially in a <pre> tag.
Bundled with code highlighting you can print record quite nicely.

    RecordFormatter.toString
        { hello = "Good morning Sir, how are we today?"
        , ayy = "macarena"
        }
    ==
    "{ hello = \"Good morning Sir, how are we today?\"\n, ayy = \"macarena\" \n}"

Also works with deeply nested records, Union types etc.

    RecordFormatter.toString
        { hello = Just 5
        , ayy =
            { extra = "Stuff in the middle"
            , let_ =
                { the =
                    { nesting =
                        { begin = "I feel very nested" }
                    }
                }
            }
        }
        ==
        "{ hello = Just 5\n, ayy = \n    { extra = \"Stuff in the middle\"\n    , let_ = \n        { the = \n            { nesting = \n                { begin = \"I feel very nested\" \n                } \n            } \n        } \n    } \n}"

-}
toString : record -> String
toString =
    Basics.toString >> String.toList >> List.foldl format (Accumulator "" -4 False False) >> .string


type alias Accumulator =
    { string : String
    , indentation : Int
    , isString : Bool
    , isEscaped : Bool
    }


format : Char -> Accumulator -> Accumulator
format char acc =
    case (char, acc.isString, acc.isEscaped) of
        ('"', False, False) ->
            { acc | string = acc.string ++ String.fromChar char, isString = True }

        ('"', True, False) ->
            { acc | string = acc.string ++ String.fromChar char, isString = False }

        ('\\', True, False) ->
            { acc | string = acc.string ++ String.fromChar char, isEscaped = True }

        ('\\', True, True) ->
            { acc | string = acc.string ++ String.fromChar char, isEscaped = False }

        ('(', False, _) -> newLine '(' 4 4 acc
        ('[', False, _) -> newLine '[' 4 4 acc
        ('{', False, _) -> newLine '{' 4 4 acc
        (')', False, _) -> newLine ')' 0 -4 acc
        (']', False, _) -> newLine ']' 0 -4 acc
        ('}', False, _) -> newLine '}' 0 -4 acc
        (',', False, _) -> newLine ',' 0 0 acc
        (other, _, _) -> { acc | string = acc.string ++ String.fromChar other }


newLine : Char -> Int -> Int -> Accumulator -> Accumulator
newLine char indentation nextIndentation acc =
    { acc
        | string = acc.string ++ (if String.isEmpty acc.string then "" else "\n") ++ String.repeat (acc.indentation + indentation) " " ++ String.fromChar char
        , indentation = acc.indentation + nextIndentation
    }