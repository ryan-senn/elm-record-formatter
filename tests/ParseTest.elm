module ParseTest exposing (suite)

import Expect exposing (Expectation)
import Test exposing (Test, test, describe)

import RecordFormatter


suite : Test
suite =
    describe "Test parsing of records"
        [ test "Parse a record with Strings" <| always testStringRecord
        , test "Parse a record with Ints" <| always testIntRecord
        , test "Parse a record with Lists" <| always testListRecord
        , test "Parse a record with Union Types" <| always testUnionTypeRecord
        , test "Parse deeply nested record" <| always testDeeplyNestedRecord
        ]


testStringRecord : Expectation
testStringRecord =
    let
        record =
            { hello = "Good morning Sir, how are we today?"
            , ayy = "macarena"
            }

    in
        RecordFormatter.toString record
            |> Expect.equal "{ hello = \"Good morning Sir, how are we today?\"\n, ayy = \"macarena\" \n}"


testIntRecord : Expectation
testIntRecord =
    let
        record =
            { hello = 123
            , ayy = -23
            }

    in
        RecordFormatter.toString record
            |> Expect.equal "{ hello = 123\n, ayy = -23 \n}"


testListRecord : Expectation
testListRecord =
    let
        record =
            { hello = ["hello", "how", "are", "you?"]
            , ayy = [-23, 34, 45]
            }

    in
        RecordFormatter.toString record
            |> Expect.equal "{ hello = \n    [\"hello\"\n    ,\"how\"\n    ,\"are\"\n    ,\"you?\"\n    ]\n, ayy = \n    [-23\n    ,34\n    ,45\n    ] \n}"


testUnionTypeRecord : Expectation
testUnionTypeRecord =
    let
        record =
            { hello = Just 5
            , ayy = Err "Something went wrong yo"
            }

    in
        RecordFormatter.toString record
            |> Expect.equal "{ hello = Just 5\n, ayy = Err \"Something went wrong yo\" \n}"


testDeeplyNestedRecord : Expectation
testDeeplyNestedRecord =
    let
        record =
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

    in
        RecordFormatter.toString record
            |> Expect.equal "{ hello = Just 5\n, ayy = \n    { extra = \"Stuff in the middle\"\n    , let_ = \n        { the = \n            { nesting = \n                { begin = \"I feel very nested\" \n                } \n            } \n        } \n    } \n}"