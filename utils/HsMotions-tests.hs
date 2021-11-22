

ip $ and = in arg jumps
  |              |
let (int2, gen2) = (generate gen1)
re ((int1, int2), gen2)
   A|             |

        |         .  .      |   |    .      |     |   
mymapM_ ∷ (Foldable t, Monad m) ⇒ (a → m b) → t a → m ()
mapM_ f = foldr ((>>) . f) (return ())
          |

        v   |                |          |         .       |
withExceptC ∷ MonadError e m ⇒ (e' → e) → m (Either e' a) → m a
thExceptC f act = do
  eith ← act
case eith of
  "     Left err  → throwError (f err)
  Right val → return val

clude or go into if then else case left right?
                                    |                     .  |               .  |             .  |          .  | .
" call highlightedyank#highlight#add( 'HighlightedyankRegion', getpos(startMark), getpos(endMark), a:motionType, 500)

    |       |      |       v     v                          |
rt3 ∷ ReaderT String (StateT [Int] (ExceptT String Identity)) Int

 type sigs there is level 1 and lower levels that are words or lists
     |       .   v         v           |             |         v  v           .   . .      | .   . .
get :: (HasRep xs, RouteM t, Monad m) => Path xs ps -> HVectElim xs (ActionCtxT ctx m ()) -> t ctx m ()


                    |            |                 v                            v    |             |
errorHandler status = spockAsApp $ W.buildMiddleware W.defaultSpockConfigInternal id $ baseAppHook $ errorApp status
rorHandler status = spockAsApp  (W.buildMiddleware W.defaultSpockConfigInternal id  (baseAppHook  (errorApp status)))

r hs function arg steps we need to skip what's inside a paran
                |     |           v       v        v     .            .       |
