
-- Prelude
foldMap          :: (Foldable t, Monoid m)              => (a -> m) -> t a                   -> m
-- Data.Foldable
foldMap          :: (Foldable t, Monoid m)              => (a -> m) -> t a                   -> m
-- Data.Conduit.List
foldMap          :: (Monad m, Monoid b)                 => (a -> b)                         -> Consumer a m b
-- Data.Traversable
foldMapDefault   :: forall t m a . (Traversable t, Monoid m) => (a -> m) -> t a                   -> m
-- Data.IntMap.Internal
foldMapWithKey   :: Monoid m                            => (Key -> a -> m) -> IntMap a        -> m
-- Data.IntMap.Lazy
foldMapWithKey   :: Monoid m                            => (Key -> a -> m) -> IntMap a        -> m
-- Data.IntMap.Strict
foldMapWithKey   :: Monoid m                            => (Key -> a -> m) -> IntMap a        -> m
-- Data.Map.Internal
foldMapWithKey   :: Monoid m                            => (k -> a -> m) -> Map k a           -> m
-- Data.Map.Lazy
foldMapWithKey   :: Monoid m                            => (k -> a -> m) -> Map k a           -> m
-- Data.Map.Strict
foldMapWithKey   :: Monoid m                            => (k -> a -> m) -> Map k a           -> m
-- Data.Map.Strict.Internal
foldMapWithKey   :: Monoid m                            => (k -> a -> m) -> Map k a           -> m
-- Data.Sequence
foldMapWithIndex :: Monoid m                            => (Int -> a -> m) -> Seq a           -> m
-- Data.Sequence.Internal
foldMapWithIndex :: Monoid m                            => (Int -> a -> m) -> Seq a           -> m
-- Data.Text.Internal.Fusion.CaseMapping
foldMapping      :: forall s . Char -> s                                                        -> Step (CC s) Char
-- Control.Lens.Fold
foldMapBy        :: Foldable t                          => (r -> r -> r) -> r -> (a -> r) -> t a -> r



-- Prelude
traverse  ∷ (Traversable t, Applicative f) ⇒ (a → f b) → t a     → f (t b)
{- base Prelude
Map each element of a structure to an action, evaluate these actions
from left to right, and collect the results. For a version that
ignores the results see traverse_. -}
-- Data.Traversable
traverse  ∷ (Traversable t, Applicative f) ⇒ (a → f b) → t a     → f (t b)
-- Control.Lens.Traversal
traverse  ∷ (Traverse_ t, Applicative f) ⇒ (a → f b) → t a     → f t b
{- lens Control.Lens.Traversal
Map each element of a structure to an action, evaluate these actions
from left to right, and collect the results. For a version that
ignores the results see traverse_. -}
-- Text.Trifecta.Util.Array
traverse  ∷ Applicative f                  ⇒ (a → f b) → Array a → f (Array b)
-- Data.Foldable
traverse_ ∷ (Foldable t, Applicative f)    ⇒ (a → f b) → t a     → f ()



traverse  ∷ (Traversable t, Applicative f) ⇒ (a → f b) → t a     → f (t b)          Prelude

traverse  ∷ (Traversable t, Applicative f) ⇒ (a → f b) → t a     → f (t b)          Data.Traversable

traverse  ∷ (Traverse_ t, Applicative f)   ⇒ (a → f b) → t a     → f t b

traverse  ∷ Applicative f                  ⇒ (a → f b) → Array a → f (Array b)      Data.Foldable

traverse_ ∷ (Foldable t, Applicative f)    ⇒ (a → f b) → t a     → f ()


traverse  ∷ (Traversable t, Applicative f) ⇒ (a → f b) → t a     → f (t b)
  {-lens Control.Lens.Traversal -}
traverse  ∷ (Traversable t, Applicative f) ⇒ (a → f b) → t a     → f (t b)
  {-{{{lens Control.Lens.Traversal
  Map each element of a strucTure to an action, evaluate these actions
  from left to right, and collect the results. For a version that
  ignores the results see traverse_. }}}-}
traverse  ∷ (Traverse_ t, Applicative f) ⇒ (a → f b) → t a     → f t b

traverse  ∷ Applicative f                  ⇒ (a → f b) → Array a → f (Array b)

traverse_ ∷ (Foldable t, Applicative f)    ⇒ (a → f b) → t a     → f ()


let concealID = matchadd("Conceal", "{-", -1, -1, {"conceal": ""})
let concealID = matchadd("Conceal", "-}", -1, -1, {"conceal": ""})
let concealID = matchadd("Conceal", "{{{", -1, -1, {"conceal": ""})
let concealID = matchadd("Conceal", "}}}", -1, -1, {"conceal": ""})

-- echo matchadd('Conceal', '{-', -1, -1, {'conceal': ''})
call matchadd('Conceal', '-\}', -1, -1, {'conceal': ''})
call matchadd('Conceal', '\{\{\{', -1, -1, {'conceal': ''})
call matchadd('Conceal', '\}\}\}', -1, -1, {'conceal': ''})
set conceallevel=2

call matchdelete( concealID )
call clearmatches()

nnoremap <leader>hl :call nvim_buf_add_highlight( bufnr(''), g:nsid_def, 'Folded', line('.')-1, 0, 120)<cr>

set foldtext=foldtext()

setlocal foldtext=HoogleInfoFoldtext()
func! HoogleInfoFoldtext()
  let l:line = split( getline(v:foldstart) )
  return '  ' . l:line[ 1 ]
endfunc

eins

HsPsTypesExplore

Prelude data IO a
module System.IO
System.IO data IO a
module GHC.Conc.IO
module Data.Text.IO
module Data.Text.Internal.IO
module Data.Text.Lazy.IO
Prelude type IOError = IOException
Control.Exception data IOException
Control.Exception.Base data IOException
module Data.IORef
Data.IORef data IORef a
System.IO data IOMode
System.IO.Error type IOError = IOException
System.IO.Error data IOErrorType
GHC.Event type IOCallback = FdKey -> Event -> IO ()
GHC.IO.Device class IODevice a
GHC.IO.Device data IODeviceType
Test.QuickCheck.Property IORose :: (IO (Rose a)) -> Rose a
Data.Vector.Mutable type IOVector = MVector RealWorld

-- Prelude\\\\
data IO a
-- module\\\\
System.IO
-- System.IO\\\\
data IO a
-- module\\\\
GHC.Conc.IO
-- module\\\\
Data.Text.IO
-- module\\\\
Data.Text.Internal.IO
-- module\\\\
Data.Text.Lazy.IO
-- Prelude\\\\
type IOError = IOException
-- Control.Exception\\\\
data IOException
-- Control.Exception.Base\\\\
data IOException
-- module\\\\
Data.IORef
-- Data.IORef\\\\
data IORef a
-- System.IO\\\\
data IOMode
-- System.IO.Error\\\\
type IOError = IOException
-- System.IO.Error\\\\
data IOErrorType
-- GHC.Event\\\\
type IOCallback = FdKey -> Event -> IO ()
-- GHC.IO.Device\\\\
class IODevice a
-- GHC.IO.Device\\\\
data IODeviceType
-- Test.QuickCheck.Property\\\\
IORose :: (IO (Rose a)) -> Rose a
-- Data.Vector.Mutable\\\\
type IOVector = MVector RealWorld





