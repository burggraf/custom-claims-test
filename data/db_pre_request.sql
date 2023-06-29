
CREATE OR REPLACE FUNCTION db_pre_request() RETURNS JSONB
    LANGUAGE "plpgsql" SECURITY DEFINER SET search_path = public
    AS 
    $$
    DECLARE 
    claims JSONB;
    user_role TEXT;
    BEGIN
    select coalesce(current_setting('request.jwt.claims', true),'{}') into claims;
    claims := claims || 
        jsonb_build_object('expires',to_timestamp(coalesce((claims::JSONB)->'exp','0')::numeric));

    -- get user_role from the roles table and add it to the claims
    select role from roles where uid = ((claims::JSONB)->>'sub')::uuid into user_role;
    claims := claims ||
        jsonb_build_object('user_role',user_role);

    PERFORM set_config(
        'request.jwt.other'::text, claims::text, false /* is_local */
    );

    return claims;
    END;
$$;
alter role authenticator 
    set pgrst.db_pre_request to 'public.db_pre_request';
NOTIFY pgrst, 'reload config';
