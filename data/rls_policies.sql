--title select:

tconst = ANY (string_to_array(replace(coalesce(req() ->> 'mymedia_titles',''), '''', ''), ','::text))

-- this is a failure (times out):
/*
(tconst IN ( SELECT mymedia.tconst
   FROM mymedia
  WHERE (mymedia.owner = auth.uid())))
*/