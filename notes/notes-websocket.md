
# websocat

test with echo server:
websocat ws://ws.vi-server.org/mirror

serve and listen for incoming messages:
websocat -s 1234

connect to server and send messages:
websocat ws://127.0.0.1:1234/

websocat -t ws-l:127.0.0.1:1234 broadcast:mirror:
websocat ws://127.0.0.1:1234

http://localhost:3000

lua require'tools_websocket'.start()
lua require'tools_websocket'.stop()
lua require'tools_websocket'.post( '{ aa: "one", bb: 12 }' )
lua require'tools_websocket'.post( 'hi there!' )

lua require'plenary.reload'.reload_module('tools_websocket')

echo g:ws_received
lua put( vim.g.sometestvar )
lua print( vim.g.sometestvar )

hi there!
"eins"
"{aa: 22, bb: 'one'}"
"{'aa': 22}"
{aa: 23, bb: 'one'}

"22, ab']"

abc 1,2
test [3, 4]

"[3, 4]"
[3, 4]

{"aa": 23}
{"aa": [3, 4]}
{"aa": [3, 4]}

{aa: 44, bb: "eins"}
{aa: 44, bb: "zwei"}

{ id: 'node_0', style: { label: { value: 'n0' } } }

{ id: 'node_0', style:
  { label: { value: 'n0' } } }

{ id: 'node_1',
  style: { label: { value: 'n1' } } }


# json repl

gej
in a js file i can normally evaluate expressions
and see the results object in float win.

gen
evaluate the test expression in the context of the file as normal.
but don't console log the result and receive and show it in vim.
instead, JSON.stringify the resulting (assumed JS) collection,
and write it to a json file.

now this serialized output value should be pushed into React state

this repl value can be just one fetch URL


cmd: fetch json







