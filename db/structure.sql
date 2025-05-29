SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: access_control; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA access_control;


--
-- Name: ai_analytics; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ai_analytics;


--
-- Name: appointments; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA appointments;


--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: clients; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA clients;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: financials; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA financials;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: growth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA growth;


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgsodium;


--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: store_management; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA store_management;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: wrappers; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS wrappers WITH SCHEMA financials;


--
-- Name: EXTENSION wrappers; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION wrappers IS 'Foreign data wrappers developed by Supabase';


--
-- Name: action_type_enum; Type: TYPE; Schema: access_control; Owner: -
--

CREATE TYPE access_control.action_type_enum AS ENUM (
    'update',
    'delete',
    'create'
);


--
-- Name: employment_type_enum; Type: TYPE; Schema: access_control; Owner: -
--

CREATE TYPE access_control.employment_type_enum AS ENUM (
    'full-time',
    'part-time'
);


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: is_email(text); Type: FUNCTION; Schema: access_control; Owner: -
--

CREATE FUNCTION access_control.is_email(input text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
  RETURN input ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';
END;
$_$;


--
-- Name: is_phone_number(text); Type: FUNCTION; Schema: access_control; Owner: -
--

CREATE FUNCTION access_control.is_phone_number(input text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
BEGIN
  RETURN input ~ '^\d{8,15}$';
END;
$_$;


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF EXISTS (
      SELECT 1
      FROM pg_event_trigger_ddl_commands() AS ev
      JOIN pg_extension AS ext
      ON ev.objid = ext.oid
      WHERE ext.extname = 'pg_net'
    )
    THEN
      IF NOT EXISTS (
        SELECT 1
        FROM pg_roles
        WHERE rolname = 'supabase_functions_admin'
      )
      THEN
        CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
      END IF;

      GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

      IF EXISTS (
        SELECT FROM pg_extension
        WHERE extname = 'pg_net'
        -- all versions in use on existing projects as of 2025-02-20
        -- version 0.12.0 onwards don't need these applied
        AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8.0', '0.10.0', '0.11.0')
      ) THEN
        ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
        ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

        ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
        ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

        REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
        REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

        GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
        GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      END IF;
    END IF;
  END;
  $$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      PERFORM pg_notify(
          'realtime:system',
          jsonb_build_object(
              'error', SQLERRM,
              'function', 'realtime.send',
              'event', event,
              'topic', topic,
              'private', private
          )::text
      );
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


--
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: -
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account_details; Type: TABLE; Schema: access_control; Owner: -
--

CREATE TABLE access_control.account_details (
    account_details_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    store_id uuid NOT NULL,
    currency text,
    bank_account_number text,
    bank_name text,
    subscription_status text,
    trial_end_date timestamp with time zone,
    auto_renew boolean,
    billing_cycle text,
    payment_method_token text,
    last_payment_date timestamp with time zone,
    payment_provider_customerid text,
    invoice_email text,
    tax_id text,
    grace_period_end timestamp with time zone,
    partner_code text,
    pricing_plan text,
    payout_method text,
    next_payment_due timestamp with time zone,
    subscription_start_date timestamp with time zone,
    payment_status text,
    outstanding_balance numeric(12,2),
    reciept_url text,
    cancelled_at timestamp with time zone,
    cancellation_reason text,
    subscription_notes text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: permissions; Type: TABLE; Schema: access_control; Owner: -
--

CREATE TABLE access_control.permissions (
    permission_name character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    description text,
    permission_id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: support_ticket; Type: TABLE; Schema: access_control; Owner: -
--

CREATE TABLE access_control.support_ticket (
    ticket_id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid NOT NULL,
    subject text NOT NULL,
    description text,
    status text,
    assigned_to uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: user_logs; Type: TABLE; Schema: access_control; Owner: -
--

CREATE TABLE access_control.user_logs (
    log_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    action_type access_control.action_type_enum,
    table_name text,
    record_id text,
    old_value jsonb,
    new_value jsonb,
    store_id uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: user_permissions; Type: TABLE; Schema: access_control; Owner: -
--

CREATE TABLE access_control.user_permissions (
    user_permission_id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    permission_toggle boolean NOT NULL,
    granted_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: user_store_assignment; Type: TABLE; Schema: access_control; Owner: -
--

CREATE TABLE access_control.user_store_assignment (
    assignment_id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    store_id uuid NOT NULL,
    active boolean NOT NULL,
    role_name text NOT NULL,
    employment_type access_control.employment_type_enum,
    permissions jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: users; Type: TABLE; Schema: access_control; Owner: -
--

CREATE TABLE access_control.users (
    user_id uuid DEFAULT gen_random_uuid() NOT NULL,
    auth0_id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone_number character varying(50),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    is_verified boolean DEFAULT false,
    multi_store_access boolean DEFAULT false,
    image text DEFAULT ''::text,
    preferred_language text DEFAULT 'en'::text,
    last_login timestamp with time zone DEFAULT now(),
    CONSTRAINT email_format CHECK (access_control.is_email((email)::text)),
    CONSTRAINT phone_format CHECK (access_control.is_phone_number((phone_number)::text))
);


--
-- Name: appointment_add_ons; Type: TABLE; Schema: appointments; Owner: -
--

CREATE TABLE appointments.appointment_add_ons (
    add_on_id uuid DEFAULT gen_random_uuid() NOT NULL,
    appointment_id uuid NOT NULL,
    inventory_id uuid NOT NULL,
    quantity integer,
    discounted boolean DEFAULT false,
    addon_price numeric,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: appointment_logs; Type: TABLE; Schema: appointments; Owner: -
--

CREATE TABLE appointments.appointment_logs (
    appt_log_id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    service_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    store_id uuid NOT NULL,
    vacancy_id uuid,
    change_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: appointments; Type: TABLE; Schema: appointments; Owner: -
--

CREATE TABLE appointments.appointments (
    appt_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    client_id uuid NOT NULL,
    service_id uuid NOT NULL,
    vacancy_id uuid,
    appt_start timestamp with time zone NOT NULL,
    appt_end timestamp with time zone NOT NULL,
    appt_notes text,
    walk_in boolean DEFAULT false,
    prepayment_amt numeric,
    time_alert_triggered boolean DEFAULT false,
    buffer_time integer,
    review text,
    feedback_sentiment text,
    discount_applied numeric,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: appt_insight; Type: TABLE; Schema: appointments; Owner: -
--

CREATE TABLE appointments.appt_insight (
    insight_id uuid DEFAULT gen_random_uuid() NOT NULL,
    appt_id uuid,
    type text,
    value jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: waitlists; Type: TABLE; Schema: appointments; Owner: -
--

CREATE TABLE appointments.waitlists (
    waitlist_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    client_id uuid NOT NULL,
    service_id uuid NOT NULL,
    waitlist_position integer,
    notified_at timestamp with time zone,
    waitlist_status text,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: walkin_queue; Type: TABLE; Schema: appointments; Owner: -
--

CREATE TABLE appointments.walkin_queue (
    queue_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_id uuid NOT NULL,
    client_id uuid NOT NULL,
    service_id uuid NOT NULL,
    added_at timestamp with time zone DEFAULT now(),
    status text,
    called_by uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: automated_msg; Type: TABLE; Schema: clients; Owner: -
--

CREATE TABLE clients.automated_msg (
    msg_id uuid DEFAULT gen_random_uuid() NOT NULL,
    msg_type text NOT NULL,
    assignment_id uuid,
    target_audience text,
    msg_title text,
    msg_content text,
    delivery_channel text,
    scheduled_time timestamp with time zone,
    frequency text,
    sent_time timestamp with time zone,
    delivery_status text,
    response_data jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: clients; Type: TABLE; Schema: clients; Owner: -
--

CREATE TABLE clients.clients (
    client_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_id uuid NOT NULL,
    global_client_id uuid NOT NULL,
    client_segment text,
    blocked boolean,
    notes text,
    marketing_opt_in boolean,
    source_channel text,
    loyalty_points integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: global_clients; Type: TABLE; Schema: clients; Owner: -
--

CREATE TABLE clients.global_clients (
    global_client_id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_name text NOT NULL,
    preferred_name text,
    preferred_contact_method text,
    client_email text,
    client_ph integer NOT NULL,
    gender text,
    client_dob date,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: payroll; Type: TABLE; Schema: financials; Owner: -
--

CREATE TABLE financials.payroll (
    payroll_id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    base_salary numeric,
    comm_service_per numeric,
    comm_inventory_per numeric,
    comm_service numeric,
    comm_inventory numeric,
    bonus numeric,
    gross_salary numeric,
    payout_status text,
    payment_date_actual timestamp with time zone,
    payout_method text,
    approval_status text,
    approved_by uuid,
    remarks text,
    start_date date,
    end_date date,
    payroll_date date,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: transaction; Type: TABLE; Schema: financials; Owner: -
--

CREATE TABLE financials.transaction (
    transaction_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    appointment_id uuid,
    tip_amount numeric,
    promo_code text,
    transaction_note text,
    revenue numeric,
    discount numeric,
    tax numeric,
    payment_gateway_response text,
    processed_date timestamp with time zone,
    invoice_id text,
    is_refunded boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: transaction_log; Type: TABLE; Schema: financials; Owner: -
--

CREATE TABLE financials.transaction_log (
    transaction_log_id uuid DEFAULT gen_random_uuid() NOT NULL,
    appointment_id uuid NOT NULL,
    store_id uuid NOT NULL,
    transaction_id uuid NOT NULL,
    assignment_id uuid NOT NULL,
    updated_by uuid,
    revenue numeric,
    discount numeric,
    tax numeric,
    processed_date timestamp with time zone,
    reason_for_change text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: client_stats; Type: TABLE; Schema: growth; Owner: -
--

CREATE TABLE growth.client_stats (
    client_stats_id uuid DEFAULT gen_random_uuid() NOT NULL,
    client_id uuid NOT NULL,
    store_id uuid NOT NULL,
    first_visit_date date,
    booking_channel_preference text,
    total_appts integer,
    vip_flag boolean,
    last_feedback_sentiment text,
    frequency numeric,
    last_visit timestamp with time zone,
    total_spending numeric,
    most_frequent_service text,
    predicted_churn boolean DEFAULT false,
    customer_lifetime_value numeric,
    no_show_count integer,
    no_show_rate numeric,
    discount_usage_rate numeric,
    cancellation_rate numeric,
    reschedule_rate numeric,
    forecast_type text,
    churn_risk_score numeric,
    forecast_value numeric,
    forecast_date timestamp with time zone,
    avg_spending numeric DEFAULT 0.0,
    last_no_show timestamp with time zone,
    common_addons text,
    addon_conversion_rate numeric,
    preferred_day text,
    review_score_avg numeric,
    common_payment_method text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: model_predictions; Type: TABLE; Schema: growth; Owner: -
--

CREATE TABLE growth.model_predictions (
    prediction_id uuid DEFAULT gen_random_uuid() NOT NULL,
    prediction_model_name text,
    model_version text,
    target_entity_type text,
    target_table_id uuid,
    prediction_type text,
    prediction_value numeric,
    run_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: staff_stats; Type: TABLE; Schema: growth; Owner: -
--

CREATE TABLE growth.staff_stats (
    staff_stats_id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    productivity_score numeric,
    total_hours_worked numeric,
    overwork_risk numeric,
    avg_shift_length numeric,
    idle_time_percentage numeric,
    forecast_type text,
    forecast_value numeric,
    forecast_date timestamp with time zone,
    avg_idle_time numeric,
    late_shifts_count integer,
    early_leaves_count integer,
    recommended_shift json,
    total_shifts integer,
    avg_client_rating numeric,
    revenue_generated numeric,
    avg_revenue numeric,
    time_utilisation numeric,
    days_off_taken integer,
    most_frequent_service text,
    on_time_rate numeric,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: store_stats; Type: TABLE; Schema: growth; Owner: -
--

CREATE TABLE growth.store_stats (
    store_stats_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_id uuid NOT NULL,
    gross_margin numeric,
    staff_turnover_rate numeric,
    utilisation_peakvsoffpeak numeric,
    avg_booking_leadtime numeric,
    avg_tip_amt numeric,
    no_show_revenue_loss numeric,
    waitlist_conversion_rate numeric,
    avg_prepayment_rate numeric,
    total_appts integer,
    noshow_rate numeric,
    cancellation_rate numeric,
    reschedule_rate numeric,
    booking_conversion_rate numeric,
    avg_daily_appts numeric,
    avg_appt_duration numeric,
    workday_utilisation_rate numeric,
    busiest_day text,
    total_revenue numeric,
    avg_revenue_perappt numeric,
    top_service text,
    inventory_sold_value numeric,
    inventory_turnover_rate numeric,
    active_staff_count integer,
    avg_staff_utilisation numeric,
    late_clock_ins integer,
    forecast_type text,
    forecast_value numeric,
    forecast_date timestamp with time zone,
    low_stock_alert_count integer,
    expired_inventory_count integer,
    avg_days_bw_restock numeric,
    inventory_accuracy_rate numeric,
    avg_wait_time numeric,
    appt_delay_rate numeric,
    service_time_variability numeric,
    schedule_overrun numeric,
    downtime_hours numeric,
    peak_hour_efficiency numeric,
    inventory_stockouts integer,
    new_clients integer,
    repeat_visit_rate numeric,
    client_retention_rate numeric,
    top_clients text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: account_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.account_details (
    id bigint NOT NULL,
    account_details_id uuid,
    user_id uuid,
    store_id uuid,
    currency character varying,
    bank_account_number character varying,
    bank_name character varying,
    subscription_status character varying,
    trial_end_date timestamp(6) without time zone,
    auto_renew boolean,
    billing_cycle character varying,
    payment_method_token character varying,
    last_payment_date timestamp(6) without time zone,
    payment_provider_customerid character varying,
    invoice_email character varying,
    tax_id character varying,
    grace_period_end timestamp(6) without time zone,
    partner_code character varying,
    pricing_plan character varying,
    payout_method character varying,
    next_payment_due timestamp(6) without time zone,
    subscription_start_date timestamp(6) without time zone,
    payment_status character varying,
    outstanding_balance numeric,
    reciept_url character varying,
    cancelled_at timestamp(6) without time zone,
    cancellation_reason character varying,
    subscription_notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: account_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.account_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.account_details_id_seq OWNED BY public.account_details.id;


--
-- Name: appointment_add_ons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointment_add_ons (
    id bigint NOT NULL,
    add_on_id uuid,
    appointment_id uuid,
    inventory_id uuid,
    quantity integer,
    discounted boolean,
    addon_price numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: appointment_add_ons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.appointment_add_ons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appointment_add_ons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.appointment_add_ons_id_seq OWNED BY public.appointment_add_ons.id;


--
-- Name: appointment_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointment_logs (
    id bigint NOT NULL,
    appt_log_id uuid,
    client_id uuid,
    service_id uuid,
    assignment_id uuid,
    store_id uuid,
    vacancy_id uuid,
    status character varying,
    change_by uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: appointment_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.appointment_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appointment_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.appointment_logs_id_seq OWNED BY public.appointment_logs.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointments (
    id bigint NOT NULL,
    appt_id uuid,
    store_id uuid,
    assignment_id uuid,
    client_id uuid,
    service_id uuid,
    vacancy_id uuid,
    appt_start timestamp(6) without time zone,
    appt_end timestamp(6) without time zone,
    status character varying,
    appt_notes text,
    walk_in boolean,
    prepayment_amt numeric,
    time_alert_triggered boolean,
    buffer_time integer,
    payment_status character varying,
    review text,
    feedback_sentiment character varying,
    discount_applied numeric,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: appt_insights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appt_insights (
    id bigint NOT NULL,
    insight_id uuid,
    appt_id uuid,
    type character varying,
    value json,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: appt_insights_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.appt_insights_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: appt_insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.appt_insights_id_seq OWNED BY public.appt_insights.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: automated_msgs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.automated_msgs (
    id bigint NOT NULL,
    msg_id uuid,
    msg_type character varying,
    assignment_id uuid,
    target_audience character varying,
    msg_title character varying,
    msg_content text,
    delivery_channel character varying,
    scheduled_time timestamp(6) without time zone,
    frequency character varying,
    sent_time timestamp(6) without time zone,
    delivery_status character varying,
    response_data json,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: automated_msgs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.automated_msgs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: automated_msgs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.automated_msgs_id_seq OWNED BY public.automated_msgs.id;


--
-- Name: client_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_stats (
    id bigint NOT NULL,
    client_stats_id uuid,
    client_id uuid,
    store_id uuid,
    first_visit_state character varying,
    booking_channel_preference character varying,
    total_appts integer,
    vip_flag boolean,
    last_feedback_sentiment character varying,
    frequency numeric,
    last_visit timestamp(6) without time zone,
    total_spending numeric,
    most_frequent_service character varying,
    predicted_churn boolean,
    customer_lifetime_value numeric,
    no_show_count integer,
    no_show_rate numeric,
    discount_usage_rate numeric,
    cancellation_rate numeric,
    reschedule_rate numeric,
    forecast_type character varying,
    churn_risk_score numeric,
    forecast_value numeric,
    forecast_date timestamp(6) without time zone,
    avg_spending numeric,
    last_no_show timestamp(6) without time zone,
    common_addons character varying,
    addon_conversion_rate numeric,
    preferred_day character varying,
    review_score_avg numeric,
    common_payment_method character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: client_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.client_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: client_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.client_stats_id_seq OWNED BY public.client_stats.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.clients (
    id bigint NOT NULL,
    client_id uuid,
    store_id uuid,
    global_client_id uuid,
    client_segment character varying,
    blocked boolean,
    notes text,
    marketing_opt_in boolean,
    source_channel character varying,
    loyalty_points integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: global_clients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.global_clients (
    id bigint NOT NULL,
    global_client_id uuid,
    client_name character varying,
    preferred_name character varying,
    preferred_contact_method character varying,
    client_email character varying,
    client_ph character varying,
    gender character varying,
    client_dob timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: global_clients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.global_clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: global_clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.global_clients_id_seq OWNED BY public.global_clients.id;


--
-- Name: inventories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventories (
    id bigint NOT NULL,
    inventory_id uuid,
    store_id uuid,
    vendor_id uuid,
    product_category character varying,
    inventory_type character varying,
    product_image character varying,
    product_name character varying,
    product_desc text,
    add_quantity integer,
    current_quantity integer,
    total_quantity integer,
    product_cost numeric,
    product_price numeric,
    expiration_date timestamp(6) without time zone,
    last_restock_date timestamp(6) without time zone,
    suggested_restock_date timestamp(6) without time zone,
    is_restocked boolean,
    barcode character varying,
    threshold_quantity integer,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: inventories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventories_id_seq OWNED BY public.inventories.id;


--
-- Name: inventory_alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_alerts (
    id bigint NOT NULL,
    alert_id uuid,
    inventory_id uuid,
    alert_type character varying,
    suggested_action character varying,
    is_resolved boolean,
    resolved_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: inventory_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_alerts_id_seq OWNED BY public.inventory_alerts.id;


--
-- Name: inventory_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_logs (
    id bigint NOT NULL,
    inventory_log_id uuid,
    inventory_id uuid,
    appointment_id uuid,
    note text,
    action_type character varying,
    quantity_changed integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: inventory_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_logs_id_seq OWNED BY public.inventory_logs.id;


--
-- Name: leaves; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.leaves (
    id bigint NOT NULL,
    leave_id uuid,
    assignment_id uuid,
    leave_type character varying,
    leave_date date,
    start_time time without time zone,
    end_time time without time zone,
    leave_reason text,
    leave_status character varying,
    approved boolean,
    approved_by uuid,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: leaves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leaves_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: leaves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leaves_id_seq OWNED BY public.leaves.id;


--
-- Name: model_predictions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.model_predictions (
    id bigint NOT NULL,
    prediction_id uuid,
    prediction_model_name character varying,
    model_version character varying,
    target_entity_type character varying,
    target_table_id uuid,
    prediction_type character varying,
    prediction_value numeric,
    run_date timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: model_predictions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.model_predictions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: model_predictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.model_predictions_id_seq OWNED BY public.model_predictions.id;


--
-- Name: payrolls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payrolls (
    id bigint NOT NULL,
    financials_payroll character varying,
    payroll_id uuid,
    assignment_id uuid,
    base_salary numeric,
    comm_service_per numeric,
    comm_inventory_per numeric,
    comm_service numeric,
    comm_inventory numeric,
    bonus numeric,
    gross_salary numeric,
    payout_status character varying,
    payment_date_actual timestamp(6) without time zone,
    payout_method character varying,
    approval_status character varying,
    approved_by uuid,
    remarks text,
    start_date date,
    end_date date,
    payroll_date date,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: payrolls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payrolls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payrolls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payrolls_id_seq OWNED BY public.payrolls.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    permission_id uuid,
    permission_name character varying,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.services (
    id bigint NOT NULL,
    service_id uuid,
    store_id uuid,
    service_image character varying,
    service_name character varying,
    service_desc text,
    service_price numeric,
    service_duration integer,
    is_featured boolean,
    service_category character varying,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: shifts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shifts (
    id bigint NOT NULL,
    shift_id uuid,
    assignment_id uuid,
    shift_date date,
    start_time time without time zone,
    end_time time without time zone,
    break_start time without time zone,
    break_end time without time zone,
    days_off json,
    scheduled_by character varying,
    is_peak_shift boolean,
    block_reason character varying,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shifts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shifts_id_seq OWNED BY public.shifts.id;


--
-- Name: staff_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.staff_stats (
    id bigint NOT NULL,
    staff_stats_id uuid,
    assignment_id uuid,
    productivity_score numeric,
    total_hours_worked numeric,
    overwork_risk numeric,
    avg_shift_length numeric,
    idle_time_percentage numeric,
    forecast_type character varying,
    forecast_value numeric,
    forecast_date timestamp(6) without time zone,
    avg_idle_time numeric,
    late_shifts_count integer,
    early_leaves_count integer,
    recommended_shift json,
    staff_total_shifts integer,
    avg_client_rating numeric,
    revenue_generated numeric,
    avg_revenue numeric,
    time_utilisation numeric,
    days_off_taken integer,
    most_frequent_service character varying,
    on_time_rate numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: staff_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.staff_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: staff_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.staff_stats_id_seq OWNED BY public.staff_stats.id;


--
-- Name: store_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.store_stats (
    id bigint NOT NULL,
    store_stats_id uuid,
    store_id uuid,
    gross_margin numeric,
    staff_turnover_rate numeric,
    utilisation_peakvsoffpeak numeric,
    avg_booking_leadtime numeric,
    avg_tip_amt numeric,
    no_show_revenue_loss numeric,
    waitlist_conversion_rate numeric,
    avg_prepayment_rate numeric,
    total_appts integer,
    noshow_rate numeric,
    cancellation_rate numeric,
    reschedule_rate numeric,
    booking_conversion_rate numeric,
    avg_daily_appts numeric,
    avg_appt_duration numeric,
    workday_utilisation_rate numeric,
    busiest_day character varying,
    total_revenue numeric,
    avg_revenue_perappt numeric,
    top_service character varying,
    inventory_sold_value numeric,
    inventory_turnover_rate numeric,
    active_staff_count integer,
    avg_staff_utilisation numeric,
    late_clock_ins integer,
    forecast_type character varying,
    forecast_value numeric,
    forecast_date timestamp(6) without time zone,
    low_stock_alert_count integer,
    expired_inventory_count integer,
    avg_days_bw_restock numeric,
    inventory_accuracy_rate numeric,
    avg_wait_time numeric,
    appt_delay_rate numeric,
    service_time_variability numeric,
    schedule_overrun numeric,
    downtime_hours numeric,
    peak_hour_efficiency numeric,
    inventory_stockouts integer,
    new_clients integer,
    repeat_visit_rate numeric,
    client_retention_rate numeric,
    top_clients character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: store_stats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.store_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: store_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.store_stats_id_seq OWNED BY public.store_stats.id;


--
-- Name: stores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stores (
    id bigint NOT NULL,
    store_id uuid,
    store_name character varying,
    store_type character varying,
    google_maps_url character varying,
    store_logo_url character varying,
    default_currency character varying,
    timezone character varying,
    booking_page_url character varying,
    store_theme character varying,
    address character varying,
    store_ph character varying,
    operating_hours json,
    vacancy uuid,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: stores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stores_id_seq OWNED BY public.stores.id;


--
-- Name: support_tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.support_tickets (
    id bigint NOT NULL,
    ticket_id uuid,
    client_id uuid,
    subject character varying,
    description text,
    status character varying,
    assigned_to uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: support_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.support_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: support_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.support_tickets_id_seq OWNED BY public.support_tickets.id;


--
-- Name: timesheets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.timesheets (
    id bigint NOT NULL,
    timesheet_id uuid,
    assignment_id uuid,
    timesheet_date date,
    clock_in timestamp(6) without time zone,
    clock_out timestamp(6) without time zone,
    hours_worked numeric,
    late_clock_in boolean,
    overtime_hours numeric,
    early_checkout boolean,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: timesheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.timesheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: timesheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.timesheets_id_seq OWNED BY public.timesheets.id;


--
-- Name: transaction_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transaction_logs (
    id bigint NOT NULL,
    transaction_log_id uuid,
    appointment_id uuid,
    store_id uuid,
    transaction_id uuid,
    assignment_id uuid,
    updated_by uuid,
    revenue numeric,
    discount numeric,
    tax numeric,
    payment_method character varying,
    processed_date timestamp(6) without time zone,
    payment_status character varying,
    reason_for_change text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: transaction_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transaction_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transaction_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transaction_logs_id_seq OWNED BY public.transaction_logs.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id bigint NOT NULL,
    transaction_id uuid,
    store_id uuid,
    assignment_id uuid,
    appointment_id uuid,
    tip_amount numeric,
    promo_code character varying,
    transaction_note text,
    revenue numeric,
    discount numeric,
    tax numeric,
    payment_method character varying,
    payment_gateway_response text,
    processed_date timestamp(6) without time zone,
    invoice_id character varying,
    is_refunded boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: user_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_logs (
    id bigint NOT NULL,
    log_id uuid,
    user_id uuid,
    action_type character varying,
    table_name character varying,
    record_id character varying,
    old_value text,
    new_value text,
    store_id uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: user_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_logs_id_seq OWNED BY public.user_logs.id;


--
-- Name: user_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_permissions (
    id bigint NOT NULL,
    user_permission_id uuid,
    assignment_id uuid,
    permission_id uuid,
    permission_toggle boolean,
    granted_by uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_permissions_id_seq OWNED BY public.user_permissions.id;


--
-- Name: user_store_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_store_assignments (
    id bigint NOT NULL,
    assignment_id uuid,
    user_id uuid,
    store_id uuid,
    active boolean,
    role_name character varying,
    employment_type character varying,
    permissions json,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: user_store_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_store_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_store_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_store_assignments_id_seq OWNED BY public.user_store_assignments.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    user_id uuid,
    auth0_id character varying,
    name character varying,
    email character varying,
    phone_number character varying,
    is_verified boolean,
    multi_store_access boolean,
    image character varying,
    preferred_language character varying,
    last_login timestamp(6) without time zone,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vacancies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vacancies (
    id bigint NOT NULL,
    vacancy_id uuid,
    store_id uuid,
    skill_tags character varying,
    vacancy_name character varying,
    occupied boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: vacancies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vacancies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vacancies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vacancies_id_seq OWNED BY public.vacancies.id;


--
-- Name: vendors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.vendors (
    id bigint NOT NULL,
    vendor_id uuid,
    store_id uuid,
    vendor_type character varying,
    vendor_name character varying,
    contact_info character varying,
    notes text,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vendors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vendors_id_seq OWNED BY public.vendors.id;


--
-- Name: waitlists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.waitlists (
    id bigint NOT NULL,
    waitlist_id uuid,
    store_id uuid,
    assignment_id uuid,
    client_id uuid,
    service_id uuid,
    waitlist_position integer,
    notified_at timestamp(6) without time zone,
    waitlist_status character varying,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: waitlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.waitlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: waitlists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.waitlists_id_seq OWNED BY public.waitlists.id;


--
-- Name: walkin_queues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.walkin_queues (
    id bigint NOT NULL,
    queue_id uuid,
    store_id uuid,
    client_id uuid,
    service_id uuid,
    added_at timestamp(6) without time zone,
    status character varying,
    called_by uuid,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: walkin_queues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.walkin_queues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: walkin_queues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.walkin_queues_id_seq OWNED BY public.walkin_queues.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: inventory; Type: TABLE; Schema: store_management; Owner: -
--

CREATE TABLE store_management.inventory (
    inventory_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_id uuid NOT NULL,
    vendor_id uuid,
    product_category text,
    inventory_type text,
    product_image text,
    product_name text,
    inventory_description text,
    add_quantity integer,
    current_quantity integer,
    total_quantity integer,
    product_cost numeric,
    product_price numeric,
    expiration_date date,
    restock_date timestamp with time zone,
    suggested_restock_date timestamp with time zone,
    is_restocked boolean DEFAULT false,
    barcode text,
    threshold_quantity integer,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: inventory_alerts; Type: TABLE; Schema: store_management; Owner: -
--

CREATE TABLE store_management.inventory_alerts (
    alert_id uuid DEFAULT gen_random_uuid() NOT NULL,
    inventory_id uuid NOT NULL,
    alert_type text,
    suggested_action text,
    is_resolved boolean DEFAULT false,
    resolved_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: inventory_logs; Type: TABLE; Schema: store_management; Owner: -
--

CREATE TABLE store_management.inventory_logs (
    inventory_log_id uuid DEFAULT gen_random_uuid() NOT NULL,
    inventory_id uuid NOT NULL,
    appointment_id uuid,
    note text,
    quantity_changed integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: leave; Type: TABLE; Schema: store_management; Owner: -
--

CREATE TABLE store_management.leave (
    leave_id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    leave_type text,
    leave_date date,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    leave_reason text,
    leave_status text,
    approved boolean,
    approved_by uuid,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: services; Type: TABLE; Schema: store_management; Owner: -
--

CREATE TABLE store_management.services (
    service_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_id uuid NOT NULL,
    service_image text,
    service_name text,
    service_description text,
    price numeric,
    service_duration integer,
    is_featured boolean DEFAULT false,
    service_category text,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: shifts; Type: TABLE; Schema: store_management; Owner: -
--

CREATE TABLE store_management.shifts (
    shift_id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    shift_date date NOT NULL,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    break_start timestamp with time zone,
    break_end timestamp with time zone,
    days_off json,
    scheduled_by text,
    is_peak_shift boolean DEFAULT false,
    block_reason text,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: stores; Type: TABLE; Schema: store_management; Owner: -
--

CREATE TABLE store_management.stores (
    store_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_name text NOT NULL,
    store_type text,
    google_maps_url text,
    store_logo_url text,
    default_currency text,
    timezone text,
    booking_page_url text,
    store_theme text,
    address text,
    store_ph integer,
    operating_hours json,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    vacancy_id uuid
);


--
-- Name: timesheets; Type: TABLE; Schema: store_management; Owner: -
--

CREATE TABLE store_management.timesheets (
    timesheet_id uuid DEFAULT gen_random_uuid() NOT NULL,
    assignment_id uuid NOT NULL,
    timesheet_date date NOT NULL,
    clock_in timestamp with time zone,
    clock_out timestamp with time zone,
    hours_worked numeric,
    late_clock_in boolean,
    overtime_hours numeric,
    early_checkout boolean,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: vacancy; Type: TABLE; Schema: store_management; Owner: -
--

CREATE TABLE store_management.vacancy (
    vacancy_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_id uuid NOT NULL,
    skill_tags text,
    vacancy_name text,
    occupied boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    vacancy integer
);


--
-- Name: vendors; Type: TABLE; Schema: store_management; Owner: -
--

CREATE TABLE store_management.vendors (
    vendor_id uuid DEFAULT gen_random_uuid() NOT NULL,
    store_id uuid NOT NULL,
    vendor_type text,
    product_vendor text,
    contact_info text,
    notes text,
    deleted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: decrypted_secrets; Type: VIEW; Schema: vault; Owner: -
--

CREATE VIEW vault.decrypted_secrets AS
 SELECT secrets.id,
    secrets.name,
    secrets.description,
    secrets.secret,
        CASE
            WHEN (secrets.secret IS NULL) THEN NULL::text
            ELSE
            CASE
                WHEN (secrets.key_id IS NULL) THEN NULL::text
                ELSE convert_from(pgsodium.crypto_aead_det_decrypt(decode(secrets.secret, 'base64'::text), convert_to(((((secrets.id)::text || secrets.description) || (secrets.created_at)::text) || (secrets.updated_at)::text), 'utf8'::name), secrets.key_id, secrets.nonce), 'utf8'::name)
            END
        END AS decrypted_secret,
    secrets.key_id,
    secrets.nonce,
    secrets.created_at,
    secrets.updated_at
   FROM vault.secrets;


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: account_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_details ALTER COLUMN id SET DEFAULT nextval('public.account_details_id_seq'::regclass);


--
-- Name: appointment_add_ons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_add_ons ALTER COLUMN id SET DEFAULT nextval('public.appointment_add_ons_id_seq'::regclass);


--
-- Name: appointment_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_logs ALTER COLUMN id SET DEFAULT nextval('public.appointment_logs_id_seq'::regclass);


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: appt_insights id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appt_insights ALTER COLUMN id SET DEFAULT nextval('public.appt_insights_id_seq'::regclass);


--
-- Name: automated_msgs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automated_msgs ALTER COLUMN id SET DEFAULT nextval('public.automated_msgs_id_seq'::regclass);


--
-- Name: client_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_stats ALTER COLUMN id SET DEFAULT nextval('public.client_stats_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: global_clients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_clients ALTER COLUMN id SET DEFAULT nextval('public.global_clients_id_seq'::regclass);


--
-- Name: inventories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories ALTER COLUMN id SET DEFAULT nextval('public.inventories_id_seq'::regclass);


--
-- Name: inventory_alerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_alerts ALTER COLUMN id SET DEFAULT nextval('public.inventory_alerts_id_seq'::regclass);


--
-- Name: inventory_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_logs ALTER COLUMN id SET DEFAULT nextval('public.inventory_logs_id_seq'::regclass);


--
-- Name: leaves id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaves ALTER COLUMN id SET DEFAULT nextval('public.leaves_id_seq'::regclass);


--
-- Name: model_predictions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.model_predictions ALTER COLUMN id SET DEFAULT nextval('public.model_predictions_id_seq'::regclass);


--
-- Name: payrolls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payrolls ALTER COLUMN id SET DEFAULT nextval('public.payrolls_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: shifts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts ALTER COLUMN id SET DEFAULT nextval('public.shifts_id_seq'::regclass);


--
-- Name: staff_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_stats ALTER COLUMN id SET DEFAULT nextval('public.staff_stats_id_seq'::regclass);


--
-- Name: store_stats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store_stats ALTER COLUMN id SET DEFAULT nextval('public.store_stats_id_seq'::regclass);


--
-- Name: stores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores ALTER COLUMN id SET DEFAULT nextval('public.stores_id_seq'::regclass);


--
-- Name: support_tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_tickets ALTER COLUMN id SET DEFAULT nextval('public.support_tickets_id_seq'::regclass);


--
-- Name: timesheets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timesheets ALTER COLUMN id SET DEFAULT nextval('public.timesheets_id_seq'::regclass);


--
-- Name: transaction_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_logs ALTER COLUMN id SET DEFAULT nextval('public.transaction_logs_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: user_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_logs ALTER COLUMN id SET DEFAULT nextval('public.user_logs_id_seq'::regclass);


--
-- Name: user_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_permissions ALTER COLUMN id SET DEFAULT nextval('public.user_permissions_id_seq'::regclass);


--
-- Name: user_store_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_store_assignments ALTER COLUMN id SET DEFAULT nextval('public.user_store_assignments_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vacancies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vacancies ALTER COLUMN id SET DEFAULT nextval('public.vacancies_id_seq'::regclass);


--
-- Name: vendors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors ALTER COLUMN id SET DEFAULT nextval('public.vendors_id_seq'::regclass);


--
-- Name: waitlists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlists ALTER COLUMN id SET DEFAULT nextval('public.waitlists_id_seq'::regclass);


--
-- Name: walkin_queues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_queues ALTER COLUMN id SET DEFAULT nextval('public.walkin_queues_id_seq'::regclass);


--
-- Name: account_details account_details_pkey; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.account_details
    ADD CONSTRAINT account_details_pkey PRIMARY KEY (account_details_id);


--
-- Name: user_logs log_id_pkey; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.user_logs
    ADD CONSTRAINT log_id_pkey PRIMARY KEY (log_id);


--
-- Name: permissions permissions_permission_id_key; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.permissions
    ADD CONSTRAINT permissions_permission_id_key UNIQUE (permission_id);


--
-- Name: permissions permissions_permission_name_key; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.permissions
    ADD CONSTRAINT permissions_permission_name_key UNIQUE (permission_name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (permission_id);


--
-- Name: support_ticket support_ticket_pkey; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.support_ticket
    ADD CONSTRAINT support_ticket_pkey PRIMARY KEY (ticket_id);


--
-- Name: user_permissions user_permissions_pkey; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.user_permissions
    ADD CONSTRAINT user_permissions_pkey PRIMARY KEY (user_permission_id);


--
-- Name: user_store_assignment user_store_assignment_pkey; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.user_store_assignment
    ADD CONSTRAINT user_store_assignment_pkey PRIMARY KEY (assignment_id);


--
-- Name: users users_auth0_id_key; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.users
    ADD CONSTRAINT users_auth0_id_key UNIQUE (auth0_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: appointment_add_ons appointment_add_ons_pkey; Type: CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointment_add_ons
    ADD CONSTRAINT appointment_add_ons_pkey PRIMARY KEY (add_on_id);


--
-- Name: appointment_logs appointment_logs_pkey; Type: CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointment_logs
    ADD CONSTRAINT appointment_logs_pkey PRIMARY KEY (appt_log_id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (appt_id);


--
-- Name: appt_insight appt_insight_pkey; Type: CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appt_insight
    ADD CONSTRAINT appt_insight_pkey PRIMARY KEY (insight_id);


--
-- Name: waitlists waitlists_pkey; Type: CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.waitlists
    ADD CONSTRAINT waitlists_pkey PRIMARY KEY (waitlist_id);


--
-- Name: walkin_queue walkin_queue_pkey; Type: CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.walkin_queue
    ADD CONSTRAINT walkin_queue_pkey PRIMARY KEY (queue_id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: automated_msg automated_msg_pkey; Type: CONSTRAINT; Schema: clients; Owner: -
--

ALTER TABLE ONLY clients.automated_msg
    ADD CONSTRAINT automated_msg_pkey PRIMARY KEY (msg_id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: clients; Owner: -
--

ALTER TABLE ONLY clients.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (client_id);


--
-- Name: global_clients global_clients_client_email_key; Type: CONSTRAINT; Schema: clients; Owner: -
--

ALTER TABLE ONLY clients.global_clients
    ADD CONSTRAINT global_clients_client_email_key UNIQUE (client_email);


--
-- Name: global_clients global_clients_pkey; Type: CONSTRAINT; Schema: clients; Owner: -
--

ALTER TABLE ONLY clients.global_clients
    ADD CONSTRAINT global_clients_pkey PRIMARY KEY (global_client_id);


--
-- Name: payroll payroll_pkey; Type: CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.payroll
    ADD CONSTRAINT payroll_pkey PRIMARY KEY (payroll_id);


--
-- Name: transaction_log transaction_log_pkey; Type: CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.transaction_log
    ADD CONSTRAINT transaction_log_pkey PRIMARY KEY (transaction_log_id);


--
-- Name: transaction transaction_pkey; Type: CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (transaction_id);


--
-- Name: client_stats client_stats_pkey; Type: CONSTRAINT; Schema: growth; Owner: -
--

ALTER TABLE ONLY growth.client_stats
    ADD CONSTRAINT client_stats_pkey PRIMARY KEY (client_stats_id);


--
-- Name: model_predictions model_predictions_pkey; Type: CONSTRAINT; Schema: growth; Owner: -
--

ALTER TABLE ONLY growth.model_predictions
    ADD CONSTRAINT model_predictions_pkey PRIMARY KEY (prediction_id);


--
-- Name: staff_stats staff_stats_pkey; Type: CONSTRAINT; Schema: growth; Owner: -
--

ALTER TABLE ONLY growth.staff_stats
    ADD CONSTRAINT staff_stats_pkey PRIMARY KEY (staff_stats_id);


--
-- Name: store_stats store_stats_pkey; Type: CONSTRAINT; Schema: growth; Owner: -
--

ALTER TABLE ONLY growth.store_stats
    ADD CONSTRAINT store_stats_pkey PRIMARY KEY (store_stats_id);


--
-- Name: account_details account_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.account_details
    ADD CONSTRAINT account_details_pkey PRIMARY KEY (id);


--
-- Name: appointment_add_ons appointment_add_ons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_add_ons
    ADD CONSTRAINT appointment_add_ons_pkey PRIMARY KEY (id);


--
-- Name: appointment_logs appointment_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointment_logs
    ADD CONSTRAINT appointment_logs_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: appt_insights appt_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appt_insights
    ADD CONSTRAINT appt_insights_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: automated_msgs automated_msgs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.automated_msgs
    ADD CONSTRAINT automated_msgs_pkey PRIMARY KEY (id);


--
-- Name: client_stats client_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_stats
    ADD CONSTRAINT client_stats_pkey PRIMARY KEY (id);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: global_clients global_clients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.global_clients
    ADD CONSTRAINT global_clients_pkey PRIMARY KEY (id);


--
-- Name: inventories inventories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventories
    ADD CONSTRAINT inventories_pkey PRIMARY KEY (id);


--
-- Name: inventory_alerts inventory_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_alerts
    ADD CONSTRAINT inventory_alerts_pkey PRIMARY KEY (id);


--
-- Name: inventory_logs inventory_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_logs
    ADD CONSTRAINT inventory_logs_pkey PRIMARY KEY (id);


--
-- Name: leaves leaves_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leaves
    ADD CONSTRAINT leaves_pkey PRIMARY KEY (id);


--
-- Name: model_predictions model_predictions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.model_predictions
    ADD CONSTRAINT model_predictions_pkey PRIMARY KEY (id);


--
-- Name: payrolls payrolls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payrolls
    ADD CONSTRAINT payrolls_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (id);


--
-- Name: staff_stats staff_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staff_stats
    ADD CONSTRAINT staff_stats_pkey PRIMARY KEY (id);


--
-- Name: store_stats store_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.store_stats
    ADD CONSTRAINT store_stats_pkey PRIMARY KEY (id);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (id);


--
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (id);


--
-- Name: timesheets timesheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.timesheets
    ADD CONSTRAINT timesheets_pkey PRIMARY KEY (id);


--
-- Name: transaction_logs transaction_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_logs
    ADD CONSTRAINT transaction_logs_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: user_logs user_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_logs
    ADD CONSTRAINT user_logs_pkey PRIMARY KEY (id);


--
-- Name: user_permissions user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_permissions
    ADD CONSTRAINT user_permissions_pkey PRIMARY KEY (id);


--
-- Name: user_store_assignments user_store_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_store_assignments
    ADD CONSTRAINT user_store_assignments_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vacancies vacancies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vacancies
    ADD CONSTRAINT vacancies_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: waitlists waitlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.waitlists
    ADD CONSTRAINT waitlists_pkey PRIMARY KEY (id);


--
-- Name: walkin_queues walkin_queues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.walkin_queues
    ADD CONSTRAINT walkin_queues_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: inventory_alerts inventory_alerts_pkey; Type: CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.inventory_alerts
    ADD CONSTRAINT inventory_alerts_pkey PRIMARY KEY (alert_id);


--
-- Name: inventory_logs inventory_logs_pkey; Type: CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.inventory_logs
    ADD CONSTRAINT inventory_logs_pkey PRIMARY KEY (inventory_log_id);


--
-- Name: inventory inventory_pkey; Type: CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.inventory
    ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id);


--
-- Name: leave leave_pkey; Type: CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.leave
    ADD CONSTRAINT leave_pkey PRIMARY KEY (leave_id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (service_id);


--
-- Name: shifts shifts_pkey; Type: CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.shifts
    ADD CONSTRAINT shifts_pkey PRIMARY KEY (shift_id);


--
-- Name: stores stores_pkey; Type: CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.stores
    ADD CONSTRAINT stores_pkey PRIMARY KEY (store_id);


--
-- Name: timesheets timesheets_pkey; Type: CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.timesheets
    ADD CONSTRAINT timesheets_pkey PRIMARY KEY (timesheet_id);


--
-- Name: vacancy vacancy_pkey; Type: CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.vacancy
    ADD CONSTRAINT vacancy_pkey PRIMARY KEY (vacancy_id);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (vendor_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: account_details account_details_store_id_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.account_details
    ADD CONSTRAINT account_details_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: account_details account_details_user_id_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.account_details
    ADD CONSTRAINT account_details_user_id_fkey FOREIGN KEY (user_id) REFERENCES access_control.users(user_id) ON DELETE CASCADE;


--
-- Name: user_logs log_id_store_id_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.user_logs
    ADD CONSTRAINT log_id_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: user_logs log_id_user_id_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.user_logs
    ADD CONSTRAINT log_id_user_id_fkey FOREIGN KEY (user_id) REFERENCES access_control.users(user_id) ON DELETE CASCADE;


--
-- Name: support_ticket support_ticket_assigned_to_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.support_ticket
    ADD CONSTRAINT support_ticket_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES access_control.users(user_id) ON DELETE SET NULL;


--
-- Name: support_ticket support_ticket_client_id_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.support_ticket
    ADD CONSTRAINT support_ticket_client_id_fkey FOREIGN KEY (client_id) REFERENCES clients.clients(client_id) ON DELETE CASCADE;


--
-- Name: support_ticket support_ticket_user_id_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.support_ticket
    ADD CONSTRAINT support_ticket_user_id_fkey FOREIGN KEY (user_id) REFERENCES access_control.users(user_id) ON DELETE CASCADE;


--
-- Name: user_permissions user_permissions_assignment_id_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.user_permissions
    ADD CONSTRAINT user_permissions_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: user_permissions user_permissions_granted_by_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.user_permissions
    ADD CONSTRAINT user_permissions_granted_by_fkey FOREIGN KEY (granted_by) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: user_permissions user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.user_permissions
    ADD CONSTRAINT user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES access_control.permissions(permission_id) ON DELETE CASCADE;


--
-- Name: user_store_assignment user_store_assignment_store_id_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.user_store_assignment
    ADD CONSTRAINT user_store_assignment_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: user_store_assignment user_store_assignment_user_id_fkey; Type: FK CONSTRAINT; Schema: access_control; Owner: -
--

ALTER TABLE ONLY access_control.user_store_assignment
    ADD CONSTRAINT user_store_assignment_user_id_fkey FOREIGN KEY (user_id) REFERENCES access_control.users(user_id) ON DELETE CASCADE;


--
-- Name: appointment_add_ons appointment_add_ons_appointment_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointment_add_ons
    ADD CONSTRAINT appointment_add_ons_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES appointments.appointments(appt_id) ON DELETE CASCADE;


--
-- Name: appointment_add_ons appointment_add_ons_inventory_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointment_add_ons
    ADD CONSTRAINT appointment_add_ons_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES store_management.inventory(inventory_id) ON DELETE CASCADE;


--
-- Name: appointment_logs appointment_logs_assignment_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointment_logs
    ADD CONSTRAINT appointment_logs_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: appointment_logs appointment_logs_change_by_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointment_logs
    ADD CONSTRAINT appointment_logs_change_by_fkey FOREIGN KEY (change_by) REFERENCES access_control.users(user_id) ON DELETE SET NULL;


--
-- Name: appointment_logs appointment_logs_client_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointment_logs
    ADD CONSTRAINT appointment_logs_client_id_fkey FOREIGN KEY (client_id) REFERENCES clients.clients(client_id) ON DELETE CASCADE;


--
-- Name: appointment_logs appointment_logs_service_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointment_logs
    ADD CONSTRAINT appointment_logs_service_id_fkey FOREIGN KEY (service_id) REFERENCES store_management.services(service_id) ON DELETE CASCADE;


--
-- Name: appointment_logs appointment_logs_store_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointment_logs
    ADD CONSTRAINT appointment_logs_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: appointment_logs appointment_logs_vacancy_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointment_logs
    ADD CONSTRAINT appointment_logs_vacancy_id_fkey FOREIGN KEY (vacancy_id) REFERENCES store_management.vacancy(vacancy_id) ON DELETE CASCADE;


--
-- Name: appointments appointments_assignment_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointments
    ADD CONSTRAINT appointments_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: appointments appointments_client_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointments
    ADD CONSTRAINT appointments_client_id_fkey FOREIGN KEY (client_id) REFERENCES clients.clients(client_id) ON DELETE CASCADE;


--
-- Name: appointments appointments_service_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointments
    ADD CONSTRAINT appointments_service_id_fkey FOREIGN KEY (service_id) REFERENCES store_management.services(service_id) ON DELETE CASCADE;


--
-- Name: appointments appointments_store_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointments
    ADD CONSTRAINT appointments_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: appointments appointments_vacancy_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appointments
    ADD CONSTRAINT appointments_vacancy_id_fkey FOREIGN KEY (vacancy_id) REFERENCES store_management.vacancy(vacancy_id) ON DELETE CASCADE;


--
-- Name: appt_insight appt_insight_appt_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.appt_insight
    ADD CONSTRAINT appt_insight_appt_id_fkey FOREIGN KEY (appt_id) REFERENCES appointments.appointments(appt_id) ON DELETE SET NULL;


--
-- Name: waitlists waitlists_assignment_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.waitlists
    ADD CONSTRAINT waitlists_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: waitlists waitlists_client_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.waitlists
    ADD CONSTRAINT waitlists_client_id_fkey FOREIGN KEY (client_id) REFERENCES clients.clients(client_id) ON DELETE CASCADE;


--
-- Name: waitlists waitlists_service_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.waitlists
    ADD CONSTRAINT waitlists_service_id_fkey FOREIGN KEY (service_id) REFERENCES store_management.services(service_id) ON DELETE CASCADE;


--
-- Name: waitlists waitlists_store_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.waitlists
    ADD CONSTRAINT waitlists_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: walkin_queue walkin_queue_called_by_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.walkin_queue
    ADD CONSTRAINT walkin_queue_called_by_fkey FOREIGN KEY (called_by) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE SET NULL;


--
-- Name: walkin_queue walkin_queue_client_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.walkin_queue
    ADD CONSTRAINT walkin_queue_client_id_fkey FOREIGN KEY (client_id) REFERENCES clients.clients(client_id) ON DELETE CASCADE;


--
-- Name: walkin_queue walkin_queue_service_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.walkin_queue
    ADD CONSTRAINT walkin_queue_service_id_fkey FOREIGN KEY (service_id) REFERENCES store_management.services(service_id) ON DELETE CASCADE;


--
-- Name: walkin_queue walkin_queue_store_id_fkey; Type: FK CONSTRAINT; Schema: appointments; Owner: -
--

ALTER TABLE ONLY appointments.walkin_queue
    ADD CONSTRAINT walkin_queue_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: automated_msg automated_msg_assignment_id_fkey; Type: FK CONSTRAINT; Schema: clients; Owner: -
--

ALTER TABLE ONLY clients.automated_msg
    ADD CONSTRAINT automated_msg_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: clients clients_global_client_id_fkey; Type: FK CONSTRAINT; Schema: clients; Owner: -
--

ALTER TABLE ONLY clients.clients
    ADD CONSTRAINT clients_global_client_id_fkey FOREIGN KEY (global_client_id) REFERENCES clients.global_clients(global_client_id) ON DELETE CASCADE;


--
-- Name: clients clients_store_id_fkey; Type: FK CONSTRAINT; Schema: clients; Owner: -
--

ALTER TABLE ONLY clients.clients
    ADD CONSTRAINT clients_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: payroll payroll_approved_by_fkey; Type: FK CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.payroll
    ADD CONSTRAINT payroll_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES access_control.users(user_id) ON DELETE SET NULL;


--
-- Name: payroll payroll_assignment_id_fkey; Type: FK CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.payroll
    ADD CONSTRAINT payroll_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: transaction transaction_appointment_id_fkey; Type: FK CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.transaction
    ADD CONSTRAINT transaction_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES appointments.appointments(appt_id) ON DELETE SET NULL;


--
-- Name: transaction transaction_assignment_id_fkey; Type: FK CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.transaction
    ADD CONSTRAINT transaction_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: transaction_log transaction_log_appointment_id_fkey; Type: FK CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.transaction_log
    ADD CONSTRAINT transaction_log_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES appointments.appointments(appt_id) ON DELETE CASCADE;


--
-- Name: transaction_log transaction_log_assignment_id_fkey; Type: FK CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.transaction_log
    ADD CONSTRAINT transaction_log_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: transaction_log transaction_log_store_id_fkey; Type: FK CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.transaction_log
    ADD CONSTRAINT transaction_log_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: transaction_log transaction_log_transaction_id_fkey; Type: FK CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.transaction_log
    ADD CONSTRAINT transaction_log_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES financials.transaction(transaction_id) ON DELETE CASCADE;


--
-- Name: transaction_log transaction_log_updated_by_fkey; Type: FK CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.transaction_log
    ADD CONSTRAINT transaction_log_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES access_control.users(user_id) ON DELETE SET NULL;


--
-- Name: transaction transaction_store_id_fkey; Type: FK CONSTRAINT; Schema: financials; Owner: -
--

ALTER TABLE ONLY financials.transaction
    ADD CONSTRAINT transaction_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: client_stats client_stats_client_id_fkey; Type: FK CONSTRAINT; Schema: growth; Owner: -
--

ALTER TABLE ONLY growth.client_stats
    ADD CONSTRAINT client_stats_client_id_fkey FOREIGN KEY (client_id) REFERENCES clients.clients(client_id) ON DELETE CASCADE;


--
-- Name: client_stats client_stats_store_id_fkey; Type: FK CONSTRAINT; Schema: growth; Owner: -
--

ALTER TABLE ONLY growth.client_stats
    ADD CONSTRAINT client_stats_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: staff_stats staff_stats_assignment_id_fkey; Type: FK CONSTRAINT; Schema: growth; Owner: -
--

ALTER TABLE ONLY growth.staff_stats
    ADD CONSTRAINT staff_stats_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: store_stats store_stats_store_id_fkey; Type: FK CONSTRAINT; Schema: growth; Owner: -
--

ALTER TABLE ONLY growth.store_stats
    ADD CONSTRAINT store_stats_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: inventory_alerts inventory_alerts_inventory_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.inventory_alerts
    ADD CONSTRAINT inventory_alerts_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES store_management.inventory(inventory_id) ON DELETE CASCADE;


--
-- Name: inventory_logs inventory_logs_inventory_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.inventory_logs
    ADD CONSTRAINT inventory_logs_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES store_management.inventory(inventory_id) ON DELETE CASCADE;


--
-- Name: inventory inventory_store_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.inventory
    ADD CONSTRAINT inventory_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: inventory inventory_vendor_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.inventory
    ADD CONSTRAINT inventory_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES store_management.vendors(vendor_id) ON DELETE SET NULL;


--
-- Name: leave leave_assignment_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.leave
    ADD CONSTRAINT leave_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: services services_store_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.services
    ADD CONSTRAINT services_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: shifts shifts_assignment_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.shifts
    ADD CONSTRAINT shifts_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: stores stores_vacancy_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.stores
    ADD CONSTRAINT stores_vacancy_id_fkey FOREIGN KEY (vacancy_id) REFERENCES store_management.vacancy(vacancy_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: timesheets timesheets_assignment_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.timesheets
    ADD CONSTRAINT timesheets_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES access_control.user_store_assignment(assignment_id) ON DELETE CASCADE;


--
-- Name: vacancy vacancy_store_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.vacancy
    ADD CONSTRAINT vacancy_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: vendors vendors_store_id_fkey; Type: FK CONSTRAINT; Schema: store_management; Owner: -
--

ALTER TABLE ONLY store_management.vendors
    ADD CONSTRAINT vendors_store_id_fkey FOREIGN KEY (store_id) REFERENCES store_management.stores(store_id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

SET search_path TO "\$user", public, extensions;

INSERT INTO "schema_migrations" (version) VALUES
('20250324235853'),
('20250324235837'),
('20250324235820'),
('20250324235803'),
('20250324235747'),
('20250324235730'),
('20250324235713'),
('20250324235653'),
('20250324235638'),
('20250324235625'),
('20250324235608'),
('20250324235553'),
('20250324235539'),
('20250324235524'),
('20250324235506'),
('20250324235301'),
('20250324235239'),
('20250324235220'),
('20250324235206'),
('20250324235150'),
('20250324235132'),
('20250324235113'),
('20250324235056'),
('20250324235037'),
('20250324235016'),
('20250324234959'),
('20250324234944'),
('20250324234929'),
('20250324234913'),
('20250324234857'),
('20250324234841'),
('20250324234827'),
('20250324234811');

