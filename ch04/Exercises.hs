import Prelude hiding (concat, takeWhile, groupBy)

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (h:_) = Just h

safeTail :: [a] -> Maybe [a]
safeTail [] = Nothing
safeTail (_:t) = Just t

safeLast :: [a] -> Maybe a
safeLast [] = Nothing
safeLast [a] = Just a
safeLast (_:t) = safeLast t

safeInit :: [a] -> Maybe [a]
safeInit [] = Nothing
safeInit (h:a:[]) = Just [h]
safeInit (h:t) = fmap (h : ) (safeInit t)

splitWith p l =
	reverse $ accumulate [] [] p l

accumulate a1 a2 p [] =
	if a2 /= []
		then reverse a2 : a1
		else a1
accumulate a1 a2 p (h:t) =
	if p h
		then accumulate a1 (h:a2) p t
		else
			if a2 /= []
				then accumulate (reverse a2 : a1) [] p t
				else accumulate a1 [] p t

concat1 :: [a] -> [a] -> [a]
concat1 []    acc = acc
concat1 (h:t) acc =
	h : concat1 t acc

concat :: [[a]] -> [a]
concat l = foldr concat1 [] l

takeWhile :: (a -> Bool) -> [a] -> [a]
takeWhile p [] = []
takeWhile p (h:t)
	| p h = h : takeWhile p t
	| otherwise = []

takeWhile1 p h acc
	| p h = h : acc
	| otherwise = acc

takeWhileF :: (a -> Bool) -> [a] -> [a]
takeWhileF p l = foldr (takeWhile1 p) [] l

groupBy1 :: (a -> a -> Bool) -> a -> [[a]] -> [[a]]
groupBy1 _ h [] =
	[[h]]

groupBy1 p h acc
	| p h h1 = (h : ha) : acc
	| otherwise = [h] : acc
	where ha = head acc
	      h1 = head ha

groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
groupBy p l = foldr (groupBy1 p) [] l
