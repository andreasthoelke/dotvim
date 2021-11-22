call append( 15, split( system( 'ls -a' ), '\n' ) )
exec "10,$normal! d8f/"
put =&runtimepath

exec '.!hoogle replicateM'
filter
!echo 'hi there'
12!echo 'hi there'
.+3!echo 'hi there'

let g:cmd1 = 'find $VIMRUNTIME -type f -name \*.vim'
let g:cmd1 = 'hoogle replicateM'
let g:cmd1 = 'hoogle replicateM -n=3'
let g:cmd1 = 'hoogle "(a -> b) -> f a -> f b" -n=50'
let g:cmd1 = 'hoogle "(a -> b) -> f a -> f b" -n=50'
let g:cmd1 = 'hoogle "Monad m => Int -> m a -> Producer m a" -n=50'
let g:cmd1 = 'hoogle "Monad m => Int -> m a -> Producer m a" -n=50'
call append( 30, split( system( g:cmd1 ), '\n' ) )


Control.Monad replicateM :: (Applicative m) => Int -> m a -> m [a]
Data.Sequence replicateM :: Monad m => Int -> m a -> m (Seq a)
Data.Sequence.Internal replicateM :: Monad m => Int -> m a -> m (Seq a)
Data.Conduit.List replicateM :: Monad m => Int -> m a -> Producer m a
Control.Monad replicateM_ :: (Applicative m) => Int -> m a -> m ()
Data.Conduit.Internal.List.Stream replicateMS :: Monad m => Int -> m a -> StreamProducer m a





Data.Conduit.List replicateM ∷ Monad m ⇒ Int → m a → Producer m a
Data.Conduit.List iterate ∷ Monad m ⇒ (a → a) → a → Producer m a
Data.Conduit.List unfold ∷ Monad m ⇒ (b → Maybe (a, b)) → b → Producer m a
Data.Conduit.List unfoldM ∷ Monad m ⇒ (b → m (Maybe (a, b))) → b → Producer m a
Data.Sequence replicateM ∷ Monad m ⇒ Int → m a → m (Seq a)
Data.Sequence.Internal replicateM ∷ Monad m ⇒ Int → m a → m (Seq a)
Data.Conduit.Internal.List.Stream replicateMS ∷ Monad m ⇒ Int → m a → StreamProducer m a
Control.Error.Safe tryAt ∷ (Monad m) ⇒ e → [a] → Int → ExceptT e m a
Control.Monad.Loops concatM ∷ Monad m ⇒ [a → m a] → (a → m a)
Control.Monad.Extra concatMapM ∷ Monad m ⇒ (a → m [b]) → [a] → m [b]
Extra concatMapM ∷ Monad m ⇒ (a → m [b]) → [a] → m [b]
Control.Monad.Extra concatForM ∷ Monad m ⇒ [a] → (a → m [b]) → m [b]
Extra concatForM ∷ Monad m ⇒ [a] → (a → m [b]) → m [b]
Data.Sequence mapWithIndex ∷ (Int → a → b) → Seq a → Seq b
Data.Sequence.Internal mapWithIndex ∷ (Int → a → b) → Seq a → Seq b
Prelude splitAt ∷ Int → [a] → ([a], [a])
Data.List splitAt ∷ Int → [a] → ([a], [a])
GHC.OldList splitAt ∷ Int → [a] → ([a], [a])
Data.List.Extra splitAtEnd ∷ Int → [a] → ([a], [a])
Extra splitAtEnd ∷ Int → [a] → ([a], [a])
Control.Monad.Loops iterateWhile ∷ Monad m ⇒ (a → Bool) → m a → m a
Control.Monad.Loops iterateUntil ∷ Monad m ⇒ (a → Bool) → m a → m a
Data.Conduit.Internal.List.Stream iterateS ∷ Monad m ⇒ (a → a) → a → StreamProducer m a
Control.Monad liftM :: (Monad m) => (a1 -> r) -> m a1 -> m r
Control.Monad (<$!>) :: Monad m => (a -> b) -> m a -> m b
Control.Monad.Loops iterateM_ :: Monad m => (a -> m a) -> a -> m b
Control.Monad.Extra loopM :: Monad m => (a -> m (Either a b)) -> a -> m b
Extra loopM :: Monad m => (a -> m (Either a b)) -> a -> m b
Control.Lens.Plated transformM :: (Monad m, Plated a) => (a -> m a) -> a -> m a
Data.Conduit.List fold :: Monad m => (b -> a -> b) -> b -> Consumer a m b
Data.Conduit.Internal.List.Stream foldS :: Monad m => (b -> a -> b) -> b -> StreamConsumer a m b
Prelude (>>=) :: forall a b . Monad m => m a -> (a -> m b) -> m b
Control.Monad (>>=) :: forall a b . Monad m => m a -> (a -> m b) -> m b
Control.Monad.Instances (>>=) :: forall a b . Monad m => m a -> (a -> m b) -> m b
Prelude (=<<) :: Monad m => (a -> m b) -> m a -> m b
Control.Monad (=<<) :: Monad m => (a -> m b) -> m a -> m b
Control.Monad ap :: (Monad m) => m (a -> b) -> m a -> m b
Data.Conduit.List scan :: Monad m => (a -> b -> b) -> b -> ConduitM a b m b
Test.QuickCheck.Monadic wp :: Monad m => m a -> (a -> PropertyM m b) -> PropertyM m b
Data.Conduit.List foldM :: Monad m => (b -> a -> m b) -> b -> Consumer a m b
Data.Conduit.Internal.List.Stream foldMS :: Monad m => (b -> a -> m b) -> b -> StreamConsumer a m b
Prelude mapM :: (Traversable t, Monad m) => (a -> m b) -> t a -> m (t b)
Control.Monad mapM :: (Traversable t, Monad m) => (a -> m b) -> t a -> m (t b)
Data.Traversable mapM :: (Traversable t, Monad m) => (a -> m b) -> t a -> m (t b)
Control.Monad forM :: (Traversable t, Monad m) => t a -> (a -> m b) -> m (t b)
Data.Traversable forM :: (Traversable t, Monad m) => t a -> (a -> m b) -> m (t b)
Data.Conduit.List scanM :: Monad m => (a -> b -> m b) -> b -> ConduitM a b m b
Control.Error.Util fmapRT :: (Monad m) => (a -> b) -> ExceptT l m a -> ExceptT l m b
Control.Monad.Trans.Writer.Lazy censor :: (Monad m) => (w -> w) -> WriterT w m a -> WriterT w m a
Control.Monad.Trans.Writer.Strict censor :: (Monad m) => (w -> w) -> WriterT w m a -> WriterT w m a
-- plus more results not shown, pass --count=60 to see more

