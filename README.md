# Elm Record Formatter
This Module comes in handy if you want to print an Elm Record to the screen. It parses any Record into a String then adds indentation and line breaks to make it readable. You'll typically want to use it in a `<pre>` tag. Bundled with syntax highlighting, you can achieve nice results.

## Demo
https://ryan-senn.github.io/elm-record-formatter-demo

It is also used by the [stellar-sdk demo page](https://ryan-senn.github.io/stellar-elm) after submitting a REST call. The server sends a json response, it gets Decoded into Elm Records and this package is then used to print the response to the screen.