errorApp status = mapM_ (\method -> hookAny method $ \_ -> errorAction' status) [minBound .. maxBound]

u want to think of the argument position. aaa should take you to the third arg

|               |      |              |     v            .    v  v                |
{ runActionCtxT ∷ ErrorT ActionInterupt (RWST (RequestInfo ctx) () ResponseState m) a }


          -- |         v         |            v
emailFormat ∷ ∀ form m. Monad m ⇒ F.Validation form m FormError String Email
emailFormat = F.hoistFnE_ $ map Email <<< cond (String.contains (String.Pattern "@")) InvalidEmail
"               |             |                  |^               ^                     |

         -- |                      |     |          |                          |
decode ∷ ∀ m a. LogMessages m ⇒ Now m [Aa, Bb] ⇒ (Json → Either String a) → Maybe sson a
decode _ Nothing = logError "Response mal <*> formed" <*> pure Nothing
"                    |        ^                 ^           |
  ab (ab) abc (["abc"]) {dcfd} abb 
aa "abc" ghi (["abc, ddba"]) jkl

" type delims and operators will rarely mix - only in type level programming
" but there may sometimes/rarely be
"    |         v       |  .      v       |
  "   [Ab 'a' <> Ab 'c', Ab 'x' <> Ab 'd', Ab 'y']

BracketStartForw

  ( eins, zwei, drei, (drei, halb), more, ( Just 22, Nothing, [ Ab 22, Bc 33, Cd 33], Just 11), vier,
  fuenf, sechs ( sieben, acht, (neun, zehn)), elf

  ( aa, bb, cc, dd)

   more , stuff

partition p xs == (filter p xs, filter (not . p) xs)
" Delimiter: if a ({[ is found before →, then go the closing )]} and search next
"         |                s    |               |
(<*>) ∷ ReaderT r m (a → b) → ReaderT r m a → ReaderT r m b
ReaderT rmab <*> ReaderT "eins" rma = ReaderT $ \r → rmab r <*> rma ar
"                  |             |         |    |          |

ze0 = object [ "numbers" .= toJSONList [1,2,3 ∷ Int]
  , "names"   .= toJSONList [ "Jane", "Artyom" ∷ String, Ab () ]
  , "names"   .= toJSONList [ "Jane", "Artyom" ∷ String ]
             ]

ze0 = object [ "numbers" .= toList [ 31, 42, 43 ], "names"   .= toList [ "Jane", "Artyom" ∷ String ], (), "names"   .= toList [ "Jane", "Artyom" ∷ String ] ]
ze0 = object [ "numbers" .= toJSONList [1,2,3 ∷ Int], "names"   .= toJSONList [ "Jane", "Artyom" ∷ String ], "names"   .= toJSONList [ "Jane", "Artyom" ∷ String ]
             ]

CommaStartBackw
zweimal zurueck
zweiter case [ oder ,

CommaStartForw
 - same level:
* if find ',' on the same () level within + 5 lines
     → move to word after comma
* else find '' (on same () level? within + 5 lines)
  → move to word after bracket

gq0 ∷ Value
gq0 = Array $ fromList [ object [ "a" <*> ( "eins"∷String), "b" .= True ]
  , object [ "a" .= ("zwei"∷String), "b" .= False ]
  , object [ "a" .= ("zwei"∷String), "b" .= False ]
                       ]

pl0 = encode ([1,2,3] ∷ [Integer])

uk1 = eitherDecode "[1,2,[3,true]]" ∷ Either String (Int, Int, (Int, Bool))


val0 ∷ Value
val0 = Object ((fromList [ -- convert a list of (Text, Value) items to a HashMap Text Value, (= "Object" type)
  ("mynumbers", Array ((fromList [Number 1, Number 3, Number 3]) ∷ Vector Value)), -- convert a list of values to a Vector of values (= "Array" type)
  ("myboolean", Bool True) ])                                    ∷ H.HashMap Text Value)
-- Object (fromList [("mynumbers",Array [Number 1.0,Number 2.0,Number 3.0]),("myboolean",Bool True)])

-- this intermediate Haskell type can be written (encoded) to JSON easily
dw = encode $ val0
-- "{\"mynumbers\":[1,2,3],\"myboolean\":true}"
-- {"mynumbers":[1,2,3],"myboolean":true}

la0 ∷ H.HashMap Text Value 
la0 = fromList [ -- convert a list of (Text, Value) items to a HashMap Text Value, (= "Object" type)
  ("mynumbers", Array ((fromList [Number 1, Number 2, Number 3]) ∷ Vector Value)), -- convert a list of values to a Vector of values (= "Array" type)
  ("myboolean", Bool True) ]                                    

dw0 = encode la0
-- "{\"mynumbers\":[1,2,3],\"myboolean\":true}"

la1 ∷ H.HashMap Text Bool 
la1 = fromList [ -- convert a list of (Text, Value) items to a HashMap Text Value, (= "Object" type)
  ("mynumbers", False), -- convert a list of values to a Vector of values (= "Array" type)
  ("myboolean", True) ]                                    

-- as the native haskell value already have a toJSON instance they can also be encoded just by using
-- 'encode'!
dw1 = encode la1
-- "{\"mynumbers\":false,\"myboolean\":true}"

-- for custom data type you would have to write a 'toJSON' instance

-- so writing to JSON is as easy as:
el0 = encode ( [ "a" =: 11
  , "b" =: 22 ] ∷ H.HashMap Text Int )

-- this just allows a proper text print - not quoting the '"'
dw2 = T.putStrLn . T.decodeUtf8 . encode $ val0
-- {"mynumbers":[1,2,3],"myboolean":true}

a =: b = (a, b)

-- you can almost literally construct a keyed collection
lk0 ∷ H.HashMap Text [Int]
lk0 = [ "mynu" =: [1,2,3]
  , "myb0" =: []
      ]
-- lk0 = [ ("mynu", [1,2,3])
--       , ("myb0", [])
--       ]

-- but you can't do this with product types with fields of different types,
-- you need to represent those as s specific data type:
data NB = NB { mynums ∷ [Int]
  , mybool ∷ Bool
             }

-- val1 ∷ Value
val1 = NB { mynums = [1,2,3]
  , mybool = True
          }


ex1Players ∷ Players1
ex1Players = M.fromList
                  [ (1, Player {pid = 1, name = "AA", playerType = Human})
                  , (2, Player {pid = 2, name = "BB", playerType = Human})
                  , (3, Player {pid = 3, name = "Computer 1", playerType = AI})
                  , (4, Player {pid = 4, name = "Computer 2", playerType = AI})
                  ]

-- test lists an skip comma in comments
data Package = Package
  {packageTags :: [(T.Text, T.Text)] -- ^ The Tag information, e.g. (category,Development) (author,Neil Mitchell).
    ,packageLibrary :: Bool -- ^ True if the package provides a library (False if it is only an executable with no API)
      ,packageSynopsis :: T.Text -- ^ The synposis, grabbed from the top section.
      ,packageVersion :: T.Text -- ^ The version, grabbed from the top section.
      ,packageDepends :: [T.Text] -- ^ The list of packages that this package directly depends on.
      ,packageDocs :: Maybe FilePath -- ^ Directory where the documentation is located
  } deriving Show



-- val2 = { "mynums" = [1,2,3]
--           , "mybool" = True

-- toJSON can turn simple haskell types into Values
nm0 ∷ [Abc]
nm0 = toJSON ([2,3,4] ∷ [Int])
-- Array [Number 2.0,Number 3.0,Number 4.0]

ke0 ∷ [Value]
ke0 = toJSON <$> [True, False]

ke1 ∷ Vector Value
ke1 = fromList $ toJSON <$> [True, False]



" Delimiter: when on ([{ search next after closing )]}
" [(1, 2), (8, 11, 5), (4, 5)]

" i'm ok with not skipping literal string content
" "   |          |               |
  hello ++ Just "ab + cd" ++ "world"
   hello + Just "ab cd"  + "world"
   hello >>= Just 123  >> Just 43 <*> map eins
   hello <*> Just "ab, cd" <*> "world"
   hello `so` Just "ab, cd" `cd` "world"
"
   44 `add` Just 44 `sub` 44 44 `kk` "as"

eins

   Just 2 >>= Some 4 [3, 4] <$> More "a"
   Just 2 >>= Some 4 [3, 4]  *> More "a" >> Some b < A b
   Just 2 <*> Some 4 (3, 4) <$> More "a"
   Just 2 <>  Some 4 (3, 4 <*> 4) <$> More "a"
"   " |          |          ^     ^      |
  44 `add` Just 44 `sub` 44 44 `kk` aa "as"
" " This works!
  "
"   " |          |                              |
  hello" ++ Just "ab cd" ("a" <> "b b") <> Some 4
"
" "   |                        |                 |
  Just ['w' ++ 'b', 'o'] ++ Just ['o','t'] ++ Just ['b', 'c']


  Just ['w' ++ 'b', 'o'],   Just ['o','t'],   Just ['b', 'c']


inRange ∷ Int → (Int, Int) → Bool
inRange val (start, end) = val >= start && val <= end
"                            |      |        |      |

countElem ∷ Eq a ⇒ [a] → a → Int
countElem l e = length $ filter (== e) l

  <*> (hm .: "c")
  <*> (hm .: "d")


" from the term function start you have these options:


" ExprInner  q         t
" ExprOuter  Q         T
" Wire       ,q        ,t
" Comma      \q        \t


" Expression/ Function start: after = X
"                mostly pt_delim = '\(=\|<\?.\?>\|\$\|→\|++\?\|>\?>.\?\)\s\zs.'
    "            new line
" Type args: coud switch to this logic when there's ∷ in the line?
  "   - if theres no ∷ in the current line, search back to previous (also inner) ∷ X ..

" Function application/expression Next - Back:
" basically WORD and B motion but
"   - not search inside ([{ when cursor is at it
"   - not jump to $ - but go to inner last arg?
  "   - not jump to opers <> + ++ == - but jump to next expression
"  Main/where fn args - var/binds: skipping brackets (destructuring)
"   - new lines

" Wireframe: inner/where fns X = ..
  "            case, if
                        "            Col 0 line, for funtion cases/patterns
" 
" Comma/ lists:
"   - find the beginning of the first elem by searching back to ([{ from the first comma found, but not further then ','


" how to navigate inside a:
"   - do
  "   - if
           "   - case
"   - let

call matchadd( 'MatchParen', '\(\s\)\@<=\S\%'.line('.').'l\%>'.(col('.')).'c' )
call matchadd( 'MatchParen', '\(\s\)\@<=\S' )
call matchadd( 'MatchParen', '\(\<\k\|\>\S\|\s\zs\S\)\%'.line('.').'l\%>'.(col('.')).'c' )
call matchadd( 'MatchParen', '\(\s\)\@<=\S\%'.line('.').'l\%<'.(col('.')+2).'c' )
call matchadd( 'MatchParen', '\(\S\ze\s\)\%'.line('.').'l\%>'.(col('.')).'c' )
call clearmatches()

myfoldr f b l = step l b
myfoldr f b l = step l b
  where
    step ∷ [a] → b
    step aks ac     = ac
    step (x:xs) ac = f x $ step xs ac


-- note that fnWire skips '= do' here
postFollowR :: Ab c -> [Char] → Handler Value
postFollowR (Ab x) username = do
  (Entity userId _) <- runDB $ getBy404 $ UniqueUserUsername username
  mCurrentUserId <- maybeAuthId
  case mCurrentUserId of
    Nothing -> notFound
    Just currentUserId -> do
      let follower = UserFollower userId currentUserId
      void $ runDB $   insertUnique follower
      getProfilesR username


-- | Request an Int within a range, reject non-complient and
-- | and confirm success.
intRangeDialog ∷ (Int, Int) → String → String → String → IO Int
intRangeDialog (rStart, rEnd[])   prompt alert confirm = go 2
intRangeDialog (rStart, rEnd[]) prompt alert confirm = go 2
intRangeDialog "rStart, rEnd[]" prompt alert confirm = go 2
intRangeDialog A.[3]replay34 prompt alert confirm = go 2
intRangeDialog [Areplay34] prompt alert confirm = go 2
intRangeDialog "rStart, rEnd" prompt alert confirm = go 2
  where
    go a = do
      print prompt
      inSt ← getLine
      case readMaybe inSt ∷ Maybe Int of
        Just x | inRange x (rStart, rEnd)
          → print (confirm <> show x) >> return x
        _ → print alert               >> go
" -- intRangeDialog (1,3) "From 1 to 3" "Arg!" "I got: "
"
cbkd0 = Just 4 <|> Just 2
cbkd0 = Just 4 >>= Just 2
cbkd0 = Just 4 <*> Just 2


" -- | Request a non-blank string, reject non-complient and
" -- | and confirm success.


nonBlankStringDialog ∷ String
                     → String
                     → String
                     → IO String
nonBlankStringDialog prompt alert confirm = go
  where
    go = do
      print ← prompt aa
      inSt ← getLine bb
      do
        ab ← bc
        if notBlank inSt
           then print confirm >> return inSt
           else print alert   >> go
" -- nonBlankStringDialog "Please enter:" "Arg!" "Thanks!"

doRounds2 ∷ AppIO GameReport
doRounds2 = nextRound 1 []
  where
    nextRound ∷ Int → [RoundResult] → AppIO GameReport
    nextRound idx rResults = do
      result ← roundScheduler idx
      players ← lift ask
      -- flag fuer exit-game mit gameReport

      case gameReport players (result:rResults) of
        GameReport {winner=Nothing} → nextRound (idx +1) (result:rResults)
        completeReport              → return completeReport


data ProgrammingLanguage =
        Haskell
      | Agda
      | Idris
      | PureScript
      deriving (Eq, Show)

data Programmer = Programmer { os ∷ OperatingSystem
                             , lang ∷ ProgrammingLanguage }
                             deriving (Eq, Show)

allOperatingSystems ∷ [OperatingSystem]
allOperatingSystems = [ GnuPlusLinux
                      , OpenBSDPlusNevermindJustBSDStill
                      , Mac
                      , Windows
                      ]

allLanguages ∷ [ProgrammingLanguage]
allLanguages = [Haskell, Agda abc,  Idris, PureScript]

allProgrammers ∷ [Programmer]
allProgrammers = do
  oss ← allOperatingSystems
  lng ← allLanguages
  return (Programmer oss lng)
-- length allProgrammers

allProgrammers1 ∷ [Programmer]
allProgrammers1 = concatMap (\oss → map (\lng → Programmer oss lng)
                                        allLanguages)
                            allOperatingSystems
-- concatMap just maps a unaryFn over a collection.


-- | Collect roundInput from players and log it to AppState,
-- print out and return the RoundResult
roundScheduler :: Int → AppIO RoundResult
roundScheduler roundIdx = do
  liftIO $ print $ "Round " <> show roundIdx <> " is about to start!"

  -- Players will be propted in reverse order based on a random switch
  players ← lift ask
  playersRRev ← condAp reverse players <$> withStdGen random
  let maxTotal = length players * 5

  humanPlayersInput ∷ [PlayerRoundInput]
      ← liftIO    $ traverse (playerRoundInputWizzard roundIdx maxTotal
                              ∷ Player   → IO             PlayerRoundInput)
                              $         filter ((== Human) . playerType) playersRRev

  aiPlayersInput    ∷ [PlayerRoundInput]
      ← hoist (hoist generalize)
                  $ traverse (aiRoundInput            roundIdx
                              ∷ PlayerId → StateT AppState (Reader Players) PlayerRoundInput)
                              $ pid <$> filter ((== AI)    . playerType) players

  let roundInput ∷ [PlayerRoundInput]
                 = humanPlayersInput <> aiPlayersInput

  -- | Append [PlayerRoundInput] to roundInputLog in AppState (sorted by rounds!)
  modify $ \appSt → appSt { roundInputLog = roundInputLog appSt <> S.fromList roundInput }

  let roundRes ∷ RoundResult
      roundRes = roundResult roundInput

  -- Show a report about the round to the user
  lift $ printRoundReport roundInput roundRes

  return roundRes




"
--------------------------------------------------------------------------------

-- | Repeatedly accum 'action' result (a) into a list,
-- apply the list to 'eval' after each turn and stop/return 'm b' if 'p' holds.
actionIdxLogEvalUntil ∷ ∀ a b m. Monad m
                      ⇒ (Int → m a) -- action (receiving index) Abd
                      ⇒ (Int → m a) -- action (receiving index)
                      → ([a] → b)   -- eval
                      → (b → Bool)  -- p
                      → m abc
                      → m b
actionIdxLogEvalUntil action eval p = go []
  where
    go ∷ Int → [a] → [] m b
    go idx xs = action idx >>= evalTestReturnOrRecurse . (: xs)
      where
        evalTestReturnOrRecurse ∷ [a] → m b
        evalTestReturnOrRecurse = fResElse eval p $ go (idx+1)
"
"

evalTestReturnOrRecurse = ifResElse eval p <*> go (idx+1)

-- | Repeatedly accum 'action' result 'a' into a list,
-- 'eval' the list after each turn and stop/return 'm b' if 'p' holds.
actionLogEvalUntil ∷ ∀ a b m. Monad m
                   ⇒ m a         -- action
                   → ([a] → b) -- eval
                   → (b → Bool)  -- p
                   → m b         -- return 'b' only if p holds, else cont. action
actionLogEvalUntil action eval p = go []
  where
    go ∷ [a] → m b
    go xs = action >>= evalTestReturnOrRecurse . (: xs)
    -- accum action (in (monad-trans) 'm') val to the log (xs) and

    evalTestReturnOrRecurse ∷ [a] → m b
    evalTestReturnOrRecurse = ifResElse eval p go
    -- eval the log, return the result of the evaluation or recurse to go action
-- it ∷ IO String
--    → ([String] → Int)
--    → (Int → Bool)
--    → IO Int
  -- ∷ Monad m
  -- ⇒ m a
  -- → ([a] → b)
  -- → (b → Bool)
  -- → m b
t_actionLogEvalUntil = actionLogEvalUntil (getLine ∷ IO String) -- produce strings('a')
                                          (length . fold) -- accum and count('m b') / derive
                                          (>10) -- pred


actionLogEvalUntil1 ∷ ∀ a b m. Monad m
                    ⇒ m a         -- action
                    → ([a] → b) -- eval
                    → (b → Bool)  -- p
                    → m b         -- return 'b' only if p holds, else cont. action
actionLogEvalUntil1 action eval p = go []
  where
    go ∷ [a] → m b
    go xs = action >>= evalTestReturnOrRecurse . (: xs)
    -- accum action (in (monad-trans) 'm') val to the log (xs) and

    evalTestReturnOrRecurse ∷ [a] → m b
    evalTestReturnOrRecurse = ifResElse eval p go
    -- eval the log, return the result of the evaluation or recurse to go action


-- Return 'action a' if 'p' holds on the result, else run 'alt a'
ifResElseM ∷ Monad m ⇒ (a → m b) → (b → Bool) → (a → m b) → (a → m b)
ifResElseM action p alt a = do b ← action a
                               if p b
                                  then return b
                                  else alt a

-- ifResElseM (Just . length) (>4) (Just . (const 0)) "eins-zwei"
t_ifResElseM1 ∷ String → IO Int
t_ifResElseM1 inStr = ifResElseM
                         (\accSt → length . (accSt++) <$> getLine)
                         (>10) -- pred tests the result of eval
                         t_ifResElseM1
                         inStr

instance Monoid Package where
  mempty = Package [] True T.empty T.empty [] Nothing
    mappend (Package x1 x2 x3 x4 x5 x6) (Package y1 y2 y3 y4 y5 y6) =
      Package (x1++y1) (x2||y2) (one x3 y3) (one x4 y4) (nubOrd $ x5 ++ y5) (x6 `mplus` y6)
        where one a b = if T.null a then b else a


data Dog =
  Dog { dogsName    ∷ DogName
      , dogsAddress ∷ Address
      } deriving (Eq, Show)


lili1 = Person { humanName = (HumanName "Lili")
               , dogName   = (DogName "Suslik")
               , address   = (Address "Berlin")
               }


-- | Return 'eval a' if 'p' holds on the result, else run 'alt a'
ifResElse ∷ Monad m
          ⇒ (a → b)
          → (b → Bool) → [Ab a] → String
          → (a → b) → Ma a
          <*> [Maybe Int] → Maybe String
          → String as
ifResElse eval p alt a = let res = eval a
                             res2 =     test 2 3
                          in if p res
                                then return res
                                else alt a

-- ifResElse length (>4) (Just . (const 0)) "eins-zwei"
t_ifResElse1 ∷ IO Int
t_ifResElse1 = go ""
  where
    go accSt = do
      someEff 23
      st ← (accSt++) <$> getLine
      ifResElse length (>10) -- pred tests the result of eval
            go -- aternative action / recurse to base action
            st

      something
         <*> Just more
         <*> Just even
         >>= test

      Test [ 11
        , Just 2
        , 22
           ] deriving Show


putLns ∷ Show a ⇒ [a] → IO ()
putLns = traverse_ $ putStrLn . show

putLns ∷ Show a ⇒ [a] → IO ()
putLns = traverse_ $ putStrLn . show



-- Test: Ballpark - Wire/ Tab/Q motion
main :: IO ()
main = do
  args <- Environment.getArgs
    (flags, inputs) <- case GetOpt.getOpt GetOpt.Permute options args of
                         (flags, inputs, []) -> return (flags, inputs)
        (_, _, errs) -> usage $ "flag errors:\n" ++ List.intercalate ", " errs

    when (Help `elem` flags) $ usage ""
    when (Version `elem` flags) $ do
      putStrLn $ "fast-tags, version "
            ++ Version.showVersion Paths_fast_tags.version
        Exit.exitSuccess

    let verbose       = Verbose `elem` flags
        emacs         = ETags `elem` flags
        vim           = not emacs
        trackPrefixes = emacs
        output        = last $ defaultOutput : [fn | Output fn <- flags]
        srcPrefix     = Text.pack $ FilePath.normalise $
          last $ "" : [fn | SrcPrefix fn <- flags]
        defaultOutput = if vim then "tags" else "TAGS"

    oldTags <- if vim && NoMerge `notElem` flags
                  then do
                    exists <- Directory.doesFileExist output
            if exists
               then Text.lines <$> Util.readFileLenient output
                else return []
        else return [] -- we do not support tags merging for emacs for now

    inputs <- if Cabal `elem` flags
                 then getCabalInputs inputs
        else map ((srcPrefix,) . FilePath.normalise) . Util.unique <$>
          getInputs flags inputs
    when (null inputs) $
      Exit.exitSuccess

    -- Hack: cabal just lists the module name, which I turn into a filename, so
    -- I don't know if it actually is .hsc.  Or .lhs, but I can't parse those
    -- anyway.
    let tryHsc = Cabal `elem` flags
    stderr <- MVar.newMVar IO.stderr
    newTags <- flip Async.mapConcurrently (zip [0 :: Int ..] inputs) $
      \(i, (srcPrefix, fn)) -> Exception.handle (catchError stderr fn) $ do
        useHsc <- if tryHsc then Directory.doesFileExist (fn ++ "c")
                            else return False
            fn <- return $ if useHsc then fn ++ "c" else fn
            (newTags, warnings) <- Tag.processFile fn trackPrefixes
            newTags <- return $ if NoModuleTags `elem` flags
                                   then filter ((/=Tag.Module) . typeOf) newTags else newTags
            newTags <- return $ (newTags ++) $ if
                                                  | FullyQualified `elem` flags ->
                                                    map (Tag.qualify True srcPrefix) newTags
                                                  | Qualified `elem` flags ->
                                                    map (Tag.qualify False srcPrefix) newTags
                                                  | otherwise -> []
                                                -- Try to do work before taking the lock.
            Exception.evaluate $ DeepSeq.rnf warnings
            MVar.withMVar stderr $ \hdl ->
              mapM_ (IO.hPutStrLn hdl) warnings
            when verbose $ do
              let line = take 78 $ show i ++ ": " ++ fn
                putStr $ '\r' : line ++ replicate (78 - length line) ' '
                IO.hFlush IO.stdout
            return newTags

    when verbose $ putChar '\n'

    let allTags = if vim
                     then Vim.merge maxSeparation (map snd inputs) newTags oldTags
            else Emacs.format maxSeparation (concat newTags)
    let write = if vim then Text.IO.hPutStrLn else Text.IO.hPutStr
    let withOutput action = if output == "-"
                               then action IO.stdout
            else IO.withFile output IO.WriteMode action
    withOutput $ \hdl -> do
      IO.hSetEncoding hdl IO.utf8
      mapM_ (write hdl) allTags

  where
    usage msg = do
      putStr $ GetOpt.usageInfo (msg ++ "\n" ++ help) options
        Exit.exitFailure

