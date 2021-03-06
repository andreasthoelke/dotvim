
" Mission: To interact with Chrome and loaded websites without leaving vim

let g:js = '(function() { var nodes = document.querySelectorAll("h2"); var titles = []; for (var i = 0; i < 5; i++) { titles.push(nodes[i].innerHTML) } return titles.join(" "); })();'

let g:js = '(function() { var nodes = document.querySelectorAll("h2"); var titles = []; for (var i = 0; i < 5; i++) { titles.push(nodes[i].textContent) } return titles.join(","); })();'

let g:js = 'console.log( abc1 )'
let g:js = 'console.log("hi")'

let g:js = 'abc1 = "test"'

chrome-cli execute '(function() { var nodes = document.querySelectorAll("h2"); var titles = []; for (var i = 0; i < 5; i++) { titles.push(nodes[i].innerHTML) } return titles.join("
"); })();'

echo system('chrome-cli execute ' . shellescape(g:js))

call system('chrome-cli open http://github.com')

!chrome-cli open http://github.com
echo system('chrome-cli execute ' . shellescape(@a))


(function() {
  return document.readyState === 'complete';
})();

" Timer{{{
call timer_start(1000, 'TestHandler', {'repeat': 3})
let g:cnt = 0
func! TestHandler( timer )
  let g:cnt = g:cnt + 1
  if g:cnt > 1
    call timer_stop( a:timer )
    echo 'done'
  endif
  echo ('yes ' . g:cnt)
endfunc"}}}

silent !chrome-cli activate -t 1192
silent !chrome-cli activate -t 1182

func! Backer(foo, ...)
echo 'back: ' ++ a:foo
endfunc

could do google search with quickfix list


window.scrollBy(0, 100);
window.location = 'http://purescript.org';
window.location = 'http://github.com';
window.open('https://www.codexworld.com', '_blank');

Overview Installation JavaScript execution Usage Examples

Overview,Installation,JavaScript execution,Usage,Examples

researching, authering and sharing information
ever ote slack videos, commenting in images 
micro, mid and stratigic level - see slack, google 

chrome-cli
  Overview
  Installation
      Homebrew
      Manual
        Downloads
  JavaScript execution
  Usage
  Examples 

func! InsertHeadingTexts()
  let g:headingsStartLine = line('.')
  let g:headingTextAsLines = system('chrome-cli execute ' . shellescape( @a ))
  call append( line('.') - 1, '' )
  call append( line('.') - 2, split( g:headingTextAsLines, ',') )
  exec 'normal!' ++ g:headingsStartLine ++ 'G'
endfunc
call InsertHeadingTexts()

setlocal concealcursor=nvc conceallevel=1

prasmussen/chrome-cli: Control Google Chrome from the command line [[:432]] test
prasmussen/chrome-cli: Control Google Chrome from the command line [[:87642]]

plus aber eins drei acht

syntax match Conceal / eins  / conceal

syntax match Conceal /\[\[:\d+\]\]/ conceal


[[\:\d+\]\]

Use a vim buffer and text editing to control and organise your web browsing sessions

" include URLs in tags
" use IDs (in subnodes) as scrollTo reference
" use c-n/p to quickly scroll to header. so just rolling headers scrolls
" autofold at indention level?
" limit the number of headers, heirachichally, h1 first then h2, etc
" (google?) search through only a list of pages
" 
" Modify the pages
" hide/ collaps parts of the page
" add annotations-divs to the page

" there are tabs (when will tab ids change?) and heading sections{{{
" could pull and represent the current window into a navigation buffer
" use the fold feature
" copy references into you code comments. refs are sharable
" could save, recreate and share sessions
" can use marks at headings
" can search the headings
" can search and pull the text in the heading/section?
" search the entire page
"
" Google search
" - into quickfix list
" google search without opening the browser
" text if folded but can be searched
" i normally open some results in tabs but then might loose track
" can open a tab and then discard the search result - google search results page does not discard
" so i can manage and comment google searches}}}

" Getting the regerence tag/data from the reference label concealed tag
" This uses a regex capturing group - the part of the regex in () is available at index 1 of the return list
echo matchlist(getline('.'), '\v[[:(\d+)\]\]')[1]

