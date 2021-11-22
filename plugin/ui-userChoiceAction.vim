
" Ideas:
" Multiselect: The dialog could work in a recursive way - when an item is selected the menu is opened/refreshed again with
" that item checked. it now can be un-checked or other items can be added to the selection. 'submit' would need a
" separate command

" ─   User Choice Menu and Action                        ■
" Any function (action!) can be supplied with a user selected last argument/value.
" The user-selected option value will be passed as the last arg to the continuation function. Only string values are
" supported for now. (the list of continuation args will be supplied to any starting args of the continuation function)
" Note: that all code that aims to use the selected value/effect needs to run in the contionuationFn. (there should be no
" code-lines after the call to UserChoiceAction().
" The forth (optional) arg can either be 'showRight' (default) or 'showBottom'
" optUserPromtValue_andFirstArg (if not empty!) will be shown in the dialog *and* be used as the first arg to the continuation
func! UserChoiceAction( userPromptText, optUserPromtValue_andFirstArg, choices, continuationFn, contOtherArgs, ... )
  let windowPos = (a:0 == 6) ? a:4 : "showRight"
  " Store continuation fn+args so the "UserChoiceAction_resume" can run it
  let g:userChoiceContinuationData = { 'fn': a:continuationFn }
  let g:userChoiceContinuationData.firstArgs = (a:optUserPromtValue_andFirstArg != {}) ?
        \  [a:optUserPromtValue_andFirstArg] + a:contOtherArgs
        \:                                     a:contOtherArgs
  " Note: async - action call stack will resume with selected value at "UserChoiceAction_resume"
  " Show the dialog
  call UserChoiceDialog_show( a:userPromptText, a:optUserPromtValue_andFirstArg, a:choices, windowPos )
endfunc

" The 'choice' objects are expected to have a 'label' key. an underscore (_) at the beginning indicates the the first ■
" char should be used as a shortcut key instead of the index number. 'sections keys create quickmenu sections.
let g:choicesTest1 = [{'label':'choice 1', 'otherData':111}, {'label':'choice 2', 'otherData':222}]
let g:choicesTest2 = [{'label':'_Google', 'url':'http://www.google.de/search?q='}, {'section':'Local search:'}, {'label':'_In Hask dir', 'comm':'Fhask'}]
"                      ( userPromptText,      optUserPromtValue_andFirstArg,            choices,       continuationFn,          contOtherArgs,          [winPos] ... )
" call UserChoiceAction( 'Run query on site', input('Site query: ', HsCursorKeyword()), g:searchSites, function('BrowserQuery'), [{'browser':'default'}] )
nnoremap <leader>tta :call UserChoiceAction( 'Please select one: ', '', g:choicesTest1, function('TestUserChoice1'), [] )<cr>
nnoremap <leader>ttb :call UserChoiceAction( 'Search ..', expand("<cword>"), g:choicesTest2, function('TestUserChoiceSearch'), [v:true] )<cr>
" try: replicateM Response MonadIO

func! TestUserChoice1 ( choosenObj )
  echo 'The payload choosen is: ' . a:choosenObj.otherData
endfunc
" exec "call TestUserChoice1( {'otherData':123} )"
" exec "call TestUserChoice1(" . string( {'otherData':123} ) . ")"

func! TestUserChoiceSearch ( searchTerm, shouldEcho, choosenObjCmd )
  if a:shouldEcho
    echo 'Searching ' . a:choosenObjCmd.label
  endif
  if has_key( a:choosenObjCmd, 'url' )
    exec '!open ' . shellescape( a:choosenObjCmd.url . a:searchTerm )
  elseif has_key( a:choosenObjCmd, 'comm' )
    exec a:choosenObjCmd.comm . ' ' . a:searchTerm
  endif
endfunc

func! UserChoiceAction_resume( selOptionValue )
  call call( g:userChoiceContinuationData.fn,
        \ g:userChoiceContinuationData.firstArgs + [a:selOptionValue] )
endfunc " ▲

func! UserChoiceDialog_show( userPromptText, userPromtValue, choices, windowPos )
  call quickmenu#current(100)
  call quickmenu#reset()

  call quickmenu#header( a:userPromptText )
  if (a:userPromtValue != {})
    call quickmenu#append('# → ' . string(a:userPromtValue), '')
  endif

  for choiceItem in a:choices
    if has_key( choiceItem, 'label' )
      if choiceItem.label[0] != '_'
        call quickmenu#append( choiceItem.label, FormatResumeCall(choiceItem), DefaultHelpText(choiceItem) )
      else
    "                            | Label           | Callback                    | Helptext                          | Trigger key (first char of label!)
        call quickmenu#append( choiceItem.label[1:], FormatResumeCall(choiceItem), DefaultHelpText(choiceItem), '', 0, tolower(choiceItem.label[1]) )
      endif
    elseif has_key( choiceItem, 'section' )
      call quickmenu#append( '# ' . choiceItem.section, '' )
    endif
  endfor

  if a:windowPos == 'showBottom'
    call quickmenu#bottom(100)
  else
    call quickmenu#toggle(100)
  endif
endfunc


" Take the first 'payload' value as quickmenu 'help'-text (shown in the 'bottom' mode)
" Note: this relies on the ordering in of the dictionary -> should instead skip the 'label' key, or use a 'tagged' key ..?
func! DefaultHelpText( choiceItem )
  let vals = values( a:choiceItem )
  if len( vals ) > 1
    return string( vals[1] )
  else
    return '' " no payload -> no help text
  endif
endfunc

" This puts the entire data-object of a menu item into a string-expression that get's executed in case the menu item is
" selected, then passing the selected item obj into the UCA-resume function
func! FormatResumeCall( choiceItemObj )
  return "call UserChoiceAction_resume(" . string(a:choiceItemObj ) . ")"
endfunc
" echo FormatResumeCall( 'something in here')
" exec FormatResumeCall( 'something in here')
" ─^  User Choice Menu and Action                        ▲

