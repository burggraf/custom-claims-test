CREATE OR REPLACE FUNCTION db_pre_request() RETURNS JSONB
    LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS 
$$
    DECLARE 
      claims JSONB;
      user_role TEXT;
      headers JSONB;
      mymedia_titles TEXT;
    BEGIN
    -- get the claims from the JWT 
    select coalesce(current_setting('request.jwt.claims', true),'{}') into claims;
    select coalesce(current_setting('request.headers', true), '{}') into headers;
    claims := claims || jsonb_build_object('headers',headers);
    -- convert the exp claim to a timestamp with time zone (UTC)
    -- claims := claims || 
    --     jsonb_build_object('expires',to_timestamp(coalesce((claims::JSONB)->'exp','0')::numeric));

    -- ******************************** CUSTOM CLAIMS ********************************
    -- get user_role from the roles table and add it to the claims
    -- select role from roles where uid = ((claims::JSONB)->>'sub')::uuid into user_role;
    -- claims := claims || jsonb_build_object('user_role',user_role);

    -- get list of titles owned by current user
    SELECT 
      array_to_string(array_agg(tconst), ',')
    FROM 
      mymedia 
    WHERE 
      mymedia.owner = (claims->>'sub')::uuid into mymedia_titles;

    claims := claims || jsonb_build_object('mymedia_titles',mymedia_titles);
    -- *******************************************************************************

    PERFORM set_config('request.claims'::text, claims::text, false /* is_local */);

    return claims;
    END;
$$;
alter role authenticator 
    set pgrst.db_pre_request to 'public.db_pre_request';
NOTIFY pgrst, 'reload config';
CREATE OR REPLACE FUNCTION claims() RETURNS "jsonb"
    LANGUAGE "sql" STABLE
    AS $$
  select 
  	coalesce(current_setting('request.claims', true), '{}')::JSONB
$$;
CREATE OR REPLACE FUNCTION req() RETURNS "jsonb"
    LANGUAGE "sql" STABLE
    AS $$
  select 
  	coalesce(current_setting('request.claims', true), '{}')::JSONB
$$;