Prelude flip :: (a -> b -> c) -> b -> a -> c
Data.Function flip :: (a -> b -> c) -> b -> a -> c
Prelude (.) :: (b -> c) -> (a -> b) -> a -> c
Data.Function (.) :: (b -> c) -> (a -> b) -> a -> c
Control.Lens.Indexed (.>) :: (st -> r) -> (kab -> st) -> kab -> r
Control.Lens.Operators (.>) :: (st -> r) -> (kab -> st) -> kab -> r
Data.Function.Wrap wrap1 :: (r -> s) -> (a1 -> r) -> (a1 -> s)
Prelude map :: (a -> b) -> [a] -> [b]
Data.List map :: (a -> b) -> [a] -> [b]
GHC.OldList map :: (a -> b) -> [a] -> [b]
Data.List foldl1' :: (a -> a -> a) -> [a] -> a
GHC.OldList foldl1 :: (a -> a -> a) -> [a] -> a
GHC.OldList foldl1' :: (a -> a -> a) -> [a] -> a
GHC.OldList foldr1 :: (a -> a -> a) -> [a] -> a
Data.List.Extra for :: [a] -> (a -> b) -> [b]
Extra for :: [a] -> (a -> b) -> [b]
Prelude scanl1 :: (a -> a -> a) -> [a] -> [a]
Prelude scanr1 :: (a -> a -> a) -> [a] -> [a]
Data.List scanl1 :: (a -> a -> a) -> [a] -> [a]
Data.List scanr1 :: (a -> a -> a) -> [a] -> [a]
GHC.OldList scanl1 :: (a -> a -> a) -> [a] -> [a]
GHC.OldList scanr1 :: (a -> a -> a) -> [a] -> [a]
GHC.OldList concatMap :: (a -> [b]) -> [a] -> [b]
Test.QuickCheck shrinkList :: (a -> [a]) -> [a] -> [[a]]
Test.QuickCheck.Arbitrary shrinkList :: (a -> [a]) -> [a] -> [[a]]
GHC.OldList foldl :: forall a b . (b -> a -> b) -> b -> [a] -> b
GHC.OldList foldl' :: forall a b . (b -> a -> b) -> b -> [a] -> b
GHC.OldList foldr :: (a -> b -> b) -> b -> [a] -> b
Prelude scanl :: (b -> a -> b) -> b -> [a] -> [b]
Data.List scanl :: (b -> a -> b) -> b -> [a] -> [b]
Data.List scanl' :: (b -> a -> b) -> b -> [a] -> [b]
GHC.OldList scanl :: (b -> a -> b) -> b -> [a] -> [b]
GHC.OldList scanl' :: (b -> a -> b) -> b -> [a] -> [b]
Prelude scanr :: (a -> b -> b) -> b -> [a] -> [b]
Data.List scanr :: (a -> b -> b) -> b -> [a] -> [b]
GHC.OldList scanr :: (a -> b -> b) -> b -> [a] -> [b]
Data.List.Extra list :: b -> (a -> [a] -> b) -> [a] -> b
Extra list :: b -> (a -> [a] -> b) -> [a] -> b
Prelude zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
Data.List zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
GHC.OldList zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
Foreign.Marshal.Utils withMany :: (a -> (b -> res) -> res) -> [a] -> ([b] -> res) -> res
Data.List intercalate :: [a] -> [[a]] -> [a]
GHC.OldList intercalate :: [a] -> [[a]] -> [a]
Prelude uncurry :: (a -> b -> c) -> ((a, b) -> c)
Data.Tuple uncurry :: (a -> b -> c) -> ((a, b) -> c)
Data.Tuple.Extra first :: (a -> a') -> (a, b) -> (a', b)
Extra first :: (a -> a') -> (a, b) -> (a', b)
Data.Tuple.Extra second :: (b -> b') -> (a, b) -> (a, b')
Extra second :: (b -> b') -> (a, b) -> (a, b')
-- plus more results not shown, pass --count=60 to see more

