
CREATE OR REPLACE FUNCTION db_pre_request() RETURNS JSONB
    LANGUAGE "plpgsql" SECURITY DEFINER SET search_path = public
    AS 
    $$
    DECLARE 
    claims JSONB;
    BEGIN
    select current_setting('request.jwt.claims', true) into claims;

    claims := claims || '{"added_by_db_pre_request": "BBB"}'::JSONB;

    PERFORM set_config(
        'request.jwt.other'::text,
        claims::text,
        false -- is_local
    );

    return claims;
    END;
$$;