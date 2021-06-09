--
-- PostgreSQL database dump
--

-- Dumped from database version 11.11
-- Dumped by pg_dump version 11.11

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: assetindexdata; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.assetindexdata (
    id integer NOT NULL,
    "sessionId" character varying(36) DEFAULT ''::character varying NOT NULL,
    "volumeId" integer NOT NULL,
    uri text,
    size bigint,
    "timestamp" timestamp(0) without time zone,
    "recordId" integer,
    "inProgress" boolean DEFAULT false,
    completed boolean DEFAULT false,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.assetindexdata OWNER TO skyviewer;

--
-- Name: assetindexdata_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.assetindexdata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assetindexdata_id_seq OWNER TO skyviewer;

--
-- Name: assetindexdata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.assetindexdata_id_seq OWNED BY public.assetindexdata.id;


--
-- Name: assets; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.assets (
    id integer NOT NULL,
    "volumeId" integer,
    "folderId" integer NOT NULL,
    "uploaderId" integer,
    filename character varying(255) NOT NULL,
    kind character varying(50) DEFAULT 'unknown'::character varying NOT NULL,
    width integer,
    height integer,
    size bigint,
    "focalPoint" character varying(13) DEFAULT NULL::character varying,
    "deletedWithVolume" boolean,
    "keptFile" boolean,
    "dateModified" timestamp(0) without time zone,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.assets OWNER TO skyviewer;

--
-- Name: assettransformindex; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.assettransformindex (
    id integer NOT NULL,
    "assetId" integer NOT NULL,
    filename character varying(255),
    format character varying(255),
    location character varying(255) NOT NULL,
    "volumeId" integer,
    "fileExists" boolean DEFAULT false NOT NULL,
    "inProgress" boolean DEFAULT false NOT NULL,
    error boolean DEFAULT false NOT NULL,
    "dateIndexed" timestamp(0) without time zone,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.assettransformindex OWNER TO skyviewer;

--
-- Name: assettransformindex_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.assettransformindex_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assettransformindex_id_seq OWNER TO skyviewer;

--
-- Name: assettransformindex_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.assettransformindex_id_seq OWNED BY public.assettransformindex.id;


--
-- Name: assettransforms; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.assettransforms (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    mode character varying(255) DEFAULT 'crop'::character varying NOT NULL,
    "position" character varying(255) DEFAULT 'center-center'::character varying NOT NULL,
    width integer,
    height integer,
    format character varying(255),
    quality integer,
    interlace character varying(255) DEFAULT 'none'::character varying NOT NULL,
    "dimensionChangeTime" timestamp(0) without time zone,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    CONSTRAINT assettransforms_interlace_check CHECK (((interlace)::text = ANY ((ARRAY['none'::character varying, 'line'::character varying, 'plane'::character varying, 'partition'::character varying])::text[]))),
    CONSTRAINT assettransforms_mode_check CHECK (((mode)::text = ANY ((ARRAY['stretch'::character varying, 'fit'::character varying, 'crop'::character varying])::text[]))),
    CONSTRAINT assettransforms_position_check CHECK ((("position")::text = ANY ((ARRAY['top-left'::character varying, 'top-center'::character varying, 'top-right'::character varying, 'center-left'::character varying, 'center-center'::character varying, 'center-right'::character varying, 'bottom-left'::character varying, 'bottom-center'::character varying, 'bottom-right'::character varying])::text[])))
);


ALTER TABLE public.assettransforms OWNER TO skyviewer;

--
-- Name: assettransforms_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.assettransforms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assettransforms_id_seq OWNER TO skyviewer;

--
-- Name: assettransforms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.assettransforms_id_seq OWNED BY public.assettransforms.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    "groupId" integer NOT NULL,
    "parentId" integer,
    "deletedWithGroup" boolean,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.categories OWNER TO skyviewer;

--
-- Name: categorygroups; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.categorygroups (
    id integer NOT NULL,
    "structureId" integer NOT NULL,
    "fieldLayoutId" integer,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.categorygroups OWNER TO skyviewer;

--
-- Name: categorygroups_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.categorygroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categorygroups_id_seq OWNER TO skyviewer;

--
-- Name: categorygroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.categorygroups_id_seq OWNED BY public.categorygroups.id;


--
-- Name: categorygroups_sites; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.categorygroups_sites (
    id integer NOT NULL,
    "groupId" integer NOT NULL,
    "siteId" integer NOT NULL,
    "hasUrls" boolean DEFAULT true NOT NULL,
    "uriFormat" text,
    template character varying(500),
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.categorygroups_sites OWNER TO skyviewer;

--
-- Name: categorygroups_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.categorygroups_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categorygroups_sites_id_seq OWNER TO skyviewer;

--
-- Name: categorygroups_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.categorygroups_sites_id_seq OWNED BY public.categorygroups_sites.id;


--
-- Name: changedattributes; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.changedattributes (
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    attribute character varying(255) NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    propagated boolean NOT NULL,
    "userId" integer
);


ALTER TABLE public.changedattributes OWNER TO skyviewer;

--
-- Name: changedfields; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.changedfields (
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    "fieldId" integer NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    propagated boolean NOT NULL,
    "userId" integer
);


ALTER TABLE public.changedfields OWNER TO skyviewer;

--
-- Name: content; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.content (
    id integer NOT NULL,
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    title character varying(255),
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    field_catalog_url character varying(255),
    field_description text
);


ALTER TABLE public.content OWNER TO skyviewer;

--
-- Name: content_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.content_id_seq OWNER TO skyviewer;

--
-- Name: content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.content_id_seq OWNED BY public.content.id;


--
-- Name: craftidtokens; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.craftidtokens (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "accessToken" text NOT NULL,
    "expiryDate" timestamp(0) without time zone,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.craftidtokens OWNER TO skyviewer;

--
-- Name: craftidtokens_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.craftidtokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.craftidtokens_id_seq OWNER TO skyviewer;

--
-- Name: craftidtokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.craftidtokens_id_seq OWNED BY public.craftidtokens.id;


--
-- Name: deprecationerrors; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.deprecationerrors (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    fingerprint character varying(255) NOT NULL,
    "lastOccurrence" timestamp(0) without time zone NOT NULL,
    file character varying(255) NOT NULL,
    line smallint,
    message text,
    traces text,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.deprecationerrors OWNER TO skyviewer;

--
-- Name: deprecationerrors_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.deprecationerrors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deprecationerrors_id_seq OWNER TO skyviewer;

--
-- Name: deprecationerrors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.deprecationerrors_id_seq OWNED BY public.deprecationerrors.id;


--
-- Name: drafts; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.drafts (
    id integer NOT NULL,
    "sourceId" integer,
    "creatorId" integer,
    name character varying(255) NOT NULL,
    notes text,
    "trackChanges" boolean DEFAULT false NOT NULL,
    "dateLastMerged" timestamp(0) without time zone,
    saved boolean DEFAULT true NOT NULL
);


ALTER TABLE public.drafts OWNER TO skyviewer;

--
-- Name: drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.drafts_id_seq OWNER TO skyviewer;

--
-- Name: drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.drafts_id_seq OWNED BY public.drafts.id;


--
-- Name: elementindexsettings; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.elementindexsettings (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    settings text,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.elementindexsettings OWNER TO skyviewer;

--
-- Name: elementindexsettings_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.elementindexsettings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.elementindexsettings_id_seq OWNER TO skyviewer;

--
-- Name: elementindexsettings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.elementindexsettings_id_seq OWNED BY public.elementindexsettings.id;


--
-- Name: elements; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.elements (
    id integer NOT NULL,
    "draftId" integer,
    "revisionId" integer,
    "fieldLayoutId" integer,
    type character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    archived boolean DEFAULT false NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.elements OWNER TO skyviewer;

--
-- Name: elements_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.elements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.elements_id_seq OWNER TO skyviewer;

--
-- Name: elements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.elements_id_seq OWNED BY public.elements.id;


--
-- Name: elements_sites; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.elements_sites (
    id integer NOT NULL,
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    slug character varying(255),
    uri character varying(255),
    enabled boolean DEFAULT true NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.elements_sites OWNER TO skyviewer;

--
-- Name: elements_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.elements_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.elements_sites_id_seq OWNER TO skyviewer;

--
-- Name: elements_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.elements_sites_id_seq OWNED BY public.elements_sites.id;


--
-- Name: entries; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.entries (
    id integer NOT NULL,
    "sectionId" integer NOT NULL,
    "parentId" integer,
    "typeId" integer NOT NULL,
    "authorId" integer,
    "postDate" timestamp(0) without time zone,
    "expiryDate" timestamp(0) without time zone,
    "deletedWithEntryType" boolean,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.entries OWNER TO skyviewer;

--
-- Name: entrytypes; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.entrytypes (
    id integer NOT NULL,
    "sectionId" integer NOT NULL,
    "fieldLayoutId" integer,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    "hasTitleField" boolean DEFAULT true NOT NULL,
    "titleTranslationMethod" character varying(255) DEFAULT 'site'::character varying NOT NULL,
    "titleTranslationKeyFormat" text,
    "titleFormat" character varying(255),
    "sortOrder" smallint,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.entrytypes OWNER TO skyviewer;

--
-- Name: entrytypes_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.entrytypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entrytypes_id_seq OWNER TO skyviewer;

--
-- Name: entrytypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.entrytypes_id_seq OWNED BY public.entrytypes.id;


--
-- Name: fieldgroups; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.fieldgroups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.fieldgroups OWNER TO skyviewer;

--
-- Name: fieldgroups_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.fieldgroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fieldgroups_id_seq OWNER TO skyviewer;

--
-- Name: fieldgroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.fieldgroups_id_seq OWNED BY public.fieldgroups.id;


--
-- Name: fieldlayoutfields; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.fieldlayoutfields (
    id integer NOT NULL,
    "layoutId" integer NOT NULL,
    "tabId" integer NOT NULL,
    "fieldId" integer NOT NULL,
    required boolean DEFAULT false NOT NULL,
    "sortOrder" smallint,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.fieldlayoutfields OWNER TO skyviewer;

--
-- Name: fieldlayoutfields_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.fieldlayoutfields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fieldlayoutfields_id_seq OWNER TO skyviewer;

--
-- Name: fieldlayoutfields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.fieldlayoutfields_id_seq OWNED BY public.fieldlayoutfields.id;


--
-- Name: fieldlayouts; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.fieldlayouts (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.fieldlayouts OWNER TO skyviewer;

--
-- Name: fieldlayouts_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.fieldlayouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fieldlayouts_id_seq OWNER TO skyviewer;

--
-- Name: fieldlayouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.fieldlayouts_id_seq OWNED BY public.fieldlayouts.id;


--
-- Name: fieldlayouttabs; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.fieldlayouttabs (
    id integer NOT NULL,
    "layoutId" integer NOT NULL,
    name character varying(255) NOT NULL,
    elements text,
    "sortOrder" smallint,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.fieldlayouttabs OWNER TO skyviewer;

--
-- Name: fieldlayouttabs_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.fieldlayouttabs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fieldlayouttabs_id_seq OWNER TO skyviewer;

--
-- Name: fieldlayouttabs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.fieldlayouttabs_id_seq OWNED BY public.fieldlayouttabs.id;


--
-- Name: fields; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.fields (
    id integer NOT NULL,
    "groupId" integer,
    name character varying(255) NOT NULL,
    handle character varying(64) NOT NULL,
    context character varying(255) DEFAULT 'global'::character varying NOT NULL,
    instructions text,
    searchable boolean DEFAULT true NOT NULL,
    "translationMethod" character varying(255) DEFAULT 'none'::character varying NOT NULL,
    "translationKeyFormat" text,
    type character varying(255) NOT NULL,
    settings text,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.fields OWNER TO skyviewer;

--
-- Name: fields_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fields_id_seq OWNER TO skyviewer;

--
-- Name: fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.fields_id_seq OWNED BY public.fields.id;


--
-- Name: globalsets; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.globalsets (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    "fieldLayoutId" integer,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.globalsets OWNER TO skyviewer;

--
-- Name: globalsets_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.globalsets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.globalsets_id_seq OWNER TO skyviewer;

--
-- Name: globalsets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.globalsets_id_seq OWNED BY public.globalsets.id;


--
-- Name: gqlschemas; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.gqlschemas (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    scope text,
    "isPublic" boolean DEFAULT false NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.gqlschemas OWNER TO skyviewer;

--
-- Name: gqlschemas_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.gqlschemas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gqlschemas_id_seq OWNER TO skyviewer;

--
-- Name: gqlschemas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.gqlschemas_id_seq OWNED BY public.gqlschemas.id;


--
-- Name: gqltokens; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.gqltokens (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "accessToken" character varying(255) NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    "expiryDate" timestamp(0) without time zone,
    "lastUsed" timestamp(0) without time zone,
    "schemaId" integer,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.gqltokens OWNER TO skyviewer;

--
-- Name: gqltokens_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.gqltokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.gqltokens_id_seq OWNER TO skyviewer;

--
-- Name: gqltokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.gqltokens_id_seq OWNED BY public.gqltokens.id;


--
-- Name: info; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.info (
    id integer NOT NULL,
    version character varying(50) NOT NULL,
    "schemaVersion" character varying(15) NOT NULL,
    maintenance boolean DEFAULT false NOT NULL,
    "configVersion" character(12) DEFAULT '000000000000'::bpchar NOT NULL,
    "fieldVersion" character(12) DEFAULT '000000000000'::bpchar NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.info OWNER TO skyviewer;

--
-- Name: info_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.info_id_seq OWNER TO skyviewer;

--
-- Name: info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.info_id_seq OWNED BY public.info.id;


--
-- Name: matrixblocks; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.matrixblocks (
    id integer NOT NULL,
    "ownerId" integer NOT NULL,
    "fieldId" integer NOT NULL,
    "typeId" integer NOT NULL,
    "sortOrder" smallint,
    "deletedWithOwner" boolean,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.matrixblocks OWNER TO skyviewer;

--
-- Name: matrixblocktypes; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.matrixblocktypes (
    id integer NOT NULL,
    "fieldId" integer NOT NULL,
    "fieldLayoutId" integer,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    "sortOrder" smallint,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.matrixblocktypes OWNER TO skyviewer;

--
-- Name: matrixblocktypes_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.matrixblocktypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.matrixblocktypes_id_seq OWNER TO skyviewer;

--
-- Name: matrixblocktypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.matrixblocktypes_id_seq OWNED BY public.matrixblocktypes.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    track character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    "applyTime" timestamp(0) without time zone NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.migrations OWNER TO skyviewer;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.migrations_id_seq OWNER TO skyviewer;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: plugins; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.plugins (
    id integer NOT NULL,
    handle character varying(255) NOT NULL,
    version character varying(255) NOT NULL,
    "schemaVersion" character varying(255) NOT NULL,
    "licenseKeyStatus" character varying(255) DEFAULT 'unknown'::character varying NOT NULL,
    "licensedEdition" character varying(255),
    "installDate" timestamp(0) without time zone NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    CONSTRAINT "plugins_licenseKeyStatus_check" CHECK ((("licenseKeyStatus")::text = ANY ((ARRAY['valid'::character varying, 'trial'::character varying, 'invalid'::character varying, 'mismatched'::character varying, 'astray'::character varying, 'unknown'::character varying])::text[])))
);


ALTER TABLE public.plugins OWNER TO skyviewer;

--
-- Name: plugins_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.plugins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.plugins_id_seq OWNER TO skyviewer;

--
-- Name: plugins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.plugins_id_seq OWNED BY public.plugins.id;


--
-- Name: projectconfig; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.projectconfig (
    path character varying(255) NOT NULL,
    value text NOT NULL
);


ALTER TABLE public.projectconfig OWNER TO skyviewer;

--
-- Name: projectconfignames; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.projectconfignames (
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.projectconfignames OWNER TO skyviewer;

--
-- Name: queue; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.queue (
    id integer NOT NULL,
    channel character varying(255) DEFAULT 'queue'::character varying NOT NULL,
    job bytea NOT NULL,
    description text,
    "timePushed" integer NOT NULL,
    ttr integer NOT NULL,
    delay integer DEFAULT 0 NOT NULL,
    priority integer DEFAULT 1024 NOT NULL,
    "dateReserved" timestamp(0) without time zone,
    "timeUpdated" integer,
    progress smallint DEFAULT 0 NOT NULL,
    "progressLabel" character varying(255),
    attempt integer,
    fail boolean DEFAULT false,
    "dateFailed" timestamp(0) without time zone,
    error text
);


ALTER TABLE public.queue OWNER TO skyviewer;

--
-- Name: queue_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.queue_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.queue_id_seq OWNER TO skyviewer;

--
-- Name: queue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.queue_id_seq OWNED BY public.queue.id;


--
-- Name: relations; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.relations (
    id integer NOT NULL,
    "fieldId" integer NOT NULL,
    "sourceId" integer NOT NULL,
    "sourceSiteId" integer,
    "targetId" integer NOT NULL,
    "sortOrder" smallint,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.relations OWNER TO skyviewer;

--
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.relations_id_seq OWNER TO skyviewer;

--
-- Name: relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.relations_id_seq OWNED BY public.relations.id;


--
-- Name: resourcepaths; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.resourcepaths (
    hash character varying(255) NOT NULL,
    path character varying(255) NOT NULL
);


ALTER TABLE public.resourcepaths OWNER TO skyviewer;

--
-- Name: revisions; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.revisions (
    id integer NOT NULL,
    "sourceId" integer NOT NULL,
    "creatorId" integer,
    num integer NOT NULL,
    notes text
);


ALTER TABLE public.revisions OWNER TO skyviewer;

--
-- Name: revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revisions_id_seq OWNER TO skyviewer;

--
-- Name: revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.revisions_id_seq OWNED BY public.revisions.id;


--
-- Name: searchindex; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.searchindex (
    "elementId" integer NOT NULL,
    attribute character varying(25) NOT NULL,
    "fieldId" integer NOT NULL,
    "siteId" integer NOT NULL,
    keywords text NOT NULL,
    keywords_vector tsvector NOT NULL
);


ALTER TABLE public.searchindex OWNER TO skyviewer;

--
-- Name: sections; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.sections (
    id integer NOT NULL,
    "structureId" integer,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    type character varying(255) DEFAULT 'channel'::character varying NOT NULL,
    "enableVersioning" boolean DEFAULT false NOT NULL,
    "propagationMethod" character varying(255) DEFAULT 'all'::character varying NOT NULL,
    "previewTargets" text,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    CONSTRAINT sections_type_check CHECK (((type)::text = ANY ((ARRAY['single'::character varying, 'channel'::character varying, 'structure'::character varying])::text[])))
);


ALTER TABLE public.sections OWNER TO skyviewer;

--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sections_id_seq OWNER TO skyviewer;

--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.sections_id_seq OWNED BY public.sections.id;


--
-- Name: sections_sites; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.sections_sites (
    id integer NOT NULL,
    "sectionId" integer NOT NULL,
    "siteId" integer NOT NULL,
    "hasUrls" boolean DEFAULT true NOT NULL,
    "uriFormat" text,
    template character varying(500),
    "enabledByDefault" boolean DEFAULT true NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.sections_sites OWNER TO skyviewer;

--
-- Name: sections_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.sections_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sections_sites_id_seq OWNER TO skyviewer;

--
-- Name: sections_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.sections_sites_id_seq OWNED BY public.sections_sites.id;


--
-- Name: sequences; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.sequences (
    name character varying(255) NOT NULL,
    next integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.sequences OWNER TO skyviewer;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    token character(100) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.sessions OWNER TO skyviewer;

--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sessions_id_seq OWNER TO skyviewer;

--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: shunnedmessages; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.shunnedmessages (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    message character varying(255) NOT NULL,
    "expiryDate" timestamp(0) without time zone,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.shunnedmessages OWNER TO skyviewer;

--
-- Name: shunnedmessages_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.shunnedmessages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shunnedmessages_id_seq OWNER TO skyviewer;

--
-- Name: shunnedmessages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.shunnedmessages_id_seq OWNED BY public.shunnedmessages.id;


--
-- Name: sitegroups; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.sitegroups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.sitegroups OWNER TO skyviewer;

--
-- Name: sitegroups_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.sitegroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sitegroups_id_seq OWNER TO skyviewer;

--
-- Name: sitegroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.sitegroups_id_seq OWNED BY public.sitegroups.id;


--
-- Name: sites; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.sites (
    id integer NOT NULL,
    "groupId" integer NOT NULL,
    "primary" boolean NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    language character varying(12) NOT NULL,
    "hasUrls" boolean DEFAULT false NOT NULL,
    "baseUrl" character varying(255),
    "sortOrder" smallint,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.sites OWNER TO skyviewer;

--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sites_id_seq OWNER TO skyviewer;

--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.sites_id_seq OWNED BY public.sites.id;


--
-- Name: structureelements; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.structureelements (
    id integer NOT NULL,
    "structureId" integer NOT NULL,
    "elementId" integer,
    root integer,
    lft integer NOT NULL,
    rgt integer NOT NULL,
    level smallint NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.structureelements OWNER TO skyviewer;

--
-- Name: structureelements_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.structureelements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.structureelements_id_seq OWNER TO skyviewer;

--
-- Name: structureelements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.structureelements_id_seq OWNED BY public.structureelements.id;


--
-- Name: structures; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.structures (
    id integer NOT NULL,
    "maxLevels" smallint,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.structures OWNER TO skyviewer;

--
-- Name: structures_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.structures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.structures_id_seq OWNER TO skyviewer;

--
-- Name: structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.structures_id_seq OWNED BY public.structures.id;


--
-- Name: systemmessages; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.systemmessages (
    id integer NOT NULL,
    language character varying(255) NOT NULL,
    key character varying(255) NOT NULL,
    subject text NOT NULL,
    body text NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.systemmessages OWNER TO skyviewer;

--
-- Name: systemmessages_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.systemmessages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.systemmessages_id_seq OWNER TO skyviewer;

--
-- Name: systemmessages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.systemmessages_id_seq OWNED BY public.systemmessages.id;


--
-- Name: taggroups; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.taggroups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    "fieldLayoutId" integer,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.taggroups OWNER TO skyviewer;

--
-- Name: taggroups_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.taggroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.taggroups_id_seq OWNER TO skyviewer;

--
-- Name: taggroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.taggroups_id_seq OWNED BY public.taggroups.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    "groupId" integer NOT NULL,
    "deletedWithGroup" boolean,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.tags OWNER TO skyviewer;

--
-- Name: templatecacheelements; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.templatecacheelements (
    id integer NOT NULL,
    "cacheId" integer NOT NULL,
    "elementId" integer NOT NULL
);


ALTER TABLE public.templatecacheelements OWNER TO skyviewer;

--
-- Name: templatecacheelements_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.templatecacheelements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.templatecacheelements_id_seq OWNER TO skyviewer;

--
-- Name: templatecacheelements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.templatecacheelements_id_seq OWNED BY public.templatecacheelements.id;


--
-- Name: templatecachequeries; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.templatecachequeries (
    id integer NOT NULL,
    "cacheId" integer NOT NULL,
    type character varying(255) NOT NULL,
    query text NOT NULL
);


ALTER TABLE public.templatecachequeries OWNER TO skyviewer;

--
-- Name: templatecachequeries_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.templatecachequeries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.templatecachequeries_id_seq OWNER TO skyviewer;

--
-- Name: templatecachequeries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.templatecachequeries_id_seq OWNED BY public.templatecachequeries.id;


--
-- Name: templatecaches; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.templatecaches (
    id integer NOT NULL,
    "siteId" integer NOT NULL,
    "cacheKey" character varying(255) NOT NULL,
    path character varying(255),
    "expiryDate" timestamp(0) without time zone NOT NULL,
    body text NOT NULL
);


ALTER TABLE public.templatecaches OWNER TO skyviewer;

--
-- Name: templatecaches_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.templatecaches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.templatecaches_id_seq OWNER TO skyviewer;

--
-- Name: templatecaches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.templatecaches_id_seq OWNED BY public.templatecaches.id;


--
-- Name: tokens; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.tokens (
    id integer NOT NULL,
    token character(32) NOT NULL,
    route text,
    "usageLimit" smallint,
    "usageCount" smallint,
    "expiryDate" timestamp(0) without time zone NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.tokens OWNER TO skyviewer;

--
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tokens_id_seq OWNER TO skyviewer;

--
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;


--
-- Name: usergroups; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.usergroups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    description text,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.usergroups OWNER TO skyviewer;

--
-- Name: usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usergroups_id_seq OWNER TO skyviewer;

--
-- Name: usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.usergroups_id_seq OWNED BY public.usergroups.id;


--
-- Name: usergroups_users; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.usergroups_users (
    id integer NOT NULL,
    "groupId" integer NOT NULL,
    "userId" integer NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.usergroups_users OWNER TO skyviewer;

--
-- Name: usergroups_users_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.usergroups_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.usergroups_users_id_seq OWNER TO skyviewer;

--
-- Name: usergroups_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.usergroups_users_id_seq OWNED BY public.usergroups_users.id;


--
-- Name: userpermissions; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.userpermissions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.userpermissions OWNER TO skyviewer;

--
-- Name: userpermissions_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.userpermissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userpermissions_id_seq OWNER TO skyviewer;

--
-- Name: userpermissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.userpermissions_id_seq OWNED BY public.userpermissions.id;


--
-- Name: userpermissions_usergroups; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.userpermissions_usergroups (
    id integer NOT NULL,
    "permissionId" integer NOT NULL,
    "groupId" integer NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.userpermissions_usergroups OWNER TO skyviewer;

--
-- Name: userpermissions_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.userpermissions_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userpermissions_usergroups_id_seq OWNER TO skyviewer;

--
-- Name: userpermissions_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.userpermissions_usergroups_id_seq OWNED BY public.userpermissions_usergroups.id;


--
-- Name: userpermissions_users; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.userpermissions_users (
    id integer NOT NULL,
    "permissionId" integer NOT NULL,
    "userId" integer NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.userpermissions_users OWNER TO skyviewer;

--
-- Name: userpermissions_users_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.userpermissions_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.userpermissions_users_id_seq OWNER TO skyviewer;

--
-- Name: userpermissions_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.userpermissions_users_id_seq OWNED BY public.userpermissions_users.id;


--
-- Name: userpreferences; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.userpreferences (
    "userId" integer NOT NULL,
    preferences text
);


ALTER TABLE public.userpreferences OWNER TO skyviewer;

--
-- Name: userpreferences_userId_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public."userpreferences_userId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."userpreferences_userId_seq" OWNER TO skyviewer;

--
-- Name: userpreferences_userId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public."userpreferences_userId_seq" OWNED BY public.userpreferences."userId";


--
-- Name: users; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    "photoId" integer,
    "firstName" character varying(100),
    "lastName" character varying(100),
    email character varying(255) NOT NULL,
    password character varying(255),
    admin boolean DEFAULT false NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    suspended boolean DEFAULT false NOT NULL,
    pending boolean DEFAULT false NOT NULL,
    "lastLoginDate" timestamp(0) without time zone,
    "lastLoginAttemptIp" character varying(45),
    "invalidLoginWindowStart" timestamp(0) without time zone,
    "invalidLoginCount" smallint,
    "lastInvalidLoginDate" timestamp(0) without time zone,
    "lockoutDate" timestamp(0) without time zone,
    "hasDashboard" boolean DEFAULT false NOT NULL,
    "verificationCode" character varying(255),
    "verificationCodeIssuedDate" timestamp(0) without time zone,
    "unverifiedEmail" character varying(255),
    "passwordResetRequired" boolean DEFAULT false NOT NULL,
    "lastPasswordChangeDate" timestamp(0) without time zone,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.users OWNER TO skyviewer;

--
-- Name: volumefolders; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.volumefolders (
    id integer NOT NULL,
    "parentId" integer,
    "volumeId" integer,
    name character varying(255) NOT NULL,
    path character varying(255),
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.volumefolders OWNER TO skyviewer;

--
-- Name: volumefolders_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.volumefolders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.volumefolders_id_seq OWNER TO skyviewer;

--
-- Name: volumefolders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.volumefolders_id_seq OWNED BY public.volumefolders.id;


--
-- Name: volumes; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.volumes (
    id integer NOT NULL,
    "fieldLayoutId" integer,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    "hasUrls" boolean DEFAULT true NOT NULL,
    url character varying(255),
    "titleTranslationMethod" character varying(255) DEFAULT 'site'::character varying NOT NULL,
    "titleTranslationKeyFormat" text,
    settings text,
    "sortOrder" smallint,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.volumes OWNER TO skyviewer;

--
-- Name: volumes_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.volumes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.volumes_id_seq OWNER TO skyviewer;

--
-- Name: volumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.volumes_id_seq OWNED BY public.volumes.id;


--
-- Name: widgets; Type: TABLE; Schema: public; Owner: skyviewer
--

CREATE TABLE public.widgets (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    type character varying(255) NOT NULL,
    "sortOrder" smallint,
    colspan smallint,
    settings text,
    enabled boolean DEFAULT true NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


ALTER TABLE public.widgets OWNER TO skyviewer;

--
-- Name: widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: skyviewer
--

CREATE SEQUENCE public.widgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.widgets_id_seq OWNER TO skyviewer;

--
-- Name: widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: skyviewer
--

ALTER SEQUENCE public.widgets_id_seq OWNED BY public.widgets.id;


--
-- Name: assetindexdata id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assetindexdata ALTER COLUMN id SET DEFAULT nextval('public.assetindexdata_id_seq'::regclass);


--
-- Name: assettransformindex id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assettransformindex ALTER COLUMN id SET DEFAULT nextval('public.assettransformindex_id_seq'::regclass);


--
-- Name: assettransforms id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assettransforms ALTER COLUMN id SET DEFAULT nextval('public.assettransforms_id_seq'::regclass);


--
-- Name: categorygroups id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categorygroups ALTER COLUMN id SET DEFAULT nextval('public.categorygroups_id_seq'::regclass);


--
-- Name: categorygroups_sites id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categorygroups_sites ALTER COLUMN id SET DEFAULT nextval('public.categorygroups_sites_id_seq'::regclass);


--
-- Name: content id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.content ALTER COLUMN id SET DEFAULT nextval('public.content_id_seq'::regclass);


--
-- Name: craftidtokens id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.craftidtokens ALTER COLUMN id SET DEFAULT nextval('public.craftidtokens_id_seq'::regclass);


--
-- Name: deprecationerrors id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.deprecationerrors ALTER COLUMN id SET DEFAULT nextval('public.deprecationerrors_id_seq'::regclass);


--
-- Name: drafts id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.drafts ALTER COLUMN id SET DEFAULT nextval('public.drafts_id_seq'::regclass);


--
-- Name: elementindexsettings id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elementindexsettings ALTER COLUMN id SET DEFAULT nextval('public.elementindexsettings_id_seq'::regclass);


--
-- Name: elements id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elements ALTER COLUMN id SET DEFAULT nextval('public.elements_id_seq'::regclass);


--
-- Name: elements_sites id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elements_sites ALTER COLUMN id SET DEFAULT nextval('public.elements_sites_id_seq'::regclass);


--
-- Name: entrytypes id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.entrytypes ALTER COLUMN id SET DEFAULT nextval('public.entrytypes_id_seq'::regclass);


--
-- Name: fieldgroups id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldgroups ALTER COLUMN id SET DEFAULT nextval('public.fieldgroups_id_seq'::regclass);


--
-- Name: fieldlayoutfields id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldlayoutfields ALTER COLUMN id SET DEFAULT nextval('public.fieldlayoutfields_id_seq'::regclass);


--
-- Name: fieldlayouts id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldlayouts ALTER COLUMN id SET DEFAULT nextval('public.fieldlayouts_id_seq'::regclass);


--
-- Name: fieldlayouttabs id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldlayouttabs ALTER COLUMN id SET DEFAULT nextval('public.fieldlayouttabs_id_seq'::regclass);


--
-- Name: fields id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fields ALTER COLUMN id SET DEFAULT nextval('public.fields_id_seq'::regclass);


--
-- Name: globalsets id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.globalsets ALTER COLUMN id SET DEFAULT nextval('public.globalsets_id_seq'::regclass);


--
-- Name: gqlschemas id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.gqlschemas ALTER COLUMN id SET DEFAULT nextval('public.gqlschemas_id_seq'::regclass);


--
-- Name: gqltokens id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.gqltokens ALTER COLUMN id SET DEFAULT nextval('public.gqltokens_id_seq'::regclass);


--
-- Name: info id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.info ALTER COLUMN id SET DEFAULT nextval('public.info_id_seq'::regclass);


--
-- Name: matrixblocktypes id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.matrixblocktypes ALTER COLUMN id SET DEFAULT nextval('public.matrixblocktypes_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: plugins id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.plugins ALTER COLUMN id SET DEFAULT nextval('public.plugins_id_seq'::regclass);


--
-- Name: queue id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.queue ALTER COLUMN id SET DEFAULT nextval('public.queue_id_seq'::regclass);


--
-- Name: relations id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.relations ALTER COLUMN id SET DEFAULT nextval('public.relations_id_seq'::regclass);


--
-- Name: revisions id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.revisions ALTER COLUMN id SET DEFAULT nextval('public.revisions_id_seq'::regclass);


--
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- Name: sections_sites id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sections_sites ALTER COLUMN id SET DEFAULT nextval('public.sections_sites_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: shunnedmessages id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.shunnedmessages ALTER COLUMN id SET DEFAULT nextval('public.shunnedmessages_id_seq'::regclass);


--
-- Name: sitegroups id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sitegroups ALTER COLUMN id SET DEFAULT nextval('public.sitegroups_id_seq'::regclass);


--
-- Name: sites id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sites ALTER COLUMN id SET DEFAULT nextval('public.sites_id_seq'::regclass);


--
-- Name: structureelements id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.structureelements ALTER COLUMN id SET DEFAULT nextval('public.structureelements_id_seq'::regclass);


--
-- Name: structures id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.structures ALTER COLUMN id SET DEFAULT nextval('public.structures_id_seq'::regclass);


--
-- Name: systemmessages id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.systemmessages ALTER COLUMN id SET DEFAULT nextval('public.systemmessages_id_seq'::regclass);


--
-- Name: taggroups id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.taggroups ALTER COLUMN id SET DEFAULT nextval('public.taggroups_id_seq'::regclass);


--
-- Name: templatecacheelements id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.templatecacheelements ALTER COLUMN id SET DEFAULT nextval('public.templatecacheelements_id_seq'::regclass);


--
-- Name: templatecachequeries id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.templatecachequeries ALTER COLUMN id SET DEFAULT nextval('public.templatecachequeries_id_seq'::regclass);


--
-- Name: templatecaches id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.templatecaches ALTER COLUMN id SET DEFAULT nextval('public.templatecaches_id_seq'::regclass);


--
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);


--
-- Name: usergroups id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.usergroups ALTER COLUMN id SET DEFAULT nextval('public.usergroups_id_seq'::regclass);


--
-- Name: usergroups_users id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.usergroups_users ALTER COLUMN id SET DEFAULT nextval('public.usergroups_users_id_seq'::regclass);


--
-- Name: userpermissions id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpermissions ALTER COLUMN id SET DEFAULT nextval('public.userpermissions_id_seq'::regclass);


--
-- Name: userpermissions_usergroups id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpermissions_usergroups ALTER COLUMN id SET DEFAULT nextval('public.userpermissions_usergroups_id_seq'::regclass);


--
-- Name: userpermissions_users id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpermissions_users ALTER COLUMN id SET DEFAULT nextval('public.userpermissions_users_id_seq'::regclass);


--
-- Name: userpreferences userId; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpreferences ALTER COLUMN "userId" SET DEFAULT nextval('public."userpreferences_userId_seq"'::regclass);


--
-- Name: volumefolders id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.volumefolders ALTER COLUMN id SET DEFAULT nextval('public.volumefolders_id_seq'::regclass);


--
-- Name: volumes id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.volumes ALTER COLUMN id SET DEFAULT nextval('public.volumes_id_seq'::regclass);


--
-- Name: widgets id; Type: DEFAULT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.widgets ALTER COLUMN id SET DEFAULT nextval('public.widgets_id_seq'::regclass);


--
-- Data for Name: assetindexdata; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.assetindexdata (id, "sessionId", "volumeId", uri, size, "timestamp", "recordId", "inProgress", completed, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.assets (id, "volumeId", "folderId", "uploaderId", filename, kind, width, height, size, "focalPoint", "deletedWithVolume", "keptFile", "dateModified", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: assettransformindex; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.assettransformindex (id, "assetId", filename, format, location, "volumeId", "fileExists", "inProgress", error, "dateIndexed", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: assettransforms; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.assettransforms (id, name, handle, mode, "position", width, height, format, quality, interlace, "dimensionChangeTime", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.categories (id, "groupId", "parentId", "deletedWithGroup", "dateCreated", "dateUpdated", uid) FROM stdin;
2	1	\N	\N	2021-05-19 21:19:04	2021-05-19 21:19:04	6b2b8394-06da-4609-b749-9670c7b9b4af
\.


--
-- Data for Name: categorygroups; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.categorygroups (id, "structureId", "fieldLayoutId", name, handle, "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	1	1	HiPS Catalogs	hipsCatalogs	2021-05-19 21:15:41	2021-05-19 21:15:41	\N	43c5d827-8706-4863-a676-17bf911ce931
\.


--
-- Data for Name: categorygroups_sites; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.categorygroups_sites (id, "groupId", "siteId", "hasUrls", "uriFormat", template, "dateCreated", "dateUpdated", uid) FROM stdin;
1	1	1	t	hips-catalogs/{slug}	\N	2021-05-19 21:15:41	2021-05-19 21:15:41	9a5f9770-6957-4b0b-9e4d-426f1f28357a
\.


--
-- Data for Name: changedattributes; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.changedattributes ("elementId", "siteId", attribute, "dateUpdated", propagated, "userId") FROM stdin;
\.


--
-- Data for Name: changedfields; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.changedfields ("elementId", "siteId", "fieldId", "dateUpdated", propagated, "userId") FROM stdin;
\.


--
-- Data for Name: content; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.content (id, "elementId", "siteId", title, "dateCreated", "dateUpdated", uid, field_catalog_url, field_description) FROM stdin;
1	1	1	\N	2021-05-19 21:09:33	2021-05-19 21:09:33	70b34bdf-a7a9-45ed-9eef-c76d043f7efb	\N	\N
2	2	1	Allsky HiPS Catalog Data	2021-05-19 21:19:04	2021-05-19 22:02:31	faa6d77a-f151-4b08-95a8-02727c11bdb4	https://epo-hips.netlify.app/catalog_transients/	A hodgepodge of stars, nebulae, galaxies, and transient objects.
3	3	1	\N	2021-05-19 22:50:51	2021-05-19 22:50:51	b0cffdee-849e-4bb9-8988-d901848bebd4	\N	\N
4	4	1	\N	2021-05-19 22:52:54	2021-05-19 22:52:54	295ab0a4-dbfe-4c7f-950e-82a2d38de081	\N	\N
5	5	1	Allsky HiPS Catalog Data	2021-05-19 22:53:34	2021-05-19 22:54:38	17bb60b2-3775-4b73-87c7-57db9be0aebb	https://epo-hips.netlify.app/catalog/	A hodgepodge of stars, galaxies, nebulae, and transient objects.
\.


--
-- Data for Name: craftidtokens; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.craftidtokens (id, "userId", "accessToken", "expiryDate", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: deprecationerrors; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.deprecationerrors (id, key, fingerprint, "lastOccurrence", file, line, message, traces, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: drafts; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.drafts (id, "sourceId", "creatorId", name, notes, "trackChanges", "dateLastMerged", saved) FROM stdin;
1	\N	1	First draft	\N	f	\N	f
2	\N	1	First draft	\N	f	\N	f
3	\N	1	First draft		f	\N	t
\.


--
-- Data for Name: elementindexsettings; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.elementindexsettings (id, type, settings, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: elements; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.elements (id, "draftId", "revisionId", "fieldLayoutId", type, enabled, archived, "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	\N	\N	\N	craft\\elements\\User	t	f	2021-05-19 21:09:33	2021-05-19 21:09:33	\N	3637eed8-8250-4e7f-ba18-54292db1b85f
2	\N	\N	1	craft\\elements\\Category	t	f	2021-05-19 21:19:04	2021-05-19 22:02:31	\N	a833905c-d82c-44ec-a12c-73a128d828ad
3	1	\N	2	craft\\elements\\Entry	t	f	2021-05-19 22:50:51	2021-05-19 22:50:51	\N	13efb1e8-5cb9-4b60-b32f-0fbada31e981
4	2	\N	2	craft\\elements\\Entry	t	f	2021-05-19 22:52:54	2021-05-19 22:52:54	\N	73a26f01-650f-4985-8410-1a1b527c6a67
5	3	\N	2	craft\\elements\\Entry	t	f	2021-05-19 22:53:34	2021-05-19 22:54:38	\N	b30d5446-9bcc-4e9a-ad5e-73dd6da9ae8a
\.


--
-- Data for Name: elements_sites; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.elements_sites (id, "elementId", "siteId", slug, uri, enabled, "dateCreated", "dateUpdated", uid) FROM stdin;
1	1	1	\N	\N	t	2021-05-19 21:09:33	2021-05-19 21:09:33	7cda788c-48bb-44ce-9a6c-129466561556
2	2	1	catalog-data	hips-catalogs/catalog-data	t	2021-05-19 21:19:04	2021-05-19 21:19:05	c79dbddd-7cda-4d5f-8ffb-8cce3e895b30
3	3	1	__temp_evrzpzgcpethpqmdatvmjwitqytkxncfwgaw	catalog/__temp_evrzpzgcpethpqmdatvmjwitqytkxncfwgaw	t	2021-05-19 22:50:51	2021-05-19 22:50:51	4b5d3c31-d572-4abb-91bf-48b80e58f397
4	4	1	__temp_ignhzbtrxqwizdkionwdqgqexnhfusgiqkdj	catalog/__temp_ignhzbtrxqwizdkionwdqgqexnhfusgiqkdj	t	2021-05-19 22:52:54	2021-05-19 22:52:54	7fb994c3-2514-48d0-825e-9c0d2b959183
5	5	1	allsky-hips-catalog-data	catalog/allsky-hips-catalog-data	t	2021-05-19 22:53:34	2021-05-19 22:53:43	55ab3df9-2d47-4a24-a4f6-8eedf246cdb6
\.


--
-- Data for Name: entries; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.entries (id, "sectionId", "parentId", "typeId", "authorId", "postDate", "expiryDate", "deletedWithEntryType", "dateCreated", "dateUpdated", uid) FROM stdin;
3	1	\N	1	1	2021-05-19 22:50:00	\N	\N	2021-05-19 22:50:51	2021-05-19 22:50:51	e57983ea-fed0-448f-9749-5b4e03328420
4	1	\N	1	1	2021-05-19 22:52:00	\N	\N	2021-05-19 22:52:54	2021-05-19 22:52:54	bb0f2e53-99b3-44f8-97fe-1f44c3dd4920
5	1	\N	1	1	2021-05-19 22:53:00	\N	\N	2021-05-19 22:53:34	2021-05-19 22:53:34	5a231364-6555-40f6-9590-db6dac2b0d87
\.


--
-- Data for Name: entrytypes; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.entrytypes (id, "sectionId", "fieldLayoutId", name, handle, "hasTitleField", "titleTranslationMethod", "titleTranslationKeyFormat", "titleFormat", "sortOrder", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	1	2	Catalog	catalog	t	site	\N	\N	1	2021-05-19 22:50:41	2021-05-19 22:50:41	\N	9d2a5fce-1549-4e9f-8205-f1527f5064b2
\.


--
-- Data for Name: fieldgroups; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.fieldgroups (id, name, "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	Common	2021-05-19 21:09:33	2021-05-19 21:09:33	\N	7d09d2f0-5c11-4a45-a805-a6d39128319e
2	Catalog	2021-05-19 21:53:15	2021-05-19 21:53:15	\N	a3b0cf34-24af-41fe-8047-b1e5b65d5bd0
\.


--
-- Data for Name: fieldlayoutfields; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.fieldlayoutfields (id, "layoutId", "tabId", "fieldId", required, "sortOrder", "dateCreated", "dateUpdated", uid) FROM stdin;
3	1	3	1	f	1	2021-05-19 22:39:44	2021-05-19 22:39:44	49f87811-7fa4-400d-a456-7ad892bccb44
4	1	3	2	f	2	2021-05-19 22:39:44	2021-05-19 22:39:44	d549bb32-080f-4c16-9752-4029c5685ce0
5	2	5	1	f	1	2021-05-19 22:53:27	2021-05-19 22:53:27	692c2c9a-cdc4-44d5-801e-5f0f5c29078f
6	2	5	2	f	2	2021-05-19 22:53:27	2021-05-19 22:53:27	ad49d161-0949-4c27-b22e-c43a29615d4b
\.


--
-- Data for Name: fieldlayouts; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.fieldlayouts (id, type, "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	craft\\elements\\Category	2021-05-19 21:15:41	2021-05-19 21:15:41	\N	88f13df1-be43-4126-b9ff-75c00eccfde6
2	craft\\elements\\Entry	2021-05-19 22:50:41	2021-05-19 22:50:41	\N	ab781cc4-81d9-4138-958a-fd7a2609cbda
\.


--
-- Data for Name: fieldlayouttabs; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.fieldlayouttabs (id, "layoutId", name, elements, "sortOrder", "dateCreated", "dateUpdated", uid) FROM stdin;
3	1	Content	[{"type":"craft\\\\fieldlayoutelements\\\\TitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"68674953-a9fc-439e-8ee2-e6a9bb70dafc"}]	1	2021-05-19 22:39:44	2021-05-19 22:39:44	64b17d06-5ad8-42b8-8f8d-6faecc62f3ad
5	2	Content	[{"type":"craft\\\\fieldlayoutelements\\\\EntryTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"68674953-a9fc-439e-8ee2-e6a9bb70dafc"}]	1	2021-05-19 22:53:27	2021-05-19 22:53:27	bfece8ba-d4ba-4eeb-81c0-fb281dcbf162
\.


--
-- Data for Name: fields; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.fields (id, "groupId", name, handle, context, instructions, searchable, "translationMethod", "translationKeyFormat", type, settings, "dateCreated", "dateUpdated", uid) FROM stdin;
1	2	URL	catalog_url	global		f	none	\N	craft\\fields\\Url	{"maxLength":"255","placeholder":null,"types":["url"]}	2021-05-19 21:54:16	2021-05-19 21:54:16	fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377
2	2	Description	description	global	What does this HiPS catalog contain?	f	none	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-05-19 21:55:27	2021-05-19 21:55:27	68674953-a9fc-439e-8ee2-e6a9bb70dafc
\.


--
-- Data for Name: globalsets; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.globalsets (id, name, handle, "fieldLayoutId", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: gqlschemas; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.gqlschemas (id, name, scope, "isPublic", "dateCreated", "dateUpdated", uid) FROM stdin;
1	Public Schema	["categorygroups.43c5d827-8706-4863-a676-17bf911ce931:read"]	t	2021-05-19 22:30:12	2021-05-19 22:44:46	d250222b-10fd-487b-a94c-8c7aa5241cb3
\.


--
-- Data for Name: gqltokens; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.gqltokens (id, name, "accessToken", enabled, "expiryDate", "lastUsed", "schemaId", "dateCreated", "dateUpdated", uid) FROM stdin;
1	Public Token	__PUBLIC__	t	\N	\N	1	2021-05-19 22:30:12	2021-05-19 22:30:12	2891d0be-e8ee-4803-8805-95e818f1360d
\.


--
-- Data for Name: info; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.info (id, version, "schemaVersion", maintenance, "configVersion", "fieldVersion", "dateCreated", "dateUpdated", uid) FROM stdin;
1	3.6.14	3.6.8	f	ottcfmwuccph	kmgdidjjdkgr	2021-05-19 21:09:33	2021-05-19 22:59:19	393da067-9dd3-4b05-bf3f-a6e8e914ae1d
\.


--
-- Data for Name: matrixblocks; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.matrixblocks (id, "ownerId", "fieldId", "typeId", "sortOrder", "deletedWithOwner", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: matrixblocktypes; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.matrixblocktypes (id, "fieldId", "fieldLayoutId", name, handle, "sortOrder", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.migrations (id, track, name, "applyTime", "dateCreated", "dateUpdated", uid) FROM stdin;
1	craft	Install	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	a24d0156-f707-43c1-95d3-298ae36f9751
2	craft	m150403_183908_migrations_table_changes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b2ed7510-3ca7-4f3a-be5d-427332eaa483
3	craft	m150403_184247_plugins_table_changes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	e3cb0461-4854-4130-b9be-245255225872
4	craft	m150403_184533_field_version	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	f49bd611-fc91-4173-80c8-8535cadb6897
5	craft	m150403_184729_type_columns	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	60864aa6-7701-4f13-a504-4d29cda4b551
6	craft	m150403_185142_volumes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	0e9c0ca4-2347-4474-bd20-707415b67db5
7	craft	m150428_231346_userpreferences	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	115b3765-e451-4971-9bd7-663ceaa0fd24
8	craft	m150519_150900_fieldversion_conversion	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b89f8c1a-c1ae-4976-a1f2-627ab5d99b58
9	craft	m150617_213829_update_email_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	7c38a18e-acb5-45be-b09b-843c1d580c8a
10	craft	m150721_124739_templatecachequeries	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	45f60a98-483e-4500-84b3-24a434e97035
11	craft	m150724_140822_adjust_quality_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	28b6c060-1b22-4807-8cbf-b2cd0b82264f
12	craft	m150815_133521_last_login_attempt_ip	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	08c5d85e-a7b6-473d-940b-38587484f0ab
13	craft	m151002_095935_volume_cache_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	95225ee0-70ef-4ed9-8c5b-2c91566880e3
14	craft	m151005_142750_volume_s3_storage_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	89fc4ac0-ec28-42d9-b2ad-8d3c3155901d
15	craft	m151016_133600_delete_asset_thumbnails	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	d1296e03-6f4a-422c-a348-2c437b53949e
16	craft	m151209_000000_move_logo	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	c60976d7-4564-47bb-9612-05766f105b8c
17	craft	m151211_000000_rename_fileId_to_assetId	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	56b10fbb-2206-4b60-8ee5-a627a5bb8b74
18	craft	m151215_000000_rename_asset_permissions	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	0a557e90-390b-419d-ab8a-d705a93aeded
19	craft	m160707_000001_rename_richtext_assetsource_setting	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	29a76b29-7b15-4335-9ba7-3389dd00c56f
20	craft	m160708_185142_volume_hasUrls_setting	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	2e505e25-a5b6-411e-9208-305c22cb97a4
21	craft	m160714_000000_increase_max_asset_filesize	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	bbf7f3f4-2ad5-49ee-9585-9f7730627eb0
22	craft	m160727_194637_column_cleanup	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	d9820153-d6cc-477a-957d-2028f0a426d5
23	craft	m160804_110002_userphotos_to_assets	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	8b082357-2a20-4cc8-bd40-894c7869f75f
24	craft	m160807_144858_sites	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	beae3dc6-33f5-4cbb-8193-2e6cd553bd64
25	craft	m160829_000000_pending_user_content_cleanup	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	5c58d741-c0cc-4875-bcd5-acf96948e0f6
26	craft	m160830_000000_asset_index_uri_increase	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	cca0bd4b-2958-473f-ac90-225a2b4ac522
27	craft	m160912_230520_require_entry_type_id	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	24259679-a25d-4e0c-9538-d89e7e8e5d7a
28	craft	m160913_134730_require_matrix_block_type_id	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	052811ce-8e4c-4397-b120-fa5d8f07869a
29	craft	m160920_174553_matrixblocks_owner_site_id_nullable	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	41fe9606-aaa2-4f3c-94a0-a360f7ec428d
30	craft	m160920_231045_usergroup_handle_title_unique	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	8afb3f34-998e-432a-9b42-518570676b0b
31	craft	m160925_113941_route_uri_parts	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	6d771fd5-0e26-49ca-ac09-b914ce137158
32	craft	m161006_205918_schemaVersion_not_null	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	bbda53d9-9e2c-4bf9-8b5f-67f23ee6294d
33	craft	m161007_130653_update_email_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b4bd72d2-9f0b-42a2-9f96-d821c302e065
34	craft	m161013_175052_newParentId	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	aea812c4-c879-42b5-ab24-f876058c0679
35	craft	m161021_102916_fix_recent_entries_widgets	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	8f1d4bc0-a372-4c5a-a5ab-85c4f91229b5
36	craft	m161021_182140_rename_get_help_widget	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	e8f27f29-70b9-4d5b-bd2f-4b1052598c35
37	craft	m161025_000000_fix_char_columns	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	a4733eac-a587-481e-b21e-8750d1b8ccae
38	craft	m161029_124145_email_message_languages	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	11c1feed-720a-44c4-9f09-ea90f10d8bfb
39	craft	m161108_000000_new_version_format	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b5f233a8-025f-43ce-a3c5-fafb61f3a8f5
40	craft	m161109_000000_index_shuffle	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	fab04fe7-c1b0-414a-9a8c-4329a26ed6b2
41	craft	m161122_185500_no_craft_app	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	90c7455e-c36c-4db9-a618-e1f7ac48328f
42	craft	m161125_150752_clear_urlmanager_cache	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	60dafeab-ac11-413e-b54d-e482f650de61
43	craft	m161220_000000_volumes_hasurl_notnull	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	ef557854-a627-4417-9bde-8e016bd79e1b
44	craft	m170114_161144_udates_permission	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	7b39b653-6964-4c84-b8cc-63c9dc603ed6
45	craft	m170120_000000_schema_cleanup	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	6aeaac82-794f-49ec-91dd-bfaeee3e77e9
46	craft	m170126_000000_assets_focal_point	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	5c410e84-5636-4596-bb1c-370ef8aae855
47	craft	m170206_142126_system_name	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	31b38915-7def-494d-a96b-ee06dddd4199
48	craft	m170217_044740_category_branch_limits	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	051e2705-2c4a-4a4b-9507-dbd35bf90426
49	craft	m170217_120224_asset_indexing_columns	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	650fd321-e113-433c-afa2-2aa064ca052c
50	craft	m170223_224012_plain_text_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	f76fa2a5-7ba5-4e3a-a812-fd5c9c47c9b7
51	craft	m170227_120814_focal_point_percentage	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	a799bdba-ae8f-40a0-a48a-d9677b907eaf
52	craft	m170228_171113_system_messages	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	659ddc15-1b78-40a3-8cda-0b011a5c80a1
53	craft	m170303_140500_asset_field_source_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	d255eba0-fe69-44c4-8e8c-c4de993c2b57
54	craft	m170306_150500_asset_temporary_uploads	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	18ebb992-fb0c-470c-8e7d-c01a135dc749
55	craft	m170523_190652_element_field_layout_ids	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b6e95912-3bd0-4079-b34d-35acc706004f
56	craft	m170621_195237_format_plugin_handles	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	5782a688-d79f-4bb6-adb4-f8775f0b46ca
57	craft	m170630_161027_deprecation_line_nullable	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	a29108bf-fd78-4b87-a604-c56a8f5f2546
58	craft	m170630_161028_deprecation_changes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	9941d6c1-0742-4b09-a893-3fe70ff09062
59	craft	m170703_181539_plugins_table_tweaks	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	f0f7b31b-b3cd-4809-a2dd-88290d403993
60	craft	m170704_134916_sites_tables	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	5c78b853-c745-43b1-ac9c-0b996d713daa
61	craft	m170706_183216_rename_sequences	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	ff2adddb-3612-4160-abd9-8a173a169fe8
62	craft	m170707_094758_delete_compiled_traits	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	81bbc666-c73b-4e09-a6d6-ae0ca5eb7e66
63	craft	m170731_190138_drop_asset_packagist	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1378a0ed-3f34-467d-93c0-2361788af49d
64	craft	m170810_201318_create_queue_table	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	201fef3d-fba3-416a-9148-ecf65f67651a
65	craft	m170903_192801_longblob_for_queue_jobs	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	e5d2cfcc-9a57-426f-8c4a-1d6f09d4f048
66	craft	m170914_204621_asset_cache_shuffle	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	6b36e04f-b92f-445a-bcb0-e12517774190
67	craft	m171011_214115_site_groups	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	88253b63-ded6-4368-bd9e-909b3ab27649
68	craft	m171012_151440_primary_site	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	c402c845-9eba-44f8-81d8-35f8a5073037
69	craft	m171013_142500_transform_interlace	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	eab5642e-daf2-40d8-abb2-586b06b479f6
70	craft	m171016_092553_drop_position_select	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	99d74b0d-2f85-4778-b3e8-a3ba43587954
71	craft	m171016_221244_less_strict_translation_method	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	6362d172-90ac-47d3-a9e8-37d0af5419de
72	craft	m171107_000000_assign_group_permissions	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	d75fbadb-12d9-4ee8-8948-0ad856369e82
73	craft	m171117_000001_templatecache_index_tune	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	192443eb-b479-4ad2-9fdd-899563488eae
74	craft	m171126_105927_disabled_plugins	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	602c2eb4-e60d-46a8-b026-dd03a696cf59
75	craft	m171130_214407_craftidtokens_table	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	3a6d1b15-daab-49a4-95ce-a9de6ddc3de2
76	craft	m171202_004225_update_email_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	a5bcbe2c-0480-4a9f-aa6a-d5b15154ae53
77	craft	m171204_000001_templatecache_index_tune_deux	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	c28171ea-6e45-4948-9159-214abb2c4a40
78	craft	m171205_130908_remove_craftidtokens_refreshtoken_column	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	82a81275-cf5d-4c42-9638-0dc8b9b45e8d
79	craft	m171218_143135_longtext_query_column	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	346e5195-6b1e-4d52-b088-13b1a1dd57d2
80	craft	m171231_055546_environment_variables_to_aliases	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	4ffa3692-126b-43ff-95bc-c3d58f1b4b41
81	craft	m180113_153740_drop_users_archived_column	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1919d80d-fb39-4661-8e8d-eda9679b0d40
82	craft	m180122_213433_propagate_entries_setting	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	ab7bcb2b-755d-47fe-9cfa-2a32efee9547
83	craft	m180124_230459_fix_propagate_entries_values	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	44145cc9-fde2-4a71-ba5b-6fec55c30e98
84	craft	m180128_235202_set_tag_slugs	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	92e2753d-704e-498a-8539-455f08dfe9e9
85	craft	m180202_185551_fix_focal_points	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1736b946-6c3a-4623-a8df-929cd48385e8
86	craft	m180217_172123_tiny_ints	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	bcc87670-7403-4012-a798-c56cf7f28240
87	craft	m180321_233505_small_ints	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	3e5f15fc-2609-4225-bb97-0760ec872e52
88	craft	m180404_182320_edition_changes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	df9b4333-c730-46c6-a20a-3a9422913ad9
89	craft	m180411_102218_fix_db_routes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	e5bf48b0-9c77-4f90-9048-d693538bf554
90	craft	m180416_205628_resourcepaths_table	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b2b85c1d-2d2f-4c89-ae0e-4d872d1a497d
91	craft	m180418_205713_widget_cleanup	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1f91b2a2-264e-401b-8fc7-e0dc00be32f0
92	craft	m180425_203349_searchable_fields	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	f4328d4c-e8e1-4d01-bebe-e8e08252e439
93	craft	m180516_153000_uids_in_field_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	0d0897cb-24c1-4d38-8f17-64d2d5b456e5
94	craft	m180517_173000_user_photo_volume_to_uid	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	4b9a143c-23ee-474d-9a31-34203264702b
95	craft	m180518_173000_permissions_to_uid	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b8c933d5-f196-4dac-b3f5-1cef26366aae
96	craft	m180520_173000_matrix_context_to_uids	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	3972ca13-de17-45cc-8211-02f73129cc59
97	craft	m180521_172900_project_config_table	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	f3e16804-f630-454b-bb58-8e4861d1e11d
98	craft	m180521_173000_initial_yml_and_snapshot	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1b2e046a-9a64-44f7-82d1-475bf0b8fe6b
99	craft	m180731_162030_soft_delete_sites	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1e115b3e-51cd-4088-88fc-be4bf69bc2d3
100	craft	m180810_214427_soft_delete_field_layouts	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	3992e9e3-71bd-423d-b9d3-b89ded5a29e7
101	craft	m180810_214439_soft_delete_elements	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	09b52c6f-db15-4dfb-b86f-203b5a73ebc7
102	craft	m180824_193422_case_sensitivity_fixes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	797caceb-5527-4027-8cff-19358540aae1
103	craft	m180901_151639_fix_matrixcontent_tables	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	077f2556-dda8-4f7f-b2b6-5d42587f0785
104	craft	m180904_112109_permission_changes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	6ece4c01-032e-406e-a0c7-90d233944e66
105	craft	m180910_142030_soft_delete_sitegroups	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	06d447a4-d6a0-4084-8b01-23e10e862ba4
106	craft	m181011_160000_soft_delete_asset_support	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	22d85086-eba6-4adf-80ab-23136d981662
107	craft	m181016_183648_set_default_user_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	e56f36b7-c45d-4c04-a35e-b4d9e369d7b3
108	craft	m181017_225222_system_config_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	6db72982-55d6-41c2-a719-7a4dbb3ea09b
109	craft	m181018_222343_drop_userpermissions_from_config	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	73272a65-a255-46b6-acd3-584ba1e074f8
110	craft	m181029_130000_add_transforms_routes_to_config	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	c91ecd8e-6ce3-4d13-8738-eac058b31a92
111	craft	m181112_203955_sequences_table	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	af313a8f-1e29-4546-b9d6-cb115f5d1bb7
112	craft	m181121_001712_cleanup_field_configs	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	fb5e9368-71b2-4564-b9d9-2bf8f28d6eb2
113	craft	m181128_193942_fix_project_config	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1095e52d-1141-4f58-8273-6a7e843fc562
114	craft	m181130_143040_fix_schema_version	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	d5312bdf-156e-4386-bf0f-5557cc1f5649
115	craft	m181211_143040_fix_entry_type_uids	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	665fc61d-597c-4b52-928a-50e716478c40
116	craft	m181217_153000_fix_structure_uids	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	7f8601e9-60f0-46e2-8a64-4ab4d49dc551
117	craft	m190104_152725_store_licensed_plugin_editions	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	fc6895cc-a677-4302-8750-27876c39ce09
118	craft	m190108_110000_cleanup_project_config	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	3be9f626-f857-4938-b183-4aa3a2ccaf8c
119	craft	m190108_113000_asset_field_setting_change	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	ccd46f7e-f4a4-4b64-b4d0-eeb07602210c
120	craft	m190109_172845_fix_colspan	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	56066aff-01ee-4b33-be11-9133c658e801
121	craft	m190110_150000_prune_nonexisting_sites	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	0bccaa0a-b5b9-4011-9619-8ba6db1c5c2c
122	craft	m190110_214819_soft_delete_volumes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	e62f56c2-233b-4eb1-9c80-bcd32846add6
123	craft	m190112_124737_fix_user_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	67982f6c-3c48-4037-b9a3-9b3348ed0223
124	craft	m190112_131225_fix_field_layouts	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b9117642-6f11-4da3-b5cc-fd3b0afa120f
125	craft	m190112_201010_more_soft_deletes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	8c35127e-aa78-4079-904c-b7cd1ce1d9eb
126	craft	m190114_143000_more_asset_field_setting_changes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	c698a031-a025-499b-8351-7338a1035be8
127	craft	m190121_120000_rich_text_config_setting	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	cbd30a8b-0cbc-4efd-b4e5-41a3fb7c25ab
128	craft	m190125_191628_fix_email_transport_password	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	f276da43-1646-49a3-a37c-419f701e9b7c
129	craft	m190128_181422_cleanup_volume_folders	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	742f2da7-b811-4f80-bfdd-7d4e00787e84
130	craft	m190205_140000_fix_asset_soft_delete_index	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	261e5b5b-b584-435e-b0e4-bb4d36cd3d10
131	craft	m190218_143000_element_index_settings_uid	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	f430e10b-86a5-419f-b67b-b2b8e2ff6949
132	craft	m190312_152740_element_revisions	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1c1d3bc2-92da-48c6-a647-39be7196a944
133	craft	m190327_235137_propagation_method	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	86edaa07-30ce-4b50-80f3-6985cdb5faa7
134	craft	m190401_223843_drop_old_indexes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	85de2688-6b2c-43e4-8cc1-d822d99688fd
135	craft	m190416_014525_drop_unique_global_indexes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	55c72c70-0158-4e3b-a1ef-39d3a454bdca
136	craft	m190417_085010_add_image_editor_permissions	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	e04f9326-1246-46f5-803c-17cc44f179f7
137	craft	m190502_122019_store_default_user_group_uid	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	709e6a84-fe8f-4015-84cb-d368ebf7e2ce
138	craft	m190504_150349_preview_targets	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	cc684efd-db22-4b98-9614-4e5c06eb77e6
139	craft	m190516_184711_job_progress_label	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	9258f67f-538a-4b7a-adcf-1dad8112b579
140	craft	m190523_190303_optional_revision_creators	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	7983406a-497d-4039-b582-8ac058db19e8
141	craft	m190529_204501_fix_duplicate_uids	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	4519c19c-88b4-466f-8808-818aa8106f8b
142	craft	m190605_223807_unsaved_drafts	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	7584a700-e7e6-4f8d-b66f-01f3733a3fe6
143	craft	m190607_230042_entry_revision_error_tables	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1ad3667e-9641-4afa-9f0f-858b84a3417c
144	craft	m190608_033429_drop_elements_uid_idx	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b0c5f79e-8a66-4d47-809a-4f38ff9f60a4
145	craft	m190617_164400_add_gqlschemas_table	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	5a6e5528-9c0c-4d74-a359-5f0c11a704d1
146	craft	m190624_234204_matrix_propagation_method	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	0e70c4a3-4444-4d96-9e55-a0b0fbeb691c
147	craft	m190711_153020_drop_snapshots	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	48258599-a572-4e8d-8774-504a916f7bc9
148	craft	m190712_195914_no_draft_revisions	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	c57388aa-1164-4a0d-9c33-f01e5a62effc
149	craft	m190723_140314_fix_preview_targets_column	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	5deb0d3e-81cb-4aa6-bed7-4bdacd183161
150	craft	m190820_003519_flush_compiled_templates	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	8387a4b7-0bf6-4889-8717-1332aae96c94
151	craft	m190823_020339_optional_draft_creators	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	46f1c883-27fe-474b-b798-1db11814a964
152	craft	m190913_152146_update_preview_targets	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b76e90e0-736a-4d46-99a5-97bdc3241933
153	craft	m191107_122000_add_gql_project_config_support	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	43746451-9495-433f-bfa8-1ba83f46924e
154	craft	m191204_085100_pack_savable_component_settings	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	6e812928-be35-4a65-8e40-757fb7a18716
155	craft	m191206_001148_change_tracking	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	b92334c3-68c1-4ad3-91a7-a0702c751ba4
156	craft	m191216_191635_asset_upload_tracking	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	99dc3533-c611-4b70-b839-f1be9b005bbe
157	craft	m191222_002848_peer_asset_permissions	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	3c9a5752-365a-49c3-b518-4a4b5ad08aa3
158	craft	m200127_172522_queue_channels	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	f3c5873a-48b7-47e0-b3f3-e5149980e242
159	craft	m200211_175048_truncate_element_query_cache	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	3fe7a007-5268-4ea1-9173-ad6c8dce7bb5
160	craft	m200213_172522_new_elements_index	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	2c31dded-83d2-4251-87a1-3708c5db2f95
161	craft	m200228_195211_long_deprecation_messages	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	4cd596fd-daac-443b-8c8c-74cb4804eede
162	craft	m200306_054652_disabled_sites	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1f7f6d06-14b4-4708-8264-2848a62461a8
163	craft	m200522_191453_clear_template_caches	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	9bf9a041-d3a6-4a5e-b532-d0c60d560f3b
164	craft	m200606_231117_migration_tracks	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1bbf669a-4122-4e71-b030-07402b6d02fc
165	craft	m200619_215137_title_translation_method	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	85be6f47-10c6-4bf1-9956-af3d2f7b38d2
166	craft	m200620_005028_user_group_descriptions	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	6598e7e0-3abc-4951-811b-050e94f4178b
167	craft	m200620_230205_field_layout_changes	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	7acd58a4-60f3-4c8b-93ac-4d094d17735e
168	craft	m200625_131100_move_entrytypes_to_top_project_config	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	10bf8c53-bbea-4eaa-9db9-d3677c7173cf
169	craft	m200629_112700_remove_project_config_legacy_files	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	512efd4a-555b-49a4-9bd7-54a6b871df8e
170	craft	m200630_183000_drop_configmap	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	33c52d4f-4bbc-4c2b-8f6f-ef81811f0a27
171	craft	m200715_113400_transform_index_error_flag	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	c3ef08d7-114d-4e0b-9d2b-8db09d5f6517
172	craft	m200716_110900_replace_file_asset_permissions	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	359ca475-0101-4c15-b230-afa6037155a7
173	craft	m200716_153800_public_token_settings_in_project_config	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	5671110b-ca17-4b63-9978-d8fa6919a89a
174	craft	m200720_175543_drop_unique_constraints	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	d4317311-7bf1-48b4-a7ef-38e4e82d0326
175	craft	m200825_051217_project_config_version	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	bdf0415d-9ea0-4182-900d-8654c10b54dc
176	craft	m201116_190500_asset_title_translation_method	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	d2300066-7647-4919-847d-9f4faa42dad5
177	craft	m201124_003555_plugin_trials	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	ba7645a9-7b39-4220-8ddc-368f270c44ff
178	craft	m210209_135503_soft_delete_field_groups	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	1dc3c858-642e-47a4-819f-d1a193ae9286
179	craft	m210212_223539_delete_invalid_drafts	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	f744756b-2711-4ee9-af16-4c6eb4bf61c7
180	craft	m210214_202731_track_saved_drafts	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	10478543-32b9-409d-871d-d94b66cffed2
181	craft	m210223_150900_add_new_element_gql_schema_components	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	ab74820a-7498-492b-8fda-cd2de1a13698
182	craft	m210224_162000_add_projectconfignames_table	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	7d9e9f57-785b-4152-9819-31359ba18dfe
183	craft	m210326_132000_invalidate_projectconfig_cache	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	bdd7cd51-9d39-48ab-be13-62c026bed03e
184	craft	m210331_220322_null_author	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 21:09:34	96dc2104-408b-470c-af38-e570c816bc9c
\.


--
-- Data for Name: plugins; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.plugins (id, handle, version, "schemaVersion", "licenseKeyStatus", "licensedEdition", "installDate", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: projectconfig; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.projectconfig (path, value) FROM stdin;
fieldGroups.7d09d2f0-5c11-4a45-a805-a6d39128319e.name	"Common"
siteGroups.c1f0a2ee-3b87-486c-96ed-7e2d25fc952f.name	"Skyviewer API"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.baseUrl	"$PRIMARY_SITE_URL"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.handle	"default"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.hasUrls	true
sites.763c0189-f6eb-419c-9ca2-2574a743768a.language	"en-US"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.name	"Skyviewer API"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.primary	true
sites.763c0189-f6eb-419c-9ca2-2574a743768a.siteGroup	"c1f0a2ee-3b87-486c-96ed-7e2d25fc952f"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.sortOrder	1
email.fromEmail	"erosas@lsst.org"
email.fromName	"Skyviewer API"
email.transportType	"craft\\\\mail\\\\transportadapters\\\\Sendmail"
system.name	"Skyviewer API"
system.live	true
system.schemaVersion	"3.6.8"
system.timeZone	"America/Los_Angeles"
users.requireEmailVerification	true
users.allowPublicRegistration	false
users.defaultGroup	null
users.photoVolumeUid	null
users.photoSubpath	null
fieldGroups.a3b0cf34-24af-41fe-8047-b1e5b65d5bd0.name	"Catalog"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.contentColumnType	"string(255)"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.fieldGroup	"a3b0cf34-24af-41fe-8047-b1e5b65d5bd0"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.handle	"catalog_url"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.instructions	""
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.name	"URL"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.searchable	false
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.settings.maxLength	"255"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.settings.placeholder	null
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.settings.types.0	"url"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.translationKeyFormat	null
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.translationMethod	"none"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.type	"craft\\\\fields\\\\Url"
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.contentColumnType	"text"
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.fieldGroup	"a3b0cf34-24af-41fe-8047-b1e5b65d5bd0"
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.handle	"description"
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.instructions	"What does this HiPS catalog contain?"
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.name	"Description"
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.searchable	false
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.settings.byteLimit	null
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.settings.charLimit	null
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.settings.code	""
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.settings.columnType	null
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.settings.initialRows	"4"
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.settings.multiline	""
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.settings.placeholder	null
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.settings.uiMode	"normal"
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.translationKeyFormat	null
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.translationMethod	"none"
fields.68674953-a9fc-439e-8ee2-e6a9bb70dafc.type	"craft\\\\fields\\\\PlainText"
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.autocapitalize	true
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.autocomplete	false
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.autocorrect	true
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.class	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.disabled	false
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.id	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.instructions	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.label	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.max	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.min	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.name	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.orientation	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.placeholder	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.readonly	false
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.requirable	false
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.size	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.step	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.tip	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.title	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\TitleField"
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.warning	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.0.width	100
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.1.fieldUid	"fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377"
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.1.instructions	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.1.label	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.1.required	false
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.1.tip	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.1.warning	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.1.width	100
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.2.fieldUid	"68674953-a9fc-439e-8ee2-e6a9bb70dafc"
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.2.instructions	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.2.label	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.2.required	false
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.2.tip	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.2.type	"craft\\\\fieldlayoutelements\\\\CustomField"
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.2.warning	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.elements.2.width	100
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.name	"Content"
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.fieldLayouts.88f13df1-be43-4126-b9ff-75c00eccfde6.tabs.0.sortOrder	1
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.handle	"hipsCatalogs"
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.name	"HiPS Catalogs"
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.hasUrls	true
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.template	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.uriFormat	"hips-catalogs/{slug}"
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.structure.maxLevels	null
categoryGroups.43c5d827-8706-4863-a676-17bf911ce931.structure.uid	"c5f91141-fb7a-4467-8e9d-d1f025206c1b"
system.edition	"pro"
graphql.publicToken.enabled	true
graphql.publicToken.expiryDate	null
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.isPublic	true
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.name	"Public Schema"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.0	"categorygroups.43c5d827-8706-4863-a676-17bf911ce931:read"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.titleFormat	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.titleTranslationKeyFormat	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.titleTranslationMethod	"site"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.autocapitalize	true
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.autocomplete	false
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.autocorrect	true
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.class	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.disabled	false
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.id	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.instructions	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.label	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.max	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.min	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.name	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.orientation	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.placeholder	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.readonly	false
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.requirable	false
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.size	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.step	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.tip	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.title	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\EntryTitleField"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.warning	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.0.width	100
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.fieldUid	"fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.instructions	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.label	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.required	false
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.tip	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.warning	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.width	100
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.fieldUid	"68674953-a9fc-439e-8ee2-e6a9bb70dafc"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.instructions	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.label	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.required	false
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.tip	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.warning	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.width	100
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.name	"Content"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.sortOrder	1
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.handle	"catalog"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.hasTitleField	true
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.name	"Catalog"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.section	"32b433c2-8fa2-439b-9678-d48e4f929b88"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.sortOrder	1
dateModified	1621465159
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.enableVersioning	true
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.handle	"catalog"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.name	"Catalog"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.0.0	"label"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.0.1	"Primary entry page"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.1.0	"urlFormat"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.1.1	"{url}"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.2.0	"refresh"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.2.1	"1"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.propagationMethod	"all"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.enabledByDefault	true
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.hasUrls	true
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.template	"catalog/_entry"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.uriFormat	"catalog/{slug}"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.structure.maxLevels	null
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.structure.uid	"ae4c1bfa-0825-4ccf-b090-4c79bed024bb"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.type	"structure"
\.


--
-- Data for Name: projectconfignames; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.projectconfignames (uid, name) FROM stdin;
7d09d2f0-5c11-4a45-a805-a6d39128319e	Common
c1f0a2ee-3b87-486c-96ed-7e2d25fc952f	Skyviewer API
763c0189-f6eb-419c-9ca2-2574a743768a	Skyviewer API
a3b0cf34-24af-41fe-8047-b1e5b65d5bd0	Catalog
fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377	URL
68674953-a9fc-439e-8ee2-e6a9bb70dafc	Description
43c5d827-8706-4863-a676-17bf911ce931	HiPS Catalogs
d250222b-10fd-487b-a94c-8c7aa5241cb3	Public Schema
9d2a5fce-1549-4e9f-8205-f1527f5064b2	Catalog
32b433c2-8fa2-439b-9678-d48e4f929b88	Catalog
\.


--
-- Data for Name: queue; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.queue (id, channel, job, description, "timePushed", ttr, delay, priority, "dateReserved", "timeUpdated", progress, "progressLabel", attempt, fail, "dateFailed", error) FROM stdin;
\.


--
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.relations (id, "fieldId", "sourceId", "sourceSiteId", "targetId", "sortOrder", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: resourcepaths; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.resourcepaths (hash, path) FROM stdin;
90fce2f1	@app/web/assets/updateswidget/dist
d30bfded	@app/web/assets/feed/dist
21e97e34	@app/web/assets/editsection/dist
84a4f0e9	@app/web/assets/fieldsettings/dist
e7d8ed31	@app/web/assets/admintable/dist
9bf97c07	@app/web/assets/graphiql/dist
7a10672d	@app/web/assets/cp/dist
e599700e	@lib/axios
32674049	@lib/d3
9ff8f76a	@lib/element-resize-detector
2af7040c	@lib/garnishjs
9b450f5c	@bower/jquery/dist
104b0f19	@lib/jquery-touch-events
8acaf821	@lib/velocity
c4636384	@lib/jquery-ui
96ed57c9	@lib/jquery.payment
17ef33db	@lib/picturefill
43911e5f	@lib/selectize
f073225	@lib/fileupload
49fd5ad5	@lib/xregexp
3fb1d032	@lib/fabric
3a40d32	@lib/iframe-resizer
cf94edaa	@app/web/assets/userpermissions/dist
e35f80b8	@lib/vue
6e7ad651	@app/web/assets/fields/dist
b128fb78	@app/web/assets/pluginstore/dist
49bb3a1f	@app/web/assets/editentry/dist
d170c583	@app/web/assets/utilities/dist
760202a0	@lib/timepicker
ae46a09f	@app/web/assets/recententries/dist
87757f71	@app/web/assets/craftsupport/dist
691df81f	@app/web/assets/dashboard/dist
\.


--
-- Data for Name: revisions; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.revisions (id, "sourceId", "creatorId", num, notes) FROM stdin;
\.


--
-- Data for Name: searchindex; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.searchindex ("elementId", attribute, "fieldId", "siteId", keywords, keywords_vector) FROM stdin;
1	username	0	1	 admin 	'admin'
1	firstname	0	1		
1	lastname	0	1		
1	fullname	0	1		
1	email	0	1	 erosas lsst org 	'erosas' 'lsst' 'org'
1	slug	0	1		
2	slug	0	1	 catalog data 	'catalog' 'data'
2	title	0	1	 allsky hips catalog data 	'allsky' 'catalog' 'data' 'hips'
3	slug	0	1	 temp evrzpzgcpethpqmdatvmjwitqytkxncfwgaw 	'evrzpzgcpethpqmdatvmjwitqytkxncfwgaw' 'temp'
3	title	0	1		
4	slug	0	1	 temp ignhzbtrxqwizdkionwdqgqexnhfusgiqkdj 	'ignhzbtrxqwizdkionwdqgqexnhfusgiqkdj' 'temp'
4	title	0	1		
5	slug	0	1	 allsky hips catalog data 	'allsky' 'catalog' 'data' 'hips'
5	title	0	1	 allsky hips catalog data 	'allsky' 'catalog' 'data' 'hips'
\.


--
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.sections (id, "structureId", name, handle, type, "enableVersioning", "propagationMethod", "previewTargets", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	2	Catalog	catalog	structure	t	all	[{"label":"Primary entry page","urlFormat":"{url}","refresh":"1"}]	2021-05-19 22:50:41	2021-05-19 22:59:19	\N	32b433c2-8fa2-439b-9678-d48e4f929b88
\.


--
-- Data for Name: sections_sites; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.sections_sites (id, "sectionId", "siteId", "hasUrls", "uriFormat", template, "enabledByDefault", "dateCreated", "dateUpdated", uid) FROM stdin;
1	1	1	t	catalog/{slug}	catalog/_entry	t	2021-05-19 22:50:41	2021-05-19 22:50:41	0d4011f3-3967-4678-9f47-a3d81dd80625
\.


--
-- Data for Name: sequences; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.sequences (name, next) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.sessions (id, "userId", token, "dateCreated", "dateUpdated", uid) FROM stdin;
51	1	JqynJTmrxNozbXzL9eHvWD_YU_g5QC2IKZKiD9Hmmjw8NGXIhGclTysycSvMj90T9TUqf2A9YCzGRsk5vC6qiSWpFzg1OV9pLufd	2021-05-19 22:03:33	2021-05-19 22:03:33	f068a72e-4c66-44eb-b26c-8297d2bfdbe1
33	1	OaHafL2UX7MXtwh_-NNfaMcVRB8_bHd4TvuXg7HIBLOpN87KWYyjpHeWQTdPIchz3IaonzNyQDKpbrJMwt-e73lDnLYHcynARkUH	2021-05-19 21:44:12	2021-05-19 21:44:12	c6f7432c-a5f3-41f7-a726-d0bbd3c4fd3c
34	1	oltYM-1bffsB_GeUqFtYJ51nBPmtOfrB7Nxch4HTS1yeEq8EFulX6NbjQuSeNDG5JhkTzvV7sp16XGilX5ZyFUyQw1BrANw6m0n-	2021-05-19 21:45:16	2021-05-19 21:45:16	d3261b72-1b0a-4c98-aa5d-ff9b2b1a5a62
8	1	MTzJljcG4kYxISoRTT38FmmHiGOcjG8L095Zuy4Qj6g072vt78Ace-Q79vRFMGoCHycD7jgz9fEQx_OVCCFt-1OrNISh8ScDOeaq	2021-05-19 21:17:50	2021-05-19 21:17:50	bf87c58e-1a10-40a7-b659-07dbb07453dc
6	1	AtTLFbvI-gQ-cT500k22Vb-LUhb_Z346J2J1jk2eVUjp48PqC1_gN61el_PCNX810SX7RJ-VIzFalLZYdmQGQdCVY6cxFv9Ypthr	2021-05-19 21:15:20	2021-05-19 21:18:22	00a34c23-9064-4c4a-b7f0-84b9f7b8f16c
35	1	gEvlbAoswdxvV8soXoDM3ZQnwIYqbfNy5yGe6M_BjBOuAZhh3RCBBTkBayyy5Szz4SMmya-vCl18Dk5YpmWhR3lBbm1MER5VnZI3	2021-05-19 21:46:22	2021-05-19 21:46:22	32ccb7a2-40da-4d88-9402-c19b1bc83aa2
36	1	lQ8-285Hg50Pkbfp_q9EXhL886mXaFOJmikyiXxGGPUrrg429EvqSmTzGx0sK5PF3XZCAI8C6pcgxCMZUr9DEideuoeDxfN9RHaO	2021-05-19 21:47:23	2021-05-19 21:47:23	c52d3b0d-d0ea-4a2b-a45d-92c95d931ea8
37	1	TyEbxY8HVO3rd33mnuEhTH4-8N2c0rdTMU6bKRy_cRH7ivw4hLRJG-OMzSGk269YEsuqhSF5YcjjGcqMS0IbkAJ_qlrXtBF7wDkV	2021-05-19 21:48:25	2021-05-19 21:48:25	2b0f2fe2-a316-42d1-adfe-dea24fff4eb6
38	1	9rActTJc1ar2cERz6I8jVkhszSqnqVNxOJ1njybP3xqv_ZPuorlCNDrsgHvlmvFzx9yG4wKM61rvX2AaCRH5BoKAtr3I4_UZs3zU	2021-05-19 21:49:27	2021-05-19 21:49:27	78d5fd81-fefd-461d-9718-b6d6209cb934
2	1	p8y5n_3xqSaNy5cTQS7J0P3uDkdQiYkrewaiBj6euOB_DuycQLMyusx5oe0rctdV4Q3i0j_95f1QznBTLCiMD7_cAcf2Bkxoscm1	2021-05-19 21:11:16	2021-05-19 21:11:41	85cb12fb-fd2b-4764-816b-5cc41049ff5b
9	1	Px_F9Z3RjGvDLomuH-o2O4CEHG7sTKvcddtzZHBTiZ0wl-CyP5c20s0jhjhWGoR4YJDoYRPoxXxLEs2gu43irxACsvsj8Hwpuz9M	2021-05-19 21:18:22	2021-05-19 21:51:16	bf34ea6e-43e2-4e33-9329-394423f1ea59
3	1	0KzPqCgP-HRQLUhZ18WnSxBPoxPhHvVrPf-k3o5ok6cJ4aOwAOBtO5-V14F0GUaSnhv4I1Xkksh18r3SSlgw7Ip3FXpSb5HpBC6S	2021-05-19 21:12:42	2021-05-19 21:12:42	18a09ff0-e912-459c-a189-79f0dd473dfe
1	1	XAe7KwVyFuXYCpToBHNYHHiV45KtlD-C5gucwcltRjdP6yEKMannIw1b6CkxJxMeymv9ftXsDU3W734Ec4O0PRcnJklY_b7yoZ6l	2021-05-19 21:09:34	2021-05-19 21:13:18	c2dfba3d-0bae-4ebb-af90-5b584e976f86
39	1	DbRi1GNExH7rjoXkoGTlY61DSWmub_yTh47cf9RMd8U3KOXo1KeoAahkLBuQHTGfFv-ZWG9LFcD9-qmEuUQGYLQRLkBcprOvRsZY	2021-05-19 21:50:28	2021-05-19 21:51:12	3b72d84c-ec4f-4111-8cc6-b29c0b7aa950
5	1	ZyjmBgO7Rj2zM0s0KnbKnCud0a3KcWUgLAwytPCwyQEMqsbi2_sojjpd2NlpX8ApF7yQO6CEkyuGjENjyC5kO6istl0Ez6wm2Wxq	2021-05-19 21:14:25	2021-05-19 21:14:59	39eab4cf-fe3b-4fc5-a1f4-a1bcf83847e1
4	1	HZtBI-zfXRaU6_Fbl8i6gzjP9KWO-cCN6BvkALapVA5YO_DNbVZpa6JWCbvtF2hwbgidH5RbQ8c9BcRmlGZ-uhs7289SnPURBSD1	2021-05-19 21:13:18	2021-05-19 21:15:20	3341579c-f7c9-4d90-8c23-c77cd657198b
7	1	PXY6gmOBIYFX6c29lll0hqIlAFohKVYDydFmdaG7Vp7f-GKwV_MbKe6sbWXT_e5dA---GQtGvSy_uzjhz5_DfFXJO5MX6iXBL0Ul	2021-05-19 21:16:47	2021-05-19 21:16:47	8d8254ed-f50c-498b-b1f3-40a13fc78b8b
20	1	j2Na-LERu1Cmg5ErWkC4_HlHQJgj1RKEIZQhwHg1Q_CCajkXHKAK6FVqCa6fRZC9z4FYYIWQ0FhboImUAnb2lDXjnMwuiedFWmSU	2021-05-19 21:30:39	2021-05-19 21:30:39	24c5b478-499f-4796-b310-766b545f0644
10	1	3QjAzE3TcHWsYp_xgd8IfdQR0AffC59F4u8z55Ro6Gm6Vh37jJEMzyPsIIhhtpAN-5G14NMPrsxpEmr01dr3ivDHK1lsBI_s3Gyr	2021-05-19 21:20:08	2021-05-19 21:20:08	40760b5d-ffbf-4625-b618-aa16d91f2454
11	1	CPSD38UB9PgxeaWtQIBjmaAhqsqtfmOIuz5NBnrEZJP9zcDc9IUFwKmkxJbH2zLEiHk2zsrz-0DslQaww_UkKs2B-lcNeLKwyEsn	2021-05-19 21:21:12	2021-05-19 21:21:12	e8eebc74-068d-462f-ad24-2e6f0112c755
12	1	UYONEUqXNZYXw2hMI2Uix9WyG2eheFmNqjqV41LUqtbKLSGzbRTgerIfmEOH8bTJ19qUmFK-TO9hNTqyUThJCr7qLsUFKNb0PEXm	2021-05-19 21:22:15	2021-05-19 21:22:15	625ca9bc-048f-4eda-9151-40b5e862fbe1
13	1	1HyUdTilyPtqruJj41oeo1jxdI0aZi-GtC36kvVjaPtBcV0w1Kjrd0QOCei76VRC0GpBSYqcDjsMbqm0Yi26X1J7ydjtUYPq6etY	2021-05-19 21:23:21	2021-05-19 21:23:21	613e01f9-6e4b-4d93-8a87-050bcf9e4276
14	1	vtQnlPuVTJv5UmZyqhxHaYEluyT4voihDlfrb3ES0XmOe3NnNZZPag4sN7m9lIZEAiTgHUYIE8EzCTObWAZyt31WvVBmPUHy93HE	2021-05-19 21:24:23	2021-05-19 21:24:23	74370c92-47ee-497c-b922-ef0097f25339
15	1	fwPFNQ3s9ofWSrkYNyKnccFw9-yqIGD_w0RpD0yo8O-e1NvNaQi7lL1S0DzMttrVEsZ2Rv6gUlaLC945X6oMujFSBGPsqrnYXS88	2021-05-19 21:25:25	2021-05-19 21:25:25	d126e1b3-7af8-4897-9d61-33e2496b5f23
16	1	SF4j0tfqGQ2ShBtJ7GnSKhSI4_A7tNaVDaibhRvw8Te5iO-b1sunJxgiAcrnyPxW4l5kT0msdcRuQqCGA2QzNFQ1yFqSlFeTshGT	2021-05-19 21:26:26	2021-05-19 21:26:26	6deb63ce-06ef-4fbe-ad5c-18e508d4c445
17	1	mY8rZJe6eFVGicM-4trI_HPApM0f8n8t0GeXqbCC1z1ieZFz2Y7pNlzmUnNeLW49F68sJ9R7KJwPAOGxAk_mGgETCKegL-wYzaoH	2021-05-19 21:27:27	2021-05-19 21:27:27	96f083e0-dabe-40f7-8129-8c0bc8b97d8b
18	1	bdkLHhjG2r-L-KC3YAF2K8-wya2WfdQpxFOGYgCVtpf1K_iE9VGxbYTdMImer9xYovQxR4oCfDy1kwg-5ILK6v7Ampk42whXZ_HA	2021-05-19 21:28:30	2021-05-19 21:28:30	9fe81961-a087-4367-8ec2-d99d8860a99e
19	1	RfWdYcUCbfNFZ9Egojm9aAhlIOc9ma3m_P2-jDOBaYlxYFVYF_AtqpQcXD6OU4wIdhdm-8-GohcVJKwuUEk_CwgF_VR8KO8QZhzh	2021-05-19 21:29:34	2021-05-19 21:29:34	b0c02d52-b955-4a90-a7b4-9d2fe547d15d
21	1	pF0c4wkmIJUJWKdL38497UnAS7BTye8L-Mk3r51pG4nXKRBmyENPa_xkjq5WvnBdCbzCMYJi-hw56yf880Sav1PIcx-81RkoiSii	2021-05-19 21:31:42	2021-05-19 21:31:42	22e91bf6-ab5f-4878-bb4b-5269fc3c3588
22	1	Ab23gSE79YLH2qPRxOTMTkATCU57sUQ-DaCnP0qSMRdBs6Z-yPlbX2VSQgIDyQe4mIsPOtJqPAe5qBOI0mv8Dr2NJo7cOMxyDeRN	2021-05-19 21:32:45	2021-05-19 21:32:45	2e5ce939-6e64-4019-97d0-0a12e1891970
23	1	XDFogkzJjqEhcqmEnLpsLlzjFvyvP23zhI5VtKc11CA7QGs_o_XiMed-cbkf1_1CTdtuoUmIwj2sfjn2B0ug_RX-RAIHNmJCBpup	2021-05-19 21:33:46	2021-05-19 21:33:46	0b62e955-bd77-4090-bb8a-1cdd53456886
24	1	EMfAoxq4jW2oO1gWbf7G4j2eZeVZOSOZCKGFyuv5-0qG-39L3P0DtH_OgjAyChaZNwc-z4JPpTsliAPDgXkdPqQxpR1K8WpUQt1r	2021-05-19 21:34:47	2021-05-19 21:34:47	9bb7d42e-9df9-41ef-97b9-56605c594711
25	1	cY7gNsSFpfuXEP56xvvocrWl11TRhUYEUPgCc2fXvcdYM_yqpoQH7pt20hxptHHJ22wkpttSUlYjdI69ycV-dWCrdjlW2hLUP_9H	2021-05-19 21:35:50	2021-05-19 21:35:50	8fb63d3e-882e-41c6-a20e-0c4708bc27e0
26	1	rrcPXu67xpPfXQPZuUrbqCHbtUENuEelMyk-dRRYr9JOwKZ1wSHpXNtolT-JMgxbYIUL6nf_PQR5I__UNqiSv7yo0FLB4d_43wMr	2021-05-19 21:36:53	2021-05-19 21:36:53	18248bd3-59ca-44c4-bca7-e01a3b3b3c7b
27	1	P8pv5toE9T8uVplTgtd3w65ShKLyC-vidD3zbfCEcVgaMFUXtX-2CW6KwUSTSwbDZW5IBLcr8CGcO1LcKEvuucwVxhiQEeUfD-7-	2021-05-19 21:37:55	2021-05-19 21:37:55	a3fda5bf-0923-4f5e-b21a-d2f2a7d287c1
28	1	n3wNiTTZfQQyRXyjlIUxBu1fx5GhdN7T8xbyCIPFUcBkEeiNcsSIq0n-v2XAK5oB_P25SGT7GUGF_T5W7RJWayNsLMqN43bC6BrC	2021-05-19 21:38:55	2021-05-19 21:38:55	64d35233-21ea-4edf-ac10-a3e2cd5dd605
29	1	6n_8r6Q17G1jclTHBmT7n2xRzXTrdsRdIze1SyqHOWqbupvDrU11xT2Tv9BzAe_Ncb18gTwdHD-YjdkCipjVUI2V6MS_nqET5do3	2021-05-19 21:40:00	2021-05-19 21:40:00	a40be560-609d-4aa3-baff-4fe098196eba
30	1	Wg7mBrS4ITQodk7y6GrJpMMGfwYFe_f5dKuzBaNjDUunr0Sz_N3SkyQoduGk7w8Gy6jzz4Ty5QIb_tAH6j6Fk1XoFgQtrtCP71fK	2021-05-19 21:41:05	2021-05-19 21:41:05	10631611-f999-4e4e-b9c6-7324ca510a67
31	1	GXydMro0UN59Cj5fpILdrXWaQcxl9c1TRXlGVvz6vgb8UIlw4co2jyPD3UqSgRrxxXfBtyAYtH46NQbxFdbw_UcLnXurDagadc00	2021-05-19 21:42:07	2021-05-19 21:42:07	4495cde8-06ba-4e7f-9743-1085c834e60d
32	1	zW1suAq3NCYJpT2eaH-_o8aaITrnwC70pU5VkTPyELVyKbQZXuRnBp5kmDkRT5RwIObm44H1MxWxLyMPoM6yiPsOWWZhSLOxoLi-	2021-05-19 21:43:09	2021-05-19 21:43:09	33069129-214d-4e14-9566-a8406f6bd052
52	1	lhj-KHnHzQpAchKmydw3Q7MXd0MnL-jYHa42ysrZzHZPy2Y23lsk6m2b5A7g_bWbAeCIWRcBImQAMOOIy3ZiKcXUynNU8KCaxRVX	2021-05-19 22:04:37	2021-05-19 22:04:37	493c0759-3c51-48cb-9e17-316654ea8b55
53	1	a8Id0-0xvdNFIaZdlN3RVAvIqe6bBD2XX4IKkUX-sljQezbRmqMy3GOfE8YSA2g-Ewn_-lvTKsLlcNgOmIjHOIwOJ3h77eY89dfC	2021-05-19 22:05:38	2021-05-19 22:05:38	ffeb7477-6ef6-4f7e-b75d-82a539ea606d
54	1	5t9xQeMqTm59U0OID0-LkPbGdql26GuWlOQDg9nD5cI5u1kTG9AkiXQcwqQ7L9-SLm9gQYXrTjCWRHvLVWvGfPjYJlcWTUAzlrQK	2021-05-19 22:06:41	2021-05-19 22:06:41	873650b8-00bb-466d-8ba0-9fcbd7a467b9
55	1	POuTpRxPKCuodnVKEri1Tw-tYVkA4s5oryG5fmMVSj7QdPGyqOTX13OvonQybJKB7rlVDrOx3frPiSO5IJXDc_xi9pwAD1wA9Cku	2021-05-19 22:07:44	2021-05-19 22:07:44	85326df2-3464-4ddf-9fe1-f5066b5b8769
40	1	HrYW0plDneJJAt6CEoj2gJjZ4VxtdxJdooulQhExf39H_34BVafnr1knq2AfmvMhUylt4dR_ol3VdI-Ro46ejGJHgOnE-Jy55AiA	2021-05-19 21:51:16	2021-05-19 21:52:53	2cf41e4f-067a-4e15-947d-e08be4d708d1
56	1	cN2yo-J-vcKquHzC2zK5hxkLm5ZEVyx8DgxxpGKxQe6VnrncZ8vSB8unGntrOmBDVQwnFeOcr-frdbAatLSRaH4Uu2iA9AIwAXx1	2021-05-19 22:08:46	2021-05-19 22:08:46	a81e4490-6cac-4378-893c-4fe30255190e
57	1	1Wt1T-pjuA4yh_Go4KmoymG8-RiIgctz1swE6BdoCgSg2iSmJJ0jlxGp6TyXYwn-pnD1OlhC9yJKo4lgk-vQkNPre6MU3D9QNdpN	2021-05-19 22:09:50	2021-05-19 22:09:50	2ddcb07d-02e6-41fb-9340-3f2d6ae2baf5
58	1	u8w-qIbwoDsM9VZmlzJcIH_KYgbXBwc3jeu5nPOTfLhYOQ2tZZHJ62rxn1lhG7c4rXMBnrQOZkzcEhJvdFR3j11A0ty53DCyONdv	2021-05-19 22:10:51	2021-05-19 22:10:51	1af377b0-d1e9-4bfc-a3bf-adfd5363421a
41	1	dPNcXK3tG3kpMgnKCWIO0sk_4ZZjtzJ8nnN3geWL_v3IKLAuWUNw1k4lANBZQLz9THgnK6uFOYv0htoqx8QxDHSOpKg00PUaf_9e	2021-05-19 21:52:53	2021-05-19 21:53:18	6b8f5708-5dcf-48e7-813a-33b1736c3b58
59	1	FxzoVvp_3VcoOBb86rrWpN1IXJdQrvn5ChUY4LsMTtGpXdTQxM9OEmJipZ3M5aSivsb7jpjk1JGUb96va7XgXavtoDDbjTX4Fq3t	2021-05-19 22:11:52	2021-05-19 22:11:52	53b22c8b-750a-4a4c-a9aa-db96ffee4efd
60	1	h6U1GaH849yusY4QXJJzNh-DZrplhOxsXdDvI_Cbi1EIi5kQSlWmdmI9FDVzGzJR5O5RaH3mrC4xoJ_jlgFuC7OZsTJnWJsa4-Ob	2021-05-19 22:12:54	2021-05-19 22:12:54	88a73554-a8d8-440f-8699-1fb2fea0a78b
61	1	pAgT7bf0EaixuIxW5WQ2-MpZfG7a_Um64YP1mRqvetEv0Kl6oujRRXpQktyox8kW6vixbRgqK6WzqYFPrCnHmAdYsQTMucgIsx0v	2021-05-19 22:13:55	2021-05-19 22:13:55	d22e8c48-5b44-4fdb-a7e1-ac6c0b0b0a50
62	1	8gP59SWGpfalulsPQgPoEVnoAxLNSqQh0SJI-U4KSEeY1PDa72dO57naEzUda1vpp6VdAzP8T6fALAGTiWH5G3cRRyT27ybYLS-N	2021-05-19 22:14:55	2021-05-19 22:14:55	658dff2a-bace-47d5-be92-db42b96a9891
42	1	Pi939hzqNaNZh8xwofkrJvyIcmsLoc6vGVIa8ECx8V8M8tQZi0AwQcwrsTrYSeE8P_KNt-wV05P71dtvVx6_fRl1aIGyM5QIw_H0	2021-05-19 21:53:18	2021-05-19 21:55:17	6910ddde-6b71-4b2b-a288-90aac49c99a8
63	1	tRlFAYik8R_2Zn7IMaom3JEFW6LbPpHACw6KiM25awTD7NiPyTrkJIVi374as3hU7zZZmHsiAI2Y_urQyeyt05Zx1MlbJwSOwiwy	2021-05-19 22:16:00	2021-05-19 22:16:00	0aeb20a6-142c-4a26-86b4-e9352b04296c
43	1	bG2PpAnyF-bwN_DawYvwsaiPajyI8j2ThDRcJZqR0ScIHwGEKT0BgtVTNcnmFh1sLFobBpSuQy2CDGCy6MknFWJtkXCp2VBG1rI4	2021-05-19 21:55:17	2021-05-19 21:55:27	ebbf65ac-80aa-4c49-a6c8-e5e2076e4093
64	1	kiu5Ujn2keKTIkn-M92FHaGeDqhuq-fZ6yWfQAoqChBJz2SiZzgtCyDBbD5IDpHOs2x20Xlb8DzouPjms7tyxlEdIvKtnRl3v5fK	2021-05-19 22:17:05	2021-05-19 22:17:05	4b516fca-adb9-4190-8a32-f2ddcd50c58e
65	1	dhSBWThH2xUqgFVZRNf2xx9-rlIFio-Iud4rTrWYvXgUjQyWg4kpr7RXLUZJ-k3vl17D86ZLTmKxhIg26TBKg_CU8tsIPElFz4tH	2021-05-19 22:18:10	2021-05-19 22:18:10	45b01a97-0182-4780-ad93-8886d2a5f5cb
45	1	oT5fFeWYzDHqKl9G3DdJ5n7eNb8vTkbzlJC5eSo_ssoawsHMuWq3-rklGuRlPxXwEbSY8egqIxvf9LjSIn8gnKxg7WHtznWXMCi2	2021-05-19 21:56:29	2021-05-19 21:57:30	74473998-c5d8-4bfd-943d-a92ecbb1d885
44	1	3Q9B6KYX3XwbNyZCScYv-hFNuUSQ9O616EWwl1AO4imk-cc4F6UQX1xnz8SlMi4gN4xltXrBR5OVXZtRB2LP-PNIof-aTetZ8abp	2021-05-19 21:55:27	2021-05-19 21:57:49	ecf7e851-0fa6-419b-8938-b985074320ad
66	1	mBsx0CW1oz00SV-f-Fbr3lBgdBdye4oQZOsUQuyd4zqnpbzD5jGXhSO_Da9A951ITesAYjFJ4BRKPDSrZZjvRXMHdTfEaDkdhj6s	2021-05-19 22:19:11	2021-05-19 22:19:11	237f3a61-636f-4063-91f4-fe311ae6c8cb
67	1	lBXNo_M1GWAR43WP0br_WEvm-D4A0bQbefeIlviHGHPjtNQqXTZXu86LtDutNZNTqUk3PXfeIGFBgmxsjcpyci1jjVMIGAJDR_FS	2021-05-19 22:20:12	2021-05-19 22:20:12	762e4cae-6029-4939-aa8a-2bbf178e5a28
68	1	VFGzGIEVOTkB0ofHLG-q_rXoUrFjQk2HFMr4LaRgHH8sBgR4EPYpJGi5UxRS0iHLCxpG48h1VOveSaLDw2ylMiIz_m5P4DY7XFzS	2021-05-19 22:21:14	2021-05-19 22:21:14	320cb44d-5966-4154-9ea1-84ec9d316f62
69	1	zE_nnazjN8fuMS4mJk7oGyOrjVy9ox03LTtvQypftGx2yRcbIjKN55tlyj-ne8-kGEWtEWIDa9MYvPxDLlDOzWt6mqxq6_6db5yj	2021-05-19 22:22:17	2021-05-19 22:22:17	b4e12c4f-16b4-472e-902a-5b39451e34bd
70	1	EwcTzVTt0c87SQlveKD1HH0pb6hNnXjOUaywzmqSKkGakVLGut6vwzoUqsPj51C91RVjFWlGAbb1dAPp6hBXuxTuH2dVEMFMKGRs	2021-05-19 22:23:21	2021-05-19 22:23:21	325dda2a-aef0-47d5-996a-9eb42af8ce64
71	1	38XPSuD0Us5F2vdEijbmJJpaQz_VWRcJ6BzqaD_Y5YwaDyTbww5JCArhKlEE4Tc013BXGp20KPHLShT31XYkNMs9xL3lnJFOlKcS	2021-05-19 22:24:29	2021-05-19 22:24:29	6bf69f2f-9918-427e-bd4b-d08c56f13256
47	1	ukwBvoYwv11loKdlks4hjUXqaiZn6eWHusUFJDczeAzNgtQR-ZsLwkEDQOsQcENk5dW5ihTl3pD3VUXz2gdZA7MfLyzqql-LZ3cj	2021-05-19 21:59:23	2021-05-19 21:59:23	0c028968-8bf2-4c49-a898-2652d3899370
48	1	gDqRrSaZcve-jW8uavsdjqs9LuAAStHe4hdc-9A8SC52_ifhnhylKRNBLXYaNTNdyRxfsGdE5VbKWJ8iohTggavuSXt2Ub-DjJjS	2021-05-19 22:00:23	2021-05-19 22:00:23	a486435d-d9d4-41b8-bdbb-718abb0b2645
72	1	I7EyJuj2TN9DyWKpoZA2g9bQI8Zs-icmTl4TodYv4QM1jb4mPibp7oz9Y_JVKMVrLtsDPrO_bKE_3Vd3EJkvTPAghQR3tohw0_7j	2021-05-19 22:25:30	2021-05-19 22:25:30	e0e06d8d-7a8b-42d2-8c17-75ad0c63309c
49	1	XoERxmltt2BPgpuMJZMpw8U-m6FPfvZzjY7rCSX1NYU4OqPwP14l0x5g8J5s7YjIsbJ0bBhRl1-1UBOvjVWSZU5sfYfipQCTf3RM	2021-05-19 22:01:24	2021-05-19 22:01:24	5c3cfb79-fea9-4794-b4b5-edec1d841559
46	1	5cHejMqLRvKNUGDNhriypjvctmUvaEhg9ccshVn6uk67AT0jXMeD6TXuetl-S_8vL6ALw27CYEVe-XN7o66QiytpNx1lr_IQkEyz	2021-05-19 21:57:49	2021-05-19 22:01:41	74ba5ae9-1ba4-4264-94ba-26deabfb4095
50	1	ugLr7eYg1epu5eAkp23rnVueG-mgf8UVC-EA1Sys-PLL4phfKXp7WwhSjCGrb0liIXPhW-SCumHwQoDNnLr9qAQrMOd7SDfvhWEE	2021-05-19 22:01:41	2021-05-19 22:26:03	6779cefd-13a8-4755-8736-044b8910de49
74	1	NEVyfUGfu3sEH_wPrLbdsqZw0j5AjjzUp-CEf7-FHreVIh7MA0Vpp8OJ0mAWpRE4cXhB3TFq730uorGcTlga1x_PEvMAU2TyfwrS	2021-05-19 22:27:10	2021-05-19 22:27:10	6c6476f3-0435-4685-bdfb-0af2ec2ea3dd
75	1	iK6cU5DyDsZ9BnoJydeAu4XrslDyu7q4XdH6eZiM5I4VaF-ejuTp8dA64A2Zo8Wr0t_AzFVXO_yTGTO1VWAPuDelYBfrQLz-NY07	2021-05-19 22:28:11	2021-05-19 22:28:11	69f559a4-4ec3-4f4d-a78d-fd5b156c7640
76	1	SkeVm8BdMiVoXKp_d2jB45p8C509bUEvqg9ddAGyM6l8gXxKhRE3drSTEOEbnffDPbjJzd44_84EvFEjb320iKQs2D1pUCAywBHg	2021-05-19 22:29:12	2021-05-19 22:29:41	2c6e7489-453f-46f9-b0f9-a069a954ba8e
73	1	JU_mVczexA58tWd8aGI9BH86wcr_GPy5EFGrhIEUQqikzz7_P9qo77zx0rWXXg7fzBhkT3K5oicXX-DZBiUL3I7QeUSLeI5YD-g0	2021-05-19 22:26:03	2021-05-19 22:29:41	ff3f905d-d684-4395-af4b-f537969c15a5
79	1	0ShsWqxvyvtSVXxosG72Lne01_CKsrKvdHMuqNVSX65kIpi8w6dgU3CYrwoVJDs7H9WBwApfufF2IYL9DQ97_s5OQWkNlcHSMQLB	2021-05-19 22:32:16	2021-05-19 22:49:10	49f825b9-6e9a-4453-80c3-973c148daae6
78	1	8gCF4d18I7jTS87vX-0pNc0PBbmixW7Z1PnqAbZr31EQ3OIB58c9RcKC0-yn-DkxddwIOuH8XWF20P5PDkE8afWJ54QXBv2UwLwz	2021-05-19 22:31:15	2021-05-19 22:31:15	10fd90d2-7df3-4a0d-8836-4f58f3e3d59f
77	1	k85YhleFn7PscWP6fSRNrrA2_gtroBfa2k0IWLKGmgX3LoeKK3rhsPPM7lfjNfdut_wx8qbwz_ViOlqFGv7jOwRQe109flFNXFOu	2021-05-19 22:29:41	2021-05-19 22:51:07	72158d07-4b2c-455e-8bea-1bb83332cff1
80	1	ceLshczCsoEwKwtrEiAFsQ7ycEsN1tsbpp_M84RXCVNmuy6KOwTCjSGt4lYDy4zF48l7GjDyZmaSGG98RW60gWXbL2uBq18ljDoP	2021-05-19 22:49:41	2021-05-19 22:49:41	a348777e-44ec-4a5d-80ca-20fc48bb2c4b
82	1	-yNhwLTL7rpDKtJKna3_ZxqS0cXZVHnDwSq4xj7FJe9QoWlXjlp8AaW8nIFO0kI2r-_3_9U8ZjCd903_CwoJQ2TuRB9esLbw4HRA	2021-05-19 22:51:07	2021-05-19 22:52:11	ccc44f7d-645e-4ed3-9a0d-3ff4b4d079c8
81	1	uvUBGr0YY2VerVRXvjBfywePwa3pXU8pZiAqGxaqkiUy3sQ9s6Uw4oGmRe51lRt2w8GDtJOnb3t5GY7n7sG3gJZnceGlfe0iqwSF	2021-05-19 22:50:12	2021-05-19 22:51:04	506487c6-e7f6-4b17-b5f5-7d0a3a3d52d8
83	1	p25dzgyShOhHL3-R5U3JGydY1DkKZJIS9TrWpv3m8zc63Lx9D9qKIdTNQLsngyS05T19A9kq5FBX6u7x9tRBypCP7Y0yfTcT3LLz	2021-05-19 22:52:11	2021-05-19 22:53:14	3dcebebb-99a9-43cc-bc88-6e998ed685d5
87	1	dgBpSdo6jy9Cu8igdhVKbfZ3MCaCu20LBcxY2TvK1oyK5wHd8RX2709Z61Ixu9bT7FDZ-iRNey_CVJlGFF_4Akd9rkw-G28tF-xM	2021-05-19 22:56:30	2021-05-19 22:56:41	20920a7e-f72f-4111-9792-5ffdaa5459e0
84	1	9kKo_rsVF2XCnAU2z4ink4aBPHKLwXcNMSeX0BbZz_pw-GKhiMSqsnNFvzlPNsGbbPBfInMH7t_6TxKpz0d8ck-4ER--HndkfxIT	2021-05-19 22:53:14	2021-05-19 22:54:16	38465148-4eda-4f40-a2d9-b903e85b11a6
86	1	4ACF_YJ6r5RLRPC1xS45689a9ErYZcdWPd9F6YAZJDG26xiFgoOo0CKSs0jQimgt54oI2SVAvfh2wOJKRSMJzNUrZdclYie3WcGW	2021-05-19 22:55:16	2021-05-19 22:57:32	b938bd5b-98ee-42ab-85d4-4b8b85b496b5
85	1	6YgEjyJULCd_-Y2p0Uafd5XxGAoAVR6yhzTR6JZZ659TzqO5Tn63UtOr_KBkuwb767-trP6uHCAUayv2vfhrbBOAKIOy494VOR9c	2021-05-19 22:54:16	2021-05-19 22:55:16	b23f58ca-ab4b-494f-b673-5e5d3d25ab58
\.


--
-- Data for Name: shunnedmessages; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.shunnedmessages (id, "userId", message, "expiryDate", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: sitegroups; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.sitegroups (id, name, "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	Skyviewer API	2021-05-19 21:09:33	2021-05-19 21:09:33	\N	c1f0a2ee-3b87-486c-96ed-7e2d25fc952f
\.


--
-- Data for Name: sites; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.sites (id, "groupId", "primary", enabled, name, handle, language, "hasUrls", "baseUrl", "sortOrder", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	1	t	t	Skyviewer API	default	en-US	t	$PRIMARY_SITE_URL	1	2021-05-19 21:09:33	2021-05-19 21:09:33	\N	763c0189-f6eb-419c-9ca2-2574a743768a
\.


--
-- Data for Name: structureelements; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.structureelements (id, "structureId", "elementId", root, lft, rgt, level, "dateCreated", "dateUpdated", uid) FROM stdin;
1	1	\N	1	1	4	0	2021-05-19 21:19:04	2021-05-19 21:19:04	72e1b935-3657-45d4-95c2-a8b577f88d76
2	1	2	1	2	3	1	2021-05-19 21:19:04	2021-05-19 21:19:04	8e34f4f2-3f68-4e79-b30f-4ba717995382
\.


--
-- Data for Name: structures; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.structures (id, "maxLevels", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	\N	2021-05-19 21:15:41	2021-05-19 21:15:41	\N	c5f91141-fb7a-4467-8e9d-d1f025206c1b
2	\N	2021-05-19 22:59:19	2021-05-19 22:59:19	\N	ae4c1bfa-0825-4ccf-b090-4c79bed024bb
\.


--
-- Data for Name: systemmessages; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.systemmessages (id, language, key, subject, body, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: taggroups; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.taggroups (id, name, handle, "fieldLayoutId", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.tags (id, "groupId", "deletedWithGroup", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: templatecacheelements; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.templatecacheelements (id, "cacheId", "elementId") FROM stdin;
\.


--
-- Data for Name: templatecachequeries; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.templatecachequeries (id, "cacheId", type, query) FROM stdin;
\.


--
-- Data for Name: templatecaches; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.templatecaches (id, "siteId", "cacheKey", path, "expiryDate", body) FROM stdin;
\.


--
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.tokens (id, token, route, "usageLimit", "usageCount", "expiryDate", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: usergroups; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.usergroups (id, name, handle, description, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: usergroups_users; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.usergroups_users (id, "groupId", "userId", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: userpermissions; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.userpermissions (id, name, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: userpermissions_usergroups; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.userpermissions_usergroups (id, "permissionId", "groupId", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: userpermissions_users; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.userpermissions_users (id, "permissionId", "userId", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: userpreferences; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.userpreferences ("userId", preferences) FROM stdin;
1	{"language":"en-US"}
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.users (id, username, "photoId", "firstName", "lastName", email, password, admin, locked, suspended, pending, "lastLoginDate", "lastLoginAttemptIp", "invalidLoginWindowStart", "invalidLoginCount", "lastInvalidLoginDate", "lockoutDate", "hasDashboard", "verificationCode", "verificationCodeIssuedDate", "unverifiedEmail", "passwordResetRequired", "lastPasswordChangeDate", "dateCreated", "dateUpdated", uid) FROM stdin;
1	admin	\N	\N	\N	erosas@lsst.org	$2y$13$kWYreAF/KSf6akVAJsZhnuRBQ1Iu2/yOGwQC/Qw/tSmfYRa9PM.5a	t	f	f	f	2021-05-19 22:57:32	\N	\N	\N	\N	\N	t	\N	\N	\N	f	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-05-19 22:57:32	2300d535-6e4f-4040-a28b-e024deda748c
\.


--
-- Data for Name: volumefolders; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.volumefolders (id, "parentId", "volumeId", name, path, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- Data for Name: volumes; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.volumes (id, "fieldLayoutId", name, handle, type, "hasUrls", url, "titleTranslationMethod", "titleTranslationKeyFormat", settings, "sortOrder", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
\.


--
-- Data for Name: widgets; Type: TABLE DATA; Schema: public; Owner: skyviewer
--

COPY public.widgets (id, "userId", type, "sortOrder", colspan, settings, enabled, "dateCreated", "dateUpdated", uid) FROM stdin;
1	1	craft\\widgets\\RecentEntries	1	\N	{"siteId":1,"section":"*","limit":10}	t	2021-05-19 21:09:36	2021-05-19 21:09:36	6d01e2cd-b482-4cf8-86d4-8bf7d9f4225c
2	1	craft\\widgets\\CraftSupport	2	\N	[]	t	2021-05-19 21:09:36	2021-05-19 21:09:36	0be85e31-00f6-454f-a31b-0c41bc31652f
3	1	craft\\widgets\\Updates	3	\N	[]	t	2021-05-19 21:09:36	2021-05-19 21:09:36	4ec54126-dcc9-4641-8d2e-ecf71ea44ec4
4	1	craft\\widgets\\Feed	4	\N	{"url":"https://craftcms.com/news.rss","title":"Craft News","limit":5}	t	2021-05-19 21:09:36	2021-05-19 21:09:36	b722b0db-0dad-46d2-ad72-a22aabb4bd18
\.


--
-- Name: assetindexdata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.assetindexdata_id_seq', 1, false);


--
-- Name: assettransformindex_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.assettransformindex_id_seq', 1, false);


--
-- Name: assettransforms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.assettransforms_id_seq', 1, false);


--
-- Name: categorygroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.categorygroups_id_seq', 1, true);


--
-- Name: categorygroups_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.categorygroups_sites_id_seq', 1, true);


--
-- Name: content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.content_id_seq', 5, true);


--
-- Name: craftidtokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.craftidtokens_id_seq', 1, false);


--
-- Name: deprecationerrors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.deprecationerrors_id_seq', 1, false);


--
-- Name: drafts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.drafts_id_seq', 3, true);


--
-- Name: elementindexsettings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.elementindexsettings_id_seq', 1, false);


--
-- Name: elements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.elements_id_seq', 5, true);


--
-- Name: elements_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.elements_sites_id_seq', 5, true);


--
-- Name: entrytypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.entrytypes_id_seq', 1, true);


--
-- Name: fieldgroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.fieldgroups_id_seq', 2, true);


--
-- Name: fieldlayoutfields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.fieldlayoutfields_id_seq', 6, true);


--
-- Name: fieldlayouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.fieldlayouts_id_seq', 2, true);


--
-- Name: fieldlayouttabs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.fieldlayouttabs_id_seq', 5, true);


--
-- Name: fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.fields_id_seq', 2, true);


--
-- Name: globalsets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.globalsets_id_seq', 1, false);


--
-- Name: gqlschemas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.gqlschemas_id_seq', 1, true);


--
-- Name: gqltokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.gqltokens_id_seq', 1, true);


--
-- Name: info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.info_id_seq', 1, false);


--
-- Name: matrixblocktypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.matrixblocktypes_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.migrations_id_seq', 184, true);


--
-- Name: plugins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.plugins_id_seq', 1, false);


--
-- Name: queue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.queue_id_seq', 17, true);


--
-- Name: relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.relations_id_seq', 1, false);


--
-- Name: revisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.revisions_id_seq', 1, false);


--
-- Name: sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.sections_id_seq', 1, true);


--
-- Name: sections_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.sections_sites_id_seq', 1, true);


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.sessions_id_seq', 88, true);


--
-- Name: shunnedmessages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.shunnedmessages_id_seq', 1, false);


--
-- Name: sitegroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.sitegroups_id_seq', 1, true);


--
-- Name: sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.sites_id_seq', 1, true);


--
-- Name: structureelements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.structureelements_id_seq', 2, true);


--
-- Name: structures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.structures_id_seq', 2, true);


--
-- Name: systemmessages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.systemmessages_id_seq', 1, false);


--
-- Name: taggroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.taggroups_id_seq', 1, false);


--
-- Name: templatecacheelements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.templatecacheelements_id_seq', 1, false);


--
-- Name: templatecachequeries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.templatecachequeries_id_seq', 1, false);


--
-- Name: templatecaches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.templatecaches_id_seq', 1, false);


--
-- Name: tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.tokens_id_seq', 1, false);


--
-- Name: usergroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.usergroups_id_seq', 1, false);


--
-- Name: usergroups_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.usergroups_users_id_seq', 1, false);


--
-- Name: userpermissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.userpermissions_id_seq', 1, false);


--
-- Name: userpermissions_usergroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.userpermissions_usergroups_id_seq', 1, false);


--
-- Name: userpermissions_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.userpermissions_users_id_seq', 1, false);


--
-- Name: userpreferences_userId_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public."userpreferences_userId_seq"', 1, false);


--
-- Name: volumefolders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.volumefolders_id_seq', 1, false);


--
-- Name: volumes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.volumes_id_seq', 1, false);


--
-- Name: widgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: skyviewer
--

SELECT pg_catalog.setval('public.widgets_id_seq', 4, true);


--
-- Name: assetindexdata assetindexdata_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assetindexdata
    ADD CONSTRAINT assetindexdata_pkey PRIMARY KEY (id);


--
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: assettransformindex assettransformindex_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assettransformindex
    ADD CONSTRAINT assettransformindex_pkey PRIMARY KEY (id);


--
-- Name: assettransforms assettransforms_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assettransforms
    ADD CONSTRAINT assettransforms_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categorygroups categorygroups_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categorygroups
    ADD CONSTRAINT categorygroups_pkey PRIMARY KEY (id);


--
-- Name: categorygroups_sites categorygroups_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categorygroups_sites
    ADD CONSTRAINT categorygroups_sites_pkey PRIMARY KEY (id);


--
-- Name: changedattributes changedattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.changedattributes
    ADD CONSTRAINT changedattributes_pkey PRIMARY KEY ("elementId", "siteId", attribute);


--
-- Name: changedfields changedfields_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.changedfields
    ADD CONSTRAINT changedfields_pkey PRIMARY KEY ("elementId", "siteId", "fieldId");


--
-- Name: content content_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_pkey PRIMARY KEY (id);


--
-- Name: craftidtokens craftidtokens_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.craftidtokens
    ADD CONSTRAINT craftidtokens_pkey PRIMARY KEY (id);


--
-- Name: deprecationerrors deprecationerrors_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.deprecationerrors
    ADD CONSTRAINT deprecationerrors_pkey PRIMARY KEY (id);


--
-- Name: drafts drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.drafts
    ADD CONSTRAINT drafts_pkey PRIMARY KEY (id);


--
-- Name: elementindexsettings elementindexsettings_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elementindexsettings
    ADD CONSTRAINT elementindexsettings_pkey PRIMARY KEY (id);


--
-- Name: elements elements_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT elements_pkey PRIMARY KEY (id);


--
-- Name: elements_sites elements_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elements_sites
    ADD CONSTRAINT elements_sites_pkey PRIMARY KEY (id);


--
-- Name: entries entries_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: entrytypes entrytypes_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.entrytypes
    ADD CONSTRAINT entrytypes_pkey PRIMARY KEY (id);


--
-- Name: fieldgroups fieldgroups_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldgroups
    ADD CONSTRAINT fieldgroups_pkey PRIMARY KEY (id);


--
-- Name: fieldlayoutfields fieldlayoutfields_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldlayoutfields
    ADD CONSTRAINT fieldlayoutfields_pkey PRIMARY KEY (id);


--
-- Name: fieldlayouts fieldlayouts_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldlayouts
    ADD CONSTRAINT fieldlayouts_pkey PRIMARY KEY (id);


--
-- Name: fieldlayouttabs fieldlayouttabs_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldlayouttabs
    ADD CONSTRAINT fieldlayouttabs_pkey PRIMARY KEY (id);


--
-- Name: fields fields_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fields
    ADD CONSTRAINT fields_pkey PRIMARY KEY (id);


--
-- Name: globalsets globalsets_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.globalsets
    ADD CONSTRAINT globalsets_pkey PRIMARY KEY (id);


--
-- Name: gqlschemas gqlschemas_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.gqlschemas
    ADD CONSTRAINT gqlschemas_pkey PRIMARY KEY (id);


--
-- Name: gqltokens gqltokens_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.gqltokens
    ADD CONSTRAINT gqltokens_pkey PRIMARY KEY (id);


--
-- Name: info info_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.info
    ADD CONSTRAINT info_pkey PRIMARY KEY (id);


--
-- Name: matrixblocks matrixblocks_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.matrixblocks
    ADD CONSTRAINT matrixblocks_pkey PRIMARY KEY (id);


--
-- Name: matrixblocktypes matrixblocktypes_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.matrixblocktypes
    ADD CONSTRAINT matrixblocktypes_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: searchindex pk_lxfgkaypfkbmlezqetvjapqydsjlbjwtrksy; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.searchindex
    ADD CONSTRAINT pk_lxfgkaypfkbmlezqetvjapqydsjlbjwtrksy PRIMARY KEY ("elementId", attribute, "fieldId", "siteId");


--
-- Name: plugins plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_pkey PRIMARY KEY (id);


--
-- Name: projectconfig projectconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.projectconfig
    ADD CONSTRAINT projectconfig_pkey PRIMARY KEY (path);


--
-- Name: projectconfignames projectconfignames_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.projectconfignames
    ADD CONSTRAINT projectconfignames_pkey PRIMARY KEY (uid);


--
-- Name: queue queue_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.queue
    ADD CONSTRAINT queue_pkey PRIMARY KEY (id);


--
-- Name: relations relations_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_pkey PRIMARY KEY (id);


--
-- Name: resourcepaths resourcepaths_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.resourcepaths
    ADD CONSTRAINT resourcepaths_pkey PRIMARY KEY (hash);


--
-- Name: revisions revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.revisions
    ADD CONSTRAINT revisions_pkey PRIMARY KEY (id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: sections_sites sections_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sections_sites
    ADD CONSTRAINT sections_sites_pkey PRIMARY KEY (id);


--
-- Name: sequences sequences_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sequences
    ADD CONSTRAINT sequences_pkey PRIMARY KEY (name);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: shunnedmessages shunnedmessages_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.shunnedmessages
    ADD CONSTRAINT shunnedmessages_pkey PRIMARY KEY (id);


--
-- Name: sitegroups sitegroups_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sitegroups
    ADD CONSTRAINT sitegroups_pkey PRIMARY KEY (id);


--
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: structureelements structureelements_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.structureelements
    ADD CONSTRAINT structureelements_pkey PRIMARY KEY (id);


--
-- Name: structures structures_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT structures_pkey PRIMARY KEY (id);


--
-- Name: systemmessages systemmessages_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.systemmessages
    ADD CONSTRAINT systemmessages_pkey PRIMARY KEY (id);


--
-- Name: taggroups taggroups_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.taggroups
    ADD CONSTRAINT taggroups_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: templatecacheelements templatecacheelements_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.templatecacheelements
    ADD CONSTRAINT templatecacheelements_pkey PRIMARY KEY (id);


--
-- Name: templatecachequeries templatecachequeries_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.templatecachequeries
    ADD CONSTRAINT templatecachequeries_pkey PRIMARY KEY (id);


--
-- Name: templatecaches templatecaches_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.templatecaches
    ADD CONSTRAINT templatecaches_pkey PRIMARY KEY (id);


--
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- Name: usergroups usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_pkey PRIMARY KEY (id);


--
-- Name: usergroups_users usergroups_users_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.usergroups_users
    ADD CONSTRAINT usergroups_users_pkey PRIMARY KEY (id);


--
-- Name: userpermissions userpermissions_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpermissions
    ADD CONSTRAINT userpermissions_pkey PRIMARY KEY (id);


--
-- Name: userpermissions_usergroups userpermissions_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpermissions_usergroups
    ADD CONSTRAINT userpermissions_usergroups_pkey PRIMARY KEY (id);


--
-- Name: userpermissions_users userpermissions_users_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpermissions_users
    ADD CONSTRAINT userpermissions_users_pkey PRIMARY KEY (id);


--
-- Name: userpreferences userpreferences_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpreferences
    ADD CONSTRAINT userpreferences_pkey PRIMARY KEY ("userId");


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: volumefolders volumefolders_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.volumefolders
    ADD CONSTRAINT volumefolders_pkey PRIMARY KEY (id);


--
-- Name: volumes volumes_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.volumes
    ADD CONSTRAINT volumes_pkey PRIMARY KEY (id);


--
-- Name: widgets widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_pkey PRIMARY KEY (id);


--
-- Name: idx_aibvszhglagfecfikfbsmqtnvuapcwrqvcab; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_aibvszhglagfecfikfbsmqtnvuapcwrqvcab ON public.fields USING btree (context);


--
-- Name: idx_akczfxbpvrqogoubxmhpsshuiumiomrtbrdf; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_akczfxbpvrqogoubxmhpsshuiumiomrtbrdf ON public.usergroups USING btree (name);


--
-- Name: idx_algqvqvwjlroryfjykwybcgqiwhqgntlipes; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_algqvqvwjlroryfjykwybcgqiwhqgntlipes ON public.categorygroups_sites USING btree ("siteId");


--
-- Name: idx_aouvbwxkucozzodquwwdmnitckwwjpbtayix; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_aouvbwxkucozzodquwwdmnitckwwjpbtayix ON public.elements USING btree (archived, "dateDeleted", "draftId", "revisionId");


--
-- Name: idx_awhozleetinzjdkbcjzxoljutdayfqbsotlp; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_awhozleetinzjdkbcjzxoljutdayfqbsotlp ON public.migrations USING btree (track, name);


--
-- Name: idx_axfpcqicozeksdqwxanvhaigfnidigynadfj; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_axfpcqicozeksdqwxanvhaigfnidigynadfj ON public.elements USING btree ("fieldLayoutId");


--
-- Name: idx_aywjsrxhznfumtuaqcnfnisrndoyxqxyqelu; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_aywjsrxhznfumtuaqcnfnisrndoyxqxyqelu ON public.entries USING btree ("sectionId");


--
-- Name: idx_bfbcsmslvamqcysctsvrgkyonfsmiueduylv; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_bfbcsmslvamqcysctsvrgkyonfsmiueduylv ON public.globalsets USING btree (name);


--
-- Name: idx_bfmwmtoctdvvupebqhfagygayolmhzlnfemt; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_bfmwmtoctdvvupebqhfagygayolmhzlnfemt ON public.widgets USING btree ("userId");


--
-- Name: idx_bghhvycgfmhyggeagfixijirnhbznjqqfjrx; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_bghhvycgfmhyggeagfixijirnhbznjqqfjrx ON public.fieldlayoutfields USING btree ("tabId");


--
-- Name: idx_bhpgeezebucqwzvpsupdxvgqzpabspsytnxs; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_bhpgeezebucqwzvpsupdxvgqzpabspsytnxs ON public.fieldgroups USING btree (name);


--
-- Name: idx_bjssnpzxdbgoakkblkmfnmutukpmawykusml; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_bjssnpzxdbgoakkblkmfnmutukpmawykusml ON public.gqltokens USING btree (name);


--
-- Name: idx_brlliucjsjmqrwcwsgnqodychkslautofkqa; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_brlliucjsjmqrwcwsgnqodychkslautofkqa ON public.relations USING btree ("sourceSiteId");


--
-- Name: idx_bscvmgytpkjixuhlqquefekhokzykbuxtdwy; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_bscvmgytpkjixuhlqquefekhokzykbuxtdwy ON public.queue USING btree (channel, fail, "timeUpdated", "timePushed");


--
-- Name: idx_bviglcmlytlingcnqsnxfketurjehjwjwldz; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_bviglcmlytlingcnqsnxfketurjehjwjwldz ON public.matrixblocks USING btree ("ownerId");


--
-- Name: idx_bwwmprokloqchpvqysxisopcetejuzyzupwr; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_bwwmprokloqchpvqysxisopcetejuzyzupwr ON public.changedattributes USING btree ("elementId", "siteId", "dateUpdated");


--
-- Name: idx_ccagxxmwawdxcnmxwcurpeyntziysrqrzcpz; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ccagxxmwawdxcnmxwcurpeyntziysrqrzcpz ON public.usergroups USING btree (handle);


--
-- Name: idx_cdkqbsnfahbjmvtzcatpmuxbvvoqynexmsqg; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_cdkqbsnfahbjmvtzcatpmuxbvvoqynexmsqg ON public.relations USING btree ("targetId");


--
-- Name: idx_cdttticbvkoslbgksuepwlvsyhtczuugtyrb; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_cdttticbvkoslbgksuepwlvsyhtczuugtyrb ON public.templatecacheelements USING btree ("elementId");


--
-- Name: idx_cfsoakqbmwalizuunryofycpykdbqgqndxxd; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_cfsoakqbmwalizuunryofycpykdbqgqndxxd ON public.entrytypes USING btree ("fieldLayoutId");


--
-- Name: idx_cjuyyrpdlfwkmusstdcesomsirnoqvnyqpqj; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_cjuyyrpdlfwkmusstdcesomsirnoqvnyqpqj ON public.entries USING btree ("authorId");


--
-- Name: idx_clkdwfcohiejtslimqsybwsngwectagegknb; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_clkdwfcohiejtslimqsybwsngwectagegknb ON public.volumefolders USING btree ("parentId");


--
-- Name: idx_cnpzflbqudzwjxxvsznxqgrssibrwjbnneer; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_cnpzflbqudzwjxxvsznxqgrssibrwjbnneer ON public.fieldgroups USING btree ("dateDeleted", name);


--
-- Name: idx_crfiycgffgjafkdwnawltzmpfxkfhnnvcxtb; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_crfiycgffgjafkdwnawltzmpfxkfhnnvcxtb ON public.categorygroups USING btree (handle);


--
-- Name: idx_ctaszbolxbztbtzprhhuhdxejyjfznvyulqe; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ctaszbolxbztbtzprhhuhdxejyjfznvyulqe ON public.assetindexdata USING btree ("sessionId", "volumeId");


--
-- Name: idx_dfalodovprinwkniorhrxpcdqihwixuaifjf; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_dfalodovprinwkniorhrxpcdqihwixuaifjf ON public.entrytypes USING btree ("dateDeleted");


--
-- Name: idx_dicisttfktbpuugyjynbzqxdjjnclaridqma; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_dicisttfktbpuugyjynbzqxdjjnclaridqma ON public.matrixblocks USING btree ("typeId");


--
-- Name: idx_digsuhzentnvowzcjiajuujcqfytgkxwbgnh; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_digsuhzentnvowzcjiajuujcqfytgkxwbgnh ON public.usergroups_users USING btree ("groupId", "userId");


--
-- Name: idx_dlyoewgvggsaokpraelqlgsrpwhgdwffuohj; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_dlyoewgvggsaokpraelqlgsrpwhgdwffuohj ON public.matrixblocks USING btree ("sortOrder");


--
-- Name: idx_dsmjrvkozsqliisdwfucenifiorfesqvqyht; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_dsmjrvkozsqliisdwfucenifiorfesqvqyht ON public.sections USING btree (name);


--
-- Name: idx_dzadiotbdrmrxknlkmscakdwxvluhstcdoqm; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_dzadiotbdrmrxknlkmscakdwxvluhstcdoqm ON public.categories USING btree ("groupId");


--
-- Name: idx_ehecjefsyolrdvuiwbntylhdhctsckrjokiw; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ehecjefsyolrdvuiwbntylhdhctsckrjokiw ON public.taggroups USING btree (handle);


--
-- Name: idx_ehepbjqeqphmjxgclpmmxmwienrzyxkvjfva; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ehepbjqeqphmjxgclpmmxmwienrzyxkvjfva ON public.users USING btree ("verificationCode");


--
-- Name: idx_ehtthrejpzodhyduxbqagnpvnpexfufrndbz; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ehtthrejpzodhyduxbqagnpvnpexfufrndbz ON public.globalsets USING btree ("fieldLayoutId");


--
-- Name: idx_enbhxbbkiwapcanipnsrramikokfqgrjresx; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_enbhxbbkiwapcanipnsrramikokfqgrjresx ON public.sites USING btree ("dateDeleted");


--
-- Name: idx_enzejhlkulsuinjeplfmijgjszkpsoepynkk; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_enzejhlkulsuinjeplfmijgjszkpsoepynkk ON public.queue USING btree (channel, fail, "timeUpdated", delay);


--
-- Name: idx_eorssjrepsdyhmerukmsjovvmmmpnloajmvd; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_eorssjrepsdyhmerukmsjovvmmmpnloajmvd ON public.templatecaches USING btree ("siteId");


--
-- Name: idx_esejseinmaiyuvummbilzzfwqenrsmoyhfty; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_esejseinmaiyuvummbilzzfwqenrsmoyhfty ON public.sessions USING btree ("userId");


--
-- Name: idx_ewuqzbedrkcttgsmndhjeyoyiejfgfcjnjkl; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ewuqzbedrkcttgsmndhjeyoyiejfgfcjnjkl ON public.categorygroups USING btree ("dateDeleted");


--
-- Name: idx_eyugiickbncgkcldyfbsxntpkcpbifhttvov; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_eyugiickbncgkcldyfbsxntpkcpbifhttvov ON public.templatecachequeries USING btree ("cacheId");


--
-- Name: idx_fbpuehfsjjagfdlqiaxuzlcdfhrmxvxmjbjp; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_fbpuehfsjjagfdlqiaxuzlcdfhrmxvxmjbjp ON public.userpermissions_usergroups USING btree ("groupId");


--
-- Name: idx_fedwtexeakktsjlurghohpjdcvnoeajqzwli; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_fedwtexeakktsjlurghohpjdcvnoeajqzwli ON public.systemmessages USING btree (language);


--
-- Name: idx_fumezaiflrfozsojqiezdhrpdbltwmteywmv; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_fumezaiflrfozsojqiezdhrpdbltwmteywmv ON public.assettransformindex USING btree ("volumeId", "assetId", location);


--
-- Name: idx_fxpbopwlgdqteycqtwsycqopycilqmffcgfk; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_fxpbopwlgdqteycqtwsycqopycilqmffcgfk ON public.fieldlayouts USING btree (type);


--
-- Name: idx_fxpizzrhvufyitaecmqjeriygvybexnukcjz; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_fxpizzrhvufyitaecmqjeriygvybexnukcjz ON public.deprecationerrors USING btree (key, fingerprint);


--
-- Name: idx_gacfibtuowsanbmeqfcmeklkzeiyriuvwqqw; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_gacfibtuowsanbmeqfcmeklkzeiyriuvwqqw ON public.matrixblocks USING btree ("fieldId");


--
-- Name: idx_gbzwzqkmedeynftktegqiyworxunctqhvtzw; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_gbzwzqkmedeynftktegqiyworxunctqhvtzw ON public.sections USING btree ("dateDeleted");


--
-- Name: idx_ggwalfquahfsgvhzdqfrvmxpxjdwhfkditdy; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ggwalfquahfsgvhzdqfrvmxpxjdwhfkditdy ON public.templatecaches USING btree ("cacheKey", "siteId", "expiryDate", path);


--
-- Name: idx_gksboxtdnwodiuiupoicfpxiuyacrsnsrerm; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_gksboxtdnwodiuiupoicfpxiuyacrsnsrerm ON public.sessions USING btree ("dateUpdated");


--
-- Name: idx_gnvaxsdbapattxwadeynexxuexmvpzgvlcob; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_gnvaxsdbapattxwadeynexxuexmvpzgvlcob ON public.elements_sites USING btree ("elementId", "siteId");


--
-- Name: idx_gompunhsmjqdsfuzzspaaegknwshhongvjqy; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_gompunhsmjqdsfuzzspaaegknwshhongvjqy ON public.categorygroups USING btree ("fieldLayoutId");


--
-- Name: idx_hlffxdhxhqusafcctzzfjtheambbyncgfbyx; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_hlffxdhxhqusafcctzzfjtheambbyncgfbyx ON public.fieldlayouts USING btree ("dateDeleted");


--
-- Name: idx_ikmufzsvdltyjzuxfhbmctmefaaplccjfenp; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ikmufzsvdltyjzuxfhbmctmefaaplccjfenp ON public.fieldlayoutfields USING btree ("fieldId");


--
-- Name: idx_innyzhysxpaasctawligntkzucepxtoiqcdd; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_innyzhysxpaasctawligntkzucepxtoiqcdd ON public.changedfields USING btree ("elementId", "siteId", "dateUpdated");


--
-- Name: idx_jnpjrmqrmmrbsendjuyxcsvppgkefwfdcdbb; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_jnpjrmqrmmrbsendjuyxcsvppgkefwfdcdbb ON public.entries USING btree ("typeId");


--
-- Name: idx_kadqgpvmkcmvfuaudcczydeoudsqanlnmxqq; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_kadqgpvmkcmvfuaudcczydeoudsqanlnmxqq ON public.assets USING btree ("folderId");


--
-- Name: idx_klycdbxfjkgrhfoktklzgpflanntdubizshw; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_klycdbxfjkgrhfoktklzgpflanntdubizshw ON public.content USING btree (title);


--
-- Name: idx_kshifhmuqvgpjydcoxjkgslplehlkmegbscs; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_kshifhmuqvgpjydcoxjkgslplehlkmegbscs ON public.templatecacheelements USING btree ("cacheId");


--
-- Name: idx_kusdxabnuybytvoqpqynsctniohsjrjdgnxz; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_kusdxabnuybytvoqpqynsctniohsjrjdgnxz ON public.userpermissions_users USING btree ("userId");


--
-- Name: idx_kvmmgwsoowryueksxnnfhauffnmqaajsqoce; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_kvmmgwsoowryueksxnnfhauffnmqaajsqoce ON public.users USING btree (lower((email)::text));


--
-- Name: idx_kvvoxurgpnjojsmstchtfzxprowqobagonla; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_kvvoxurgpnjojsmstchtfzxprowqobagonla ON public.entries USING btree ("expiryDate");


--
-- Name: idx_kxhqocactthunplyzmkfdujxaibrtfhdbeig; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_kxhqocactthunplyzmkfdujxaibrtfhdbeig ON public.usergroups_users USING btree ("userId");


--
-- Name: idx_lfkszeaczqeuukacvkqepjxpraqpoyptansj; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_lfkszeaczqeuukacvkqepjxpraqpoyptansj ON public.entrytypes USING btree ("sectionId");


--
-- Name: idx_lqeaodofyzagtpgrwenumtsxonjsojkznifz; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_lqeaodofyzagtpgrwenumtsxonjsojkznifz ON public.sections USING btree ("structureId");


--
-- Name: idx_lqsfxhxwmkqosblnviciymxkqnvxbfusbtjy; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_lqsfxhxwmkqosblnviciymxkqnvxbfusbtjy ON public.userpermissions USING btree (name);


--
-- Name: idx_lrypalgtkudwbhhsczxghxsbqvrckuznhzww; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_lrypalgtkudwbhhsczxghxsbqvrckuznhzww ON public.entrytypes USING btree (handle, "sectionId");


--
-- Name: idx_lwbpeawpsxxvdhvvzixckuzhrbudfdzppqni; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_lwbpeawpsxxvdhvvzixckuzhrbudfdzppqni ON public.matrixblocktypes USING btree ("fieldId");


--
-- Name: idx_mdpfppuruvsemeisbpwcsxsoygvvjxzdagle; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_mdpfppuruvsemeisbpwcsxsoygvvjxzdagle ON public.shunnedmessages USING btree ("userId", message);


--
-- Name: idx_mewmjrwtloapupmfkmitakpmfekwhsqcnbhe; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_mewmjrwtloapupmfkmitakpmfekwhsqcnbhe ON public.userpermissions_users USING btree ("permissionId", "userId");


--
-- Name: idx_mhufqbryfvlnymhzimkqrsltadxfjswhbcda; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_mhufqbryfvlnymhzimkqrsltadxfjswhbcda ON public.elements_sites USING btree ("siteId");


--
-- Name: idx_molvdyoqbatpezwtmvzrslwfpqxoahhpgrzg; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_molvdyoqbatpezwtmvzrslwfpqxoahhpgrzg ON public.systemmessages USING btree (key, language);


--
-- Name: idx_mqmligqbbyutclonhejnfasmmdavtiaegtyr; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_mqmligqbbyutclonhejnfasmmdavtiaegtyr ON public.fields USING btree (handle, context);


--
-- Name: idx_mtxyzqiblpxnkptlvngobzhvkzhcnfpgfxza; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_mtxyzqiblpxnkptlvngobzhvkzhcnfpgfxza ON public.volumes USING btree ("fieldLayoutId");


--
-- Name: idx_mtzclsstwkywflzowjodzgxzhjrqmkoltpnf; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_mtzclsstwkywflzowjodzgxzhjrqmkoltpnf ON public.elements_sites USING btree (slug, "siteId");


--
-- Name: idx_naceylbsdjafrhifxzefxcclmuvxeraieuij; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_naceylbsdjafrhifxzefxcclmuvxeraieuij ON public.sessions USING btree (uid);


--
-- Name: idx_nfcvuhvuyihgvffqaorndyextbsehocgrrif; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_nfcvuhvuyihgvffqaorndyextbsehocgrrif ON public.users USING btree (lower((username)::text));


--
-- Name: idx_ngapqmosuzkrwmizkphenmuxdwxfyvnrqqju; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ngapqmosuzkrwmizkphenmuxdwxfyvnrqqju ON public.searchindex USING btree (keywords);


--
-- Name: idx_ngttnoentmqqqjpjfpfxnjwqhrkiymeuurdc; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ngttnoentmqqqjpjfpfxnjwqhrkiymeuurdc ON public.fieldlayouttabs USING btree ("layoutId");


--
-- Name: idx_nitbxxodacivlpxiudtembhpmcfiixwwazxp; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_nitbxxodacivlpxiudtembhpmcfiixwwazxp ON public.templatecaches USING btree ("cacheKey", "siteId", "expiryDate");


--
-- Name: idx_nunxmdrpvwxaododzhytzhghnvpetyducgrb; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_nunxmdrpvwxaododzhytzhghnvpetyducgrb ON public.categorygroups USING btree ("structureId");


--
-- Name: idx_odpihnhdhqitcbbcbaggkxexsswmujfesisi; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_odpihnhdhqitcbbcbaggkxexsswmujfesisi ON public.drafts USING btree (saved);


--
-- Name: idx_ofvqhwjoofgywybnttmigawptysxawrbbgfm; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_ofvqhwjoofgywybnttmigawptysxawrbbgfm ON public.tokens USING btree (token);


--
-- Name: idx_oqmmeyljxxjipeptaywrfmajncyxnhatlbai; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_oqmmeyljxxjipeptaywrfmajncyxnhatlbai ON public.templatecachequeries USING btree (type);


--
-- Name: idx_ozvnjluwhaxftfjffqkmcizeojcqlqoexdst; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ozvnjluwhaxftfjffqkmcizeojcqlqoexdst ON public.tags USING btree ("groupId");


--
-- Name: idx_pdxnhcznrgxsjdkowroebghgruaweneeopsl; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_pdxnhcznrgxsjdkowroebghgruaweneeopsl ON public.fieldlayoutfields USING btree ("sortOrder");


--
-- Name: idx_pfdrctzhuvmlijxplhokrgwuxxhpnttzhmvo; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_pfdrctzhuvmlijxplhokrgwuxxhpnttzhmvo ON public.elements USING btree (type);


--
-- Name: idx_pqegcqoexvbdcgdgnmsyvmpcitdeoesfvnrc; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_pqegcqoexvbdcgdgnmsyvmpcitdeoesfvnrc ON public.elements_sites USING btree (enabled);


--
-- Name: idx_pzsvwjjhpzfvzxfhvftgwlglemrfckixenfr; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_pzsvwjjhpzfvzxfhvftgwlglemrfckixenfr ON public.assets USING btree ("volumeId");


--
-- Name: idx_qcojqnkqasrzepyvzuihctalasbusfbmqxlu; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_qcojqnkqasrzepyvzuihctalasbusfbmqxlu ON public.sites USING btree (handle);


--
-- Name: idx_qhdvlwuacpsgfdwfhfsddanozcemgfsnicwr; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_qhdvlwuacpsgfdwfhfsddanozcemgfsnicwr ON public.entries USING btree ("postDate");


--
-- Name: idx_qsjubbhvxnrrxglpqxrdlcmxmmzpserdjvhd; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_qsjubbhvxnrrxglpqxrdlcmxmmzpserdjvhd ON public.entrytypes USING btree (name, "sectionId");


--
-- Name: idx_quoqtowoigtgjyvjafneylwttvfkbluvfjvf; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_quoqtowoigtgjyvjafneylwttvfkbluvfjvf ON public.globalsets USING btree (handle);


--
-- Name: idx_raxapfrkooshohqwnsttqzbmjmneaubrjywp; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_raxapfrkooshohqwnsttqzbmjmneaubrjywp ON public.volumes USING btree (name);


--
-- Name: idx_rdanlqdzozimxsvbdkdwebcutvlwnvokphvv; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_rdanlqdzozimxsvbdkdwebcutvlwnvokphvv ON public.sections_sites USING btree ("siteId");


--
-- Name: idx_rfwgzjbbybxgobvzcthuaynttiylycwcqbpr; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_rfwgzjbbybxgobvzcthuaynttiylycwcqbpr ON public.sections_sites USING btree ("sectionId", "siteId");


--
-- Name: idx_rhijawpoyksyqnzcdofjzckuaohzotlmjwls; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_rhijawpoyksyqnzcdofjzckuaohzotlmjwls ON public.structureelements USING btree (lft);


--
-- Name: idx_rpnbljhhzohrjzbwtxaszvxwlyaktwgatkes; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_rpnbljhhzohrjzbwtxaszvxwlyaktwgatkes ON public.content USING btree ("siteId");


--
-- Name: idx_rpxsxevuykubuyidwnxyvsphjonxgxvwshlu; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_rpxsxevuykubuyidwnxyvsphjonxgxvwshlu ON public.userpermissions_usergroups USING btree ("permissionId", "groupId");


--
-- Name: idx_sfqvyfdoxlbwdtlckzohzcbofhcrymxnibao; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_sfqvyfdoxlbwdtlckzohzcbofhcrymxnibao ON public.elements USING btree ("dateDeleted");


--
-- Name: idx_shyasyalysnodnfacqievotxdybtwxloxtjn; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_shyasyalysnodnfacqievotxdybtwxloxtjn ON public.elements USING btree (archived, "dateCreated");


--
-- Name: idx_sqaybshkxvjzciecdlmbvxxkqhcevisxrstr; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_sqaybshkxvjzciecdlmbvxxkqhcevisxrstr ON public.sections USING btree (handle);


--
-- Name: idx_sucfqgpljyauzkaercsyxfbbuihgqgejravw; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_sucfqgpljyauzkaercsyxfbbuihgqgejravw ON public.assets USING btree (filename, "folderId");


--
-- Name: idx_swbdhkcyldrymmimnyyzhoruusqzieqzqkoj; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_swbdhkcyldrymmimnyyzhoruusqzieqzqkoj ON public.sitegroups USING btree (name);


--
-- Name: idx_sxmmpdncyboznlkdhwiqqhogqjfugcljetcv; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_sxmmpdncyboznlkdhwiqqhogqjfugcljetcv ON public.fieldlayoutfields USING btree ("layoutId", "fieldId");


--
-- Name: idx_tibckudppxjixabnwitmstncmonzyfcljxwp; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_tibckudppxjixabnwitmstncmonzyfcljxwp ON public.structureelements USING btree ("elementId");


--
-- Name: idx_tisltfobstngapxhxwhgjmyrcgncfowhbumi; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_tisltfobstngapxhxwhgjmyrcgncfowhbumi ON public.taggroups USING btree (name);


--
-- Name: idx_tkhgjlhpsahimpdzkdespdvitrlqmbbzinfs; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_tkhgjlhpsahimpdzkdespdvitrlqmbbzinfs ON public.categorygroups USING btree (name);


--
-- Name: idx_tutojnrimafslbculxiyhtqlhmtjxsdycodm; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_tutojnrimafslbculxiyhtqlhmtjxsdycodm ON public.plugins USING btree (handle);


--
-- Name: idx_tyxwtvkxmivthgakhwfzpfusqhfpoqpefwjh; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_tyxwtvkxmivthgakhwfzpfusqhfpoqpefwjh ON public.assetindexdata USING btree ("volumeId");


--
-- Name: idx_ubeonauvklsmksdrviihehxaebkdfwstmftt; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ubeonauvklsmksdrviihehxaebkdfwstmftt ON public.elements_sites USING btree (lower((uri)::text), "siteId");


--
-- Name: idx_ueluuquebchhwfpsjenjoefhomovbdbpovor; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ueluuquebchhwfpsjenjoefhomovbdbpovor ON public.volumes USING btree (handle);


--
-- Name: idx_ugmrktthadekhnyawajexhfslnvlugbcpgay; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ugmrktthadekhnyawajexhfslnvlugbcpgay ON public.taggroups USING btree ("dateDeleted");


--
-- Name: idx_ujlortvoloqawkvpyhqxoxrvinmrqebqciqr; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_ujlortvoloqawkvpyhqxoxrvinmrqebqciqr ON public.structureelements USING btree (level);


--
-- Name: idx_unwswmwqqllvbixmraomayyygydxsnxhkutm; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_unwswmwqqllvbixmraomayyygydxsnxhkutm ON public.volumes USING btree ("dateDeleted");


--
-- Name: idx_uxfqbahutggwjubvwsfvkoegeluazksytkju; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_uxfqbahutggwjubvwsfvkoegeluazksytkju ON public.searchindex USING gin (keywords_vector) WITH (fastupdate=yes);


--
-- Name: idx_vewziwqascthqjmxznvqfjhcsxhndhyzaxpj; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_vewziwqascthqjmxznvqfjhcsxhndhyzaxpj ON public.matrixblocktypes USING btree ("fieldLayoutId");


--
-- Name: idx_vkbtvweombmisfvayfkzzkdirurvlcvlsztu; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_vkbtvweombmisfvayfkzzkdirurvlcvlsztu ON public.volumefolders USING btree (name, "parentId", "volumeId");


--
-- Name: idx_vkdnqkhzdlykulcvnzghtithnsbrrqecubyf; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_vkdnqkhzdlykulcvnzghtithnsbrrqecubyf ON public.structures USING btree ("dateDeleted");


--
-- Name: idx_vohwgrkpnvinjzeftawuztuhkminmupepvvu; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_vohwgrkpnvinjzeftawuztuhkminmupepvvu ON public.users USING btree (uid);


--
-- Name: idx_vqrexmlapffadgvlkjxrfypkgijshndffhft; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_vqrexmlapffadgvlkjxrfypkgijshndffhft ON public.assettransforms USING btree (name);


--
-- Name: idx_vxholinzobnlbwtgyaluqutqngzetijhtwfe; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_vxholinzobnlbwtgyaluqutqngzetijhtwfe ON public.assettransforms USING btree (handle);


--
-- Name: idx_warcvjhvekwsfazlbslnlhhwyvmvhxdombgu; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_warcvjhvekwsfazlbslnlhhwyvmvhxdombgu ON public.revisions USING btree ("sourceId", num);


--
-- Name: idx_wasqfkxrvoapoopfusuhwkswbwaloqfxuqrz; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_wasqfkxrvoapoopfusuhwkswbwaloqfxuqrz ON public.matrixblocktypes USING btree (handle, "fieldId");


--
-- Name: idx_wbilfpsakocknvryuoqlsjavvbbhocdcqvpn; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_wbilfpsakocknvryuoqlsjavvbbhocdcqvpn ON public.fieldlayouttabs USING btree ("sortOrder");


--
-- Name: idx_wysyhamnxufkthhfmeffcdduvwpirckxiwra; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_wysyhamnxufkthhfmeffcdduvwpirckxiwra ON public.tokens USING btree ("expiryDate");


--
-- Name: idx_xcvciijipsangbimzlvroajksznflvorwpmm; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_xcvciijipsangbimzlvroajksznflvorwpmm ON public.content USING btree ("elementId", "siteId");


--
-- Name: idx_xjimybbwkmpbcsdoxftapqumcsksaaayxgdc; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_xjimybbwkmpbcsdoxftapqumcsksaaayxgdc ON public.elements USING btree (enabled);


--
-- Name: idx_xlpmulmmghjebuqfpgrgcwgljbauuhmzkxer; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_xlpmulmmghjebuqfpgrgcwgljbauuhmzkxer ON public.structureelements USING btree (root);


--
-- Name: idx_xqxdgmprxluthfbnbckshsdnhtkyygvbspyv; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_xqxdgmprxluthfbnbckshsdnhtkyygvbspyv ON public.matrixblocktypes USING btree (name, "fieldId");


--
-- Name: idx_xuqowaqrrvgqlistluqihtadujctqwakdxwu; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_xuqowaqrrvgqlistluqihtadujctqwakdxwu ON public.relations USING btree ("fieldId", "sourceId", "sourceSiteId", "targetId");


--
-- Name: idx_ybksgjflahutfceyqeaflvbcopvvytdonfaf; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_ybksgjflahutfceyqeaflvbcopvvytdonfaf ON public.categorygroups_sites USING btree ("groupId", "siteId");


--
-- Name: idx_yrxftlnxpsmciukckimyjfeqwzntvcqipqxi; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_yrxftlnxpsmciukckimyjfeqwzntvcqipqxi ON public.sites USING btree ("sortOrder");


--
-- Name: idx_zasfvpoahplcfxeumgzgnzxbgcpfagpnvndo; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_zasfvpoahplcfxeumgzgnzxbgcpfagpnvndo ON public.sessions USING btree (token);


--
-- Name: idx_zdndeeuuwcedatjtgftdnsmwlhxglvgpxaus; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_zdndeeuuwcedatjtgftdnsmwlhxglvgpxaus ON public.structureelements USING btree (rgt);


--
-- Name: idx_zgcnapihnimdsbybbsupdjvrptppmwvrzqzs; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_zgcnapihnimdsbybbsupdjvrptppmwvrzqzs ON public.elementindexsettings USING btree (type);


--
-- Name: idx_ziqrgwirypwcmgbhxholppoirzukpgviiyty; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_ziqrgwirypwcmgbhxholppoirzukpgviiyty ON public.structureelements USING btree ("structureId", "elementId");


--
-- Name: idx_zjokdikzipkpbjrzpcjhbyklqfsupadfszkh; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_zjokdikzipkpbjrzpcjhbyklqfsupadfszkh ON public.relations USING btree ("sourceId");


--
-- Name: idx_zjsqazfrdnpaauhxyufuqlbskizitghwlcwz; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_zjsqazfrdnpaauhxyufuqlbskizitghwlcwz ON public.fields USING btree ("groupId");


--
-- Name: idx_zjyrvkmarmvzgtgqxshnjxhzdpbkpgnxvdxv; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE UNIQUE INDEX idx_zjyrvkmarmvzgtgqxshnjxhzdpbkpgnxvdxv ON public.gqltokens USING btree ("accessToken");


--
-- Name: idx_zmsizsccwslchutbplrheudfbqrwmdrlppah; Type: INDEX; Schema: public; Owner: skyviewer
--

CREATE INDEX idx_zmsizsccwslchutbplrheudfbqrwmdrlppah ON public.volumefolders USING btree ("volumeId");


--
-- Name: sessions fk_acapcwrtxkcbfpvcrircmxmzajykqkdrapda; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT fk_acapcwrtxkcbfpvcrircmxmzajykqkdrapda FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: craftidtokens fk_anncddwkkgbeknhwdmqtunlpmekxuhzfvrzs; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.craftidtokens
    ADD CONSTRAINT fk_anncddwkkgbeknhwdmqtunlpmekxuhzfvrzs FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: gqltokens fk_aourqrpugkkibrapdozivhaolxpylahiwfug; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.gqltokens
    ADD CONSTRAINT fk_aourqrpugkkibrapdozivhaolxpylahiwfug FOREIGN KEY ("schemaId") REFERENCES public.gqlschemas(id) ON DELETE SET NULL;


--
-- Name: matrixblocks fk_araaqeavsmgffynlfsrtyibkfmwmqmrispuc; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.matrixblocks
    ADD CONSTRAINT fk_araaqeavsmgffynlfsrtyibkfmwmqmrispuc FOREIGN KEY ("fieldId") REFERENCES public.fields(id) ON DELETE CASCADE;


--
-- Name: users fk_avooeanabxpkxyponktscntoanrcdfcxgpbg; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_avooeanabxpkxyponktscntoanrcdfcxgpbg FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: changedfields fk_azzkhjytfotjfwabxpvccgbnxcthgdecdysu; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.changedfields
    ADD CONSTRAINT fk_azzkhjytfotjfwabxpvccgbnxcthgdecdysu FOREIGN KEY ("fieldId") REFERENCES public.fields(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: elements_sites fk_baalghwvkgkaubibaxabpxeogzvepwrhrujt; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elements_sites
    ADD CONSTRAINT fk_baalghwvkgkaubibaxabpxeogzvepwrhrujt FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: relations fk_bcyfwivvzyxxvobykfcknsaxnsevrvztdnxz; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_bcyfwivvzyxxvobykfcknsaxnsevrvztdnxz FOREIGN KEY ("targetId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: categories fk_bhtscovzuwfwndtvugsyrvumfhcwmpikdaui; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_bhtscovzuwfwndtvugsyrvumfhcwmpikdaui FOREIGN KEY ("groupId") REFERENCES public.categorygroups(id) ON DELETE CASCADE;


--
-- Name: assets fk_blxwfdyggrimtvtcesmrepbcrsfwytlcszyi; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_blxwfdyggrimtvtcesmrepbcrsfwytlcszyi FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: entrytypes fk_btbdzklkalrnmahnydzzgqhidmiwvlhfgmzv; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.entrytypes
    ADD CONSTRAINT fk_btbdzklkalrnmahnydzzgqhidmiwvlhfgmzv FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- Name: changedattributes fk_bvrqiovnqfjapcrgbzfvzsjsccrxbkaerazr; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.changedattributes
    ADD CONSTRAINT fk_bvrqiovnqfjapcrgbzfvzsjsccrxbkaerazr FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: elements fk_clpcbyoxvqwzfofatabglgbebvompowgcyfp; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT fk_clpcbyoxvqwzfofatabglgbebvompowgcyfp FOREIGN KEY ("revisionId") REFERENCES public.revisions(id) ON DELETE CASCADE;


--
-- Name: entrytypes fk_cqgvrielnebilxqkzjnvoaadnocaqyobztpc; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.entrytypes
    ADD CONSTRAINT fk_cqgvrielnebilxqkzjnvoaadnocaqyobztpc FOREIGN KEY ("sectionId") REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: userpermissions_users fk_dphsfwlqyruxsalrsiivumtnscxrbormhyok; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpermissions_users
    ADD CONSTRAINT fk_dphsfwlqyruxsalrsiivumtnscxrbormhyok FOREIGN KEY ("permissionId") REFERENCES public.userpermissions(id) ON DELETE CASCADE;


--
-- Name: categories fk_dppvwxstbmhlmphrljswdkuyytaqhbdfanzi; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_dppvwxstbmhlmphrljswdkuyytaqhbdfanzi FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: categorygroups fk_dqbnjjtzjzmidwljrscnqjpehqxekfqldqtl; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categorygroups
    ADD CONSTRAINT fk_dqbnjjtzjzmidwljrscnqjpehqxekfqldqtl FOREIGN KEY ("structureId") REFERENCES public.structures(id) ON DELETE CASCADE;


--
-- Name: matrixblocktypes fk_dskhmacthjwrlinugyolppexvwweuqjkurrx; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.matrixblocktypes
    ADD CONSTRAINT fk_dskhmacthjwrlinugyolppexvwweuqjkurrx FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- Name: entries fk_dsklafpetxkeadsfrvihyvjmpohxjcidjiqr; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_dsklafpetxkeadsfrvihyvjmpohxjcidjiqr FOREIGN KEY ("typeId") REFERENCES public.entrytypes(id) ON DELETE CASCADE;


--
-- Name: fields fk_dveexxlnibjkmyeakcgoteribufsqfwajafq; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fields
    ADD CONSTRAINT fk_dveexxlnibjkmyeakcgoteribufsqfwajafq FOREIGN KEY ("groupId") REFERENCES public.fieldgroups(id) ON DELETE CASCADE;


--
-- Name: drafts fk_dxcryxmtajlhgoprjbiuxkuwpzwxxnwuzjwe; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.drafts
    ADD CONSTRAINT fk_dxcryxmtajlhgoprjbiuxkuwpzwxxnwuzjwe FOREIGN KEY ("creatorId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: relations fk_ebqmmgphfynuftwxcalphnjofzflasbyaasn; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_ebqmmgphfynuftwxcalphnjofzflasbyaasn FOREIGN KEY ("fieldId") REFERENCES public.fields(id) ON DELETE CASCADE;


--
-- Name: tags fk_ewbidcsefcwzbbeanwrnwrfgihcqnamsbvrp; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_ewbidcsefcwzbbeanwrnwrfgihcqnamsbvrp FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: elements fk_ewtmyjcqvkqrfytglpijzwcfhmcapqwzgpsc; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT fk_ewtmyjcqvkqrfytglpijzwcfhmcapqwzgpsc FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- Name: revisions fk_eyetqcrufhfxelkkjlzuvrdbjmzkjlapelim; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.revisions
    ADD CONSTRAINT fk_eyetqcrufhfxelkkjlzuvrdbjmzkjlapelim FOREIGN KEY ("sourceId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: changedfields fk_fdkqndlqpvzklxzwtbhfzokomgabwgzturby; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.changedfields
    ADD CONSTRAINT fk_fdkqndlqpvzklxzwtbhfzokomgabwgzturby FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: sites fk_fqnltiqgnuduvdksbrxdswgpicwjtqfyxllw; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT fk_fqnltiqgnuduvdksbrxdswgpicwjtqfyxllw FOREIGN KEY ("groupId") REFERENCES public.sitegroups(id) ON DELETE CASCADE;


--
-- Name: templatecacheelements fk_frhrwzpyrjzxdgeednauxfbdgbuvwpwqmpjz; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.templatecacheelements
    ADD CONSTRAINT fk_frhrwzpyrjzxdgeednauxfbdgbuvwpwqmpjz FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: fieldlayouttabs fk_fykpcumxtmiiccsyqftpyihmtixchdfeylxy; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldlayouttabs
    ADD CONSTRAINT fk_fykpcumxtmiiccsyqftpyihmtixchdfeylxy FOREIGN KEY ("layoutId") REFERENCES public.fieldlayouts(id) ON DELETE CASCADE;


--
-- Name: userpermissions_usergroups fk_gadsjqcmbnfuxubomxqkpuwdynuktnkplxpf; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpermissions_usergroups
    ADD CONSTRAINT fk_gadsjqcmbnfuxubomxqkpuwdynuktnkplxpf FOREIGN KEY ("permissionId") REFERENCES public.userpermissions(id) ON DELETE CASCADE;


--
-- Name: userpermissions_users fk_gifjhtsudjlgnzhuylqngacpwbftnykqczym; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpermissions_users
    ADD CONSTRAINT fk_gifjhtsudjlgnzhuylqngacpwbftnykqczym FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: fieldlayoutfields fk_gpddbfuvkqhnliuceyxowviqxdcjujfkbrkv; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldlayoutfields
    ADD CONSTRAINT fk_gpddbfuvkqhnliuceyxowviqxdcjujfkbrkv FOREIGN KEY ("fieldId") REFERENCES public.fields(id) ON DELETE CASCADE;


--
-- Name: categorygroups_sites fk_gqjmczlxxqtogtausixmprwqdgdofeyqjqvt; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categorygroups_sites
    ADD CONSTRAINT fk_gqjmczlxxqtogtausixmprwqdgdofeyqjqvt FOREIGN KEY ("groupId") REFERENCES public.categorygroups(id) ON DELETE CASCADE;


--
-- Name: changedattributes fk_gulsscrjmelxhtibudradswtohnzktpddpjy; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.changedattributes
    ADD CONSTRAINT fk_gulsscrjmelxhtibudradswtohnzktpddpjy FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: categorygroups_sites fk_hcqydxndhjvqlhqwancewqwyeeizsxigtmwb; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categorygroups_sites
    ADD CONSTRAINT fk_hcqydxndhjvqlhqwancewqwyeeizsxigtmwb FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: categorygroups fk_hlcsoqhdgxfwvuykndjycdpzovgyhffgtqne; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categorygroups
    ADD CONSTRAINT fk_hlcsoqhdgxfwvuykndjycdpzovgyhffgtqne FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- Name: content fk_hlmvwoxokzqvetfzwpkqhqqufgvdixthcjym; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT fk_hlmvwoxokzqvetfzwpkqhqqufgvdixthcjym FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: usergroups_users fk_iajjspnankfmhexucrqruyzntgitzvkdaazc; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.usergroups_users
    ADD CONSTRAINT fk_iajjspnankfmhexucrqruyzntgitzvkdaazc FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: matrixblocks fk_ibajiagocgofbtckkfshgiiklubaxtouyelc; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.matrixblocks
    ADD CONSTRAINT fk_ibajiagocgofbtckkfshgiiklubaxtouyelc FOREIGN KEY ("ownerId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: volumes fk_ijeqltjxlgxltsrdrygzzqgiaekdglzayjba; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.volumes
    ADD CONSTRAINT fk_ijeqltjxlgxltsrdrygzzqgiaekdglzayjba FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- Name: relations fk_jfeksulqfdslnpmddungigupphrvuvdmrsfn; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_jfeksulqfdslnpmddungigupphrvuvdmrsfn FOREIGN KEY ("sourceSiteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sections_sites fk_kamsfgleoyuhjndbtdhvxvjbcokmtlglmawn; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sections_sites
    ADD CONSTRAINT fk_kamsfgleoyuhjndbtdhvxvjbcokmtlglmawn FOREIGN KEY ("sectionId") REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: tags fk_kcxjvsbicqxkkxdcowaoroysdhwapfwxgkpj; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_kcxjvsbicqxkkxdcowaoroysdhwapfwxgkpj FOREIGN KEY ("groupId") REFERENCES public.taggroups(id) ON DELETE CASCADE;


--
-- Name: taggroups fk_keoxpzseiorfxllgseuxgxmwslhbayembhrk; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.taggroups
    ADD CONSTRAINT fk_keoxpzseiorfxllgseuxgxmwslhbayembhrk FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- Name: entries fk_kgjjbfilryyjpgxwthrszqubszgzvcvcucgx; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_kgjjbfilryyjpgxwthrszqubszgzvcvcucgx FOREIGN KEY ("sectionId") REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- Name: entries fk_kgtgxhxbkvczpdevtbyliplsvzbddesrjwhj; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_kgtgxhxbkvczpdevtbyliplsvzbddesrjwhj FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: changedattributes fk_kqdcmaygxrbqenaibrsxifpblthmdvtoddhy; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.changedattributes
    ADD CONSTRAINT fk_kqdcmaygxrbqenaibrsxifpblthmdvtoddhy FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: entries fk_myepbwawycrfseryfoeenlelcjjrabboeiba; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_myepbwawycrfseryfoeenlelcjjrabboeiba FOREIGN KEY ("authorId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: userpreferences fk_nvdnlrjoxgtibyniomlscxndfzgrofhhwkyk; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpreferences
    ADD CONSTRAINT fk_nvdnlrjoxgtibyniomlscxndfzgrofhhwkyk FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: users fk_nxffqauqqwhrrhjnespsyofevqqlwpnnplfq; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_nxffqauqqwhrrhjnespsyofevqqlwpnnplfq FOREIGN KEY ("photoId") REFERENCES public.assets(id) ON DELETE SET NULL;


--
-- Name: matrixblocktypes fk_nxpjahxiyspjualpicbxjriyfvzbpdcpthkz; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.matrixblocktypes
    ADD CONSTRAINT fk_nxpjahxiyspjualpicbxjriyfvzbpdcpthkz FOREIGN KEY ("fieldId") REFERENCES public.fields(id) ON DELETE CASCADE;


--
-- Name: globalsets fk_nzuzfxncmaojysjehxlkexofdflkltwpxiks; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.globalsets
    ADD CONSTRAINT fk_nzuzfxncmaojysjehxlkexofdflkltwpxiks FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- Name: structureelements fk_oglcfvchxbliovjeouunigqnewaetyviilqa; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.structureelements
    ADD CONSTRAINT fk_oglcfvchxbliovjeouunigqnewaetyviilqa FOREIGN KEY ("structureId") REFERENCES public.structures(id) ON DELETE CASCADE;


--
-- Name: matrixblocks fk_pevbofdckhgqybzjjbfmnoiamgjbaknilpjx; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.matrixblocks
    ADD CONSTRAINT fk_pevbofdckhgqybzjjbfmnoiamgjbaknilpjx FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: assets fk_pliaqhtmpxdcobtmuemgeczinaylamcmsjnw; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_pliaqhtmpxdcobtmuemgeczinaylamcmsjnw FOREIGN KEY ("folderId") REFERENCES public.volumefolders(id) ON DELETE CASCADE;


--
-- Name: fieldlayoutfields fk_prwczdkhxoskdsmjmuuikwkkcxoxdkqqzpei; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldlayoutfields
    ADD CONSTRAINT fk_prwczdkhxoskdsmjmuuikwkkcxoxdkqqzpei FOREIGN KEY ("tabId") REFERENCES public.fieldlayouttabs(id) ON DELETE CASCADE;


--
-- Name: volumefolders fk_qifhwkhhqhjvptudynzkavzfxuwcexqxsfjr; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.volumefolders
    ADD CONSTRAINT fk_qifhwkhhqhjvptudynzkavzfxuwcexqxsfjr FOREIGN KEY ("volumeId") REFERENCES public.volumes(id) ON DELETE CASCADE;


--
-- Name: templatecaches fk_qmbduzqhpbnsalyrmsejnulqgtscakxaepqm; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.templatecaches
    ADD CONSTRAINT fk_qmbduzqhpbnsalyrmsejnulqgtscakxaepqm FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: elements_sites fk_qulxgorjhbrrkxryqiydqoszksyyhmapfclm; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elements_sites
    ADD CONSTRAINT fk_qulxgorjhbrrkxryqiydqoszksyyhmapfclm FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: volumefolders fk_qwnetumldqouglypoexfxvvqecnqdtltdenw; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.volumefolders
    ADD CONSTRAINT fk_qwnetumldqouglypoexfxvvqecnqdtltdenw FOREIGN KEY ("parentId") REFERENCES public.volumefolders(id) ON DELETE CASCADE;


--
-- Name: templatecachequeries fk_rssrrjnxgojeloqdytmgqqjpbzkyekvdmgtu; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.templatecachequeries
    ADD CONSTRAINT fk_rssrrjnxgojeloqdytmgqqjpbzkyekvdmgtu FOREIGN KEY ("cacheId") REFERENCES public.templatecaches(id) ON DELETE CASCADE;


--
-- Name: shunnedmessages fk_salqvlhiukuadtjrkdpoqpadgxyxwfgswbvp; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.shunnedmessages
    ADD CONSTRAINT fk_salqvlhiukuadtjrkdpoqpadgxyxwfgswbvp FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: sections_sites fk_sapdvsolxaeqxpjsofzhhbhhsinkwfebvrke; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sections_sites
    ADD CONSTRAINT fk_sapdvsolxaeqxpjsofzhhbhhsinkwfebvrke FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: widgets fk_ssooxbzzpxuzcksmvdzdewhxtdzevncbfnnb; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT fk_ssooxbzzpxuzcksmvdzdewhxtdzevncbfnnb FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: structureelements fk_tcrgzpgjihvbacgyeifolwlpmmicfcadjdxk; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.structureelements
    ADD CONSTRAINT fk_tcrgzpgjihvbacgyeifolwlpmmicfcadjdxk FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: changedfields fk_ttzvlzzvlpywtkzakiotqbvtbaedcohjpwzc; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.changedfields
    ADD CONSTRAINT fk_ttzvlzzvlpywtkzakiotqbvtbaedcohjpwzc FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: content fk_uhpbzxedulgcilqpceuecavtiiirrtbvhcsq; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT fk_uhpbzxedulgcilqpceuecavtiiirrtbvhcsq FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: userpermissions_usergroups fk_uvipnepqohqvckydpoffratpsojuevuglwks; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.userpermissions_usergroups
    ADD CONSTRAINT fk_uvipnepqohqvckydpoffratpsojuevuglwks FOREIGN KEY ("groupId") REFERENCES public.usergroups(id) ON DELETE CASCADE;


--
-- Name: elements fk_uxksfnwvglvkmkhhombxfrqazqkjgectxhvc; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT fk_uxksfnwvglvkmkhhombxfrqazqkjgectxhvc FOREIGN KEY ("draftId") REFERENCES public.drafts(id) ON DELETE CASCADE;


--
-- Name: templatecacheelements fk_vbjbessmrosfylraudllwxtufzehmjhhudbj; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.templatecacheelements
    ADD CONSTRAINT fk_vbjbessmrosfylraudllwxtufzehmjhhudbj FOREIGN KEY ("cacheId") REFERENCES public.templatecaches(id) ON DELETE CASCADE;


--
-- Name: entries fk_vfdogasytasksaavoaupnedeivxvzdyjrfbg; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_vfdogasytasksaavoaupnedeivxvzdyjrfbg FOREIGN KEY ("parentId") REFERENCES public.entries(id) ON DELETE SET NULL;


--
-- Name: categories fk_vogfdrxhlwzawqhxmlipsoaepvqlbboaweoi; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_vogfdrxhlwzawqhxmlipsoaepvqlbboaweoi FOREIGN KEY ("parentId") REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- Name: assets fk_vqvjysrngzlhivsudijmrbnnlxvjrvbwsklv; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_vqvjysrngzlhivsudijmrbnnlxvjrvbwsklv FOREIGN KEY ("volumeId") REFERENCES public.volumes(id) ON DELETE CASCADE;


--
-- Name: globalsets fk_vtlhnmgkgflbatxapriuhfjhczeqesirbqam; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.globalsets
    ADD CONSTRAINT fk_vtlhnmgkgflbatxapriuhfjhczeqesirbqam FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: drafts fk_wgkdcxubcosrjalbbrbcbtjzvkqlzkvlcnwg; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.drafts
    ADD CONSTRAINT fk_wgkdcxubcosrjalbbrbcbtjzvkqlzkvlcnwg FOREIGN KEY ("sourceId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: changedfields fk_wwecvotqkkkvetdmsqkoeisqdtoilmutjmok; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.changedfields
    ADD CONSTRAINT fk_wwecvotqkkkvetdmsqkoeisqdtoilmutjmok FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: assets fk_wxxpowhecgzxdomankczvkhvlpkiqxmcpgnm; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_wxxpowhecgzxdomankczvkhvlpkiqxmcpgnm FOREIGN KEY ("uploaderId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: relations fk_xsxmugogqbsskvakqzkeoyrwtnzibejqchky; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_xsxmugogqbsskvakqzkeoyrwtnzibejqchky FOREIGN KEY ("sourceId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- Name: sections fk_yfwjnmvmyksxuiylfyystjetqpyjrijaosbl; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT fk_yfwjnmvmyksxuiylfyystjetqpyjrijaosbl FOREIGN KEY ("structureId") REFERENCES public.structures(id) ON DELETE SET NULL;


--
-- Name: fieldlayoutfields fk_yretsbatlsvddfusomhjctpsiqticzuqhqjr; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.fieldlayoutfields
    ADD CONSTRAINT fk_yretsbatlsvddfusomhjctpsiqticzuqhqjr FOREIGN KEY ("layoutId") REFERENCES public.fieldlayouts(id) ON DELETE CASCADE;


--
-- Name: assetindexdata fk_yrnoyuydmxlmlydmcxmwcqwrsqmreeeiywtq; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.assetindexdata
    ADD CONSTRAINT fk_yrnoyuydmxlmlydmcxmwcqwrsqmreeeiywtq FOREIGN KEY ("volumeId") REFERENCES public.volumes(id) ON DELETE CASCADE;


--
-- Name: revisions fk_ysabcqjrntaviyfxmufksdighinpjuplkgvs; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.revisions
    ADD CONSTRAINT fk_ysabcqjrntaviyfxmufksdighinpjuplkgvs FOREIGN KEY ("creatorId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: usergroups_users fk_ywabfwubrrvwmfqkbtqdntpssdsrndpbgfkh; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.usergroups_users
    ADD CONSTRAINT fk_ywabfwubrrvwmfqkbtqdntpssdsrndpbgfkh FOREIGN KEY ("groupId") REFERENCES public.usergroups(id) ON DELETE CASCADE;


--
-- Name: matrixblocks fk_ziuwxjfdaktbzbjffckkspykcokzjsvtezpt; Type: FK CONSTRAINT; Schema: public; Owner: skyviewer
--

ALTER TABLE ONLY public.matrixblocks
    ADD CONSTRAINT fk_ziuwxjfdaktbzbjffckkspykcokzjsvtezpt FOREIGN KEY ("typeId") REFERENCES public.matrixblocktypes(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

