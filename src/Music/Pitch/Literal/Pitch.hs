
{-# LANGUAGE NoMonomorphismRestriction #-}

-------------------------------------------------------------------------------------
-- |
-- Copyright   : (c) Hans Hoglund 2012
--
-- License     : BSD-style
--
-- Maintainer  : hans@hanshoglund.se
-- Stability   : experimental
-- Portability : portable
--
-- Provides overloaded pitch literals.
--
-------------------------------------------------------------------------------------

module Music.Pitch.Literal.Pitch (

        -- * IsPitch class
        IsPitch(..),
        PitchL(..),
        
        -- * Literal values
        
        -- ** Four octaves up
        cs'''', ds'''', es'''', fs'''', gs'''', as'''', bs'''',
        c'''' , d'''' , e'''' , f'''' , g'''' , a'''' , b'''' ,
        cb'''', db'''', eb'''', fb'''', gb'''', ab'''', bb'''',

        -- ** Three octaves up
        cs''', ds''', es''', fs''', gs''', as''', bs''',
        c''' , d''' , e''' , f''' , g''' , a''' , b''' ,
        cb''', db''', eb''', fb''', gb''', ab''', bb''',

        -- ** Two octaves up
        cs'', ds'', es'', fs'', gs'', as'', bs'',
        c'' , d'' , e'' , f'' , g'' , a'' , b'' ,
        cb'', db'', eb'', fb'', gb'', ab'', bb'',

        -- ** One octave up
        cs' , ds' , es' , fs' , gs' , as' , bs' ,
        c'  , d'  , e'  , f'  , g'  , a'  , b'  ,
        cb' , db' , eb' , fb' , gb' , ab' , bb' ,

        -- ** Standard octave
        cs  , ds  , es  , fs  , gs  , as  , bs  ,
        c   , d   , e   , f   , g   , a   , b   ,
        cb  , db  , eb  , fb  , gb  , ab  , bb  ,

        -- ** One octave down
        cs_ , ds_ , es_ , fs_ , gs_ , as_ , bs_ ,
        c_  , d_  , e_  , f_  , g_  , a_  , b_  ,
        cb_ , db_ , eb_ , fb_ , gb_ , ab_ , bb_ ,

        -- ** Two octaves down
        cs__, ds__, es__, fs__, gs__, as__, bs__,
        c__ , d__ , e__ , f__ , g__ , a__ , b__ ,
        cb__, db__, eb__, fb__, gb__, ab__, bb__,

        -- ** Three octaves down
        cs___, ds___, es___, fs___, gs___, as___, bs___,
        c___ , d___ , e___ , f___ , g___ , a___ , b___ ,
        cb___, db___, eb___, fb___, gb___, ab___, bb___,

  ) where

import           Control.Applicative
import           Data.Fixed
import           Data.Int
import           Data.Ratio
import           Data.Semigroup
import           Data.Word

-- Pitch literal, defined as @(class, alteration, octave)@, where
--
--     * @class@      is a pitch class number in @[0..6]@, starting from C.
--
--     * @alteration@ is the number of semitones, i.e. 0 is natural, 1 for sharp 2 for double sharp, -1 for flat and -2 for double flat.
--       Alteration is in 'Maybe' because some pitch representations differ between explicit and explicit accidentals, i.e. a diatonic
--       pitch type may assume @(0,Nothing,...)@ to mean C sharp rather than C.
--
--     * @octave@     is octave number in scientific pitch notation.
--
-- Middle C is represented by the pitch literal @(0, Nothing, 0)@.
--
newtype PitchL = PitchL { getPitchL :: (Int, Maybe Double, Int) }
    deriving (Eq, Show, Ord)

class IsPitch a where
    fromPitch :: PitchL -> a

instance IsPitch PitchL where
    fromPitch = id

instance IsPitch a => IsPitch (Maybe a) where
    fromPitch = pure . fromPitch

instance IsPitch a => IsPitch (First a) where
    fromPitch = pure . fromPitch

instance IsPitch a => IsPitch (Last a) where
    fromPitch = pure . fromPitch

instance IsPitch a => IsPitch [a] where
    fromPitch = pure . fromPitch

instance (Monoid b, IsPitch a) => IsPitch (b, a) where
    fromPitch = pure . fromPitch

instance IsPitch Int where
    fromPitch x = fromIntegral (fromPitch x :: Integer)

instance IsPitch Word where
    fromPitch x = fromIntegral (fromPitch x :: Integer)

instance IsPitch Float where
    fromPitch x = realToFrac (fromPitch x :: Double)

instance HasResolution a => IsPitch (Fixed a) where
    fromPitch x = realToFrac (fromPitch x :: Double)

instance Integral a => IsPitch (Ratio a) where
    fromPitch x = realToFrac (fromPitch x :: Double)

instance IsPitch Double where
    fromPitch (PitchL (pc, sem, oct)) = fromIntegral $ semitones sem + diatonic pc + oct * 12
        where
            semitones = maybe 0 round
            diatonic pc = case pc of
                0 -> 0
                1 -> 2
                2 -> 4
                3 -> 5
                4 -> 7
                5 -> 9
                6 -> 11

instance IsPitch Integer where
    fromPitch (PitchL (pc, sem, oct)) = fromIntegral $ semitones sem + diatonic pc + oct * 12
        where
            semitones = maybe 0 round
            diatonic pc = case pc of
                0 -> 0
                1 -> 2
                2 -> 4
                3 -> 5
                4 -> 7
                5 -> 9
                6 -> 11

cs'' = fromPitch $ PitchL (0, Just 1, 2)
ds'' = fromPitch $ PitchL (1, Just 1, 2)
es'' = fromPitch $ PitchL (2, Just 1, 2)
fs'' = fromPitch $ PitchL (3, Just 1, 2)
gs'' = fromPitch $ PitchL (4, Just 1, 2)
as'' = fromPitch $ PitchL (5, Just 1, 2)
bs'' = fromPitch $ PitchL (6, Just 1, 2)

c''  = fromPitch $ PitchL (0, Nothing, 2)
d''  = fromPitch $ PitchL (1, Nothing, 2)
e''  = fromPitch $ PitchL (2, Nothing, 2)
f''  = fromPitch $ PitchL (3, Nothing, 2)
g''  = fromPitch $ PitchL (4, Nothing, 2)
a''  = fromPitch $ PitchL (5, Nothing, 2)
b''  = fromPitch $ PitchL (6, Nothing, 2)

cb'' = fromPitch $ PitchL (0, Just (-1), 2)
db'' = fromPitch $ PitchL (1, Just (-1), 2)
eb'' = fromPitch $ PitchL (2, Just (-1), 2)
fb'' = fromPitch $ PitchL (3, Just (-1), 2)
gb'' = fromPitch $ PitchL (4, Just (-1), 2)
ab'' = fromPitch $ PitchL (5, Just (-1), 2)
bb'' = fromPitch $ PitchL (6, Just (-1), 2)

cs'  = fromPitch $ PitchL (0, Just 1, 1)
ds'  = fromPitch $ PitchL (1, Just 1, 1)
es'  = fromPitch $ PitchL (2, Just 1, 1)
fs'  = fromPitch $ PitchL (3, Just 1, 1)
gs'  = fromPitch $ PitchL (4, Just 1, 1)
as'  = fromPitch $ PitchL (5, Just 1, 1)
bs'  = fromPitch $ PitchL (6, Just 1, 1)

c'   = fromPitch $ PitchL (0, Nothing, 1)
d'   = fromPitch $ PitchL (1, Nothing, 1)
e'   = fromPitch $ PitchL (2, Nothing, 1)
f'   = fromPitch $ PitchL (3, Nothing, 1)
g'   = fromPitch $ PitchL (4, Nothing, 1)
a'   = fromPitch $ PitchL (5, Nothing, 1)
b'   = fromPitch $ PitchL (6, Nothing, 1)

cb'  = fromPitch $ PitchL (0, Just (-1), 1)
db'  = fromPitch $ PitchL (1, Just (-1), 1)
eb'  = fromPitch $ PitchL (2, Just (-1), 1)
fb'  = fromPitch $ PitchL (3, Just (-1), 1)
gb'  = fromPitch $ PitchL (4, Just (-1), 1)
ab'  = fromPitch $ PitchL (5, Just (-1), 1)
bb'  = fromPitch $ PitchL (6, Just (-1), 1)

cs   = fromPitch $ PitchL (0, Just 1, 0)
ds   = fromPitch $ PitchL (1, Just 1, 0)
es   = fromPitch $ PitchL (2, Just 1, 0)
fs   = fromPitch $ PitchL (3, Just 1, 0)
gs   = fromPitch $ PitchL (4, Just 1, 0)
as   = fromPitch $ PitchL (5, Just 1, 0)
bs   = fromPitch $ PitchL (6, Just 1, 0)

c    = fromPitch $ PitchL (0, Nothing, 0)
d    = fromPitch $ PitchL (1, Nothing, 0)
e    = fromPitch $ PitchL (2, Nothing, 0)
f    = fromPitch $ PitchL (3, Nothing, 0)
g    = fromPitch $ PitchL (4, Nothing, 0)
a    = fromPitch $ PitchL (5, Nothing, 0)
b    = fromPitch $ PitchL (6, Nothing, 0)

cb   = fromPitch $ PitchL (0, Just (-1), 0)
db   = fromPitch $ PitchL (1, Just (-1), 0)
eb   = fromPitch $ PitchL (2, Just (-1), 0)
fb   = fromPitch $ PitchL (3, Just (-1), 0)
gb   = fromPitch $ PitchL (4, Just (-1), 0)
ab   = fromPitch $ PitchL (5, Just (-1), 0)
bb   = fromPitch $ PitchL (6, Just (-1), 0)

cs_  = fromPitch $ PitchL (0, Just 1, -1)
ds_  = fromPitch $ PitchL (1, Just 1, -1)
es_  = fromPitch $ PitchL (2, Just 1, -1)
fs_  = fromPitch $ PitchL (3, Just 1, -1)
gs_  = fromPitch $ PitchL (4, Just 1, -1)
as_  = fromPitch $ PitchL (5, Just 1, -1)
bs_  = fromPitch $ PitchL (6, Just 1, -1)

c_   = fromPitch $ PitchL (0, Nothing, -1)
d_   = fromPitch $ PitchL (1, Nothing, -1)
e_   = fromPitch $ PitchL (2, Nothing, -1)
f_   = fromPitch $ PitchL (3, Nothing, -1)
g_   = fromPitch $ PitchL (4, Nothing, -1)
a_   = fromPitch $ PitchL (5, Nothing, -1)
b_   = fromPitch $ PitchL (6, Nothing, -1)

cb_  = fromPitch $ PitchL (0, Just (-1), -1)
db_  = fromPitch $ PitchL (1, Just (-1), -1)
eb_  = fromPitch $ PitchL (2, Just (-1), -1)
fb_  = fromPitch $ PitchL (3, Just (-1), -1)
gb_  = fromPitch $ PitchL (4, Just (-1), -1)
ab_  = fromPitch $ PitchL (5, Just (-1), -1)
bb_  = fromPitch $ PitchL (6, Just (-1), -1)

cs__ = fromPitch $ PitchL (0, Just 1, -2)
ds__ = fromPitch $ PitchL (1, Just 1, -2)
es__ = fromPitch $ PitchL (2, Just 1, -2)
fs__ = fromPitch $ PitchL (3, Just 1, -2)
gs__ = fromPitch $ PitchL (4, Just 1, -2)
as__ = fromPitch $ PitchL (5, Just 1, -2)
bs__ = fromPitch $ PitchL (6, Just 1, -2)

c__  = fromPitch $ PitchL (0, Nothing, -2)
d__  = fromPitch $ PitchL (1, Nothing, -2)
e__  = fromPitch $ PitchL (2, Nothing, -2)
f__  = fromPitch $ PitchL (3, Nothing, -2)
g__  = fromPitch $ PitchL (4, Nothing, -2)
a__  = fromPitch $ PitchL (5, Nothing, -2)
b__  = fromPitch $ PitchL (6, Nothing, -2)

cb__ = fromPitch $ PitchL (0, Just (-1), -2)
db__ = fromPitch $ PitchL (1, Just (-1), -2)
eb__ = fromPitch $ PitchL (2, Just (-1), -2)
fb__ = fromPitch $ PitchL (3, Just (-1), -2)
gb__ = fromPitch $ PitchL (4, Just (-1), -2)
ab__ = fromPitch $ PitchL (5, Just (-1), -2)
bb__ = fromPitch $ PitchL (6, Just (-1), -2)


----
b''' = octavesUp 1 b''
a''' = octavesUp 1 a''
g''' = octavesUp 1 g''
f''' = octavesUp 1 f''
e''' = octavesUp 1 e''
d''' = octavesUp 1 d''
c''' = octavesUp 1 c''

bs''' = octavesUp 1 bs''
as''' = octavesUp 1 as''
gs''' = octavesUp 1 gs''
fs''' = octavesUp 1 fs''
es''' = octavesUp 1 es''
ds''' = octavesUp 1 ds''
cs''' = octavesUp 1 cs''

bb''' = octavesUp 1 bb''
ab''' = octavesUp 1 ab''
gb''' = octavesUp 1 gb''
fb''' = octavesUp 1 fb''
eb''' = octavesUp 1 eb''
db''' = octavesUp 1 db''
cb''' = octavesUp 1 cb''

b'''' = octavesUp 1 b'''
a'''' = octavesUp 1 a'''
g'''' = octavesUp 1 g'''
f'''' = octavesUp 1 f'''
e'''' = octavesUp 1 e'''
d'''' = octavesUp 1 d'''
c'''' = octavesUp 1 c'''

bs'''' = octavesUp 1 bs'''
as'''' = octavesUp 1 as'''
gs'''' = octavesUp 1 gs'''
fs'''' = octavesUp 1 fs'''
es'''' = octavesUp 1 es'''
ds'''' = octavesUp 1 ds'''
cs'''' = octavesUp 1 cs'''

bb'''' = octavesUp 1 bb'''
ab'''' = octavesUp 1 ab'''
gb'''' = octavesUp 1 gb'''
fb'''' = octavesUp 1 fb'''
eb'''' = octavesUp 1 eb'''
db'''' = octavesUp 1 db'''
cb'''' = octavesUp 1 cb'''




b___ = octavesDown 1 b__
a___ = octavesDown 1 a__
g___ = octavesDown 1 g__
f___ = octavesDown 1 f__
e___ = octavesDown 1 e__
d___ = octavesDown 1 d__
c___ = octavesDown 1 c__

bs___ = octavesDown 1 bs__
as___ = octavesDown 1 as__
gs___ = octavesDown 1 gs__
fs___ = octavesDown 1 fs__
es___ = octavesDown 1 es__
ds___ = octavesDown 1 ds__
cs___ = octavesDown 1 cs__

bb___ = octavesDown 1 bb__
ab___ = octavesDown 1 ab__
gb___ = octavesDown 1 gb__
fb___ = octavesDown 1 fb__
eb___ = octavesDown 1 eb__
db___ = octavesDown 1 db__
cb___ = octavesDown 1 cb__


