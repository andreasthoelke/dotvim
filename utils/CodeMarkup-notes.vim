" Navigating and editing long sources files using markup and textobjects
"
"
"
" Code Markup
"   more visual and navigational structure
"   highlights
"   motions and textobjects



" ─   Examples          
" Another one: but now content is below
" Another: but now content is below
" and multiple lines
" Test Three:
" but now content is below
" and multiple lines

" ─   Structure         
" words
" arguments, parans (next argument navigation), type signature, list, string
" lines
" paragraph / and native paragraph
" top-level def
" folds (zj z)
" hunks/errors/spells (s] sj?)
" labels
" headers
" sections

" how can I unify jumps to objects and end of objects with the content/around/inside reference?
" words, lines, paragraphs sort of have this
" but not vim-targets? (other textobject examples? - there is def. reuse of the patters)

" folds are sort of related to longer jumps or textobjects - can easily be created/deleted

" zj/k z]z[ are native and work well for folds
" c-l/h for paragraphs, ,c-l for end of paragraph
"   is really convienient - like scrolling
" c-n/p is a more highlevel - to navigate labels and headers
" but what if I only want headers and sections? 
" ** should have these three objects in tagbar
" There is also 'next haskell/vim top-level devinition' playing into this
" there is also next hunks and next warning/ale/gitgutter

" How to create headers, labels and sections
" how to change them?

" Another one: but now content is below
" Another: but now content is below
" and multiple lines
" Test Three:
" but now content is below
" and multiple lines

" This is but maybe. I this is longer .. it would not be a label: and that can be brief


" a section is closed when an end marker is created
"   the map/command automatically uses the header txt of the previous sectionheader
" also when a section end marker is created, fold markers are added
" to the section start and end lines

" Headings are not folds by default but can easily be made to folds)
" Headings may have no fold start markers
" you can add a manual fold. cursor on the header line: "zf\j.." or vis-sel

" ─   Todos                                             ──
" labels could be indented
"        should be limied in length and not contain dots
" make header of commented line
" support haskell comments in highlighing
" use haskell/vim comments depend on file type

" delete header (and end marker) but leave headline text to edit? then recreate?
" include optional foldmarkers
" automatically when an end line is created
" reformat section end after change of header text
" also update an end marker if exsistent

" go to next/prev section header (not end header)
" go to end → text object
" go to next/prev label
" → all these consistent in mapping and implementation

" Textobjects:
" inside section header
" inside section
" around section
" inside label

" ─   Some tests                                         ■
" call append( line('.'), 'line below')
" /\v^("|--)\s─(\^|\s)\s{2}\u.*\S\s*──$
" call search('\v^("|--)\s─(\^|\s)\s{2}\zs\u.*\S\ze\s*──$')
" call search('\v^("|--)\s─\s{3}\zs\u.*\S\ze\s*──$', 'bW')
" echo matchstr(getline (line('.') -1), '\v^("|--)\s─(\^|\s)\s{2}\zs\u.*\S\ze\s*──')
" echo matchstr(getline (line('.') -1), '[a-z]*t')
" ─^  Some tests                                         ▲


" ─   Maps                                              ──
" Test on these lines

" normal Headings
" ─   Utils fold                                        ──

" ─   Utils traverse                                    ──


" Heading with manually created fold
" this may be created until/around the next heading to then fold headings
" ─   Utils fold                                        ── ■

" more
" ▲

" Sections are created as headings, then creating the end line will delete the end dashes in the heading!
" so they are different from headings with manual folds

" let [sl, sc] = searchpos(a:opening, 'bcW') " search left for opening

" ─   Helpers                                            ■



" ─^  Helpers                                            ▲

" ─   Sometest                                          ──