" Conceal the Chrome-nav reference tags, e.g ??? [[:432]] ??? might be hidden here{{{
" Notes: - The 'Conceal' highlight/syntax group is special - activating the conceal feature
"        - in the case the regex entry is not magic? therefore I needed to use \v
"        - 10 is the priority (of hlsearch)
"        - -1 is a (non?) ID that would allow to delete the match

echo matchadd('Conceal', '\v[[:\d+\]\]', 10, -1, {'conceal': ''})
" conceallevel 1 means that matches are collapsed to one char. '2' collapses completely
set conceallevel=2
" When the concealcursor is *not* set, the conceald text will reveal when the cursor is in the line
" concealcursor=n would keeps the text conceald even if the cursor in on the line and only reveal the text in 
set concealcursor=n
" Show concealed text when cursor is in line
set concealcursor=
" set concealcursor=}}}

echo matchadd('Underlined2', '\v.+[[:\d+\]\]', 10, -1)


call matchadd('Conceal', 'eins', 10, 77, {'conceal': 'p'})
call matchadd('Conceal', 'eins', 10, 99, {'conceal': 'p'})


[752:853] Getting Started with Headless Chrome ??|?? Web ??|?? Google Developers"{{{
[752:847] Quick start ??|?? Tools for Web Developers ??|?? Google Developers
[752:1051] querySelectorAll - Google Search
[752:1054] Document.querySelectorAll() | MDN
[752:1072] Locating DOM elements using selectors | MDN
[752:1057] HTML DOM querySelectorAll() Method
[752:1060] Tryit Editor v3.6
[752:1063] CSS Syntax and Selectors
[752:1079] Exercise v3.0
[752:1088] Array.prototype | MDN
[752:1091] javascript map over nodelist - Google Search
[752:1094] NodeList | MDN
[752:1097] javascript - Filter or map nodelists in ES6 - Stack Overflow
[752:1179] es6 lambdas - Google Search
[752:1189] JavaScript's Lambda and Arrow Functions ??? Vinta Software
[752:1182] ES6 Lambda Expressions
[752:1195] repeatedly in js - Google Search
[752:1230] JavaScript String repeat() Method
[752:1233] Tryit Editor v3.6
[752:1259] PureScript
[752:1414] javascript query if page is loaded - Google Search
[752:1417] The && and || Operators in JavaScript ??? Marius Schulz
[752:1420] Detect document ready in pure JS
[752:1466] vim open url but keep focus in vim - Google Search
[752:1490] run shell command, launch app, but keep focus - Google Groups
[752:1487] Is it possible to have the output of a :! command in a split rather than the whole window? - Vi and Vim Stack Exchange
[549:550] Messenger
[549:1176] Johann Sebastian Bach - Suite for orchestra No 3 in D major, BWV 1068: Air
[1120:1121] org-pricings-costs | development Slack
[1161:1201] New Tab
[1211:1212] Haskell :: Reddit
[1211:1216] Vim/Neovim with Haskell in 2019 (+ is there any plugin that shows types upon hovering?) : haskell
[1211:1219] ghcid for the win!"}}}

func! InsertTabLabels()
  let g:tabsStartLine = line('.')
  let g:tabsInfo = system('chrome-cli list tabs')
  call append( line('.') - 1, '' )
  call append( line('.') - 2, split( g:tabsInfo, '\n' ) )
  exec 'normal!' ++ g:tabsStartLine ++ 'G'
endfunc
call InsertTabLabels()

echo system('chrome-cli list windows')
echo system('chrome-cli execute ' . shellescape(@a))

console.log(headingElems);

Here, we get a list of <p> elements whose immediate parent element is a div with the class "highlighted" and which are located inside a container whose ID is "test".

  var container = document.querySelector("#test");
var matches = container.querySelectorAll("div.highlighted > p");

var content = document.querySelector('article') || document;
var headingElems = content.querySelectorAll('h1, h2, h3, h4, h5');
(function() {
  var headingTexts = Array.from( headingElems ).map( el => {
    const indent = ' '.repeat( 2 * (el.tagName[1] - 1) );
    return indent + el.textContent;
  }).join(',');
  return headingTexts;
})();


(function() {
  var content = document.querySelector('article');
  var headingElems = content.querySelectorAll('h1, h2, h3, h4, h5');
  var headingTexts = Array.from( headingElems ).map( el => {
    const indent = ' '.repeat( 2 * (el.tagName[1] - 1) );
    return indent + el.textContent;
  }).join(',');
  return headingTexts;
})();