Prelude flip :: (a -> b -> c) -> b -> a -> c
Data.Function flip :: (a -> b -> c) -> b -> a -> c
Prelude (.) :: (b -> c) -> (a -> b) -> a -> c
Data.Function (.) :: (b -> c) -> (a -> b) -> a -> c
Control.Lens.Indexed (.>) :: (st -> r) -> (kab -> st) -> kab -> r
Control.Lens.Operators (.>) :: (st -> r) -> (kab -> st) -> kab -> r
Data.Function.Wrap wrap1 :: (r -> s) -> (a1 -> r) -> (a1 -> s)
Prelude map :: (a -> b) -> [a] -> [b]
Data.List map :: (a -> b) -> [a] -> [b]
GHC.OldList map :: (a -> b) -> [a] -> [b]
Data.List foldl1' :: (a -> a -> a) -> [a] -> a
GHC.OldList foldl1 :: (a -> a -> a) -> [a] -> a
GHC.OldList foldl1' :: (a -> a -> a) -> [a] -> a
GHC.OldList foldr1 :: (a -> a -> a) -> [a] -> a
Data.List.Extra for :: [a] -> (a -> b) -> [b]
Extra for :: [a] -> (a -> b) -> [b]
Prelude scanl1 :: (a -> a -> a) -> [a] -> [a]
Prelude scanr1 :: (a -> a -> a) -> [a] -> [a]
Data.List scanl1 :: (a -> a -> a) -> [a] -> [a]
Data.List scanr1 :: (a -> a -> a) -> [a] -> [a]
GHC.OldList scanl1 :: (a -> a -> a) -> [a] -> [a]
GHC.OldList scanr1 :: (a -> a -> a) -> [a] -> [a]
GHC.OldList concatMap :: (a -> [b]) -> [a] -> [b]
Test.QuickCheck shrinkList :: (a -> [a]) -> [a] -> [[a]]
Test.QuickCheck.Arbitrary shrinkList :: (a -> [a]) -> [a] -> [[a]]
GHC.OldList foldl :: forall a b . (b -> a -> b) -> b -> [a] -> b
GHC.OldList foldl' :: forall a b . (b -> a -> b) -> b -> [a] -> b
GHC.OldList foldr :: (a -> b -> b) -> b -> [a] -> b
Prelude scanl :: (b -> a -> b) -> b -> [a] -> [b]
Data.List scanl :: (b -> a -> b) -> b -> [a] -> [b]
Data.List scanl' :: (b -> a -> b) -> b -> [a] -> [b]
GHC.OldList scanl :: (b -> a -> b) -> b -> [a] -> [b]
GHC.OldList scanl' :: (b -> a -> b) -> b -> [a] -> [b]
Prelude scanr :: (a -> b -> b) -> b -> [a] -> [b]
Data.List scanr :: (a -> b -> b) -> b -> [a] -> [b]
GHC.OldList scanr :: (a -> b -> b) -> b -> [a] -> [b]
Data.List.Extra list :: b -> (a -> [a] -> b) -> [a] -> b
Extra list :: b -> (a -> [a] -> b) -> [a] -> b
Prelude zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
Data.List zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
GHC.OldList zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
Foreign.Marshal.Utils withMany :: (a -> (b -> res) -> res) -> [a] -> ([b] -> res) -> res
Data.List intercalate :: [a] -> [[a]] -> [a]
GHC.OldList intercalate :: [a] -> [[a]] -> [a]
Prelude uncurry :: (a -> b -> c) -> ((a, b) -> c)
Data.Tuple uncurry :: (a -> b -> c) -> ((a, b) -> c)
Data.Tuple.Extra first :: (a -> a') -> (a, b) -> (a', b)
Extra first :: (a -> a') -> (a, b) -> (a', b)
Data.Tuple.Extra second :: (b -> b') -> (a, b) -> (a, b')
Extra second :: (b -> b') -> (a, b) -> (a, b')
-- plus more results not shown, pass --count=60 to see more




