
" HsMotions:
" Only think aligned/alongside/about the structure and syntax of you code

" Go 3 lines down and 4 words in is still ok - but not ideal because
"  - you ought to not read a haskell function line by line
"  - vim/text words don't represent you thinking well either

" Think top-down, alongside the hierachies of composed expressions
" not wordwise
" the cursor is a point of focus, reference - moving it can expand/highlight a structure - help your thinking
" avoid mental switching
" pronounce expressions, work alongside/support not intefer with top-down units of syntactical thinking
" should be predictable
" reach next thinking step with just 3 keystrokes - 3 are perfectly memorable as a rythimic sequence
" 

" Status quo/ Approaches:
" " <--  intuition ....... thinking - learning automating -->
  " 1. mouse scrolling and pointing
"   2. race car hjkl
"   3. text structure: w, Word, Paragraph, $, ^, targets, indention → like a monkey making clever use of branches to get
"   to the fruit in a most efficiant way. we automate this process - hardly need to conciously process the tactics.
  "   has good training/automation effects, is perceived as fun some mental gymnastics that is nice to perform alongside
"   thinking about syntax and programming.
  "   - disadvatage: the motions can not be reversed to go back and forth between two spots: illustrate by example where
    "   you hangle from beginning or end of line
"   4. search: 'f', easymotion, search
"   5. syntactic: substitute 2nd arg or expression is more likely to be repeatable
"   6. semantic/labeling structure
"   7. heuristic/convention based

"   typical programmers learning curve evolves from 1 to 4
"   start using w-b as a higher level/effective 'l'/'h'
"   jump to the end of the line and then back
"
"   1,2. are very low overhead/processing (you fall back to then when you are exhaused)
"   but there are no muscle memory gains/learning gains
"   no use of powerful jump back
"   3. allows these gains
"   but it still intefers requires other thinking

" navigating and editing commands/maps should be aligned to/should support your thought process
" Navigation should be aligned with the thought/metal process
" Label mode requires you to shift metal state to processing spellings/letters
" - but you should be thinking syntax, delimiter and arg- positions
" - label mode navigation seems elegant and super fast but
"   - it's actually not that fast if you consider your latency of reading a letter/label and then typing it
                                                                                             "   - it's implies constant shifting/ distraction from what you have just thought about - which probl was the syntax of
"   meaning of your code

" you need to prossess the structure of your function/def and break it down into expression starts
"  - try neovim highlight marking with some fns

" ─   Description        
" - Top level dev
"     - Indented Labels! (new!)
" - Headers
" - Labels
" - Sections

" Toplevel devs, labels, headers, sections
" all have name and content
" labels are only to structur longer comments
" labels extend to the next label or empty line

" Header Content and Header Label textobjects
" Content should extend until double empty line

" Labeled Content and Label text textobjects?

" Section label and section content textobjects

" ─   Operators          
" Yank, Substitute, Change, Delete, Replace, Uppercase

" ─   Mapps          

" Object     NextStart PrevStart NextEnd PreviousEnd inside around Inside Around LabelForw LabelBack
" word       w         b         e       ge          iw     aw     Iw     Aw     \w        \b
" WORD       W         B         E       gE          iW     aW
" Line       j0        k0        j$      k$          il     al                   \j        \k
" ,('                                                i,     a'     I,     A,
" ExprInner  q         t
" ExprOuter  Q         T
" Wire       ,q        ,t
" Comma      \q        \t
" intoComma
"
" TypeArg
" ApFnArg
" Paragraph  c-l       c-h       ,c-l    ,c-h        ip     ap                   \c-l      \c-h
" method     ]m                  ]M
" TopLevDef  c-n       c-p       ..                  if     af
                                                        "  name
"  content
" Header
"  name (u!)
"  content
" Label
"  name
"  content
" Section
"  name (u!) x
"  content


nmap <Tab> :echo 'hi there'<cr>
nmap <S-Tab> :echo 'HI THERE'<cr>

Now c-i/m
and tab shift-tab is still unmaped?

------------

c-n/p
c-i/m

Y I
J K

Q T
q t

W B
w b

Heading, Section
Label, Indented labels
Folds (are like Sections, and every section is a Fold. Headings are not folds by default but can easily be made to folds)

c-n/p Toplevel
c-lh  Paragraph

Hunks
Warnings/Errors

q t  Wireframe
W B  Expression
w b  HsWord

Q T  Comma, Into Comma
Indent (don't need this)
RHS

" ─   New maps                                          ──


--

→ copied this to .vim/notes/notes-navigation.md

-- 1. Headings & Labels
T s-T Heading
q s-q Label

-- 2. Paragraph
c-l h Paragraph| ParagVim }{
z-j k Fold

-- 3. Toplevel-fn & Area
c-n p Toplevel
c-m i Area

-- 4. Column, Comma & Line
  I Y ColumnRight
t s-t Comma| ,t ,s-t IntoComma
  J K LineStart

" 5. Small & Big Hs Words
  W B Expression
  w b HsWord



