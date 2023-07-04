--title select:

tconst = ANY (string_to_array(req() ->> 'mymedia_titles', ','))

-- this is a failure (times out):
/*
(tconst IN ( SELECT mymedia.tconst
   FROM mymedia
  WHERE (mymedia.owner = auth.uid())))
*/