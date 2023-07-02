-- get all header values as a json object
CREATE OR REPLACE FUNCTION public.headers() RETURNS json
    LANGUAGE sql STABLE
    AS $$
    SELECT COALESCE(current_setting('request.headers', true)::json, '{}'::json);
$$;
