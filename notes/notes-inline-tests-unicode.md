
- Cursor: below cursor
- Right of block: after end of line/ or (better) right of all lines in haskell block
  * right of block/implementation with option to select test number.
- Below block & below arg: below haskell block/ or (in case of test args) end of test arg line

* :type, type +d
  * paste
  * just show
    * type at (makes only sense for show)
* :kind
* :browse (only for import)


Testing/ Testframe have an emphesis on scalability, featibility in production and team-standards

focus on seeing/playing with data
to help learning and visualizing how implementations/transformats work
use this illustration of functionality for 
* documentation
* testing

There is an overlab (and some potention shortcomings) here:
  TDD <> Replbased Dev <> Documentation


kp0 = database3 (Just "eins") 123

-- > (Just "eins") 123
①  = (Just eins) 123
selSome ①  == { "Eins", 123 }
①  <$> maybe == Just { "Eins", 123 }
①  ◇ maybe == Just { "Eins", 123 }
①  ◇ maybe == Just { "Eins", 123 }
①  ◆ maybe == Just { "Eins", 123 }
①  ▴ maybe == Just { "Eins", 123 }
-- └ ▲ maybe == ⑷ Just { "Eins", 123 }
-- └ △ maybe == Just { "Eins", 123 }   ← this use as <$>
-- └ ↟ maybe == Just { "Eins", 123 }   ← this use as <$>
-- └ ˄ maybe == Just { "Eins", 123 }   ← this use as <$>
-- └ ⋀ maybe == Just { "Eins", 123 }   ← this use as <$>
-- └ ↕ maybe == Just { "Eins", 123 }   ← this use as <$>
-- └ ⬍ maybe == Just { "Eins", 123 }   ← this use as <$>
-- └ μ maybe == Just { "Eins", 123 }   ← this use as <$>
-- └ σ maybe == Just { "Eins", 123 }   ← this use as <$>
-- └ ⌂ ⌵ aybe == Just { "Eins", 123 }   ← this use as <$>
-- └ ⩟ ⩚ ⩓ ⋀ be == Just { "Eins", 123 }   ← this use as <$>
-- └ ﹩ ⍡ ⍚ ⍑ ⌗ e ⍓ ⏙n ⌓ ⍏ ⌶ ⍜ ⍛ ⍝ ≗ l ⋂ △ ⟐ ⪜ ≧ ⫦ ⊧⫩ ⊩ ⊫ >>= == Just { "Eins", 123 }
-- └ $ maybe == Just { "Eins", 123 }
-- └ Ⓢ  maybe == Just { "Eins", 123 } >>=
②            (\a → a)              
④
⑼

