--
-- PostgreSQL database dump
--

\restrict JHLYfThxcVJFgz4UATyoRO5MsqUkid93fqw8rdoo8Gt2IHrX16Pu1FDWpO5CmdX

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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
-- Name: gen_random_uuid_v7(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.gen_random_uuid_v7() RETURNS uuid
    LANGUAGE plpgsql
    AS $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$;


ALTER FUNCTION public.gen_random_uuid_v7() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty (
    id bigint NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    "maxLoad" bigint,
    "employmentStatus" text,
    "shiftPreference" text,
    "preferredHours" text,
    "facultyId" text NOT NULL,
    "userInfoId" bigint NOT NULL,
    program text,
    "isActive" boolean NOT NULL,
    "currentLoad" double precision,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.faculty OWNER TO postgres;

--
-- Name: faculty_availability; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty_availability (
    id bigint NOT NULL,
    "facultyId" bigint NOT NULL,
    "dayOfWeek" text NOT NULL,
    "startTime" text NOT NULL,
    "endTime" text NOT NULL,
    "isPreferred" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.faculty_availability OWNER TO postgres;

--
-- Name: faculty_availability_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_availability_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_availability_id_seq OWNER TO postgres;

--
-- Name: faculty_availability_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_availability_id_seq OWNED BY public.faculty_availability.id;


--
-- Name: faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_id_seq OWNER TO postgres;

--
-- Name: faculty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_id_seq OWNED BY public.faculty.id;


--
-- Name: room; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.room (
    id bigint NOT NULL,
    name text NOT NULL,
    capacity bigint NOT NULL,
    type text NOT NULL,
    program text NOT NULL,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.room OWNER TO postgres;

--
-- Name: room_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.room_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.room_id_seq OWNER TO postgres;

--
-- Name: room_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.room_id_seq OWNED BY public.room.id;


--
-- Name: schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schedule (
    id bigint NOT NULL,
    "subjectId" bigint NOT NULL,
    "facultyId" bigint NOT NULL,
    "roomId" bigint,
    "timeslotId" bigint,
    section text NOT NULL,
    "sectionId" bigint,
    "loadTypes" json,
    units double precision,
    hours double precision,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.schedule OWNER TO postgres;

--
-- Name: schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schedule_id_seq OWNER TO postgres;

--
-- Name: schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.schedule_id_seq OWNED BY public.schedule.id;


--
-- Name: section; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.section (
    id bigint NOT NULL,
    program text NOT NULL,
    "yearLevel" bigint NOT NULL,
    "sectionCode" text NOT NULL,
    "academicYear" text NOT NULL,
    semester bigint NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.section OWNER TO postgres;

--
-- Name: section_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.section_id_seq OWNER TO postgres;

--
-- Name: section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.section_id_seq OWNED BY public.section.id;


--
-- Name: serverpod_auth_core_jwt_refresh_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_core_jwt_refresh_token (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "extraClaims" text,
    method text NOT NULL,
    "fixedSecret" bytea NOT NULL,
    "rotatingSecretHash" text CONSTRAINT "serverpod_auth_core_jwt_refresh_tok_rotatingSecretHash_not_null" NOT NULL,
    "lastUpdatedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.serverpod_auth_core_jwt_refresh_token OWNER TO postgres;

--
-- Name: serverpod_auth_core_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_core_profile (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "userName" text,
    "fullName" text,
    email text,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "imageId" uuid
);


ALTER TABLE public.serverpod_auth_core_profile OWNER TO postgres;

--
-- Name: serverpod_auth_core_profile_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_core_profile_image (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "userProfileId" uuid NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "storageId" text NOT NULL,
    path text NOT NULL,
    url text NOT NULL
);


ALTER TABLE public.serverpod_auth_core_profile_image OWNER TO postgres;

--
-- Name: serverpod_auth_core_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_core_session (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "scopeNames" json NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "lastUsedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "expiresAt" timestamp without time zone,
    "expireAfterUnusedFor" bigint,
    "sessionKeyHash" bytea NOT NULL,
    "sessionKeySalt" bytea NOT NULL,
    method text NOT NULL
);


ALTER TABLE public.serverpod_auth_core_session OWNER TO postgres;

--
-- Name: serverpod_auth_core_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_core_user (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "scopeNames" json NOT NULL,
    blocked boolean NOT NULL
);


ALTER TABLE public.serverpod_auth_core_user OWNER TO postgres;

--
-- Name: serverpod_auth_idp_apple_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_apple_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "userIdentifier" text NOT NULL,
    "refreshToken" text NOT NULL,
    "refreshTokenRequestedWithBundleIdentifier" boolean CONSTRAINT "serverpod_auth_idp_apple_ac_refreshTokenRequestedWithB_not_null" NOT NULL,
    "lastRefreshedAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    email text,
    "isEmailVerified" boolean,
    "isPrivateEmail" boolean,
    "firstName" text,
    "lastName" text
);


ALTER TABLE public.serverpod_auth_idp_apple_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_email_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_email_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    email text NOT NULL,
    "passwordHash" text NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_email_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_email_account_password_reset_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_email_account_password_reset_request (
    id uuid DEFAULT public.gen_random_uuid_v7() CONSTRAINT serverpod_auth_idp_email_account_password_reset_req_id_not_null NOT NULL,
    "emailAccountId" uuid CONSTRAINT "serverpod_auth_idp_email_account_passwo_emailAccountId_not_null" NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP CONSTRAINT "serverpod_auth_idp_email_account_password_re_createdAt_not_null" NOT NULL,
    "challengeId" uuid CONSTRAINT "serverpod_auth_idp_email_account_password__challengeId_not_null" NOT NULL,
    "setPasswordChallengeId" uuid
);


ALTER TABLE public.serverpod_auth_idp_email_account_password_reset_request OWNER TO postgres;

--
-- Name: serverpod_auth_idp_email_account_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_email_account_request (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "createdAt" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email text NOT NULL,
    "challengeId" uuid NOT NULL,
    "createAccountChallengeId" uuid
);


ALTER TABLE public.serverpod_auth_idp_email_account_request OWNER TO postgres;

--
-- Name: serverpod_auth_idp_firebase_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_firebase_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    created timestamp without time zone NOT NULL,
    email text,
    phone text,
    "userIdentifier" text NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_firebase_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_google_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_google_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    created timestamp without time zone NOT NULL,
    email text NOT NULL,
    "userIdentifier" text NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_google_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_passkey_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_passkey_account (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "authUserId" uuid NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "keyId" bytea NOT NULL,
    "keyIdBase64" text NOT NULL,
    "clientDataJSON" bytea NOT NULL,
    "attestationObject" bytea NOT NULL,
    "originalChallenge" bytea NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_passkey_account OWNER TO postgres;

--
-- Name: serverpod_auth_idp_passkey_challenge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_passkey_challenge (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    challenge bytea NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_passkey_challenge OWNER TO postgres;

--
-- Name: serverpod_auth_idp_rate_limited_request_attempt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_rate_limited_request_attempt (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    domain text NOT NULL,
    source text NOT NULL,
    nonce text NOT NULL,
    "ipAddress" text,
    "attemptedAt" timestamp without time zone CONSTRAINT "serverpod_auth_idp_rate_limited_request_at_attemptedAt_not_null" NOT NULL,
    "extraData" json
);


ALTER TABLE public.serverpod_auth_idp_rate_limited_request_attempt OWNER TO postgres;

--
-- Name: serverpod_auth_idp_secret_challenge; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_idp_secret_challenge (
    id uuid DEFAULT public.gen_random_uuid_v7() NOT NULL,
    "challengeCodeHash" text NOT NULL
);


ALTER TABLE public.serverpod_auth_idp_secret_challenge OWNER TO postgres;

--
-- Name: serverpod_auth_key; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_auth_key (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    hash text NOT NULL,
    "scopeNames" json NOT NULL,
    method text NOT NULL
);


ALTER TABLE public.serverpod_auth_key OWNER TO postgres;

--
-- Name: serverpod_auth_key_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_auth_key_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_auth_key_id_seq OWNER TO postgres;

--
-- Name: serverpod_auth_key_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_auth_key_id_seq OWNED BY public.serverpod_auth_key.id;


--
-- Name: serverpod_cloud_storage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_cloud_storage (
    id bigint NOT NULL,
    "storageId" text NOT NULL,
    path text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    expiration timestamp without time zone,
    "byteData" bytea NOT NULL,
    verified boolean NOT NULL
);


ALTER TABLE public.serverpod_cloud_storage OWNER TO postgres;

--
-- Name: serverpod_cloud_storage_direct_upload; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_cloud_storage_direct_upload (
    id bigint NOT NULL,
    "storageId" text NOT NULL,
    path text NOT NULL,
    expiration timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);


ALTER TABLE public.serverpod_cloud_storage_direct_upload OWNER TO postgres;

--
-- Name: serverpod_cloud_storage_direct_upload_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_cloud_storage_direct_upload_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_cloud_storage_direct_upload_id_seq OWNER TO postgres;

--
-- Name: serverpod_cloud_storage_direct_upload_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_cloud_storage_direct_upload_id_seq OWNED BY public.serverpod_cloud_storage_direct_upload.id;


--
-- Name: serverpod_cloud_storage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_cloud_storage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_cloud_storage_id_seq OWNER TO postgres;

--
-- Name: serverpod_cloud_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_cloud_storage_id_seq OWNED BY public.serverpod_cloud_storage.id;


--
-- Name: serverpod_email_auth; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_email_auth (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    email text NOT NULL,
    hash text NOT NULL
);


ALTER TABLE public.serverpod_email_auth OWNER TO postgres;

--
-- Name: serverpod_email_auth_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_email_auth_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_email_auth_id_seq OWNER TO postgres;

--
-- Name: serverpod_email_auth_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_email_auth_id_seq OWNED BY public.serverpod_email_auth.id;


--
-- Name: serverpod_email_create_request; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_email_create_request (
    id bigint NOT NULL,
    "userName" text NOT NULL,
    email text NOT NULL,
    hash text NOT NULL,
    "verificationCode" text NOT NULL
);


ALTER TABLE public.serverpod_email_create_request OWNER TO postgres;

--
-- Name: serverpod_email_create_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_email_create_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_email_create_request_id_seq OWNER TO postgres;

--
-- Name: serverpod_email_create_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_email_create_request_id_seq OWNED BY public.serverpod_email_create_request.id;


--
-- Name: serverpod_email_failed_sign_in; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_email_failed_sign_in (
    id bigint NOT NULL,
    email text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);


ALTER TABLE public.serverpod_email_failed_sign_in OWNER TO postgres;

--
-- Name: serverpod_email_failed_sign_in_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_email_failed_sign_in_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_email_failed_sign_in_id_seq OWNER TO postgres;

--
-- Name: serverpod_email_failed_sign_in_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_email_failed_sign_in_id_seq OWNED BY public.serverpod_email_failed_sign_in.id;


--
-- Name: serverpod_email_reset; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_email_reset (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "verificationCode" text NOT NULL,
    expiration timestamp without time zone NOT NULL
);


ALTER TABLE public.serverpod_email_reset OWNER TO postgres;

--
-- Name: serverpod_email_reset_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_email_reset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_email_reset_id_seq OWNER TO postgres;

--
-- Name: serverpod_email_reset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_email_reset_id_seq OWNED BY public.serverpod_email_reset.id;


--
-- Name: serverpod_future_call; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_future_call (
    id bigint NOT NULL,
    name text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    identifier text
);


ALTER TABLE public.serverpod_future_call OWNER TO postgres;

--
-- Name: serverpod_future_call_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_future_call_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_future_call_id_seq OWNER TO postgres;

--
-- Name: serverpod_future_call_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_future_call_id_seq OWNED BY public.serverpod_future_call.id;


--
-- Name: serverpod_google_refresh_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_google_refresh_token (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    "refreshToken" text NOT NULL
);


ALTER TABLE public.serverpod_google_refresh_token OWNER TO postgres;

--
-- Name: serverpod_google_refresh_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_google_refresh_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_google_refresh_token_id_seq OWNER TO postgres;

--
-- Name: serverpod_google_refresh_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_google_refresh_token_id_seq OWNED BY public.serverpod_google_refresh_token.id;


--
-- Name: serverpod_health_connection_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_health_connection_info (
    id bigint NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    active bigint NOT NULL,
    closing bigint NOT NULL,
    idle bigint NOT NULL,
    granularity bigint NOT NULL
);


ALTER TABLE public.serverpod_health_connection_info OWNER TO postgres;

--
-- Name: serverpod_health_connection_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_health_connection_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_health_connection_info_id_seq OWNER TO postgres;

--
-- Name: serverpod_health_connection_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_health_connection_info_id_seq OWNED BY public.serverpod_health_connection_info.id;


--
-- Name: serverpod_health_metric; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_health_metric (
    id bigint NOT NULL,
    name text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    value double precision NOT NULL,
    granularity bigint NOT NULL
);


ALTER TABLE public.serverpod_health_metric OWNER TO postgres;

--
-- Name: serverpod_health_metric_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_health_metric_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_health_metric_id_seq OWNER TO postgres;

--
-- Name: serverpod_health_metric_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_health_metric_id_seq OWNED BY public.serverpod_health_metric.id;


--
-- Name: serverpod_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_log (
    id bigint NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    reference text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    message text NOT NULL,
    error text,
    "stackTrace" text,
    "order" bigint NOT NULL
);


ALTER TABLE public.serverpod_log OWNER TO postgres;

--
-- Name: serverpod_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_log_id_seq OWNER TO postgres;

--
-- Name: serverpod_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_log_id_seq OWNED BY public.serverpod_log.id;


--
-- Name: serverpod_message_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_message_log (
    id bigint NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    endpoint text NOT NULL,
    "messageName" text NOT NULL,
    duration double precision NOT NULL,
    error text,
    "stackTrace" text,
    slow boolean NOT NULL,
    "order" bigint NOT NULL
);


ALTER TABLE public.serverpod_message_log OWNER TO postgres;

--
-- Name: serverpod_message_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_message_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_message_log_id_seq OWNER TO postgres;

--
-- Name: serverpod_message_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_message_log_id_seq OWNED BY public.serverpod_message_log.id;


--
-- Name: serverpod_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_method (
    id bigint NOT NULL,
    endpoint text NOT NULL,
    method text NOT NULL
);


ALTER TABLE public.serverpod_method OWNER TO postgres;

--
-- Name: serverpod_method_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_method_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_method_id_seq OWNER TO postgres;

--
-- Name: serverpod_method_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_method_id_seq OWNED BY public.serverpod_method.id;


--
-- Name: serverpod_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_migrations (
    id bigint NOT NULL,
    module text NOT NULL,
    version text NOT NULL,
    "timestamp" timestamp without time zone
);


ALTER TABLE public.serverpod_migrations OWNER TO postgres;

--
-- Name: serverpod_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_migrations_id_seq OWNER TO postgres;

--
-- Name: serverpod_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_migrations_id_seq OWNED BY public.serverpod_migrations.id;


--
-- Name: serverpod_query_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_query_log (
    id bigint NOT NULL,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    query text NOT NULL,
    duration double precision NOT NULL,
    "numRows" bigint,
    error text,
    "stackTrace" text,
    slow boolean NOT NULL,
    "order" bigint NOT NULL
);


ALTER TABLE public.serverpod_query_log OWNER TO postgres;

--
-- Name: serverpod_query_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_query_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_query_log_id_seq OWNER TO postgres;

--
-- Name: serverpod_query_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_query_log_id_seq OWNED BY public.serverpod_query_log.id;


--
-- Name: serverpod_readwrite_test; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_readwrite_test (
    id bigint NOT NULL,
    number bigint NOT NULL
);


ALTER TABLE public.serverpod_readwrite_test OWNER TO postgres;

--
-- Name: serverpod_readwrite_test_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_readwrite_test_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_readwrite_test_id_seq OWNER TO postgres;

--
-- Name: serverpod_readwrite_test_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_readwrite_test_id_seq OWNED BY public.serverpod_readwrite_test.id;


--
-- Name: serverpod_runtime_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_runtime_settings (
    id bigint NOT NULL,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);


ALTER TABLE public.serverpod_runtime_settings OWNER TO postgres;

--
-- Name: serverpod_runtime_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_runtime_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_runtime_settings_id_seq OWNER TO postgres;

--
-- Name: serverpod_runtime_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_runtime_settings_id_seq OWNED BY public.serverpod_runtime_settings.id;


--
-- Name: serverpod_session_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_session_log (
    id bigint NOT NULL,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    module text,
    endpoint text,
    method text,
    duration double precision,
    "numQueries" bigint,
    slow boolean,
    error text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "userId" text,
    "isOpen" boolean,
    touched timestamp without time zone NOT NULL
);


ALTER TABLE public.serverpod_session_log OWNER TO postgres;

--
-- Name: serverpod_session_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_session_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_session_log_id_seq OWNER TO postgres;

--
-- Name: serverpod_session_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_session_log_id_seq OWNED BY public.serverpod_session_log.id;


--
-- Name: serverpod_user_image; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_user_image (
    id bigint NOT NULL,
    "userId" bigint NOT NULL,
    version bigint NOT NULL,
    url text NOT NULL
);


ALTER TABLE public.serverpod_user_image OWNER TO postgres;

--
-- Name: serverpod_user_image_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_user_image_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_user_image_id_seq OWNER TO postgres;

--
-- Name: serverpod_user_image_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_user_image_id_seq OWNED BY public.serverpod_user_image.id;


--
-- Name: serverpod_user_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.serverpod_user_info (
    id bigint NOT NULL,
    "userIdentifier" text NOT NULL,
    "userName" text,
    "fullName" text,
    email text,
    created timestamp without time zone NOT NULL,
    "imageUrl" text,
    "scopeNames" json NOT NULL,
    blocked boolean NOT NULL
);


ALTER TABLE public.serverpod_user_info OWNER TO postgres;

--
-- Name: serverpod_user_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.serverpod_user_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.serverpod_user_info_id_seq OWNER TO postgres;

--
-- Name: serverpod_user_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.serverpod_user_info_id_seq OWNED BY public.serverpod_user_info.id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    id bigint NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    "studentNumber" text NOT NULL,
    course text NOT NULL,
    "yearLevel" bigint NOT NULL,
    section text,
    "sectionId" bigint,
    "userInfoId" bigint NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_id_seq OWNER TO postgres;

--
-- Name: student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_id_seq OWNED BY public.student.id;


--
-- Name: subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject (
    id bigint NOT NULL,
    code text NOT NULL,
    name text NOT NULL,
    units bigint NOT NULL,
    hours double precision,
    "yearLevel" bigint,
    term bigint,
    types json NOT NULL,
    program text NOT NULL,
    "studentsCount" bigint NOT NULL,
    "isActive" boolean DEFAULT true NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.subject OWNER TO postgres;

--
-- Name: subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subject_id_seq OWNER TO postgres;

--
-- Name: subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subject_id_seq OWNED BY public.subject.id;


--
-- Name: timeslot; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.timeslot (
    id bigint NOT NULL,
    day text NOT NULL,
    "startTime" text NOT NULL,
    "endTime" text NOT NULL,
    label text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


ALTER TABLE public.timeslot OWNER TO postgres;

--
-- Name: timeslot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.timeslot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.timeslot_id_seq OWNER TO postgres;

--
-- Name: timeslot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.timeslot_id_seq OWNED BY public.timeslot.id;


--
-- Name: user_role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_role (
    id bigint NOT NULL,
    "userId" text NOT NULL,
    role text NOT NULL
);


ALTER TABLE public.user_role OWNER TO postgres;

--
-- Name: user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_role_id_seq OWNER TO postgres;

--
-- Name: user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_role_id_seq OWNED BY public.user_role.id;


--
-- Name: faculty id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty ALTER COLUMN id SET DEFAULT nextval('public.faculty_id_seq'::regclass);


--
-- Name: faculty_availability id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_availability ALTER COLUMN id SET DEFAULT nextval('public.faculty_availability_id_seq'::regclass);


--
-- Name: room id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room ALTER COLUMN id SET DEFAULT nextval('public.room_id_seq'::regclass);


--
-- Name: schedule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule ALTER COLUMN id SET DEFAULT nextval('public.schedule_id_seq'::regclass);


--
-- Name: section id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section ALTER COLUMN id SET DEFAULT nextval('public.section_id_seq'::regclass);


--
-- Name: serverpod_auth_key id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_key ALTER COLUMN id SET DEFAULT nextval('public.serverpod_auth_key_id_seq'::regclass);


--
-- Name: serverpod_cloud_storage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_cloud_storage ALTER COLUMN id SET DEFAULT nextval('public.serverpod_cloud_storage_id_seq'::regclass);


--
-- Name: serverpod_cloud_storage_direct_upload id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_cloud_storage_direct_upload ALTER COLUMN id SET DEFAULT nextval('public.serverpod_cloud_storage_direct_upload_id_seq'::regclass);


--
-- Name: serverpod_email_auth id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_email_auth ALTER COLUMN id SET DEFAULT nextval('public.serverpod_email_auth_id_seq'::regclass);


--
-- Name: serverpod_email_create_request id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_email_create_request ALTER COLUMN id SET DEFAULT nextval('public.serverpod_email_create_request_id_seq'::regclass);


--
-- Name: serverpod_email_failed_sign_in id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_email_failed_sign_in ALTER COLUMN id SET DEFAULT nextval('public.serverpod_email_failed_sign_in_id_seq'::regclass);


--
-- Name: serverpod_email_reset id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_email_reset ALTER COLUMN id SET DEFAULT nextval('public.serverpod_email_reset_id_seq'::regclass);


--
-- Name: serverpod_future_call id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_future_call ALTER COLUMN id SET DEFAULT nextval('public.serverpod_future_call_id_seq'::regclass);


--
-- Name: serverpod_google_refresh_token id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_google_refresh_token ALTER COLUMN id SET DEFAULT nextval('public.serverpod_google_refresh_token_id_seq'::regclass);


--
-- Name: serverpod_health_connection_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_health_connection_info ALTER COLUMN id SET DEFAULT nextval('public.serverpod_health_connection_info_id_seq'::regclass);


--
-- Name: serverpod_health_metric id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_health_metric ALTER COLUMN id SET DEFAULT nextval('public.serverpod_health_metric_id_seq'::regclass);


--
-- Name: serverpod_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_log ALTER COLUMN id SET DEFAULT nextval('public.serverpod_log_id_seq'::regclass);


--
-- Name: serverpod_message_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_message_log ALTER COLUMN id SET DEFAULT nextval('public.serverpod_message_log_id_seq'::regclass);


--
-- Name: serverpod_method id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_method ALTER COLUMN id SET DEFAULT nextval('public.serverpod_method_id_seq'::regclass);


--
-- Name: serverpod_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_migrations ALTER COLUMN id SET DEFAULT nextval('public.serverpod_migrations_id_seq'::regclass);


--
-- Name: serverpod_query_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_query_log ALTER COLUMN id SET DEFAULT nextval('public.serverpod_query_log_id_seq'::regclass);


--
-- Name: serverpod_readwrite_test id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_readwrite_test ALTER COLUMN id SET DEFAULT nextval('public.serverpod_readwrite_test_id_seq'::regclass);


--
-- Name: serverpod_runtime_settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_runtime_settings ALTER COLUMN id SET DEFAULT nextval('public.serverpod_runtime_settings_id_seq'::regclass);


--
-- Name: serverpod_session_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_session_log ALTER COLUMN id SET DEFAULT nextval('public.serverpod_session_log_id_seq'::regclass);


--
-- Name: serverpod_user_image id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_user_image ALTER COLUMN id SET DEFAULT nextval('public.serverpod_user_image_id_seq'::regclass);


--
-- Name: serverpod_user_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_user_info ALTER COLUMN id SET DEFAULT nextval('public.serverpod_user_info_id_seq'::regclass);


--
-- Name: student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_id_seq'::regclass);


--
-- Name: subject id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject ALTER COLUMN id SET DEFAULT nextval('public.subject_id_seq'::regclass);


--
-- Name: timeslot id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timeslot ALTER COLUMN id SET DEFAULT nextval('public.timeslot_id_seq'::regclass);


--
-- Name: user_role id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role ALTER COLUMN id SET DEFAULT nextval('public.user_role_id_seq'::regclass);


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty (id, name, email, "maxLoad", "employmentStatus", "shiftPreference", "preferredHours", "facultyId", "userInfoId", program, "isActive", "currentLoad", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: faculty_availability; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty_availability (id, "facultyId", "dayOfWeek", "startTime", "endTime", "isPreferred", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: room; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.room (id, name, capacity, type, program, "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schedule (id, "subjectId", "facultyId", "roomId", "timeslotId", section, "sectionId", "loadTypes", units, hours, "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: section; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.section (id, program, "yearLevel", "sectionCode", "academicYear", semester, "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_core_jwt_refresh_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_core_jwt_refresh_token (id, "authUserId", "scopeNames", "extraClaims", method, "fixedSecret", "rotatingSecretHash", "lastUpdatedAt", "createdAt") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_core_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_core_profile (id, "authUserId", "userName", "fullName", email, "createdAt", "imageId") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_core_profile_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_core_profile_image (id, "userProfileId", "createdAt", "storageId", path, url) FROM stdin;
\.


--
-- Data for Name: serverpod_auth_core_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_core_session (id, "authUserId", "scopeNames", "createdAt", "lastUsedAt", "expiresAt", "expireAfterUnusedFor", "sessionKeyHash", "sessionKeySalt", method) FROM stdin;
\.


--
-- Data for Name: serverpod_auth_core_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_core_user (id, "createdAt", "scopeNames", blocked) FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_apple_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_apple_account (id, "userIdentifier", "refreshToken", "refreshTokenRequestedWithBundleIdentifier", "lastRefreshedAt", "authUserId", "createdAt", email, "isEmailVerified", "isPrivateEmail", "firstName", "lastName") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_email_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_email_account (id, "authUserId", "createdAt", email, "passwordHash") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_email_account_password_reset_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_email_account_password_reset_request (id, "emailAccountId", "createdAt", "challengeId", "setPasswordChallengeId") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_email_account_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_email_account_request (id, "createdAt", email, "challengeId", "createAccountChallengeId") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_firebase_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_firebase_account (id, "authUserId", created, email, phone, "userIdentifier") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_google_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_google_account (id, "authUserId", created, email, "userIdentifier") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_passkey_account; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_passkey_account (id, "authUserId", "createdAt", "keyId", "keyIdBase64", "clientDataJSON", "attestationObject", "originalChallenge") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_passkey_challenge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_passkey_challenge (id, "createdAt", challenge) FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_rate_limited_request_attempt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_rate_limited_request_attempt (id, domain, source, nonce, "ipAddress", "attemptedAt", "extraData") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_idp_secret_challenge; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_idp_secret_challenge (id, "challengeCodeHash") FROM stdin;
\.


--
-- Data for Name: serverpod_auth_key; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_auth_key (id, "userId", hash, "scopeNames", method) FROM stdin;
\.


--
-- Data for Name: serverpod_cloud_storage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_cloud_storage (id, "storageId", path, "addedTime", expiration, "byteData", verified) FROM stdin;
\.


--
-- Data for Name: serverpod_cloud_storage_direct_upload; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_cloud_storage_direct_upload (id, "storageId", path, expiration, "authKey") FROM stdin;
\.


--
-- Data for Name: serverpod_email_auth; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_email_auth (id, "userId", email, hash) FROM stdin;
\.


--
-- Data for Name: serverpod_email_create_request; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_email_create_request (id, "userName", email, hash, "verificationCode") FROM stdin;
\.


--
-- Data for Name: serverpod_email_failed_sign_in; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_email_failed_sign_in (id, email, "time", "ipAddress") FROM stdin;
\.


--
-- Data for Name: serverpod_email_reset; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_email_reset (id, "userId", "verificationCode", expiration) FROM stdin;
\.


--
-- Data for Name: serverpod_future_call; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_future_call (id, name, "time", "serializedObject", "serverId", identifier) FROM stdin;
\.


--
-- Data for Name: serverpod_google_refresh_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_google_refresh_token (id, "userId", "refreshToken") FROM stdin;
\.


--
-- Data for Name: serverpod_health_connection_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_health_connection_info (id, "serverId", "timestamp", active, closing, idle, granularity) FROM stdin;
\.


--
-- Data for Name: serverpod_health_metric; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_health_metric (id, name, "serverId", "timestamp", "isHealthy", value, granularity) FROM stdin;
\.


--
-- Data for Name: serverpod_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_log (id, "sessionLogId", "messageId", reference, "serverId", "time", "logLevel", message, error, "stackTrace", "order") FROM stdin;
\.


--
-- Data for Name: serverpod_message_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_message_log (id, "sessionLogId", "serverId", "messageId", endpoint, "messageName", duration, error, "stackTrace", slow, "order") FROM stdin;
\.


--
-- Data for Name: serverpod_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_method (id, endpoint, method) FROM stdin;
\.


--
-- Data for Name: serverpod_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_migrations (id, module, version, "timestamp") FROM stdin;
1	citesched	20260304094738576	2026-03-04 18:06:09.241383
2	serverpod	20251208110333922-v3-0-0	2026-03-04 18:06:09.241383
3	serverpod_auth_idp	20260109031533194	2026-03-04 18:06:09.241383
4	serverpod_auth	20250825102351908-v3-0-0	2026-03-04 18:06:09.241383
5	serverpod_auth_core	20251208110412389-v3-0-0	2026-03-04 18:06:09.241383
\.


--
-- Data for Name: serverpod_query_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_query_log (id, "serverId", "sessionLogId", "messageId", query, duration, "numRows", error, "stackTrace", slow, "order") FROM stdin;
\.


--
-- Data for Name: serverpod_readwrite_test; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_readwrite_test (id, number) FROM stdin;
\.


--
-- Data for Name: serverpod_runtime_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_runtime_settings (id, "logSettings", "logSettingsOverrides", "logServiceCalls", "logMalformedCalls") FROM stdin;
\.


--
-- Data for Name: serverpod_session_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_session_log (id, "serverId", "time", module, endpoint, method, duration, "numQueries", slow, error, "stackTrace", "authenticatedUserId", "userId", "isOpen", touched) FROM stdin;
\.


--
-- Data for Name: serverpod_user_image; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_user_image (id, "userId", version, url) FROM stdin;
\.


--
-- Data for Name: serverpod_user_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.serverpod_user_info (id, "userIdentifier", "userName", "fullName", email, created, "imageUrl", "scopeNames", blocked) FROM stdin;
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (id, name, email, "studentNumber", course, "yearLevel", section, "sectionId", "userInfoId", "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: subject; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subject (id, code, name, units, hours, "yearLevel", term, types, program, "studentsCount", "isActive", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: timeslot; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.timeslot (id, day, "startTime", "endTime", label, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: user_role; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_role (id, "userId", role) FROM stdin;
\.


--
-- Name: faculty_availability_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_availability_id_seq', 1, false);


--
-- Name: faculty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_id_seq', 1, false);


--
-- Name: room_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.room_id_seq', 1, false);


--
-- Name: schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.schedule_id_seq', 1, false);


--
-- Name: section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.section_id_seq', 1, false);


--
-- Name: serverpod_auth_key_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_auth_key_id_seq', 1, false);


--
-- Name: serverpod_cloud_storage_direct_upload_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_cloud_storage_direct_upload_id_seq', 1, false);


--
-- Name: serverpod_cloud_storage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_cloud_storage_id_seq', 1, false);


--
-- Name: serverpod_email_auth_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_email_auth_id_seq', 1, false);


--
-- Name: serverpod_email_create_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_email_create_request_id_seq', 1, false);


--
-- Name: serverpod_email_failed_sign_in_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_email_failed_sign_in_id_seq', 1, false);


--
-- Name: serverpod_email_reset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_email_reset_id_seq', 1, false);


--
-- Name: serverpod_future_call_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_future_call_id_seq', 1, false);


--
-- Name: serverpod_google_refresh_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_google_refresh_token_id_seq', 1, false);


--
-- Name: serverpod_health_connection_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_health_connection_info_id_seq', 1, false);


--
-- Name: serverpod_health_metric_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_health_metric_id_seq', 1, false);


--
-- Name: serverpod_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_log_id_seq', 1, false);


--
-- Name: serverpod_message_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_message_log_id_seq', 1, false);


--
-- Name: serverpod_method_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_method_id_seq', 1, false);


--
-- Name: serverpod_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_migrations_id_seq', 5, true);


--
-- Name: serverpod_query_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_query_log_id_seq', 1, false);


--
-- Name: serverpod_readwrite_test_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_readwrite_test_id_seq', 1, false);


--
-- Name: serverpod_runtime_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_runtime_settings_id_seq', 1, false);


--
-- Name: serverpod_session_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_session_log_id_seq', 1, false);


--
-- Name: serverpod_user_image_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_user_image_id_seq', 1, false);


--
-- Name: serverpod_user_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.serverpod_user_info_id_seq', 1, false);


--
-- Name: student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_id_seq', 1, false);


--
-- Name: subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subject_id_seq', 1, false);


--
-- Name: timeslot_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.timeslot_id_seq', 1, false);


--
-- Name: user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_role_id_seq', 1, false);


--
-- Name: faculty_availability faculty_availability_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_availability
    ADD CONSTRAINT faculty_availability_pkey PRIMARY KEY (id);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (id);


--
-- Name: room room_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.room
    ADD CONSTRAINT room_pkey PRIMARY KEY (id);


--
-- Name: schedule schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id);


--
-- Name: section section_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section
    ADD CONSTRAINT section_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_core_jwt_refresh_token serverpod_auth_core_jwt_refresh_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_jwt_refresh_token
    ADD CONSTRAINT serverpod_auth_core_jwt_refresh_token_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_core_profile_image serverpod_auth_core_profile_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_profile_image
    ADD CONSTRAINT serverpod_auth_core_profile_image_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_core_profile serverpod_auth_core_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_profile
    ADD CONSTRAINT serverpod_auth_core_profile_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_core_session serverpod_auth_core_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_session
    ADD CONSTRAINT serverpod_auth_core_session_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_core_user serverpod_auth_core_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_user
    ADD CONSTRAINT serverpod_auth_core_user_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_apple_account serverpod_auth_idp_apple_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_apple_account
    ADD CONSTRAINT serverpod_auth_idp_apple_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_email_account_password_reset_request serverpod_auth_idp_email_account_password_reset_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_password_reset_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_password_reset_request_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_email_account serverpod_auth_idp_email_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account
    ADD CONSTRAINT serverpod_auth_idp_email_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_email_account_request serverpod_auth_idp_email_account_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_request_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_firebase_account serverpod_auth_idp_firebase_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_firebase_account
    ADD CONSTRAINT serverpod_auth_idp_firebase_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_google_account serverpod_auth_idp_google_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_google_account
    ADD CONSTRAINT serverpod_auth_idp_google_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_passkey_account serverpod_auth_idp_passkey_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_passkey_account
    ADD CONSTRAINT serverpod_auth_idp_passkey_account_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_passkey_challenge serverpod_auth_idp_passkey_challenge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_passkey_challenge
    ADD CONSTRAINT serverpod_auth_idp_passkey_challenge_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_rate_limited_request_attempt serverpod_auth_idp_rate_limited_request_attempt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_rate_limited_request_attempt
    ADD CONSTRAINT serverpod_auth_idp_rate_limited_request_attempt_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_idp_secret_challenge serverpod_auth_idp_secret_challenge_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_secret_challenge
    ADD CONSTRAINT serverpod_auth_idp_secret_challenge_pkey PRIMARY KEY (id);


--
-- Name: serverpod_auth_key serverpod_auth_key_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_key
    ADD CONSTRAINT serverpod_auth_key_pkey PRIMARY KEY (id);


--
-- Name: serverpod_cloud_storage_direct_upload serverpod_cloud_storage_direct_upload_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_cloud_storage_direct_upload
    ADD CONSTRAINT serverpod_cloud_storage_direct_upload_pkey PRIMARY KEY (id);


--
-- Name: serverpod_cloud_storage serverpod_cloud_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_cloud_storage
    ADD CONSTRAINT serverpod_cloud_storage_pkey PRIMARY KEY (id);


--
-- Name: serverpod_email_auth serverpod_email_auth_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_email_auth
    ADD CONSTRAINT serverpod_email_auth_pkey PRIMARY KEY (id);


--
-- Name: serverpod_email_create_request serverpod_email_create_request_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_email_create_request
    ADD CONSTRAINT serverpod_email_create_request_pkey PRIMARY KEY (id);


--
-- Name: serverpod_email_failed_sign_in serverpod_email_failed_sign_in_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_email_failed_sign_in
    ADD CONSTRAINT serverpod_email_failed_sign_in_pkey PRIMARY KEY (id);


--
-- Name: serverpod_email_reset serverpod_email_reset_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_email_reset
    ADD CONSTRAINT serverpod_email_reset_pkey PRIMARY KEY (id);


--
-- Name: serverpod_future_call serverpod_future_call_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_future_call
    ADD CONSTRAINT serverpod_future_call_pkey PRIMARY KEY (id);


--
-- Name: serverpod_google_refresh_token serverpod_google_refresh_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_google_refresh_token
    ADD CONSTRAINT serverpod_google_refresh_token_pkey PRIMARY KEY (id);


--
-- Name: serverpod_health_connection_info serverpod_health_connection_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_health_connection_info
    ADD CONSTRAINT serverpod_health_connection_info_pkey PRIMARY KEY (id);


--
-- Name: serverpod_health_metric serverpod_health_metric_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_health_metric
    ADD CONSTRAINT serverpod_health_metric_pkey PRIMARY KEY (id);


--
-- Name: serverpod_log serverpod_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_log
    ADD CONSTRAINT serverpod_log_pkey PRIMARY KEY (id);


--
-- Name: serverpod_message_log serverpod_message_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_message_log
    ADD CONSTRAINT serverpod_message_log_pkey PRIMARY KEY (id);


--
-- Name: serverpod_method serverpod_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_method
    ADD CONSTRAINT serverpod_method_pkey PRIMARY KEY (id);


--
-- Name: serverpod_migrations serverpod_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_migrations
    ADD CONSTRAINT serverpod_migrations_pkey PRIMARY KEY (id);


--
-- Name: serverpod_query_log serverpod_query_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_query_log
    ADD CONSTRAINT serverpod_query_log_pkey PRIMARY KEY (id);


--
-- Name: serverpod_readwrite_test serverpod_readwrite_test_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_readwrite_test
    ADD CONSTRAINT serverpod_readwrite_test_pkey PRIMARY KEY (id);


--
-- Name: serverpod_runtime_settings serverpod_runtime_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_runtime_settings
    ADD CONSTRAINT serverpod_runtime_settings_pkey PRIMARY KEY (id);


--
-- Name: serverpod_session_log serverpod_session_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_session_log
    ADD CONSTRAINT serverpod_session_log_pkey PRIMARY KEY (id);


--
-- Name: serverpod_user_image serverpod_user_image_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_user_image
    ADD CONSTRAINT serverpod_user_image_pkey PRIMARY KEY (id);


--
-- Name: serverpod_user_info serverpod_user_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_user_info
    ADD CONSTRAINT serverpod_user_info_pkey PRIMARY KEY (id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- Name: subject subject_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pkey PRIMARY KEY (id);


--
-- Name: timeslot timeslot_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timeslot
    ADD CONSTRAINT timeslot_pkey PRIMARY KEY (id);


--
-- Name: user_role user_role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (id);


--
-- Name: faculty_email_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX faculty_email_unique_idx ON public.faculty USING btree (email);


--
-- Name: faculty_id_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX faculty_id_unique_idx ON public.faculty USING btree ("facultyId");


--
-- Name: room_name_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX room_name_unique_idx ON public.room USING btree (name);


--
-- Name: section_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX section_unique_idx ON public.section USING btree (program, "yearLevel", "sectionCode", "academicYear", semester);


--
-- Name: serverpod_auth_apple_account_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_apple_account_identifier ON public.serverpod_auth_idp_apple_account USING btree ("userIdentifier");


--
-- Name: serverpod_auth_core_jwt_refresh_token_last_updated_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_auth_core_jwt_refresh_token_last_updated_at ON public.serverpod_auth_core_jwt_refresh_token USING btree ("lastUpdatedAt");


--
-- Name: serverpod_auth_firebase_account_user_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_firebase_account_user_identifier ON public.serverpod_auth_idp_firebase_account USING btree ("userIdentifier");


--
-- Name: serverpod_auth_google_account_user_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_google_account_user_identifier ON public.serverpod_auth_idp_google_account USING btree ("userIdentifier");


--
-- Name: serverpod_auth_idp_email_account_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_idp_email_account_email ON public.serverpod_auth_idp_email_account USING btree (email);


--
-- Name: serverpod_auth_idp_email_account_request_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_idp_email_account_request_email ON public.serverpod_auth_idp_email_account_request USING btree (email);


--
-- Name: serverpod_auth_idp_passkey_account_key_id_base64; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_idp_passkey_account_key_id_base64 ON public.serverpod_auth_idp_passkey_account USING btree ("keyIdBase64");


--
-- Name: serverpod_auth_idp_rate_limited_request_attempt_composite; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_auth_idp_rate_limited_request_attempt_composite ON public.serverpod_auth_idp_rate_limited_request_attempt USING btree (domain, source, nonce, "attemptedAt");


--
-- Name: serverpod_auth_key_userId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "serverpod_auth_key_userId_idx" ON public.serverpod_auth_key USING btree ("userId");


--
-- Name: serverpod_auth_profile_user_profile_email_auth_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_auth_profile_user_profile_email_auth_user_id ON public.serverpod_auth_core_profile USING btree ("authUserId");


--
-- Name: serverpod_cloud_storage_direct_upload_storage_path; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_cloud_storage_direct_upload_storage_path ON public.serverpod_cloud_storage_direct_upload USING btree ("storageId", path);


--
-- Name: serverpod_cloud_storage_expiration; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_cloud_storage_expiration ON public.serverpod_cloud_storage USING btree (expiration);


--
-- Name: serverpod_cloud_storage_path_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_cloud_storage_path_idx ON public.serverpod_cloud_storage USING btree ("storageId", path);


--
-- Name: serverpod_email_auth_create_account_request_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_email_auth_create_account_request_idx ON public.serverpod_email_create_request USING btree (email);


--
-- Name: serverpod_email_auth_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_email_auth_email ON public.serverpod_email_auth USING btree (email);


--
-- Name: serverpod_email_failed_sign_in_email_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_email_failed_sign_in_email_idx ON public.serverpod_email_failed_sign_in USING btree (email);


--
-- Name: serverpod_email_failed_sign_in_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_email_failed_sign_in_time_idx ON public.serverpod_email_failed_sign_in USING btree ("time");


--
-- Name: serverpod_email_reset_verification_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_email_reset_verification_idx ON public.serverpod_email_reset USING btree ("verificationCode");


--
-- Name: serverpod_future_call_identifier_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_future_call_identifier_idx ON public.serverpod_future_call USING btree (identifier);


--
-- Name: serverpod_future_call_serverId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "serverpod_future_call_serverId_idx" ON public.serverpod_future_call USING btree ("serverId");


--
-- Name: serverpod_future_call_time_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_future_call_time_idx ON public.serverpod_future_call USING btree ("time");


--
-- Name: serverpod_google_refresh_token_userId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX "serverpod_google_refresh_token_userId_idx" ON public.serverpod_google_refresh_token USING btree ("userId");


--
-- Name: serverpod_health_connection_info_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_health_connection_info_timestamp_idx ON public.serverpod_health_connection_info USING btree ("timestamp", "serverId", granularity);


--
-- Name: serverpod_health_metric_timestamp_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_health_metric_timestamp_idx ON public.serverpod_health_metric USING btree ("timestamp", "serverId", name, granularity);


--
-- Name: serverpod_log_sessionLogId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "serverpod_log_sessionLogId_idx" ON public.serverpod_log USING btree ("sessionLogId");


--
-- Name: serverpod_method_endpoint_method_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_method_endpoint_method_idx ON public.serverpod_method USING btree (endpoint, method);


--
-- Name: serverpod_migrations_ids; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_migrations_ids ON public.serverpod_migrations USING btree (module);


--
-- Name: serverpod_query_log_sessionLogId_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON public.serverpod_query_log USING btree ("sessionLogId");


--
-- Name: serverpod_session_log_isopen_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_session_log_isopen_idx ON public.serverpod_session_log USING btree ("isOpen");


--
-- Name: serverpod_session_log_serverid_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_session_log_serverid_idx ON public.serverpod_session_log USING btree ("serverId");


--
-- Name: serverpod_session_log_touched_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_session_log_touched_idx ON public.serverpod_session_log USING btree (touched);


--
-- Name: serverpod_user_image_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_user_image_user_id ON public.serverpod_user_image USING btree ("userId", version);


--
-- Name: serverpod_user_info_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX serverpod_user_info_email ON public.serverpod_user_info USING btree (email);


--
-- Name: serverpod_user_info_user_identifier; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX serverpod_user_info_user_identifier ON public.serverpod_user_info USING btree ("userIdentifier");


--
-- Name: student_email_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX student_email_unique_idx ON public.student USING btree (email);


--
-- Name: student_number_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX student_number_unique_idx ON public.student USING btree ("studentNumber");


--
-- Name: user_role_user_id_unique_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX user_role_user_id_unique_idx ON public.user_role USING btree ("userId");


--
-- Name: faculty_availability faculty_availability_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_availability
    ADD CONSTRAINT faculty_availability_fk_0 FOREIGN KEY ("facultyId") REFERENCES public.faculty(id);


--
-- Name: schedule schedule_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_fk_0 FOREIGN KEY ("subjectId") REFERENCES public.subject(id);


--
-- Name: schedule schedule_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_fk_1 FOREIGN KEY ("facultyId") REFERENCES public.faculty(id);


--
-- Name: schedule schedule_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_fk_2 FOREIGN KEY ("roomId") REFERENCES public.room(id);


--
-- Name: schedule schedule_fk_3; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_fk_3 FOREIGN KEY ("timeslotId") REFERENCES public.timeslot(id);


--
-- Name: schedule schedule_fk_4; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_fk_4 FOREIGN KEY ("sectionId") REFERENCES public.section(id);


--
-- Name: serverpod_auth_core_jwt_refresh_token serverpod_auth_core_jwt_refresh_token_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_jwt_refresh_token
    ADD CONSTRAINT serverpod_auth_core_jwt_refresh_token_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_core_profile serverpod_auth_core_profile_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_profile
    ADD CONSTRAINT serverpod_auth_core_profile_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_core_profile serverpod_auth_core_profile_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_profile
    ADD CONSTRAINT serverpod_auth_core_profile_fk_1 FOREIGN KEY ("imageId") REFERENCES public.serverpod_auth_core_profile_image(id);


--
-- Name: serverpod_auth_core_profile_image serverpod_auth_core_profile_image_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_profile_image
    ADD CONSTRAINT serverpod_auth_core_profile_image_fk_0 FOREIGN KEY ("userProfileId") REFERENCES public.serverpod_auth_core_profile(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_core_session serverpod_auth_core_session_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_core_session
    ADD CONSTRAINT serverpod_auth_core_session_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_apple_account serverpod_auth_idp_apple_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_apple_account
    ADD CONSTRAINT serverpod_auth_idp_apple_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account serverpod_auth_idp_email_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account
    ADD CONSTRAINT serverpod_auth_idp_email_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account_password_reset_request serverpod_auth_idp_email_account_password_reset_request_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_password_reset_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_password_reset_request_fk_0 FOREIGN KEY ("emailAccountId") REFERENCES public.serverpod_auth_idp_email_account(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account_password_reset_request serverpod_auth_idp_email_account_password_reset_request_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_password_reset_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_password_reset_request_fk_1 FOREIGN KEY ("challengeId") REFERENCES public.serverpod_auth_idp_secret_challenge(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account_password_reset_request serverpod_auth_idp_email_account_password_reset_request_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_password_reset_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_password_reset_request_fk_2 FOREIGN KEY ("setPasswordChallengeId") REFERENCES public.serverpod_auth_idp_secret_challenge(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account_request serverpod_auth_idp_email_account_request_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_request_fk_0 FOREIGN KEY ("challengeId") REFERENCES public.serverpod_auth_idp_secret_challenge(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_email_account_request serverpod_auth_idp_email_account_request_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_email_account_request
    ADD CONSTRAINT serverpod_auth_idp_email_account_request_fk_1 FOREIGN KEY ("createAccountChallengeId") REFERENCES public.serverpod_auth_idp_secret_challenge(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_firebase_account serverpod_auth_idp_firebase_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_firebase_account
    ADD CONSTRAINT serverpod_auth_idp_firebase_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_google_account serverpod_auth_idp_google_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_google_account
    ADD CONSTRAINT serverpod_auth_idp_google_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_auth_idp_passkey_account serverpod_auth_idp_passkey_account_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_auth_idp_passkey_account
    ADD CONSTRAINT serverpod_auth_idp_passkey_account_fk_0 FOREIGN KEY ("authUserId") REFERENCES public.serverpod_auth_core_user(id) ON DELETE CASCADE;


--
-- Name: serverpod_log serverpod_log_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_log
    ADD CONSTRAINT serverpod_log_fk_0 FOREIGN KEY ("sessionLogId") REFERENCES public.serverpod_session_log(id) ON DELETE CASCADE;


--
-- Name: serverpod_message_log serverpod_message_log_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_message_log
    ADD CONSTRAINT serverpod_message_log_fk_0 FOREIGN KEY ("sessionLogId") REFERENCES public.serverpod_session_log(id) ON DELETE CASCADE;


--
-- Name: serverpod_query_log serverpod_query_log_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.serverpod_query_log
    ADD CONSTRAINT serverpod_query_log_fk_0 FOREIGN KEY ("sessionLogId") REFERENCES public.serverpod_session_log(id) ON DELETE CASCADE;


--
-- Name: student student_fk_0; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_fk_0 FOREIGN KEY ("sectionId") REFERENCES public.section(id);


--
-- PostgreSQL database dump complete
--

\unrestrict JHLYfThxcVJFgz4UATyoRO5MsqUkid93fqw8rdoo8Gt2IHrX16Pu1FDWpO5CmdX

