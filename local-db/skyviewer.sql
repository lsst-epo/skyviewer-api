--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.2

-- Started on 2021-10-27 16:06:43 MST
CREATE DATABASE skyviewer;
\c skyviewer
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

--
-- TOC entry 3 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

--CREATE SCHEMA public;


--
-- TOC entry 4691 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

--COMMENT ON SCHEMA public IS 'standard public schema';


SET default_table_access_method = heap;

--
-- TOC entry 323 (class 1259 OID 17993)
-- Name: announcements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.announcements (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    "pluginId" integer,
    heading character varying(255) NOT NULL,
    body text NOT NULL,
    unread boolean DEFAULT true NOT NULL,
    "dateRead" timestamp(0) without time zone,
    "dateCreated" timestamp(0) without time zone NOT NULL
);


--
-- TOC entry 322 (class 1259 OID 17991)
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.announcements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4692 (class 0 OID 0)
-- Dependencies: 322
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.announcements_id_seq OWNED BY public.announcements.id;


--
-- TOC entry 200 (class 1259 OID 16444)
-- Name: assetindexdata; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 201 (class 1259 OID 16454)
-- Name: assetindexdata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assetindexdata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4693 (class 0 OID 0)
-- Dependencies: 201
-- Name: assetindexdata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assetindexdata_id_seq OWNED BY public.assetindexdata.id;


--
-- TOC entry 202 (class 1259 OID 16456)
-- Name: assets; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 203 (class 1259 OID 16462)
-- Name: assettransformindex; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 204 (class 1259 OID 16472)
-- Name: assettransformindex_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assettransformindex_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4694 (class 0 OID 0)
-- Dependencies: 204
-- Name: assettransformindex_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assettransformindex_id_seq OWNED BY public.assettransformindex.id;


--
-- TOC entry 205 (class 1259 OID 16474)
-- Name: assettransforms; Type: TABLE; Schema: public; Owner: -
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
    CONSTRAINT assettransforms_interlace_check CHECK (((interlace)::text = ANY (ARRAY[('none'::character varying)::text, ('line'::character varying)::text, ('plane'::character varying)::text, ('partition'::character varying)::text]))),
    CONSTRAINT assettransforms_mode_check CHECK (((mode)::text = ANY (ARRAY[('stretch'::character varying)::text, ('fit'::character varying)::text, ('crop'::character varying)::text]))),
    CONSTRAINT assettransforms_position_check CHECK ((("position")::text = ANY (ARRAY[('top-left'::character varying)::text, ('top-center'::character varying)::text, ('top-right'::character varying)::text, ('center-left'::character varying)::text, ('center-center'::character varying)::text, ('center-right'::character varying)::text, ('bottom-left'::character varying)::text, ('bottom-center'::character varying)::text, ('bottom-right'::character varying)::text])))
);


--
-- TOC entry 206 (class 1259 OID 16487)
-- Name: assettransforms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.assettransforms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4695 (class 0 OID 0)
-- Dependencies: 206
-- Name: assettransforms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.assettransforms_id_seq OWNED BY public.assettransforms.id;


--
-- TOC entry 207 (class 1259 OID 16489)
-- Name: categories; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 208 (class 1259 OID 16493)
-- Name: categorygroups; Type: TABLE; Schema: public; Owner: -
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
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    "defaultPlacement" character varying(255) DEFAULT 'end'::character varying NOT NULL,
    CONSTRAINT "categorygroups_defaultPlacement_check" CHECK ((("defaultPlacement")::text = ANY ((ARRAY['beginning'::character varying, 'end'::character varying])::text[])))
);


--
-- TOC entry 209 (class 1259 OID 16501)
-- Name: categorygroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorygroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4696 (class 0 OID 0)
-- Dependencies: 209
-- Name: categorygroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorygroups_id_seq OWNED BY public.categorygroups.id;


--
-- TOC entry 210 (class 1259 OID 16503)
-- Name: categorygroups_sites; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 211 (class 1259 OID 16511)
-- Name: categorygroups_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categorygroups_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4697 (class 0 OID 0)
-- Dependencies: 211
-- Name: categorygroups_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categorygroups_sites_id_seq OWNED BY public.categorygroups_sites.id;


--
-- TOC entry 212 (class 1259 OID 16513)
-- Name: changedattributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.changedattributes (
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    attribute character varying(255) NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    propagated boolean NOT NULL,
    "userId" integer
);


--
-- TOC entry 213 (class 1259 OID 16516)
-- Name: changedfields; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.changedfields (
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    "fieldId" integer NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    propagated boolean NOT NULL,
    "userId" integer
);


--
-- TOC entry 214 (class 1259 OID 16519)
-- Name: content; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.content (
    id integer NOT NULL,
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    title character varying(255),
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    field_path character varying(255),
    "field_siteDescription" text,
    "field_siteTitle" text,
    "field_catalogVariety" character varying(255),
    "field_sourceSize" integer,
    field_target text,
    field_fov integer,
    "field_fovMin" integer,
    "field_fovMax" integer,
    field_heading text,
    field_subheading text,
    field_duration integer,
    field_complexity smallint,
    field_description text,
    field_ra integer,
    field_dec integer,
    "field_factsHeading" text,
    "field_introHeading" text,
    "field_introSubheading" text,
    field_characteristics text,
    "field_altText" text,
    "field_astroObjectId" text,
    "field_varietyHandle" text,
    "field_varietyName" text
);


--
-- TOC entry 215 (class 1259 OID 16526)
-- Name: content_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.content_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4698 (class 0 OID 0)
-- Dependencies: 215
-- Name: content_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.content_id_seq OWNED BY public.content.id;


--
-- TOC entry 216 (class 1259 OID 16528)
-- Name: craftidtokens; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 217 (class 1259 OID 16535)
-- Name: craftidtokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.craftidtokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4699 (class 0 OID 0)
-- Dependencies: 217
-- Name: craftidtokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.craftidtokens_id_seq OWNED BY public.craftidtokens.id;


--
-- TOC entry 218 (class 1259 OID 16537)
-- Name: deprecationerrors; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 219 (class 1259 OID 16544)
-- Name: deprecationerrors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deprecationerrors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4700 (class 0 OID 0)
-- Dependencies: 219
-- Name: deprecationerrors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deprecationerrors_id_seq OWNED BY public.deprecationerrors.id;


--
-- TOC entry 220 (class 1259 OID 16546)
-- Name: drafts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.drafts (
    id integer NOT NULL,
    "sourceId" integer,
    "creatorId" integer,
    name character varying(255) NOT NULL,
    notes text,
    "trackChanges" boolean DEFAULT false NOT NULL,
    "dateLastMerged" timestamp(0) without time zone,
    saved boolean DEFAULT true NOT NULL,
    provisional boolean DEFAULT false NOT NULL
);


--
-- TOC entry 221 (class 1259 OID 16554)
-- Name: drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.drafts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 221
-- Name: drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.drafts_id_seq OWNED BY public.drafts.id;


--
-- TOC entry 222 (class 1259 OID 16556)
-- Name: elementindexsettings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.elementindexsettings (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    settings text,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 16563)
-- Name: elementindexsettings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.elementindexsettings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4702 (class 0 OID 0)
-- Dependencies: 223
-- Name: elementindexsettings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.elementindexsettings_id_seq OWNED BY public.elementindexsettings.id;


--
-- TOC entry 224 (class 1259 OID 16565)
-- Name: elements; Type: TABLE; Schema: public; Owner: -
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
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    "canonicalId" integer,
    "dateLastMerged" timestamp(0) without time zone
);


--
-- TOC entry 225 (class 1259 OID 16572)
-- Name: elements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.elements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 225
-- Name: elements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.elements_id_seq OWNED BY public.elements.id;


--
-- TOC entry 226 (class 1259 OID 16574)
-- Name: elements_sites; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 227 (class 1259 OID 16582)
-- Name: elements_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.elements_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4704 (class 0 OID 0)
-- Dependencies: 227
-- Name: elements_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.elements_sites_id_seq OWNED BY public.elements_sites.id;


--
-- TOC entry 228 (class 1259 OID 16584)
-- Name: entries; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 229 (class 1259 OID 16588)
-- Name: entrytypes; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 230 (class 1259 OID 16598)
-- Name: entrytypes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.entrytypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4705 (class 0 OID 0)
-- Dependencies: 230
-- Name: entrytypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.entrytypes_id_seq OWNED BY public.entrytypes.id;


--
-- TOC entry 231 (class 1259 OID 16600)
-- Name: fieldgroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fieldgroups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 232 (class 1259 OID 16605)
-- Name: fieldgroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fieldgroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 232
-- Name: fieldgroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fieldgroups_id_seq OWNED BY public.fieldgroups.id;


--
-- TOC entry 233 (class 1259 OID 16607)
-- Name: fieldlayoutfields; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 234 (class 1259 OID 16612)
-- Name: fieldlayoutfields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fieldlayoutfields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4707 (class 0 OID 0)
-- Dependencies: 234
-- Name: fieldlayoutfields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fieldlayoutfields_id_seq OWNED BY public.fieldlayoutfields.id;


--
-- TOC entry 235 (class 1259 OID 16614)
-- Name: fieldlayouts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fieldlayouts (
    id integer NOT NULL,
    type character varying(255) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 16619)
-- Name: fieldlayouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fieldlayouts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4708 (class 0 OID 0)
-- Dependencies: 236
-- Name: fieldlayouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fieldlayouts_id_seq OWNED BY public.fieldlayouts.id;


--
-- TOC entry 237 (class 1259 OID 16621)
-- Name: fieldlayouttabs; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 238 (class 1259 OID 16628)
-- Name: fieldlayouttabs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fieldlayouttabs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4709 (class 0 OID 0)
-- Dependencies: 238
-- Name: fieldlayouttabs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fieldlayouttabs_id_seq OWNED BY public.fieldlayouttabs.id;


--
-- TOC entry 239 (class 1259 OID 16630)
-- Name: fields; Type: TABLE; Schema: public; Owner: -
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
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    "columnSuffix" character(8)
);


--
-- TOC entry 240 (class 1259 OID 16640)
-- Name: fields_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4710 (class 0 OID 0)
-- Dependencies: 240
-- Name: fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fields_id_seq OWNED BY public.fields.id;


--
-- TOC entry 241 (class 1259 OID 16642)
-- Name: globalsets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.globalsets (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    "fieldLayoutId" integer,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    "sortOrder" smallint
);


--
-- TOC entry 242 (class 1259 OID 16649)
-- Name: globalsets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.globalsets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4711 (class 0 OID 0)
-- Dependencies: 242
-- Name: globalsets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.globalsets_id_seq OWNED BY public.globalsets.id;


--
-- TOC entry 243 (class 1259 OID 16651)
-- Name: gqlschemas; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 244 (class 1259 OID 16659)
-- Name: gqlschemas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gqlschemas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4712 (class 0 OID 0)
-- Dependencies: 244
-- Name: gqlschemas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gqlschemas_id_seq OWNED BY public.gqlschemas.id;


--
-- TOC entry 245 (class 1259 OID 16661)
-- Name: gqltokens; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 246 (class 1259 OID 16669)
-- Name: gqltokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gqltokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4713 (class 0 OID 0)
-- Dependencies: 246
-- Name: gqltokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gqltokens_id_seq OWNED BY public.gqltokens.id;


--
-- TOC entry 247 (class 1259 OID 16671)
-- Name: info; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 248 (class 1259 OID 16678)
-- Name: info_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4714 (class 0 OID 0)
-- Dependencies: 248
-- Name: info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.info_id_seq OWNED BY public.info.id;


--
-- TOC entry 249 (class 1259 OID 16680)
-- Name: matrixblocks; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 250 (class 1259 OID 16684)
-- Name: matrixblocktypes; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 251 (class 1259 OID 16691)
-- Name: matrixblocktypes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.matrixblocktypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4715 (class 0 OID 0)
-- Dependencies: 251
-- Name: matrixblocktypes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.matrixblocktypes_id_seq OWNED BY public.matrixblocktypes.id;


--
-- TOC entry 252 (class 1259 OID 16693)
-- Name: matrixcontent_factscontentblocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.matrixcontent_factscontentblocks (
    id integer NOT NULL,
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    "field_factsContentBlock_body" text
);


--
-- TOC entry 253 (class 1259 OID 16700)
-- Name: matrixcontent_factscontentblocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.matrixcontent_factscontentblocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4716 (class 0 OID 0)
-- Dependencies: 253
-- Name: matrixcontent_factscontentblocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.matrixcontent_factscontentblocks_id_seq OWNED BY public.matrixcontent_factscontentblocks.id;


--
-- TOC entry 254 (class 1259 OID 16702)
-- Name: matrixcontent_introcontentblocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.matrixcontent_introcontentblocks (
    id integer NOT NULL,
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    "field_introBlock_body" text
);


--
-- TOC entry 255 (class 1259 OID 16709)
-- Name: matrixcontent_introcontentblocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.matrixcontent_introcontentblocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4717 (class 0 OID 0)
-- Dependencies: 255
-- Name: matrixcontent_introcontentblocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.matrixcontent_introcontentblocks_id_seq OWNED BY public.matrixcontent_introcontentblocks.id;


--
-- TOC entry 256 (class 1259 OID 16711)
-- Name: matrixcontent_poiastroobject; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.matrixcontent_poiastroobject (
    id integer NOT NULL,
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 257 (class 1259 OID 16715)
-- Name: matrixcontent_poiastroobject_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.matrixcontent_poiastroobject_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4718 (class 0 OID 0)
-- Dependencies: 257
-- Name: matrixcontent_poiastroobject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.matrixcontent_poiastroobject_id_seq OWNED BY public.matrixcontent_poiastroobject.id;


--
-- TOC entry 258 (class 1259 OID 16717)
-- Name: matrixcontent_tourpois; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.matrixcontent_tourpois (
    id integer NOT NULL,
    "elementId" integer NOT NULL,
    "siteId" integer NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL,
    "field_tourPoi_description" text,
    "field_tourPoi_fov" integer
);


--
-- TOC entry 259 (class 1259 OID 16724)
-- Name: matrixcontent_tourpois_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.matrixcontent_tourpois_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4719 (class 0 OID 0)
-- Dependencies: 259
-- Name: matrixcontent_tourpois_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.matrixcontent_tourpois_id_seq OWNED BY public.matrixcontent_tourpois.id;


--
-- TOC entry 260 (class 1259 OID 16726)
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 261 (class 1259 OID 16733)
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4720 (class 0 OID 0)
-- Dependencies: 261
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- TOC entry 262 (class 1259 OID 16735)
-- Name: plugins; Type: TABLE; Schema: public; Owner: -
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
    CONSTRAINT "plugins_licenseKeyStatus_check" CHECK ((("licenseKeyStatus")::text = ANY (ARRAY[('valid'::character varying)::text, ('trial'::character varying)::text, ('invalid'::character varying)::text, ('mismatched'::character varying)::text, ('astray'::character varying)::text, ('unknown'::character varying)::text])))
);


--
-- TOC entry 263 (class 1259 OID 16744)
-- Name: plugins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plugins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4721 (class 0 OID 0)
-- Dependencies: 263
-- Name: plugins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plugins_id_seq OWNED BY public.plugins.id;


--
-- TOC entry 264 (class 1259 OID 16746)
-- Name: projectconfig; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projectconfig (
    path character varying(255) NOT NULL,
    value text NOT NULL
);


--
-- TOC entry 265 (class 1259 OID 16756)
-- Name: queue; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 266 (class 1259 OID 16767)
-- Name: queue_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.queue_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4722 (class 0 OID 0)
-- Dependencies: 266
-- Name: queue_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.queue_id_seq OWNED BY public.queue.id;


--
-- TOC entry 267 (class 1259 OID 16769)
-- Name: relations; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 268 (class 1259 OID 16773)
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4723 (class 0 OID 0)
-- Dependencies: 268
-- Name: relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.relations_id_seq OWNED BY public.relations.id;


--
-- TOC entry 269 (class 1259 OID 16775)
-- Name: resourcepaths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.resourcepaths (
    hash character varying(255) NOT NULL,
    path character varying(255) NOT NULL
);


--
-- TOC entry 270 (class 1259 OID 16781)
-- Name: revisions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.revisions (
    id integer NOT NULL,
    "sourceId" integer NOT NULL,
    "creatorId" integer,
    num integer NOT NULL,
    notes text
);


--
-- TOC entry 271 (class 1259 OID 16787)
-- Name: revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 271
-- Name: revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.revisions_id_seq OWNED BY public.revisions.id;


--
-- TOC entry 272 (class 1259 OID 16789)
-- Name: searchindex; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.searchindex (
    "elementId" integer NOT NULL,
    attribute character varying(25) NOT NULL,
    "fieldId" integer NOT NULL,
    "siteId" integer NOT NULL,
    keywords text NOT NULL,
    keywords_vector tsvector NOT NULL
);


--
-- TOC entry 273 (class 1259 OID 16795)
-- Name: sections; Type: TABLE; Schema: public; Owner: -
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
    "defaultPlacement" character varying(255) DEFAULT 'end'::character varying NOT NULL,
    CONSTRAINT "sections_defaultPlacement_check" CHECK ((("defaultPlacement")::text = ANY ((ARRAY['beginning'::character varying, 'end'::character varying])::text[]))),
    CONSTRAINT sections_type_check CHECK (((type)::text = ANY (ARRAY[('single'::character varying)::text, ('channel'::character varying)::text, ('structure'::character varying)::text])))
);


--
-- TOC entry 274 (class 1259 OID 16807)
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4725 (class 0 OID 0)
-- Dependencies: 274
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sections_id_seq OWNED BY public.sections.id;


--
-- TOC entry 275 (class 1259 OID 16809)
-- Name: sections_sites; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 276 (class 1259 OID 16818)
-- Name: sections_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sections_sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4726 (class 0 OID 0)
-- Dependencies: 276
-- Name: sections_sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sections_sites_id_seq OWNED BY public.sections_sites.id;


--
-- TOC entry 277 (class 1259 OID 16820)
-- Name: sequences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sequences (
    name character varying(255) NOT NULL,
    next integer DEFAULT 1 NOT NULL
);


--
-- TOC entry 278 (class 1259 OID 16824)
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    "userId" integer NOT NULL,
    token character(100) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 279 (class 1259 OID 16828)
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 279
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- TOC entry 280 (class 1259 OID 16830)
-- Name: shunnedmessages; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 281 (class 1259 OID 16834)
-- Name: shunnedmessages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shunnedmessages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4728 (class 0 OID 0)
-- Dependencies: 281
-- Name: shunnedmessages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shunnedmessages_id_seq OWNED BY public.shunnedmessages.id;


--
-- TOC entry 282 (class 1259 OID 16836)
-- Name: sitegroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sitegroups (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 283 (class 1259 OID 16841)
-- Name: sitegroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sitegroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4729 (class 0 OID 0)
-- Dependencies: 283
-- Name: sitegroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sitegroups_id_seq OWNED BY public.sitegroups.id;


--
-- TOC entry 284 (class 1259 OID 16843)
-- Name: sites; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 285 (class 1259 OID 16853)
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 285
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sites_id_seq OWNED BY public.sites.id;


--
-- TOC entry 286 (class 1259 OID 16855)
-- Name: structureelements; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 287 (class 1259 OID 16859)
-- Name: structureelements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.structureelements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 287
-- Name: structureelements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.structureelements_id_seq OWNED BY public.structureelements.id;


--
-- TOC entry 288 (class 1259 OID 16861)
-- Name: structures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.structures (
    id integer NOT NULL,
    "maxLevels" smallint,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    "dateDeleted" timestamp(0) without time zone DEFAULT NULL::timestamp without time zone,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 289 (class 1259 OID 16866)
-- Name: structures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.structures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 289
-- Name: structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.structures_id_seq OWNED BY public.structures.id;


--
-- TOC entry 290 (class 1259 OID 16868)
-- Name: systemmessages; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 291 (class 1259 OID 16875)
-- Name: systemmessages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.systemmessages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4733 (class 0 OID 0)
-- Dependencies: 291
-- Name: systemmessages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.systemmessages_id_seq OWNED BY public.systemmessages.id;


--
-- TOC entry 292 (class 1259 OID 16877)
-- Name: taggroups; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 293 (class 1259 OID 16885)
-- Name: taggroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.taggroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4734 (class 0 OID 0)
-- Dependencies: 293
-- Name: taggroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.taggroups_id_seq OWNED BY public.taggroups.id;


--
-- TOC entry 294 (class 1259 OID 16887)
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    "groupId" integer NOT NULL,
    "deletedWithGroup" boolean,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 295 (class 1259 OID 16891)
-- Name: templatecacheelements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.templatecacheelements (
    id integer NOT NULL,
    "cacheId" integer NOT NULL,
    "elementId" integer NOT NULL
);


--
-- TOC entry 296 (class 1259 OID 16894)
-- Name: templatecacheelements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.templatecacheelements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 296
-- Name: templatecacheelements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.templatecacheelements_id_seq OWNED BY public.templatecacheelements.id;


--
-- TOC entry 297 (class 1259 OID 16896)
-- Name: templatecachequeries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.templatecachequeries (
    id integer NOT NULL,
    "cacheId" integer NOT NULL,
    type character varying(255) NOT NULL,
    query text NOT NULL
);


--
-- TOC entry 298 (class 1259 OID 16902)
-- Name: templatecachequeries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.templatecachequeries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4736 (class 0 OID 0)
-- Dependencies: 298
-- Name: templatecachequeries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.templatecachequeries_id_seq OWNED BY public.templatecachequeries.id;


--
-- TOC entry 299 (class 1259 OID 16904)
-- Name: templatecaches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.templatecaches (
    id integer NOT NULL,
    "siteId" integer NOT NULL,
    "cacheKey" character varying(255) NOT NULL,
    path character varying(255),
    "expiryDate" timestamp(0) without time zone NOT NULL,
    body text NOT NULL
);


--
-- TOC entry 300 (class 1259 OID 16910)
-- Name: templatecaches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.templatecaches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4737 (class 0 OID 0)
-- Dependencies: 300
-- Name: templatecaches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.templatecaches_id_seq OWNED BY public.templatecaches.id;


--
-- TOC entry 301 (class 1259 OID 16912)
-- Name: tokens; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 302 (class 1259 OID 16919)
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4738 (class 0 OID 0)
-- Dependencies: 302
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;


--
-- TOC entry 303 (class 1259 OID 16921)
-- Name: usergroups; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 304 (class 1259 OID 16928)
-- Name: usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4739 (class 0 OID 0)
-- Dependencies: 304
-- Name: usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usergroups_id_seq OWNED BY public.usergroups.id;


--
-- TOC entry 305 (class 1259 OID 16930)
-- Name: usergroups_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.usergroups_users (
    id integer NOT NULL,
    "groupId" integer NOT NULL,
    "userId" integer NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 306 (class 1259 OID 16934)
-- Name: usergroups_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.usergroups_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4740 (class 0 OID 0)
-- Dependencies: 306
-- Name: usergroups_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.usergroups_users_id_seq OWNED BY public.usergroups_users.id;


--
-- TOC entry 307 (class 1259 OID 16936)
-- Name: userpermissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.userpermissions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 308 (class 1259 OID 16940)
-- Name: userpermissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.userpermissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4741 (class 0 OID 0)
-- Dependencies: 308
-- Name: userpermissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.userpermissions_id_seq OWNED BY public.userpermissions.id;


--
-- TOC entry 309 (class 1259 OID 16942)
-- Name: userpermissions_usergroups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.userpermissions_usergroups (
    id integer NOT NULL,
    "permissionId" integer NOT NULL,
    "groupId" integer NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 310 (class 1259 OID 16946)
-- Name: userpermissions_usergroups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.userpermissions_usergroups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4742 (class 0 OID 0)
-- Dependencies: 310
-- Name: userpermissions_usergroups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.userpermissions_usergroups_id_seq OWNED BY public.userpermissions_usergroups.id;


--
-- TOC entry 311 (class 1259 OID 16948)
-- Name: userpermissions_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.userpermissions_users (
    id integer NOT NULL,
    "permissionId" integer NOT NULL,
    "userId" integer NOT NULL,
    "dateCreated" timestamp(0) without time zone NOT NULL,
    "dateUpdated" timestamp(0) without time zone NOT NULL,
    uid character(36) DEFAULT '0'::bpchar NOT NULL
);


--
-- TOC entry 312 (class 1259 OID 16952)
-- Name: userpermissions_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.userpermissions_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4743 (class 0 OID 0)
-- Dependencies: 312
-- Name: userpermissions_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.userpermissions_users_id_seq OWNED BY public.userpermissions_users.id;


--
-- TOC entry 313 (class 1259 OID 16954)
-- Name: userpreferences; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.userpreferences (
    "userId" integer NOT NULL,
    preferences text
);


--
-- TOC entry 314 (class 1259 OID 16960)
-- Name: userpreferences_userId_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public."userpreferences_userId_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4744 (class 0 OID 0)
-- Dependencies: 314
-- Name: userpreferences_userId_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public."userpreferences_userId_seq" OWNED BY public.userpreferences."userId";


--
-- TOC entry 315 (class 1259 OID 16962)
-- Name: users; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 316 (class 1259 OID 16975)
-- Name: volumefolders; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 317 (class 1259 OID 16982)
-- Name: volumefolders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.volumefolders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4745 (class 0 OID 0)
-- Dependencies: 317
-- Name: volumefolders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.volumefolders_id_seq OWNED BY public.volumefolders.id;


--
-- TOC entry 318 (class 1259 OID 16984)
-- Name: volumes; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 319 (class 1259 OID 16994)
-- Name: volumes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.volumes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4746 (class 0 OID 0)
-- Dependencies: 319
-- Name: volumes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.volumes_id_seq OWNED BY public.volumes.id;


--
-- TOC entry 320 (class 1259 OID 16996)
-- Name: widgets; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 321 (class 1259 OID 17004)
-- Name: widgets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.widgets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4747 (class 0 OID 0)
-- Dependencies: 321
-- Name: widgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.widgets_id_seq OWNED BY public.widgets.id;


--
-- TOC entry 4051 (class 2604 OID 17996)
-- Name: announcements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements ALTER COLUMN id SET DEFAULT nextval('public.announcements_id_seq'::regclass);


--
-- TOC entry 3874 (class 2604 OID 17006)
-- Name: assetindexdata id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assetindexdata ALTER COLUMN id SET DEFAULT nextval('public.assetindexdata_id_seq'::regclass);


--
-- TOC entry 3882 (class 2604 OID 17007)
-- Name: assettransformindex id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assettransformindex ALTER COLUMN id SET DEFAULT nextval('public.assettransformindex_id_seq'::regclass);


--
-- TOC entry 3887 (class 2604 OID 17008)
-- Name: assettransforms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assettransforms ALTER COLUMN id SET DEFAULT nextval('public.assettransforms_id_seq'::regclass);


--
-- TOC entry 3894 (class 2604 OID 17009)
-- Name: categorygroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorygroups ALTER COLUMN id SET DEFAULT nextval('public.categorygroups_id_seq'::regclass);


--
-- TOC entry 3899 (class 2604 OID 17010)
-- Name: categorygroups_sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorygroups_sites ALTER COLUMN id SET DEFAULT nextval('public.categorygroups_sites_id_seq'::regclass);


--
-- TOC entry 3901 (class 2604 OID 17011)
-- Name: content id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content ALTER COLUMN id SET DEFAULT nextval('public.content_id_seq'::regclass);


--
-- TOC entry 3903 (class 2604 OID 17012)
-- Name: craftidtokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.craftidtokens ALTER COLUMN id SET DEFAULT nextval('public.craftidtokens_id_seq'::regclass);


--
-- TOC entry 3905 (class 2604 OID 17013)
-- Name: deprecationerrors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deprecationerrors ALTER COLUMN id SET DEFAULT nextval('public.deprecationerrors_id_seq'::regclass);


--
-- TOC entry 3908 (class 2604 OID 17014)
-- Name: drafts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drafts ALTER COLUMN id SET DEFAULT nextval('public.drafts_id_seq'::regclass);


--
-- TOC entry 3911 (class 2604 OID 17015)
-- Name: elementindexsettings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elementindexsettings ALTER COLUMN id SET DEFAULT nextval('public.elementindexsettings_id_seq'::regclass);


--
-- TOC entry 3916 (class 2604 OID 17016)
-- Name: elements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elements ALTER COLUMN id SET DEFAULT nextval('public.elements_id_seq'::regclass);


--
-- TOC entry 3919 (class 2604 OID 17017)
-- Name: elements_sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elements_sites ALTER COLUMN id SET DEFAULT nextval('public.elements_sites_id_seq'::regclass);


--
-- TOC entry 3925 (class 2604 OID 17018)
-- Name: entrytypes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entrytypes ALTER COLUMN id SET DEFAULT nextval('public.entrytypes_id_seq'::regclass);


--
-- TOC entry 3928 (class 2604 OID 17019)
-- Name: fieldgroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldgroups ALTER COLUMN id SET DEFAULT nextval('public.fieldgroups_id_seq'::regclass);


--
-- TOC entry 3931 (class 2604 OID 17020)
-- Name: fieldlayoutfields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldlayoutfields ALTER COLUMN id SET DEFAULT nextval('public.fieldlayoutfields_id_seq'::regclass);


--
-- TOC entry 3934 (class 2604 OID 17021)
-- Name: fieldlayouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldlayouts ALTER COLUMN id SET DEFAULT nextval('public.fieldlayouts_id_seq'::regclass);


--
-- TOC entry 3936 (class 2604 OID 17022)
-- Name: fieldlayouttabs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldlayouttabs ALTER COLUMN id SET DEFAULT nextval('public.fieldlayouttabs_id_seq'::regclass);


--
-- TOC entry 3941 (class 2604 OID 17023)
-- Name: fields id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fields ALTER COLUMN id SET DEFAULT nextval('public.fields_id_seq'::regclass);


--
-- TOC entry 3943 (class 2604 OID 17024)
-- Name: globalsets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.globalsets ALTER COLUMN id SET DEFAULT nextval('public.globalsets_id_seq'::regclass);


--
-- TOC entry 3946 (class 2604 OID 17025)
-- Name: gqlschemas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gqlschemas ALTER COLUMN id SET DEFAULT nextval('public.gqlschemas_id_seq'::regclass);


--
-- TOC entry 3949 (class 2604 OID 17026)
-- Name: gqltokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gqltokens ALTER COLUMN id SET DEFAULT nextval('public.gqltokens_id_seq'::regclass);


--
-- TOC entry 3954 (class 2604 OID 17027)
-- Name: info id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info ALTER COLUMN id SET DEFAULT nextval('public.info_id_seq'::regclass);


--
-- TOC entry 3957 (class 2604 OID 17028)
-- Name: matrixblocktypes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixblocktypes ALTER COLUMN id SET DEFAULT nextval('public.matrixblocktypes_id_seq'::regclass);


--
-- TOC entry 3959 (class 2604 OID 17029)
-- Name: matrixcontent_factscontentblocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_factscontentblocks ALTER COLUMN id SET DEFAULT nextval('public.matrixcontent_factscontentblocks_id_seq'::regclass);


--
-- TOC entry 3961 (class 2604 OID 17030)
-- Name: matrixcontent_introcontentblocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_introcontentblocks ALTER COLUMN id SET DEFAULT nextval('public.matrixcontent_introcontentblocks_id_seq'::regclass);


--
-- TOC entry 3963 (class 2604 OID 17031)
-- Name: matrixcontent_poiastroobject id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_poiastroobject ALTER COLUMN id SET DEFAULT nextval('public.matrixcontent_poiastroobject_id_seq'::regclass);


--
-- TOC entry 3965 (class 2604 OID 17032)
-- Name: matrixcontent_tourpois id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_tourpois ALTER COLUMN id SET DEFAULT nextval('public.matrixcontent_tourpois_id_seq'::regclass);


--
-- TOC entry 3967 (class 2604 OID 17033)
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- TOC entry 3970 (class 2604 OID 17034)
-- Name: plugins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plugins ALTER COLUMN id SET DEFAULT nextval('public.plugins_id_seq'::regclass);


--
-- TOC entry 3977 (class 2604 OID 17035)
-- Name: queue id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.queue ALTER COLUMN id SET DEFAULT nextval('public.queue_id_seq'::regclass);


--
-- TOC entry 3979 (class 2604 OID 17036)
-- Name: relations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relations ALTER COLUMN id SET DEFAULT nextval('public.relations_id_seq'::regclass);


--
-- TOC entry 3980 (class 2604 OID 17037)
-- Name: revisions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revisions ALTER COLUMN id SET DEFAULT nextval('public.revisions_id_seq'::regclass);


--
-- TOC entry 3986 (class 2604 OID 17038)
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- TOC entry 3993 (class 2604 OID 17039)
-- Name: sections_sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections_sites ALTER COLUMN id SET DEFAULT nextval('public.sections_sites_id_seq'::regclass);


--
-- TOC entry 3996 (class 2604 OID 17040)
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- TOC entry 3998 (class 2604 OID 17041)
-- Name: shunnedmessages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shunnedmessages ALTER COLUMN id SET DEFAULT nextval('public.shunnedmessages_id_seq'::regclass);


--
-- TOC entry 4001 (class 2604 OID 17042)
-- Name: sitegroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sitegroups ALTER COLUMN id SET DEFAULT nextval('public.sitegroups_id_seq'::regclass);


--
-- TOC entry 4006 (class 2604 OID 17043)
-- Name: sites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sites ALTER COLUMN id SET DEFAULT nextval('public.sites_id_seq'::regclass);


--
-- TOC entry 4008 (class 2604 OID 17044)
-- Name: structureelements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structureelements ALTER COLUMN id SET DEFAULT nextval('public.structureelements_id_seq'::regclass);


--
-- TOC entry 4011 (class 2604 OID 17045)
-- Name: structures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures ALTER COLUMN id SET DEFAULT nextval('public.structures_id_seq'::regclass);


--
-- TOC entry 4013 (class 2604 OID 17046)
-- Name: systemmessages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.systemmessages ALTER COLUMN id SET DEFAULT nextval('public.systemmessages_id_seq'::regclass);


--
-- TOC entry 4016 (class 2604 OID 17047)
-- Name: taggroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggroups ALTER COLUMN id SET DEFAULT nextval('public.taggroups_id_seq'::regclass);


--
-- TOC entry 4018 (class 2604 OID 17048)
-- Name: templatecacheelements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templatecacheelements ALTER COLUMN id SET DEFAULT nextval('public.templatecacheelements_id_seq'::regclass);


--
-- TOC entry 4019 (class 2604 OID 17049)
-- Name: templatecachequeries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templatecachequeries ALTER COLUMN id SET DEFAULT nextval('public.templatecachequeries_id_seq'::regclass);


--
-- TOC entry 4020 (class 2604 OID 17050)
-- Name: templatecaches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templatecaches ALTER COLUMN id SET DEFAULT nextval('public.templatecaches_id_seq'::regclass);


--
-- TOC entry 4022 (class 2604 OID 17051)
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);


--
-- TOC entry 4024 (class 2604 OID 17052)
-- Name: usergroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usergroups ALTER COLUMN id SET DEFAULT nextval('public.usergroups_id_seq'::regclass);


--
-- TOC entry 4026 (class 2604 OID 17053)
-- Name: usergroups_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usergroups_users ALTER COLUMN id SET DEFAULT nextval('public.usergroups_users_id_seq'::regclass);


--
-- TOC entry 4028 (class 2604 OID 17054)
-- Name: userpermissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpermissions ALTER COLUMN id SET DEFAULT nextval('public.userpermissions_id_seq'::regclass);


--
-- TOC entry 4030 (class 2604 OID 17055)
-- Name: userpermissions_usergroups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpermissions_usergroups ALTER COLUMN id SET DEFAULT nextval('public.userpermissions_usergroups_id_seq'::regclass);


--
-- TOC entry 4032 (class 2604 OID 17056)
-- Name: userpermissions_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpermissions_users ALTER COLUMN id SET DEFAULT nextval('public.userpermissions_users_id_seq'::regclass);


--
-- TOC entry 4033 (class 2604 OID 17057)
-- Name: userpreferences userId; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpreferences ALTER COLUMN "userId" SET DEFAULT nextval('public."userpreferences_userId_seq"'::regclass);


--
-- TOC entry 4042 (class 2604 OID 17058)
-- Name: volumefolders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volumefolders ALTER COLUMN id SET DEFAULT nextval('public.volumefolders_id_seq'::regclass);


--
-- TOC entry 4047 (class 2604 OID 17059)
-- Name: volumes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volumes ALTER COLUMN id SET DEFAULT nextval('public.volumes_id_seq'::regclass);


--
-- TOC entry 4050 (class 2604 OID 17060)
-- Name: widgets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.widgets ALTER COLUMN id SET DEFAULT nextval('public.widgets_id_seq'::regclass);


--
-- TOC entry 4685 (class 0 OID 17993)
-- Dependencies: 323
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.announcements (id, "userId", "pluginId", heading, body, unread, "dateRead", "dateCreated") FROM stdin;
2	112	\N	Editor Slideouts	Double-click entries and other editable elements to try the new editor slideout interface.	t	\N	2021-08-30 21:28:59
4	112	\N	Streamlined Entry Publishing Flow	The entry publishing workflow is now [simpler and more intuitive](https://craftcms.com/knowledge-base/editing-entries).	t	\N	2021-08-30 21:28:59
1	1	\N	Editor Slideouts	Double-click entries and other editable elements to try the new editor slideout interface.	f	2021-09-14 22:46:35	2021-08-30 21:28:59
3	1	\N	Streamlined Entry Publishing Flow	The entry publishing workflow is now [simpler and more intuitive](https://craftcms.com/knowledge-base/editing-entries).	f	2021-09-14 22:46:35	2021-08-30 21:28:59
\.


--
-- TOC entry 4562 (class 0 OID 16444)
-- Dependencies: 200
-- Data for Name: assetindexdata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assetindexdata (id, "sessionId", "volumeId", uri, size, "timestamp", "recordId", "inProgress", completed, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4564 (class 0 OID 16456)
-- Dependencies: 202
-- Data for Name: assets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assets (id, "volumeId", "folderId", "uploaderId", filename, kind, width, height, size, "focalPoint", "deletedWithVolume", "keptFile", "dateModified", "dateCreated", "dateUpdated", uid) FROM stdin;
50	2	10	1	Fo4-pebbles-artwork.png	image	242	303	114191	\N	t	t	2021-06-21 23:03:21	2021-06-21 23:03:21	2021-06-21 23:03:21	846d0ab9-0217-4be7-ad5e-d36e74b28bb6
49	2	10	1	astrocat.jpeg	image	225	225	12597	\N	t	t	2021-06-21 23:02:56	2021-06-21 23:02:56	2021-06-21 23:02:56	7fa2a67f-e7cf-486d-b786-a0c8c4aceeac
290	5	16	1	astrocat_2021-09-08-175844_pzpk.jpeg	image	225	225	12590	\N	f	f	2021-09-08 17:58:44	2021-09-08 17:58:44	2021-09-08 17:58:44	c20f0158-0fa2-49cd-a620-328daf929e3c
116	1	1	1	galaxy-icon_2021-08-06-221957_rygb.png	image	20	20	851	\N	f	f	2021-08-06 22:19:57	2021-08-06 22:19:57	2021-08-06 22:19:57	2cccacb4-1a54-4e37-a56f-d358a5d30eb8
197	1	1	1	landmark-icon_2021-08-17-203711_mqou.png	image	14	20	476	\N	f	f	2021-08-17 20:37:11	2021-08-17 20:37:11	2021-08-17 20:37:11	f02cf625-3e91-4835-ba3e-afb0c201e615
118	1	1	1	nebula-icon_2021-08-06-221958_rmuk.png	image	20	20	825	\N	f	f	2021-08-06 22:19:58	2021-08-06 22:19:58	2021-08-06 22:19:58	d0dd57f1-1afa-46c3-b169-c9f8e4980ac2
119	1	1	1	star-icon_2021-08-06-221958_gggl.png	image	20	20	569	\N	f	f	2021-08-06 22:19:58	2021-08-06 22:19:58	2021-08-06 22:19:58	de115baa-38ee-4400-95fa-c4dbbaad3760
120	1	1	1	transient-icon_2021-08-06-221958_jjls.png	image	20	20	880	\N	f	f	2021-08-06 22:19:58	2021-08-06 22:19:58	2021-08-06 22:19:58	89d7660c-e32a-42ec-837c-eb480c78f11f
117	1	1	1	landmark-icon.png	image	14	20	609	\N	f	f	2021-08-17 20:37:14	2021-08-06 22:19:58	2021-08-17 20:37:14	36b93b78-264b-49ca-a91a-2cf15e480b84
199	1	1	1	astrocat.jpeg	image	225	225	12590	\N	f	f	2021-08-17 20:41:22	2021-08-17 20:41:22	2021-08-17 20:41:22	72de808b-53a0-4cc1-a733-740f3657106b
187	1	1	1	star-icon_2021-08-17-203539_jurm.png	image	20	20	569	\N	f	f	2021-08-17 20:35:39	2021-08-17 20:35:39	2021-08-17 20:35:39	3cad8932-462e-4a02-85bc-30ae69196874
217	1	1	1	galaxy-icon.png	image	20	20	851	\N	f	f	2021-09-23 16:56:52	2021-08-20 22:01:07	2021-09-23 16:56:52	582a1c8a-078a-47e7-bab9-e8c331545944
189	1	1	1	galaxy-icon_2021-08-17-203557_bwkx.png	image	20	20	851	\N	f	f	2021-08-17 20:35:57	2021-08-17 20:35:57	2021-08-17 20:35:57	5904e480-87cc-4d3d-b124-d2a0f625880d
320	1	1	1	fun-goal-icon_2021-09-14-223121_rjpb.png	image	20	20	908	\N	f	f	2021-09-14 22:31:22	2021-09-14 22:31:22	2021-09-14 22:31:22	aede4adb-6a8c-4937-a132-677339ce0326
191	1	1	1	nebula-icon_2021-08-17-203613_drvc.png	image	20	20	825	\N	f	f	2021-08-17 20:36:13	2021-08-17 20:36:13	2021-08-17 20:36:13	0fb0ae9e-164e-4aef-a41a-d47276956726
193	1	1	1	transient-icon_2021-08-17-203634_fvww.png	image	20	20	880	\N	f	f	2021-08-17 20:36:34	2021-08-17 20:36:34	2021-08-17 20:36:34	aa2afefc-7646-4629-adc0-5b8cb9414ccc
195	1	1	1	fun-goal-icon_2021-08-17-203657_tbxa.png	image	20	20	908	\N	f	f	2021-08-17 20:36:57	2021-08-17 20:36:57	2021-08-17 20:36:57	6ebf9737-a7b7-4fb5-8f0f-cc81f4c55905
17	1	1	1	star-icon.png	image	20	20	718	\N	f	f	2021-08-17 20:35:42	2021-06-15 17:23:21	2021-08-17 20:35:42	d9d76686-3292-4637-b895-e70a88bab817
19	1	1	1	galaxy-icon.png	image	20	20	851	\N	f	f	2021-08-17 20:36:00	2021-06-15 17:23:44	2021-08-17 20:36:00	dc912f77-93aa-4bf6-82f5-0aecfd6f9095
22	1	1	1	nebula-icon.png	image	20	20	825	\N	f	f	2021-08-17 20:36:16	2021-06-15 17:34:13	2021-08-17 20:36:16	b64d6a65-8460-4a6b-9616-bdfa3bbee092
26	1	1	1	transient-icon.png	image	20	20	880	\N	f	f	2021-08-17 20:36:37	2021-06-15 17:51:02	2021-08-17 20:36:37	005a3f48-daf7-4a7a-ba8d-fc3e8648c725
115	1	1	1	fun-goal-icon.png	image	20	20	908	\N	f	f	2021-08-17 20:37:00	2021-08-06 22:19:57	2021-08-17 20:37:00	955bc33a-263b-4117-9a9d-cd1a02581a8c
280	3	11	1	astrocat_2021-09-08-175728_uomq.jpeg	image	225	225	12590	\N	f	f	2021-09-08 17:57:28	2021-09-08 17:57:28	2021-09-08 17:57:28	084f0c2e-e6c6-4b32-b34d-7e902ffa0a80
204	3	11	1	Screen-Shot-2021-08-20-at-2.02.37-PM.png	image	435	810	79484	\N	f	f	2021-08-20 21:54:23	2021-08-20 21:54:23	2021-08-20 21:54:23	175bb0cf-6e7b-4dac-9de7-a4115a1d18af
321	1	1	1	galaxy-icon_2021-09-14-223128_bgdu.png	image	20	20	851	\N	f	f	2021-09-14 22:31:28	2021-09-14 22:31:28	2021-09-14 22:31:28	02afc330-4e16-4e66-b568-6185528457b9
350	1	1	1	landmark-icon_2021-09-23-165755_airh.png	image	14	20	476	\N	f	f	2021-09-23 16:57:55	2021-09-23 16:57:55	2021-09-23 16:57:55	79eb314c-a2a4-4ef1-a076-16076919e3f5
322	1	1	1	landmark-icon_2021-09-14-223134_luqk.png	image	14	20	476	\N	f	f	2021-09-14 22:31:34	2021-09-14 22:31:34	2021-09-14 22:31:34	93d7f460-3f15-4da1-b3e7-23ef6cd0bcc3
344	1	1	1	nebula-icon_2021-09-23-165707_ykzv.png	image	20	20	825	\N	f	f	2021-09-23 16:57:07	2021-09-23 16:57:07	2021-09-23 16:57:07	bdf3539b-59c9-4f85-b389-7a1f5ed59112
323	1	1	1	nebula-icon_2021-09-14-223140_whay.png	image	20	20	825	\N	f	f	2021-09-14 22:31:40	2021-09-14 22:31:40	2021-09-14 22:31:40	b6b8930d-2eb8-42a4-a62b-929cbe19c7a9
219	1	1	1	star-icon.png	image	20	20	718	\N	f	f	2021-09-23 16:56:31	2021-08-20 22:01:07	2021-09-23 16:56:31	4b87aff9-a382-40a8-8d38-9dc0e1fae1c8
324	1	1	1	star-icon_2021-09-14-223147_umzx.png	image	20	20	569	\N	f	f	2021-09-14 22:31:47	2021-09-14 22:31:47	2021-09-14 22:31:47	fbf9a514-1405-4fc0-81c3-d95fcde09d59
347	1	1	1	transient-icon_2021-09-23-165723_wocf.png	image	20	20	880	\N	f	f	2021-09-23 16:57:23	2021-09-23 16:57:23	2021-09-23 16:57:23	f7c0edbb-1128-4007-9799-6d47bd3dcfd1
325	1	1	1	transient-icon_2021-09-14-223152_fiwl.png	image	20	20	880	\N	f	f	2021-09-14 22:31:52	2021-09-14 22:31:52	2021-09-14 22:31:52	611f9765-98a5-4527-b351-916a083a36b3
214	1	1	1	nebula-icon.png	image	20	20	825	\N	f	f	2021-09-23 16:57:09	2021-08-20 22:01:06	2021-09-23 16:57:09	7261d7cf-348d-451e-be0c-96072de41197
338	1	1	1	star-icon_2021-09-23-165629_vtwn.png	image	20	20	569	\N	f	f	2021-09-23 16:56:29	2021-09-23 16:56:29	2021-09-23 16:56:29	fb1c602d-6b4a-42cc-b09b-b90974c19012
341	1	1	1	galaxy-icon_2021-09-23-165649_esmt.png	image	20	20	851	\N	f	f	2021-09-23 16:56:49	2021-09-23 16:56:49	2021-09-23 16:56:49	9585b2a6-e3bf-47fa-9c5c-59246f160664
218	1	1	1	transient-icon.png	image	20	20	880	\N	f	f	2021-09-23 16:57:25	2021-08-20 22:01:07	2021-09-23 16:57:25	969e836a-7908-4280-b54e-b7b6ee517b40
216	1	1	1	landmark-icon.png	image	14	20	609	\N	f	f	2021-09-23 16:57:57	2021-08-20 22:01:06	2021-09-23 16:57:57	7c0291dd-3a66-43f5-8c7f-0621e8d7c07c
353	1	1	1	star-icon_2021-09-28-234000_gtpe.png	image	20	20	644	\N	f	f	2021-09-28 23:40:02	2021-09-28 23:40:02	2021-09-28 23:40:02	013296d8-0224-4ddd-92f1-03e23661b93f
239	5	16	1	astrocat.jpeg	image	225	225	12594	\N	f	f	2021-09-08 17:58:46	2021-08-30 21:32:28	2021-09-08 17:58:46	d899778f-4458-4544-af4f-c34e13cdb889
137	3	11	1	test.png	image	242	303	110610	\N	f	f	2021-08-06 22:54:52	2021-08-06 22:54:52	2021-08-06 22:54:52	02cf2b80-660b-4ac8-8934-8df6e26540d2
167	3	11	1	Fo4-pebbles-artwork.png	image	242	303	110610	\N	f	f	2021-08-17 20:25:07	2021-08-17 20:25:07	2021-08-17 20:25:07	1d73ff2f-355b-4ec6-9e2d-aeaedfad88f6
228	3	11	1	astrocat.jpeg	image	225	225	12594	\N	f	f	2021-09-08 17:57:30	2021-08-30 21:31:25	2021-09-08 17:57:30	0b8f4ee1-6273-47d1-96aa-9c2e421685b2
215	1	1	1	fun-goal-icon.png	image	20	20	908	\N	f	f	2021-09-14 22:31:24	2021-08-20 22:01:06	2021-09-14 22:31:24	a41f6958-5193-48c2-9afb-39acae4f800f
356	1	1	1	galaxy-icon_2021-09-28-234211_yspn.png	image	20	20	717	\N	f	f	2021-09-28 23:42:13	2021-09-28 23:42:13	2021-09-28 23:42:13	ef405315-ed43-4539-a1c4-2f49689f58b4
359	1	1	1	nebula-icon_2021-09-28-234534_tnca.png	image	20	20	626	\N	f	f	2021-09-28 23:45:35	2021-09-28 23:45:36	2021-09-28 23:45:36	44ee3b3e-593a-4180-ad0e-3556b03da40a
362	1	1	1	transient-icon_2021-09-28-234840_bxwy.png	image	20	20	655	\N	f	f	2021-09-28 23:48:42	2021-09-28 23:48:42	2021-09-28 23:48:42	998e15c7-2855-4f4a-b43d-95d70375d13e
365	1	1	1	landmark-icon_2021-09-28-235159_siwt.png	image	14	20	528	\N	f	f	2021-09-28 23:52:00	2021-09-28 23:52:01	2021-09-28 23:52:01	ce8bf0be-08e0-4f17-8d13-d9eb2ce749ee
380	3	11	1	ourneighborhood.jpg	image	3840	1200	710314	\N	\N	\N	2021-10-08 00:35:09	2021-10-08 00:35:10	2021-10-08 00:35:10	54367eca-7328-447c-8369-edb5da4886c0
370	1	1	1	star-icon.png	image	20	20	637	\N	\N	\N	2021-10-08 22:40:08	2021-09-29 19:39:50	2021-10-08 22:40:08	bbc691f3-79cf-4e28-a297-4d38b03c6ad6
382	1	1	1	star-icon_2021-10-08-224004_gyby.png	image	20	20	644	\N	f	f	2021-10-08 22:40:04	2021-10-08 22:40:04	2021-10-08 22:40:04	baabecc7-bc58-4bb0-a2db-6a0116e87488
373	1	1	1	galaxy-icon.png	image	20	20	717	\N	\N	\N	2021-10-08 22:40:42	2021-09-29 19:40:14	2021-10-08 22:40:42	92989ec3-ac21-48bf-b199-c10714cb6540
384	1	1	1	galaxy-icon_2021-10-08-224037_ojuo.png	image	20	20	717	\N	f	f	2021-10-08 22:40:37	2021-10-08 22:40:38	2021-10-08 22:40:38	1c1d4e16-0494-4196-8861-502a072cd036
369	1	1	1	nebula-icon.png	image	20	20	626	\N	\N	\N	2021-10-08 22:42:31	2021-09-29 19:39:41	2021-10-08 22:42:31	ccc60c05-90e4-464c-bee9-ce491688b56a
387	1	1	1	nebula-icon_2021-10-08-224227_zkks.png	image	20	20	626	\N	f	f	2021-10-08 22:42:27	2021-10-08 22:42:27	2021-10-08 22:42:27	fb1729a8-04dd-4fb8-9145-04db4cdf11b5
372	1	1	1	transient-icon.png	image	20	20	655	\N	\N	\N	2021-10-08 22:42:50	2021-09-29 19:40:06	2021-10-08 22:42:50	1c80444f-bf27-4417-9a89-cc29c35a9b9c
390	1	1	1	transient-icon_2021-10-08-224247_ykoz.png	image	20	20	655	\N	f	f	2021-10-08 22:42:47	2021-10-08 22:42:48	2021-10-08 22:42:48	9d700d71-fcf0-40eb-ac0a-af8cab42f1ca
371	1	1	1	landmark-icon.png	image	14	20	528	\N	\N	\N	2021-10-08 22:43:12	2021-09-29 19:39:58	2021-10-08 22:43:12	5ce7ee6d-33c4-4860-bca3-6b4ec45d38b7
393	1	1	1	landmark-icon_2021-10-08-224309_lytq.png	image	14	20	528	\N	f	f	2021-10-08 22:43:09	2021-10-08 22:43:09	2021-10-08 22:43:09	a5db2139-a48b-4076-a1ac-e7ff6419f4cd
368	1	1	1	fun-goal-icon.png	image	20	20	804	\N	f	f	2021-09-29 19:39:32	2021-09-29 19:39:32	2021-09-29 19:39:32	828e5789-ee18-44ba-85b6-216a4e62a719
376	1	1	1	star-icon_2021-10-01-203317_odxg.png	image	20	20	644	\N	f	f	2021-10-01 20:33:18	2021-10-01 20:33:18	2021-10-01 20:33:18	d44d39a0-b239-4621-9f68-60eece6b23a7
398	3	11	1	Screen-Shot-2021-10-07-at-10.57.36-AM.png	image	2894	1144	1782139	\N	\N	\N	2021-10-08 23:03:47	2021-10-08 23:03:47	2021-10-08 23:03:47	1b88d6b2-9f90-41b9-8906-9b3cdfa8bcb9
399	5	16	1	Screen-Shot-2021-10-07-at-9.53.18-AM.png	image	2552	880	209757	\N	\N	\N	2021-10-08 23:04:46	2021-10-08 23:04:46	2021-10-08 23:04:46	3c759354-e6c2-49ae-bba9-5ad4f66e9bba
424	3	11	1	Screen-Shot-2021-10-07-at-10.58.24-AM.png	image	2894	1144	255471	\N	\N	\N	2021-10-08 23:07:59	2021-10-08 23:07:59	2021-10-08 23:07:59	0efddfc7-6455-4e6d-bdd4-d9d7162426b4
443	3	11	1	cutout.png	image	1280	960	46648	\N	f	f	2021-10-22 22:20:37	2021-10-22 22:20:37	2021-10-22 22:20:37	d3eb2bad-b31b-4a78-b247-871bc60449f1
444	3	11	1	sasquatch.png	image	170	230	39050	\N	f	f	2021-10-25 21:50:51	2021-10-25 21:50:51	2021-10-25 21:50:51	4cd8f973-66f9-4a78-adaa-2354a76b9ae5
445	3	11	1	eric-rosas.png	image	170	230	39050	\N	\N	\N	2021-10-26 17:15:00	2021-10-26 17:15:00	2021-10-26 17:15:00	05b63dc2-5423-4395-adf9-ff824d80b20c
\.


--
-- TOC entry 4565 (class 0 OID 16462)
-- Dependencies: 203
-- Data for Name: assettransformindex; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assettransformindex (id, "assetId", filename, format, location, "volumeId", "fileExists", "inProgress", error, "dateIndexed", "dateCreated", "dateUpdated", uid) FROM stdin;
120	398	Screen-Shot-2021-10-07-at-10.57.36-AM.png	\N	_700x700_fit_center-center_none	3	t	f	f	2021-10-08 23:09:03	2021-10-08 23:09:03	2021-10-08 23:09:03	d5f68c1e-2cbf-4d11-a2be-d890408cba3c
121	399	Screen-Shot-2021-10-07-at-9.53.18-AM.png	\N	_1200x1200_fit_center-center_none	5	t	f	f	2021-10-08 23:09:18	2021-10-08 23:09:18	2021-10-08 23:09:18	cfc80761-7f1f-4906-b2fe-fcbd5ba4703f
112	380	ourneighborhood.jpg	\N	_2100x2100_fit_center-center_none	3	t	f	f	2021-10-08 23:08:58	2021-10-08 23:08:58	2021-10-08 23:08:59	97ab19a2-1946-476d-b4e9-627907ff8993
122	399	Screen-Shot-2021-10-07-at-9.53.18-AM.png	\N	_800x800_fit_center-center_none	5	t	f	f	2021-10-08 23:09:18	2021-10-08 23:09:18	2021-10-08 23:09:19	304dc900-d6bd-48e2-a88a-dd1ce53fb883
113	380	ourneighborhood.jpg	\N	_1400x1400_fit_center-center_none	3	t	f	f	2021-10-08 23:08:59	2021-10-08 23:08:59	2021-10-08 23:08:59	dfa6c95f-5faa-42d4-8058-dc89e45bb52f
123	399	Screen-Shot-2021-10-07-at-9.53.18-AM.png	\N	_400x400_fit_center-center_none	5	t	f	f	2021-10-08 23:09:19	2021-10-08 23:09:19	2021-10-08 23:09:19	f55ea6ca-267a-479d-a771-e7fc98949f7c
114	380	ourneighborhood.jpg	\N	_700x700_fit_center-center_none	3	t	f	f	2021-10-08 23:08:59	2021-10-08 23:08:59	2021-10-08 23:08:59	f8fb78b8-773e-4a22-a502-b14bcc7684ad
115	424	Screen-Shot-2021-10-07-at-10.58.24-AM.png	\N	_2100x2100_fit_center-center_none	3	t	f	f	2021-10-08 23:08:59	2021-10-08 23:08:59	2021-10-08 23:09:01	89bfca48-152c-49a4-bb62-9da206f4c7aa
116	424	Screen-Shot-2021-10-07-at-10.58.24-AM.png	\N	_1400x1400_fit_center-center_none	3	t	f	f	2021-10-08 23:09:01	2021-10-08 23:09:01	2021-10-08 23:09:01	34ef10d3-72b4-47ab-b265-202f20783832
117	424	Screen-Shot-2021-10-07-at-10.58.24-AM.png	\N	_700x700_fit_center-center_none	3	t	f	f	2021-10-08 23:09:01	2021-10-08 23:09:01	2021-10-08 23:09:02	0f443100-cc3a-43b7-991a-646e7fb063db
118	398	Screen-Shot-2021-10-07-at-10.57.36-AM.png	\N	_2100x2100_fit_center-center_none	3	t	f	f	2021-10-08 23:09:02	2021-10-08 23:09:02	2021-10-08 23:09:03	cd408391-7e4e-41aa-8c8e-374e5f29db54
119	398	Screen-Shot-2021-10-07-at-10.57.36-AM.png	\N	_1400x1400_fit_center-center_none	3	t	f	f	2021-10-08 23:09:03	2021-10-08 23:09:03	2021-10-08 23:09:03	124d063c-41f6-42cc-8232-06411668e77b
\.


--
-- TOC entry 4567 (class 0 OID 16474)
-- Dependencies: 205
-- Data for Name: assettransforms; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.assettransforms (id, name, handle, mode, "position", width, height, format, quality, interlace, "dimensionChangeTime", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4569 (class 0 OID 16489)
-- Dependencies: 207
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, "groupId", "parentId", "deletedWithGroup", "dateCreated", "dateUpdated", uid) FROM stdin;
2	1	\N	t	2021-05-19 21:19:04	2021-05-19 21:19:04	6b2b8394-06da-4609-b749-9670c7b9b4af
177	2	\N	\N	2021-08-17 20:28:22	2021-08-17 20:28:22	1cd7fbec-fc42-4c5f-96ea-b7e3f9dd064c
178	3	\N	\N	2021-08-17 20:28:31	2021-08-17 20:28:31	44362081-3354-4edc-8de6-4947e98ad359
205	3	\N	\N	2021-08-20 21:55:12	2021-08-20 21:55:12	ebdaa8a8-6507-4810-a91a-fb64b99e9d1c
206	3	\N	\N	2021-08-20 21:55:30	2021-08-20 21:55:30	366e8e18-1f96-46a7-986f-580670e5ec4e
207	3	\N	\N	2021-08-20 21:55:41	2021-08-20 21:55:41	77ac8552-0718-47a3-abea-879bfb0d9ec1
208	3	\N	\N	2021-08-20 21:55:51	2021-08-20 21:55:51	513d87f9-c12b-4f6b-bf8e-f29afdf999f3
229	2	\N	\N	2021-08-30 21:31:28	2021-08-30 21:31:28	152845e2-a206-43d2-ad89-8d75ecc0759e
\.


--
-- TOC entry 4570 (class 0 OID 16493)
-- Dependencies: 208
-- Data for Name: categorygroups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categorygroups (id, "structureId", "fieldLayoutId", name, handle, "dateCreated", "dateUpdated", "dateDeleted", uid, "defaultPlacement") FROM stdin;
1	1	1	HiPS Catalogs	hipsCatalogs	2021-05-19 21:15:41	2021-05-19 21:15:41	2021-08-12 21:49:08	43c5d827-8706-4863-a676-17bf911ce931	end
2	10	20	Tour Variety	tourVariety	2021-08-12 21:49:09	2021-08-12 21:49:09	\N	aa3e2ce5-e67a-4378-8a44-c660690cbcc3	end
3	11	21	Tour Theme	tourTheme	2021-08-12 21:49:09	2021-08-12 21:49:09	\N	40780a9f-1ee7-4c59-aaaf-159094330220	end
\.


--
-- TOC entry 4572 (class 0 OID 16503)
-- Dependencies: 210
-- Data for Name: categorygroups_sites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categorygroups_sites (id, "groupId", "siteId", "hasUrls", "uriFormat", template, "dateCreated", "dateUpdated", uid) FROM stdin;
1	1	1	t	hips-catalogs/{slug}	\N	2021-05-19 21:15:41	2021-05-19 21:15:41	9a5f9770-6957-4b0b-9e4d-426f1f28357a
2	1	2	t	hips-catalogs/{slug}	\N	2021-06-15 15:02:03	2021-06-15 15:02:03	7cf2868c-d139-4d8f-909f-4706a1d67992
3	2	1	t	tour-variety/{slug}	\N	2021-08-12 21:49:09	2021-08-12 21:49:09	e3cb336f-c77e-4b0e-abbd-7163711a949d
4	2	2	t	tour-variety/{slug}	\N	2021-08-12 21:49:09	2021-08-12 21:49:09	7fdaf5a1-29a9-474a-bafb-1a011347d2d7
5	3	1	t	tour-theme/{slug}	\N	2021-08-12 21:49:09	2021-08-12 21:49:09	77159be5-22b4-4af3-a010-b25ece13c275
6	3	2	t	tour-theme/{slug}	\N	2021-08-12 21:49:09	2021-08-12 21:49:09	d02303d5-3fe3-4155-bf1d-9a2917d476e8
\.


--
-- TOC entry 4574 (class 0 OID 16513)
-- Dependencies: 212
-- Data for Name: changedattributes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.changedattributes ("elementId", "siteId", attribute, "dateUpdated", propagated, "userId") FROM stdin;
67	2	uri	2021-06-22 21:50:23	t	1
67	1	uri	2021-06-22 21:50:23	f	1
67	1	title	2021-07-19 22:32:37	f	1
112	1	admin	2021-07-26 16:44:54	f	1
112	1	password	2021-07-26 16:51:47	f	\N
112	1	verificationCode	2021-07-26 16:51:47	f	\N
112	1	verificationCodeIssuedDate	2021-07-26 16:51:47	f	\N
112	1	lastPasswordChangeDate	2021-07-26 16:51:47	f	\N
138	1	slug	2021-08-06 23:03:19	f	1
138	1	uri	2021-08-06 23:03:19	f	1
8	1	slug	2021-08-20 22:02:00	f	1
8	1	uri	2021-08-20 22:02:00	f	1
8	1	title	2021-08-20 22:02:00	f	1
14	1	slug	2021-08-20 22:02:33	f	1
14	1	uri	2021-08-20 22:02:33	f	1
14	1	title	2021-08-20 22:02:33	f	1
23	1	slug	2021-08-20 22:03:07	f	1
23	1	uri	2021-08-20 22:03:07	f	1
23	1	title	2021-08-20 22:03:07	f	1
27	1	slug	2021-08-20 22:03:29	f	1
27	1	uri	2021-08-20 22:03:29	f	1
27	1	title	2021-08-20 22:03:29	f	1
31	1	slug	2021-08-20 22:04:11	f	1
31	1	uri	2021-08-20 22:04:11	f	1
31	1	title	2021-08-20 22:04:11	f	1
35	1	slug	2021-08-20 22:04:39	f	1
35	1	uri	2021-08-20 22:04:39	f	1
35	1	title	2021-08-20 22:04:39	f	1
227	2	slug	2021-08-30 21:31:07	t	1
227	2	uri	2021-08-30 21:31:07	t	1
227	2	title	2021-08-30 21:31:07	t	1
227	1	slug	2021-08-30 21:31:07	f	1
227	1	uri	2021-08-30 21:31:07	f	1
227	1	title	2021-08-30 21:31:07	f	1
95	2	title	2021-09-08 17:50:58	t	1
95	1	title	2021-09-08 17:50:58	f	1
279	2	slug	2021-09-08 17:55:42	t	1
279	2	uri	2021-09-08 17:55:42	t	1
279	2	title	2021-09-08 17:55:42	t	1
279	1	slug	2021-09-08 17:55:43	f	1
279	1	uri	2021-09-08 17:55:43	f	1
279	1	title	2021-09-08 17:55:43	f	1
298	2	slug	2021-09-08 18:25:35	t	1
298	2	uri	2021-09-08 18:25:35	t	1
298	2	title	2021-09-08 18:25:35	t	1
298	1	slug	2021-09-08 18:25:35	f	1
298	1	uri	2021-09-08 18:25:35	f	1
298	1	title	2021-09-08 18:25:35	f	1
374	2	slug	2021-10-01 20:05:48	t	1
374	2	uri	2021-10-01 20:05:48	t	1
374	2	title	2021-10-01 20:05:48	t	1
374	1	slug	2021-10-01 20:05:48	f	1
374	1	uri	2021-10-01 20:05:48	f	1
374	1	title	2021-10-01 20:05:48	f	1
\.


--
-- TOC entry 4575 (class 0 OID 16516)
-- Dependencies: 213
-- Data for Name: changedfields; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.changedfields ("elementId", "siteId", "fieldId", "dateUpdated", propagated, "userId") FROM stdin;
279	1	55	2021-09-08 17:55:52	f	1
67	2	19	2021-06-22 21:50:23	t	1
67	2	20	2021-06-22 21:50:23	t	1
67	2	33	2021-06-22 21:50:23	t	1
67	2	34	2021-06-22 21:50:23	t	1
67	2	17	2021-06-22 21:50:23	t	1
67	2	32	2021-06-22 21:50:23	t	1
67	2	31	2021-06-22 21:50:23	t	1
67	2	35	2021-06-22 21:50:23	t	1
279	1	22	2021-09-08 17:57:37	f	1
67	1	19	2021-06-22 21:50:23	f	1
67	1	20	2021-06-22 21:50:23	f	1
238	2	49	2021-08-30 21:32:11	f	1
298	1	33	2021-09-08 18:25:53	f	1
298	1	34	2021-09-08 18:25:53	f	1
65	2	26	2021-06-22 21:50:23	t	1
65	2	27	2021-06-22 21:50:23	t	1
65	2	28	2021-06-22 21:50:23	t	1
65	1	26	2021-06-22 21:50:23	f	1
65	1	27	2021-06-22 21:50:23	f	1
65	1	28	2021-06-22 21:50:23	f	1
8	2	6	2021-06-22 21:50:23	t	1
242	2	49	2021-08-30 21:32:33	f	1
8	2	8	2021-06-22 21:50:23	t	1
8	2	7	2021-06-22 21:50:23	t	1
8	1	6	2021-06-22 21:50:23	f	1
279	1	17	2021-09-08 17:57:52	f	1
8	1	7	2021-06-22 21:50:23	f	1
14	2	6	2021-06-22 21:50:23	t	1
279	1	31	2021-09-08 17:58:11	f	1
14	2	7	2021-06-22 21:50:23	t	1
14	1	6	2021-06-22 21:50:24	f	1
288	2	49	2021-09-08 17:58:17	f	1
14	1	7	2021-06-22 21:50:24	f	1
23	2	6	2021-06-22 21:50:24	t	1
23	2	7	2021-06-22 21:50:24	t	1
23	1	6	2021-06-22 21:50:24	f	1
23	1	7	2021-06-22 21:50:24	f	1
27	2	6	2021-06-22 21:50:24	t	1
45	2	11	2021-09-14 22:43:07	t	1
27	2	7	2021-06-22 21:50:24	t	1
27	1	6	2021-06-22 21:50:24	f	1
92	2	52	2021-08-17 20:41:24	t	1
67	2	30	2021-09-08 17:54:31	f	1
27	1	7	2021-06-22 21:50:24	f	1
31	2	6	2021-06-22 21:50:24	t	1
92	1	52	2021-08-17 20:41:25	f	1
31	2	7	2021-06-22 21:50:24	t	1
31	1	6	2021-06-22 21:50:24	f	1
92	1	26	2021-08-17 20:41:25	f	1
92	2	27	2021-08-20 21:56:12	t	1
31	1	7	2021-06-22 21:50:24	f	1
67	1	33	2021-06-22 21:51:08	f	1
67	1	34	2021-06-22 21:51:08	f	1
67	1	17	2021-06-22 21:51:08	f	1
67	1	32	2021-06-22 21:51:45	f	1
67	1	31	2021-06-22 21:51:45	f	1
92	2	28	2021-08-20 21:56:12	t	1
92	1	27	2021-08-20 21:56:12	f	1
92	1	28	2021-08-20 21:56:12	f	1
35	2	6	2021-06-22 21:50:24	t	1
35	2	7	2021-06-22 21:50:24	t	1
35	1	6	2021-06-22 21:50:24	f	1
45	1	11	2021-09-14 22:43:07	f	1
35	1	7	2021-06-22 21:50:24	f	1
41	2	6	2021-06-22 21:50:24	t	1
41	2	1	2021-06-22 21:50:24	t	1
41	2	8	2021-06-22 21:50:24	t	1
41	2	7	2021-06-22 21:50:24	t	1
41	1	6	2021-06-22 21:50:24	f	1
41	1	1	2021-06-22 21:50:24	f	1
41	1	8	2021-06-22 21:50:24	f	1
41	1	7	2021-06-22 21:50:24	f	1
8	2	1	2021-08-20 22:02:00	t	1
8	1	1	2021-08-20 22:02:00	f	1
8	1	8	2021-08-20 22:02:00	f	1
92	2	40	2021-07-16 18:45:50	t	1
92	1	40	2021-07-16 18:45:50	f	1
374	1	1	2021-10-01 20:06:06	f	1
374	2	1	2021-10-01 20:06:06	t	1
374	2	8	2021-10-01 20:06:06	t	1
65	2	25	2021-07-23 22:54:00	t	1
65	2	12	2021-07-23 22:54:00	t	1
65	2	39	2021-07-23 22:54:00	t	1
65	1	25	2021-07-23 22:54:01	f	1
65	1	12	2021-07-23 22:54:01	f	1
65	1	39	2021-07-23 22:54:01	f	1
67	1	30	2021-09-08 17:54:31	f	1
227	2	55	2021-09-08 17:54:51	f	1
23	2	8	2021-10-08 22:40:48	f	1
23	1	8	2021-10-08 22:40:48	f	1
45	2	13	2021-09-16 20:37:20	t	1
45	1	13	2021-09-16 20:37:20	f	1
227	2	30	2021-09-08 17:55:09	f	1
279	1	30	2021-09-08 17:55:47	f	1
27	2	1	2021-10-08 22:42:36	t	1
27	1	1	2021-10-08 22:42:36	f	1
27	2	8	2021-10-08 22:42:36	f	1
27	1	8	2021-10-08 22:42:36	f	1
31	2	1	2021-10-08 22:42:54	t	1
31	2	8	2021-10-08 22:42:54	f	1
227	1	20	2021-08-30 21:31:33	f	1
31	1	8	2021-10-08 22:42:54	f	1
31	1	1	2021-10-08 22:42:54	f	1
35	2	8	2021-10-08 22:43:16	f	1
35	1	8	2021-10-08 22:43:16	f	1
138	2	53	2021-08-06 22:56:20	t	1
138	1	53	2021-08-06 22:56:21	f	1
35	2	1	2021-10-08 22:43:16	t	1
35	1	1	2021-10-08 22:43:16	f	1
14	2	8	2021-10-08 22:43:20	f	1
14	1	8	2021-10-08 22:43:20	f	1
291	2	56	2021-10-08 23:05:41	f	1
67	2	21	2021-10-08 23:06:42	f	1
67	1	21	2021-10-08 23:06:42	f	1
67	1	35	2021-10-08 23:06:42	f	1
67	2	22	2021-10-08 23:06:42	f	1
67	1	22	2021-10-08 23:06:42	f	1
98	2	50	2021-10-08 23:07:33	t	1
98	1	50	2021-10-08 23:07:33	f	1
95	1	21	2021-10-08 23:07:33	f	1
95	1	35	2021-10-08 23:07:33	f	1
95	1	22	2021-10-08 23:07:33	f	1
95	1	30	2021-08-17 20:28:35	f	1
95	1	55	2021-08-17 20:28:35	f	1
227	2	21	2021-10-08 23:08:16	f	1
227	1	21	2021-10-08 23:08:16	f	1
227	2	22	2021-10-08 23:08:16	f	1
227	1	22	2021-10-08 23:08:16	f	1
298	2	21	2021-10-08 23:08:48	f	1
298	1	21	2021-10-08 23:08:48	f	1
298	2	22	2021-10-08 23:08:48	f	1
298	1	22	2021-10-08 23:08:48	f	1
308	2	40	2021-10-22 19:54:03	t	1
293	2	49	2021-09-08 17:58:56	f	1
279	1	35	2021-09-08 17:58:56	f	1
227	1	35	2021-08-30 21:32:33	f	1
279	1	20	2021-09-08 17:57:16	f	1
279	2	30	2021-09-08 17:58:58	t	1
279	2	55	2021-09-08 17:58:58	t	1
279	2	19	2021-09-08 17:58:58	t	1
279	2	20	2021-09-08 17:58:58	t	1
279	2	21	2021-09-08 17:58:58	t	1
227	2	19	2021-08-30 21:32:35	t	1
227	2	20	2021-08-30 21:32:35	t	1
227	2	33	2021-08-30 21:32:35	t	1
227	2	34	2021-08-30 21:32:35	t	1
227	2	17	2021-08-30 21:32:35	t	1
227	2	32	2021-08-30 21:32:35	t	1
227	2	31	2021-08-30 21:32:35	t	1
227	2	35	2021-08-30 21:32:35	t	1
279	2	22	2021-09-08 17:58:58	t	1
279	2	33	2021-09-08 17:58:58	t	1
279	2	34	2021-09-08 17:58:58	t	1
279	2	17	2021-09-08 17:58:58	t	1
279	2	32	2021-09-08 17:58:58	t	1
279	2	31	2021-09-08 17:58:58	t	1
279	2	35	2021-09-08 17:58:58	t	1
279	1	21	2021-09-08 17:57:33	f	1
308	1	40	2021-10-22 19:54:13	f	1
227	1	33	2021-08-30 21:31:48	f	1
227	1	34	2021-08-30 21:31:48	f	1
67	2	55	2021-09-08 17:54:31	f	1
67	1	55	2021-09-08 17:54:31	f	1
227	1	55	2021-09-08 17:54:52	f	1
227	1	30	2021-09-08 17:55:09	f	1
310	2	49	2021-09-08 18:26:56	f	1
298	1	35	2021-09-08 18:26:56	f	1
298	1	17	2021-09-08 18:26:00	f	1
298	2	30	2021-09-08 18:26:58	t	1
298	2	55	2021-09-08 18:26:58	t	1
298	2	19	2021-09-08 18:26:58	t	1
298	2	20	2021-09-08 18:26:58	t	1
298	2	33	2021-09-08 18:26:58	t	1
298	2	34	2021-09-08 18:26:58	t	1
298	2	17	2021-09-08 18:26:58	t	1
298	1	30	2021-09-08 18:25:27	f	1
298	2	32	2021-09-08 18:26:58	t	1
298	2	31	2021-09-08 18:26:58	t	1
227	1	17	2021-08-30 21:31:54	f	1
298	2	35	2021-09-08 18:26:58	t	1
23	2	1	2021-10-08 22:40:48	t	1
23	1	1	2021-10-08 22:40:48	f	1
227	1	32	2021-08-30 21:31:58	f	1
298	1	55	2021-09-08 18:25:32	f	1
279	1	33	2021-09-08 17:57:45	f	1
279	1	34	2021-09-08 17:57:45	f	1
14	2	1	2021-10-08 22:43:20	t	1
14	1	1	2021-10-08 22:43:20	f	1
298	1	32	2021-09-08 18:26:05	f	1
92	2	56	2021-10-08 23:04:52	f	1
92	1	56	2021-10-08 23:04:53	f	1
45	2	14	2021-09-14 22:43:07	t	1
45	1	14	2021-09-14 22:43:07	f	1
240	2	56	2021-10-08 23:05:09	f	1
240	1	56	2021-10-08 23:05:09	f	1
227	1	31	2021-08-30 21:32:05	f	1
291	1	56	2021-10-08 23:05:41	f	1
308	2	56	2021-10-08 23:05:58	f	1
308	1	56	2021-10-08 23:05:58	f	1
298	1	20	2021-09-08 18:25:39	f	1
237	2	49	2021-08-30 21:32:07	f	1
73	2	50	2021-10-08 23:06:43	t	1
45	2	12	2021-09-16 20:36:42	t	1
45	1	12	2021-09-16 20:36:42	f	1
73	1	50	2021-10-08 23:06:43	f	1
45	2	1	2021-09-16 20:37:20	t	1
45	1	1	2021-09-16 20:37:20	f	1
279	1	32	2021-09-08 17:58:07	f	1
95	2	21	2021-10-08 23:07:33	f	1
95	2	22	2021-10-08 23:07:33	f	1
287	2	49	2021-09-08 17:58:14	f	1
298	1	31	2021-09-08 18:26:12	f	1
306	2	49	2021-09-08 18:26:14	f	1
307	2	49	2021-09-08 18:26:17	f	1
289	2	49	2021-09-08 17:58:18	f	1
\.


--
-- TOC entry 4576 (class 0 OID 16519)
-- Dependencies: 214
-- Data for Name: content; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.content (id, "elementId", "siteId", title, "dateCreated", "dateUpdated", uid, field_path, "field_siteDescription", "field_siteTitle", "field_catalogVariety", "field_sourceSize", field_target, field_fov, "field_fovMin", "field_fovMax", field_heading, field_subheading, field_duration, field_complexity, field_description, field_ra, field_dec, "field_factsHeading", "field_introHeading", "field_introSubheading", field_characteristics, "field_altText", "field_astroObjectId", "field_varietyHandle", "field_varietyName") FROM stdin;
1	1	1	\N	2021-05-19 21:09:33	2021-05-19 21:09:33	70b34bdf-a7a9-45ed-9eef-c76d043f7efb	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
3	3	1	\N	2021-05-19 22:50:51	2021-05-19 22:50:51	b0cffdee-849e-4bb9-8988-d901848bebd4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
4	4	1	\N	2021-05-19 22:52:54	2021-05-19 22:52:54	295ab0a4-dbfe-4c7f-950e-82a2d38de081	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
5	5	1	Allsky HiPS Catalog Data	2021-05-19 22:53:34	2021-05-19 22:54:38	17bb60b2-3775-4b73-87c7-57db9be0aebb	https://epo-hips.netlify.app/catalog/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
31	18	1	Stars Catalog	2021-06-15 17:23:28	2021-06-15 17:23:28	97096c09-ab05-4f8f-b0b4-d76cdbc96dc2	https://epo-hips.netlify.app/catalog_stars/	\N	\N	["star"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
32	18	2	Stars Catalog	2021-06-15 17:23:28	2021-06-15 17:23:28	5feb67ce-5f42-4201-b61d-6112371efe08	https://epo-hips.netlify.app/catalog_stars/	\N	\N	["star"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
35	20	1	Galaxies Catalog	2021-06-15 17:23:49	2021-06-15 17:23:49	247936d8-c98b-46d4-ac05-f446d0470c8a	https://epo-hips.netlify.app/catalog_galaxies/	\N	\N	["galaxy"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
36	20	2	Galaxies Catalog	2021-06-15 17:23:49	2021-06-15 17:23:49	0fc16d14-9ebd-4867-b87a-69c513ae21bd	https://epo-hips.netlify.app/catalog_galaxies/	\N	\N	["galaxy"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
13	9	1	Stars Catalog	2021-06-15 16:50:17	2021-06-15 16:50:17	4b7f936c-63ce-475a-b85c-c730ac4067b0	https://epo-hips.netlify.app/catalog_stars/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
14	9	2	Stars Catalog	2021-06-15 16:50:17	2021-06-15 16:50:17	9f5aebfb-cc3b-4668-9b1f-4c08f8239032	https://epo-hips.netlify.app/catalog_stars/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	10	1	\N	2021-06-15 16:58:55	2021-06-15 16:58:55	ca960dba-3e22-4cfe-a179-70455767a7b1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
16	10	2	\N	2021-06-15 16:58:55	2021-06-15 16:58:55	71adf856-75db-496b-a237-e61b3220fd63	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
17	11	1	\N	2021-06-15 16:59:52	2021-06-15 16:59:52	022aeb76-9d46-41e9-bf0f-898bfd13a7d2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
18	11	2	\N	2021-06-15 16:59:52	2021-06-15 16:59:52	50b80a0d-c915-47c9-86c1-9273f8ced4a7	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
2	2	1	Allsky HiPS Catalog Data	2021-05-19 21:19:04	2021-06-15 17:00:20	faa6d77a-f151-4b08-95a8-02727c11bdb4	https://epo-hips.netlify.app/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
8	2	2	Allsky HiPS Catalog Data	2021-06-15 16:41:05	2021-06-15 17:00:20	9b2c6eb4-32f4-405d-a033-7013a211b4e8	https://epo-hips.netlify.app/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
19	12	1	Stars Catalog	2021-06-15 17:04:56	2021-06-15 17:04:56	aafecc12-7a83-4b44-b180-9610815247b4	https://epo-hips.netlify.app/catalog_stars/	\N	\N	[]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
20	12	2	Stars Catalog	2021-06-15 17:04:56	2021-06-15 17:04:56	ccc0f5e4-4644-471a-a185-aa2ada6daa1c	https://epo-hips.netlify.app/catalog_stars/	\N	\N	[]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
25	15	1	Galaxies Catalog	2021-06-15 17:17:51	2021-06-15 17:17:51	e257b943-cd30-46b4-9ccf-293ed0eb3a3b	https://epo-hips.netlify.app/catalog_galaxies/	\N	\N	["galaxy"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
26	15	2	Galaxies Catalog	2021-06-15 17:17:51	2021-06-15 17:17:51	dc0d8981-211b-46f2-83dc-7100e14616e5	https://epo-hips.netlify.app/catalog_galaxies/	\N	\N	["galaxy"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
27	16	1	Stars Catalog	2021-06-15 17:21:23	2021-06-15 17:21:23	e83999d6-27f7-4e64-823f-b1280c47186d	https://epo-hips.netlify.app/catalog_stars/	\N	\N	["star"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
28	16	2	Stars Catalog	2021-06-15 17:21:23	2021-06-15 17:21:23	d457d575-e8ae-4ea8-92da-88202bc130a6	https://epo-hips.netlify.app/catalog_stars/	\N	\N	["star"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
44	24	2	Nebulae Catalog	2021-06-15 17:34:27	2021-06-15 17:34:27	35be1111-160d-409c-b3c7-4cc8f9c00133	https://epo-hips.netlify.app/catalog_nebulae/	\N	\N	["nebula"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
43	24	1	Nebulae Catalog	2021-06-15 17:34:27	2021-06-15 17:34:27	4604e80f-605f-43f4-bc31-b036fbfa6db7	https://epo-hips.netlify.app/catalog_nebulae/	\N	\N	["nebula"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
51	28	1	Transients Catalog	2021-06-15 17:51:12	2021-06-15 17:51:12	ffd8f235-edfb-429b-bead-d61912201b91	https://epo-hips.netlify.app/catalog_transients/	\N	\N	["transient"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
52	28	2	Transients Catalog	2021-06-15 17:51:12	2021-06-15 17:51:12	4fc807aa-9f1e-4b84-99a4-2a3d21e78d9f	https://epo-hips.netlify.app/catalog_transients/	\N	\N	["transient"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
67	36	1	Landmarks Catalog	2021-06-15 17:58:33	2021-06-15 17:58:33	5996219c-e8d2-45cf-bcd8-2207059db3c2	https://epo-hips.netlify.app/catalog_landmarks/	\N	\N	["landmark"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
68	36	2	Landmarks Catalog	2021-06-15 17:58:33	2021-06-15 17:58:33	2234cd9e-7a6d-4da3-a235-4273ef1900eb	https://epo-hips.netlify.app/catalog_landmarks/	\N	\N	["landmark"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
55	30	1	Fun goal icon	2021-06-15 17:54:39	2021-06-15 17:54:39	7d485781-b15d-4b5d-8195-ca0f8afa4521	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
56	30	2	Fun goal icon	2021-06-15 17:54:39	2021-06-15 17:54:39	3fea10b1-ad55-4b4d-ada9-a4dccc6879de	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
59	32	1	Goals Catalog	2021-06-15 17:54:45	2021-06-15 17:54:45	8072b915-f59c-4331-b2c9-aeb4af646632	https://epo-hips.netlify.app/catalog_goals/	\N	\N	["goal"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
60	32	2	Goals Catalog	2021-06-15 17:54:45	2021-06-15 17:54:45	d3dd5041-4646-453e-9b2b-8eca5a365140	https://epo-hips.netlify.app/catalog_goals/	\N	\N	["goal"]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
71	38	1	Control HEALPix Catalog	2021-06-15 18:07:52	2021-06-15 18:07:52	ec127204-9cb2-446a-bcf6-3d8c000cfb41	https://epo-hips.netlify.app/images/	\N	\N	[]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
39	22	1	Nebula icon	2021-06-15 17:34:12	2021-08-17 20:36:15	22efad4e-439c-4938-871f-c2c1f85b3d6b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
29	17	1	Star icon	2021-06-15 17:23:21	2021-08-17 20:35:42	cd471840-2fca-41d1-8e10-89e2a6573a86	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
30	17	2	Star icon	2021-06-15 17:23:21	2021-08-17 20:35:42	5fd5e91c-edf9-42a4-af4a-71a7c8605490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
40	22	2	Nebula icon	2021-06-15 17:34:13	2021-08-17 20:36:16	e8563b1d-7c05-4477-886b-eb651386d63a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
47	26	1	Transient icon	2021-06-15 17:51:02	2021-08-17 20:36:37	d8fd4c0e-4491-49d8-a761-eeba4b179d11	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
48	26	2	Transient icon	2021-06-15 17:51:02	2021-08-17 20:36:37	1b1b3bd3-0df8-43a4-83d0-acb79125509c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
72	38	2	Control HEALPix Catalog	2021-06-15 18:07:52	2021-06-15 18:07:52	d6fcee01-d169-4707-9544-ddeb814eec36	https://epo-hips.netlify.app/images/	\N	\N	[]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
73	39	1	Control HEALPix Catalog	2021-06-15 18:07:52	2021-06-15 18:07:52	65f3c6e3-0e0b-4f1a-a03a-83860e46cf7b	https://epo-hips.netlify.app/images/	\N	\N	[]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
74	39	2	Control HEALPix Catalog	2021-06-15 18:07:52	2021-06-15 18:07:52	30fd0872-be4e-4278-a656-81633fc0e68e	https://epo-hips.netlify.app/images/	\N	\N	[]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
65	35	1	landmark	2021-06-15 17:58:32	2021-10-08 22:43:16	acb260a4-d19d-499b-837f-28db50435be4	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	landmark	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
49	27	1	nebula	2021-06-15 17:51:12	2021-10-08 22:42:36	57434b6b-ea9c-423e-9b32-e8ae7a7a5e09	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	transient	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
41	23	1	galaxy	2021-06-15 17:34:27	2021-10-08 22:40:48	08602eb4-5ac7-4451-b640-0f3b69722913	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	nebula	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
57	31	1	transient	2021-06-15 17:54:44	2021-10-08 22:42:54	664a429e-738f-4a1b-9550-af41497dab05	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	goal	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
58	31	2	Goals Catalog	2021-06-15 17:54:45	2021-10-08 22:42:54	8c2bf691-5655-46ae-9207-a1ce5fa3c6f6	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	goal	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
66	35	2	Landmarks Catalog	2021-06-15 17:58:33	2021-10-08 22:43:16	1604bd09-c27b-47fa-9477-6ecec55aaa54	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	landmark	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
63	34	1	Landmark icon	2021-06-15 17:58:28	2021-06-15 17:58:28	e65c1f45-6798-44e9-9c9e-b010f9a9883d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
64	34	2	Landmark icon	2021-06-15 17:58:28	2021-06-15 17:58:28	8267e12c-057e-4094-8638-e4b65b7dadfd	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
79	42	1	AKARI Catalog	2021-06-15 18:11:30	2021-06-15 18:11:30	b030ad08-e9b1-4191-9925-6b3532d0db4e	https://epo-hips.netlify.app/catalog/	\N	\N	[]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
80	42	2	AKARI Catalog	2021-06-15 18:11:30	2021-06-15 18:11:30	826d5884-a34a-40c6-b9e8-a7017efe28ca	https://epo-hips.netlify.app/catalog/	\N	\N	[]	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
81	43	1	\N	2021-06-15 21:36:09	2021-06-15 21:36:09	ea1f6514-0c9f-45d5-932c-266ff233a408	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
82	43	2	\N	2021-06-15 21:36:09	2021-06-15 21:36:09	d19b115c-1b67-4cbc-a71f-147b4a93ea5f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
89	47	1	\N	2021-06-21 22:42:31	2021-06-21 22:42:31	a9d83e91-868f-48ee-a9f8-2ac8168509fb	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
90	47	2	\N	2021-06-21 22:42:31	2021-06-21 22:42:31	7e025183-5a30-4014-982d-e98a0fe4c811	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
87	46	1	Control HEALPix Catalog	2021-06-15 21:38:14	2021-06-15 21:38:14	8017b9f1-e243-4b7d-830a-c9906c27c88a	\N	\N	\N	\N	\N	267.0208333333 -24.7800000000	60	2	90	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
88	46	2	Control HEALPix Catalog	2021-06-15 21:38:14	2021-06-15 21:38:14	6417b2c0-2c70-4b3f-a4a4-3125d8af4434	\N	\N	\N	\N	\N	267.0208333333 -24.7800000000	60	2	90	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
102	57	2	Why Aliens??	2021-06-21 23:06:50	2021-06-21 23:06:50	6c4d7382-e3b6-4e2a-8aec-188d5687e759	\N	\N	\N	\N	\N	\N	\N	\N	\N	Why not???	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
103	61	1	Why Aliens??	2021-06-21 23:06:50	2021-06-21 23:06:50	fca1c0f8-d678-4d9f-84f8-531788a5a8ac	\N	\N	\N	\N	\N	\N	\N	\N	\N	Why not???	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
93	49	1	Astrocat	2021-06-21 23:02:56	2021-06-21 23:02:56	2a6cd32c-dcd7-4e18-8d0e-15ccdbf4dd7b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
94	49	2	Astrocat	2021-06-21 23:02:56	2021-06-21 23:02:56	0556cce8-7b98-4235-a76b-3762bfe2a793	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
101	57	1	Why Aliens??	2021-06-21 23:06:50	2021-06-21 23:06:50	a8b3a004-9b03-4900-9174-ca1ac90c8529	\N	\N	\N	\N	\N	\N	\N	\N	\N	Why not???	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
95	50	1	Fo4 pebbles artwork	2021-06-21 23:03:21	2021-06-21 23:03:21	bc43f79b-8de9-42b8-bc35-cc22cdaef622	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
96	50	2	Fo4 pebbles artwork	2021-06-21 23:03:21	2021-06-21 23:03:21	b7764806-ca88-4caa-9ba9-ed4067108742	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
97	51	1	Alien Hunting	2021-06-21 23:04:33	2021-06-21 23:04:33	7b821cdd-d90a-4233-952a-3c4b7ef371ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	The Truth is Out There!	Aliens - What a Concept!	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
98	51	2	Alien Hunting	2021-06-21 23:04:33	2021-06-21 23:04:33	8317f07d-49ae-4d5e-b96b-5295b13feb01	\N	\N	\N	\N	\N	\N	\N	\N	\N	The Truth is Out There!	Aliens - What a Concept!	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
99	54	1	Alien Hunting	2021-06-21 23:04:33	2021-06-21 23:04:33	c1debf3c-dbb6-4469-9d51-cad1c344013e	\N	\N	\N	\N	\N	\N	\N	\N	\N	The Truth is Out There!	Aliens - What a Concept!	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
100	54	2	Alien Hunting	2021-06-21 23:04:33	2021-06-21 23:04:33	58f02228-776a-40d9-95fd-514a9c42925e	\N	\N	\N	\N	\N	\N	\N	\N	\N	The Truth is Out There!	Aliens - What a Concept!	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
104	61	2	Why Aliens??	2021-06-21 23:06:50	2021-06-21 23:06:50	5ecce77b-ca7e-4157-b9e6-2b0feef844cc	\N	\N	\N	\N	\N	\N	\N	\N	\N	Why not???	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
107	66	1	The mothership	2021-06-21 23:15:44	2021-06-21 23:15:44	04002278-eff7-4e76-863e-2fcc66b76aeb	\N	\N	\N	\N	\N	\N	50	\N	\N	\N	\N	\N	\N	Such and such	1	123123	\N	\N	\N	\N	\N	\N	\N	\N
108	66	2	The mothership	2021-06-21 23:15:45	2021-06-21 23:15:45	f3477817-550a-4323-bd45-4b791a2b4c71	\N	\N	\N	\N	\N	\N	50	\N	\N	\N	\N	\N	\N	Such and such	1	123123	\N	\N	\N	\N	\N	\N	\N	\N
111	68	1	The Search for Aliens	2021-06-21 23:15:49	2021-06-21 23:15:49	0cb33aaa-d0b1-4618-8733-fa8a4c3bf669	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
112	68	2	The Search for Aliens	2021-06-21 23:15:49	2021-06-21 23:15:49	f1fccb51-d7ab-4edc-b781-bd99fa9f0db3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
113	70	1	The Search for Aliens	2021-06-22 21:51:08	2021-06-22 21:51:08	1f2033ba-35aa-4aed-9c65-f79e5ccec727	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	Some heading	another subheading	\N	\N	\N	\N	\N
114	70	2	The Search for Aliens	2021-06-22 21:51:08	2021-06-22 21:51:08	170972c8-44f8-47ba-a37e-deed5811ceb6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
115	74	1	The Search for Aliens	2021-06-22 21:51:45	2021-06-22 21:51:45	7a395e45-9825-47fe-9cef-c37c04da7107	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	How about this fun fact!	Some heading	another subheading	\N	\N	\N	\N	\N
116	74	2	The Search for Aliens	2021-06-22 21:51:45	2021-06-22 21:51:45	245c2111-4210-4317-9eb5-74629ea04171	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
77	41	1	AKARI Catalog	2021-06-15 18:11:30	2021-06-22 21:50:24	f76fdaf3-c67a-4ebb-af9c-c54961bdd480	https://epo-hips.netlify.app/catalog/	\N	\N	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
78	41	2	AKARI Catalog	2021-06-15 18:11:30	2021-06-22 21:50:24	79f089c1-0da1-46b1-b2be-6a13e61b9f55	https://epo-hips.netlify.app/catalog/	\N	\N	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
117	78	1	\N	2021-06-28 17:39:27	2021-06-28 17:39:27	fe86fb81-5c4c-49c9-b459-0f99da458aa7	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
118	79	1	\N	2021-06-28 17:41:30	2021-06-28 17:41:30	78e0360a-0369-430b-af24-073e3b5f0521	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
119	80	1	\N	2021-06-28 17:42:18	2021-06-28 17:42:18	f8a18787-741e-4a53-a03a-087676424b5d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
122	82	1	Tester	2021-07-16 17:53:05	2021-07-16 17:53:05	f3a5cf24-b951-4666-b1b4-62a619b61521	http://eric.rosas	\N	\N	star	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
123	82	2	Tester	2021-07-16 17:53:05	2021-07-16 17:53:05	b4b79a54-3ebe-4fba-b5f4-b07e0d548aa3	http://eric.rosas	\N	\N	star	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
124	83	1	Tester	2021-07-16 17:53:05	2021-07-16 17:53:05	907c77a7-e2c4-4b4a-bfcc-6d756eef4098	http://eric.rosas	\N	\N	star	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
125	83	2	Tester	2021-07-16 17:53:05	2021-07-16 17:53:05	fe7fed72-8408-4fba-b01f-b312972b5dac	http://eric.rosas	\N	\N	star	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
126	84	1	\N	2021-07-16 18:41:34	2021-07-16 18:41:34	02d42a2f-1fd7-4cf5-85ed-4b5e0d368a44	\N	\N	\N	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
127	84	2	\N	2021-07-16 18:41:34	2021-07-16 18:41:34	66d8df78-8378-440e-9cb4-bf99f6080470	\N	\N	\N	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
136	99	1	Tour de Force	2021-07-16 18:43:41	2021-07-16 18:43:41	12218c14-2791-4afb-a6d1-713368580400	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
105	65	1	The mothership	2021-06-21 23:15:44	2021-07-23 22:53:57	c7d481e0-ace4-4704-b697-cbdb56471062	\N	\N	\N	\N	\N	\N	50	\N	\N	\N	\N	\N	\N	Such and such	1	123123	\N	\N	\N	\N	\N	\N	\N	\N
106	65	2	The mothership	2021-06-21 23:15:44	2021-07-23 22:53:59	583a7439-363e-4610-b5dd-fcdda721d5d1	\N	\N	\N	\N	\N	\N	50	\N	\N	\N	\N	\N	\N	Such and such	1	123123	\N	\N	\N	\N	\N	\N	\N	\N
137	99	2	Tour de Force	2021-07-16 18:43:42	2021-07-16 18:43:42	bd03189c-8e28-49cc-a2b4-253a1a85de9d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
138	103	1	Check out this tour!	2021-07-16 18:45:50	2021-07-16 18:45:50	52095dc7-f9f5-4837-9988-74d25bb7bdfc	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	5	\N	\N	\N	<h1>Blah blah</h1>	\N	\N	\N	\N
139	103	2	Check out this tour!	2021-07-16 18:45:50	2021-07-16 18:45:50	086cc34e-908c-4098-9526-608f91fd11b2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	5	\N	\N	\N	<h1>Blah blah</h1>	\N	\N	\N	\N
140	104	1	Tour de Force	2021-07-16 18:45:52	2021-07-16 18:45:52	26fe9c05-b817-4017-a7df-aab8b13631a1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
141	104	2	Tour de Force	2021-07-16 18:45:52	2021-07-16 18:45:52	621f63fd-398f-48de-a2ca-f656259ffa63	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
132	93	1	Check out this tour!	2021-07-16 18:43:23	2021-07-16 18:43:23	27c19f1c-d4b0-4da2-9fcd-6f02774f284d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	5	\N	\N	\N	Blah blah	\N	\N	\N	\N
6	6	1	\N	2021-06-15 15:02:03	2021-08-30 21:29:11	48cafb83-0b31-4ebd-987b-05e1d62e7a52	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
7	6	2	\N	2021-06-15 15:02:03	2021-08-30 21:29:11	8dbc8df9-ffd1-428f-9524-707fe80a63bf	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
85	45	1	Control HEALPix Catalog	2021-06-15 21:38:14	2021-09-16 20:37:20	a8a72b6a-9c8a-4394-a52a-d981c8323c76	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	107.0208333333 -2.7800000000	40	1	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
133	93	2	Check out this tour!	2021-07-16 18:43:23	2021-07-16 18:43:23	68fb2910-5ebc-4727-bf56-fb9048c19f71	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	5	\N	\N	\N	Blah blah	\N	\N	\N	\N
142	108	1	The Search for Alienz	2021-07-19 22:32:06	2021-07-19 22:32:06	d52c1fd9-a660-4f83-8b4f-a918c7740e77	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	How about this fun fact!	Some heading	another subheading	\N	\N	\N	\N	\N
143	108	2	The Search for Aliens	2021-07-19 22:32:16	2021-07-19 22:32:16	17059c18-5d3e-40cc-ab5e-8108ebfda849	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
166	124	1	Nebulae Catalog	2021-08-06 22:23:40	2021-08-06 22:23:40	6f8b9fc5-6b3e-4d22-8ce7-fbeeea98edca	https://storage.googleapis.com/hips-data/catalog_nebulae/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
167	124	2	Nebulae Catalog	2021-08-06 22:23:40	2021-08-06 22:23:40	997b31c9-52d4-424a-ba4f-38753ee8e488	https://storage.googleapis.com/hips-data/catalog_nebulae/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
144	112	1	\N	2021-07-26 16:36:01	2021-07-26 16:51:44	a7d354eb-9c82-4307-985d-8587174a8b19	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
145	113	1	\N	2021-07-26 17:36:47	2021-07-26 17:36:47	37289b68-f0d9-44b9-aa64-5b42cb6a5e1b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
33	19	1	Galaxy icon	2021-06-15 17:23:44	2021-08-17 20:36:00	46a3e6e6-3f1f-4ed4-bcdd-ab138a06b4b9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
174	128	1	Stars Catalog	2021-08-06 22:25:32	2021-08-06 22:25:32	bea642db-4eaf-4613-8427-24f8b3953bfb	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
150	116	1	Galaxy icon	2021-08-06 22:19:57	2021-08-06 22:19:57	12c07216-65a2-4ee4-b06f-3aa807cfbd8f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
151	116	2	Galaxy icon	2021-08-06 22:19:57	2021-08-06 22:19:57	b2269f12-909a-4a71-aad9-d08c836b51ee	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
154	118	1	Nebula icon	2021-08-06 22:19:58	2021-08-06 22:19:58	793ccb23-63e9-4d0d-be04-108a59f666f5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
155	118	2	Nebula icon	2021-08-06 22:19:58	2021-08-06 22:19:58	8ffc6a39-7049-4010-aed1-1d8b1f965fc0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
156	119	1	Star icon	2021-08-06 22:19:58	2021-08-06 22:19:58	7a4cd9c2-0ef3-497a-b561-3b9766b228c9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
157	119	2	Star icon	2021-08-06 22:19:58	2021-08-06 22:19:58	e40ff1ba-16c8-433a-8317-73dc1e7de95a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
158	120	1	Transient icon	2021-08-06 22:19:58	2021-08-06 22:19:58	67588a3f-8225-42dd-a9d0-49f303978c02	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
159	120	2	Transient icon	2021-08-06 22:19:58	2021-08-06 22:19:58	bb819e85-80c0-44c1-98d5-301f896185e9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
160	121	1	Stars Catalog	2021-08-06 22:23:02	2021-08-06 22:23:02	8c2e8283-fb8a-4639-9c88-904b9b79eab8	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
161	121	2	Stars Catalog	2021-08-06 22:23:03	2021-08-06 22:23:03	2b3c5802-7fcd-498a-8896-6d765037ac7c	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
162	122	1	Galaxies Catalog	2021-08-06 22:23:19	2021-08-06 22:23:19	46df0a9c-337d-4944-98b5-717062df53f9	https://storage.googleapis.com/hips-data/catalog_galaxies/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
163	122	2	Galaxies Catalog	2021-08-06 22:23:19	2021-08-06 22:23:19	40c4796f-bdb1-4eb1-b629-7befb4489a89	https://storage.googleapis.com/hips-data/catalog_galaxies/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
148	115	1	Fun goal icon	2021-08-06 22:19:57	2021-08-17 20:37:00	016993d7-19d3-41d2-be31-efda84832a8c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
164	123	1	Stars Catalog	2021-08-06 22:23:24	2021-08-06 22:23:24	9fdc69a3-2087-49fb-ad55-2647b35cb716	https://storage.googleapis.com/hips-data/catalog_stars/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
165	123	2	Stars Catalog	2021-08-06 22:23:25	2021-08-06 22:23:25	f35fe757-4b84-41a5-8cf9-326e677d95ec	https://storage.googleapis.com/hips-data/catalog_stars/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
168	125	1	Transients Catalog	2021-08-06 22:23:52	2021-08-06 22:23:52	0d179e3b-2bc8-402f-9a62-ea296238c99f	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
169	125	2	Transients Catalog	2021-08-06 22:23:53	2021-08-06 22:23:53	b40c4ec2-9a21-48bf-8b50-be80bebca2f3	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
170	126	1	Goals Catalog	2021-08-06 22:24:07	2021-08-06 22:24:07	1377c681-a851-4d9e-b070-38dc1cb1bf64	https://storage.googleapis.com/hips-data/catalog_goals/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
171	126	2	Goals Catalog	2021-08-06 22:24:07	2021-08-06 22:24:07	0ea35626-07eb-4cc2-b29b-91789144b7aa	https://storage.googleapis.com/hips-data/catalog_goals/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
172	127	1	Landmarks Catalog	2021-08-06 22:24:29	2021-08-06 22:24:29	244e23f0-fc9e-47f8-a3de-7c6ef402818c	https://storage.googleapis.com/hips-data/catalog_landmarks/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
173	127	2	Landmarks Catalog	2021-08-06 22:24:29	2021-08-06 22:24:29	0d632b6e-b901-4fe8-8315-c42899548460	https://storage.googleapis.com/hips-data/catalog_landmarks/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
34	19	2	Galaxy icon	2021-06-15 17:23:44	2021-08-17 20:36:00	310a8b42-a27e-4825-8bcc-34169ece22ce	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
149	115	2	Fun goal icon	2021-08-06 22:19:57	2021-08-17 20:37:00	6cd0658c-59b1-49ca-ada3-e19adb8cf72b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
152	117	1	Landmark icon	2021-08-06 22:19:58	2021-08-17 20:37:14	a06bc0f3-a993-418a-af17-fe5304d30b66	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
153	117	2	Landmark icon	2021-08-06 22:19:58	2021-08-17 20:37:14	b93cb12d-d431-4b16-913b-69d2fdb38b9a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
175	128	2	Stars Catalog	2021-08-06 22:25:32	2021-08-06 22:25:32	e3925110-bc8c-4de8-b4a2-00684c7e8b4f	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
176	129	1	Galaxies Catalog	2021-08-06 22:25:37	2021-08-06 22:25:37	a347da1b-6c30-47e5-aa7e-e1e3f7f2d094	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
177	129	2	Galaxies Catalog	2021-08-06 22:25:37	2021-08-06 22:25:37	be987cdb-c123-474d-a00b-4d36c654caa7	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
178	130	1	Nebulae Catalog	2021-08-06 22:25:41	2021-08-06 22:25:41	d0d88f95-7102-4e72-bb62-426bd1807470	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
179	130	2	Nebulae Catalog	2021-08-06 22:25:41	2021-08-06 22:25:41	f1d14f6c-e65e-462f-9991-dd6488ab5f77	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
180	131	1	Transients Catalog	2021-08-06 22:25:45	2021-08-06 22:25:45	44a9d541-fb80-4a8f-bdc4-32ab5c49501a	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
181	131	2	Transients Catalog	2021-08-06 22:25:45	2021-08-06 22:25:45	a4e8ebde-dcbf-43c8-85eb-04b4b2084eb1	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
182	132	1	Goals Catalog	2021-08-06 22:25:54	2021-08-06 22:25:54	5b9bbd6a-b997-454b-b0f1-314dc39a9b46	https://storage.googleapis.com/hips-data/catalog_goals/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
183	132	2	Goals Catalog	2021-08-06 22:25:54	2021-08-06 22:25:54	c411e4d3-406a-43a2-9844-9ca3afc833d2	https://storage.googleapis.com/hips-data/catalog_goals/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
134	95	1	Tour de Forcez	2021-07-16 18:43:41	2021-10-08 23:07:33	2b11a01d-c843-4816-b349-6dbdd5106e63	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
12	8	2	Stars Catalog	2021-06-15 16:50:17	2021-08-20 22:02:00	2f829720-d655-4064-975b-293a8bf5de1e	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	star	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
50	27	2	Transients Catalog	2021-06-15 17:51:12	2021-10-08 22:42:36	fc01e2e8-4ff8-4d3e-a75c-16f960402ed6	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	transient	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
109	67	1	The Search for Alienz	2021-06-21 23:15:49	2021-10-08 23:06:42	af169d06-f79b-4280-9d76-8b52e0f729a2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	How about this fun fact!	Some heading	another subheading	\N	\N	\N	\N	\N
24	14	2	Galaxies Catalog	2021-06-15 17:17:51	2021-10-08 22:43:20	277d4ad8-8cc9-4695-b1d8-5f5e41dcc769	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	galaxy	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
184	133	1	Goals Catalog	2021-08-06 22:25:59	2021-08-06 22:25:59	6dd5938e-e72a-4989-910d-8105a51e22c5	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
185	133	2	Goals Catalog	2021-08-06 22:25:59	2021-08-06 22:25:59	83c9c2ed-95de-4b0d-8e69-69080ac79ce5	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
186	134	1	Landmarks Catalog	2021-08-06 22:26:07	2021-08-06 22:26:07	bee17105-11d7-4b89-b62a-7f35ec860b69	https://storage.googleapis.com/hips-data/catalog_landmarks	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
187	134	2	Landmarks Catalog	2021-08-06 22:26:08	2021-08-06 22:26:08	f85c283b-c03a-4c8d-9be7-6781044f4109	https://storage.googleapis.com/hips-data/catalog_landmarks	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
188	135	1	Control HEALPix Catalog	2021-08-06 22:26:30	2021-08-06 22:26:30	9bede69c-6875-4487-91a4-3a384bf7fc7e	https://storage.googleapis.com/hips-data/images	\N	\N	\N	\N	267.0208333333 -24.7800000000	60	2	90	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
189	135	2	Control HEALPix Catalog	2021-08-06 22:26:30	2021-08-06 22:26:30	8dcc5441-ac8b-4790-aa0d-a2da93cf7e40	https://storage.googleapis.com/hips-data/images	\N	\N	\N	\N	267.0208333333 -24.7800000000	60	2	90	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
206	150	1	The Search for Alienz	2021-08-06 23:04:32	2021-08-06 23:04:32	64b91652-7502-4a57-92d6-e7781730be66	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	How about this fun fact!	Some heading	another subheading	\N	\N	\N	\N	\N
207	150	2	The Search for Aliens	2021-08-06 23:04:32	2021-08-06 23:04:32	c6adca4f-1afb-43a0-8d5c-4343e40106da	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
213	162	2	Control HEALPix Catalog	2021-08-06 23:06:48	2021-08-06 23:06:48	aeb4b62a-67f9-457c-9b41-539323801876	https://storage.googleapis.com/hips-data/images	\N	\N	\N	\N	267.0208333333 -24.7800000000	60	2	90	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
208	154	1	Tour de Force	2021-08-06 23:04:44	2021-08-06 23:04:44	bbddd1d9-0044-4308-8bc5-223fd0c9167d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
192	137	1	Test	2021-08-06 22:54:52	2021-08-06 22:54:52	80130898-f508-4562-b4fc-90b062109ba4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
193	137	2	Test	2021-08-06 22:54:52	2021-08-06 22:54:52	1e0ac90a-c924-4555-9c36-6c09dac3a91c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
209	154	2	Tour de Force	2021-08-06 23:04:44	2021-08-06 23:04:44	8e9bbf30-6ada-4ee8-a92b-e2e92625de80	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
210	158	1	Tour de Force	2021-08-06 23:05:17	2021-08-06 23:05:17	957b1784-e9e1-4ac5-9598-13776a85bc8e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
211	158	2	Tour de Force	2021-08-06 23:05:17	2021-08-06 23:05:17	f6519e1a-5114-4db7-9908-7955c1acebf0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
196	139	1	Eric Test	2021-08-06 22:54:56	2021-08-06 22:54:56	b3ecaaca-a090-4c10-9612-4be7c0aa3ea6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Rosas	Eric Test
197	139	2	Eric Test	2021-08-06 22:54:56	2021-08-06 22:54:56	3df0a7c9-942a-46b4-bb52-ec03296b05e6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Rosas	Eric Test
212	162	1	Control HEALPix Catalog	2021-08-06 23:06:48	2021-08-06 23:06:48	f0ea68ed-8751-44d1-8729-c6f3a3a1db96	https://storage.googleapis.com/hips-data/images	\N	\N	\N	\N	267.0208333333 -24.7800000000	60	2	90	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
198	140	1	Eric Test	2021-08-06 22:56:21	2021-08-06 22:56:21	91f34c6e-b897-489b-a7e9-a2914fa5679c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	tours	Eric Test
199	140	2	Eric Test	2021-08-06 22:56:21	2021-08-06 22:56:21	df3f36c1-2ca3-4311-a394-be95c69bc8d5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	tours	Eric Test
200	141	1	The Search for Alienz	2021-08-06 23:02:41	2021-08-06 23:02:41	a3b24895-c2ca-497a-9e65-dbb4ec695654	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	How about this fun fact!	Some heading	another subheading	\N	\N	\N	\N	\N
201	141	2	The Search for Aliens	2021-08-06 23:02:41	2021-08-06 23:02:41	8de570ec-72ad-4180-8618-1a7027965f32	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
202	145	1	Tour de Force	2021-08-06 23:02:51	2021-08-06 23:02:51	d9bb8cd1-ce63-4671-a481-a6d035b45a7b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
203	145	2	Tour de Force	2021-08-06 23:02:51	2021-08-06 23:02:51	9bb65489-924f-436d-a3b2-bcd704d75a35	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
194	138	1	Eric Test	2021-08-06 22:54:56	2021-08-06 23:03:19	ed2fc2c1-c342-455d-9e57-e14732bc18b9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	tours	Eric Test
195	138	2	Eric Test	2021-08-06 22:54:56	2021-08-06 23:03:19	7850bbe7-34a4-4365-adfc-b85f08a0bfa0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	tours	Eric Test
204	149	1	Eric Test	2021-08-06 23:03:19	2021-08-06 23:03:19	43565c0c-9dd0-407a-bc37-9fac60fdc77c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	tours	Eric Test
205	149	2	Eric Test	2021-08-06 23:03:19	2021-08-06 23:03:19	6ff6e4e6-40e8-4320-8611-a932d56060c3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	tours	Eric Test
214	163	1	Galaxies Catalog	2021-08-06 23:09:51	2021-08-06 23:09:51	0f5ec30d-ecd1-4ca5-abaf-6780401b52f6	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
215	163	2	Galaxies Catalog	2021-08-06 23:09:51	2021-08-06 23:09:51	3bb99ea1-021b-487b-9065-b548c107eba2	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
216	164	1	Nebulae Catalog	2021-08-06 23:10:01	2021-08-06 23:10:01	b9fbf410-076c-46ca-8fe0-1d09aa077ed7	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
217	164	2	Nebulae Catalog	2021-08-06 23:10:01	2021-08-06 23:10:01	25bcaf8a-0202-4165-ad11-e0f59ef2d573	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
218	165	1	Transients Catalog	2021-08-06 23:10:10	2021-08-06 23:10:10	a12e2eb2-05b2-4f4b-9aa6-0635a3fc4f9d	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
219	165	2	Transients Catalog	2021-08-06 23:10:10	2021-08-06 23:10:10	feb60929-9e09-4586-92fb-8a1c548a2b73	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
220	166	1	Goals Catalog	2021-08-06 23:10:21	2021-08-06 23:10:21	9928b396-235d-4795-8855-b5bb74678fad	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
221	166	2	Goals Catalog	2021-08-06 23:10:21	2021-08-06 23:10:21	8e866df8-3284-4beb-9499-16c54f119033	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
222	167	1	Fo4 pebbles artwork	2021-08-17 20:25:07	2021-08-17 20:25:07	20015e9f-71e1-4f3e-bc7d-909f8f457390	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
223	167	2	Fo4 pebbles artwork	2021-08-17 20:25:07	2021-08-17 20:25:07	b9ca8756-5f18-445f-8d23-2f853e0b6018	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
224	168	1	The Search for Alienz	2021-08-17 20:25:11	2021-08-17 20:25:11	653b36df-e5f5-44ce-bb7a-f57f1cc98398	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	How about this fun fact!	Some heading	another subheading	\N	\N	\N	\N	\N
225	168	2	The Search for Aliens	2021-08-17 20:25:11	2021-08-17 20:25:11	404c062f-1d5a-4b98-b226-2e1183d025ce	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
226	172	1	Control HEALPix Catalog	2021-08-17 20:25:16	2021-08-17 20:25:16	cd873ba5-84a4-41e4-a217-46cb181916d1	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	267.0208333333 -24.7800000000	60	2	90	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
227	172	2	Control HEALPix Catalog	2021-08-17 20:25:16	2021-08-17 20:25:16	81205f41-ebd7-4df8-a4fd-0347b77e8471	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	267.0208333333 -24.7800000000	60	2	90	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
228	173	1	Tour de Force	2021-08-17 20:25:35	2021-08-17 20:25:35	89a21c4f-cd79-4e98-bd51-8e695af14c3b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
110	67	2	The Search for Aliens	2021-06-21 23:15:49	2021-10-08 23:06:43	27397715-87a5-49a8-b3dc-38cb181aefca	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
86	45	2	Control HEALPix Catalog	2021-06-15 21:38:14	2021-09-16 20:37:21	520c26e6-41b3-444d-a73d-d6ebb22b1bb6	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	107.0208333333 -2.7800000000	40	1	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
229	173	2	Tour de Force	2021-08-17 20:25:35	2021-08-17 20:25:35	bfc11a50-ed96-49c4-8fdf-48b3ea35f526	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
234	179	1	Tour de Force	2021-08-17 20:28:35	2021-08-17 20:28:35	d5c87bdc-b4e9-4c2f-8a73-022402ec026c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
235	179	2	Tour de Force	2021-08-17 20:28:35	2021-08-17 20:28:35	d69de305-efa5-478f-ae20-3a2d63651716	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
236	183	1	Tour de Force	2021-08-17 20:29:06	2021-08-17 20:29:06	65371c29-96f2-412b-ad86-dd5419db21cd	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
237	183	2	Tour de Force	2021-08-17 20:29:06	2021-08-17 20:29:06	cdde40b5-c768-4c4e-8d4f-7b98d95a4352	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
238	187	1	Star icon	2021-08-17 20:35:39	2021-08-17 20:35:39	5f42e48e-210b-4d7c-9d24-9d458106471b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
239	187	2	Star icon	2021-08-17 20:35:39	2021-08-17 20:35:39	ecec4c04-8337-4017-863d-fe3159127747	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
240	188	1	Stars Catalog	2021-08-17 20:35:45	2021-08-17 20:35:45	43780435-ff68-4e0e-9098-cfe1b22e47ba	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
241	188	2	Stars Catalog	2021-08-17 20:35:46	2021-08-17 20:35:46	e2b13900-e097-4f1b-9b7c-010047028622	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
242	189	1	Galaxy icon	2021-08-17 20:35:57	2021-08-17 20:35:57	ad951f62-0209-4d70-987d-bbbe221fcda4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
243	189	2	Galaxy icon	2021-08-17 20:35:57	2021-08-17 20:35:57	d6b515a2-9f8e-4447-bdff-5c7bacae0415	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
244	190	1	Galaxies Catalog	2021-08-17 20:36:03	2021-08-17 20:36:03	98071661-663c-4fcb-bf97-46e04e88dad5	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
245	190	2	Galaxies Catalog	2021-08-17 20:36:03	2021-08-17 20:36:03	65153ccd-dbda-4902-ac0e-0ed5a950d352	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
246	191	1	Nebula icon	2021-08-17 20:36:13	2021-08-17 20:36:13	a4912957-4c77-4ebb-b691-d7f0521bf87b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
247	191	2	Nebula icon	2021-08-17 20:36:13	2021-08-17 20:36:13	f824e1d6-ab88-4e23-a184-7a153dae3f3f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
248	192	1	Nebulae Catalog	2021-08-17 20:36:18	2021-08-17 20:36:18	3c8fc9cb-96bb-4402-a397-05ef7504eb9e	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
249	192	2	Nebulae Catalog	2021-08-17 20:36:19	2021-08-17 20:36:19	41051d7e-e30c-47f0-aa82-d8ca636f521c	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
250	193	1	Transient icon	2021-08-17 20:36:34	2021-08-17 20:36:34	5c3a712b-6fc7-46fa-84f0-0633a52ad89d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
251	193	2	Transient icon	2021-08-17 20:36:34	2021-08-17 20:36:34	600c2c61-487e-435c-9a24-177a092359f4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
252	194	1	Transients Catalog	2021-08-17 20:36:40	2021-08-17 20:36:40	8794bddf-00b1-4184-b700-f21f8484a7ad	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
253	194	2	Transients Catalog	2021-08-17 20:36:41	2021-08-17 20:36:41	365f1e9d-84ca-4031-92fe-654b7144613a	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
254	195	1	Fun goal icon	2021-08-17 20:36:57	2021-08-17 20:36:57	cf227d3e-9703-48a1-8fa8-8561e8e526e5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
255	195	2	Fun goal icon	2021-08-17 20:36:57	2021-08-17 20:36:57	2659fc56-047a-4446-b92e-88148d8c5048	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
256	196	1	Goals Catalog	2021-08-17 20:37:02	2021-08-17 20:37:02	55469441-37b4-458e-8599-6e112d3631bd	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
257	196	2	Goals Catalog	2021-08-17 20:37:03	2021-08-17 20:37:03	b097e59d-90ee-4faa-b91f-76c3880bcd33	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
258	197	1	Landmark icon	2021-08-17 20:37:11	2021-08-17 20:37:11	15e02983-78d5-4837-9cf8-36b3ae2b56db	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
259	197	2	Landmark icon	2021-08-17 20:37:11	2021-08-17 20:37:11	f0fc17df-5860-4800-a839-e1032f121751	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
260	198	1	Landmarks Catalog	2021-08-17 20:37:17	2021-08-17 20:37:17	8555cfb0-4895-4aa2-9f7f-7d5bfcef5c76	https://storage.googleapis.com/hips-data/catalog_landmarks	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
261	198	2	Landmarks Catalog	2021-08-17 20:37:17	2021-08-17 20:37:17	db4a13d8-50a7-48ff-99d2-a1a0f60f8b00	https://storage.googleapis.com/hips-data/catalog_landmarks	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
262	199	1	Astrocat	2021-08-17 20:41:22	2021-08-17 20:41:22	0d03c059-a38f-465a-a4ab-ab94ff46a3f3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
263	199	2	Astrocat	2021-08-17 20:41:22	2021-08-17 20:41:22	3e096ae9-8214-48d9-a713-ec874ab7cfb5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
264	200	1	Check out this tour!	2021-08-17 20:41:25	2021-08-17 20:41:25	cb490bb3-a9d3-4891-8e1d-3a18a14b132c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	5	\N	\N	\N	<h1>Blah blah</h1>	\N	\N	\N	\N
265	200	2	Check out this tour!	2021-08-17 20:41:25	2021-08-17 20:41:25	25b1131e-cedb-4662-9de3-e38d21a489de	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2	5	\N	\N	\N	<h1>Blah blah</h1>	\N	\N	\N	\N
266	201	1	\N	2021-08-17 20:43:58	2021-08-17 20:43:58	32f4840b-6a3b-4f4a-8eaf-ea94b514d19d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
267	201	2	\N	2021-08-17 20:43:58	2021-08-17 20:43:58	55611cf8-5437-41bd-b878-dda94f2c3ddd	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
268	202	1	\N	2021-08-17 21:26:23	2021-08-17 21:26:23	6306b35c-ded9-498f-a18a-91365a87bae5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
269	202	2	\N	2021-08-17 21:26:23	2021-08-17 21:26:23	0a987f39-426e-468f-8f12-bec8b294bba1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
270	203	1	\N	2021-08-20 21:48:32	2021-08-20 21:48:32	b4f8387a-f2a2-462e-bbc6-79c42258d863	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
271	203	2	\N	2021-08-20 21:48:32	2021-08-20 21:48:32	23a2ae01-b277-479c-9291-77f054aa0f9c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
272	204	1	Screen Shot 2021 08 20 at 2 02 37 PM	2021-08-20 21:54:23	2021-08-20 21:54:23	41e23725-e196-4a1d-9351-133a8252f9b1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
273	204	2	Screen Shot 2021 08 20 at 2 02 37 PM	2021-08-20 21:54:23	2021-08-20 21:54:23	ad356abe-c2f8-44fc-aec3-f97ac1ab3cbb	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
130	92	1	Check out this tour!	2021-07-16 18:43:22	2021-10-08 23:04:52	560ddc2d-ba8a-4712-8111-da9577c1ee6a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	234	52	\N	\N	\N	<h1>Blah blah</h1>	\N	\N	\N	\N
232	178	1	Stars	2021-08-17 20:28:31	2021-08-20 21:55:05	bc335686-a476-4245-87e3-174bf94d92f6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
233	178	2	Tester	2021-08-17 20:28:31	2021-08-20 21:55:05	2ec3232f-3773-4be0-ae46-74c74777e8af	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
274	205	1	Planets	2021-08-20 21:55:12	2021-08-20 21:55:12	38b130e8-47f4-4c77-9492-c58970abb2cd	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
275	205	2	Planets	2021-08-20 21:55:12	2021-08-20 21:55:12	d73c8ebb-9193-4eee-a31e-66f4b254d3d4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
276	206	1	Nebulae	2021-08-20 21:55:30	2021-08-20 21:55:30	bc44582b-3ad7-491a-9dfc-5d2c15c8e4d2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
277	206	2	Nebulae	2021-08-20 21:55:30	2021-08-20 21:55:30	f4a6dd7f-b174-4180-ae16-2abb206924f3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
278	207	1	Galaxies	2021-08-20 21:55:41	2021-08-20 21:55:41	9dad7a47-f4d7-41fb-921f-932c565e45af	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
279	207	2	Galaxies	2021-08-20 21:55:41	2021-08-20 21:55:41	ef4997c8-9c14-4576-bbbd-613bffa53102	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
280	208	1	Constellations	2021-08-20 21:55:51	2021-08-20 21:55:51	12116c18-32ac-4ef2-9576-9d097e986472	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
281	208	2	Constellations	2021-08-20 21:55:51	2021-08-20 21:55:51	39033205-0520-4e63-a540-0e5767b391e4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
282	209	1	Check out this tour!	2021-08-20 21:56:12	2021-08-20 21:56:12	11d9cc0a-0883-4d7a-a102-e492579f2f44	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	234	52	\N	\N	\N	<h1>Blah blah</h1>	\N	\N	\N	\N
283	209	2	Check out this tour!	2021-08-20 21:56:12	2021-08-20 21:56:12	684293d5-62f6-4f75-971f-dc42a46cb1a1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	234	52	\N	\N	\N	<h1>Blah blah</h1>	\N	\N	\N	\N
284	210	1	Tour de Force	2021-08-20 21:56:58	2021-08-20 21:56:58	2515b1f4-c769-4069-ad80-1eb8f2c5ecbe	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
285	210	2	Tour de Force	2021-08-20 21:56:58	2021-08-20 21:56:58	b6bd5921-c800-405d-81a0-d33bcf5413a9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
11	8	1	goal	2021-06-15 16:50:17	2021-08-20 22:02:00	b0db8273-971b-44b7-bcfe-f8010f72e714	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	star	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
298	220	1	goal	2021-08-20 22:02:00	2021-08-20 22:02:00	78af07be-8d89-41d3-8936-70d518844a55	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
299	220	2	Stars Catalog	2021-08-20 22:02:00	2021-08-20 22:02:00	fc659a6c-c4a2-433c-afd7-c47ec9a28c60	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
300	221	1	star	2021-08-20 22:02:33	2021-08-20 22:02:33	292463ef-059b-4317-8bda-84d2daaba927	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
301	221	2	Galaxies Catalog	2021-08-20 22:02:33	2021-08-20 22:02:33	67adc503-565f-48bd-99e4-8e764a3521a1	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
302	222	1	galaxy	2021-08-20 22:03:07	2021-08-20 22:03:07	a1c7af09-a839-47f8-8c7f-73745d5c075a	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
303	222	2	Nebulae Catalog	2021-08-20 22:03:07	2021-08-20 22:03:07	b33645df-e3b4-4b22-a6b6-d6de644a1029	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
304	223	1	nebula	2021-08-20 22:03:29	2021-08-20 22:03:29	31b34b6e-435f-41e3-9dd4-c5c43930ac1e	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
305	223	2	Transients Catalog	2021-08-20 22:03:29	2021-08-20 22:03:29	70913e0e-8abb-4ebf-a0df-28664de660ec	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
306	224	1	transient	2021-08-20 22:04:11	2021-08-20 22:04:11	17fc6ea4-94f0-40b4-913d-e6954c3d4046	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
307	224	2	Goals Catalog	2021-08-20 22:04:11	2021-08-20 22:04:11	47e10c8c-29d3-4ba6-b55a-e0a9c62a95e7	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
308	225	1	landmark	2021-08-20 22:04:39	2021-08-20 22:04:39	9df06214-3b4b-466d-9f77-b04a50423377	https://storage.googleapis.com/hips-data/catalog_landmarks	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
309	225	2	Landmarks Catalog	2021-08-20 22:04:39	2021-08-20 22:04:39	0008b8aa-a19b-4c96-b5b5-e4f7b930bc1c	https://storage.googleapis.com/hips-data/catalog_landmarks	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
310	226	1	transient	2021-08-20 22:04:44	2021-08-20 22:04:44	577e7498-19c1-4c8c-989b-d6950bc2bbb0	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
311	226	2	Goals Catalog	2021-08-20 22:04:44	2021-08-20 22:04:44	d1caca5e-b4df-4616-84e7-8b1f5e300cae	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
322	241	1	Whoa	2021-08-30 21:32:31	2021-08-30 21:32:31	def36a8a-f7d7-4ff2-910b-016ff48fd9d0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>Homer Simpson</p>	\N	123	\N	\N
323	241	2	Whoa	2021-08-30 21:32:31	2021-08-30 21:32:31	431c2ba6-b3ad-47dd-8dde-a8ed2bbe9fa5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>Homer Simpson</p>	\N	123	\N	\N
324	243	1	Another fine tour	2021-08-30 21:32:35	2021-08-30 21:32:35	85404f38-c00a-48ed-a14b-71181f4f40fd	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	Did you know...	Yet another fine tour	Hooray!	\N	\N	\N	\N	\N
325	243	2	Another fine tour	2021-08-30 21:32:35	2021-08-30 21:32:35	c248c8a7-b13d-4d1c-9b11-b431d0112e33	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	Did you know...	Yet another fine tour	Hooray!	\N	\N	\N	\N	\N
312	227	1	Another fine tour	2021-08-30 21:31:02	2021-10-08 23:08:16	9def21c9-208c-467d-9a45-38ac07e611f3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	Did you know...	Yet another fine tour	Hooray!	\N	\N	\N	\N	\N
314	228	1	Astrocat	2021-08-30 21:31:25	2021-09-08 17:57:30	756ebd55-48d6-4713-bb47-f4535325725e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
315	228	2	Astrocat	2021-08-30 21:31:25	2021-09-08 17:57:30	db71693f-0103-4973-a16c-ddfbaa5400fd	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
318	239	1	Astrocat	2021-08-30 21:32:28	2021-09-08 17:58:46	42544d2e-9c50-442d-9514-7668bce01a9f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
319	239	2	Astrocat	2021-08-30 21:32:28	2021-09-08 17:58:46	c20e20fc-4a51-4dae-b0a0-66b120f8e08a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
288	215	1	Fun goal icon	2021-08-20 22:01:06	2021-09-14 22:31:24	554fe46a-0824-4502-9721-cf6c82e46953	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
292	217	1	Galaxy icon	2021-08-20 22:01:06	2021-09-23 16:56:52	81f726ab-72f2-4ddf-ab22-d9eb473a0183	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
289	215	2	Fun goal icon	2021-08-20 22:01:06	2021-09-14 22:31:24	cc98ace0-3130-415a-9282-d82596ff1190	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
42	23	2	Nebulae Catalog	2021-06-15 17:34:27	2021-10-08 22:40:48	34f2dfc6-1088-4216-955c-5a94a15edcab	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	nebula	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
286	214	1	Nebula icon	2021-08-20 22:01:06	2021-09-23 16:57:09	7af056fe-285d-4aee-8dec-6896efb0e70a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
316	229	1	Some variety	2021-08-30 21:31:28	2021-10-08 23:04:06	60b5eae9-5231-478a-a5f9-35d415981299	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	some variety	\N
23	14	1	star	2021-06-15 17:17:51	2021-10-08 22:43:20	764b86c2-8492-43d1-a7e0-74aa5cd607fe	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	galaxy	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
294	218	1	Transient icon	2021-08-20 22:01:07	2021-09-23 16:57:25	3447e625-db73-4351-9704-30eb100fd628	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
295	218	2	Transient icon	2021-08-20 22:01:07	2021-09-23 16:57:25	10e2b7d0-ca80-4521-9681-ca92533b634c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
317	229	2	Some variety	2021-08-30 21:31:28	2021-10-08 23:04:06	31eaf482-b114-4f08-89c4-95bfa0bb24ec	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	some variety	\N
293	217	2	Galaxy icon	2021-08-20 22:01:07	2021-09-23 16:56:52	cbeaa040-4096-4988-a567-cdfcbc1c6ff8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
290	216	1	Landmark icon	2021-08-20 22:01:06	2021-09-23 16:57:57	7d1c1ffa-422a-4187-b74b-ae27755ad197	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
291	216	2	Landmark icon	2021-08-20 22:01:06	2021-09-23 16:57:57	0bddd695-03c4-4df2-815f-8edaea20af2b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
287	214	2	Nebula icon	2021-08-20 22:01:06	2021-09-23 16:57:09	d3f4e673-303a-47d8-b116-6b250c3fcac9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
296	219	1	Star icon	2021-08-20 22:01:07	2021-09-23 16:56:31	82be94ea-dc81-4b31-a19d-2ccab58f4a6a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
297	219	2	Star icon	2021-08-20 22:01:07	2021-09-23 16:56:31	cf83cda6-a15c-411f-ad95-d42b3f5f2b79	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
320	240	1	Whoa	2021-08-30 21:32:31	2021-10-08 23:05:09	bede16b1-ff9a-430f-90e1-1f8f23bfb98f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>Homer Simpson</p>	\N	123	\N	\N
321	240	2	Whoa	2021-08-30 21:32:31	2021-10-08 23:05:09	86fac090-2262-4c3a-8df9-00d407eaa21f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>Homer Simpson</p>	\N	123	\N	\N
135	95	2	Tour de Force	2021-07-16 18:43:41	2021-10-08 23:07:33	48921208-0cef-420a-ab13-def302a7343c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
313	227	2	Another fine tour	2021-08-30 21:31:02	2021-10-08 23:08:16	6369b41c-905f-420c-868c-d75841704ad4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	Did you know...	Yet another fine tour	Hooray!	\N	\N	\N	\N	\N
328	251	1	Tour de Forcez	2021-09-08 17:50:58	2021-09-08 17:50:58	8d554772-cf34-44cb-b699-828167f5404a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
329	251	2	Tour de Force	2021-09-08 17:50:58	2021-09-08 17:50:58	7e85aa61-7023-4082-ad07-d8b4245cd2c9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
350	292	1	this is a brand new astro object	2021-09-08 17:58:54	2021-09-08 17:58:54	a9ad8b09-05e4-4aa0-a1c9-d6987a7868fa	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>this is a test</p>	\N	1	\N	\N
351	292	2	this is a brand new astro object	2021-09-08 17:58:54	2021-09-08 17:58:54	9556ad71-6009-45ce-b8bc-1d06bbe824c2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>this is a test</p>	\N	1	\N	\N
344	280	1	Astrocat	2021-09-08 17:57:28	2021-09-08 17:57:28	e3d85b9b-5e5d-4be1-bcad-17d8ad36ed16	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
345	280	2	Astrocat	2021-09-08 17:57:28	2021-09-08 17:57:28	504f6c25-5d04-48cc-a293-aabad367d094	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
358	309	1	This is a cloud astro object	2021-09-08 18:26:41	2021-09-08 18:26:41	216e3226-e232-40ac-bc33-3d83b82f43ba	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>gnarwhal</p>	\N	1	\N	\N
332	259	1	The Search for Alienz	2021-09-08 17:54:32	2021-09-08 17:54:32	2655b791-1f66-45f6-a2ae-a22432fdf9d8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	How about this fun fact!	Some heading	another subheading	\N	\N	\N	\N	\N
333	259	2	The Search for Aliens	2021-09-08 17:54:32	2021-09-08 17:54:32	25e7472b-e79e-4d97-a768-18bf585e2358	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
359	309	2	This is a cloud astro object	2021-09-08 18:26:41	2021-09-08 18:26:41	f0806d75-eb47-4b99-9b7b-6b4fae880b9b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>gnarwhal</p>	\N	1	\N	\N
342	279	1	This is a brand new tour	2021-09-08 17:55:33	2021-09-08 17:58:58	b5eab863-a73d-4f3b-8c46-897c59f34839	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	ttt	Temp temp	Just a test!	\N	\N	\N	\N	\N
336	267	1	Another fine tour	2021-09-08 17:54:51	2021-09-08 17:54:51	0d1af28b-5777-4f38-9cd9-94eac51666c4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	Did you know...	Yet another fine tour	Hooray!	\N	\N	\N	\N	\N
337	267	2	Another fine tour	2021-09-08 17:54:52	2021-09-08 17:54:52	c5ccbd28-047a-4225-b7ab-7a02c754122a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	Did you know...	Yet another fine tour	Hooray!	\N	\N	\N	\N	\N
343	279	2	This is a brand new tour	2021-09-08 17:55:33	2021-09-08 17:58:58	1f60c1e7-651e-4171-ac66-6c049223d509	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	ttt	Temp temp	Just a test!	\N	\N	\N	\N	\N
352	294	1	This is a brand new tour	2021-09-08 17:58:58	2021-09-08 17:58:58	43d78392-7e37-4680-a9f2-ff0d34cc8de9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	ttt	Temp temp	Just a test!	\N	\N	\N	\N	\N
353	294	2	This is a brand new tour	2021-09-08 17:58:58	2021-09-08 17:58:58	77cae4bf-c508-4e76-9100-c033ce76a905	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	ttt	Temp temp	Just a test!	\N	\N	\N	\N	\N
372	320	1	Fun goal icon	2021-09-14 22:31:22	2021-09-14 22:31:22	8313db01-e5bf-4ab3-9e08-d461546f9a7d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
373	320	2	Fun goal icon	2021-09-14 22:31:22	2021-09-14 22:31:22	6fe85ebf-5fdd-48df-93b4-359766a350ef	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
340	275	1	Another fine tour	2021-09-08 17:55:09	2021-09-08 17:55:09	d497ce8d-dd1d-4e19-ba02-083b02843df5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	Did you know...	Yet another fine tour	Hooray!	\N	\N	\N	\N	\N
341	275	2	Another fine tour	2021-09-08 17:55:09	2021-09-08 17:55:09	f1dea3c3-9da8-414b-9f73-672b39368bce	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	Did you know...	Yet another fine tour	Hooray!	\N	\N	\N	\N	\N
374	321	1	Galaxy icon	2021-09-14 22:31:28	2021-09-14 22:31:28	b910b305-7bc0-429c-a178-6e729af34eb7	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
364	316	1	star	2021-09-14 22:23:01	2021-09-14 22:23:01	c366bba9-2344-4623-8d6e-09dd393b40a0	https://storage.googleapis.com/hips-data/catalog_stars/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
356	308	1	This is a cloud astro object	2021-09-08 18:26:41	2021-10-22 19:53:59	1e45aae7-0384-496f-b48a-5ddf70d1bc8e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>Stuff and things</p>	\N	1	\N	\N
357	308	2	This is a cloud astro object	2021-09-08 18:26:41	2021-10-22 19:54:02	1cc4cd81-961b-4ad5-85f5-b312ab91b54f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>Stuff and things</p>	\N	1	\N	\N
360	311	1	A tour of the cloud!	2021-09-08 18:26:58	2021-09-08 18:26:58	652cc975-2048-47b8-a270-03d4d19d8629	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	A cloud fact!	Cloud heading	Cloud subheading	\N	\N	\N	\N	\N
361	311	2	A tour of the cloud!	2021-09-08 18:26:58	2021-09-08 18:26:58	234806eb-d51e-4d9f-b2cf-edf66eed975f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	A cloud fact!	Cloud heading	Cloud subheading	\N	\N	\N	\N	\N
368	318	1	star	2021-09-14 22:23:30	2021-09-14 22:23:30	dd7cdf85-cf25-44c8-891b-a49eb76919d9	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
365	316	2	Galaxies Catalog	2021-09-14 22:23:01	2021-09-14 22:23:01	a2f5e338-8c57-4974-8042-d3da6006de12	https://storage.googleapis.com/hips-data/catalog_stars/	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
346	290	1	Astrocat	2021-09-08 17:58:44	2021-09-08 17:58:44	8edee3db-1cdf-4493-966a-e14f7794b32b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
347	290	2	Astrocat	2021-09-08 17:58:44	2021-09-08 17:58:44	13ece681-c2c8-4d2b-aeb2-ad857b15cef0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
369	318	2	Galaxies Catalog	2021-09-14 22:23:30	2021-09-14 22:23:30	a2ead165-ccc8-4d8f-a4d3-93e8ce6a53d1	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
375	321	2	Galaxy icon	2021-09-14 22:31:28	2021-09-14 22:31:28	05f977c5-3a5f-47f1-bebc-c00f2122dec9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
376	322	1	Landmark icon	2021-09-14 22:31:34	2021-09-14 22:31:34	c0347273-e85a-4df7-8c3a-c3e77a3b7a9c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
377	322	2	Landmark icon	2021-09-14 22:31:34	2021-09-14 22:31:34	6b767804-bd5c-4f53-8dbc-f27a23979c49	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
378	323	1	Nebula icon	2021-09-14 22:31:40	2021-09-14 22:31:40	940f6075-0fe7-43b1-96e1-8201908ea2fd	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
348	291	1	this is a brand new astro object	2021-09-08 17:58:53	2021-10-08 23:05:41	3aa64512-06aa-47f8-85fb-d90eb9801d72	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>this is a test</p>	\N	1	\N	\N
349	291	2	this is a brand new astro object	2021-09-08 17:58:54	2021-10-08 23:05:41	e3355454-533c-4688-8035-318b29dc139d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>this is a test</p>	\N	1	\N	\N
379	323	2	Nebula icon	2021-09-14 22:31:40	2021-09-14 22:31:40	3f8c8675-b9ca-4082-ae7f-7ed7eccd88c3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
380	324	1	Star icon	2021-09-14 22:31:47	2021-09-14 22:31:47	b7e23ca8-01e3-424a-8c67-473237bb9c9a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
381	324	2	Star icon	2021-09-14 22:31:47	2021-09-14 22:31:47	3c405ad2-a725-4890-89aa-3da4a5b77a76	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
382	325	1	Transient icon	2021-09-14 22:31:52	2021-09-14 22:31:52	725a1516-2c4d-4f29-89f0-c48583508d3c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
383	325	2	Transient icon	2021-09-14 22:31:52	2021-09-14 22:31:52	55f65c38-bbb9-4189-a53c-c0af40537dde	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
354	298	1	A tour of the cloud!	2021-09-08 18:23:49	2021-10-08 23:08:48	523218a3-8fb4-49e9-90dc-d22eb912659c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	A cloud fact!	Cloud heading	Cloud subheading	\N	\N	\N	\N	\N
384	326	1	galaxy	2021-09-14 22:32:05	2021-09-14 22:32:05	dc6911ec-f534-4c43-8186-8782d98a90e9	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
355	298	2	A tour of the cloud!	2021-09-08 18:23:50	2021-10-08 23:08:48	38d861a8-4ea3-44dd-a116-480efc604fd4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	A cloud fact!	Cloud heading	Cloud subheading	\N	\N	\N	\N	\N
385	326	2	Nebulae Catalog	2021-09-14 22:32:05	2021-09-14 22:32:05	8715c591-f67c-4024-b4bf-e07aa8b0d323	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
432	350	1	Landmark icon	2021-09-23 16:57:55	2021-09-23 16:57:55	73426faa-dcf5-4291-869c-43fb42117195	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
433	350	2	Landmark icon	2021-09-23 16:57:55	2021-09-23 16:57:55	c5fcdf74-13ed-4ffd-bb3e-0e12dd50211a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
420	344	1	Nebula icon	2021-09-23 16:57:07	2021-09-23 16:57:07	a1862c62-d252-4a4e-9231-6bddd1c71d4f	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
421	344	2	Nebula icon	2021-09-23 16:57:07	2021-09-23 16:57:07	75a0fe7d-bf98-446e-9e40-c6d0610cb26b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
396	332	1	Control HEALPix Catalog	2021-09-16 20:36:42	2021-09-16 20:36:42	c54e7120-5904-45b7-a637-4f871f69862d	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	107.0208333333 -2.7800000000	40	10	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
397	332	2	Control HEALPix Catalog	2021-09-16 20:36:42	2021-09-16 20:36:42	158c0449-554b-419f-a82e-9c9f24ce2120	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	107.0208333333 -2.7800000000	40	10	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
435	351	2	Landmarks Catalog	2021-09-23 16:58:01	2021-09-23 16:58:01	002c7700-ce23-4e0d-83e6-7969326dd885	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
410	339	1	star	2021-09-23 16:56:37	2021-09-23 16:56:37	deb2fdac-4a59-4c71-9e40-cd27e21dffe4	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
411	339	2	Galaxies Catalog	2021-09-23 16:56:37	2021-09-23 16:56:37	d53c96a3-de5f-44ab-b79b-173412954895	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
388	328	1	Control HEALPix Catalog	2021-09-14 22:43:07	2021-09-14 22:43:07	7b0c3502-5e42-45b0-8be3-a11aa496b3ef	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	107.0208333333 -2.7800000000	40	23	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
389	328	2	Control HEALPix Catalog	2021-09-14 22:43:07	2021-09-14 22:43:07	ce1f2c9a-08e0-41b6-8c31-68b400ffec16	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	107.0208333333 -2.7800000000	40	23	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
440	354	1	star	2021-09-28 23:40:53	2021-09-28 23:40:53	69cd4f06-0902-43f3-9a1d-bed0f01cc770	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
441	354	2	Galaxies Catalog	2021-09-28 23:40:57	2021-09-28 23:40:57	963de809-2d5b-4ab2-8b32-1fa8144867aa	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
414	341	1	Galaxy icon	2021-09-23 16:56:49	2021-09-23 16:56:49	9f4c1d2a-9cff-4835-8551-e2e87054fdf9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
400	334	1	Control HEALPix Catalog	2021-09-16 20:37:21	2021-09-16 20:37:21	0309bd53-593e-4658-ae1d-458fc2a76766	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	107.0208333333 -2.7800000000	40	1	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
401	334	2	Control HEALPix Catalog	2021-09-16 20:37:21	2021-09-16 20:37:21	4055083f-6f1b-4cff-87d8-af0f0df86d08	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	107.0208333333 -2.7800000000	40	1	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
392	330	1	Control HEALPix Catalog	2021-09-16 20:36:16	2021-09-16 20:36:16	3323124f-30c1-445c-b228-da37a07cabcd	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	107.0208333333 -2.7800000000	100	23	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
393	330	2	Control HEALPix Catalog	2021-09-16 20:36:17	2021-09-16 20:36:17	86a4abac-c4a8-4073-b2c7-f0d50af7601c	http://alasky.u-strasbg.fr/DSS/DSSColor	\N	\N	\N	\N	107.0208333333 -2.7800000000	100	23	100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
402	335	1	landmark	2021-09-16 23:29:40	2021-09-16 23:29:40	168456a2-960e-4072-90ed-eabafbd0992d	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
403	335	2	Landmarks Catalog	2021-09-16 23:29:40	2021-09-16 23:29:40	f14c279d-f972-40a4-8631-9c1abbf1dee8	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
415	341	2	Galaxy icon	2021-09-23 16:56:49	2021-09-23 16:56:49	02778de8-55c0-42f9-bf0b-d75237164444	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
428	348	1	transient	2021-09-23 16:57:44	2021-09-23 16:57:44	7d28cfe8-e421-4b0b-880d-52ed284ebf08	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
404	336	1	landmark	2021-09-16 23:29:43	2021-09-16 23:29:43	307345da-6c65-4bef-82a8-27666379728e	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
405	336	2	Landmarks Catalog	2021-09-16 23:29:43	2021-09-16 23:29:43	a3958ba1-df7a-47a7-b917-059a6e88befe	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
429	348	2	Goals Catalog	2021-09-23 16:57:44	2021-09-23 16:57:44	36028291-db51-481a-ac58-de5983a94b50	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
408	338	1	Star icon	2021-09-23 16:56:29	2021-09-23 16:56:29	363620d8-0d08-4d99-8230-6578b45e2b1e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
409	338	2	Star icon	2021-09-23 16:56:29	2021-09-23 16:56:29	8e2ee74d-9430-4242-9a0c-f15eba341c8e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
422	345	1	nebula	2021-09-23 16:57:13	2021-09-23 16:57:13	a077c867-b53c-4042-9aca-1b01de92b807	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
423	345	2	Transients Catalog	2021-09-23 16:57:13	2021-09-23 16:57:13	410cea94-f4a8-42f3-9125-56b5256cb7bd	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
416	342	1	galaxy	2021-09-23 16:56:55	2021-09-23 16:56:55	04b9aa73-a35f-4f95-b3b1-23d5f189cd75	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
417	342	2	Nebulae Catalog	2021-09-23 16:56:55	2021-09-23 16:56:55	a3e04f3f-5f88-4e1f-b6b6-0b56d9b1de1c	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
426	347	1	Transient icon	2021-09-23 16:57:23	2021-09-23 16:57:23	d956a425-6d59-4a5f-b5f4-6ca230869233	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
427	347	2	Transient icon	2021-09-23 16:57:23	2021-09-23 16:57:23	67412c2d-cc39-4648-8636-4cc6e4bdca6d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
444	356	1	Galaxy icon	2021-09-28 23:42:12	2021-09-28 23:42:12	9fbe12bb-1b9b-49e1-991a-90a53a7e62cb	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
434	351	1	landmark	2021-09-23 16:58:01	2021-09-23 16:58:01	5256ad41-2744-4e93-beb8-6b5349f23d6b	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
438	353	1	Star icon	2021-09-28 23:40:01	2021-09-28 23:40:01	ccc7aba3-d189-4fea-8e1b-4734d4eefd56	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
439	353	2	Star icon	2021-09-28 23:40:03	2021-09-28 23:40:03	5c2206ff-150e-4ce3-bf78-1887fbff6c41	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
445	356	2	Galaxy icon	2021-09-28 23:42:14	2021-09-28 23:42:14	b115d31d-d4c4-4d4b-becf-8aa032b3469d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
446	357	1	galaxy	2021-09-28 23:43:32	2021-09-28 23:43:32	2d78b960-77cc-43dc-a73c-4f339f38ab66	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
450	359	1	Nebula icon	2021-09-28 23:45:34	2021-09-28 23:45:34	8151bddf-a289-4c90-bd6a-58e94c4468c0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
447	357	2	Nebulae Catalog	2021-09-28 23:43:36	2021-09-28 23:43:36	023f94d4-44cd-4a77-943e-06676eeac369	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
451	359	2	Nebula icon	2021-09-28 23:45:36	2021-09-28 23:45:36	3a5bf9a7-d1b3-4c63-80cb-2b0c6a5bcbf6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
452	360	1	nebula	2021-09-28 23:46:31	2021-09-28 23:46:31	b8b187ce-7696-48d5-8c67-40c595ee45cc	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
453	360	2	Transients Catalog	2021-09-28 23:46:35	2021-09-28 23:46:35	454aea66-9f6b-44c9-bbd0-91f08b5be3b7	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
456	362	1	Transient icon	2021-09-28 23:48:41	2021-09-28 23:48:41	5caa6c3b-4c3b-4857-a24c-743842b1b704	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
457	362	2	Transient icon	2021-09-28 23:48:43	2021-09-28 23:48:43	c43830a5-039a-49e7-b0b5-ada3c8afb3d4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
500	384	1	Galaxy icon	2021-10-08 22:40:37	2021-10-08 22:40:37	0358ebe3-f005-4ffb-b81d-4f8954a452aa	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
501	384	2	Galaxy icon	2021-10-08 22:40:38	2021-10-08 22:40:38	811acfb0-fe83-4a71-a9fc-f5ad590f58b3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
496	382	1	Star icon	2021-10-08 22:40:04	2021-10-08 22:40:04	d731308f-2414-41cb-a37a-91aa27226c8d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
497	382	2	Star icon	2021-10-08 22:40:04	2021-10-08 22:40:04	304db567-5a1a-47ab-99ff-08c4096c89f3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
480	374	1	test cat	2021-10-01 20:05:41	2021-10-01 20:06:06	3e1e2815-98b0-4c64-bfe9-9541f950a381	http://test/path	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
481	374	2	test cat	2021-10-01 20:05:41	2021-10-01 20:06:06	baf1e967-1542-4a50-ab4d-c6c2fa142d12	http://test/path	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
482	375	1	test cat	2021-10-01 20:06:06	2021-10-01 20:06:06	50e5a8bb-c6a6-425b-8484-9cee16f31812	http://test/path	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
458	363	1	transient	2021-09-28 23:49:47	2021-09-28 23:49:47	cbf79fa0-f872-4b71-9620-a95be6f0b307	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
459	363	2	Goals Catalog	2021-09-28 23:49:51	2021-09-28 23:49:51	19b9704b-0d57-40f4-a160-d5373953ffa7	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
483	375	2	test cat	2021-10-01 20:06:06	2021-10-01 20:06:06	bad4df5d-7904-4f37-b8b3-9f25d633ebc4	http://test/path	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
484	376	1	Star icon	2021-10-01 20:33:17	2021-10-01 20:33:17	17776c6a-759a-4092-ab9f-28919f9d5b10	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
462	365	1	Landmark icon	2021-09-28 23:52:00	2021-09-28 23:52:00	bde1e094-900f-4bcd-8d4d-d47b7213117d	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
463	365	2	Landmark icon	2021-09-28 23:52:01	2021-09-28 23:52:01	5c771f58-b384-4cde-9944-df6f42287581	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
485	376	2	Star icon	2021-10-01 20:33:18	2021-10-01 20:33:18	a4626b1c-bd41-44fa-b6f1-09af06c63518	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
472	370	1	Star icon	2021-09-29 19:39:49	2021-10-08 22:40:08	348e5a10-ac39-4197-a16d-74217adb5d58	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
473	370	2	Star icon	2021-09-29 19:39:50	2021-10-08 22:40:08	a84a679a-b5e9-4164-85a6-7684d52fd7fd	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
478	373	1	Galaxy icon	2021-09-29 19:40:13	2021-10-08 22:40:42	cf39b891-e34a-4b4f-a78c-9befca9529b0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
479	373	2	Galaxy icon	2021-09-29 19:40:15	2021-10-08 22:40:42	affc08e4-886f-4617-bdf2-320a76df5507	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
464	366	1	landmark	2021-09-28 23:52:57	2021-09-28 23:52:57	7b4d8072-8188-44ec-a33c-925f0e6f3bf3	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
465	366	2	Landmarks Catalog	2021-09-28 23:53:01	2021-09-28 23:53:01	228d2d23-c64d-4a0f-bf4c-448700689d15	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
466	367	1	\N	2021-09-29 00:03:17	2021-09-29 00:03:17	8ae5906c-4268-4198-8ddb-1e28f6b9f364	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
467	367	2	\N	2021-09-29 00:03:22	2021-09-29 00:03:22	19ca0701-b6f7-4ef6-b310-905b631045b9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
468	368	1	Fun goal icon	2021-09-29 19:39:31	2021-09-29 19:39:31	4fbbf520-b641-477d-a4e0-e98b51e9d3fd	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
469	368	2	Fun goal icon	2021-09-29 19:39:33	2021-09-29 19:39:33	778089dd-85a5-4f3a-82d5-0a7da0056047	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
471	369	2	Nebula icon	2021-09-29 19:39:42	2021-10-08 22:42:31	75f0cd2f-0851-40d5-bdef-d90b15019ee8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
488	378	1	star	2021-10-01 20:33:23	2021-10-01 20:33:23	1e32ce57-1ec9-44dd-906b-41339c7f5792	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
489	378	2	Galaxies Catalog	2021-10-01 20:33:23	2021-10-01 20:33:23	5ef7fb87-4f18-4746-a1af-e31caf03df90	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
490	379	1	\N	2021-10-04 22:28:14	2021-10-04 22:28:14	0e4982fe-adf4-4687-b81c-c250c4d09930	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
491	379	2	\N	2021-10-04 22:28:15	2021-10-04 22:28:15	36dfae93-55b7-46f6-8eee-5dcf3f130afb	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
492	380	1	Ourneighborhood	2021-10-08 00:35:09	2021-10-08 00:35:09	108e5e9d-5a59-46c1-a47c-e01954c247d2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
493	380	2	Ourneighborhood	2021-10-08 00:35:10	2021-10-08 00:35:10	6e48809c-418e-4851-8b68-c9466cf77601	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
511	389	2	Transients Catalog	2021-10-08 22:42:36	2021-10-08 22:42:36	097d0a1e-f863-4e32-a4ec-c62196395e38	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
504	386	1	galaxy	2021-10-08 22:40:48	2021-10-08 22:40:48	088a0b7d-7d24-4f16-ad49-f287b08b6128	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
498	383	1	star	2021-10-08 22:40:17	2021-10-08 22:40:17	99dd170c-7344-481c-bb0a-d4eb6660fcb1	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
499	383	2	Galaxies Catalog	2021-10-08 22:40:17	2021-10-08 22:40:17	4f85231b-86e1-4e9a-91b8-0eff17a45afa	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
512	390	1	Transient icon	2021-10-08 22:42:47	2021-10-08 22:42:47	800b0a53-febd-49c7-aae4-a9ba4e813f2c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
513	390	2	Transient icon	2021-10-08 22:42:48	2021-10-08 22:42:48	2165c694-7931-4d19-bad4-202b6ff60656	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
476	372	1	Transient icon	2021-09-29 19:40:05	2021-10-08 22:42:50	5150f4ee-af8f-4c52-9f87-25ceaea9927b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
505	386	2	Nebulae Catalog	2021-10-08 22:40:48	2021-10-08 22:40:48	749a3001-2cd5-43e7-bdf7-30d22a77a88a	https://storage.googleapis.com/hips-data/catalog_galaxies	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
506	387	1	Nebula icon	2021-10-08 22:42:27	2021-10-08 22:42:27	f129f67b-ec02-4353-ad12-226c8b47cef5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
507	387	2	Nebula icon	2021-10-08 22:42:27	2021-10-08 22:42:27	88983bc3-b495-48cd-8d05-eabca1504147	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
470	369	1	Nebula icon	2021-09-29 19:39:40	2021-10-08 22:42:31	5273c53c-b717-4013-a601-95bdb89610f6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
477	372	2	Transient icon	2021-09-29 19:40:07	2021-10-08 22:42:50	45016967-0814-4a2e-b3e4-ae0c931fcb11	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
510	389	1	nebula	2021-10-08 22:42:36	2021-10-08 22:42:36	c854a879-38dc-4334-b5ce-5449b1c44b2e	https://storage.googleapis.com/hips-data/catalog_nebulae	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
518	393	1	Landmark icon	2021-10-08 22:43:09	2021-10-08 22:43:09	1d0bd8ee-6a8a-46f1-ac13-95d0bc359d0b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
519	393	2	Landmark icon	2021-10-08 22:43:09	2021-10-08 22:43:09	de1de7a5-c10d-4f7b-ae18-6c7ede5af431	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
516	392	1	transient	2021-10-08 22:42:55	2021-10-08 22:42:55	a73e57a4-9306-461b-bd69-4da8adebd616	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
517	392	2	Goals Catalog	2021-10-08 22:42:55	2021-10-08 22:42:55	e60947e5-f9d1-4d40-9d15-6c9408cbe706	https://storage.googleapis.com/hips-data/catalog_transients	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
474	371	1	Landmark icon	2021-09-29 19:39:57	2021-10-08 22:43:12	c32abe35-2b23-4c48-a990-5d4d286d1b7c	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
475	371	2	Landmark icon	2021-09-29 19:39:59	2021-10-08 22:43:12	4373b52a-d49a-46ca-bb10-3f6e8e03fa12	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
542	405	1	this is a brand new astro object	2021-10-08 23:05:41	2021-10-08 23:05:41	81e29cea-ebad-4c7f-aabd-9ac665db6ee7	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>this is a test</p>	\N	1	\N	\N
543	405	2	this is a brand new astro object	2021-10-08 23:05:42	2021-10-08 23:05:42	eaf75972-ebe7-4757-8e02-8979718f27c5	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>this is a test</p>	\N	1	\N	\N
550	412	1	The Search for Alienz	2021-10-08 23:06:43	2021-10-08 23:06:43	51268c9b-cda2-4bfe-880e-5dc34b462c1a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	How about this fun fact!	Some heading	another subheading	\N	\N	\N	\N	\N
524	396	1	landmark	2021-10-08 22:43:16	2021-10-08 22:43:16	13baed0d-eb6e-4b99-ac20-304d93927180	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
525	396	2	Landmarks Catalog	2021-10-08 22:43:16	2021-10-08 22:43:16	54f1d13c-3bde-4894-b85f-256cfbeee6ff	https://storage.googleapis.com/hips-data/catalog_goals	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
526	397	1	star	2021-10-08 22:43:20	2021-10-08 22:43:20	e4f93f7c-9285-452a-a6d8-e830285ec44a	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
527	397	2	Galaxies Catalog	2021-10-08 22:43:20	2021-10-08 22:43:20	05a91148-f6b3-4977-a047-9809958ede35	https://storage.googleapis.com/hips-data/catalog_stars	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
230	177	1	Test	2021-08-17 20:28:22	2021-10-08 23:03:23	84c6359b-c10c-4fbd-88ae-d5902a798812	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	tours	\N
231	177	2	Test	2021-08-17 20:28:22	2021-10-08 23:03:23	ab0a371b-0de9-43a2-b76a-60c140e10322	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	tours	\N
528	398	1	Screen Shot 2021 10 07 at 10 57 36 AM	2021-10-08 23:03:44	2021-10-08 23:03:44	05970a16-126a-4fea-afdf-bd898bca54cc	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
529	398	2	Screen Shot 2021 10 07 at 10 57 36 AM	2021-10-08 23:03:47	2021-10-08 23:03:47	05f49d8d-6774-4517-839e-afe3adeb8603	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
530	399	1	Screen Shot 2021 10 07 at 9 53 18 AM	2021-10-08 23:04:45	2021-10-08 23:04:45	b0f15dd3-cca6-4e0d-8b52-04dc048467c6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
531	399	2	Screen Shot 2021 10 07 at 9 53 18 AM	2021-10-08 23:04:46	2021-10-08 23:04:46	3d2d9d90-016f-42ac-9a85-e4fcd3f1b424	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
551	412	2	The Search for Aliens	2021-10-08 23:06:43	2021-10-08 23:06:43	28b00d90-9622-4f26-b90e-5fc3541e82da	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
131	92	2	Check out this tour!	2021-07-16 18:43:23	2021-10-08 23:04:52	96697ed4-7c78-45e4-a845-9a7ff5b6bf0e	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	234	52	\N	\N	\N	<h1>Blah blah</h1>	\N	\N	\N	\N
534	401	1	Check out this tour!	2021-10-08 23:04:53	2021-10-08 23:04:53	af959590-4d04-4c47-a31b-5a1043476dd8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	234	52	\N	\N	\N	<h1>Blah blah</h1>	\N	\N	\N	\N
535	401	2	Check out this tour!	2021-10-08 23:04:53	2021-10-08 23:04:53	46afcbe7-9faa-4ab6-9e5b-034bd6897348	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	234	52	\N	\N	\N	<h1>Blah blah</h1>	\N	\N	\N	\N
569	442	2	This is a cloud astro object	2021-10-22 19:54:11	2021-10-22 19:54:11	4f6d5a84-aca1-416c-a2fc-0ba324e811e6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>Stuff and things</p>	\N	1	\N	\N
570	443	1	Cutout	2021-10-22 22:20:36	2021-10-22 22:20:36	568e979e-73c8-4a18-a588-a1dbf0921572	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
546	407	1	This is a cloud astro object	2021-10-08 23:05:58	2021-10-08 23:05:58	af5013cf-4e60-4b1f-bdb0-490695c8207b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>gnarwhal</p>	\N	1	\N	\N
547	407	2	This is a cloud astro object	2021-10-08 23:05:58	2021-10-08 23:05:58	cf210472-bb8e-4eed-86de-b5a198870a7a	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>gnarwhal</p>	\N	1	\N	\N
538	403	1	Whoa	2021-10-08 23:05:09	2021-10-08 23:05:09	3e816fd1-c5ae-41dd-8b38-6ac908a343d7	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>Homer Simpson</p>	\N	123	\N	\N
539	403	2	Whoa	2021-10-08 23:05:09	2021-10-08 23:05:09	1aa5cf14-447b-46b9-895b-6a0c6a904708	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>Homer Simpson</p>	\N	123	\N	\N
571	443	2	Cutout	2021-10-22 22:20:37	2021-10-22 22:20:37	2e583c59-bf86-46fd-97f8-ec57473a5864	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
572	444	1	Sasquatch	2021-10-25 21:50:50	2021-10-25 21:50:50	ae05010a-35a6-4132-aee3-783a5c0e007b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
573	444	2	Sasquatch	2021-10-25 21:50:51	2021-10-25 21:50:51	a51bf1d9-9b26-4ef2-88ae-db8de94e927b	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
574	445	1	Eric rosas	2021-10-26 17:15:00	2021-10-26 17:15:00	0e5011e7-b224-4fce-a38d-6dba821aa252	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
564	437	1	A tour of the cloud!	2021-10-08 23:08:49	2021-10-08 23:08:49	fae66d22-329c-4ccb-a680-fa2a9018a4dc	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	A cloud fact!	Cloud heading	Cloud subheading	\N	\N	\N	\N	\N
565	437	2	A tour of the cloud!	2021-10-08 23:08:49	2021-10-08 23:08:49	d841e60d-a810-444c-aaba-522b534227d2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	A cloud fact!	Cloud heading	Cloud subheading	\N	\N	\N	\N	\N
554	420	1	Tour de Forcez	2021-10-08 23:07:34	2021-10-08 23:07:34	3d08d918-7793-4b92-8f7a-ff8fe71b96ab	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
555	420	2	Tour de Force	2021-10-08 23:07:34	2021-10-08 23:07:34	00b9fedb-ac70-42f3-a2ea-ca8b31498b38	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	3	\N	\N	\N	Did you know tours are tours?	First you tour de force	Then you tour de nap	\N	\N	\N	\N	\N
556	424	1	Screen Shot 2021 10 07 at 10 58 24 AM	2021-10-08 23:07:57	2021-10-08 23:07:57	bf925374-f546-4772-8d52-1eeb517dc621	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
560	429	1	Another fine tour	2021-10-08 23:08:17	2021-10-08 23:08:17	86e67605-224e-482e-b1a5-f76a8e1b05ab	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	Did you know...	Yet another fine tour	Hooray!	\N	\N	\N	\N	\N
561	429	2	Another fine tour	2021-10-08 23:08:17	2021-10-08 23:08:17	1d204606-05ce-4657-8827-fd6cfb4eecf2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	5	1	\N	\N	\N	Did you know...	Yet another fine tour	Hooray!	\N	\N	\N	\N	\N
557	424	2	Screen Shot 2021 10 07 at 10 58 24 AM	2021-10-08 23:07:59	2021-10-08 23:07:59	d56a3976-4ec7-4f2a-b4b7-f449c784e977	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
575	445	2	Eric rosas	2021-10-26 17:15:00	2021-10-26 17:15:00	90123d71-8266-4640-9051-b5cdfd7acf06	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
568	442	1	This is a cloud astro object	2021-10-22 19:54:06	2021-10-22 19:54:06	ade1c204-f7ff-46a2-8393-3528291fd7e8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	2	\N	\N	\N	<p>Stuff and things</p>	\N	1	\N	\N
\.


--
-- TOC entry 4578 (class 0 OID 16528)
-- Dependencies: 216
-- Data for Name: craftidtokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.craftidtokens (id, "userId", "accessToken", "expiryDate", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4580 (class 0 OID 16537)
-- Dependencies: 218
-- Data for Name: deprecationerrors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.deprecationerrors (id, key, fingerprint, "lastOccurrence", file, line, message, traces, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4582 (class 0 OID 16546)
-- Dependencies: 220
-- Data for Name: drafts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.drafts (id, "sourceId", "creatorId", name, notes, "trackChanges", "dateLastMerged", saved, provisional) FROM stdin;
1	\N	1	First draft	\N	f	\N	f	f
2	\N	1	First draft	\N	f	\N	f	f
3	\N	1	First draft		f	\N	t	f
5	\N	1	First draft	\N	f	\N	f	f
6	\N	1	First draft	\N	f	\N	f	f
14	\N	1	First draft	\N	f	\N	f	f
16	\N	1	First draft	\N	f	\N	f	f
19	\N	1	First draft	\N	f	\N	f	f
23	\N	1	First draft	\N	f	\N	f	f
24	\N	1	First draft	\N	f	\N	f	f
25	\N	1	First draft	\N	f	\N	f	f
50	\N	1	First draft	\N	f	\N	f	f
53	\N	1	First draft	\N	f	\N	f	f
\.


--
-- TOC entry 4584 (class 0 OID 16556)
-- Dependencies: 222
-- Data for Name: elementindexsettings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.elementindexsettings (id, type, settings, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4586 (class 0 OID 16565)
-- Dependencies: 224
-- Data for Name: elements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.elements (id, "draftId", "revisionId", "fieldLayoutId", type, enabled, archived, "dateCreated", "dateUpdated", "dateDeleted", uid, "canonicalId", "dateLastMerged") FROM stdin;
1	\N	\N	\N	craft\\elements\\User	t	f	2021-05-19 21:09:33	2021-05-19 21:09:33	\N	3637eed8-8250-4e7f-ba18-54292db1b85f	\N	\N
6	\N	\N	3	craft\\elements\\GlobalSet	t	f	2021-06-15 15:02:03	2021-08-30 21:29:11	\N	ea689411-d03e-48f0-8841-3318c457eee1	\N	\N
399	\N	\N	22	craft\\elements\\Asset	t	f	2021-10-08 23:04:45	2021-10-08 23:04:45	\N	5d002b0b-564f-40cb-bc3c-7deb8d6f9bf9	\N	\N
69	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-22 21:51:07	2021-10-08 23:06:43	\N	f6b0dfa3-ac60-4438-ac47-c4a01febce30	\N	\N
227	\N	\N	6	craft\\elements\\Entry	t	f	2021-08-30 21:31:02	2021-10-08 23:08:16	\N	2dfbf505-2142-4813-ae84-a22a2bdc608b	\N	\N
298	\N	\N	6	craft\\elements\\Entry	t	f	2021-09-08 18:23:49	2021-10-08 23:08:48	\N	52d3293d-d712-4ebe-a100-fbf2a0736335	\N	\N
55	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-21 23:04:33	2021-06-21 23:04:33	\N	2db9d3fa-de23-455c-ac45-2706224a4b2b	\N	\N
56	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-21 23:04:33	2021-06-21 23:04:33	\N	9af996e2-f95b-48b9-a3ce-91965101eb98	\N	\N
251	\N	77	6	craft\\elements\\Entry	t	f	2021-09-08 17:50:58	2021-09-08 17:50:58	\N	5e8f821f-0faa-413e-b323-dfb9dc10f060	95	\N
252	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:50:58	2021-09-08 17:50:58	\N	52b9b2a9-5b7f-4969-b33b-3981cc2bc6b7	96	\N
253	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:50:58	2021-09-08 17:50:58	\N	f51076f6-7036-4a8b-83ed-d1d9d3a05167	97	\N
254	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:50:58	2021-09-08 17:50:58	\N	2229901e-b3a8-497e-8fad-6e310179cd03	98	\N
233	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:31:58	2021-08-30 21:31:58	2021-08-30 21:32:01	ec4f718f-4c7c-47c6-8f71-9dd023fbddd6	\N	\N
283	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:57:50	2021-09-08 17:57:50	2021-09-08 17:57:52	748f288e-3b8e-4db4-859c-9145d4cdac4f	\N	\N
38	\N	\N	2	craft\\elements\\Entry	t	f	2021-06-15 18:07:52	2021-06-15 18:07:52	2021-06-15 22:09:00	499ffc66-a73b-43f2-b3f5-642cd9273309	\N	\N
289	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:58:18	2021-09-08 17:58:18	2021-09-08 17:58:56	23c4a35e-b224-4642-97c6-24d3aff638cb	\N	\N
303	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:26:05	2021-09-08 18:26:05	2021-09-08 18:26:08	76708ba1-800b-4650-ba84-b09936a69c62	\N	\N
309	\N	83	16	craft\\elements\\Entry	t	f	2021-09-08 18:26:41	2021-09-08 18:26:41	\N	a804ac0b-eb07-4f4a-9838-50e563d4e143	308	\N
322	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-14 22:31:34	2021-09-14 22:31:34	2021-09-14 22:31:37	97008961-2bdc-401c-9939-0c020fa7dadc	\N	\N
58	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-21 23:06:50	2021-06-21 23:06:50	2021-06-22 21:50:11	7ccdae05-ab7f-47f9-bf54-13ee4522588b	\N	\N
62	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-21 23:06:50	2021-06-21 23:06:50	\N	b08dbc20-15a4-4ac0-ab58-2af66c02ee87	\N	\N
63	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-21 23:06:50	2021-06-21 23:06:50	\N	17c5344a-0ba5-41e0-8223-dc56015a6428	\N	\N
64	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-21 23:06:50	2021-06-21 23:06:50	\N	64937dab-cd12-423d-ae1d-baaab5720630	\N	\N
59	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-21 23:06:50	2021-06-21 23:06:50	2021-06-22 21:50:11	ab8fabc1-0ba9-4dbe-9285-a9b3a32972ad	\N	\N
60	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-21 23:06:50	2021-06-21 23:06:50	2021-06-22 21:50:11	033fc9dd-c41e-4c32-8b7c-ac7d228d0289	\N	\N
57	\N	\N	11	craft\\elements\\Entry	t	f	2021-06-21 23:06:50	2021-06-21 23:06:50	2021-06-22 21:50:11	518f0547-1ed9-47be-8f89-cedbb746a692	\N	\N
52	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-21 23:04:33	2021-06-21 23:04:33	2021-06-22 21:50:11	ae5c780a-3f25-4dc3-9a98-6d696103b44e	\N	\N
53	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-21 23:04:33	2021-06-21 23:04:33	2021-06-22 21:50:11	18eaf418-c714-43dc-8f52-2e9ee27d457e	\N	\N
51	\N	\N	10	craft\\elements\\Entry	t	f	2021-06-21 23:04:33	2021-06-21 23:04:33	2021-06-22 21:50:11	15418e5b-f601-4e92-b9e0-ff04783fda31	\N	\N
8	\N	\N	2	craft\\elements\\Entry	t	f	2021-06-15 16:50:17	2021-08-20 22:02:00	2021-09-16 20:39:46	25d92c48-65a0-4481-9f50-67e6abf9f999	\N	\N
71	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-22 21:51:08	2021-06-22 21:51:07	\N	a5b00b48-9244-4962-b978-252603525dee	\N	\N
65	\N	\N	12	craft\\elements\\Entry	t	f	2021-06-21 23:15:44	2021-06-21 23:15:44	2021-08-03 17:03:53	97304764-de64-4deb-8a47-8f5a46620a4e	\N	\N
50	\N	\N	9	craft\\elements\\Asset	t	f	2021-06-21 23:03:21	2021-06-21 23:03:21	2021-08-03 17:03:57	3a6cef1f-2bf3-42a5-bbdf-e5f584691f1e	\N	\N
49	\N	\N	9	craft\\elements\\Asset	t	f	2021-06-21 23:02:55	2021-06-21 23:02:55	2021-08-03 17:03:59	deaec5a8-44d9-441d-89e0-47ad503513ca	\N	\N
45	\N	\N	5	craft\\elements\\Entry	t	f	2021-06-15 21:38:14	2021-09-16 20:37:20	\N	bb8381d7-71b8-405e-894a-c912a67f73a2	\N	\N
332	\N	90	5	craft\\elements\\Entry	t	f	2021-09-16 20:36:42	2021-09-16 20:36:42	\N	cbc9087e-71c2-4cf5-b36f-465ffecc2f91	45	\N
335	\N	92	2	craft\\elements\\Entry	t	f	2021-09-16 23:29:40	2021-09-16 23:29:40	\N	e9854733-7d01-4e5b-ab32-63a0d8690aa4	35	\N
3	1	\N	2	craft\\elements\\Entry	t	f	2021-05-19 22:50:51	2021-05-19 22:50:51	\N	13efb1e8-5cb9-4b60-b32f-0fbada31e981	\N	\N
367	50	\N	16	craft\\elements\\Entry	t	f	2021-09-29 00:03:16	2021-09-29 00:03:16	\N	abf9f0c1-e520-43a7-97b9-7ed88f9830eb	\N	\N
370	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-29 19:39:48	2021-10-08 22:40:08	\N	0cc25837-162d-48b3-8e81-548f4d47e35d	\N	\N
339	\N	94	2	craft\\elements\\Entry	t	f	2021-09-23 16:56:37	2021-09-23 16:56:37	\N	08c19f9c-918c-4168-8950-7bf723384ca6	14	\N
17	\N	\N	4	craft\\elements\\Asset	t	f	2021-06-15 17:23:21	2021-08-17 20:35:42	2021-08-20 22:00:09	9c3267ef-43ac-4d20-8349-d130070a5274	\N	\N
41	\N	\N	2	craft\\elements\\Entry	t	f	2021-06-15 18:11:30	2021-06-15 18:11:30	2021-08-06 23:10:33	1b425211-a66c-4812-b1fa-29dbf209c0a6	\N	\N
30	\N	\N	4	craft\\elements\\Asset	t	f	2021-06-15 17:54:39	2021-06-15 17:54:39	2021-08-06 23:09:15	961319d9-172a-48a1-b2ca-0bc897fd40dd	\N	\N
22	\N	\N	4	craft\\elements\\Asset	t	f	2021-06-15 17:34:12	2021-08-17 20:36:15	2021-08-20 22:00:09	a273346e-590a-4f44-a121-616539822b86	\N	\N
19	\N	\N	4	craft\\elements\\Asset	t	f	2021-06-15 17:23:44	2021-08-17 20:36:00	2021-08-20 22:00:09	4ccc65de-554e-418b-bc98-b755acf495ea	\N	\N
34	\N	\N	4	craft\\elements\\Asset	t	f	2021-06-15 17:58:28	2021-06-15 17:58:28	2021-08-06 23:09:15	4cd760dc-ee82-4a78-b242-33049c01476b	\N	\N
26	\N	\N	4	craft\\elements\\Asset	t	f	2021-06-15 17:51:02	2021-08-17 20:36:37	2021-08-20 22:00:09	c805db20-bc1c-442a-91e3-a4ec1ca94a1c	\N	\N
2	\N	\N	1	craft\\elements\\Category	t	f	2021-05-19 21:19:04	2021-06-15 17:00:20	2021-08-12 21:49:08	a833905c-d82c-44ec-a12c-73a128d828ad	\N	\N
347	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-23 16:57:23	2021-09-23 16:57:23	2021-09-23 16:57:26	86c9f6cf-ca1d-4b03-bf39-5483968c2c0b	\N	\N
4	2	\N	2	craft\\elements\\Entry	t	f	2021-05-19 22:52:54	2021-05-19 22:52:54	\N	73a26f01-650f-4985-8410-1a1b527c6a67	\N	\N
351	\N	98	2	craft\\elements\\Entry	t	f	2021-09-23 16:58:00	2021-09-23 16:58:01	\N	b49ab73b-8ccb-4dcf-bc9c-1d5b96002310	35	\N
35	\N	\N	2	craft\\elements\\Entry	t	f	2021-06-15 17:58:32	2021-10-08 22:43:16	\N	532d6681-d74c-4df2-8080-5454061b8ba8	\N	\N
368	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-29 19:39:30	2021-09-29 19:39:30	2021-10-08 23:02:22	b14b8c33-e5bd-43b2-a716-a77fe411837c	\N	\N
372	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-29 19:40:05	2021-10-08 22:42:50	\N	420dd296-2a66-4421-a445-dc298abe9cee	\N	\N
31	\N	\N	2	craft\\elements\\Entry	t	f	2021-06-15 17:54:44	2021-10-08 22:42:54	\N	5b9011cd-2502-44a4-9a9a-1cfd95ba75d6	\N	\N
376	\N	\N	4	craft\\elements\\Asset	t	f	2021-10-01 20:33:17	2021-10-01 20:33:17	2021-10-08 23:02:22	64d0f269-32fd-42d3-86d9-1ce2fd9ebb47	\N	\N
239	\N	\N	22	craft\\elements\\Asset	t	f	2021-08-30 21:32:28	2021-09-08 17:58:46	2021-10-08 23:02:35	4551eaaa-4c57-4aae-bf81-ce621f8544a1	\N	\N
240	\N	\N	16	craft\\elements\\Entry	t	f	2021-08-30 21:32:31	2021-10-08 23:05:09	\N	80e69c7c-289a-474d-a087-7d0a304d9463	\N	\N
75	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-06-22 21:51:45	2021-06-22 21:51:07	\N	9e8580cf-3f3f-4108-a60e-b033ead0bd5d	\N	\N
76	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-06-22 21:51:45	2021-06-22 21:51:45	\N	b135afd6-ebd6-4674-a93b-cd7d5d1fea16	\N	\N
77	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-06-22 21:51:45	2021-06-22 21:51:45	\N	a00fe1e9-79ff-4372-8636-607f43c3695e	\N	\N
78	\N	\N	\N	craft\\elements\\User	t	f	2021-06-28 17:39:27	2021-06-28 17:39:27	\N	9e938414-ebc7-4453-84ef-17162fedc528	\N	\N
79	\N	\N	\N	craft\\elements\\User	t	f	2021-06-28 17:41:30	2021-06-28 17:41:30	\N	5b18078c-91d3-4fdd-b3ac-565757f7aff5	\N	\N
80	\N	\N	\N	craft\\elements\\User	t	f	2021-06-28 17:42:18	2021-06-28 17:42:18	\N	78c3b9bb-1d80-4b36-ae55-93e13a09c243	\N	\N
234	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:32:00	2021-08-30 21:32:00	2021-08-30 21:32:03	9f6dd786-11d7-412e-95e2-3ca9b1d2dadd	\N	\N
100	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:43:42	2021-07-16 18:42:22	\N	124df120-fdd1-4210-a8fe-8df2179d76ef	\N	\N
101	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:43:42	2021-07-16 18:42:33	\N	37f6f4ac-fb72-4219-b0b3-60934dc0dbb1	\N	\N
102	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:43:42	2021-07-16 18:43:33	\N	ac004fde-ae65-4780-8b15-33c73f48654e	\N	\N
241	\N	75	16	craft\\elements\\Entry	t	f	2021-08-30 21:32:31	2021-08-30 21:32:31	\N	213ce261-dafe-4800-9e26-daae7d6495a7	240	\N
310	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:26:56	2021-10-08 23:08:49	\N	fb4645cf-4ccc-4f30-af3e-b99b50397746	\N	\N
105	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:45:52	2021-07-16 18:42:22	\N	c116a734-3a47-43f1-886a-772c125c9208	\N	\N
106	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:45:53	2021-07-16 18:42:33	\N	34c8eb58-d7c3-4ba6-ade8-4aedac51b8c1	\N	\N
107	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:45:53	2021-07-16 18:43:33	\N	525236c0-8655-4071-bf25-6701f6af59a7	\N	\N
86	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:42:19	2021-07-16 18:42:19	2021-07-16 18:42:23	2b065cd2-bb55-493f-b402-f7f0974a9dc6	\N	\N
88	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:42:31	2021-07-16 18:42:31	2021-07-16 18:42:33	ffad5851-b1d4-43f9-8fcd-f5985670b0f7	\N	\N
90	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:42:36	2021-07-16 18:42:36	2021-07-16 18:42:42	d633cefa-0801-4d79-bbf3-01d5e138b6a0	\N	\N
291	\N	\N	16	craft\\elements\\Entry	t	f	2021-09-08 17:58:53	2021-10-08 23:05:41	\N	3133e7c5-2566-4fa5-a2d9-21c7eb77cae0	\N	\N
91	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:42:41	2021-07-16 18:42:41	2021-07-16 18:43:33	f56d528d-6556-4724-b7cd-9cea9003907b	\N	\N
84	19	\N	2	craft\\elements\\Entry	t	f	2021-07-16 18:41:34	2021-07-16 18:41:34	\N	610de78b-4347-4b9b-84ed-a0f5eb54ea8a	\N	\N
405	\N	114	16	craft\\elements\\Entry	t	f	2021-10-08 23:05:41	2021-10-08 23:05:41	\N	5735f1e0-78a6-4dff-a093-6f76ac518556	291	\N
109	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-07-19 22:32:18	2021-06-22 21:51:07	\N	4d51f0c3-460e-498a-8f91-88dc7e775aa2	\N	\N
110	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-07-19 22:32:25	2021-06-22 21:51:45	\N	68a20276-fbb1-4c63-ad4e-543d8a6acd1e	\N	\N
111	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-07-19 22:32:30	2021-07-19 22:31:56	\N	23538dba-b003-4030-8433-374659ef8a2d	\N	\N
95	\N	\N	6	craft\\elements\\Entry	t	f	2021-07-16 18:43:41	2021-10-08 23:07:33	\N	56e72d00-560f-4349-b04e-c3dcde4bddf0	\N	\N
277	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:55:09	2021-09-08 17:55:09	\N	44180d28-3ad7-47a6-bfc2-a12ab490e14f	236	\N
112	\N	\N	\N	craft\\elements\\User	t	f	2021-07-26 16:35:59	2021-07-26 16:51:43	\N	fd94dac6-8589-4f1e-aec5-317fbd80e5a2	\N	\N
113	\N	\N	\N	craft\\elements\\User	t	f	2021-07-26 17:36:47	2021-07-26 17:36:47	\N	e1cfa26e-a081-4d45-91e3-95b494eec8de	\N	\N
278	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:55:09	2021-09-08 17:55:09	\N	8c9251fd-12c0-4d0f-ba39-959f283d4018	242	\N
290	\N	\N	22	craft\\elements\\Asset	t	f	2021-09-08 17:58:44	2021-09-08 17:58:44	2021-09-08 17:58:47	c2fd0d93-401b-4ac1-b730-4929334f558d	\N	\N
284	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:57:52	2021-09-08 17:57:52	2021-09-08 18:22:58	eaf77a86-a764-490c-8b3e-d31d7a4206e5	\N	\N
275	\N	80	6	craft\\elements\\Entry	t	f	2021-09-08 17:55:09	2021-09-08 17:55:09	\N	7012bf81-1350-43e0-9f2d-8cbb10d390d4	227	\N
276	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:55:09	2021-09-08 17:55:09	\N	19a400a7-d3e2-444f-a177-54d93b75137d	232	\N
116	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-06 22:19:57	2021-08-06 22:19:57	2021-08-06 22:20:03	8e7f8843-eac4-4151-888a-b5fa33a229b6	\N	\N
118	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-06 22:19:58	2021-08-06 22:19:58	2021-08-06 22:20:04	819ffa6f-aae3-4a0a-b939-b772fdcc9d60	\N	\N
119	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-06 22:19:58	2021-08-06 22:19:58	2021-08-06 22:20:04	47370ccb-ce17-41e0-98e8-14c56c12a629	\N	\N
120	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-06 22:19:58	2021-08-06 22:19:58	2021-08-06 22:20:04	887235fb-420e-4a31-b2a3-03f8e9950fac	\N	\N
299	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:25:53	2021-09-08 18:25:53	2021-09-08 18:25:56	206f1e5a-70f1-4dee-95f2-a361c73f6854	\N	\N
304	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:26:08	2021-09-08 18:26:08	2021-09-08 18:26:12	157a4161-06cf-4cdf-8de2-b65a93777e27	\N	\N
318	\N	86	2	craft\\elements\\Entry	t	f	2021-09-14 22:23:30	2021-09-14 22:23:30	\N	15428d12-2402-4986-b7af-186610b95b43	14	\N
323	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-14 22:31:40	2021-09-14 22:31:40	2021-09-14 22:31:44	c877f3ea-cfd9-4b1d-9155-4626daa0cdff	\N	\N
328	\N	88	5	craft\\elements\\Entry	t	f	2021-09-14 22:43:07	2021-09-14 22:43:07	\N	baad68fd-f99e-4cc9-adff-a1c6fcca7d2d	45	\N
336	\N	93	2	craft\\elements\\Entry	t	f	2021-09-16 23:29:42	2021-09-16 23:29:43	\N	3120211c-dba5-4c6f-9669-0e251beaf03c	35	\N
117	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-06 22:19:58	2021-08-17 20:37:14	2021-08-20 22:00:09	5f122c22-ccae-448b-aebf-a77e2d79a2aa	\N	\N
344	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-23 16:57:07	2021-09-23 16:57:07	2021-09-23 16:57:09	385f4407-0846-46e9-80d5-78320541ed33	\N	\N
82	\N	\N	2	craft\\elements\\Entry	t	f	2021-07-16 17:53:05	2021-07-16 17:53:05	2021-08-06 23:06:25	e1f18740-784c-4802-9209-72d079d8ed65	\N	\N
115	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-06 22:19:57	2021-08-17 20:37:00	2021-08-20 22:00:09	7c8f5caf-b5ea-4c56-9724-77062f72a975	\N	\N
348	\N	97	2	craft\\elements\\Entry	t	f	2021-09-23 16:57:43	2021-09-23 16:57:44	\N	eaa820d7-c902-43e0-81d7-40164522f7ce	31	\N
138	\N	\N	18	craft\\elements\\Entry	t	f	2021-08-06 22:54:56	2021-08-06 23:03:19	2021-08-12 21:49:08	8bec5275-1e7e-43a7-a22f-75e8b541327b	\N	\N
356	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-28 23:42:11	2021-09-28 23:42:11	2021-09-29 19:35:06	80959ae6-01af-4ccf-abbe-5a99ad721673	\N	\N
359	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-28 23:45:34	2021-09-28 23:45:34	2021-09-29 19:35:07	4d936cda-da7b-432f-b669-f24c4480a8b8	\N	\N
365	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-28 23:51:59	2021-09-28 23:51:59	2021-09-29 19:35:09	9d7e2be4-b564-4a2e-b50d-a8ecb8dffb25	\N	\N
137	\N	\N	17	craft\\elements\\Asset	t	f	2021-08-06 22:54:52	2021-08-06 22:54:52	2021-10-08 23:02:48	1d065da3-5723-4227-8626-6ded134f8a54	\N	\N
228	\N	\N	17	craft\\elements\\Asset	t	f	2021-08-30 21:31:25	2021-09-08 17:57:30	2021-10-08 23:02:48	68dab35a-1bb6-493b-86e0-9e09b9b10e7f	\N	\N
92	\N	\N	16	craft\\elements\\Entry	t	f	2021-07-16 18:43:22	2021-10-08 23:04:52	\N	53bf96d5-10c1-49ca-a3d1-f0c8ffa80bcf	\N	\N
142	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:02:41	2021-06-22 21:51:07	\N	a7d08600-f954-4158-ab56-21a890f17dab	\N	\N
143	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:02:41	2021-06-22 21:51:45	\N	312e425d-f7c7-4018-817d-7b308f43db33	\N	\N
144	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:02:41	2021-08-06 23:02:41	\N	0ef13944-7aa0-47c1-ad6a-8782e37cbc34	\N	\N
235	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:32:03	2021-08-30 21:32:03	2021-08-30 21:32:05	62269710-5a85-4664-9036-b86d97e35257	\N	\N
146	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:02:51	2021-07-16 18:42:22	\N	dcde75dd-e8f9-4b70-b581-d6c65c40e869	\N	\N
147	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:02:51	2021-07-16 18:42:33	\N	d8b6044f-b84c-444f-bf8d-fd290465a78b	\N	\N
148	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:02:51	2021-08-06 23:02:50	\N	386f842b-7ba1-4111-8b74-99bd1324ce65	\N	\N
305	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:26:12	2021-10-08 23:08:49	\N	45965b47-3aca-49b8-8abd-96ce7dd335ab	\N	\N
259	\N	78	6	craft\\elements\\Entry	t	f	2021-09-08 17:54:31	2021-09-08 17:54:32	\N	4c6b0070-71ab-4ff6-8ac9-4fa98de5e0b1	67	\N
151	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:04:32	2021-06-22 21:51:07	\N	a70ded7f-66f8-4215-92c3-661d4eae88ac	\N	\N
152	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:04:32	2021-06-22 21:51:45	\N	72d417a1-1a76-45f4-8f00-6a6cf378eb3a	\N	\N
153	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:04:32	2021-08-06 23:04:32	\N	d6078b34-ee63-4b31-aa84-f7fad04a82be	\N	\N
260	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:54:32	2021-09-08 17:54:32	\N	519942df-1e67-4956-98c3-5f41ea5d4ae6	69	\N
155	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:04:44	2021-07-16 18:42:22	\N	ae41b115-f81e-4705-97b4-149231e4942b	\N	\N
156	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:04:44	2021-07-16 18:42:33	\N	4f9ed4ba-50b4-493b-b525-530e1f465fa7	\N	\N
157	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:04:44	2021-08-06 23:04:44	\N	6bef344c-3c94-42f4-a292-3873aa46bd5f	\N	\N
261	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:54:32	2021-09-08 17:54:32	\N	cc4b3842-b5a1-4755-b871-d3925e1e6dfa	72	\N
159	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:05:17	2021-07-16 18:42:22	\N	26932b86-bc64-407a-8677-64b2594ec162	\N	\N
160	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:05:17	2021-07-16 18:42:33	\N	ca70578d-d365-421a-baf8-d224d4614b98	\N	\N
161	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-06 23:05:17	2021-08-06 23:05:17	\N	a032abea-4ee8-4dad-9fff-73acffdf4125	\N	\N
262	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:54:32	2021-09-08 17:54:32	\N	ffa27ad9-63fd-4b0a-8c33-3bf63c8c9d26	73	\N
73	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-06-22 21:51:45	2021-10-08 23:06:43	\N	7b303b58-8d21-4cc7-9452-4372cbf3bc85	\N	\N
292	\N	81	16	craft\\elements\\Entry	t	f	2021-09-08 17:58:53	2021-09-08 17:58:54	\N	c5eb44ff-599e-400d-8127-4e58eed3ad6a	291	\N
311	\N	84	6	craft\\elements\\Entry	t	f	2021-09-08 18:26:58	2021-09-08 18:26:58	\N	56551910-7964-4b6b-bf32-a641013b77ab	298	\N
312	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:26:58	2021-09-08 18:26:58	\N	fc1e081f-28d4-4b87-9a42-23a5cd55b7a1	302	\N
279	\N	\N	6	craft\\elements\\Entry	t	f	2021-09-08 17:55:33	2021-09-08 17:58:58	2021-09-08 18:22:58	059981a6-dc5e-4f36-99b9-d29dd08221b0	\N	\N
300	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:25:56	2021-09-08 18:25:56	2021-09-08 18:25:58	19bf3785-d99c-450d-8dc9-f517b1d763ea	\N	\N
169	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:25:12	2021-06-22 21:51:07	\N	505cb987-5d6c-4adc-a441-aa4ead2f2b31	\N	\N
170	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:25:12	2021-06-22 21:51:45	\N	fb2e84f9-481d-49e7-aaa0-23c3182899f7	\N	\N
171	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:25:12	2021-08-17 20:25:11	\N	4787404b-72a4-43dc-873d-ea71e0aa6716	\N	\N
285	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:58:07	2021-09-08 17:58:07	2021-09-08 17:58:11	c1818cc4-b2dd-48da-a74c-af1a899f87cc	\N	\N
313	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:26:58	2021-09-08 18:26:58	\N	489fa913-eb41-4520-b342-b986ce82ec81	305	\N
174	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:25:35	2021-07-16 18:42:22	\N	04619a6b-cc7c-4251-9465-ff368f85d1a9	\N	\N
175	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:25:35	2021-07-16 18:42:33	\N	96007c4f-eaa0-44ff-88cc-590e160429f4	\N	\N
176	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:25:35	2021-08-17 20:25:35	\N	dd67ca4c-f966-4854-8dc2-adde5d54de4d	\N	\N
314	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:26:58	2021-09-08 18:26:58	\N	6a5311ba-3a62-4c90-a3a4-332f3694f9bd	310	\N
180	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:28:35	2021-07-16 18:42:22	\N	d2c5b743-3782-40d5-b636-b046bd34a175	\N	\N
181	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:28:35	2021-07-16 18:42:33	\N	a80bec0b-d877-4bfd-a766-5109c5c9dce6	\N	\N
182	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:28:35	2021-08-17 20:28:35	\N	9c84fe8c-dfe5-461f-9820-f9946a099488	\N	\N
184	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:29:06	2021-07-16 18:42:22	\N	526c04b5-b215-4ba2-abc6-f5fd683a15ec	\N	\N
185	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:29:07	2021-07-16 18:42:33	\N	99cbe151-0841-4a76-b9ac-6e8b92a24be1	\N	\N
186	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-17 20:29:07	2021-08-17 20:29:06	\N	a17e0d7f-1cb9-4491-90e3-daf9c744d5e5	\N	\N
187	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-17 20:35:39	2021-08-17 20:35:39	2021-08-17 20:35:42	86807c27-6751-4dbb-97af-53ac8f1a6d0a	\N	\N
324	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-14 22:31:47	2021-09-14 22:31:47	2021-09-14 22:31:50	2b4273d9-249c-49a9-9df2-81f054bc572d	\N	\N
189	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-17 20:35:57	2021-08-17 20:35:57	2021-08-17 20:36:00	b84f20cf-3733-4dba-8b65-f02aacdde59b	\N	\N
334	\N	91	5	craft\\elements\\Entry	t	f	2021-09-16 20:37:20	2021-09-16 20:37:21	\N	1ee37d14-d593-45f4-8568-65048e53066b	45	\N
191	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-17 20:36:13	2021-08-17 20:36:13	2021-08-17 20:36:16	97aac36b-b690-414d-b8d4-5e5cfb08a1a1	\N	\N
193	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-17 20:36:34	2021-08-17 20:36:34	2021-08-17 20:36:37	e5bf6752-ef8b-4166-9f58-c8b0d4752e03	\N	\N
341	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-23 16:56:49	2021-09-23 16:56:49	2021-09-23 16:56:52	43641eb7-ac45-46b4-b098-36a80c7fe736	\N	\N
345	\N	96	2	craft\\elements\\Entry	t	f	2021-09-23 16:57:13	2021-09-23 16:57:13	\N	1ab2a1ad-36f0-4d4d-a282-db6909c1e333	27	\N
195	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-17 20:36:57	2021-08-17 20:36:57	2021-08-17 20:37:00	85f2a9c5-b081-476d-97d9-53c4e037eb13	\N	\N
178	\N	\N	21	craft\\elements\\Category	t	f	2021-08-17 20:28:31	2021-08-20 21:55:05	\N	6a04f50b-6d17-46c4-a555-e66592847dec	\N	\N
141	\N	43	6	craft\\elements\\Entry	t	f	2021-08-06 23:02:41	2021-08-06 23:02:41	\N	536154f1-f2b4-4241-b66e-9742b0def23e	67	\N
353	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-28 23:40:00	2021-09-28 23:40:00	2021-09-29 19:35:05	7ea7e278-d683-4617-bfa9-b7b556138029	\N	\N
23	\N	\N	2	craft\\elements\\Entry	t	f	2021-06-15 17:34:27	2021-10-08 22:40:48	\N	9a915cc0-8171-46af-8a89-8c9e534ff41a	\N	\N
167	\N	\N	17	craft\\elements\\Asset	t	f	2021-08-17 20:25:07	2021-08-17 20:25:07	2021-10-08 23:02:48	9ab37202-d969-47f5-b921-9e78d4ef3e3a	\N	\N
229	\N	\N	20	craft\\elements\\Category	t	f	2021-08-30 21:31:28	2021-10-08 23:04:06	\N	8bc75581-fb86-434c-ae86-ea3082e628e8	\N	\N
401	\N	112	16	craft\\elements\\Entry	t	f	2021-10-08 23:04:52	2021-10-08 23:04:53	\N	7d9fe621-708c-4bae-ab50-14f6b6afe32c	92	\N
197	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-17 20:37:11	2021-08-17 20:37:11	2021-08-17 20:37:14	d2ec5f3d-4b93-4151-b726-2dcbb3131ce3	\N	\N
230	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:31:49	2021-08-30 21:31:49	2021-08-30 21:31:51	46f03445-cedc-4782-845b-ea8ea72a4ead	\N	\N
205	\N	\N	21	craft\\elements\\Category	t	f	2021-08-20 21:55:12	2021-08-20 21:55:12	\N	4d9a25fc-a8f2-483c-ae81-14f0b2d3a090	\N	\N
206	\N	\N	21	craft\\elements\\Category	t	f	2021-08-20 21:55:30	2021-08-20 21:55:30	\N	32d11aba-07aa-46e1-88cc-ef07aee0a672	\N	\N
207	\N	\N	21	craft\\elements\\Category	t	f	2021-08-20 21:55:41	2021-08-20 21:55:41	\N	5e1e9268-8b5a-471c-83cd-5bc3b53fe618	\N	\N
208	\N	\N	21	craft\\elements\\Category	t	f	2021-08-20 21:55:51	2021-08-20 21:55:51	\N	4f8bc6e2-4996-422c-82a0-e7c7f79a335e	\N	\N
243	\N	76	6	craft\\elements\\Entry	t	f	2021-08-30 21:32:34	2021-08-30 21:32:35	\N	5c024b89-6c11-487e-9505-055af9911b2f	227	\N
244	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:32:35	2021-08-30 21:32:35	\N	a9cd82f0-0e25-418d-b8f6-5545a4240103	232	\N
211	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-20 21:56:58	2021-07-16 18:42:22	\N	98968481-90f3-43a8-ba89-0e1d831f5bb5	\N	\N
212	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-20 21:56:58	2021-07-16 18:42:33	\N	fb45e269-5ce9-4f6e-9bd7-14101ccfd70c	\N	\N
213	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-20 21:56:58	2021-08-20 21:56:58	\N	81ba5131-0179-4bf6-b6ff-130204b141c5	\N	\N
199	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-17 20:41:22	2021-08-17 20:41:22	2021-08-20 22:00:09	839cf109-3c5f-4d61-b978-da1023ba2906	\N	\N
236	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:32:05	2021-10-08 23:08:16	\N	4f8ebcc7-a661-483a-b85c-6bc59ef7b262	\N	\N
245	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:32:35	2021-08-30 21:32:35	\N	d6418521-0d33-493c-a2d1-f2892c29db38	236	\N
246	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:32:35	2021-08-30 21:32:35	\N	493f8883-36f1-412e-a895-fedbd755786b	242	\N
286	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:58:11	2021-09-08 17:58:11	2021-09-08 18:22:58	7fe0d50a-62e1-4653-ac17-2ba83f7becbf	\N	\N
5	3	\N	2	craft\\elements\\Entry	t	f	2021-05-19 22:53:34	2021-05-19 22:54:38	\N	b30d5446-9bcc-4e9a-ad5e-73dd6da9ae8a	\N	\N
10	5	\N	2	craft\\elements\\Entry	t	f	2021-06-15 16:58:55	2021-06-15 16:58:55	\N	fd597d43-ead6-4cb4-a9ce-ae328b0b501b	\N	\N
11	6	\N	2	craft\\elements\\Entry	t	f	2021-06-15 16:59:52	2021-06-15 16:59:52	\N	dd7a1bcd-9cea-4c7d-a256-ebb2340dced1	\N	\N
47	16	\N	6	craft\\elements\\Entry	t	f	2021-06-21 22:42:31	2021-06-21 22:42:31	\N	8e8db579-ef35-497b-9e6a-e4d1bb445b5a	\N	\N
43	14	\N	5	craft\\elements\\Entry	t	f	2021-06-15 21:36:09	2021-06-15 21:36:09	\N	b27df941-02e0-4c46-9643-a01f8c35d016	\N	\N
201	23	\N	6	craft\\elements\\Entry	t	f	2021-08-17 20:43:58	2021-08-17 20:43:58	\N	0a17bd50-037a-4ce8-b97f-eb49d38ccc0e	\N	\N
202	24	\N	5	craft\\elements\\Entry	t	f	2021-08-17 21:26:23	2021-08-17 21:26:23	\N	341bcc82-14fc-40c3-a654-da27e2b94134	\N	\N
203	25	\N	6	craft\\elements\\Entry	t	f	2021-08-20 21:48:32	2021-08-20 21:48:32	\N	cf643606-6576-4231-a6cc-68b518022b7e	\N	\N
28	\N	8	2	craft\\elements\\Entry	t	f	2021-06-15 17:51:11	2021-06-15 17:51:11	\N	2e00572a-621b-4240-88df-b6936cc471cd	27	\N
280	\N	\N	17	craft\\elements\\Asset	t	f	2021-09-08 17:57:28	2021-09-08 17:57:28	2021-09-08 17:57:30	b6beb54c-dc04-4425-8e47-07b82c72ba15	\N	\N
32	\N	9	2	craft\\elements\\Entry	t	f	2021-06-15 17:54:44	2021-06-15 17:54:44	\N	aeaaf39d-880e-48c1-9431-9e875a20807b	31	\N
46	\N	13	5	craft\\elements\\Entry	t	f	2021-06-15 21:38:14	2021-06-15 21:38:14	\N	8daa954e-0583-46db-81dc-2bc278725801	45	\N
39	\N	11	2	craft\\elements\\Entry	t	f	2021-06-15 18:07:52	2021-06-15 18:07:52	2021-06-15 22:09:00	634f6fc9-08c0-48a1-8f94-c937b83b2079	38	\N
24	\N	7	2	craft\\elements\\Entry	t	f	2021-06-15 17:34:26	2021-06-15 17:34:26	\N	8bd53d02-1e5c-4bcf-9029-46e15b89f9ec	23	\N
36	\N	10	2	craft\\elements\\Entry	t	f	2021-06-15 17:58:32	2021-06-15 17:58:32	\N	4d9e9f65-5df7-415b-9d6a-c69193c8b191	35	\N
68	\N	17	6	craft\\elements\\Entry	t	f	2021-06-21 23:15:49	2021-06-21 23:15:49	\N	bab51b2d-8f6e-4dbe-a76d-e41348569a1b	67	\N
293	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:58:56	2021-09-08 17:58:56	2021-09-08 18:22:58	a6396044-245a-4d87-9668-6410c248903f	\N	\N
61	\N	15	11	craft\\elements\\Entry	t	f	2021-06-21 23:06:50	2021-06-21 23:06:50	2021-06-22 21:50:11	357dc58c-0baa-4c98-92ff-7bfcfb7bbb2f	57	\N
70	\N	18	6	craft\\elements\\Entry	t	f	2021-06-22 21:51:07	2021-06-22 21:51:07	\N	acd0da68-95b3-4c87-9600-270daf6881e5	67	\N
99	\N	22	6	craft\\elements\\Entry	t	f	2021-07-16 18:43:41	2021-07-16 18:43:41	\N	65ed9a17-d46f-4bbc-bac6-38e05bd1d587	95	\N
301	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:25:58	2021-09-08 18:25:58	2021-09-08 18:26:00	97606c8d-2609-4e2a-ac17-c94b0e67d886	\N	\N
93	\N	21	16	craft\\elements\\Entry	t	f	2021-07-16 18:43:22	2021-07-16 18:43:22	\N	d2df97bd-f1cc-4dbd-b336-0c8aa13c5e1b	92	\N
198	\N	64	2	craft\\elements\\Entry	t	f	2021-08-17 20:37:17	2021-08-17 20:37:17	\N	6fdc5c04-2261-4fa0-b76e-104c90c9038a	35	\N
306	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:26:14	2021-09-08 18:26:14	2021-09-08 18:26:17	1465e4b7-5b5f-4018-8d44-c61288026365	\N	\N
218	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-20 22:01:07	2021-09-23 16:57:25	2021-09-29 19:35:03	d19e0fd3-a448-4d4b-bdef-691be312998a	\N	\N
215	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-20 22:01:06	2021-09-14 22:31:24	2021-09-29 19:34:59	12e990ac-670c-4675-9c56-0bf4ced31f17	\N	\N
217	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-20 22:01:06	2021-09-23 16:56:52	2021-09-29 19:35:00	55ac3530-5165-4801-9aee-b8e36258474f	\N	\N
320	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-14 22:31:21	2021-09-14 22:31:21	2021-09-14 22:31:24	7dfac930-283a-4da7-8c48-c3ddd796b5df	\N	\N
216	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-20 22:01:06	2021-09-23 16:57:57	2021-09-29 19:35:04	3cc34888-dfb9-4bc1-8d2e-e8b5a4da44eb	\N	\N
219	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-20 22:01:07	2021-09-23 16:56:31	2021-09-29 19:35:01	06b3d959-d8c0-4867-aee5-ca87df6b5b57	\N	\N
204	\N	\N	17	craft\\elements\\Asset	t	f	2021-08-20 21:54:23	2021-08-20 21:54:23	2021-10-08 23:02:48	e4a61966-d86b-44c9-a7d7-ab835fb842ec	\N	\N
325	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-14 22:31:52	2021-09-14 22:31:52	2021-09-14 22:31:55	9adc86c9-d47f-45ae-a004-0029fef37d98	\N	\N
330	\N	89	5	craft\\elements\\Entry	t	f	2021-09-16 20:36:16	2021-09-16 20:36:16	\N	54788baf-92d3-460c-ba4b-cd42d540a157	45	\N
16	\N	4	2	craft\\elements\\Entry	t	f	2021-06-15 17:21:23	2021-06-15 17:21:23	2021-09-16 20:39:46	47a2a62e-babd-41ef-b10f-022ec0abc681	8	\N
123	\N	28	2	craft\\elements\\Entry	t	f	2021-08-06 22:23:24	2021-08-06 22:23:24	2021-09-16 20:39:46	80841e17-080e-4968-95f2-0b8b13627d33	8	\N
121	\N	26	2	craft\\elements\\Entry	t	f	2021-08-06 22:23:02	2021-08-06 22:23:02	2021-09-16 20:39:46	8f490fa9-2602-430a-a435-9b12dc43ffe0	8	\N
128	\N	33	2	craft\\elements\\Entry	t	f	2021-08-06 22:25:32	2021-08-06 22:25:32	2021-09-16 20:39:46	b86e4dc6-f0d0-4a7e-82fa-7ca111071f47	8	\N
188	\N	59	2	craft\\elements\\Entry	t	f	2021-08-17 20:35:45	2021-08-17 20:35:45	2021-09-16 20:39:46	4aad76c8-272e-433f-ba6a-1c63562d1863	8	\N
214	\N	\N	4	craft\\elements\\Asset	t	f	2021-08-20 22:01:06	2021-09-23 16:57:09	2021-09-29 19:35:02	8d8e8c7a-7814-4467-b5bf-1624122a877a	\N	\N
177	\N	\N	20	craft\\elements\\Category	t	f	2021-08-17 20:28:22	2021-10-08 23:03:23	\N	7be708a6-6203-4e1b-9f48-5e175732e9ac	\N	\N
122	\N	27	2	craft\\elements\\Entry	t	f	2021-08-06 22:23:18	2021-08-06 22:23:18	\N	092dcff4-eef6-4f1d-93e3-ca7e0b88d6bc	14	\N
124	\N	29	2	craft\\elements\\Entry	t	f	2021-08-06 22:23:40	2021-08-06 22:23:40	\N	a5f882fe-bfe8-455c-9492-053e54c33b44	23	\N
132	\N	37	2	craft\\elements\\Entry	t	f	2021-08-06 22:25:54	2021-08-06 22:25:54	\N	98e34570-0910-4c6d-bced-96c955050703	31	\N
125	\N	30	2	craft\\elements\\Entry	t	f	2021-08-06 22:23:52	2021-08-06 22:23:52	\N	7f97dea8-71db-4dcb-b613-757b3f473fe4	27	\N
126	\N	31	2	craft\\elements\\Entry	t	f	2021-08-06 22:24:07	2021-08-06 22:24:07	\N	9d57ea91-d1d2-4365-b7b2-d4fbb157f955	31	\N
127	\N	32	2	craft\\elements\\Entry	t	f	2021-08-06 22:24:29	2021-08-06 22:24:29	\N	eeb43009-6fe5-4dec-888e-021a97fe90a5	35	\N
129	\N	34	2	craft\\elements\\Entry	t	f	2021-08-06 22:25:37	2021-08-06 22:25:37	\N	dc26ddc0-99ed-4895-b25c-9e1f3d560d8d	14	\N
130	\N	35	2	craft\\elements\\Entry	t	f	2021-08-06 22:25:41	2021-08-06 22:25:41	\N	3b05a4ca-9534-4dee-b5d5-59e4e283c0c8	23	\N
131	\N	36	2	craft\\elements\\Entry	t	f	2021-08-06 22:25:45	2021-08-06 22:25:45	\N	598e5c09-5ef2-4a66-a1fe-e78aaf98b3a7	27	\N
133	\N	38	2	craft\\elements\\Entry	t	f	2021-08-06 22:25:59	2021-08-06 22:25:59	\N	88f0803d-9d6f-457e-9725-9d506485a8c6	31	\N
134	\N	39	2	craft\\elements\\Entry	t	f	2021-08-06 22:26:07	2021-08-06 22:26:07	\N	48414fed-584c-40da-b1b3-0c798f76e90a	35	\N
135	\N	40	5	craft\\elements\\Entry	t	f	2021-08-06 22:26:30	2021-08-06 22:26:30	\N	b1511af6-f1f5-4b70-8308-17bfaf4e664d	45	\N
145	\N	44	6	craft\\elements\\Entry	t	f	2021-08-06 23:02:50	2021-08-06 23:02:50	\N	d9c9a064-976a-4ee1-9b4d-522b60e24f39	95	\N
150	\N	46	6	craft\\elements\\Entry	t	f	2021-08-06 23:04:31	2021-08-06 23:04:31	\N	7233193c-b616-4fda-8788-53425e12f3f0	67	\N
154	\N	47	6	craft\\elements\\Entry	t	f	2021-08-06 23:04:43	2021-08-06 23:04:43	\N	00469a36-6ac4-40bf-add8-4846c953a894	95	\N
158	\N	48	6	craft\\elements\\Entry	t	f	2021-08-06 23:05:17	2021-08-06 23:05:17	\N	a1ace2a2-c8e7-4d33-81f0-6b90af09206b	95	\N
83	\N	20	2	craft\\elements\\Entry	t	f	2021-07-16 17:53:05	2021-07-16 17:53:05	2021-08-06 23:06:25	1bd09f65-dd5d-40dd-a3b8-336b20c9d515	82	\N
162	\N	49	5	craft\\elements\\Entry	t	f	2021-08-06 23:06:48	2021-08-06 23:06:48	\N	964f3b91-e79f-4e4b-95d1-6e672da4029f	45	\N
163	\N	50	2	craft\\elements\\Entry	t	f	2021-08-06 23:09:51	2021-08-06 23:09:51	\N	6c102a6e-68dc-41d2-8439-6cd8e89b44fe	14	\N
164	\N	51	2	craft\\elements\\Entry	t	f	2021-08-06 23:10:01	2021-08-06 23:10:01	\N	912f3f53-0110-44ec-bdb4-9ce3d550f8bf	23	\N
165	\N	52	2	craft\\elements\\Entry	t	f	2021-08-06 23:10:10	2021-08-06 23:10:10	\N	4510394e-27b4-43ba-9066-9f4fbc4fe6af	27	\N
166	\N	53	2	craft\\elements\\Entry	t	f	2021-08-06 23:10:21	2021-08-06 23:10:21	\N	cf9dddd9-6cc6-43e8-a6cd-5f0c3ec24a98	31	\N
42	\N	12	2	craft\\elements\\Entry	t	f	2021-06-15 18:11:30	2021-06-15 18:11:30	2021-08-06 23:10:33	757f5edb-a85a-420f-8b3c-19a3c8c0d63e	41	\N
139	\N	41	18	craft\\elements\\Entry	t	f	2021-08-06 22:54:56	2021-08-06 22:54:56	2021-08-12 21:49:08	0b8a8d98-d3c3-4276-9dfe-8a4daeaf4a91	138	\N
140	\N	42	18	craft\\elements\\Entry	t	f	2021-08-06 22:56:20	2021-08-06 22:56:20	2021-08-12 21:49:08	6e691832-a32c-4b6d-8d50-58121e08d374	138	\N
149	\N	45	18	craft\\elements\\Entry	t	f	2021-08-06 23:03:19	2021-08-06 23:03:19	2021-08-12 21:49:08	0e7dffb1-cb43-436f-84d6-2f11166236fc	138	\N
168	\N	54	6	craft\\elements\\Entry	t	f	2021-08-17 20:25:11	2021-08-17 20:25:11	\N	5157ebab-3688-4f42-8769-74bfbfa68dbe	67	\N
172	\N	55	5	craft\\elements\\Entry	t	f	2021-08-17 20:25:16	2021-08-17 20:25:16	\N	5a6f5cde-fd02-47ce-9334-07d1d0d63525	45	\N
173	\N	56	6	craft\\elements\\Entry	t	f	2021-08-17 20:25:35	2021-08-17 20:25:35	\N	666277a8-5932-47b1-807a-e4705477bfa2	95	\N
179	\N	57	6	craft\\elements\\Entry	t	f	2021-08-17 20:28:34	2021-08-17 20:28:34	\N	66d28936-d650-4877-9d57-36649d1d0b91	95	\N
183	\N	58	6	craft\\elements\\Entry	t	f	2021-08-17 20:29:06	2021-08-17 20:29:06	\N	5caed6da-f3ed-418c-a0fe-c45c0f505513	95	\N
407	\N	115	16	craft\\elements\\Entry	t	f	2021-10-08 23:05:58	2021-10-08 23:05:58	\N	183926c3-0aa4-440c-a228-f15475242e15	308	\N
190	\N	60	2	craft\\elements\\Entry	t	f	2021-08-17 20:36:03	2021-08-17 20:36:03	\N	fe843ffa-93fb-4aac-bfd5-6dd787822854	14	\N
192	\N	61	2	craft\\elements\\Entry	t	f	2021-08-17 20:36:18	2021-08-17 20:36:18	\N	ea1240dd-83e8-4099-b399-1276616d07e4	23	\N
194	\N	62	2	craft\\elements\\Entry	t	f	2021-08-17 20:36:40	2021-08-17 20:36:40	\N	6670414a-f14b-4a15-89d9-a9dec084a145	27	\N
196	\N	63	2	craft\\elements\\Entry	t	f	2021-08-17 20:37:02	2021-08-17 20:37:02	\N	db96b92f-cbdc-44af-bda9-e6299ca6a676	31	\N
200	\N	65	16	craft\\elements\\Entry	t	f	2021-08-17 20:41:24	2021-08-17 20:41:24	\N	03b97eb8-8717-4ca7-9529-e9ba19783aa0	92	\N
209	\N	66	16	craft\\elements\\Entry	t	f	2021-08-20 21:56:12	2021-08-20 21:56:12	\N	04961589-b0fc-44d9-877b-e955430a24ba	92	\N
210	\N	67	6	craft\\elements\\Entry	t	f	2021-08-20 21:56:58	2021-08-20 21:56:58	\N	c618eb8d-9f59-4a44-a72a-15e68f95328e	95	\N
67	\N	\N	6	craft\\elements\\Entry	t	f	2021-06-21 23:15:49	2021-10-08 23:06:42	\N	03e6a9c5-ba71-4859-b931-37119af7f5d8	\N	\N
221	\N	69	2	craft\\elements\\Entry	t	f	2021-08-20 22:02:33	2021-08-20 22:02:33	\N	e6f7dd39-8d5a-4c22-9979-a4361ac401ff	14	\N
222	\N	70	2	craft\\elements\\Entry	t	f	2021-08-20 22:03:06	2021-08-20 22:03:06	\N	881b3724-8b95-4ed8-add3-3514132bfb9e	23	\N
223	\N	71	2	craft\\elements\\Entry	t	f	2021-08-20 22:03:29	2021-08-20 22:03:29	\N	214a6fdf-ee11-44a4-bace-f878eb8f2d85	27	\N
224	\N	72	2	craft\\elements\\Entry	t	f	2021-08-20 22:04:11	2021-08-20 22:04:11	\N	8de9e6bb-811d-4ad8-a90c-2d8e6ad9f84a	31	\N
225	\N	73	2	craft\\elements\\Entry	t	f	2021-08-20 22:04:39	2021-08-20 22:04:39	\N	61e6bb0d-3c4f-4bae-a67b-c98c1719f027	35	\N
226	\N	74	2	craft\\elements\\Entry	t	f	2021-08-20 22:04:44	2021-08-20 22:04:44	\N	672003c6-764e-485c-9108-bcde3e60926d	31	\N
74	\N	19	6	craft\\elements\\Entry	t	f	2021-06-22 21:51:44	2021-06-22 21:51:44	\N	8938203b-e72e-4e2b-81be-51413450b838	67	\N
72	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-06-22 21:51:45	2021-10-08 23:06:43	\N	0ce5b021-0d56-4e16-9a1a-016881248b99	\N	\N
412	\N	116	6	craft\\elements\\Entry	t	f	2021-10-08 23:06:42	2021-10-08 23:06:43	\N	c1c06313-b6f5-4a26-95f9-9fdeb187f9d0	67	\N
15	\N	3	2	craft\\elements\\Entry	t	f	2021-06-15 17:17:51	2021-06-15 17:17:51	\N	0597f71a-a715-4ec3-9b34-e47e104260e2	14	\N
413	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:06:44	2021-10-08 23:06:44	\N	d8a5ee6b-381d-4574-baca-5df68a75be95	69	\N
20	\N	6	2	craft\\elements\\Entry	t	f	2021-06-15 17:23:49	2021-06-15 17:23:49	\N	15f767f6-3a51-4f2d-9b35-dd2f721f279d	14	\N
108	\N	25	6	craft\\elements\\Entry	t	f	2021-07-19 22:31:47	2021-07-19 22:31:47	\N	fa550010-6370-4161-9220-0f46cdcaa1e5	67	\N
231	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:31:51	2021-08-30 21:31:51	2021-08-30 21:31:54	0f5963c7-df28-4139-936d-1b04aac916d0	\N	\N
414	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:06:44	2021-10-08 23:06:44	\N	acda7353-dc2f-40d4-9337-880912613f95	72	\N
415	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:06:44	2021-10-08 23:06:44	\N	e1ad8115-834f-4397-a3cd-4d211c5a9499	73	\N
96	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:43:41	2021-10-08 23:07:33	\N	d6f35d71-1fd8-4e94-9ba3-1333cc46243b	\N	\N
54	\N	14	10	craft\\elements\\Entry	t	f	2021-06-21 23:04:33	2021-06-21 23:04:33	2021-06-22 21:50:11	59decc21-43ed-45fe-b241-0aad175c8ff0	51	\N
103	\N	23	16	craft\\elements\\Entry	t	f	2021-07-16 18:45:50	2021-07-16 18:45:50	\N	f03c42ed-6e9c-4193-923b-266a605c11d7	92	\N
104	\N	24	6	craft\\elements\\Entry	t	f	2021-07-16 18:45:52	2021-07-16 18:45:52	\N	c5755475-3dda-4b0f-aae9-f6281d3d5bac	95	\N
66	\N	16	12	craft\\elements\\Entry	t	f	2021-06-21 23:15:44	2021-06-21 23:15:44	2021-08-03 17:03:53	f62abe7d-ef80-49ad-9ad8-6f001bb6db8f	65	\N
403	\N	113	16	craft\\elements\\Entry	t	f	2021-10-08 23:05:09	2021-10-08 23:05:09	\N	0bfdff2e-454c-43fe-a209-c16aa779c7a7	240	\N
237	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:32:07	2021-08-30 21:32:07	2021-08-30 21:32:11	8b0be8e3-df78-4bd7-a591-b217978f8e58	\N	\N
238	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:32:11	2021-08-30 21:32:11	2021-08-30 21:32:33	c1083b56-227e-49fa-82e2-47e7926a445a	\N	\N
232	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:31:54	2021-10-08 23:08:16	\N	bf35113e-1c49-44a4-a2fd-51fde7606854	\N	\N
302	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:26:00	2021-10-08 23:08:48	\N	7c72cfb6-fa25-4468-9804-0dd02caf0fb2	\N	\N
350	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-23 16:57:55	2021-09-23 16:57:55	2021-09-23 16:57:57	2187c4a9-595c-4410-9fa9-a1ac219f5864	\N	\N
267	\N	79	6	craft\\elements\\Entry	t	f	2021-09-08 17:54:51	2021-09-08 17:54:51	\N	b37c93a0-7810-4ddb-b519-7f7118103560	227	\N
268	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:54:52	2021-09-08 17:54:52	\N	bc6c703e-0586-47b6-8722-4effb9031950	232	\N
269	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:54:52	2021-09-08 17:54:52	\N	21c0d06b-c128-40ce-aa54-4b0747e33a68	236	\N
270	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:54:52	2021-09-08 17:54:52	\N	6dde6dda-a962-421d-8945-f42f2718360c	242	\N
281	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:57:46	2021-09-08 17:57:46	2021-09-08 17:57:48	c36197b6-1f5d-4539-bb13-64487d52a127	\N	\N
282	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:57:48	2021-09-08 17:57:48	2021-09-08 17:57:50	94b018da-cae4-48d3-a4b6-58c4befb5a8f	\N	\N
287	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:58:14	2021-09-08 17:58:14	2021-09-08 17:58:17	94ba8634-beeb-430c-b8c6-6d0dd20f27c0	\N	\N
288	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:58:17	2021-09-08 17:58:17	2021-09-08 17:58:18	d2707a5e-3eeb-4954-99cf-58a06dbc5ff4	\N	\N
295	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:58:58	2021-09-08 17:58:58	\N	b48dedad-5107-425f-b509-8a6e61ae457e	284	\N
296	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:58:58	2021-09-08 17:58:58	\N	757a2ecd-e0fa-4c80-becf-b75afc3c2f84	286	\N
297	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 17:58:58	2021-09-08 17:58:58	\N	3c440a41-e6fb-490a-a1ae-cdb1a26c1e66	293	\N
294	\N	82	6	craft\\elements\\Entry	t	f	2021-09-08 17:58:58	2021-09-08 17:58:58	2021-09-08 18:22:58	fde145e2-5abf-4a1a-aee5-898abec601bf	279	\N
307	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-09-08 18:26:17	2021-09-08 18:26:17	2021-09-08 18:26:56	ff4de025-51b4-45c7-95cc-598a6fa0855b	\N	\N
316	\N	85	2	craft\\elements\\Entry	t	f	2021-09-14 22:23:01	2021-09-14 22:23:01	\N	c937d36e-da9c-4f13-b291-73178b823aa8	14	\N
321	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-14 22:31:28	2021-09-14 22:31:28	2021-09-14 22:31:31	0d7c4dd1-cb7d-4c99-ac3a-51beaf42eca4	\N	\N
326	\N	87	2	craft\\elements\\Entry	t	f	2021-09-14 22:32:04	2021-09-14 22:32:05	\N	377a35b5-7705-4801-8e45-8f38e8cf926d	23	\N
354	\N	99	2	craft\\elements\\Entry	t	f	2021-09-28 23:40:48	2021-09-28 23:40:53	\N	819f844e-523c-4421-988d-4eb979b6e58f	14	\N
357	\N	100	2	craft\\elements\\Entry	t	f	2021-09-28 23:43:27	2021-09-28 23:43:32	\N	63d23ea3-3fc3-4d37-b896-7889f34ae444	23	\N
360	\N	101	2	craft\\elements\\Entry	t	f	2021-09-28 23:46:26	2021-09-28 23:46:31	\N	f60577e0-e0e9-4f6f-abca-ff27eeec6812	27	\N
220	\N	68	2	craft\\elements\\Entry	t	f	2021-08-20 22:02:00	2021-08-20 22:02:00	2021-09-16 20:39:46	bbd75927-b72a-4b49-8457-9ce58a7ea9cb	8	\N
9	\N	1	2	craft\\elements\\Entry	t	f	2021-06-15 16:50:17	2021-06-15 16:50:17	2021-09-16 20:39:46	e5664e30-f773-4c94-8a8f-949d5fb55d18	8	\N
12	\N	2	2	craft\\elements\\Entry	t	f	2021-06-15 17:04:56	2021-06-15 17:04:56	2021-09-16 20:39:46	122fbaf6-2e00-47a0-939c-ff6fda8301ab	8	\N
18	\N	5	2	craft\\elements\\Entry	t	f	2021-06-15 17:23:28	2021-06-15 17:23:28	2021-09-16 20:39:46	bfb057a2-da23-4b85-9c82-eb348a236e2a	8	\N
338	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-23 16:56:29	2021-09-23 16:56:29	2021-09-23 16:56:32	8e80aadc-799c-4df3-af86-5bf6693e6947	\N	\N
342	\N	95	2	craft\\elements\\Entry	t	f	2021-09-23 16:56:55	2021-09-23 16:56:55	\N	8a761d9d-6cf9-4d27-aafe-e108d8b3783c	23	\N
363	\N	102	2	craft\\elements\\Entry	t	f	2021-09-28 23:49:41	2021-09-28 23:49:46	\N	7699c53e-5ced-4792-af11-e175abf76fb8	31	\N
366	\N	103	2	craft\\elements\\Entry	t	f	2021-09-28 23:52:52	2021-09-28 23:52:57	\N	41b8eeca-1617-4ab0-9550-60cb92682330	35	\N
362	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-28 23:48:40	2021-09-28 23:48:40	2021-09-29 19:35:08	8f13f7d9-593d-4177-892e-9461f11323d0	\N	\N
378	\N	105	2	craft\\elements\\Entry	t	f	2021-10-01 20:33:22	2021-10-01 20:33:23	\N	f0be2407-fbcf-4dbf-996c-ecfb491a200e	14	\N
379	53	\N	2	craft\\elements\\Entry	t	f	2021-10-04 22:28:14	2021-10-04 22:28:14	\N	e049d4af-07ca-4e46-be0d-3f082e6ad7fa	\N	\N
380	\N	\N	17	craft\\elements\\Asset	t	f	2021-10-08 00:35:09	2021-10-08 00:35:09	\N	34fdf27a-b50b-4f6f-8606-cc6598a730f1	\N	\N
374	\N	\N	2	craft\\elements\\Entry	t	f	2021-10-01 20:05:41	2021-10-01 20:06:06	2021-10-01 20:06:18	4a4e11d1-e25a-45fd-b69b-26e59b2d7827	\N	\N
375	\N	104	2	craft\\elements\\Entry	t	f	2021-10-01 20:06:06	2021-10-01 20:06:06	2021-10-01 20:06:18	995a20ce-638d-4519-b293-0d6867b310d8	374	\N
383	\N	106	2	craft\\elements\\Entry	t	f	2021-10-08 22:40:17	2021-10-08 22:40:17	\N	69d75408-0400-4b9b-a65c-07807e656f13	14	\N
382	\N	\N	4	craft\\elements\\Asset	t	f	2021-10-08 22:40:04	2021-10-08 22:40:04	2021-10-08 22:40:08	d6e516c2-beea-4dfb-8341-f9e277564a04	\N	\N
373	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-29 19:40:13	2021-10-08 22:40:42	\N	e950b54c-df1d-49da-8b28-ec7ededffab7	\N	\N
384	\N	\N	4	craft\\elements\\Asset	t	f	2021-10-08 22:40:37	2021-10-08 22:40:37	2021-10-08 22:40:42	b0abbf2d-ee7a-4e31-91f7-a94a4306c124	\N	\N
369	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-29 19:39:40	2021-10-08 22:42:31	\N	eb26d2b4-296b-48cf-8266-d527abac1ad5	\N	\N
387	\N	\N	4	craft\\elements\\Asset	t	f	2021-10-08 22:42:27	2021-10-08 22:42:27	2021-10-08 22:42:31	0727ce36-ad82-4dd9-8269-3f4c192ba3c0	\N	\N
386	\N	107	2	craft\\elements\\Entry	t	f	2021-10-08 22:40:48	2021-10-08 22:40:48	\N	cacfa027-fa3d-47b8-9e8f-498b44751507	23	\N
390	\N	\N	4	craft\\elements\\Asset	t	f	2021-10-08 22:42:47	2021-10-08 22:42:47	2021-10-08 22:42:51	3a3f28bf-2988-4c91-9860-0eb7e8c0e794	\N	\N
27	\N	\N	2	craft\\elements\\Entry	t	f	2021-06-15 17:51:12	2021-10-08 22:42:36	\N	9ce253ec-e279-49ab-8036-8d11192dbdac	\N	\N
389	\N	108	2	craft\\elements\\Entry	t	f	2021-10-08 22:42:36	2021-10-08 22:42:36	\N	f92b5b5d-c031-481d-b7ce-8509577040a8	27	\N
392	\N	109	2	craft\\elements\\Entry	t	f	2021-10-08 22:42:54	2021-10-08 22:42:55	\N	d708d208-e638-433c-bd56-7912308facd3	31	\N
371	\N	\N	4	craft\\elements\\Asset	t	f	2021-09-29 19:39:57	2021-10-08 22:43:12	\N	f0f43201-5034-4e34-86b2-bad1b202be53	\N	\N
393	\N	\N	4	craft\\elements\\Asset	t	f	2021-10-08 22:43:09	2021-10-08 22:43:09	2021-10-08 22:43:12	8738f30a-b7ba-4dce-964f-56f919ae74f2	\N	\N
443	\N	\N	17	craft\\elements\\Asset	t	f	2021-10-22 22:20:36	2021-10-22 22:20:36	2021-10-26 17:02:07	6b999ccd-d952-44c7-b898-211414731946	\N	\N
444	\N	\N	17	craft\\elements\\Asset	t	f	2021-10-25 21:50:50	2021-10-25 21:50:50	2021-10-26 17:02:08	df250d09-0fe3-4450-bb21-4b146eed079d	\N	\N
396	\N	110	2	craft\\elements\\Entry	t	f	2021-10-08 22:43:16	2021-10-08 22:43:16	\N	fb6ac5ed-c5a7-43f0-ad13-d5e22e4a3c8b	35	\N
14	\N	\N	2	craft\\elements\\Entry	t	f	2021-06-15 17:17:51	2021-10-08 22:43:20	\N	b74a0ac9-e655-4a71-af55-e618ff602208	\N	\N
397	\N	111	2	craft\\elements\\Entry	t	f	2021-10-08 22:43:20	2021-10-08 22:43:20	\N	27dae4f7-7a3b-45a6-9912-edf1713001a4	14	\N
398	\N	\N	17	craft\\elements\\Asset	t	f	2021-10-08 23:03:44	2021-10-08 23:03:44	\N	958e4cd8-d092-45af-97d3-0f50ee24fcfd	\N	\N
242	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-08-30 21:32:33	2021-10-08 23:08:17	\N	854c9b28-8412-48b6-80f5-4c8dda7d7aed	\N	\N
429	\N	118	6	craft\\elements\\Entry	t	f	2021-10-08 23:08:16	2021-10-08 23:08:17	\N	aa593e0b-4152-447e-8703-c27f3cc55e8c	227	\N
430	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:08:17	2021-10-08 23:08:17	\N	e45d2f9d-a3dc-4416-a289-aa10b45fb665	232	\N
431	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:08:17	2021-10-08 23:08:17	\N	f12be6ce-5b9a-412d-b461-c30e89c68d6d	236	\N
432	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:08:17	2021-10-08 23:08:17	\N	15713b0c-b276-44f7-b65c-284f5fea0c51	242	\N
445	\N	\N	17	craft\\elements\\Asset	t	f	2021-10-26 17:15:00	2021-10-26 17:15:00	\N	cd6be515-c24d-4c88-821f-f3ed59fc50c3	\N	\N
97	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:43:41	2021-10-08 23:07:33	\N	9ef8f9f5-05e1-446e-8822-ce45a9a23641	\N	\N
98	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-07-16 18:43:41	2021-10-08 23:07:33	\N	7b93a5ec-839e-404a-8130-272cae8f16f2	\N	\N
420	\N	117	6	craft\\elements\\Entry	t	f	2021-10-08 23:07:33	2021-10-08 23:07:34	\N	5062efee-9fae-442c-aa92-435aac797c2c	95	\N
421	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:07:34	2021-10-08 23:07:34	\N	e47c130f-68dc-40f3-ad15-90fe9f0b8aa4	96	\N
422	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:07:34	2021-10-08 23:07:34	\N	797af371-5ef9-4cfb-bd62-2f95dedcc93b	97	\N
423	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:07:34	2021-10-08 23:07:34	\N	04d950bf-1ca0-460d-a9a4-fc4e2d51b93b	98	\N
424	\N	\N	17	craft\\elements\\Asset	t	f	2021-10-08 23:07:57	2021-10-08 23:07:57	\N	d0bf3663-4ce8-476d-93fe-a95aa5b824ea	\N	\N
437	\N	119	6	craft\\elements\\Entry	t	f	2021-10-08 23:08:48	2021-10-08 23:08:49	\N	5d97a746-310e-4842-b4f3-8b9059e8562a	298	\N
438	\N	\N	8	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:08:49	2021-10-08 23:08:49	\N	13f76854-be13-44b9-96f9-ee2a9f8e6ce7	302	\N
439	\N	\N	14	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:08:49	2021-10-08 23:08:49	\N	86700ee1-56a6-4f5a-a752-b784d55a5d71	305	\N
440	\N	\N	13	craft\\elements\\MatrixBlock	t	f	2021-10-08 23:08:49	2021-10-08 23:08:50	\N	88f5d816-89bf-4857-9ef8-523f8eb27071	310	\N
308	\N	\N	16	craft\\elements\\Entry	t	f	2021-09-08 18:26:41	2021-10-22 19:53:58	\N	fb9615c0-e975-41b8-a149-671aff4fa240	\N	\N
442	\N	120	16	craft\\elements\\Entry	t	f	2021-10-22 19:53:58	2021-10-22 19:54:05	\N	120aeab7-06ef-41cc-877d-302888ab42f3	308	\N
\.


--
-- TOC entry 4588 (class 0 OID 16574)
-- Dependencies: 226
-- Data for Name: elements_sites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.elements_sites (id, "elementId", "siteId", slug, uri, enabled, "dateCreated", "dateUpdated", uid) FROM stdin;
1	1	1	\N	\N	t	2021-05-19 21:09:33	2021-05-19 21:09:33	7cda788c-48bb-44ce-9a6c-129466561556
2	2	1	catalog-data	hips-catalogs/catalog-data	t	2021-05-19 21:19:04	2021-05-19 21:19:05	c79dbddd-7cda-4d5f-8ffb-8cce3e895b30
3	3	1	__temp_evrzpzgcpethpqmdatvmjwitqytkxncfwgaw	catalog/__temp_evrzpzgcpethpqmdatvmjwitqytkxncfwgaw	t	2021-05-19 22:50:51	2021-05-19 22:50:51	4b5d3c31-d572-4abb-91bf-48b80e58f397
4	4	1	__temp_ignhzbtrxqwizdkionwdqgqexnhfusgiqkdj	catalog/__temp_ignhzbtrxqwizdkionwdqgqexnhfusgiqkdj	t	2021-05-19 22:52:54	2021-05-19 22:52:54	7fb994c3-2514-48d0-825e-9c0d2b959183
5	5	1	allsky-hips-catalog-data	catalog/allsky-hips-catalog-data	t	2021-05-19 22:53:34	2021-05-19 22:53:43	55ab3df9-2d47-4a24-a4f6-8eedf246cdb6
6	6	1	\N	\N	t	2021-06-15 15:02:03	2021-06-15 15:02:03	e9905572-b7d3-4c79-8e64-ece1715e818c
7	6	2	\N	\N	t	2021-06-15 15:02:03	2021-06-15 15:02:03	10bf2bd4-9c5f-4d96-ba23-811994c061bf
8	2	2	catalog-data	hips-catalogs/catalog-data	t	2021-06-15 16:41:05	2021-06-15 16:41:05	a2c90811-5ce0-4844-8828-c88c3ff58409
13	9	1	stars-catalog	catalog/stars-catalog	t	2021-06-15 16:50:17	2021-06-15 16:50:17	fcac81f8-922d-42e0-9660-5c3b01adb004
14	9	2	stars-catalog	catalog/stars-catalog	t	2021-06-15 16:50:17	2021-06-15 16:50:17	0ea732aa-5a26-4f3d-a1ab-830e30530cc5
12	8	2	stars-catalog	catalog/stars-catalog	t	2021-06-15 16:50:17	2021-06-15 16:50:19	751cf02a-a344-4d40-9b4d-c92383afb496
15	10	1	__temp_oiwlfgbxnzzylcjhnrdcrelfwippnbacrpil	catalog/__temp_oiwlfgbxnzzylcjhnrdcrelfwippnbacrpil	t	2021-06-15 16:58:55	2021-06-15 16:58:55	0e720a45-8f49-47ce-9372-a278ecddcb6a
16	10	2	__temp_oiwlfgbxnzzylcjhnrdcrelfwippnbacrpil	catalog/__temp_oiwlfgbxnzzylcjhnrdcrelfwippnbacrpil	t	2021-06-15 16:58:55	2021-06-15 16:58:55	a34fcc7d-1955-4df9-93aa-a075c2382fbf
17	11	1	__temp_wlmsgwxnqfwiyyaheimtfjazbxinsifesbdf	catalog/__temp_wlmsgwxnqfwiyyaheimtfjazbxinsifesbdf	t	2021-06-15 16:59:52	2021-06-15 16:59:52	d94653f7-b242-443e-86bf-902abbc8d65c
18	11	2	__temp_wlmsgwxnqfwiyyaheimtfjazbxinsifesbdf	catalog/__temp_wlmsgwxnqfwiyyaheimtfjazbxinsifesbdf	t	2021-06-15 16:59:52	2021-06-15 16:59:52	531c6a32-c36e-4eb6-a2f0-ade92edddc8d
19	12	1	stars-catalog	catalog/stars-catalog	t	2021-06-15 17:04:56	2021-06-15 17:04:56	2294a48f-d956-4a3b-bd52-24514c79681e
20	12	2	stars-catalog	catalog/stars-catalog	t	2021-06-15 17:04:56	2021-06-15 17:04:56	321389df-1c0f-4f3f-ab93-dcf7b7e25275
25	15	1	galaxies-catalog	catalog/galaxies-catalog	t	2021-06-15 17:17:51	2021-06-15 17:17:51	804f46a9-fd07-4440-ae75-44ed5c9fedac
26	15	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-06-15 17:17:51	2021-06-15 17:17:51	b3b94f35-1c30-4722-a9b9-a2aecbd38afe
27	16	1	stars-catalog	catalog/stars-catalog	t	2021-06-15 17:21:23	2021-06-15 17:21:23	4437270a-1d24-48b6-a0fe-d73e545fb571
28	16	2	stars-catalog	catalog/stars-catalog	t	2021-06-15 17:21:23	2021-06-15 17:21:23	ae326637-2e73-47a7-9e6b-66635424d13c
29	17	1	\N	\N	t	2021-06-15 17:23:21	2021-06-15 17:23:21	1618d269-9b14-40c4-a62b-884f6d2b5281
30	17	2	\N	\N	t	2021-06-15 17:23:21	2021-06-15 17:23:21	69713c5c-ca56-4c9e-8368-89472d4e45e6
31	18	1	stars-catalog	catalog/stars-catalog	t	2021-06-15 17:23:28	2021-06-15 17:23:28	8104c6bd-edf9-4137-992a-b2d733c6612a
32	18	2	stars-catalog	catalog/stars-catalog	t	2021-06-15 17:23:28	2021-06-15 17:23:28	e0de2a4c-c9d9-4958-986f-31bd3a7ca126
33	19	1	\N	\N	t	2021-06-15 17:23:44	2021-06-15 17:23:44	a9cefdfd-5f57-44fc-afd8-8a98f82a1ea0
34	19	2	\N	\N	t	2021-06-15 17:23:44	2021-06-15 17:23:44	cfdb81e2-e663-4f4c-b8de-c821ddd4e9d1
35	20	1	galaxies-catalog	catalog/galaxies-catalog	t	2021-06-15 17:23:49	2021-06-15 17:23:49	8a019e4e-cbf2-4699-b590-4485bf6989c9
36	20	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-06-15 17:23:49	2021-06-15 17:23:49	b311c60c-1c16-4fa2-a91b-b81b3eb7f9af
39	22	1	\N	\N	t	2021-06-15 17:34:12	2021-06-15 17:34:12	5ae65b15-a240-4aca-8c59-90ba35882d81
40	22	2	\N	\N	t	2021-06-15 17:34:13	2021-06-15 17:34:13	77e2b2c3-f2c3-44a8-a061-86339c2f3a85
43	24	1	nebulae-catalog	catalog/nebulae-catalog	t	2021-06-15 17:34:27	2021-06-15 17:34:27	87f623c7-f7fa-43cc-ae4d-abe010bf6841
44	24	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-06-15 17:34:27	2021-06-15 17:34:27	5f360a63-be4b-4f64-be4b-5a60bc931754
47	26	1	\N	\N	t	2021-06-15 17:51:02	2021-06-15 17:51:02	2b99c85b-cbb5-48e0-ac2a-bd25f769654e
48	26	2	\N	\N	t	2021-06-15 17:51:02	2021-06-15 17:51:02	abae3774-8449-4365-83c0-df1a6679a575
51	28	1	transients-catalog	catalog/transients-catalog	t	2021-06-15 17:51:12	2021-06-15 17:51:12	5a75e56a-f953-4352-b937-1ff6befbca40
52	28	2	transients-catalog	catalog/transients-catalog	t	2021-06-15 17:51:12	2021-06-15 17:51:12	9713cd42-b9a1-4230-b44a-f5fab4193f00
55	30	1	\N	\N	t	2021-06-15 17:54:39	2021-06-15 17:54:39	551f61b6-8e77-4932-acce-61ae580288a8
56	30	2	\N	\N	t	2021-06-15 17:54:39	2021-06-15 17:54:39	4895460c-6cfb-4b85-bc37-a2912f5dbd9b
59	32	1	goals-catalog	catalog/goals-catalog	t	2021-06-15 17:54:45	2021-06-15 17:54:45	ecb38334-90be-4e4a-a6ec-fb6cb2069c0e
60	32	2	goals-catalog	catalog/goals-catalog	t	2021-06-15 17:54:45	2021-06-15 17:54:45	5eb840f4-a2a8-419c-8597-3b4a95c1824a
63	34	1	\N	\N	t	2021-06-15 17:58:28	2021-06-15 17:58:28	55a8b97b-34d4-4d30-b269-e2d5491dcf3e
64	34	2	\N	\N	t	2021-06-15 17:58:28	2021-06-15 17:58:28	337f38d5-26bf-4a03-b297-b33170a6ed43
67	36	1	landmarks-catalog	catalog/landmarks-catalog	t	2021-06-15 17:58:33	2021-06-15 17:58:33	0cae7256-3b5d-41a0-af99-4190eaef70f7
68	36	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-06-15 17:58:33	2021-06-15 17:58:33	95c1ac47-0703-402b-9a1b-98f6df204aba
73	39	1	control-healpix-catalog	catalog/control-healpix-catalog	t	2021-06-15 18:07:52	2021-06-15 18:07:52	6596428a-7923-4cb3-8aaf-57e98df7873e
74	39	2	control-healpix-catalog	catalog/control-healpix-catalog	t	2021-06-15 18:07:52	2021-06-15 18:07:52	ef515997-7809-4534-ab7f-153ac1d61c00
49	27	1	nebula	catalog/nebula	t	2021-06-15 17:51:12	2021-10-08 22:42:38	502de576-a487-48e2-b090-4e73a23ae660
50	27	2	transients-catalog	catalog/transients-catalog	t	2021-06-15 17:51:12	2021-10-08 22:42:38	fd8fe273-44e1-4516-acb7-c00349f555d9
42	23	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-06-15 17:34:27	2021-10-08 22:40:50	009fa402-c1d7-4352-8eb8-2e244a8cc06e
57	31	1	transient	catalog/transient	t	2021-06-15 17:54:44	2021-10-08 22:42:56	1e657bc1-90f0-45e8-801e-4460500e326a
24	14	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-06-15 17:17:51	2021-10-08 22:43:22	3168f653-0e3b-4352-9fb1-4585113129ee
58	31	2	goals-catalog	catalog/goals-catalog	t	2021-06-15 17:54:45	2021-10-08 22:42:56	76bdfd66-58c7-435d-83ca-0d1b56061fd7
65	35	1	landmarks	catalog/landmarks	t	2021-06-15 17:58:32	2021-10-08 22:43:18	fb1abe41-6f0e-4bc8-a247-bc8f266f8aac
66	35	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-06-15 17:58:33	2021-10-08 22:43:18	c610d41d-f46c-4e6e-b576-9e3b67ecc0f2
23	14	1	stars	catalog/stars	t	2021-06-15 17:17:51	2021-10-08 22:43:22	234a6bb8-9487-4143-86ff-351074f463ed
41	23	1	galaxy	catalog/galaxy	t	2021-06-15 17:34:27	2021-10-08 22:40:50	b7ad8891-f58d-4579-9835-bcd832bcf423
71	38	1	control-healpix-catalog	catalog/control-healpix-catalog	t	2021-06-15 18:07:52	2021-06-15 18:07:54	9ad1662f-3c60-461b-837a-79046de5a1cc
72	38	2	control-healpix-catalog	catalog/control-healpix-catalog	t	2021-06-15 18:07:52	2021-06-15 18:07:54	c541ce2c-c269-45f6-b7af-73c785dd7e06
79	42	1	akari-catalog	catalog/akari-catalog	t	2021-06-15 18:11:30	2021-06-15 18:11:30	d65d8641-b552-417e-a61c-6dbbc51e5229
80	42	2	akari-catalog	catalog/akari-catalog	t	2021-06-15 18:11:30	2021-06-15 18:11:30	3992ef92-932a-4710-a154-093aad4855a1
77	41	1	akari-catalog	catalog/akari-catalog	t	2021-06-15 18:11:30	2021-06-15 18:11:31	f06ae509-cf32-4a13-947e-c3ce1a0c9c02
78	41	2	akari-catalog	catalog/akari-catalog	t	2021-06-15 18:11:30	2021-06-15 18:11:31	4b8c20ad-35b0-47ed-a68a-3b105f340b67
81	43	1	__temp_xzbqvoiognclacxxyvdpslfigzmwlgbijarh	explorer/__temp_xzbqvoiognclacxxyvdpslfigzmwlgbijarh	t	2021-06-15 21:36:09	2021-06-15 21:36:09	eccf6644-5ca8-49b3-94c3-e6e7979542ff
82	43	2	__temp_xzbqvoiognclacxxyvdpslfigzmwlgbijarh	explorer/__temp_xzbqvoiognclacxxyvdpslfigzmwlgbijarh	t	2021-06-15 21:36:09	2021-06-15 21:36:09	58c3eeca-d65f-4fe7-9b1c-fd644543ae51
87	46	1	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-06-15 21:38:14	2021-06-15 21:38:14	0946ac39-a743-4c45-9439-4453c197d116
88	46	2	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-06-15 21:38:14	2021-06-15 21:38:14	e9db7e10-7864-4eaa-ac8f-42d68b988547
89	47	1	__temp_cvhzapxbptraqzfbykkwjsikueriruymzvbh	astro-tour/__temp_cvhzapxbptraqzfbykkwjsikueriruymzvbh	t	2021-06-21 22:42:31	2021-06-21 22:42:31	2c6b750c-9d3e-4a49-8462-7aaedfaca869
90	47	2	__temp_cvhzapxbptraqzfbykkwjsikueriruymzvbh	astro-tour/__temp_cvhzapxbptraqzfbykkwjsikueriruymzvbh	t	2021-06-21 22:42:31	2021-06-21 22:42:31	4ce95490-a2fa-4e27-a468-9fc743a32428
93	49	1	\N	\N	t	2021-06-21 23:02:56	2021-06-21 23:02:56	c9f3724f-61bb-4173-9a5e-39800ca9ce0a
94	49	2	\N	\N	t	2021-06-21 23:02:56	2021-06-21 23:02:56	7a17f616-6be8-4225-b830-ea51ba9ebf56
95	50	1	\N	\N	t	2021-06-21 23:03:21	2021-06-21 23:03:21	a146fc52-857c-438d-a4fb-c510689069e3
96	50	2	\N	\N	t	2021-06-21 23:03:21	2021-06-21 23:03:21	1d5b6760-9762-43c0-9809-150fb270a3de
99	52	1	\N	\N	t	2021-06-21 23:04:33	2021-06-21 23:04:33	35785337-13d5-40ce-8fb6-348ac5dc0e16
100	52	2	\N	\N	t	2021-06-21 23:04:33	2021-06-21 23:04:33	d22758a5-4991-4fbb-b55f-e388467f4ef4
101	53	1	\N	\N	t	2021-06-21 23:04:33	2021-06-21 23:04:33	ddcb16b5-3cd7-4eb7-ab63-d7a05dc9add5
102	53	2	\N	\N	t	2021-06-21 23:04:33	2021-06-21 23:04:33	3db8b5f4-ed45-4b35-9520-cc065fbfee3f
103	54	1	alien-hunting	tour-intro/alien-hunting	t	2021-06-21 23:04:33	2021-06-21 23:04:33	8d01cec4-9cfe-4284-b0bb-bbaf9d7bed5f
104	54	2	alien-hunting	tour-intro/alien-hunting	t	2021-06-21 23:04:33	2021-06-21 23:04:33	7edb92c1-4a0c-4d35-8900-876af35c8af3
105	55	1	\N	\N	t	2021-06-21 23:04:33	2021-06-21 23:04:33	13877352-e09a-4879-aa06-8f63d68d45ca
106	55	2	\N	\N	t	2021-06-21 23:04:33	2021-06-21 23:04:33	829c03c8-a51e-41a2-a007-db5fd0a0644f
107	56	1	\N	\N	t	2021-06-21 23:04:33	2021-06-21 23:04:33	a97715cf-904e-42c8-b39d-fb09dceb1f5b
108	56	2	\N	\N	t	2021-06-21 23:04:33	2021-06-21 23:04:33	efedb4bf-3917-405f-b782-0221fbd45d84
97	51	1	alien-hunting	tour-intro/alien-hunting	t	2021-06-21 23:04:33	2021-06-21 23:04:34	69c19e57-2971-4feb-80b5-18d70014ee98
98	51	2	alien-hunting	tour-intro/alien-hunting	t	2021-06-21 23:04:33	2021-06-21 23:04:34	ab97f51d-913c-46cb-988f-f18e016ee062
111	58	1	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	01778a45-dd92-4fb9-8bbf-2cd35a186c14
112	58	2	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	7fc6c054-e03e-4a7e-8362-c2636cfd78dd
113	59	1	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	9d6af474-9918-4745-b27c-b07ef2537ce0
114	59	2	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	90f76bcd-f774-4631-bc6e-2ad85f0f9a8b
115	60	1	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	a5627d16-005f-423f-8659-e9477ad21b0b
116	60	2	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	95aac126-4b71-457d-aba7-5dd109b81458
117	61	1	why-aliens	tour-fact/why-aliens	t	2021-06-21 23:06:50	2021-06-21 23:06:50	ef7634e9-de4c-46d5-a20a-37366b4739ab
118	61	2	why-aliens	tour-fact/why-aliens	t	2021-06-21 23:06:50	2021-06-21 23:06:50	780bc246-7331-45da-b848-a1872f6c66d9
119	62	1	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	fdda737f-c205-4418-98ad-3cfbe3062cb4
120	62	2	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	35e851ba-623f-4dee-92be-7288b730d226
121	63	1	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	94fb8dc5-8e64-4a81-9723-1193a85ebe7c
122	63	2	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	db31f86d-c70f-4bb3-8b8c-aa0dad1f2eb3
123	64	1	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	deff2d2f-8a66-4a99-992f-4a477e5266f0
124	64	2	\N	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	4297c444-bcab-42dd-8902-fe43a622fd8b
109	57	1	why-aliens	tour-fact/why-aliens	t	2021-06-21 23:06:50	2021-06-21 23:06:51	7d0d9629-df81-4e3e-a642-0be5cf196c35
110	57	2	why-aliens	tour-fact/why-aliens	t	2021-06-21 23:06:50	2021-06-21 23:06:51	c29b3b9a-eec9-401c-932b-cf9abf2748e2
127	66	1	the-mothership	tour-point-of-interest/the-mothership	t	2021-06-21 23:15:44	2021-06-21 23:15:44	8f1dd577-fe64-481b-adc4-b8f6771b9188
128	66	2	the-mothership	tour-point-of-interest/the-mothership	t	2021-06-21 23:15:45	2021-06-21 23:15:45	d8dc8e2c-afbe-4e18-9e96-75e64c712e56
131	68	1	the-search-for-aliens	astro-tour/the-search-for-aliens	t	2021-06-21 23:15:49	2021-06-21 23:15:49	147ea2b8-7649-4033-998e-9f808511f720
132	68	2	the-search-for-aliens	astro-tour/the-search-for-aliens	t	2021-06-21 23:15:49	2021-06-21 23:15:49	54557e94-b424-4fd8-ad88-c7132667a971
133	69	1	\N	\N	t	2021-06-22 21:51:07	2021-06-22 21:51:07	b72db763-5e2c-4fed-96e6-9e753626e596
134	69	2	\N	\N	t	2021-06-22 21:51:07	2021-06-22 21:51:07	dae4d082-f87d-4198-b4c5-f9d6c46cbac6
135	70	1	the-search-for-aliens	tour/the-search-for-aliens	t	2021-06-22 21:51:08	2021-06-22 21:51:08	d43c1ac4-5ab8-47a6-8d0f-c9ca8831ef68
136	70	2	the-search-for-aliens	tour/the-search-for-aliens	t	2021-06-22 21:51:08	2021-06-22 21:51:08	7757f25f-2318-4969-b33a-467dede50062
137	71	1	\N	\N	t	2021-06-22 21:51:08	2021-06-22 21:51:08	5b2e2943-4ded-4cc5-8d9e-e2449df97d21
138	71	2	\N	\N	t	2021-06-22 21:51:08	2021-06-22 21:51:08	9c4d90c1-775f-4d23-86ee-23c729ac294e
139	72	1	\N	\N	t	2021-06-22 21:51:45	2021-06-22 21:51:45	c063fb14-f5cd-40f7-8aa4-175626dd4d1b
140	72	2	\N	\N	t	2021-06-22 21:51:45	2021-06-22 21:51:45	329900e7-e4c6-466c-b5e1-54605815e451
126	65	2	the-mothership	tour-point-of-interest/the-mothership	t	2021-06-21 23:15:44	2021-07-23 22:53:51	fb0285f0-2c0e-4435-82c6-0a23be38a19c
130	67	2	the-search-for-aliens	tour/the-search-for-aliens	t	2021-06-21 23:15:49	2021-10-08 23:06:46	86e11bb8-a4ef-4621-97da-48efaee9d1e8
85	45	1	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-06-15 21:38:14	2021-09-16 20:37:21	30f22908-2ad7-4021-87f6-0c1c7c439c6a
86	45	2	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-06-15 21:38:14	2021-09-16 20:37:21	f82c6345-9f7d-470b-9dd3-1171acca1bf0
129	67	1	the-search-for-aliens	tour/the-search-for-aliens	t	2021-06-21 23:15:49	2021-10-08 23:06:46	0beaad43-2bca-4cac-a1ea-92e05031adad
141	73	1	\N	\N	t	2021-06-22 21:51:45	2021-06-22 21:51:45	84e22ad0-ddf0-4aa6-85c9-2fdfc669f2e9
142	73	2	\N	\N	t	2021-06-22 21:51:45	2021-06-22 21:51:45	d218ff0c-a6ca-46d6-81b4-61a4b3a2504e
143	74	1	the-search-for-aliens	tour/the-search-for-aliens	t	2021-06-22 21:51:45	2021-06-22 21:51:45	f195a2d0-1c00-461d-af5f-57f0be3ddfd0
144	74	2	the-search-for-aliens	tour/the-search-for-aliens	t	2021-06-22 21:51:45	2021-06-22 21:51:45	06126a6c-600c-4d9a-be81-8edc20c1c985
145	75	1	\N	\N	t	2021-06-22 21:51:45	2021-06-22 21:51:45	094685f3-2876-4287-9ce2-888017dcedcf
146	75	2	\N	\N	t	2021-06-22 21:51:45	2021-06-22 21:51:45	79835131-09ba-4964-a0b3-150dc2a96290
147	76	1	\N	\N	t	2021-06-22 21:51:45	2021-06-22 21:51:45	71d57920-73fd-4963-88bd-5e845aec8cec
148	76	2	\N	\N	t	2021-06-22 21:51:45	2021-06-22 21:51:45	7f1f76b1-9d55-44dd-84c1-5736e19a18e2
149	77	1	\N	\N	t	2021-06-22 21:51:45	2021-06-22 21:51:45	32911632-c91f-4c81-9310-6c0362cc930c
150	77	2	\N	\N	t	2021-06-22 21:51:45	2021-06-22 21:51:45	08a1ef12-cd0b-428e-9ff0-366422c84347
151	78	1	\N	\N	t	2021-06-28 17:39:27	2021-06-28 17:39:27	47d31adb-dbce-45c1-af19-f631481c70ff
152	79	1	\N	\N	t	2021-06-28 17:41:30	2021-06-28 17:41:30	1476fffe-11d7-4875-a6b0-7f40bdfc8666
153	80	1	\N	\N	t	2021-06-28 17:42:18	2021-06-28 17:42:18	29676ba7-1ea2-4b41-b38a-450f521dd4f9
158	83	1	tester	catalog/tester	t	2021-07-16 17:53:05	2021-07-16 17:53:05	d99611b1-0309-4008-91fa-f550447dd820
159	83	2	tester	catalog/tester	t	2021-07-16 17:53:05	2021-07-16 17:53:05	01d441a9-820f-435e-b66e-17a427545553
156	82	1	tester	catalog/tester	t	2021-07-16 17:53:05	2021-07-16 17:53:07	5639e2b0-242a-4eb2-9577-08a397427697
157	82	2	tester	catalog/tester	t	2021-07-16 17:53:05	2021-07-16 17:53:07	320e3723-4811-4aad-a4fd-80c7d48f3f2b
160	84	1	__temp_rsvcttdjtmsxoibthovpwyunadbivposekgt	catalog/__temp_rsvcttdjtmsxoibthovpwyunadbivposekgt	t	2021-07-16 18:41:34	2021-07-16 18:41:34	54da6024-4ff1-4393-a987-f6608842dcb7
161	84	2	__temp_rsvcttdjtmsxoibthovpwyunadbivposekgt	catalog/__temp_rsvcttdjtmsxoibthovpwyunadbivposekgt	t	2021-07-16 18:41:34	2021-07-16 18:41:34	43217c5c-93fd-41b4-adee-2af5fda39feb
164	86	1	\N	\N	t	2021-07-16 18:42:19	2021-07-16 18:42:19	a4eab564-209e-4614-8c9f-c209b58d0483
165	86	2	\N	\N	t	2021-07-16 18:42:19	2021-07-16 18:42:19	fce9f2fc-6fbb-421f-9b45-5212e0bc58ce
168	88	1	\N	\N	t	2021-07-16 18:42:31	2021-07-16 18:42:31	e662cec3-6069-4244-87a4-6493390c48a4
169	88	2	\N	\N	t	2021-07-16 18:42:31	2021-07-16 18:42:31	bf7735f0-d67b-411c-97b4-751996ed7227
172	90	1	\N	\N	t	2021-07-16 18:42:36	2021-07-16 18:42:36	bd3e18e1-f6ad-4600-8c53-abf3f67a0872
173	90	2	\N	\N	t	2021-07-16 18:42:36	2021-07-16 18:42:36	2b5651c7-388b-4aaf-a178-639ade0dc344
174	91	1	\N	\N	t	2021-07-16 18:42:41	2021-07-16 18:42:41	9bdea200-bb9a-4d4e-9eab-2c3e0ffe05ba
175	91	2	\N	\N	t	2021-07-16 18:42:41	2021-07-16 18:42:41	e074718d-23f2-4b4b-bf9a-f7d4ab7af00f
178	93	1	check-out-this-tour	astro-object/check-out-this-tour	t	2021-07-16 18:43:23	2021-07-16 18:43:23	517e93e7-0128-4c84-97a3-2fc1033b6240
179	93	2	check-out-this-tour	astro-object/check-out-this-tour	t	2021-07-16 18:43:23	2021-07-16 18:43:23	e5977c0f-c974-4f50-87e4-cab6a9ab5143
176	92	1	check-out-this-tour	astro-object/check-out-this-tour	t	2021-07-16 18:43:22	2021-07-16 18:43:23	66e93154-9997-4926-bd82-2a43b34c4ae7
177	92	2	check-out-this-tour	astro-object/check-out-this-tour	t	2021-07-16 18:43:23	2021-07-16 18:43:23	3be30496-f2a1-4bab-903e-243a5ced692c
184	96	1	\N	\N	t	2021-07-16 18:43:41	2021-07-16 18:43:41	30445f5e-9951-4187-bb1b-a4f8d5cad425
185	96	2	\N	\N	t	2021-07-16 18:43:41	2021-07-16 18:43:41	13ff327b-2c67-42a4-a2e7-d4749a4636f2
186	97	1	\N	\N	t	2021-07-16 18:43:41	2021-07-16 18:43:41	9e4a7eed-28c4-49ad-a31f-091d070cc795
187	97	2	\N	\N	t	2021-07-16 18:43:41	2021-07-16 18:43:41	fd1ea19b-0636-4747-94f2-fe1bb1e72ded
188	98	1	\N	\N	t	2021-07-16 18:43:41	2021-07-16 18:43:41	793a2098-472a-43d7-bd5f-1caf7c23f3c9
189	98	2	\N	\N	t	2021-07-16 18:43:41	2021-07-16 18:43:41	8fdacd13-a9d5-42cc-9960-79cc8f0d08a4
190	99	1	tour-de-force	tour/tour-de-force	t	2021-07-16 18:43:41	2021-07-16 18:43:41	b252e534-ed49-426f-b15c-2ef404987075
191	99	2	tour-de-force	tour/tour-de-force	t	2021-07-16 18:43:42	2021-07-16 18:43:42	40481762-cdb6-414e-a297-8e4bc84ad240
192	100	1	\N	\N	t	2021-07-16 18:43:42	2021-07-16 18:43:42	e443c8fb-b7f3-4ef4-8fe2-f263057b9d56
193	100	2	\N	\N	t	2021-07-16 18:43:42	2021-07-16 18:43:42	6f4cc16c-1e27-4741-b4d3-5c85584d6c42
194	101	1	\N	\N	t	2021-07-16 18:43:42	2021-07-16 18:43:42	0611d2fe-77d3-4b2c-872c-5e16eb6f8995
195	101	2	\N	\N	t	2021-07-16 18:43:42	2021-07-16 18:43:42	c7783d20-c32b-4e1f-8bc2-01cafc66a104
196	102	1	\N	\N	t	2021-07-16 18:43:42	2021-07-16 18:43:42	a6ebbb74-29fd-433a-b195-97c4f8a34944
197	102	2	\N	\N	t	2021-07-16 18:43:42	2021-07-16 18:43:42	b1cd99b3-a086-4ee0-b944-88d9b1958919
198	103	1	check-out-this-tour	astro-object/check-out-this-tour	t	2021-07-16 18:45:50	2021-07-16 18:45:50	cfb6372e-ae56-46ae-a184-a76068b51659
199	103	2	check-out-this-tour	astro-object/check-out-this-tour	t	2021-07-16 18:45:50	2021-07-16 18:45:50	338e5352-5d14-4813-a93a-9096889208bd
200	104	1	tour-de-force	tour/tour-de-force	t	2021-07-16 18:45:52	2021-07-16 18:45:52	916f09f9-3b2a-4a8a-86c6-86ac8dbbd831
201	104	2	tour-de-force	tour/tour-de-force	t	2021-07-16 18:45:52	2021-07-16 18:45:52	2f02bdc2-0702-4e1d-9585-4dd6d66921da
202	105	1	\N	\N	t	2021-07-16 18:45:52	2021-07-16 18:45:52	e564d4cd-cdf7-4f72-afdd-fee59a6134bc
203	105	2	\N	\N	t	2021-07-16 18:45:53	2021-07-16 18:45:53	65fa73ff-1159-4a71-a68e-df2d32dec5ad
204	106	1	\N	\N	t	2021-07-16 18:45:53	2021-07-16 18:45:53	399712bf-9511-41bb-b2ce-d5f10d52ca9e
205	106	2	\N	\N	t	2021-07-16 18:45:53	2021-07-16 18:45:53	4895b5bc-0547-4f58-a82f-561de3e8609c
206	107	1	\N	\N	t	2021-07-16 18:45:53	2021-07-16 18:45:53	b2f79edc-aa0a-4c17-a089-c86e5872bb86
207	107	2	\N	\N	t	2021-07-16 18:45:53	2021-07-16 18:45:53	7dbb60b8-6024-4ef5-9978-da746191edae
208	108	1	the-search-for-aliens	tour/the-search-for-aliens	t	2021-07-19 22:32:06	2021-07-19 22:32:06	58852d83-62f4-4137-8f92-9d0b6c9a0016
209	108	2	the-search-for-aliens	tour/the-search-for-aliens	t	2021-07-19 22:32:15	2021-07-19 22:32:15	a7087f7d-ba3a-49d8-8db2-f728ea19bfb0
210	109	1	\N	\N	t	2021-07-19 22:32:19	2021-07-19 22:32:19	84c3c8b1-6ef1-4815-8767-15e71acb1485
211	109	2	\N	\N	t	2021-07-19 22:32:22	2021-07-19 22:32:22	16cf5554-25db-469f-91e3-d3231a9eef4b
212	110	1	\N	\N	t	2021-07-19 22:32:25	2021-07-19 22:32:25	83b05a6e-5b5a-418f-bc6f-ba2d868978da
213	110	2	\N	\N	t	2021-07-19 22:32:28	2021-07-19 22:32:28	7131f6ce-1352-4fb6-9bf4-fdb8e0c6f0d6
214	111	1	\N	\N	t	2021-07-19 22:32:30	2021-07-19 22:32:30	06f28162-0a15-47eb-b8e1-a85ba699541c
215	111	2	\N	\N	t	2021-07-19 22:32:33	2021-07-19 22:32:33	5617cad8-1141-4c1a-a117-46b6fb59020c
125	65	1	the-mothership	tour-point-of-interest/the-mothership	t	2021-06-21 23:15:44	2021-07-23 22:53:50	4bc2d7d2-08cf-4efe-b705-93bea0514c5f
216	112	1	\N	\N	t	2021-07-26 16:36:00	2021-07-26 16:36:00	63cdf179-1b29-474c-94bb-e1431d1d3ff0
183	95	2	tour-de-force	tour/tour-de-force	t	2021-07-16 18:43:41	2021-10-08 23:07:37	31ef0dc2-eae6-4a94-9c0a-a7ac82405788
217	113	1	\N	\N	t	2021-07-26 17:36:47	2021-07-26 17:36:47	031d51ea-046f-4860-96ba-c10c729a0dc0
220	115	1	\N	\N	t	2021-08-06 22:19:57	2021-08-06 22:19:57	e82ef178-a0b6-4f7d-a67a-776a2873227b
221	115	2	\N	\N	t	2021-08-06 22:19:57	2021-08-06 22:19:57	75be2e52-21d0-4449-b06f-a2b13be5eb4b
222	116	1	\N	\N	t	2021-08-06 22:19:57	2021-08-06 22:19:57	cdc9af8d-335e-4084-8caa-9d2ef2cc0abf
223	116	2	\N	\N	t	2021-08-06 22:19:57	2021-08-06 22:19:57	ae4a58d5-4786-44c0-b1ab-498888d76faf
224	117	1	\N	\N	t	2021-08-06 22:19:58	2021-08-06 22:19:58	9fd85736-1f36-4243-8910-4f6c1e83d26c
225	117	2	\N	\N	t	2021-08-06 22:19:58	2021-08-06 22:19:58	8a4ffa36-5e12-483f-9835-b6a48a91669f
226	118	1	\N	\N	t	2021-08-06 22:19:58	2021-08-06 22:19:58	a856142a-b951-463e-82a5-b232b374e9af
227	118	2	\N	\N	t	2021-08-06 22:19:58	2021-08-06 22:19:58	84816762-fa48-4064-b675-3385664440ea
228	119	1	\N	\N	t	2021-08-06 22:19:58	2021-08-06 22:19:58	f4b55052-c1e3-4910-9bf3-19a71da3d003
229	119	2	\N	\N	t	2021-08-06 22:19:58	2021-08-06 22:19:58	b8458d29-b3ca-4f14-b7e1-c84608a0d87f
230	120	1	\N	\N	t	2021-08-06 22:19:58	2021-08-06 22:19:58	cbfa3661-3038-4193-85b7-71b3566230e2
231	120	2	\N	\N	t	2021-08-06 22:19:58	2021-08-06 22:19:58	1c033c68-1d54-448c-8161-2f5bb04f49d5
232	121	1	stars-catalog	catalog/stars-catalog	t	2021-08-06 22:23:02	2021-08-06 22:23:02	0d16fc96-d3d1-4d0d-89d3-0bffed10463e
233	121	2	stars-catalog	catalog/stars-catalog	t	2021-08-06 22:23:03	2021-08-06 22:23:03	fce3b530-1bed-4cd8-b648-8a060990f774
234	122	1	galaxies-catalog	catalog/galaxies-catalog	t	2021-08-06 22:23:19	2021-08-06 22:23:19	d6c7bdff-a89a-453d-8277-2a5bb9ccbb7f
235	122	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-08-06 22:23:19	2021-08-06 22:23:19	382a4c8e-3de3-492a-b58b-bfebaff8ec6c
236	123	1	stars-catalog	catalog/stars-catalog	t	2021-08-06 22:23:24	2021-08-06 22:23:24	fe3f469c-61ee-44ea-a270-3bff6880e084
237	123	2	stars-catalog	catalog/stars-catalog	t	2021-08-06 22:23:25	2021-08-06 22:23:25	04b2fe0e-1739-4878-86f5-057b6ffec730
238	124	1	nebulae-catalog	catalog/nebulae-catalog	t	2021-08-06 22:23:40	2021-08-06 22:23:40	ef0089f8-a0ae-4b3d-9cd0-2e9ea8745fae
239	124	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-08-06 22:23:40	2021-08-06 22:23:40	d1fdaa41-d551-4238-ae39-fee80ab281c2
240	125	1	transients-catalog	catalog/transients-catalog	t	2021-08-06 22:23:52	2021-08-06 22:23:52	2de40248-663c-4241-ba89-fd8194d87f4d
241	125	2	transients-catalog	catalog/transients-catalog	t	2021-08-06 22:23:53	2021-08-06 22:23:53	fcbd2fea-fef8-48ed-89d1-944ab894c409
242	126	1	goals-catalog	catalog/goals-catalog	t	2021-08-06 22:24:07	2021-08-06 22:24:07	60424761-2938-410d-88de-6817c5609b03
243	126	2	goals-catalog	catalog/goals-catalog	t	2021-08-06 22:24:07	2021-08-06 22:24:07	e83bad73-e20c-4ae9-8fdd-809308cfc1a0
244	127	1	landmarks-catalog	catalog/landmarks-catalog	t	2021-08-06 22:24:29	2021-08-06 22:24:29	c2a52b4a-2cfd-45d7-824c-b968a89c9406
245	127	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-08-06 22:24:29	2021-08-06 22:24:29	ed5904e6-958e-4131-97b7-d2f5b59f079f
246	128	1	stars-catalog	catalog/stars-catalog	t	2021-08-06 22:25:32	2021-08-06 22:25:32	4f767842-cfc9-44b3-b690-30054b203bf8
247	128	2	stars-catalog	catalog/stars-catalog	t	2021-08-06 22:25:32	2021-08-06 22:25:32	c6552e0f-4edc-468f-b297-57c9d0e6c833
248	129	1	galaxies-catalog	catalog/galaxies-catalog	t	2021-08-06 22:25:37	2021-08-06 22:25:37	32011741-4e50-493b-9060-1483958b565e
249	129	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-08-06 22:25:37	2021-08-06 22:25:37	bcb5f006-d604-4a37-b187-44c1c502af40
250	130	1	nebulae-catalog	catalog/nebulae-catalog	t	2021-08-06 22:25:41	2021-08-06 22:25:41	071b48a1-1c40-410f-91b6-d4c0f20c12de
251	130	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-08-06 22:25:41	2021-08-06 22:25:41	17fd054f-f44a-4ddb-896c-1f8d69152842
252	131	1	transients-catalog	catalog/transients-catalog	t	2021-08-06 22:25:45	2021-08-06 22:25:45	a0149246-63a2-48f0-9f54-fc7609487dca
253	131	2	transients-catalog	catalog/transients-catalog	t	2021-08-06 22:25:45	2021-08-06 22:25:45	054650bd-24c1-41a9-af57-79c12d634bcc
254	132	1	goals-catalog	catalog/goals-catalog	t	2021-08-06 22:25:54	2021-08-06 22:25:54	414ef527-c08c-449b-a67c-985ee97989e0
255	132	2	goals-catalog	catalog/goals-catalog	t	2021-08-06 22:25:54	2021-08-06 22:25:54	cd646318-eb6e-4677-8371-e3e8ae06b3ae
256	133	1	goals-catalog	catalog/goals-catalog	t	2021-08-06 22:25:59	2021-08-06 22:25:59	30f862d0-1e14-4cdf-821d-6b51d50b1575
257	133	2	goals-catalog	catalog/goals-catalog	t	2021-08-06 22:25:59	2021-08-06 22:25:59	f63fb5a0-ba80-41e1-a70b-fb8aa274212c
258	134	1	landmarks-catalog	catalog/landmarks-catalog	t	2021-08-06 22:26:07	2021-08-06 22:26:07	bc86ee9c-6293-474e-a601-c7f00f6a309d
259	134	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-08-06 22:26:08	2021-08-06 22:26:08	e072f6ec-e2dc-4848-9f48-c948387602db
260	135	1	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-08-06 22:26:30	2021-08-06 22:26:30	e7290719-3767-4416-adf7-86a1b3255106
261	135	2	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-08-06 22:26:30	2021-08-06 22:26:30	dc26df0c-6aba-401f-b361-0800a0ee9f0b
264	137	1	\N	\N	t	2021-08-06 22:54:52	2021-08-06 22:54:52	93e6a25c-b319-44af-b3c2-15644b2ccbe9
265	137	2	\N	\N	t	2021-08-06 22:54:52	2021-08-06 22:54:52	b9dc4378-1c25-40e4-8a3a-e03e9b2a5ce2
268	139	1	eric-test	guided-experiences/eric-test	t	2021-08-06 22:54:56	2021-08-06 22:54:56	13861b77-2111-45ee-ad29-9954d4d19947
269	139	2	eric-test	guided-experiences/eric-test	t	2021-08-06 22:54:56	2021-08-06 22:54:56	6f6a26ea-73b9-4aaa-87cf-8fb1c29a00ed
267	138	2	eric-test	guided-experiences/eric-test	t	2021-08-06 22:54:56	2021-08-06 22:54:57	9ab61129-ad2c-4a82-bb84-f83620e10b2b
270	140	1	eric-test	guided-experiences/eric-test	t	2021-08-06 22:56:21	2021-08-06 22:56:21	97730e42-88fb-4f9e-8bf9-1e17c7443343
271	140	2	eric-test	guided-experiences/eric-test	t	2021-08-06 22:56:21	2021-08-06 22:56:21	3ac2ebeb-21fb-4455-a286-a873d196e0c3
272	141	1	the-search-for-aliens	tour/the-search-for-aliens	t	2021-08-06 23:02:41	2021-08-06 23:02:41	fe6bf46e-bef1-4452-bbf7-33ebe6cc5e97
273	141	2	the-search-for-aliens	tour/the-search-for-aliens	t	2021-08-06 23:02:41	2021-08-06 23:02:41	5200a360-9c97-46cc-95f8-99624a70ad84
274	142	1	\N	\N	t	2021-08-06 23:02:41	2021-08-06 23:02:41	75b6ae3a-2e76-4ff0-974d-66d663c3a39b
275	142	2	\N	\N	t	2021-08-06 23:02:41	2021-08-06 23:02:41	e084baaa-17af-422f-b9b9-6df9eb42a814
276	143	1	\N	\N	t	2021-08-06 23:02:41	2021-08-06 23:02:41	ed6803d3-3eac-4c73-8540-6088060a0bbe
277	143	2	\N	\N	t	2021-08-06 23:02:41	2021-08-06 23:02:41	429ded71-0543-458b-a933-f71fda439f3d
278	144	1	\N	\N	t	2021-08-06 23:02:41	2021-08-06 23:02:41	7dfcc07a-4efe-4190-ba76-a11ec5f16531
279	144	2	\N	\N	t	2021-08-06 23:02:41	2021-08-06 23:02:41	7b45927b-c977-4213-99cb-085991979639
280	145	1	tour-de-force	tour/tour-de-force	t	2021-08-06 23:02:51	2021-08-06 23:02:51	a1d500ba-0fec-4426-acc5-481bf2185b1d
281	145	2	tour-de-force	tour/tour-de-force	t	2021-08-06 23:02:51	2021-08-06 23:02:51	6c47b098-a6c0-48cd-b081-35f8971ebbda
282	146	1	\N	\N	t	2021-08-06 23:02:51	2021-08-06 23:02:51	e54025fd-217e-4887-8a0d-0268522ab049
283	146	2	\N	\N	t	2021-08-06 23:02:51	2021-08-06 23:02:51	0049d1fe-7389-4309-824c-f7f0fdd7a5be
284	147	1	\N	\N	t	2021-08-06 23:02:51	2021-08-06 23:02:51	3367826a-2733-47d6-a77d-31ef1a5ec138
285	147	2	\N	\N	t	2021-08-06 23:02:51	2021-08-06 23:02:51	4f58c390-b3d3-4d0f-95f6-cf780e7bbd5c
286	148	1	\N	\N	t	2021-08-06 23:02:51	2021-08-06 23:02:51	aa4c8164-96f7-45ec-94f0-3f26a3a2b484
287	148	2	\N	\N	t	2021-08-06 23:02:51	2021-08-06 23:02:51	e35acd41-637e-409b-9277-fdc9a073d79d
266	138	1	tours	guided-experiences/tours	t	2021-08-06 22:54:56	2021-08-06 23:03:19	9981a019-414c-4eed-a3c8-adec3d99bba3
288	149	1	tours	guided-experiences/tours	t	2021-08-06 23:03:19	2021-08-06 23:03:19	06a651b6-b200-41c7-8809-8854ece01062
289	149	2	eric-test	guided-experiences/eric-test	t	2021-08-06 23:03:19	2021-08-06 23:03:19	4b73360a-d63a-41aa-b00b-074d6c25d1e6
290	150	1	the-search-for-aliens	tour/the-search-for-aliens	t	2021-08-06 23:04:32	2021-08-06 23:04:32	71a948ca-7a95-4747-b61d-2d0f1fb406ab
291	150	2	the-search-for-aliens	tour/the-search-for-aliens	t	2021-08-06 23:04:32	2021-08-06 23:04:32	cbef6a03-ad72-4810-84ed-2b98c693bf78
292	151	1	\N	\N	t	2021-08-06 23:04:32	2021-08-06 23:04:32	25e09e43-ad89-4fec-bd80-f83ee459bda5
293	151	2	\N	\N	t	2021-08-06 23:04:32	2021-08-06 23:04:32	d639bd1d-c398-426f-8397-d0094ac8c9ca
294	152	1	\N	\N	t	2021-08-06 23:04:32	2021-08-06 23:04:32	609140f1-5037-4c7d-8366-2df12bbcf729
295	152	2	\N	\N	t	2021-08-06 23:04:32	2021-08-06 23:04:32	59a0695b-a389-4648-be38-9acdebb7637f
296	153	1	\N	\N	t	2021-08-06 23:04:32	2021-08-06 23:04:32	f88a28e1-4a9f-40a9-a4ee-cfb4ecfd2220
297	153	2	\N	\N	t	2021-08-06 23:04:32	2021-08-06 23:04:32	6af8452d-280e-4493-9e35-9b4d1d3d5fe1
298	154	1	tour-de-force	tour/tour-de-force	t	2021-08-06 23:04:44	2021-08-06 23:04:44	f0873816-b7d1-4055-aaf5-6d820d47dd54
299	154	2	tour-de-force	tour/tour-de-force	t	2021-08-06 23:04:44	2021-08-06 23:04:44	fb5612e9-4639-4944-8158-eaddee752e0d
300	155	1	\N	\N	t	2021-08-06 23:04:44	2021-08-06 23:04:44	1fd30be5-37e6-4753-90c6-d1f7f7766d88
301	155	2	\N	\N	t	2021-08-06 23:04:44	2021-08-06 23:04:44	7f1330a9-ca60-4702-a96b-8faba885d112
302	156	1	\N	\N	t	2021-08-06 23:04:44	2021-08-06 23:04:44	c9526186-4c8d-478b-a81e-f9b6e91b944b
303	156	2	\N	\N	t	2021-08-06 23:04:44	2021-08-06 23:04:44	4b9136a9-3110-4e21-b1fc-51f631f7daae
304	157	1	\N	\N	t	2021-08-06 23:04:44	2021-08-06 23:04:44	545eeaea-c659-4706-b49c-f65fbe982271
305	157	2	\N	\N	t	2021-08-06 23:04:44	2021-08-06 23:04:44	fa089ed7-9ba5-46e1-9de9-0da1d4c991ce
306	158	1	tour-de-force	tour/tour-de-force	t	2021-08-06 23:05:17	2021-08-06 23:05:17	ad7c5184-0225-4169-b907-3e392112ac7d
307	158	2	tour-de-force	tour/tour-de-force	t	2021-08-06 23:05:17	2021-08-06 23:05:17	85d6567e-d183-4293-84e7-a17d598341ef
308	159	1	\N	\N	t	2021-08-06 23:05:17	2021-08-06 23:05:17	6fb78d8f-d45b-4982-9bca-3495177fecc6
309	159	2	\N	\N	t	2021-08-06 23:05:17	2021-08-06 23:05:17	c170246d-b015-4aaf-a669-d9946a450146
310	160	1	\N	\N	t	2021-08-06 23:05:17	2021-08-06 23:05:17	645d9e82-8fef-4e78-861a-e5dadfdbab77
311	160	2	\N	\N	t	2021-08-06 23:05:17	2021-08-06 23:05:17	d034aca6-2f5e-42ab-a4ae-8533f44c0e7a
312	161	1	\N	\N	t	2021-08-06 23:05:17	2021-08-06 23:05:17	c13c8d90-51a3-4b2d-936a-ed55398287d5
313	161	2	\N	\N	t	2021-08-06 23:05:17	2021-08-06 23:05:17	e4d45b8a-155f-44e5-a7e7-75cba80c18d7
314	162	1	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-08-06 23:06:48	2021-08-06 23:06:48	f87ed5aa-60e7-4d90-9ea9-5ec51d70eead
315	162	2	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-08-06 23:06:48	2021-08-06 23:06:48	39d30b67-c5c3-4831-b0f4-55f0939a1471
316	163	1	galaxies-catalog	catalog/galaxies-catalog	t	2021-08-06 23:09:51	2021-08-06 23:09:51	ef87da63-01e7-48a7-a3d5-edec52cf3209
317	163	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-08-06 23:09:51	2021-08-06 23:09:51	eca57c18-3763-4e51-8197-433e9ad05da4
318	164	1	nebulae-catalog	catalog/nebulae-catalog	t	2021-08-06 23:10:01	2021-08-06 23:10:01	90f58cb8-7271-4673-8c74-53d578c74feb
319	164	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-08-06 23:10:01	2021-08-06 23:10:01	554102d3-60af-41ba-9519-d3dbce69e5e2
320	165	1	transients-catalog	catalog/transients-catalog	t	2021-08-06 23:10:10	2021-08-06 23:10:10	a58103cd-7fd4-455b-b2fa-3a2a372d4195
321	165	2	transients-catalog	catalog/transients-catalog	t	2021-08-06 23:10:10	2021-08-06 23:10:10	275fe3b5-0b7d-489d-9563-a69ee0cff43d
322	166	1	goals-catalog	catalog/goals-catalog	t	2021-08-06 23:10:21	2021-08-06 23:10:21	b8bde9f5-bf3f-459b-89a0-5370b3e3098e
323	166	2	goals-catalog	catalog/goals-catalog	t	2021-08-06 23:10:21	2021-08-06 23:10:21	66f06f09-caea-4ffa-a692-792725e5d3f7
324	167	1	\N	\N	t	2021-08-17 20:25:07	2021-08-17 20:25:07	191e3a99-b57d-4408-b6ea-9c1206ff38e5
325	167	2	\N	\N	t	2021-08-17 20:25:07	2021-08-17 20:25:07	7f2d2cc7-5ae8-45ec-80ee-b9a2ffb8aeff
326	168	1	the-search-for-aliens	tour/the-search-for-aliens	t	2021-08-17 20:25:11	2021-08-17 20:25:11	b5345de3-211b-4a7b-bb46-84b206e47bfd
327	168	2	the-search-for-aliens	tour/the-search-for-aliens	t	2021-08-17 20:25:11	2021-08-17 20:25:11	e8257710-2bec-459d-b606-b8461266443d
328	169	1	\N	\N	t	2021-08-17 20:25:12	2021-08-17 20:25:12	06664e73-6691-46ed-8cad-7822627ca06a
329	169	2	\N	\N	t	2021-08-17 20:25:12	2021-08-17 20:25:12	2df093da-248f-4655-b99f-d22746d3f99c
330	170	1	\N	\N	t	2021-08-17 20:25:12	2021-08-17 20:25:12	5efa230f-2c37-4a48-a74b-da50bf3c51da
331	170	2	\N	\N	t	2021-08-17 20:25:12	2021-08-17 20:25:12	02e866f8-9e84-40f4-8eb1-db42ec180a34
332	171	1	\N	\N	t	2021-08-17 20:25:12	2021-08-17 20:25:12	644a91c9-bb74-4617-b653-4b66ede9788b
333	171	2	\N	\N	t	2021-08-17 20:25:12	2021-08-17 20:25:12	ff9560cd-9972-42ee-aa72-6f289b474c74
334	172	1	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-08-17 20:25:16	2021-08-17 20:25:16	c152a8a7-865a-438a-9e01-6f1e90449852
335	172	2	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-08-17 20:25:16	2021-08-17 20:25:16	a4049601-5ced-42f3-8800-a5e440437907
336	173	1	tour-de-force	tour/tour-de-force	t	2021-08-17 20:25:35	2021-08-17 20:25:35	3c85559a-2c26-4a49-b5ef-d9ab79bac9be
337	173	2	tour-de-force	tour/tour-de-force	t	2021-08-17 20:25:35	2021-08-17 20:25:35	a2c123b3-9880-4469-be35-e4eb25c437a5
338	174	1	\N	\N	t	2021-08-17 20:25:35	2021-08-17 20:25:35	0c8747ee-081b-4986-906b-bc6469398775
339	174	2	\N	\N	t	2021-08-17 20:25:35	2021-08-17 20:25:35	b33ea552-ac3c-4e6e-9225-f9fae1f8d67a
340	175	1	\N	\N	t	2021-08-17 20:25:35	2021-08-17 20:25:35	09d48f6e-ac7a-45a1-a38b-92a88da9c5f5
341	175	2	\N	\N	t	2021-08-17 20:25:35	2021-08-17 20:25:35	051318a9-9b02-4e42-a3cb-c4fd97dabb33
342	176	1	\N	\N	t	2021-08-17 20:25:35	2021-08-17 20:25:35	120baaa8-ce00-4512-a776-10260b02ab8f
343	176	2	\N	\N	t	2021-08-17 20:25:35	2021-08-17 20:25:35	c7a20ea3-9308-4fab-92ca-455dbdf0eb8b
345	177	2	test	tour-variety/test	t	2021-08-17 20:28:22	2021-08-17 20:28:23	456e877f-7995-4bf9-9b30-a46df4c97843
347	178	2	tester	tour-theme/tester	t	2021-08-17 20:28:31	2021-08-17 20:28:31	60da4a96-8f3a-4522-9b3a-cbfe100eef21
344	177	1	tours	tour-variety/tours	t	2021-08-17 20:28:22	2021-08-20 21:54:33	ada6d749-92be-4eb2-8923-00c53eeec5e3
348	179	1	tour-de-force	tour/tour-de-force	t	2021-08-17 20:28:35	2021-08-17 20:28:35	c7b5befd-db96-4337-92fc-50576a916b88
349	179	2	tour-de-force	tour/tour-de-force	t	2021-08-17 20:28:35	2021-08-17 20:28:35	20b915a8-913e-4967-84c9-0533e7ebc5da
350	180	1	\N	\N	t	2021-08-17 20:28:35	2021-08-17 20:28:35	c4e986df-2708-457c-a44e-5e5ae4173c99
351	180	2	\N	\N	t	2021-08-17 20:28:35	2021-08-17 20:28:35	c1afb413-11d9-451e-875c-9df103ae03a2
352	181	1	\N	\N	t	2021-08-17 20:28:35	2021-08-17 20:28:35	d9a61853-f13a-48ed-8a2b-85f13ca67e85
353	181	2	\N	\N	t	2021-08-17 20:28:35	2021-08-17 20:28:35	8bdc42c7-2bf0-4500-a7db-b3ce0e83db12
354	182	1	\N	\N	t	2021-08-17 20:28:35	2021-08-17 20:28:35	50bca3af-a35a-40a7-af99-92cde1da8cc5
355	182	2	\N	\N	t	2021-08-17 20:28:35	2021-08-17 20:28:35	82a9d085-86cf-4c65-b98b-1d82fae67798
356	183	1	tour-de-force	tour/tour-de-force	t	2021-08-17 20:29:06	2021-08-17 20:29:06	ada639c6-faf8-4d5d-92e4-b9a7133c2ae4
357	183	2	tour-de-force	tour/tour-de-force	t	2021-08-17 20:29:06	2021-08-17 20:29:06	03690929-7e0e-42d6-9423-86e5372b3b0c
358	184	1	\N	\N	t	2021-08-17 20:29:06	2021-08-17 20:29:06	82548918-f32a-4ce5-b23b-f57bd5002b55
359	184	2	\N	\N	t	2021-08-17 20:29:07	2021-08-17 20:29:07	e5aab9ef-ca06-47ae-971a-a7317975d191
360	185	1	\N	\N	t	2021-08-17 20:29:07	2021-08-17 20:29:07	9441d096-940b-4841-8316-3765f2fc7708
361	185	2	\N	\N	t	2021-08-17 20:29:07	2021-08-17 20:29:07	556d6bc8-7768-4fdb-a8dc-4d87fa193646
362	186	1	\N	\N	t	2021-08-17 20:29:07	2021-08-17 20:29:07	a2d811a5-7ffd-4a03-a82b-1afde882eb1e
363	186	2	\N	\N	t	2021-08-17 20:29:07	2021-08-17 20:29:07	6e040c66-c2cd-40c2-9339-20fd69533b74
364	187	1	\N	\N	t	2021-08-17 20:35:39	2021-08-17 20:35:39	4ea2836f-ab98-43b4-a414-44ad24992952
365	187	2	\N	\N	t	2021-08-17 20:35:39	2021-08-17 20:35:39	602139e3-0266-4f76-b38e-47e94eb27145
366	188	1	stars-catalog	catalog/stars-catalog	t	2021-08-17 20:35:45	2021-08-17 20:35:45	956cfbc7-f89f-4af5-870c-8d28af389cb4
367	188	2	stars-catalog	catalog/stars-catalog	t	2021-08-17 20:35:46	2021-08-17 20:35:46	4ab2ef3b-5321-419a-aa24-7719acd4cd65
368	189	1	\N	\N	t	2021-08-17 20:35:57	2021-08-17 20:35:57	26664a9d-e5a6-4448-b17f-2d58005aada0
369	189	2	\N	\N	t	2021-08-17 20:35:57	2021-08-17 20:35:57	b01ed7cb-ca9c-43a6-bac0-799878714abb
370	190	1	galaxies-catalog	catalog/galaxies-catalog	t	2021-08-17 20:36:03	2021-08-17 20:36:03	a10753e3-cb84-40f1-8db6-cce517a5019e
371	190	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-08-17 20:36:03	2021-08-17 20:36:03	f41e532f-bd32-499d-833c-90e5e230f2dd
372	191	1	\N	\N	t	2021-08-17 20:36:13	2021-08-17 20:36:13	c719e6f5-0ab5-4457-84df-4244304a313e
373	191	2	\N	\N	t	2021-08-17 20:36:13	2021-08-17 20:36:13	f1f31e00-d8aa-426f-a10f-14cf381dd934
374	192	1	nebulae-catalog	catalog/nebulae-catalog	t	2021-08-17 20:36:18	2021-08-17 20:36:18	30dcff20-80a5-4bf9-8be6-bb982bf99556
375	192	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-08-17 20:36:19	2021-08-17 20:36:19	e8a9d62b-dc84-4869-8661-afe669829c00
376	193	1	\N	\N	t	2021-08-17 20:36:34	2021-08-17 20:36:34	f718c9be-994e-48ce-a646-3f6bd2f45172
377	193	2	\N	\N	t	2021-08-17 20:36:34	2021-08-17 20:36:34	541be7c8-cbdd-449b-a878-13de5dcf4455
378	194	1	transients-catalog	catalog/transients-catalog	t	2021-08-17 20:36:40	2021-08-17 20:36:40	565368cd-15dd-43b4-9253-3b22a2d7f136
379	194	2	transients-catalog	catalog/transients-catalog	t	2021-08-17 20:36:41	2021-08-17 20:36:41	5e6011f7-5ed8-4298-abe1-40f5d00e7b5a
380	195	1	\N	\N	t	2021-08-17 20:36:57	2021-08-17 20:36:57	8d2ac554-7809-4d5a-9c7a-e129e0031ba4
381	195	2	\N	\N	t	2021-08-17 20:36:57	2021-08-17 20:36:57	5c38025c-8312-490e-8148-5430396570fe
382	196	1	goals-catalog	catalog/goals-catalog	t	2021-08-17 20:37:02	2021-08-17 20:37:02	206c4a28-ed2a-4383-8d93-8a7fc66d6a3f
383	196	2	goals-catalog	catalog/goals-catalog	t	2021-08-17 20:37:03	2021-08-17 20:37:03	20005e81-8ba5-4fb3-83ae-a98002705421
384	197	1	\N	\N	t	2021-08-17 20:37:11	2021-08-17 20:37:11	e9c5e236-43ed-49c5-8cb8-7e989aade659
385	197	2	\N	\N	t	2021-08-17 20:37:11	2021-08-17 20:37:11	dadec04e-6474-428b-9733-dee12fa5576f
386	198	1	landmarks-catalog	catalog/landmarks-catalog	t	2021-08-17 20:37:17	2021-08-17 20:37:17	868aab1b-75f8-4843-b9b3-598f13da8394
387	198	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-08-17 20:37:17	2021-08-17 20:37:17	25618114-3286-424f-a744-ab2f0830404a
388	199	1	\N	\N	t	2021-08-17 20:41:22	2021-08-17 20:41:22	593024ca-e219-41e9-8211-f2fc74e391b8
389	199	2	\N	\N	t	2021-08-17 20:41:22	2021-08-17 20:41:22	6d3a410d-0b59-4666-b179-bd01e9bcd71e
390	200	1	check-out-this-tour	astro-object/check-out-this-tour	t	2021-08-17 20:41:25	2021-08-17 20:41:25	85f039ec-d53f-46ed-bf94-2d91d43b25e4
391	200	2	check-out-this-tour	astro-object/check-out-this-tour	t	2021-08-17 20:41:25	2021-08-17 20:41:25	ca751c28-48cc-4c73-b8f3-081891030b3f
392	201	1	__temp_jadhvficvzmyewnlepqxovbswlgkuwlfpqiv	tour/__temp_jadhvficvzmyewnlepqxovbswlgkuwlfpqiv	t	2021-08-17 20:43:58	2021-08-17 20:43:58	dcb00db9-7b99-4552-94a7-e186c17d8a84
393	201	2	__temp_jadhvficvzmyewnlepqxovbswlgkuwlfpqiv	tour/__temp_jadhvficvzmyewnlepqxovbswlgkuwlfpqiv	t	2021-08-17 20:43:58	2021-08-17 20:43:58	8c4df233-9645-42fa-9e7d-d03acc2b29c5
394	202	1	__temp_qlrbnqfpuvhygmnithxetjribzikkqnrzjqh	explorer/__temp_qlrbnqfpuvhygmnithxetjribzikkqnrzjqh	t	2021-08-17 21:26:23	2021-08-17 21:26:23	6b5a50ff-2e8f-4633-accc-73ec7b3a866b
395	202	2	__temp_qlrbnqfpuvhygmnithxetjribzikkqnrzjqh	explorer/__temp_qlrbnqfpuvhygmnithxetjribzikkqnrzjqh	t	2021-08-17 21:26:23	2021-08-17 21:26:23	d337a4eb-1d38-4103-8657-7e3c945a1d44
396	203	1	__temp_asvbaheenfkzkergormysbgioexollrbeegn	tour/__temp_asvbaheenfkzkergormysbgioexollrbeegn	t	2021-08-20 21:48:32	2021-08-20 21:48:32	ce15a231-fd36-42f9-a170-2c36b49dcca7
397	203	2	__temp_asvbaheenfkzkergormysbgioexollrbeegn	tour/__temp_asvbaheenfkzkergormysbgioexollrbeegn	t	2021-08-20 21:48:32	2021-08-20 21:48:32	42f94b42-e8fe-4099-b579-78769c1d1c81
398	204	1	\N	\N	t	2021-08-20 21:54:23	2021-08-20 21:54:23	741a5037-fcaa-4781-8c65-bd8ceb6e211d
399	204	2	\N	\N	t	2021-08-20 21:54:23	2021-08-20 21:54:23	c99eebc7-96ff-4f72-9150-f9b2a110b4ce
346	178	1	stars	tour-theme/stars	t	2021-08-17 20:28:31	2021-08-20 21:55:05	d4d4ed8b-9c8e-41ff-9c13-48b83d1288eb
400	205	1	planets	tour-theme/planets	t	2021-08-20 21:55:12	2021-08-20 21:55:13	69fce92c-ccb9-4c3b-9b98-46183950f233
401	205	2	planets	tour-theme/planets	t	2021-08-20 21:55:12	2021-08-20 21:55:13	851afab6-bf98-4733-ae1e-9bc9805fc3f2
403	206	2	nebulae	tour-theme/nebulae	t	2021-08-20 21:55:30	2021-09-14 22:40:57	a8b86152-4153-401b-bf61-f1d02a15c842
404	207	1	galaxies	tour-theme/galaxies	t	2021-08-20 21:55:41	2021-08-20 21:55:41	338f1c87-579c-4bbd-b82f-82f6ea5254e2
405	207	2	galaxies	tour-theme/galaxies	t	2021-08-20 21:55:41	2021-08-20 21:55:42	aff4f725-0de0-47c5-99a2-deee57286287
406	208	1	constellations	tour-theme/constellations	t	2021-08-20 21:55:51	2021-08-20 21:55:52	2e24eb61-e095-4ac5-876a-7d084c572cef
407	208	2	constellations	tour-theme/constellations	t	2021-08-20 21:55:51	2021-08-20 21:55:52	8dccaf6a-7bed-419f-a679-6ee7fa2d5cf7
408	209	1	check-out-this-tour	astro-object/check-out-this-tour	t	2021-08-20 21:56:12	2021-08-20 21:56:12	c01bb188-6749-4908-8218-b4d34748c1f3
409	209	2	check-out-this-tour	astro-object/check-out-this-tour	t	2021-08-20 21:56:12	2021-08-20 21:56:12	a51edbdf-d396-45bd-9f11-f27ca6b9e035
410	210	1	tour-de-force	tour/tour-de-force	t	2021-08-20 21:56:58	2021-08-20 21:56:58	3e28c2cd-ade0-4543-98c1-63c7b4cd8988
411	210	2	tour-de-force	tour/tour-de-force	t	2021-08-20 21:56:58	2021-08-20 21:56:58	bc44ece1-1a22-48c8-b2bb-550a4393a152
412	211	1	\N	\N	t	2021-08-20 21:56:58	2021-08-20 21:56:58	51a155b8-7bb8-4a36-88de-9606f779080f
413	211	2	\N	\N	t	2021-08-20 21:56:58	2021-08-20 21:56:58	d32e04ad-b85a-421f-9be3-296a19874d77
414	212	1	\N	\N	t	2021-08-20 21:56:58	2021-08-20 21:56:58	e760b1ea-1487-4a3e-8aa1-a65f39d86c48
415	212	2	\N	\N	t	2021-08-20 21:56:58	2021-08-20 21:56:58	bae4ccf3-6e33-45dd-ac0e-1881a8790241
416	213	1	\N	\N	t	2021-08-20 21:56:58	2021-08-20 21:56:58	87e3e35c-4767-4e26-8be5-ac1b68ae0499
417	213	2	\N	\N	t	2021-08-20 21:56:58	2021-08-20 21:56:58	014ce666-3d1d-496c-bdf0-f2d927c2a7ec
418	214	1	\N	\N	t	2021-08-20 22:01:06	2021-08-20 22:01:06	e5abe1a9-87ac-45e8-8a9e-2ee168ae4223
419	214	2	\N	\N	t	2021-08-20 22:01:06	2021-08-20 22:01:06	ea1b3e95-d155-4481-a233-7f7cbf6d8e13
420	215	1	\N	\N	t	2021-08-20 22:01:06	2021-08-20 22:01:06	793690a6-4dcf-4988-9417-fa0bc043688f
421	215	2	\N	\N	t	2021-08-20 22:01:06	2021-08-20 22:01:06	63f2c635-0120-4eed-95cf-aa4368899b69
422	216	1	\N	\N	t	2021-08-20 22:01:06	2021-08-20 22:01:06	202f1763-4709-42c2-909d-07c938f5e3f5
423	216	2	\N	\N	t	2021-08-20 22:01:06	2021-08-20 22:01:06	1018bb29-fae2-4770-ac59-1f0b4bde9538
424	217	1	\N	\N	t	2021-08-20 22:01:06	2021-08-20 22:01:06	49924eb9-56be-488e-98a8-86df014ee616
425	217	2	\N	\N	t	2021-08-20 22:01:07	2021-08-20 22:01:07	1c6391c3-23c7-4028-a693-df22e1ee0351
426	218	1	\N	\N	t	2021-08-20 22:01:07	2021-08-20 22:01:07	0d876ba5-6e07-415d-9204-e1cc8a8dcac8
427	218	2	\N	\N	t	2021-08-20 22:01:07	2021-08-20 22:01:07	23bb8a62-6072-4b82-91ac-f7fbeef2ac31
428	219	1	\N	\N	t	2021-08-20 22:01:07	2021-08-20 22:01:07	599f9a0d-4288-488f-bab4-15130621f0f3
429	219	2	\N	\N	t	2021-08-20 22:01:07	2021-08-20 22:01:07	3f759249-50d0-4ddf-a6e9-0546a0b0f70e
11	8	1	goals	catalog/goals	t	2021-06-15 16:50:17	2021-08-20 22:02:00	3a35827d-c2ff-43a9-a868-4324f565bcf6
430	220	1	goals	catalog/goals	t	2021-08-20 22:02:00	2021-08-20 22:02:00	08ad90a9-e60c-4768-a71b-b2f782cf596b
431	220	2	stars-catalog	catalog/stars-catalog	t	2021-08-20 22:02:00	2021-08-20 22:02:00	a6865fb2-47f4-46aa-a89e-4ff0f036d1c3
432	221	1	stars	catalog/stars	t	2021-08-20 22:02:33	2021-08-20 22:02:33	fb517743-14db-475d-b7e9-7d0b189e9744
433	221	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-08-20 22:02:33	2021-08-20 22:02:33	3f28ef4c-1d45-4abc-b80b-6143fe3294f3
434	222	1	galaxy	catalog/galaxy	t	2021-08-20 22:03:07	2021-08-20 22:03:07	c90f8ffa-7c07-447e-b372-8a2838aaf9d7
435	222	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-08-20 22:03:07	2021-08-20 22:03:07	43a95c95-7d5a-4705-8d58-358ad6af5014
436	223	1	nebula	catalog/nebula	t	2021-08-20 22:03:29	2021-08-20 22:03:29	c568d41b-8d68-431d-be61-e9978079c694
437	223	2	transients-catalog	catalog/transients-catalog	t	2021-08-20 22:03:29	2021-08-20 22:03:29	3406aa27-1f4f-4590-93f1-c0b4e4cb21e6
438	224	1	transient	catalog/transient	t	2021-08-20 22:04:11	2021-08-20 22:04:11	9f544740-2f63-474b-8880-e527e34de1d5
439	224	2	goals-catalog	catalog/goals-catalog	t	2021-08-20 22:04:11	2021-08-20 22:04:11	acdf14c8-5afe-4c04-806a-677515c6bcdc
440	225	1	landmarks	catalog/landmarks	t	2021-08-20 22:04:39	2021-08-20 22:04:39	3e0d6f69-07b5-4253-8a26-1499badf8b0d
441	225	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-08-20 22:04:39	2021-08-20 22:04:39	c3331b1f-a0ab-41ed-b46b-d5788d473798
442	226	1	transient	catalog/transient	t	2021-08-20 22:04:44	2021-08-20 22:04:44	4e99a6c9-bfbb-4282-8f80-edc6b46bab59
443	226	2	goals-catalog	catalog/goals-catalog	t	2021-08-20 22:04:44	2021-08-20 22:04:44	8ab5f921-fab7-4eae-8923-cd56442bd1a9
446	228	1	\N	\N	t	2021-08-30 21:31:25	2021-08-30 21:31:25	af6c2433-896a-4d40-b8f4-10a2210c6d40
447	228	2	\N	\N	t	2021-08-30 21:31:25	2021-08-30 21:31:25	c4876335-d16a-4797-978c-e489bb048cd4
448	229	1	some-variety	tour-variety/some-variety	t	2021-08-30 21:31:28	2021-08-30 21:31:29	de6e35db-1a2c-468b-a4a5-7ba0778e996f
449	229	2	some-variety	tour-variety/some-variety	t	2021-08-30 21:31:28	2021-08-30 21:31:29	2bc5d1a3-da2a-4b79-bd5b-0e5745d48785
450	230	1	\N	\N	t	2021-08-30 21:31:49	2021-08-30 21:31:49	7bc6ffd1-6aa0-40e9-9670-90c55ba459c9
451	230	2	\N	\N	t	2021-08-30 21:31:49	2021-08-30 21:31:49	a1dad270-04e9-40d1-9b25-430e89c06593
452	231	1	\N	\N	t	2021-08-30 21:31:51	2021-08-30 21:31:51	932c64e2-6aa9-4952-a651-0812f72268b6
453	231	2	\N	\N	t	2021-08-30 21:31:51	2021-08-30 21:31:51	7a27bfa6-0e04-463a-8ee1-d25e2baa8dfb
454	232	1	\N	\N	t	2021-08-30 21:31:54	2021-08-30 21:31:54	52e55033-9653-4b47-811e-2950523d6d24
455	232	2	\N	\N	t	2021-08-30 21:31:54	2021-08-30 21:31:54	4bc8d487-eb1c-47a8-a22a-4a3571a7c03f
456	233	1	\N	\N	t	2021-08-30 21:31:58	2021-08-30 21:31:58	a717d8d9-63f8-4d4d-9dad-88244789ebd7
457	233	2	\N	\N	t	2021-08-30 21:31:59	2021-08-30 21:31:59	f8c4f46f-daf2-43ce-b822-97c69836ebfa
458	234	1	\N	\N	t	2021-08-30 21:32:00	2021-08-30 21:32:00	417e5452-c026-48c2-867e-1016036c461b
459	234	2	\N	\N	t	2021-08-30 21:32:01	2021-08-30 21:32:01	27888098-5642-4398-8546-a650a6663733
460	235	1	\N	\N	t	2021-08-30 21:32:03	2021-08-30 21:32:03	b4d54c9a-cfd0-409c-b1ee-f8b85232c895
461	235	2	\N	\N	t	2021-08-30 21:32:03	2021-08-30 21:32:03	ca08505c-afaa-4b81-a386-7f26d3aa0380
462	236	1	\N	\N	t	2021-08-30 21:32:05	2021-08-30 21:32:05	f11183d7-9705-44d5-8b9d-f6adf697632d
463	236	2	\N	\N	t	2021-08-30 21:32:05	2021-08-30 21:32:05	6d240994-5bff-4e25-8750-11da6b0a2470
464	237	1	\N	\N	t	2021-08-30 21:32:07	2021-08-30 21:32:07	6f1b25d1-f484-4c98-9ac7-e8de1f2a768e
465	237	2	\N	\N	t	2021-08-30 21:32:07	2021-08-30 21:32:07	3552f0c1-e87c-448a-a917-a3b73b89303d
466	238	1	\N	\N	t	2021-08-30 21:32:11	2021-08-30 21:32:11	6ea69518-29f9-46fd-821a-a3de493de645
467	238	2	\N	\N	t	2021-08-30 21:32:11	2021-08-30 21:32:11	8694314c-3d0a-4afe-99ba-01d3d81e40fc
468	239	1	\N	\N	t	2021-08-30 21:32:28	2021-08-30 21:32:28	f3187622-72c3-47d3-974f-b0fba25b4262
469	239	2	\N	\N	t	2021-08-30 21:32:28	2021-08-30 21:32:28	494ecab6-16b1-42fc-897b-370957c7aca1
472	241	1	whoa	astro-object/whoa	t	2021-08-30 21:32:31	2021-08-30 21:32:31	9afc7c7a-caec-4e30-95ca-042b300c88b8
473	241	2	whoa	astro-object/whoa	t	2021-08-30 21:32:31	2021-08-30 21:32:31	e26ad1e8-613c-459c-8524-e5d644b22b7f
471	240	2	whoa	astro-object/whoa	t	2021-08-30 21:32:31	2021-10-08 23:05:12	173944fa-276f-4922-b9ba-f1e3d2b93bc8
445	227	2	another-fine-tour	tour/another-fine-tour	t	2021-08-30 21:31:02	2021-10-08 23:08:20	a5e3a14c-a790-45b6-9ccc-d8fb0d9a4cdc
474	242	1	\N	\N	t	2021-08-30 21:32:33	2021-08-30 21:32:33	35ba0540-e899-4249-9475-8939c44d3500
475	242	2	\N	\N	t	2021-08-30 21:32:33	2021-08-30 21:32:33	e8fd1e70-cc0e-45dd-821e-9aad32bd14f5
470	240	1	whoa	astro-object/whoa	t	2021-08-30 21:32:31	2021-10-08 23:05:12	87f9b9c4-fcba-4ef0-a7c2-a9cc5b871733
476	243	1	another-fine-tour	tour/another-fine-tour	t	2021-08-30 21:32:35	2021-08-30 21:32:35	8fd37e30-4618-4b39-882e-8b2749c9e8f3
477	243	2	another-fine-tour	tour/another-fine-tour	t	2021-08-30 21:32:35	2021-08-30 21:32:35	363af2dd-c649-48f4-829f-4933ec621384
478	244	1	\N	\N	t	2021-08-30 21:32:35	2021-08-30 21:32:35	2c6695b9-c174-474d-9ac2-d38a779220cd
479	244	2	\N	\N	t	2021-08-30 21:32:35	2021-08-30 21:32:35	fb42e46c-fb50-4ad6-8398-1676515164b4
480	245	1	\N	\N	t	2021-08-30 21:32:35	2021-08-30 21:32:35	d1ea8fa5-25ad-4d94-8c76-79582d4edf81
481	245	2	\N	\N	t	2021-08-30 21:32:35	2021-08-30 21:32:35	5a698138-ddaa-45b0-8335-ac82ea8f3b95
482	246	1	\N	\N	t	2021-08-30 21:32:35	2021-08-30 21:32:35	2f1a99a3-e4ea-4fd6-ad1b-079814c7c73b
483	246	2	\N	\N	t	2021-08-30 21:32:35	2021-08-30 21:32:35	a610f1d3-b54d-481d-a971-556a37c3e276
492	251	1	tour-de-force	tour/tour-de-force	t	2021-09-08 17:50:58	2021-09-08 17:50:58	bf91b382-2cc5-4e28-b00e-781836d5b553
493	251	2	tour-de-force	tour/tour-de-force	t	2021-09-08 17:50:58	2021-09-08 17:50:58	85e6b2ba-6368-419f-b6d5-ca757be174b9
494	252	1	\N	\N	t	2021-09-08 17:50:58	2021-09-08 17:50:58	266a3a3d-c2d6-4bab-ac5b-77c19b903019
495	252	2	\N	\N	t	2021-09-08 17:50:58	2021-09-08 17:50:58	da404ec9-8d0e-4c29-bf63-faa548e15540
496	253	1	\N	\N	t	2021-09-08 17:50:58	2021-09-08 17:50:58	3b7b19f0-7d1f-4318-a8fb-5d304326fbcc
497	253	2	\N	\N	t	2021-09-08 17:50:58	2021-09-08 17:50:58	08534971-1bb6-4ef2-a842-af6451dfd5b4
498	254	1	\N	\N	t	2021-09-08 17:50:58	2021-09-08 17:50:58	6340d5d9-d4c3-4081-b68f-939ea15ab9e5
499	254	2	\N	\N	t	2021-09-08 17:50:58	2021-09-08 17:50:58	1ab0a852-0c7e-495d-b688-5fe2b032ea1a
508	259	1	the-search-for-aliens	tour/the-search-for-aliens	t	2021-09-08 17:54:32	2021-09-08 17:54:32	69c28d6a-f219-4dd3-83b4-1984f399877b
509	259	2	the-search-for-aliens	tour/the-search-for-aliens	t	2021-09-08 17:54:32	2021-09-08 17:54:32	ea64a5e7-87e0-4c71-94f3-1555af965458
510	260	1	\N	\N	t	2021-09-08 17:54:32	2021-09-08 17:54:32	390a005a-00ee-43bc-9a7c-cfb369216a40
511	260	2	\N	\N	t	2021-09-08 17:54:32	2021-09-08 17:54:32	c9089b5e-16e5-4d3d-8a33-26acc05af676
512	261	1	\N	\N	t	2021-09-08 17:54:32	2021-09-08 17:54:32	3097bf2e-4438-43bc-9dc3-d01110a9501c
513	261	2	\N	\N	t	2021-09-08 17:54:32	2021-09-08 17:54:32	8c9e8ca2-0d8c-45a9-83cf-ac10d7667c70
514	262	1	\N	\N	t	2021-09-08 17:54:32	2021-09-08 17:54:32	fd41dd87-ddaa-479c-b86b-93a4412ced3a
515	262	2	\N	\N	t	2021-09-08 17:54:32	2021-09-08 17:54:32	54831df2-8689-446b-99e3-86752c274f7f
524	267	1	another-fine-tour	tour/another-fine-tour	t	2021-09-08 17:54:51	2021-09-08 17:54:51	76c0ab24-d013-4d10-b558-e858b77ac3ba
525	267	2	another-fine-tour	tour/another-fine-tour	t	2021-09-08 17:54:52	2021-09-08 17:54:52	ac9d6ab2-a5d2-4f63-af75-1791ec011d96
526	268	1	\N	\N	t	2021-09-08 17:54:52	2021-09-08 17:54:52	dda029b6-bb97-4e38-ae77-9e7f9751af70
527	268	2	\N	\N	t	2021-09-08 17:54:52	2021-09-08 17:54:52	20a7b819-dcb6-4c04-bb9a-b7488a60c95d
528	269	1	\N	\N	t	2021-09-08 17:54:52	2021-09-08 17:54:52	57c52b18-9da3-4c92-bdfa-016a34bd34c5
529	269	2	\N	\N	t	2021-09-08 17:54:52	2021-09-08 17:54:52	903011c2-dc3e-4447-b17f-afd9910ace2e
530	270	1	\N	\N	t	2021-09-08 17:54:52	2021-09-08 17:54:52	7d677db2-2ad6-403e-b57f-c734a3ba27d9
531	270	2	\N	\N	t	2021-09-08 17:54:52	2021-09-08 17:54:52	8f1efec8-0c3a-4311-8ac1-f345691b53ac
540	275	1	another-fine-tour	tour/another-fine-tour	t	2021-09-08 17:55:09	2021-09-08 17:55:09	9635cbec-2572-4dd8-9d82-f6a508217d5c
541	275	2	another-fine-tour	tour/another-fine-tour	t	2021-09-08 17:55:09	2021-09-08 17:55:09	05aa61a4-fa76-42a2-afc5-026ca419a184
542	276	1	\N	\N	t	2021-09-08 17:55:09	2021-09-08 17:55:09	c053b49b-b9f0-48e8-bb5a-da48dc068a4a
543	276	2	\N	\N	t	2021-09-08 17:55:09	2021-09-08 17:55:09	8081a125-81c1-4c22-a017-01ca49cb39d9
544	277	1	\N	\N	t	2021-09-08 17:55:09	2021-09-08 17:55:09	7afe352f-207a-41a3-a5fe-a237f1ba477f
545	277	2	\N	\N	t	2021-09-08 17:55:09	2021-09-08 17:55:09	4b3522b7-953a-4321-9473-13d375dc424c
546	278	1	\N	\N	t	2021-09-08 17:55:09	2021-09-08 17:55:09	e56e80df-9f8d-4488-a33c-64184c34e6ed
547	278	2	\N	\N	t	2021-09-08 17:55:09	2021-09-08 17:55:09	9d76bf9b-5d1e-4955-855e-e8083be8db2b
548	279	1	this-is-a-brand-new-tour	tour/this-is-a-brand-new-tour	t	2021-09-08 17:55:33	2021-09-08 17:55:42	60d998a0-28dd-4bff-a9e3-553167f32bda
549	279	2	this-is-a-brand-new-tour	tour/this-is-a-brand-new-tour	t	2021-09-08 17:55:33	2021-09-08 17:55:42	c5aeea5a-7678-4cfe-ba0d-fb272f81ccdc
550	280	1	\N	\N	t	2021-09-08 17:57:28	2021-09-08 17:57:28	0fcfcc37-349a-440a-b215-0f4caabfa1cf
551	280	2	\N	\N	t	2021-09-08 17:57:28	2021-09-08 17:57:28	0bb85e96-3cc9-4c3e-82eb-8fcbe80e422b
552	281	1	\N	\N	t	2021-09-08 17:57:46	2021-09-08 17:57:46	8851ac60-663b-4a75-934a-a4241f283d11
553	281	2	\N	\N	t	2021-09-08 17:57:46	2021-09-08 17:57:46	cf4f4fb1-395d-4e84-b068-7fd6b7f914fb
554	282	1	\N	\N	t	2021-09-08 17:57:48	2021-09-08 17:57:48	638977fd-7163-4ccf-9ad6-42d8187c87e2
555	282	2	\N	\N	t	2021-09-08 17:57:48	2021-09-08 17:57:48	e3726071-8355-4e27-9eda-e1633fcfb575
556	283	1	\N	\N	t	2021-09-08 17:57:50	2021-09-08 17:57:50	79f6582a-39a2-4bc8-a172-980354b3b517
557	283	2	\N	\N	t	2021-09-08 17:57:50	2021-09-08 17:57:50	997f86f1-1b2e-48d5-bcf1-dbd2457b82e6
558	284	1	\N	\N	t	2021-09-08 17:57:52	2021-09-08 17:57:52	82e9205d-6ac0-4fe6-b486-6a07ff3802d2
559	284	2	\N	\N	t	2021-09-08 17:57:52	2021-09-08 17:57:52	a1db7944-0b2a-4d82-ad8b-cce123f7c291
560	285	1	\N	\N	t	2021-09-08 17:58:07	2021-09-08 17:58:07	9bedc87e-b1b8-4da2-a13b-0fc983d3bbc8
561	285	2	\N	\N	t	2021-09-08 17:58:07	2021-09-08 17:58:07	ea5b90c4-8cde-46de-9073-d84f6c0f81b5
562	286	1	\N	\N	t	2021-09-08 17:58:11	2021-09-08 17:58:11	5eeec574-87a0-401a-92fd-186f079f8309
563	286	2	\N	\N	t	2021-09-08 17:58:11	2021-09-08 17:58:11	5015e4d2-4b5c-49f0-b7b2-89c8ec972f84
564	287	1	\N	\N	t	2021-09-08 17:58:14	2021-09-08 17:58:14	dff8f9d5-8e7f-4ad5-9edc-7d65652cc746
565	287	2	\N	\N	t	2021-09-08 17:58:14	2021-09-08 17:58:14	7a05d699-db88-45cf-99e0-274190c3da25
566	288	1	\N	\N	t	2021-09-08 17:58:17	2021-09-08 17:58:17	ffd873fe-4c4a-4ca9-a2e5-f4023846ebef
567	288	2	\N	\N	t	2021-09-08 17:58:17	2021-09-08 17:58:17	652f3163-c9e9-458b-a979-e647391be9fd
568	289	1	\N	\N	t	2021-09-08 17:58:18	2021-09-08 17:58:18	84cfc407-d349-4c2a-a991-d481fa862a12
569	289	2	\N	\N	t	2021-09-08 17:58:18	2021-09-08 17:58:18	2d55b3fd-bce8-4c75-a8be-bf3f18d1b41b
570	290	1	\N	\N	t	2021-09-08 17:58:44	2021-09-08 17:58:44	e7ba8925-3778-42e4-9774-b73e824343e7
571	290	2	\N	\N	t	2021-09-08 17:58:44	2021-09-08 17:58:44	eb753245-782b-43d1-9b00-543eb0396e37
574	292	1	this-is-a-brand-new-astro-object	astro-object/this-is-a-brand-new-astro-object	t	2021-09-08 17:58:54	2021-09-08 17:58:54	955c3f73-b543-447e-85b5-e27d55af7cb1
444	227	1	another-fine-tour	tour/another-fine-tour	t	2021-08-30 21:31:02	2021-10-08 23:08:20	e2033c59-f5ca-482c-bad1-7b22e39962ef
573	291	2	this-is-a-brand-new-astro-object	astro-object/this-is-a-brand-new-astro-object	t	2021-09-08 17:58:54	2021-10-08 23:05:44	eabdb45b-6fe3-44ee-a7a5-73652f7e51bb
575	292	2	this-is-a-brand-new-astro-object	astro-object/this-is-a-brand-new-astro-object	t	2021-09-08 17:58:54	2021-09-08 17:58:54	0da086e4-d276-42c0-97c1-60fb37d35a09
576	293	1	\N	\N	t	2021-09-08 17:58:56	2021-09-08 17:58:56	bc3e4829-653e-4019-81af-df51a931d1e5
577	293	2	\N	\N	t	2021-09-08 17:58:56	2021-09-08 17:58:56	98125d52-540c-47f2-94de-9cab885e707c
578	294	1	this-is-a-brand-new-tour	tour/this-is-a-brand-new-tour	t	2021-09-08 17:58:58	2021-09-08 17:58:58	2035550a-3fcf-4e4e-ad76-fc343d2e9fd5
579	294	2	this-is-a-brand-new-tour	tour/this-is-a-brand-new-tour	t	2021-09-08 17:58:58	2021-09-08 17:58:58	eebe51ff-b452-4b75-a735-a59546bdeb0a
580	295	1	\N	\N	t	2021-09-08 17:58:58	2021-09-08 17:58:58	4c36c6a1-f889-4683-8d64-919294c15fd2
581	295	2	\N	\N	t	2021-09-08 17:58:58	2021-09-08 17:58:58	72f36e5d-06cb-4bc5-a588-c86b96fdb045
582	296	1	\N	\N	t	2021-09-08 17:58:58	2021-09-08 17:58:58	cc19af8f-02bf-4f83-a0dc-21e1d9212ff9
583	296	2	\N	\N	t	2021-09-08 17:58:58	2021-09-08 17:58:58	0e03e363-8ae6-467a-8dcd-64cc4f96ffee
584	297	1	\N	\N	t	2021-09-08 17:58:58	2021-09-08 17:58:58	d97bd396-3da9-4031-ab60-021e11ad8f13
585	297	2	\N	\N	t	2021-09-08 17:58:58	2021-09-08 17:58:58	f8e0fb7f-df68-4675-bc59-8f82fa0a5e60
588	299	1	\N	\N	t	2021-09-08 18:25:53	2021-09-08 18:25:53	e169e12a-85c8-4f0a-bc51-2e6dded3ba39
589	299	2	\N	\N	t	2021-09-08 18:25:54	2021-09-08 18:25:54	1cdf6697-0785-4fd2-a23d-4abdf5e00e02
590	300	1	\N	\N	t	2021-09-08 18:25:56	2021-09-08 18:25:56	b7816611-c9fb-42d8-a1ec-d8cdd530e494
591	300	2	\N	\N	t	2021-09-08 18:25:56	2021-09-08 18:25:56	5bb83f60-281b-4c5f-8534-511bd88daadf
592	301	1	\N	\N	t	2021-09-08 18:25:58	2021-09-08 18:25:58	76a82c38-6d3a-4370-bbc0-acafff5b3dc6
593	301	2	\N	\N	t	2021-09-08 18:25:58	2021-09-08 18:25:58	4c156bad-8e58-4aac-9dfb-e62cdb7e8e06
594	302	1	\N	\N	t	2021-09-08 18:26:00	2021-09-08 18:26:00	8e442ffe-19ac-49bd-8c0e-e2a6be59cfe9
595	302	2	\N	\N	t	2021-09-08 18:26:00	2021-09-08 18:26:00	ee51dc05-642b-4ede-9913-22a333acd9d0
596	303	1	\N	\N	t	2021-09-08 18:26:05	2021-09-08 18:26:05	f32d3307-11b2-4c9f-a86e-941bb1d17a7e
597	303	2	\N	\N	t	2021-09-08 18:26:05	2021-09-08 18:26:05	a3d7eb2c-b389-4c60-bd7f-b8cfcdfc0df0
598	304	1	\N	\N	t	2021-09-08 18:26:08	2021-09-08 18:26:08	98814ab5-08a3-4442-be0f-8f99518ab572
599	304	2	\N	\N	t	2021-09-08 18:26:08	2021-09-08 18:26:08	4bded9cd-c4a4-4a1d-865f-f7b3d56deab6
600	305	1	\N	\N	t	2021-09-08 18:26:12	2021-09-08 18:26:12	24d7e871-7c2d-4652-bc2e-054dc70eeab6
601	305	2	\N	\N	t	2021-09-08 18:26:12	2021-09-08 18:26:12	e101cf3f-1ec7-4853-a158-ca420ae3f4be
602	306	1	\N	\N	t	2021-09-08 18:26:14	2021-09-08 18:26:14	80eb992f-ee60-43c0-8ec6-dfd2d18ce740
603	306	2	\N	\N	t	2021-09-08 18:26:14	2021-09-08 18:26:14	92aae33c-59a4-48cc-8601-213df7836e3d
604	307	1	\N	\N	t	2021-09-08 18:26:17	2021-09-08 18:26:17	0aa3d61b-2262-4e50-ad1f-f9a6cb4b8c3d
605	307	2	\N	\N	t	2021-09-08 18:26:17	2021-09-08 18:26:17	5c1188d9-170d-48e5-9407-0f7d76db7296
608	309	1	this-is-a-cloud-astro-object	astro-object/this-is-a-cloud-astro-object	t	2021-09-08 18:26:41	2021-09-08 18:26:41	7f4d21cd-b110-4efb-9975-34ecd08f76a2
609	309	2	this-is-a-cloud-astro-object	astro-object/this-is-a-cloud-astro-object	t	2021-09-08 18:26:41	2021-09-08 18:26:41	77be7f5f-6fe4-4ddc-9757-369f87ef286e
607	308	2	this-is-a-cloud-astro-object	astro-object/this-is-a-cloud-astro-object	t	2021-09-08 18:26:41	2021-10-08 23:06:00	7ae5836a-adbf-4530-b842-a1b9b0191a85
586	298	1	a-tour-of-the-cloud	tour/a-tour-of-the-cloud	t	2021-09-08 18:23:49	2021-10-08 23:08:52	e5b644a5-a162-428f-9de6-b571fffc7a05
610	310	1	\N	\N	t	2021-09-08 18:26:56	2021-09-08 18:26:56	02f02eb6-8f29-4b15-bb36-328dc3ee0487
611	310	2	\N	\N	t	2021-09-08 18:26:56	2021-09-08 18:26:56	007e72e8-fd62-49f3-b729-8bad143e4d82
612	311	1	a-tour-of-the-cloud	tour/a-tour-of-the-cloud	t	2021-09-08 18:26:58	2021-09-08 18:26:58	542c3fcc-e5d8-402d-8b2d-71f2eb91c457
613	311	2	a-tour-of-the-cloud	tour/a-tour-of-the-cloud	t	2021-09-08 18:26:58	2021-09-08 18:26:58	330a5797-e670-48f3-9074-3adf853a6e86
614	312	1	\N	\N	t	2021-09-08 18:26:58	2021-09-08 18:26:58	32fab42e-d3fd-471e-97ac-c6e614449b73
615	312	2	\N	\N	t	2021-09-08 18:26:58	2021-09-08 18:26:58	729380e9-de99-4309-83ad-f975174a41ee
616	313	1	\N	\N	t	2021-09-08 18:26:58	2021-09-08 18:26:58	2d576bb2-ae7c-4d37-a8a9-872bd15a9900
617	313	2	\N	\N	t	2021-09-08 18:26:58	2021-09-08 18:26:58	0b40b52f-0e9f-4f20-bb71-0f7ece08ad94
618	314	1	\N	\N	t	2021-09-08 18:26:58	2021-09-08 18:26:58	5951bfad-4f5c-42ba-ab03-ec67785d924b
619	314	2	\N	\N	t	2021-09-08 18:26:58	2021-09-08 18:26:58	20e39782-f3cb-49b7-ab81-c60d477c7ba6
622	316	1	stars	catalog/stars	t	2021-09-14 22:23:01	2021-09-14 22:23:01	c2405469-ceda-4ee7-9414-ba4229cca26b
623	316	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-09-14 22:23:01	2021-09-14 22:23:01	adbe7c09-3de7-409e-8b56-2af957f3c406
626	318	1	stars	catalog/stars	t	2021-09-14 22:23:30	2021-09-14 22:23:30	4e0e2d9f-7675-4d79-9b6f-a318f7aaaf1e
627	318	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-09-14 22:23:30	2021-09-14 22:23:30	8f7d9890-e4db-4f19-9600-0374a634d87d
630	320	1	\N	\N	t	2021-09-14 22:31:22	2021-09-14 22:31:22	6c201881-c083-4be5-be20-95ce924a1203
631	320	2	\N	\N	t	2021-09-14 22:31:22	2021-09-14 22:31:22	bc6a36a4-addb-4f55-abbb-647b05b62a3e
632	321	1	\N	\N	t	2021-09-14 22:31:28	2021-09-14 22:31:28	7e7d47d8-66f3-4d17-a394-9c2596583209
633	321	2	\N	\N	t	2021-09-14 22:31:28	2021-09-14 22:31:28	2718d693-9242-41b4-bd07-b371f46ef56c
634	322	1	\N	\N	t	2021-09-14 22:31:34	2021-09-14 22:31:34	1db493c1-1e2b-4e2c-b3f4-92ac2c0f6b34
635	322	2	\N	\N	t	2021-09-14 22:31:34	2021-09-14 22:31:34	df0ddea7-81f3-4731-be79-934b77e2b608
636	323	1	\N	\N	t	2021-09-14 22:31:40	2021-09-14 22:31:40	f417c279-7306-440d-a80b-c6f02855ef15
637	323	2	\N	\N	t	2021-09-14 22:31:40	2021-09-14 22:31:40	2f9ca90b-b2ab-465b-8255-5c42270a6efb
638	324	1	\N	\N	t	2021-09-14 22:31:47	2021-09-14 22:31:47	554a64a0-8eb6-4d93-af66-5fd61734d796
639	324	2	\N	\N	t	2021-09-14 22:31:47	2021-09-14 22:31:47	a64e2860-a33c-49e1-a5ce-a21884bc98c2
640	325	1	\N	\N	t	2021-09-14 22:31:52	2021-09-14 22:31:52	9220fa84-ba03-4f0b-ae29-b2613020f573
641	325	2	\N	\N	t	2021-09-14 22:31:52	2021-09-14 22:31:52	8078420a-6d79-4f30-9ff8-9d57fd3ec1a2
642	326	1	galaxy	catalog/galaxy	t	2021-09-14 22:32:05	2021-09-14 22:32:05	8f941938-1709-4eb8-aa5c-1b41b668d830
643	326	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-09-14 22:32:05	2021-09-14 22:32:05	d1f52dcc-9a07-43ec-a20d-0204f3709a52
402	206	1	nebulae	tour-theme/nebulae	t	2021-08-20 21:55:30	2021-09-14 22:40:57	6ce93b6c-d822-4932-af9c-973ab18b9019
572	291	1	this-is-a-brand-new-astro-object	astro-object/this-is-a-brand-new-astro-object	t	2021-09-08 17:58:53	2021-10-08 23:05:44	b3ef7781-bfc7-44a8-9bfe-bfb1eb8485a8
606	308	1	this-is-a-cloud-astro-object	astro-object/this-is-a-cloud-astro-object	t	2021-09-08 18:26:41	2021-10-08 23:06:00	5a52deba-d15d-4315-b919-fe052851303a
587	298	2	a-tour-of-the-cloud	tour/a-tour-of-the-cloud	t	2021-09-08 18:23:50	2021-10-08 23:08:52	91da1ad9-893f-4132-8318-6c288485b59f
646	328	1	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-09-14 22:43:07	2021-09-14 22:43:07	b76c1ac5-0f3d-4400-ad5c-607cd88c996f
647	328	2	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-09-14 22:43:07	2021-09-14 22:43:07	a935dcc4-1831-4c1b-809a-b700fca96006
650	330	1	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-09-16 20:36:16	2021-09-16 20:36:16	c0a7117b-d647-4cb3-9754-c2f3e59fb0f3
651	330	2	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-09-16 20:36:17	2021-09-16 20:36:17	69ae7fa7-9b6e-433c-9123-01cf9da4dff2
654	332	1	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-09-16 20:36:42	2021-09-16 20:36:42	205de6f3-6582-4cd1-9cb7-d8377cc1ec13
655	332	2	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-09-16 20:36:42	2021-09-16 20:36:42	ce838b19-8107-461f-8006-35f707b9bab2
658	334	1	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-09-16 20:37:21	2021-09-16 20:37:21	1c34e9a2-684c-43f7-894d-66acd3a73d60
659	334	2	control-healpix-catalog	explorer/control-healpix-catalog	t	2021-09-16 20:37:21	2021-09-16 20:37:21	751b6de2-c5e0-4ef7-9a60-f2ec7029bbc7
660	335	1	landmarks	catalog/landmarks	t	2021-09-16 23:29:40	2021-09-16 23:29:40	8229354f-1ee0-4617-ae51-4081ebc53f53
661	335	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-09-16 23:29:40	2021-09-16 23:29:40	1431e4db-f73f-4f49-9599-eb6bca942413
662	336	1	landmarks	catalog/landmarks	t	2021-09-16 23:29:43	2021-09-16 23:29:43	85d8549e-25ad-45af-8c90-901a80c76de6
663	336	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-09-16 23:29:43	2021-09-16 23:29:43	db6dc1f7-8980-4e00-9a18-a20a26de16ff
666	338	1	\N	\N	t	2021-09-23 16:56:29	2021-09-23 16:56:29	7af9e660-5b0e-4c9f-9e42-ab98e436ec2a
667	338	2	\N	\N	t	2021-09-23 16:56:29	2021-09-23 16:56:29	4157059f-0dfa-46f5-97a6-ad7f260f32d5
668	339	1	stars	catalog/stars	t	2021-09-23 16:56:37	2021-09-23 16:56:37	cb3091ec-7018-4ab7-826a-9d1cb4935ae8
669	339	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-09-23 16:56:37	2021-09-23 16:56:37	b322f30a-4a4f-4bcd-842f-b1d1ce3d9714
672	341	1	\N	\N	t	2021-09-23 16:56:49	2021-09-23 16:56:49	4c829c3b-5120-499c-ad7b-3dbd812c33fe
673	341	2	\N	\N	t	2021-09-23 16:56:49	2021-09-23 16:56:49	898b92c3-5c81-4dd9-b0b4-2554c1f04f1f
674	342	1	galaxy	catalog/galaxy	t	2021-09-23 16:56:55	2021-09-23 16:56:55	b0b3e5ad-0428-41f2-b383-002b780c23a5
675	342	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-09-23 16:56:55	2021-09-23 16:56:55	d31b9e21-a545-43e1-a34c-0337eff53d66
678	344	1	\N	\N	t	2021-09-23 16:57:07	2021-09-23 16:57:07	7f5610d2-10b5-46bd-92cd-13f6ab5352ec
679	344	2	\N	\N	t	2021-09-23 16:57:07	2021-09-23 16:57:07	aa72f0cb-a3c5-441f-a607-8556a4e9665b
680	345	1	nebula	catalog/nebula	t	2021-09-23 16:57:13	2021-09-23 16:57:13	543c48f4-183c-4212-b67a-4ed2feb94b26
681	345	2	transients-catalog	catalog/transients-catalog	t	2021-09-23 16:57:13	2021-09-23 16:57:13	07028c5e-73e0-4bfd-bc32-ae36e4d37ba9
684	347	1	\N	\N	t	2021-09-23 16:57:23	2021-09-23 16:57:23	8f496acb-3be3-4867-906c-1b15bc158f80
685	347	2	\N	\N	t	2021-09-23 16:57:23	2021-09-23 16:57:23	ac5bb8fb-f0b1-435b-bd7f-bd29fc3d88d0
686	348	1	transient	catalog/transient	t	2021-09-23 16:57:44	2021-09-23 16:57:44	eec09317-6a4d-4d18-91ea-7bde27ecaebe
687	348	2	goals-catalog	catalog/goals-catalog	t	2021-09-23 16:57:44	2021-09-23 16:57:44	0afe5c55-cc79-4072-966a-9b35b58bc9c6
690	350	1	\N	\N	t	2021-09-23 16:57:55	2021-09-23 16:57:55	0543fb6b-bd3d-4034-96a4-79d2b53ef0a1
691	350	2	\N	\N	t	2021-09-23 16:57:55	2021-09-23 16:57:55	4a77c248-8168-4258-b15e-0755de5c5812
692	351	1	landmarks	catalog/landmarks	t	2021-09-23 16:58:01	2021-09-23 16:58:01	5055dabe-0568-4236-831e-b75360f025ad
693	351	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-09-23 16:58:01	2021-09-23 16:58:01	7b1add8b-ebee-4d97-82c7-903a41ba2989
696	353	1	\N	\N	t	2021-09-28 23:40:01	2021-09-28 23:40:01	7cb19fb1-b82c-4dec-80a1-1ecd12f36cf9
697	353	2	\N	\N	t	2021-09-28 23:40:02	2021-09-28 23:40:02	f8ba00f0-1773-46da-a883-26d9361e274a
698	354	1	stars	catalog/stars	t	2021-09-28 23:40:53	2021-09-28 23:40:53	e68f62f1-624e-4ac3-9f57-cf51043303b1
699	354	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-09-28 23:40:57	2021-09-28 23:40:57	1c84d911-823a-400c-97c1-34ce71bb950f
702	356	1	\N	\N	t	2021-09-28 23:42:12	2021-09-28 23:42:12	301efc83-4c93-4d24-a2a2-cd4ad5f5ac32
703	356	2	\N	\N	t	2021-09-28 23:42:13	2021-09-28 23:42:13	60d54210-f613-44c3-9e42-b7f132c941e2
704	357	1	galaxy	catalog/galaxy	t	2021-09-28 23:43:32	2021-09-28 23:43:32	8b578eb5-28af-4bb3-bdd2-1567e0ad0cc0
705	357	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-09-28 23:43:36	2021-09-28 23:43:36	2eb2671c-87ba-4b8a-8dcd-b0e0cf326cef
708	359	1	\N	\N	t	2021-09-28 23:45:34	2021-09-28 23:45:34	0f36ef52-1409-4ec3-8910-4fe821553e86
709	359	2	\N	\N	t	2021-09-28 23:45:36	2021-09-28 23:45:36	e147ada2-4660-41ec-82f1-eb1157929787
710	360	1	nebula	catalog/nebula	t	2021-09-28 23:46:31	2021-09-28 23:46:31	f0140946-b659-4ea4-b27c-36e602b506b8
711	360	2	transients-catalog	catalog/transients-catalog	t	2021-09-28 23:46:35	2021-09-28 23:46:35	34fee908-63f7-4044-ac16-3fb73334d86f
714	362	1	\N	\N	t	2021-09-28 23:48:41	2021-09-28 23:48:41	e4783a7f-1b91-48d8-a8a7-322a17a423d9
715	362	2	\N	\N	t	2021-09-28 23:48:43	2021-09-28 23:48:43	7e72e37c-321b-41fe-85ff-0a816a259707
716	363	1	transient	catalog/transient	t	2021-09-28 23:49:46	2021-09-28 23:49:46	0c89237a-8af9-4af3-b369-81a8a7b21954
717	363	2	goals-catalog	catalog/goals-catalog	t	2021-09-28 23:49:50	2021-09-28 23:49:50	e2811356-7a48-45a0-89d1-9506c8f5cdc8
720	365	1	\N	\N	t	2021-09-28 23:51:59	2021-09-28 23:51:59	3539b397-a782-4021-9418-12a39ab314af
721	365	2	\N	\N	t	2021-09-28 23:52:01	2021-09-28 23:52:01	e37de51b-b615-40dc-8815-990731634505
722	366	1	landmarks	catalog/landmarks	t	2021-09-28 23:52:57	2021-09-28 23:52:57	31b78d16-4b03-4b8f-b663-058ea8a4e476
723	366	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-09-28 23:53:01	2021-09-28 23:53:01	9bd7bf63-4ee8-4d87-aed8-88c2b318f767
724	367	1	__temp_kzfsfdmzolbqlsiyrjfmiyfuzrazzqbcospi	astro-object/__temp_kzfsfdmzolbqlsiyrjfmiyfuzrazzqbcospi	t	2021-09-29 00:03:17	2021-09-29 00:03:17	4e38bdfd-999d-4a5d-b7c6-eac7f5313aee
725	367	2	__temp_kzfsfdmzolbqlsiyrjfmiyfuzrazzqbcospi	astro-object/__temp_kzfsfdmzolbqlsiyrjfmiyfuzrazzqbcospi	t	2021-09-29 00:03:21	2021-09-29 00:03:21	cae38e4b-1d80-40f5-b5bc-489eb372da35
726	368	1	\N	\N	t	2021-09-29 19:39:30	2021-09-29 19:39:30	3401fedb-6150-467a-99c7-26a758a6ebb3
727	368	2	\N	\N	t	2021-09-29 19:39:32	2021-09-29 19:39:32	16740d65-8f18-451a-9343-425f39abf0e0
728	369	1	\N	\N	t	2021-09-29 19:39:40	2021-09-29 19:39:40	7df82128-597b-4362-af45-064408f00305
729	369	2	\N	\N	t	2021-09-29 19:39:42	2021-09-29 19:39:42	41241a77-f2c3-467e-800b-11a6e1a2d87c
730	370	1	\N	\N	t	2021-09-29 19:39:49	2021-09-29 19:39:49	b5e8f4ea-ae0f-4c13-8dc3-b58f04f62b00
731	370	2	\N	\N	t	2021-09-29 19:39:50	2021-09-29 19:39:50	0ac6aca9-484a-4526-966b-1ed5194200c6
732	371	1	\N	\N	t	2021-09-29 19:39:57	2021-09-29 19:39:57	f223ed8c-c77c-430f-86c1-53561f4392c7
733	371	2	\N	\N	t	2021-09-29 19:39:59	2021-09-29 19:39:59	51f076ac-9390-469a-8623-5afd6e6403fe
734	372	1	\N	\N	t	2021-09-29 19:40:05	2021-09-29 19:40:05	4b881aba-fad9-4c1e-9b56-f028df1f2379
735	372	2	\N	\N	t	2021-09-29 19:40:07	2021-09-29 19:40:07	5a2e5ba2-9b08-477e-b096-1427621db4b8
736	373	1	\N	\N	t	2021-09-29 19:40:13	2021-09-29 19:40:13	1a7ad706-ccf6-4898-a924-28bb1de7654c
737	373	2	\N	\N	t	2021-09-29 19:40:15	2021-09-29 19:40:15	1c899b65-7642-4ccc-a92c-0f8f07867d0f
738	374	1	test-cat	catalog/test-cat	t	2021-10-01 20:05:41	2021-10-01 20:05:48	14c0e73b-4bb5-4fc1-90ee-bf143e27ea3b
739	374	2	test-cat	catalog/test-cat	t	2021-10-01 20:05:41	2021-10-01 20:05:48	868d1fa1-0450-4340-b75c-49f8e98cec2a
740	375	1	test-cat	catalog/test-cat	t	2021-10-01 20:06:06	2021-10-01 20:06:06	18b389f8-9797-4b39-9a58-bc6a95748755
741	375	2	test-cat	catalog/test-cat	t	2021-10-01 20:06:06	2021-10-01 20:06:06	33bae434-c739-4b40-ab27-a2a29f715f61
742	376	1	\N	\N	t	2021-10-01 20:33:17	2021-10-01 20:33:17	472ee2de-661b-4a45-832b-e8b77a960b98
743	376	2	\N	\N	t	2021-10-01 20:33:18	2021-10-01 20:33:18	ede35f00-7a82-4403-a4fc-49ff4648a859
746	378	1	stars	catalog/stars	t	2021-10-01 20:33:23	2021-10-01 20:33:23	9644a9db-eb72-435e-93fe-10db3a77fbe9
747	378	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-10-01 20:33:23	2021-10-01 20:33:23	983ad949-aec1-4664-80b6-7e78cd841030
748	379	1	__temp_enzpusapxwopnnkpsqpjkpjcckhqtkiidcsa	catalog/__temp_enzpusapxwopnnkpsqpjkpjcckhqtkiidcsa	t	2021-10-04 22:28:14	2021-10-04 22:28:14	2ba29b04-1492-48be-9fe4-432b9de27452
749	379	2	__temp_enzpusapxwopnnkpsqpjkpjcckhqtkiidcsa	catalog/__temp_enzpusapxwopnnkpsqpjkpjcckhqtkiidcsa	t	2021-10-04 22:28:15	2021-10-04 22:28:15	b9a999c0-e53d-4446-8b1c-400f6788ae7a
750	380	1	\N	\N	t	2021-10-08 00:35:09	2021-10-08 00:35:09	64c339bc-74a1-4843-9237-140e81402f51
751	380	2	\N	\N	t	2021-10-08 00:35:10	2021-10-08 00:35:10	a1a64ad5-f789-4bc2-83c9-80d340103721
754	382	1	\N	\N	t	2021-10-08 22:40:04	2021-10-08 22:40:04	3c870729-6802-4158-88c7-156c688a8824
755	382	2	\N	\N	t	2021-10-08 22:40:04	2021-10-08 22:40:04	d311cf8d-e96d-4e7c-adb8-2b88dbbee611
756	383	1	stars	catalog/stars	t	2021-10-08 22:40:17	2021-10-08 22:40:17	720b21c5-175a-4693-9201-a61af1aa4454
757	383	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-10-08 22:40:17	2021-10-08 22:40:17	d844bb1c-2e25-40a7-933c-9b34d673b54b
758	384	1	\N	\N	t	2021-10-08 22:40:37	2021-10-08 22:40:37	60e9803e-13a9-421f-a6f7-36e8302b1a30
759	384	2	\N	\N	t	2021-10-08 22:40:38	2021-10-08 22:40:38	9bca10c1-a4c5-4d3b-9e57-d4c15ff36f49
762	386	1	galaxy	catalog/galaxy	t	2021-10-08 22:40:48	2021-10-08 22:40:48	1e1a16c9-426e-4234-aa0b-5745c7f65d90
763	386	2	nebulae-catalog	catalog/nebulae-catalog	t	2021-10-08 22:40:48	2021-10-08 22:40:48	a235edfd-41e9-4716-ab50-4e903552ea5b
764	387	1	\N	\N	t	2021-10-08 22:42:27	2021-10-08 22:42:27	927191b2-9123-46a1-a071-d279e15c5832
765	387	2	\N	\N	t	2021-10-08 22:42:27	2021-10-08 22:42:27	6ed721f7-4002-4e65-8724-915146f014ef
768	389	1	nebula	catalog/nebula	t	2021-10-08 22:42:36	2021-10-08 22:42:36	60b52f6c-b4d6-4b6a-a211-3cf6ffca34f5
769	389	2	transients-catalog	catalog/transients-catalog	t	2021-10-08 22:42:36	2021-10-08 22:42:36	5e9ad88d-4649-45aa-8da7-b5ac2e2c3cd3
770	390	1	\N	\N	t	2021-10-08 22:42:47	2021-10-08 22:42:47	870e9342-7ad6-43e6-9ea9-c595187f5d6f
771	390	2	\N	\N	t	2021-10-08 22:42:48	2021-10-08 22:42:48	06e07413-b850-4dba-b6e5-066d4e1a6626
774	392	1	transient	catalog/transient	t	2021-10-08 22:42:55	2021-10-08 22:42:55	312513b5-6bf0-4543-9238-25644121d144
775	392	2	goals-catalog	catalog/goals-catalog	t	2021-10-08 22:42:55	2021-10-08 22:42:55	9905c87f-b9a3-44ab-a17c-bdcf8f3e4cab
776	393	1	\N	\N	t	2021-10-08 22:43:09	2021-10-08 22:43:09	aa72f64a-b784-4aee-bada-2f65a7695310
777	393	2	\N	\N	t	2021-10-08 22:43:09	2021-10-08 22:43:09	656e3f1e-3f3d-4e66-a681-8eea63885c2a
782	396	1	landmarks	catalog/landmarks	t	2021-10-08 22:43:16	2021-10-08 22:43:16	c6e286e8-ce51-4de5-b84c-c0e7181b05a2
783	396	2	landmarks-catalog	catalog/landmarks-catalog	t	2021-10-08 22:43:16	2021-10-08 22:43:16	672bd51f-e189-4a7a-8913-0f42d93fc082
784	397	1	stars	catalog/stars	t	2021-10-08 22:43:20	2021-10-08 22:43:20	311db894-7fcf-451b-8566-368c13df050c
785	397	2	galaxies-catalog	catalog/galaxies-catalog	t	2021-10-08 22:43:20	2021-10-08 22:43:20	a073036d-bf3e-4136-8387-38cbb06c012d
786	398	1	\N	\N	t	2021-10-08 23:03:44	2021-10-08 23:03:44	04bf9ea2-8719-4a00-bb36-4a2ee9b76a18
787	398	2	\N	\N	t	2021-10-08 23:03:47	2021-10-08 23:03:47	e16a5dd3-2313-4ec1-bc10-c2af9a5199e3
788	399	1	\N	\N	t	2021-10-08 23:04:45	2021-10-08 23:04:45	60a6147f-808a-4e3f-aae3-79c58bbd4cee
789	399	2	\N	\N	t	2021-10-08 23:04:46	2021-10-08 23:04:46	c894808b-4a15-4164-8398-73f93da85cf3
792	401	1	check-out-this-tour	astro-object/check-out-this-tour	t	2021-10-08 23:04:53	2021-10-08 23:04:53	0529d7de-dd30-4ec9-adeb-dfcd55f63a12
793	401	2	check-out-this-tour	astro-object/check-out-this-tour	t	2021-10-08 23:04:53	2021-10-08 23:04:53	b543247f-acbd-4d34-acdf-ef7791ee22af
796	403	1	whoa	astro-object/whoa	t	2021-10-08 23:05:09	2021-10-08 23:05:09	b48d86fe-2185-4485-ab85-4a744f353355
797	403	2	whoa	astro-object/whoa	t	2021-10-08 23:05:09	2021-10-08 23:05:09	d4a6e470-576b-4f60-9e6f-594b0578235d
800	405	1	this-is-a-brand-new-astro-object	astro-object/this-is-a-brand-new-astro-object	t	2021-10-08 23:05:41	2021-10-08 23:05:41	7e710cc7-6229-488a-8aba-a240d87885b6
801	405	2	this-is-a-brand-new-astro-object	astro-object/this-is-a-brand-new-astro-object	t	2021-10-08 23:05:42	2021-10-08 23:05:42	251cd927-f3f4-4e0d-9671-fd33c20daf16
804	407	1	this-is-a-cloud-astro-object	astro-object/this-is-a-cloud-astro-object	t	2021-10-08 23:05:58	2021-10-08 23:05:58	5ae8d386-733b-4378-945c-8c22c4fa77d5
805	407	2	this-is-a-cloud-astro-object	astro-object/this-is-a-cloud-astro-object	t	2021-10-08 23:05:58	2021-10-08 23:05:58	21540619-c930-47a0-a0e1-766a504421ab
814	412	1	the-search-for-aliens	tour/the-search-for-aliens	t	2021-10-08 23:06:43	2021-10-08 23:06:43	84d55179-532c-4231-ae51-61fb52f14cc6
815	412	2	the-search-for-aliens	tour/the-search-for-aliens	t	2021-10-08 23:06:43	2021-10-08 23:06:43	97a99195-480c-44f3-af99-f1bffc5724f0
816	413	1	\N	\N	t	2021-10-08 23:06:44	2021-10-08 23:06:44	b2391a39-bbad-484c-aacd-b4c60bd7db73
817	413	2	\N	\N	t	2021-10-08 23:06:44	2021-10-08 23:06:44	fac807fd-687f-4730-acdf-4cf09f055fb6
818	414	1	\N	\N	t	2021-10-08 23:06:44	2021-10-08 23:06:44	e806e34d-089f-4607-a412-a35f520e5e92
819	414	2	\N	\N	t	2021-10-08 23:06:44	2021-10-08 23:06:44	9ca0468d-fb30-4380-8f52-aae24fe1d250
820	415	1	\N	\N	t	2021-10-08 23:06:44	2021-10-08 23:06:44	3bfc83ea-b640-4f5f-8b60-0114caa11562
821	415	2	\N	\N	t	2021-10-08 23:06:44	2021-10-08 23:06:44	7dca5c7e-f26f-4497-a755-bad3581dc082
830	420	1	tour-de-force	tour/tour-de-force	t	2021-10-08 23:07:34	2021-10-08 23:07:34	c31cee1e-afb3-4b48-b089-e3673ab3bcbe
831	420	2	tour-de-force	tour/tour-de-force	t	2021-10-08 23:07:34	2021-10-08 23:07:34	e7ed082e-b7cf-4c77-9686-833f0a094fd2
832	421	1	\N	\N	t	2021-10-08 23:07:34	2021-10-08 23:07:34	2b3fb669-7ae7-4d74-9ab7-7b22a0d9a0f5
833	421	2	\N	\N	t	2021-10-08 23:07:34	2021-10-08 23:07:34	8c79ae28-068d-44e4-bb70-ad705c1eb363
834	422	1	\N	\N	t	2021-10-08 23:07:34	2021-10-08 23:07:34	b49059cc-ed31-47d5-aff3-2871faec9bc7
835	422	2	\N	\N	t	2021-10-08 23:07:34	2021-10-08 23:07:34	a7b5d6fb-8d01-4355-87da-fcdb3f7d77a5
836	423	1	\N	\N	t	2021-10-08 23:07:34	2021-10-08 23:07:34	08807830-b384-45ec-a8ae-e85eb53847d8
837	423	2	\N	\N	t	2021-10-08 23:07:34	2021-10-08 23:07:34	185c69b4-10ce-464e-b3c5-7d0c528e427b
182	95	1	tour-de-force	tour/tour-de-force	t	2021-07-16 18:43:41	2021-10-08 23:07:37	1120e1d1-300f-49f1-a91d-8d860392cf76
838	424	1	\N	\N	t	2021-10-08 23:07:57	2021-10-08 23:07:57	c408c90b-1bc1-4989-9685-3a4b0c30dc20
839	424	2	\N	\N	t	2021-10-08 23:07:59	2021-10-08 23:07:59	3846d9ec-d783-4fed-bda4-4b027de87fa9
848	429	1	another-fine-tour	tour/another-fine-tour	t	2021-10-08 23:08:17	2021-10-08 23:08:17	9de485f9-0578-45e3-80d6-cd6e7d4ac351
849	429	2	another-fine-tour	tour/another-fine-tour	t	2021-10-08 23:08:17	2021-10-08 23:08:17	f827135b-7501-45af-a0df-a0b01da64aea
850	430	1	\N	\N	t	2021-10-08 23:08:17	2021-10-08 23:08:17	e23db8af-b497-4466-a9cc-ce55806b5b34
851	430	2	\N	\N	t	2021-10-08 23:08:17	2021-10-08 23:08:17	f40bdc37-3f70-4fb0-8223-0ed573e10b62
852	431	1	\N	\N	t	2021-10-08 23:08:17	2021-10-08 23:08:17	905d0d1b-cd01-45ae-ae3a-b5801664a204
853	431	2	\N	\N	t	2021-10-08 23:08:17	2021-10-08 23:08:17	11817653-dc75-4fec-a51a-139e7a565c62
854	432	1	\N	\N	t	2021-10-08 23:08:17	2021-10-08 23:08:17	199185a7-45cc-438d-824a-25f3851e6c0c
855	432	2	\N	\N	t	2021-10-08 23:08:17	2021-10-08 23:08:17	640539b7-9173-497f-8de6-d80dd8b50ce4
864	437	1	a-tour-of-the-cloud	tour/a-tour-of-the-cloud	t	2021-10-08 23:08:49	2021-10-08 23:08:49	9e90f0eb-7845-48e3-adb8-43b818a784d8
865	437	2	a-tour-of-the-cloud	tour/a-tour-of-the-cloud	t	2021-10-08 23:08:49	2021-10-08 23:08:49	03ad53ff-f42c-47f6-91f1-7b7983c528db
866	438	1	\N	\N	t	2021-10-08 23:08:49	2021-10-08 23:08:49	e9fe8625-177a-4e84-8faf-9744356704b2
867	438	2	\N	\N	t	2021-10-08 23:08:49	2021-10-08 23:08:49	54477a4a-2d23-457c-a591-b29a9f29a781
868	439	1	\N	\N	t	2021-10-08 23:08:49	2021-10-08 23:08:49	800d7a4e-3798-4338-91af-afe6f32d705d
869	439	2	\N	\N	t	2021-10-08 23:08:49	2021-10-08 23:08:49	7dbd453f-ca5c-4b52-8282-99035b5423da
870	440	1	\N	\N	t	2021-10-08 23:08:49	2021-10-08 23:08:49	af5d72ac-7b83-40f5-b9a9-30bc417907b7
871	440	2	\N	\N	t	2021-10-08 23:08:50	2021-10-08 23:08:50	37108fba-cb0f-4cd7-8d47-be9c7307e4a7
874	442	1	this-is-a-cloud-astro-object	astro-object/this-is-a-cloud-astro-object	t	2021-10-22 19:54:06	2021-10-22 19:54:06	b367f3cc-46a4-4ae5-8017-731346ec852c
875	442	2	this-is-a-cloud-astro-object	astro-object/this-is-a-cloud-astro-object	t	2021-10-22 19:54:11	2021-10-22 19:54:11	36096e34-14f7-4d70-bbd8-4c5377fff0c7
876	443	1	\N	\N	t	2021-10-22 22:20:36	2021-10-22 22:20:36	53ff3ac1-8795-4fdb-9db2-6dbb56187d7d
877	443	2	\N	\N	t	2021-10-22 22:20:37	2021-10-22 22:20:37	4dd4dd4a-6050-4574-b2e3-6394e6bced0c
878	444	1	\N	\N	t	2021-10-25 21:50:50	2021-10-25 21:50:50	fadb5905-e980-4abf-936f-d206c226b211
879	444	2	\N	\N	t	2021-10-25 21:50:51	2021-10-25 21:50:51	5e6bdbe7-4404-46dc-b80d-bfcf66de6ae9
880	445	1	\N	\N	t	2021-10-26 17:15:00	2021-10-26 17:15:00	e2029678-3ac0-4d3b-843b-44868511889b
881	445	2	\N	\N	t	2021-10-26 17:15:00	2021-10-26 17:15:00	b139c97e-7e7f-4946-ae5b-5d625b83b70b
\.


--
-- TOC entry 4590 (class 0 OID 16584)
-- Dependencies: 228
-- Data for Name: entries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.entries (id, "sectionId", "parentId", "typeId", "authorId", "postDate", "expiryDate", "deletedWithEntryType", "dateCreated", "dateUpdated", uid) FROM stdin;
3	1	\N	1	1	2021-05-19 22:50:00	\N	\N	2021-05-19 22:50:51	2021-05-19 22:50:51	e57983ea-fed0-448f-9749-5b4e03328420
4	1	\N	1	1	2021-05-19 22:52:00	\N	\N	2021-05-19 22:52:54	2021-05-19 22:52:54	bb0f2e53-99b3-44f8-97fe-1f44c3dd4920
5	1	\N	1	1	2021-05-19 22:53:00	\N	\N	2021-05-19 22:53:34	2021-05-19 22:53:34	5a231364-6555-40f6-9590-db6dac2b0d87
9	1	\N	1	1	2021-06-15 16:49:00	\N	\N	2021-06-15 16:50:17	2021-06-15 16:50:17	fbd60a79-b20b-4708-95f5-f0428476ee54
10	1	\N	1	1	2021-06-15 16:58:00	\N	\N	2021-06-15 16:58:55	2021-06-15 16:58:55	44539c8f-e294-418f-a012-1c01c1f9dcce
11	1	\N	1	1	2021-06-15 16:59:00	\N	\N	2021-06-15 16:59:52	2021-06-15 16:59:52	1dd1a4b8-adcc-43b3-b409-2a52ebb1a2ee
12	1	\N	1	1	2021-06-15 16:49:00	\N	\N	2021-06-15 17:04:56	2021-06-15 17:04:56	c61ba006-d2c3-4b29-8209-39e3bcfb71f7
14	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-06-15 17:17:51	2021-06-15 17:17:51	aed89b20-67bc-426f-bc94-cdf6a2dcc71b
15	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-06-15 17:17:51	2021-06-15 17:17:51	49f09209-aee9-4434-8306-843d1f3c6dd6
83	1	\N	1	1	2021-07-16 17:52:00	\N	\N	2021-07-16 17:53:05	2021-07-16 17:53:05	967d1e6e-c4e0-4b0d-bc1b-2d12af11415c
16	1	\N	1	1	2021-06-15 16:49:00	\N	\N	2021-06-15 17:21:23	2021-06-15 17:21:23	91d667ef-8c64-4a2d-8af5-f7b3538b9017
18	1	\N	1	1	2021-06-15 16:49:00	\N	\N	2021-06-15 17:23:28	2021-06-15 17:23:28	6e198a6a-17b7-4123-bf9a-ba6f8c82fd14
20	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-06-15 17:23:49	2021-06-15 17:23:49	910a4b70-5f5e-4229-8b3d-23d6abcb658c
23	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-06-15 17:34:27	2021-06-15 17:34:27	6afc817b-8843-4749-81a6-7580fdd17dbf
24	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-06-15 17:34:27	2021-06-15 17:34:27	f9f15e62-0e45-4dc5-83aa-08c8b2a33798
27	1	\N	1	1	2021-06-15 17:50:00	\N	\N	2021-06-15 17:51:12	2021-06-15 17:51:12	73853c90-fa02-402b-a68d-6f4114841b47
28	1	\N	1	1	2021-06-15 17:50:00	\N	\N	2021-06-15 17:51:12	2021-06-15 17:51:12	a2074219-39fb-40a4-a18e-fab1eca1188f
31	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-06-15 17:54:44	2021-06-15 17:54:44	4d93a522-0050-4b96-87c4-0b2e67fd0ab9
32	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-06-15 17:54:45	2021-06-15 17:54:45	5b90d1d2-d922-4b5c-b099-b79cd807ddc9
84	1	\N	1	1	2021-07-16 18:41:00	\N	\N	2021-07-16 18:41:34	2021-07-16 18:41:34	a82a61c2-d4b7-4244-b918-30a6b6c29006
35	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-06-15 17:58:32	2021-06-15 17:58:32	258c9724-ce1a-4846-b587-15f13cca94ca
36	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-06-15 17:58:33	2021-06-15 17:58:33	b17b7ba4-5950-481b-8707-f84190cef42e
39	1	\N	1	1	2021-06-15 18:05:00	\N	\N	2021-06-15 18:07:52	2021-06-15 18:07:52	f86692cb-b3b8-4c11-b9ff-2bb24f29a8ac
92	7	\N	8	1	2021-07-16 18:43:00	\N	\N	2021-07-16 18:43:22	2021-07-16 18:43:22	2d8f738b-e88e-410c-9c45-c58d364d4008
42	1	\N	1	1	2021-06-15 18:11:00	\N	\N	2021-06-15 18:11:30	2021-06-15 18:11:30	5586be81-889d-4be0-be2e-0f53b5f0850b
93	7	\N	8	1	2021-07-16 18:43:00	\N	\N	2021-07-16 18:43:23	2021-07-16 18:43:23	75ee8756-1955-44b1-8652-fee1c720b1ed
43	2	\N	2	1	2021-06-15 21:36:00	\N	\N	2021-06-15 21:36:09	2021-06-15 21:36:09	207a0342-493b-4ab6-bbca-d08f5d2f2976
45	2	\N	2	1	2021-06-15 21:37:00	\N	\N	2021-06-15 21:38:14	2021-06-15 21:38:14	7963db85-8999-45dc-af77-3c69233f55c3
46	2	\N	2	1	2021-06-15 21:37:00	\N	\N	2021-06-15 21:38:14	2021-06-15 21:38:14	b5291ad8-7d96-4c87-910c-6a92212b436a
95	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-07-16 18:43:41	2021-07-16 18:43:41	fbaa5b63-833e-4dc8-96e4-e8f050219a60
38	1	\N	1	1	2021-06-15 18:05:00	\N	f	2021-06-15 18:07:52	2021-06-15 18:07:52	e3665b4e-d4dd-4dc4-b9fa-6249bb942a89
47	3	\N	3	1	2021-06-21 22:42:00	\N	\N	2021-06-21 22:42:31	2021-06-21 22:42:31	6ff39762-a60c-4a0e-abec-33f4f3143161
54	4	\N	5	1	2021-06-21 23:04:00	\N	\N	2021-06-21 23:04:33	2021-06-21 23:04:33	d87812dd-dacf-449a-a05d-d921995ad38c
61	5	\N	6	1	2021-06-21 23:06:00	\N	\N	2021-06-21 23:06:50	2021-06-21 23:06:50	0686f096-e929-4f6f-8afa-4945718ca8a5
66	6	\N	7	1	2021-06-21 23:15:00	\N	\N	2021-06-21 23:15:44	2021-06-21 23:15:44	763cd0b2-e720-47b7-9c59-49b3dd3274ca
67	3	\N	3	1	2021-06-21 22:59:00	\N	\N	2021-06-21 23:15:49	2021-06-21 23:15:49	455f6b3f-b480-40fa-978f-0b8bea31ecab
68	3	\N	3	1	2021-06-21 22:59:00	\N	\N	2021-06-21 23:15:49	2021-06-21 23:15:49	76d353cf-965a-4a75-b937-59691d617001
99	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-07-16 18:43:41	2021-07-16 18:43:41	52da15a6-1a30-42a2-b059-7d31479cf0fc
57	5	\N	6	1	2021-06-21 23:06:00	\N	t	2021-06-21 23:06:50	2021-06-21 23:06:50	a00afc32-28f2-46bb-b0f2-d5b1259abbf0
51	4	\N	5	1	2021-06-21 23:04:00	\N	t	2021-06-21 23:04:33	2021-06-21 23:04:33	fb5ff89a-bf0c-45ad-807a-decaee0bc3bf
70	3	\N	3	1	2021-06-21 22:59:00	\N	\N	2021-06-22 21:51:08	2021-06-22 21:51:08	6fd977f0-6a06-4ab8-8381-e7d8c1b0217b
74	3	\N	3	1	2021-06-21 22:59:00	\N	\N	2021-06-22 21:51:45	2021-06-22 21:51:45	87163f1c-2a42-4693-9a04-97ffe53b69f6
103	7	\N	8	1	2021-07-16 18:43:00	\N	\N	2021-07-16 18:45:50	2021-07-16 18:45:50	820146c9-23de-4a38-b0de-10e9680ff0e5
104	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-07-16 18:45:52	2021-07-16 18:45:52	3c0300b2-2f66-44a9-8747-cc03564622cd
108	3	\N	3	1	2021-06-21 22:59:00	\N	\N	2021-07-19 22:32:07	2021-07-19 22:32:07	72548d70-ac15-46bd-90fd-6bd0fd451c94
65	6	\N	7	1	2021-06-21 23:15:00	\N	t	2021-06-21 23:15:44	2021-06-21 23:15:44	46ac7fc8-448b-4d0a-8514-2aff98fd72e4
121	1	\N	1	1	2021-06-15 16:49:00	\N	\N	2021-08-06 22:23:02	2021-08-06 22:23:02	f7cb92b5-00b5-4e8f-bce9-3fc6fef24a53
122	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-08-06 22:23:19	2021-08-06 22:23:19	ffc0f27e-1a3d-4f08-83d7-a3bc763f9d17
123	1	\N	1	1	2021-06-15 16:49:00	\N	\N	2021-08-06 22:23:24	2021-08-06 22:23:24	86625684-e4d5-40cb-8a14-3e70bc7d828b
124	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-08-06 22:23:40	2021-08-06 22:23:40	f3477b66-ce20-4def-81fd-e5ea356bc425
125	1	\N	1	1	2021-06-15 17:50:00	\N	\N	2021-08-06 22:23:52	2021-08-06 22:23:52	ab0821cc-8d9d-4cb1-bd52-b024991346ff
126	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-08-06 22:24:07	2021-08-06 22:24:07	1cf18b96-8c91-4a2f-9209-d840c93661e7
127	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-08-06 22:24:29	2021-08-06 22:24:29	108d6dd7-cbd6-48a8-9084-1e58046a95a2
132	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-08-06 22:25:54	2021-08-06 22:25:54	7d9ccdbc-08a4-49fa-84a2-e2c0b886ae94
128	1	\N	1	1	2021-06-15 16:49:00	\N	\N	2021-08-06 22:25:32	2021-08-06 22:25:32	04598a14-e6d4-4e91-af42-0812c4e4316a
129	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-08-06 22:25:37	2021-08-06 22:25:37	12152808-a188-41fa-a7b7-fa33f5d930c9
130	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-08-06 22:25:41	2021-08-06 22:25:41	20813d91-723c-4deb-8fd5-6b8205043237
131	1	\N	1	1	2021-06-15 17:50:00	\N	\N	2021-08-06 22:25:45	2021-08-06 22:25:45	22e37b2f-2293-46df-a612-55b5fc034755
133	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-08-06 22:25:59	2021-08-06 22:25:59	f570dd8e-7148-4b00-88d4-9d5eebcb001c
134	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-08-06 22:26:07	2021-08-06 22:26:07	a82ccc36-a402-4cd7-86bf-87673a41a9bc
135	2	\N	2	1	2021-06-15 21:37:00	\N	\N	2021-08-06 22:26:30	2021-08-06 22:26:30	b4a56a3d-d123-4b4d-be2e-b796ad0069e7
139	8	\N	9	1	2021-08-06 22:54:00	\N	\N	2021-08-06 22:54:56	2021-08-06 22:54:56	e114399e-44e4-48ed-b28b-77434e2b827e
140	8	\N	9	1	2021-08-06 22:54:00	\N	\N	2021-08-06 22:56:21	2021-08-06 22:56:21	e97c527b-d5d8-42e1-b357-a2bf4111cfd7
141	3	\N	3	1	2021-06-21 22:59:00	\N	\N	2021-08-06 23:02:41	2021-08-06 23:02:41	997eb146-f72b-44b0-b95c-c543ef43102e
145	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-08-06 23:02:51	2021-08-06 23:02:51	4ed6fe14-af16-4665-892a-31f9f09e0cf9
149	8	\N	9	1	2021-08-06 22:54:00	\N	\N	2021-08-06 23:03:19	2021-08-06 23:03:19	4ccd2694-0f3c-4fb5-8968-3193e5ea6a93
138	8	\N	9	1	2021-08-06 22:54:00	\N	t	2021-08-06 22:54:56	2021-08-06 22:54:56	c1322944-9e19-4236-af3e-cb16c36f037d
8	1	\N	1	1	2021-06-15 16:49:00	\N	f	2021-06-15 16:50:17	2021-06-15 16:50:17	3c3972bb-e188-4e9c-969d-cf644cc5e79d
150	3	\N	3	1	2021-06-21 22:59:00	\N	\N	2021-08-06 23:04:32	2021-08-06 23:04:32	5dc81a33-b7fd-472a-9d99-798c940c059a
154	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-08-06 23:04:44	2021-08-06 23:04:44	1e792e51-1e75-45e4-86a6-34d44c03dc0a
158	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-08-06 23:05:17	2021-08-06 23:05:17	2cfd99d1-6e36-433e-ae01-7bbd7d3e5778
82	1	\N	1	1	2021-07-16 17:52:00	\N	f	2021-07-16 17:53:05	2021-07-16 17:53:05	dc551304-32d1-41aa-9fd9-1e5e06bce633
162	2	\N	2	1	2021-06-15 21:37:00	\N	\N	2021-08-06 23:06:48	2021-08-06 23:06:48	c29a86c1-f67b-4987-82a1-76d3eb3e3ef8
163	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-08-06 23:09:51	2021-08-06 23:09:51	35f63827-e7a2-4b2f-ab9d-67594454c56c
164	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-08-06 23:10:01	2021-08-06 23:10:01	7a4d4f66-e4e3-4012-98e2-737cd6dc3b68
165	1	\N	1	1	2021-06-15 17:50:00	\N	\N	2021-08-06 23:10:10	2021-08-06 23:10:10	f0c8d931-5d7a-4daa-974d-23b2913d0b15
166	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-08-06 23:10:21	2021-08-06 23:10:21	0c7de717-2b07-43aa-8f2c-33bca2113362
41	1	\N	1	1	2021-06-15 18:11:00	\N	f	2021-06-15 18:11:30	2021-06-15 18:11:30	b5b38384-9a63-42f9-9992-304ced62ce1e
168	3	\N	3	1	2021-06-21 22:59:00	\N	\N	2021-08-17 20:25:11	2021-08-17 20:25:11	a6b0d23b-a144-4ab7-8f96-b674d3704ae7
172	2	\N	2	1	2021-06-15 21:37:00	\N	\N	2021-08-17 20:25:16	2021-08-17 20:25:16	95d8647c-819c-4735-a21d-e33b472951fb
173	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-08-17 20:25:35	2021-08-17 20:25:35	5483d7b4-83a4-4658-9bff-ed5f9623dd81
179	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-08-17 20:28:35	2021-08-17 20:28:35	3d2cca5f-1ffa-42ea-b414-5a169541dc2f
183	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-08-17 20:29:06	2021-08-17 20:29:06	280ed2fd-71a3-4316-894e-6d8ce44b252d
188	1	\N	1	1	2021-06-15 16:49:00	\N	\N	2021-08-17 20:35:45	2021-08-17 20:35:45	e9847f57-4017-428c-ab0a-ca46fda2db79
190	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-08-17 20:36:03	2021-08-17 20:36:03	e94dd2e5-5b9b-423d-b572-9a24f5ee4d0a
192	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-08-17 20:36:18	2021-08-17 20:36:18	e876d0a1-bddc-422d-ac53-1ed7ee05e99a
194	1	\N	1	1	2021-06-15 17:50:00	\N	\N	2021-08-17 20:36:40	2021-08-17 20:36:40	5f3fe8e3-f6d0-446c-88d2-3bf34454c4c7
196	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-08-17 20:37:02	2021-08-17 20:37:02	0bb61025-6dca-481c-ba31-aa66ed12911f
198	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-08-17 20:37:17	2021-08-17 20:37:17	499f9b70-5d97-41c8-a0c0-9f79c59b7e67
200	7	\N	8	1	2021-07-16 18:43:00	\N	\N	2021-08-17 20:41:25	2021-08-17 20:41:25	3d409dc3-23a6-4612-8f85-a5421e300111
201	3	\N	3	1	2021-08-17 20:43:00	\N	\N	2021-08-17 20:43:58	2021-08-17 20:43:58	aa245f94-1a06-4e43-aee2-6981b57fc1de
202	2	\N	2	1	2021-08-17 21:26:00	\N	\N	2021-08-17 21:26:23	2021-08-17 21:26:23	404a438c-b352-49fe-93b9-a9755602c02a
203	3	\N	3	1	2021-08-20 21:48:00	\N	\N	2021-08-20 21:48:32	2021-08-20 21:48:32	6c05c90e-6fa9-4c15-8016-6f1235ac5de5
209	7	\N	8	1	2021-07-16 18:43:00	\N	\N	2021-08-20 21:56:12	2021-08-20 21:56:12	c6f00b34-ea4b-4d29-8260-bbc0f3870bc0
210	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-08-20 21:56:58	2021-08-20 21:56:58	64f2f067-1e64-4095-9ccb-c8b297e4343c
220	1	\N	1	1	2021-06-15 16:49:00	\N	\N	2021-08-20 22:02:00	2021-08-20 22:02:00	47d37c58-7e62-4bdd-93e3-f7a424603d33
221	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-08-20 22:02:33	2021-08-20 22:02:33	e0154067-4c19-4bee-80d9-cbec439a6894
222	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-08-20 22:03:07	2021-08-20 22:03:07	616a87c6-1d1e-4238-8776-a6a70e597ba7
223	1	\N	1	1	2021-06-15 17:50:00	\N	\N	2021-08-20 22:03:29	2021-08-20 22:03:29	97c8366a-de31-4080-a818-6de2b484f9a9
224	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-08-20 22:04:11	2021-08-20 22:04:11	eca4b37a-0724-4714-affe-a0e6319b0b87
225	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-08-20 22:04:39	2021-08-20 22:04:39	5bc88ff3-e66f-41f0-9b2c-532600360d50
226	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-08-20 22:04:44	2021-08-20 22:04:44	4cba1ffc-52b5-408d-abf6-5cd7c5e100b1
227	3	\N	3	1	2021-08-30 21:31:00	\N	\N	2021-08-30 21:31:02	2021-08-30 21:31:02	29e4999e-d380-4f3a-9b3b-eff1d5a22542
240	7	\N	8	1	2021-08-30 21:32:00	\N	\N	2021-08-30 21:32:31	2021-08-30 21:32:31	fdb75ca9-64b9-4b36-827d-db4bc6bbc505
241	7	\N	8	1	2021-08-30 21:32:00	\N	\N	2021-08-30 21:32:31	2021-08-30 21:32:31	6dc3f0c8-299a-4f19-96b0-410abb33744f
243	3	\N	3	1	2021-08-30 21:31:00	\N	\N	2021-08-30 21:32:35	2021-08-30 21:32:35	d717348e-fe6d-4e6e-901e-b2a27edd0ac6
251	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-09-08 17:50:58	2021-09-08 17:50:58	127c9ee5-a7b3-4790-a0e7-f1f3f8c6cd33
318	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-09-14 22:23:30	2021-09-14 22:23:30	e7051da7-f0ec-404c-8564-e154c7c0b909
259	3	\N	3	1	2021-06-21 22:59:00	\N	\N	2021-09-08 17:54:32	2021-09-08 17:54:32	a9544fec-f094-4e5d-a443-df4a61d21254
267	3	\N	3	1	2021-08-30 21:31:00	\N	\N	2021-09-08 17:54:51	2021-09-08 17:54:51	d4aeb15a-9ec5-40ef-95a5-79df9df61c8e
275	3	\N	3	1	2021-08-30 21:31:00	\N	\N	2021-09-08 17:55:09	2021-09-08 17:55:09	b264c50b-befa-4395-8296-485212ed98ad
326	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-09-14 22:32:05	2021-09-14 22:32:05	dc29c9a2-3f2f-4cec-bdac-b5ea6c4ba865
291	7	\N	8	1	2021-09-08 17:58:00	\N	\N	2021-09-08 17:58:53	2021-09-08 17:58:53	effaf4f2-54bb-4b42-b4ba-e78c12f71f59
292	7	\N	8	1	2021-09-08 17:58:00	\N	\N	2021-09-08 17:58:54	2021-09-08 17:58:54	d3647a34-76bd-41cb-965b-c8914178ee69
294	3	\N	3	1	2021-09-08 17:55:00	\N	\N	2021-09-08 17:58:58	2021-09-08 17:58:58	cb677657-d210-48bb-ae57-2b0a505af5de
279	3	\N	3	1	2021-09-08 17:55:00	\N	f	2021-09-08 17:55:33	2021-09-08 17:55:33	2700fae0-7420-45e7-9a29-c0a7888fb9a4
298	3	\N	3	1	2021-09-08 18:23:00	\N	\N	2021-09-08 18:23:50	2021-09-08 18:23:50	4076af33-e3cc-4c07-a9c2-27be467e2b71
308	7	\N	8	1	2021-09-08 18:26:00	\N	\N	2021-09-08 18:26:41	2021-09-08 18:26:41	c13db5c6-cb6b-4662-87c0-4761322af0d1
309	7	\N	8	1	2021-09-08 18:26:00	\N	\N	2021-09-08 18:26:41	2021-09-08 18:26:41	0aefd06a-914a-40a0-8ad3-a3a1b369474e
311	3	\N	3	1	2021-09-08 18:23:00	\N	\N	2021-09-08 18:26:58	2021-09-08 18:26:58	554cb0a8-4452-4a6b-9093-0549293694e1
316	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-09-14 22:23:01	2021-09-14 22:23:01	01a5b635-f9f6-4bcf-8003-64d9442cf48d
332	2	\N	2	1	2021-06-15 21:37:00	\N	\N	2021-09-16 20:36:42	2021-09-16 20:36:42	ea5705df-b158-466c-9111-2695d37dd6d7
328	2	\N	2	1	2021-06-15 21:37:00	\N	\N	2021-09-14 22:43:07	2021-09-14 22:43:07	caee1a13-b3bd-45b2-96f1-57f7f9c4a340
335	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-09-16 23:29:40	2021-09-16 23:29:40	c422cc13-0f62-4ca4-84d8-12d28a15f471
330	2	\N	2	1	2021-06-15 21:37:00	\N	\N	2021-09-16 20:36:16	2021-09-16 20:36:16	855d013d-7c82-4728-b547-f781d39d5f45
336	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-09-16 23:29:43	2021-09-16 23:29:43	b8692bbf-28b3-4c27-8b6e-8ec538ca3021
334	2	\N	2	1	2021-06-15 21:37:00	\N	\N	2021-09-16 20:37:21	2021-09-16 20:37:21	870b71cf-4167-4a75-8fdc-0cf4c59fbb9d
342	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-09-23 16:56:55	2021-09-23 16:56:55	49828cf2-8050-46e1-a950-0c8c7d06c93b
339	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-09-23 16:56:37	2021-09-23 16:56:37	96509076-2557-4914-a2a3-62e915117966
345	1	\N	1	1	2021-06-15 17:50:00	\N	\N	2021-09-23 16:57:13	2021-09-23 16:57:13	f5014ea9-9377-4f33-b133-65e0dc7077b8
348	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-09-23 16:57:44	2021-09-23 16:57:44	97b3edc6-541e-4f3a-97c9-bdf9eaf04697
351	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-09-23 16:58:01	2021-09-23 16:58:01	1011d693-4b66-4dd4-955b-2b4e1cab90e2
354	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-09-28 23:40:54	2021-09-28 23:40:54	6b8bfd4e-faac-4ac2-9b86-5fa85b32385e
357	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-09-28 23:43:33	2021-09-28 23:43:33	ccf0ca5c-7d11-4285-9782-5c09b2a5f052
360	1	\N	1	1	2021-06-15 17:50:00	\N	\N	2021-09-28 23:46:31	2021-09-28 23:46:31	c68a9b22-9b80-419d-b7a2-8bf429bb6614
363	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-09-28 23:49:47	2021-09-28 23:49:47	d999caf2-6e17-4418-bcbf-4224e6d24267
366	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-09-28 23:52:57	2021-09-28 23:52:57	62290f8e-8e0c-44b1-9a1b-7b02485293b4
367	7	\N	8	1	2021-09-29 00:03:00	\N	\N	2021-09-29 00:03:18	2021-09-29 00:03:18	3caac533-e917-4246-b582-f3d20bf4b17f
375	1	\N	1	1	2021-10-01 20:05:00	\N	\N	2021-10-01 20:06:06	2021-10-01 20:06:06	60089994-22e5-448c-9aba-1d5ab5e8e00b
374	1	\N	1	1	2021-10-01 20:05:00	\N	f	2021-10-01 20:05:41	2021-10-01 20:05:41	0741d837-4197-4719-b1f6-f89650023be9
378	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-10-01 20:33:23	2021-10-01 20:33:23	ac38e2aa-df59-41e4-9a01-20416f8b01a8
379	1	\N	1	1	2021-10-04 22:28:00	\N	\N	2021-10-04 22:28:15	2021-10-04 22:28:15	85ae0ec0-1aad-4968-8461-73cdf3bc7efa
383	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-10-08 22:40:17	2021-10-08 22:40:17	6a4fe02e-a8ce-4b16-96e4-8b0877125800
386	1	\N	1	1	2021-06-15 17:32:00	\N	\N	2021-10-08 22:40:48	2021-10-08 22:40:48	4e467df2-7562-46e4-8df3-779b735d4713
389	1	\N	1	1	2021-06-15 17:50:00	\N	\N	2021-10-08 22:42:36	2021-10-08 22:42:36	8bf02004-339f-4a85-a2a7-0945e3a6e304
392	1	\N	1	1	2021-06-15 17:53:00	\N	\N	2021-10-08 22:42:55	2021-10-08 22:42:55	705a4e54-6134-49bb-827b-0b3a0ec41bb6
396	1	\N	1	1	2021-06-15 17:56:00	\N	\N	2021-10-08 22:43:16	2021-10-08 22:43:16	60650ee9-95b4-48f2-afcc-c02135cc9a08
397	1	\N	1	1	2021-06-15 17:17:00	\N	\N	2021-10-08 22:43:20	2021-10-08 22:43:20	48769e91-a53f-4f4e-8502-84b94558b663
401	7	\N	8	1	2021-07-16 18:43:00	\N	\N	2021-10-08 23:04:53	2021-10-08 23:04:53	14d2a815-25b2-4665-b1a4-baaae04065e7
403	7	\N	8	1	2021-08-30 21:32:00	\N	\N	2021-10-08 23:05:09	2021-10-08 23:05:09	4d84f513-f385-462a-9d2f-bf7211a5548d
405	7	\N	8	1	2021-09-08 17:58:00	\N	\N	2021-10-08 23:05:41	2021-10-08 23:05:41	23c19a06-cd27-45fa-9e1e-1ca52104586c
407	7	\N	8	1	2021-09-08 18:26:00	\N	\N	2021-10-08 23:05:58	2021-10-08 23:05:58	474324b7-46b2-4ca2-b9cc-34af1c6c1956
412	3	\N	3	1	2021-06-21 22:59:00	\N	\N	2021-10-08 23:06:43	2021-10-08 23:06:43	87139542-a548-4c57-8d86-955378c0e065
420	3	\N	3	1	2021-07-16 18:41:00	\N	\N	2021-10-08 23:07:34	2021-10-08 23:07:34	fed72158-3f19-4b6f-87cd-8eef04c851b3
429	3	\N	3	1	2021-08-30 21:31:00	\N	\N	2021-10-08 23:08:17	2021-10-08 23:08:17	1e38cb4f-2c89-468d-8341-c5ad414aa6bb
437	3	\N	3	1	2021-09-08 18:23:00	\N	\N	2021-10-08 23:08:49	2021-10-08 23:08:49	950ec873-d227-4cf0-8ad4-352f99c7fceb
442	7	\N	8	1	2021-09-08 18:26:00	\N	\N	2021-10-22 19:54:06	2021-10-22 19:54:06	804f7520-1184-42f0-abf4-829a9b2afe9d
\.


--
-- TOC entry 4591 (class 0 OID 16588)
-- Dependencies: 229
-- Data for Name: entrytypes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.entrytypes (id, "sectionId", "fieldLayoutId", name, handle, "hasTitleField", "titleTranslationMethod", "titleTranslationKeyFormat", "titleFormat", "sortOrder", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	1	2	Catalog	catalog	t	site	\N	\N	1	2021-05-19 22:50:41	2021-05-19 22:50:41	\N	9d2a5fce-1549-4e9f-8205-f1527f5064b2
2	2	5	Survey	survey	t	site	\N	\N	1	2021-06-15 20:53:27	2021-06-15 21:42:43	\N	bae3d86b-064a-47c2-9af4-736639f79b7b
4	3	7	Intro	intro	t	site	\N	\N	2	2021-06-21 22:02:02	2021-06-21 22:02:02	2021-06-21 22:43:25	5ce09cb6-a7cd-43e6-9706-08ec3ade32e4
6	5	11	Tour Fact	tourFact	t	site	\N	\N	1	2021-06-21 22:47:44	2021-06-21 22:47:44	2021-06-22 21:50:11	7bdc8427-a1e4-4e91-bd2d-6df37ecc598b
5	4	10	Tour Intro	tourIntro	t	site	\N	\N	1	2021-06-21 22:43:52	2021-06-21 22:43:52	2021-06-22 21:50:11	16b35bd6-a6c2-4aa6-94f7-7fcb7521a858
3	3	6	Tour	tour	t	site	\N	\N	1	2021-06-21 21:46:12	2021-06-22 21:50:12	\N	52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9
8	7	16	Astro Object	astroObject	t	site	\N	\N	1	2021-07-16 17:47:52	2021-07-16 17:47:52	\N	16b1feef-a5aa-449f-b011-919a9d6075ed
7	6	12	Point of Interest	poi	t	site	\N	\N	1	2021-06-21 22:52:01	2021-07-20 00:12:42	2021-08-03 17:03:54	72ffe34e-f0b2-437e-beaa-d69b3fa947fb
9	8	18	Guided Experience (Tour Variety)	guidedExperience	f	site	\N	{varietyName}	2	2021-08-03 17:05:26	2021-08-03 17:05:26	2021-08-12 21:49:08	03f62b96-9104-4c4f-9754-0fc75a5421b8
\.


--
-- TOC entry 4593 (class 0 OID 16600)
-- Dependencies: 231
-- Data for Name: fieldgroups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fieldgroups (id, name, "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	Common	2021-05-19 21:09:33	2021-05-19 21:09:33	\N	7d09d2f0-5c11-4a45-a805-a6d39128319e
2	Catalog	2021-05-19 21:53:15	2021-05-19 21:53:15	\N	a3b0cf34-24af-41fe-8047-b1e5b65d5bd0
3	Globals	2021-06-15 15:02:03	2021-06-15 15:02:03	\N	4accd3e5-dd7d-4464-9f19-db2009adda71
4	Survey	2021-06-15 21:22:55	2021-06-15 21:22:55	\N	0ecf9feb-ab77-470b-a2de-eb396a3a4682
5	Tour	2021-06-21 22:02:26	2021-06-22 21:50:11	\N	8d6803f5-ca34-46d8-a8d5-869896e34b65
\.


--
-- TOC entry 4595 (class 0 OID 16607)
-- Dependencies: 233
-- Data for Name: fieldlayoutfields; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fieldlayoutfields (id, "layoutId", "tabId", "fieldId", required, "sortOrder", "dateCreated", "dateUpdated", uid) FROM stdin;
82	10	36	15	f	1	2021-06-21 22:45:42	2021-06-21 22:45:42	9929f016-1baf-4e17-a8d2-accb566d5415
83	10	36	16	f	2	2021-06-21 22:45:42	2021-06-21 22:45:42	5c74bc95-280f-40c3-a4b1-e4bc243bdfa1
84	10	36	17	f	3	2021-06-21 22:45:42	2021-06-21 22:45:42	0417f100-b23f-472b-a0cf-b8181ab7cd0e
85	11	38	15	f	1	2021-06-21 22:48:02	2021-06-21 22:48:02	55517244-9239-4e9e-989b-695a52934070
86	11	38	17	f	2	2021-06-21 22:48:02	2021-06-21 22:48:02	6db8678d-1f72-4295-8249-70ba405bdf21
278	6	118	30	f	1	2021-08-12 21:49:09	2021-08-12 21:49:09	999c1798-e8f4-45c1-8baa-8613fe7790b2
279	6	118	55	f	2	2021-08-12 21:49:09	2021-08-12 21:49:09	89639ad3-54b9-44df-a6e2-7fb9631107dd
280	6	118	19	f	3	2021-08-12 21:49:09	2021-08-12 21:49:09	22d0a166-fd16-4246-bd0a-fdd088615c91
281	6	118	20	f	4	2021-08-12 21:49:09	2021-08-12 21:49:09	03f2adbf-6e46-456c-9edc-035354c128f9
282	6	118	21	f	5	2021-08-12 21:49:09	2021-08-12 21:49:09	1e0bf023-cba4-4829-9c1f-8253c78163d7
283	6	118	22	f	6	2021-08-12 21:49:09	2021-08-12 21:49:09	84bac56e-a1fd-442d-aee1-928716793834
284	6	119	33	f	0	2021-08-12 21:49:09	2021-08-12 21:49:09	2542aef4-f7e2-4650-b913-db3f76cc2fea
285	6	119	34	f	1	2021-08-12 21:49:09	2021-08-12 21:49:09	453980d2-834c-4eff-8312-8e171dcdd270
286	6	119	17	f	2	2021-08-12 21:49:09	2021-08-12 21:49:09	fc0945ba-bd10-4c01-a511-c42f4f4f41d5
287	6	120	32	f	0	2021-08-12 21:49:09	2021-08-12 21:49:09	9397681b-2d31-48b9-8359-3c7b911c6e9e
288	6	120	31	f	1	2021-08-12 21:49:09	2021-08-12 21:49:09	f65dc693-9e18-4acc-8cdc-3669de39f305
289	6	121	35	f	0	2021-08-12 21:49:09	2021-08-12 21:49:09	43cbbbeb-fd92-4dd7-a285-4042f55acda6
292	20	125	53	f	1	2021-08-12 21:49:09	2021-08-12 21:49:09	4c345c86-4742-4859-a9da-b856e1f8e15d
293	20	125	21	f	2	2021-08-12 21:49:09	2021-08-12 21:49:09	39e20c4f-8b1d-4e44-82c3-e86103cb65dc
294	16	126	52	f	1	2021-08-19 20:34:03	2021-08-19 20:34:03	f5eb3e31-faa5-4429-a5f6-902a4592edd0
295	16	126	27	f	2	2021-08-19 20:34:03	2021-08-19 20:34:03	1f20934b-7c9e-4430-a676-b933b703d4c6
74	7	33	15	f	1	2021-06-21 22:36:47	2021-06-21 22:36:47	1011c2ff-5e7f-43a9-ad4f-8ca34d4c7b0b
75	7	33	16	f	2	2021-06-21 22:36:47	2021-06-21 22:36:47	0d9fc713-2056-4c77-988d-0bf8dccab102
76	7	33	17	f	3	2021-06-21 22:36:47	2021-06-21 22:36:47	718d18a5-2575-4d46-a2a6-adcc4066d7ca
296	16	126	28	f	3	2021-08-19 20:34:03	2021-08-19 20:34:03	c03061b9-7b20-4c06-a1bf-55ec080fae6c
297	16	126	56	f	4	2021-08-19 20:34:03	2021-08-19 20:34:03	6663abd6-587f-4faf-87e5-817523adf2f9
298	16	126	40	f	5	2021-08-19 20:34:03	2021-08-19 20:34:03	a114006b-274a-4dbf-b142-359fb5ec9695
306	3	133	5	f	0	2021-08-30 21:29:11	2021-08-30 21:29:11	37989a45-2df0-4b0c-b3b8-ccd42d04dcb2
307	3	133	3	f	1	2021-08-30 21:29:11	2021-08-30 21:29:11	8671f4ab-dc1b-4ae5-baae-8dbae4819c50
318	17	144	51	f	1	2021-10-08 22:29:25	2021-10-08 22:29:25	440077bc-1adb-4e11-bb73-82c15e6ad00f
320	4	146	51	f	1	2021-10-08 22:57:45	2021-10-08 22:57:45	b0f861ab-d782-4ef7-b445-d7fc995109ae
321	22	147	51	f	1	2021-10-11 14:41:22	2021-10-11 14:41:22	44b09694-5dcc-48f0-b6b2-ffbb393adc53
185	12	74	25	f	1	2021-07-20 00:12:40	2021-07-20 00:12:40	01bd245f-f0f1-47f3-af9d-22852b0740aa
186	12	74	12	f	2	2021-07-20 00:12:41	2021-07-20 00:12:41	b315cf01-f512-4637-9de6-3c72c19929ac
187	12	75	39	f	0	2021-07-20 00:12:41	2021-07-20 00:12:41	495a96ee-11b4-41bc-aefd-592c1b9e6d0c
238	1	102	6	f	1	2021-08-06 22:10:25	2021-08-06 22:10:25	76a335bf-0c82-4e2b-9585-18409a53323c
239	1	102	1	f	2	2021-08-06 22:10:25	2021-08-06 22:10:25	7f1469fc-439f-4489-a688-03e3a7ce8bdb
240	1	102	8	f	4	2021-08-06 22:10:25	2021-08-06 22:10:25	67e69e18-6a0e-46c9-9d2f-972e9a29d524
241	1	102	7	f	5	2021-08-06 22:10:25	2021-08-06 22:10:25	fba58e8a-cba4-47e1-a02a-f0e226f46ada
242	5	103	1	t	1	2021-08-06 22:10:26	2021-08-06 22:10:26	22e3d9b2-48cb-486a-bdd9-64c62961549b
243	5	103	11	f	2	2021-08-06 22:10:26	2021-08-06 22:10:26	c9bb8acf-5af4-4c2d-90a3-c33c076fa7ee
244	5	103	13	f	3	2021-08-06 22:10:26	2021-08-06 22:10:26	1a0fe4bd-7774-48c7-ac62-55b6cc579c3d
245	5	103	14	f	4	2021-08-06 22:10:26	2021-08-06 22:10:26	53c78c72-5d85-4326-a6c1-b02acf0269a9
246	5	103	12	f	5	2021-08-06 22:10:26	2021-08-06 22:10:26	5d2aa521-a421-496a-a914-0443dbf78af0
247	2	104	1	f	1	2021-08-06 22:10:26	2021-08-06 22:10:26	7e8d3b08-5d7c-4776-b547-017356107c66
248	2	104	8	f	2	2021-08-06 22:10:26	2021-08-06 22:10:26	9ab5bf2a-50f1-4311-91a3-d2cebecfcd3c
256	15	107	43	f	0	2021-08-06 22:10:26	2021-08-06 22:10:26	b742e2b0-120b-416c-a0ce-1bda9ec8f96b
257	8	108	18	t	0	2021-08-06 22:10:26	2021-08-06 22:10:26	8cf60ed3-bfed-41d0-a620-958788e4aed9
258	14	109	38	f	0	2021-08-06 22:10:26	2021-08-06 22:10:26	f6013152-bb57-498f-a5bf-efa5a0173c8e
259	13	110	37	f	0	2021-08-06 22:10:27	2021-08-06 22:10:27	6043cf2a-e1ce-45b3-92b6-be22c803a830
260	13	110	50	f	1	2021-08-06 22:10:27	2021-08-06 22:10:27	85c5a4f5-9008-480a-b5ff-bfd659b85030
261	13	110	49	f	2	2021-08-06 22:10:27	2021-08-06 22:10:27	d0cc1199-d1ed-4c83-a78c-f8392ad7f2f2
273	18	115	54	f	1	2021-08-06 22:10:27	2021-08-06 22:10:27	c85e61c4-18eb-4600-9dd9-ef8bcd178d9a
274	18	115	53	f	2	2021-08-06 22:10:27	2021-08-06 22:10:27	4aa8cc2c-edf9-4182-8494-00ee747e67ea
275	18	115	21	f	3	2021-08-06 22:10:27	2021-08-06 22:10:27	77fe4bba-1eaf-4135-b66d-df5f4a0aa66d
\.


--
-- TOC entry 4597 (class 0 OID 16614)
-- Dependencies: 235
-- Data for Name: fieldlayouts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fieldlayouts (id, type, "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
2	craft\\elements\\Entry	2021-05-19 22:50:41	2021-05-19 22:50:41	\N	ab781cc4-81d9-4138-958a-fd7a2609cbda
3	craft\\elements\\GlobalSet	2021-06-15 15:02:03	2021-06-15 15:02:03	\N	3aff80ee-9ac7-4a11-8a1b-ed7f358711b6
4	craft\\elements\\Asset	2021-06-15 17:03:52	2021-06-15 17:03:52	\N	9ad699b5-16f7-4d7f-a22c-2e886dd7970b
5	craft\\elements\\Entry	2021-06-15 20:53:27	2021-06-15 20:53:27	\N	a590a1dc-4372-4d00-9cf8-267c5e5e93f1
6	craft\\elements\\Entry	2021-06-21 21:46:12	2021-06-21 21:46:12	\N	05e3e818-d66c-4f2d-99ef-52fe1ee8904e
8	craft\\elements\\MatrixBlock	2021-06-21 22:20:10	2021-06-21 22:20:10	\N	0fc0ae09-e999-401a-94f3-c849d44a6fc0
7	craft\\elements\\Entry	2021-06-21 22:02:02	2021-06-21 22:02:02	2021-06-21 22:43:25	b64b5f91-b1ef-4704-a8c9-1970f90bedaa
11	craft\\elements\\Entry	2021-06-21 22:47:44	2021-06-21 22:47:44	2021-06-22 21:50:11	fe37315b-e5c5-469f-b9d9-a5c1134879aa
10	craft\\elements\\Entry	2021-06-21 22:43:52	2021-06-21 22:43:52	2021-06-22 21:50:11	5dda0058-4d03-41bf-95da-f1b330e8b691
13	craft\\elements\\MatrixBlock	2021-06-22 21:50:13	2021-06-22 21:50:13	\N	1b720c1b-b66f-4f5c-bd7d-a64b1bd32367
14	craft\\elements\\MatrixBlock	2021-06-22 21:50:13	2021-06-22 21:50:13	\N	01e3de18-5422-4982-8793-e0a34948e1d5
15	craft\\elements\\MatrixBlock	2021-07-16 17:47:52	2021-07-16 17:47:52	\N	ca79027c-e444-43f4-ac18-1a49f21083c6
16	craft\\elements\\Entry	2021-07-16 17:47:52	2021-07-16 17:47:52	\N	1172933d-d14c-443e-a972-e0e3dae6d4f7
12	craft\\elements\\Entry	2021-06-21 22:52:01	2021-07-20 00:12:39	2021-08-03 17:03:53	a9a4a2f3-3bfb-49fb-9a49-646f6c67f300
9	craft\\elements\\Asset	2021-06-21 22:32:34	2021-06-21 22:32:34	2021-08-03 17:04:00	fe7947c6-7f24-4183-a283-092cc29be2d3
17	craft\\elements\\Asset	2021-08-03 17:04:59	2021-08-03 17:04:59	\N	3bbfc7cd-6a6b-4534-bd52-9b7566850e2a
1	craft\\elements\\Category	2021-05-19 21:15:41	2021-05-19 21:15:41	2021-08-12 21:49:08	88f13df1-be43-4126-b9ff-75c00eccfde6
18	craft\\elements\\Entry	2021-08-03 17:05:24	2021-08-03 17:05:24	2021-08-12 21:49:08	89a174f2-4090-484d-bb45-2ad094211820
20	craft\\elements\\Category	2021-08-12 21:49:09	2021-08-12 21:49:09	\N	1bd45809-7be7-4083-bdbc-bceb5876fdc8
21	craft\\elements\\Category	2021-08-12 21:49:09	2021-08-12 21:49:09	\N	80e1cd37-ef90-4e3b-817f-776176d2d5b2
22	craft\\elements\\Asset	2021-08-19 20:34:03	2021-08-19 20:34:03	\N	f69d7e12-9845-48c1-8dd1-59b7d13fef81
19	craft\\elements\\Asset	2021-08-03 21:16:41	2021-08-19 20:34:03	2021-08-30 21:29:11	76a8f584-d4ee-40b1-ac3e-e5f63aaf4b7f
\.


--
-- TOC entry 4599 (class 0 OID 16621)
-- Dependencies: 237
-- Data for Name: fieldlayouttabs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fieldlayouttabs (id, "layoutId", name, elements, "sortOrder", "dateCreated", "dateUpdated", uid) FROM stdin;
133	3	Metadata	[{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"45720ab9-15e3-4cdc-8103-9c0495d2c1d2"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"d2cd37c9-0e8a-4bbb-aff0-13584d58279b"}]	1	2021-08-30 21:29:11	2021-08-30 21:29:11	ae9ff631-191f-469f-8d72-6b2d8927e1b1
31	9	Content	[{"type":"craft\\\\fieldlayoutelements\\\\AssetTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100}]	1	2021-06-21 22:32:34	2021-06-21 22:32:34	ea0c6f08-5c44-4960-a372-17c3adb210ab
33	7	Content	[{"type":"craft\\\\fieldlayoutelements\\\\EntryTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"99900237-7b20-49d9-ae09-b70c06489be7"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"6ae58874-f4e1-4216-82c0-7af4094fdc0c"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"008cb5a3-a777-476f-8410-4f2bf13ac492"}]	1	2021-06-21 22:36:47	2021-06-21 22:36:47	63c0c367-e954-4b82-bf72-0dd75260b805
36	10	Content	[{"type":"craft\\\\fieldlayoutelements\\\\EntryTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"99900237-7b20-49d9-ae09-b70c06489be7"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"6ae58874-f4e1-4216-82c0-7af4094fdc0c"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"008cb5a3-a777-476f-8410-4f2bf13ac492"}]	1	2021-06-21 22:45:42	2021-06-21 22:45:42	145611eb-d669-4da8-9a4a-9be28db85dc7
38	11	Content	[{"type":"craft\\\\fieldlayoutelements\\\\EntryTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"99900237-7b20-49d9-ae09-b70c06489be7"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"008cb5a3-a777-476f-8410-4f2bf13ac492"}]	1	2021-06-21 22:48:02	2021-06-21 22:48:02	3b266993-a45d-437d-a16d-b629edbde156
74	12	Content	[{"type":"craft\\\\fieldlayoutelements\\\\EntryTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"5244042f-c1bd-4262-8aa8-4cb92e5f2ea4"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"a0521bda-0df4-4937-9d6e-1534dfb98b58"}]	1	2021-07-20 00:12:40	2021-07-20 00:12:40	2c32ee77-17bd-4e0e-a0c6-7cd6ee14f76f
75	12	Astro Object	[{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"e4521605-ff3a-4876-8c3c-cde0ffe5deaa"}]	2	2021-07-20 00:12:41	2021-07-20 00:12:41	e618efe8-8bf6-40cf-94da-b7546318ea4a
104	2	Content	[{"type":"craft\\\\fieldlayoutelements\\\\EntryTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"7e00543c-2735-49a3-96f0-d39d5d7333fe"}]	1	2021-08-06 22:10:26	2021-08-06 22:10:26	b2497e19-6d98-44b5-96a1-81dd98f4ec90
107	15	Content	[{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"84e9fa1d-8aed-40e1-a0e9-cb13152ea782"}]	1	2021-08-06 22:10:26	2021-08-06 22:10:26	aaf1fa69-f486-4dfe-9947-00bfe7d0950c
108	8	Content	[{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":true,"width":100,"fieldUid":"6f7c799f-429a-486c-bde4-a5bd5ece3a78"}]	1	2021-08-06 22:10:26	2021-08-06 22:10:26	f3244c7f-5f2c-4a7a-9087-30c57f54720b
109	14	Content	[{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"ccd123b4-00ff-4cdb-87e0-20be70c5f8f3"}]	1	2021-08-06 22:10:26	2021-08-06 22:10:26	15d6b7b7-7993-4911-a2f6-3d1811199a35
110	13	Content	[{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"fe1835fb-8bd0-4e5a-b637-0e94330568ac"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"d6f8219d-2a83-4ee6-967e-10720dec037b"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"4a676166-cd4f-4c4e-a7ee-afca5c68fc2d"}]	1	2021-08-06 22:10:27	2021-08-06 22:10:27	6828f618-b241-4551-bd37-d270c5262240
144	17	Content	[{"type":"craft\\\\fieldlayoutelements\\\\AssetTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"5ef8f422-6773-4891-99b9-f56cdb8bced4"}]	1	2021-10-08 22:29:25	2021-10-08 22:29:25	cbc6d879-bfa7-4f72-995b-5b5cbc188a32
102	1	Content	[{"type":"craft\\\\fieldlayoutelements\\\\TitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"d7e99ce5-1dc7-4bac-94c6-91f86a5882e0"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"7e00543c-2735-49a3-96f0-d39d5d7333fe"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"82510efa-cd7e-4f64-bfaa-1da05df2f53a"}]	1	2021-08-06 22:10:25	2021-08-06 22:10:25	4a92d0ac-02ed-474e-b8f8-44b3f5d172b6
103	5	Content	[{"type":"craft\\\\fieldlayoutelements\\\\EntryTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":"","instructions":"","tip":null,"warning":null,"required":"1","width":100,"fieldUid":"fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"b3f50442-f90e-42e6-986e-b2426abedaca"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"0732995e-10da-4be7-944b-51b1135d12eb"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"455216e8-f949-4521-911f-d50895102cd4"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"a0521bda-0df4-4937-9d6e-1534dfb98b58"}]	1	2021-08-06 22:10:26	2021-08-06 22:10:26	2f5923d5-5008-4e5d-aa23-cb1b9aa6a8a2
146	4	Content	[{"type":"craft\\\\fieldlayoutelements\\\\AssetTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"5ef8f422-6773-4891-99b9-f56cdb8bced4"}]	1	2021-10-08 22:57:45	2021-10-08 22:57:45	f1c1230b-67af-4b0e-b095-486faab585e4
115	18	Content	[{"type":"craft\\\\fieldlayoutelements\\\\EntryTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"5fefc9c3-999f-4d02-988d-5a1738812936"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"36cb7208-d072-48ac-af5e-c034035afdfd"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"7f01b564-7d49-4139-be9d-07d369fd3408"}]	1	2021-08-06 22:10:27	2021-08-06 22:10:27	2701f924-93d0-4033-af30-a6e0251c8f22
118	6	Content	[{"type":"craft\\\\fieldlayoutelements\\\\EntryTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"2c43566d-87e9-47af-b1e3-87577b58f06f"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"4b8d140e-8cb8-489e-9a89-0c30c4717e30"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"93cdcbba-f59d-41f1-ac65-5d9b0f83ef62"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"d4c658d8-0938-43f0-9ce0-0515d09ca162"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"7f01b564-7d49-4139-be9d-07d369fd3408"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"3c645133-6daf-4632-a842-13662885ad1b"}]	1	2021-08-12 21:49:09	2021-08-12 21:49:09	e0168e7f-82aa-4227-b226-22405ba2919a
119	6	Intro	[{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"a715351e-d465-4446-81f8-c9a15b3d1298"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"31806af1-7467-49ea-9638-01ecf1c546cd"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"008cb5a3-a777-476f-8410-4f2bf13ac492"}]	2	2021-08-12 21:49:09	2021-08-12 21:49:09	f93a5cf6-e549-41f8-95e6-d47eaf0bcafd
120	6	Facts	[{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"18a685a4-2ce7-4ae8-b717-0154cff390c1"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"04fc1a9d-6240-4e69-ad81-2e02190a7e8d"}]	3	2021-08-12 21:49:09	2021-08-12 21:49:09	3989b00f-e28d-466c-889e-a981c63bcb92
121	6	POI	[{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"8fd439fe-660f-4cac-8ddf-b71b8ad6276f"}]	4	2021-08-12 21:49:09	2021-08-12 21:49:09	488ef686-08aa-44ca-b6d6-41ad808685b1
125	20	Content	[{"type":"craft\\\\fieldlayoutelements\\\\TitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"36cb7208-d072-48ac-af5e-c034035afdfd"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"7f01b564-7d49-4139-be9d-07d369fd3408"}]	1	2021-08-12 21:49:09	2021-08-12 21:49:09	34d67981-f623-4603-8306-fa68a142c4e4
126	16	Content	[{"type":"craft\\\\fieldlayoutelements\\\\EntryTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":"","instructions":"","tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"25d2c2a6-169a-461c-b67d-54294c7d22d7"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"8a653768-6c25-44d4-815e-182cd324b043"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"c8a76131-a217-46f6-9b2a-88d4f2a2f7de"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"fe74f2bf-6416-4c77-a05d-1ef924e575a8"},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"e76c2c25-ca53-4f4c-bd93-a5af52ebb72c"}]	1	2021-08-19 20:34:03	2021-08-19 20:34:03	2aa9a330-4ff7-4bba-bd76-a86c92901fd4
147	22	Content	[{"type":"craft\\\\fieldlayoutelements\\\\AssetTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100},{"type":"craft\\\\fieldlayoutelements\\\\CustomField","label":null,"instructions":null,"tip":null,"warning":null,"required":false,"width":100,"fieldUid":"5ef8f422-6773-4891-99b9-f56cdb8bced4"}]	1	2021-10-11 14:41:22	2021-10-11 14:41:22	15c589f8-e1a3-441c-8960-8d2162279653
129	19	Content	[{"type":"craft\\\\fieldlayoutelements\\\\AssetTitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100}]	1	2021-08-19 20:34:03	2021-08-19 20:34:03	43bd78ff-b645-40dc-86af-39d019ba892a
131	21	Content	[{"type":"craft\\\\fieldlayoutelements\\\\TitleField","autocomplete":false,"class":null,"size":null,"name":null,"autocorrect":true,"autocapitalize":true,"disabled":false,"readonly":false,"title":null,"placeholder":null,"step":null,"min":null,"max":null,"requirable":false,"id":null,"containerAttributes":[],"inputContainerAttributes":[],"labelAttributes":[],"orientation":null,"label":null,"instructions":null,"tip":null,"warning":null,"width":100}]	1	2021-08-24 22:43:21	2021-08-24 22:43:21	b84846c7-c9c2-4633-874e-abb02773150d
\.


--
-- TOC entry 4601 (class 0 OID 16630)
-- Dependencies: 239
-- Data for Name: fields; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fields (id, "groupId", name, handle, context, instructions, searchable, "translationMethod", "translationKeyFormat", type, settings, "dateCreated", "dateUpdated", uid, "columnSuffix") FROM stdin;
3	3	Site Description	siteDescription	global		f	site	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-06-15 15:02:03	2021-06-15 15:02:03	d2cd37c9-0e8a-4bbb-aff0-13584d58279b	\N
4	3	Site Image	siteImage	global		f	site	\N	craft\\fields\\Assets	{"allowSelfRelations":false,"allowUploads":true,"allowedKinds":null,"defaultUploadLocationSource":"","defaultUploadLocationSubpath":"","limit":"1","localizeRelations":false,"previewMode":"full","restrictFiles":"","selectionLabel":"","showSiteMenu":false,"showUnpermittedFiles":false,"showUnpermittedVolumes":false,"singleUploadLocationSource":"","singleUploadLocationSubpath":"","source":null,"sources":"*","targetSiteId":null,"useSingleFolder":false,"validateRelatedElements":false,"viewMode":"large"}	2021-06-15 15:02:03	2021-06-15 15:02:03	6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5	\N
5	3	Site Title	siteTitle	global		f	site	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-06-15 15:02:03	2021-06-15 15:02:03	45720ab9-15e3-4cdc-8103-9c0495d2c1d2	\N
7	2	Source Size	sourceSize	global	Size of the marker icons	f	none	\N	craft\\fields\\Number	{"decimals":0,"defaultValue":"20","max":null,"min":"0","prefix":null,"previewCurrency":"","previewFormat":"none","size":null,"suffix":null}	2021-06-15 16:57:30	2021-06-15 20:43:49	82510efa-cd7e-4f64-bfaa-1da05df2f53a	\N
11	4	Target	target	global	The RA and DEC that the Skyviewer Explorer will focus on during page load, type RA first followed by a space and then DEC: <RA> <DEC>	f	none	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":"Ex: 267.0208333333 -24.7800000000","uiMode":"normal"}	2021-06-15 21:32:02	2021-06-15 21:32:02	b3f50442-f90e-42e6-986e-b2426abedaca	\N
14	4	Field of Vision (FOV) Maximum Value	fovMax	global	An integer greater than 0 and also greater than the FOV min	f	none	\N	craft\\fields\\Number	{"decimals":0,"defaultValue":null,"max":null,"min":"0","prefix":null,"previewCurrency":"","previewFormat":"decimal","size":null,"suffix":null}	2021-06-15 21:34:59	2021-06-15 21:34:59	455216e8-f949-4521-911f-d50895102cd4	\N
13	4	Field of Vision (FOV) Minimum Value	fovMin	global	An integer greater than 0 and less than the FOV max value.	f	none	\N	craft\\fields\\Number	{"decimals":0,"defaultValue":null,"max":null,"min":"0","prefix":null,"previewCurrency":"","previewFormat":"decimal","size":null,"suffix":null}	2021-06-15 21:34:19	2021-06-21 21:43:06	0732995e-10da-4be7-944b-51b1135d12eb	\N
19	5	Duration	duration	global	In minutes	f	none	\N	craft\\fields\\Number	{"decimals":0,"defaultValue":"5","max":null,"min":"0","prefix":null,"previewCurrency":"","previewFormat":"decimal","size":null,"suffix":null}	2021-06-21 22:30:06	2021-06-21 22:30:06	93cdcbba-f59d-41f1-ac65-5d9b0f83ef62	\N
15	1	Heading	heading	global		f	none	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-06-21 22:03:44	2021-06-21 22:44:28	99900237-7b20-49d9-ae09-b70c06489be7	\N
16	1	Subheading	subheading	global		f	none	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-06-21 22:04:19	2021-06-21 22:44:42	6ae58874-f4e1-4216-82c0-7af4094fdc0c	\N
12	1	Field of Vision (FOV) Initial Value	fov	global	An integer indicating the initial Zoom level	f	none	\N	craft\\fields\\Number	{"decimals":0,"defaultValue":null,"max":null,"min":"0","prefix":null,"previewCurrency":"","previewFormat":"decimal","size":null,"suffix":null}	2021-06-15 21:33:04	2021-06-21 22:56:02	a0521bda-0df4-4937-9d6e-1534dfb98b58	\N
20	5	Complexity	complexity	global	Between 1 - 5 where 1 - 2 is "Easy", 3 - 4 is "Medium", and 5 is "Hard"	f	none	\N	craft\\fields\\Number	{"decimals":0,"defaultValue":null,"max":"5","min":"1","prefix":null,"previewCurrency":"","previewFormat":"decimal","size":null,"suffix":null}	2021-06-21 22:30:26	2021-06-22 21:50:11	d4c658d8-0938-43f0-9ce0-0515d09ca162	\N
17	5	Intro Content Blocks	introContentBlocks	global		t	site	\N	craft\\fields\\Matrix	{"contentTable":"{{%matrixcontent_introcontentblocks}}","maxBlocks":"","minBlocks":"","propagationMethod":"all"}	2021-06-21 22:20:10	2021-07-16 17:47:51	008cb5a3-a777-476f-8410-4f2bf13ac492	\N
18	\N	Body	body	matrixBlockType:48d995fe-6d24-48f6-904a-c54f64964387		t	site	\N	craft\\redactor\\Field	{"availableTransforms":"*","availableVolumes":"","cleanupHtml":true,"columnType":"text","configSelectionMode":"choose","defaultTransform":"","manualConfig":"","purifierConfig":"","purifyHtml":"1","redactorConfig":"","removeEmptyTags":"1","removeInlineStyles":"1","removeNbsp":"1","showHtmlButtonForNonAdmins":"","showUnpermittedFiles":false,"showUnpermittedVolumes":false,"uiMode":"enlarged"}	2021-06-21 22:20:10	2021-07-16 17:47:51	6f7c799f-429a-486c-bde4-a5bd5ece3a78	\N
25	5	Description	description	global		t	none	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"1","placeholder":null,"uiMode":"normal"}	2021-06-21 22:52:58	2021-07-16 17:47:51	5244042f-c1bd-4262-8aa8-4cb92e5f2ea4	\N
28	5	Dec	dec	global	Declination	f	none	\N	craft\\fields\\Number	{"decimals":0,"defaultValue":null,"max":null,"min":"0","prefix":null,"previewCurrency":"","previewFormat":"decimal","size":null,"suffix":null}	2021-06-21 22:55:42	2021-06-22 21:50:11	c8a76131-a217-46f6-9b2a-88d4f2a2f7de	\N
33	5	Intro Heading	introHeading	global		t	site	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-06-22 21:50:12	2021-07-16 17:47:51	a715351e-d465-4446-81f8-c9a15b3d1298	\N
27	5	Ra	ra	global	Right Acension	f	none	\N	craft\\fields\\Number	{"decimals":0,"defaultValue":null,"max":null,"min":"0","prefix":null,"previewCurrency":"","previewFormat":"decimal","size":null,"suffix":null}	2021-06-21 22:54:36	2021-06-22 21:50:12	8a653768-6c25-44d4-815e-182cd324b043	\N
1	1	Path	path	global		t	none	\N	craft\\fields\\Url	{"maxLength":"255","placeholder":null,"types":["url"]}	2021-05-19 21:54:16	2021-08-03 17:04:40	fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377	\N
35	5	Tour POIs	tourPois	global		t	site	\N	craft\\fields\\Matrix	{"contentTable":"{{%matrixcontent_tourpois}}","maxBlocks":"","minBlocks":"","propagationMethod":"all"}	2021-06-22 21:50:12	2021-07-16 17:47:51	8fd439fe-660f-4cac-8ddf-b71b8ad6276f	\N
39	5	Astro Objects	astroObjects	global		t	site	\N	craft\\fields\\Entries	{"allowSelfRelations":false,"limit":"","localizeRelations":false,"selectionLabel":"","showSiteMenu":false,"source":null,"sources":["section:e2eb2e80-8e02-4a68-aa81-3d488f80543d"],"targetSiteId":null,"validateRelatedElements":false,"viewMode":null}	2021-07-16 17:47:51	2021-07-16 17:47:51	e4521605-ff3a-4876-8c3c-cde0ffe5deaa	\N
31	5	Fun Facts Content Blocks	factsContentBlocks	global		t	site	\N	craft\\fields\\Matrix	{"contentTable":"{{%matrixcontent_factscontentblocks}}","maxBlocks":"","minBlocks":"","propagationMethod":"all"}	2021-06-22 21:50:11	2021-07-16 17:47:51	04fc1a9d-6240-4e69-ad81-2e02190a7e8d	\N
32	5	Fun Facts Heading	factsHeading	global		t	site	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":"Fun Facts","uiMode":"normal"}	2021-06-22 21:50:12	2021-07-16 17:47:51	18a685a4-2ce7-4ae8-b717-0154cff390c1	\N
34	5	Intro Subheading	introSubheading	global		t	site	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-06-22 21:50:12	2021-07-16 17:47:51	31806af1-7467-49ea-9638-01ecf1c546cd	\N
29	5	Points of Interest	pois	global		t	site	\N	craft\\fields\\Entries	{"allowSelfRelations":false,"limit":"","localizeRelations":false,"selectionLabel":"","showSiteMenu":false,"source":null,"sources":["section:4a76eb6e-e209-42df-8ef6-43f1e5f7f745"],"targetSiteId":null,"validateRelatedElements":false,"viewMode":null}	2021-06-21 22:57:45	2021-07-16 17:47:51	62b4e157-411a-433c-bdc0-dcd42a2d7ca4	\N
37	\N	Description	description	matrixBlockType:a8b34826-6a25-4e0a-b5dc-7e9820257899		t	site	\N	craft\\redactor\\Field	{"availableTransforms":"*","availableVolumes":"","cleanupHtml":true,"columnType":"text","configSelectionMode":"choose","defaultTransform":"","manualConfig":"","purifierConfig":"","purifyHtml":"1","redactorConfig":"","removeEmptyTags":"1","removeInlineStyles":"1","removeNbsp":"1","showHtmlButtonForNonAdmins":"","showUnpermittedFiles":false,"showUnpermittedVolumes":false,"uiMode":"enlarged"}	2021-06-22 21:50:13	2021-07-16 17:47:51	fe1835fb-8bd0-4e5a-b637-0e94330568ac	\N
38	\N	Body	body	matrixBlockType:8944198c-ff53-4323-ad48-976efeb3f56e		t	site	\N	craft\\redactor\\Field	{"availableTransforms":"*","availableVolumes":"","cleanupHtml":true,"columnType":"text","configSelectionMode":"choose","defaultTransform":"","manualConfig":"","purifierConfig":"","purifyHtml":"1","redactorConfig":"","removeEmptyTags":"1","removeInlineStyles":"1","removeNbsp":"1","showHtmlButtonForNonAdmins":"","showUnpermittedFiles":false,"showUnpermittedVolumes":false,"uiMode":"enlarged"}	2021-06-22 21:50:13	2021-07-16 17:47:51	ccd123b4-00ff-4cdb-87e0-20be70c5f8f3	\N
41	5	POI Astro Object	poiAstroObject	global		t	site	\N	craft\\fields\\Matrix	{"contentTable":"{{%matrixcontent_poiastroobject}}","maxBlocks":"","minBlocks":"","propagationMethod":"all"}	2021-07-16 17:47:51	2021-07-16 17:47:51	b67e6d47-49f6-4385-85c7-ada70ffcf67e	\N
43	\N	Astro Object	astroObject	matrixBlockType:82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c		t	site	\N	craft\\fields\\Entries	{"allowSelfRelations":false,"limit":"1","localizeRelations":false,"selectionLabel":"","showSiteMenu":false,"source":null,"sources":["section:e2eb2e80-8e02-4a68-aa81-3d488f80543d"],"targetSiteId":null,"validateRelatedElements":false,"viewMode":null}	2021-07-16 17:47:52	2021-07-16 17:47:52	84e9fa1d-8aed-40e1-a0e9-cb13152ea782	\N
26	5	Image	image	global		t	site	\N	craft\\fields\\Assets	{"allowSelfRelations":false,"allowUploads":true,"allowedKinds":null,"defaultUploadLocationSource":"volume:77fd2a32-cdf7-4a77-8648-d79616eed462","defaultUploadLocationSubpath":"/web/assets/astro-tours","limit":"1","localizeRelations":false,"previewMode":"full","restrictFiles":"","selectionLabel":"","showSiteMenu":false,"showUnpermittedFiles":false,"showUnpermittedVolumes":false,"singleUploadLocationSource":"volume:85d34514-ec13-4850-a272-a3ab1bc790ef","singleUploadLocationSubpath":"","source":null,"sources":"*","targetSiteId":null,"useSingleFolder":false,"validateRelatedElements":false,"viewMode":"large"}	2021-06-21 22:53:59	2021-08-19 20:34:03	cd879179-0c4d-47a3-90e9-61fdb3516cc4	\N
22	5	Background Image	backgroundImage	global		t	site	\N	craft\\fields\\Assets	{"allowSelfRelations":false,"allowUploads":true,"allowedKinds":null,"defaultUploadLocationSource":"volume:a469a047-d19a-421e-97f8-c58f1bda27d7","defaultUploadLocationSubpath":"","limit":"1","localizeRelations":false,"previewMode":"thumbs","restrictFiles":"","selectionLabel":"","showSiteMenu":false,"showUnpermittedFiles":false,"showUnpermittedVolumes":false,"singleUploadLocationSource":"volume:85d34514-ec13-4850-a272-a3ab1bc790ef","singleUploadLocationSubpath":"","source":null,"sources":"*","targetSiteId":null,"useSingleFolder":false,"validateRelatedElements":false,"viewMode":"large"}	2021-06-21 22:35:03	2021-08-03 17:04:30	3c645133-6daf-4632-a842-13662885ad1b	\N
21	5	Thumbnail Image	thumbnail	global		t	site	\N	craft\\fields\\Assets	{"allowSelfRelations":false,"allowUploads":true,"allowedKinds":null,"defaultUploadLocationSource":"volume:a469a047-d19a-421e-97f8-c58f1bda27d7","defaultUploadLocationSubpath":"","limit":"","localizeRelations":false,"previewMode":"full","restrictFiles":"","selectionLabel":"","showSiteMenu":false,"showUnpermittedFiles":false,"showUnpermittedVolumes":false,"singleUploadLocationSource":"volume:85d34514-ec13-4850-a272-a3ab1bc790ef","singleUploadLocationSubpath":"","source":null,"sources":"*","targetSiteId":null,"useSingleFolder":false,"validateRelatedElements":false,"viewMode":"list"}	2021-06-21 22:34:30	2021-08-03 17:04:33	7f01b564-7d49-4139-be9d-07d369fd3408	\N
30	5	Variety	tourVariety	global		t	site	\N	craft\\fields\\Categories	{"allowLimit":false,"allowMultipleSources":false,"allowSelfRelations":false,"branchLimit":"1","limit":null,"localizeRelations":false,"selectionLabel":"","showSiteMenu":false,"source":"group:aa3e2ce5-e67a-4378-8a44-c660690cbcc3","sources":"*","targetSiteId":null,"validateRelatedElements":false,"viewMode":null}	2021-06-21 23:01:03	2021-08-12 21:49:09	2c43566d-87e9-47af-b1e3-87577b58f06f	\N
49	\N	astroObject	astroObject	matrixBlockType:a8b34826-6a25-4e0a-b5dc-7e9820257899		f	site	\N	craft\\fields\\Entries	{"allowSelfRelations":false,"limit":"1","localizeRelations":false,"selectionLabel":"","showSiteMenu":false,"source":null,"sources":["section:e2eb2e80-8e02-4a68-aa81-3d488f80543d"],"targetSiteId":null,"validateRelatedElements":false,"viewMode":null}	2021-08-03 17:04:12	2021-08-03 17:04:12	4a676166-cd4f-4c4e-a7ee-afca5c68fc2d	\N
50	\N	FOV	fov	matrixBlockType:a8b34826-6a25-4e0a-b5dc-7e9820257899		f	none	\N	craft\\fields\\Number	{"decimals":0,"defaultValue":"20","max":null,"min":"0","prefix":null,"previewCurrency":"","previewFormat":"decimal","size":null,"suffix":null}	2021-08-03 17:04:14	2021-08-03 17:04:14	d6f8219d-2a83-4ee6-967e-10720dec037b	\N
40	5	Characteristics	characteristics	global		t	none	\N	craft\\redactor\\Field	{"availableTransforms":"*","availableVolumes":"*","cleanupHtml":true,"columnType":"text","configSelectionMode":"choose","defaultTransform":"","manualConfig":"","purifierConfig":"","purifyHtml":"1","redactorConfig":"","removeEmptyTags":"1","removeInlineStyles":"1","removeNbsp":"1","showHtmlButtonForNonAdmins":"","showUnpermittedFiles":false,"showUnpermittedVolumes":false,"uiMode":"enlarged"}	2021-07-16 17:47:51	2021-08-03 17:04:25	e76c2c25-ca53-4f4c-bd93-a5af52ebb72c	\N
8	2	Icon	icon	global	Icon for the marker on the UI	f	site	\N	craft\\fields\\Assets	{"allowSelfRelations":false,"allowUploads":true,"allowedKinds":null,"defaultUploadLocationSource":"volume:85d34514-ec13-4850-a272-a3ab1bc790ef","defaultUploadLocationSubpath":"","limit":"1","localizeRelations":false,"previewMode":"thumbs","restrictFiles":"","selectionLabel":"","showSiteMenu":false,"showUnpermittedFiles":false,"showUnpermittedVolumes":false,"singleUploadLocationSource":"volume:85d34514-ec13-4850-a272-a3ab1bc790ef","singleUploadLocationSubpath":"","source":null,"sources":"*","targetSiteId":null,"useSingleFolder":false,"validateRelatedElements":false,"viewMode":"large"}	2021-06-15 16:58:22	2021-08-03 17:04:31	7e00543c-2735-49a3-96f0-d39d5d7333fe	\N
6	2	Variety	catalogVariety	global		t	none	\N	craft\\fields\\Dropdown	{"optgroups":true,"options":[{"label":"Stars","value":"star","default":""},{"label":"Galaxies","value":"galaxy","default":""},{"label":"Nebulas","value":"nebula","default":""},{"label":"Transients","value":"transient","default":""},{"label":"Goals","value":"goal","default":""},{"label":"Landmarks","value":"landmark","default":""}]}	2021-06-15 16:56:15	2021-08-03 17:04:43	d7e99ce5-1dc7-4bac-94c6-91f86a5882e0	\N
51	1	Alternate Text	altText	global		f	site	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-08-03 17:04:46	2021-08-03 17:04:46	5ef8f422-6773-4891-99b9-f56cdb8bced4	\N
53	5	Variety Handle	varietyHandle	global		f	none	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-08-03 17:04:53	2021-08-03 17:04:53	36cb7208-d072-48ac-af5e-c034035afdfd	\N
54	5	Variety Name	varietyName	global		f	site	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-08-03 17:04:57	2021-08-03 17:04:57	5fefc9c3-999f-4d02-988d-5a1738812936	\N
55	5	Tour Theme	tourTheme	global		t	site	\N	craft\\fields\\Categories	{"allowLimit":false,"allowMultipleSources":false,"allowSelfRelations":false,"branchLimit":"1","limit":null,"localizeRelations":false,"selectionLabel":"","showSiteMenu":false,"source":"group:40780a9f-1ee7-4c59-aaaf-159094330220","sources":"*","targetSiteId":null,"validateRelatedElements":false,"viewMode":null}	2021-08-12 21:49:09	2021-08-12 21:49:09	4b8d140e-8cb8-489e-9a89-0c30c4717e30	\N
52	5	Object Id	astroObjectId	global		f	none	\N	craft\\fields\\PlainText	{"byteLimit":null,"charLimit":null,"code":"","columnType":null,"initialRows":"4","multiline":"","placeholder":null,"uiMode":"normal"}	2021-08-03 17:04:50	2021-08-19 20:34:03	25d2c2a6-169a-461c-b67d-54294c7d22d7	\N
56	1	Image	astroImage	global		f	site	\N	craft\\fields\\Assets	{"allowSelfRelations":false,"allowUploads":true,"allowedKinds":null,"defaultUploadLocationSource":"volume:860a3a7b-7ed5-4997-9a40-0d00e58b77d0","defaultUploadLocationSubpath":"","limit":"","localizeRelations":false,"previewMode":"full","restrictFiles":"","selectionLabel":"","showSiteMenu":false,"showUnpermittedFiles":false,"showUnpermittedVolumes":false,"singleUploadLocationSource":"volume:85d34514-ec13-4850-a272-a3ab1bc790ef","singleUploadLocationSubpath":"","source":null,"sources":["volume:860a3a7b-7ed5-4997-9a40-0d00e58b77d0"],"targetSiteId":null,"useSingleFolder":false,"validateRelatedElements":false,"viewMode":"list"}	2021-08-19 20:34:03	2021-08-19 20:34:03	fe74f2bf-6416-4c77-a05d-1ef924e575a8	\N
\.


--
-- TOC entry 4603 (class 0 OID 16642)
-- Dependencies: 241
-- Data for Name: globalsets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.globalsets (id, name, handle, "fieldLayoutId", "dateCreated", "dateUpdated", uid, "sortOrder") FROM stdin;
6	Site Info	siteInfo	3	2021-06-15 15:02:03	2021-08-30 21:29:11	ea689411-d03e-48f0-8841-3318c457eee1	1
\.


--
-- TOC entry 4605 (class 0 OID 16651)
-- Dependencies: 243
-- Data for Name: gqlschemas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.gqlschemas (id, name, scope, "isPublic", "dateCreated", "dateUpdated", uid) FROM stdin;
1	Public Schema	["sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d:read","entrytypes.16b1feef-a5aa-449f-b011-919a9d6075ed:read","sections.32b433c2-8fa2-439b-9678-d48e4f929b88:read","entrytypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2:read","sections.02e3155f-23cf-4f36-a734-a3f447d04e85:read","entrytypes.bae3d86b-064a-47c2-9af4-736639f79b7b:read","sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f:read","entrytypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9:read","volumes.a469a047-d19a-421e-97f8-c58f1bda27d7:read","volumes.85d34514-ec13-4850-a272-a3ab1bc790ef:read","volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0:read","globalsets.ea689411-d03e-48f0-8841-3318c457eee1:read","categorygroups.40780a9f-1ee7-4c59-aaaf-159094330220:read","categorygroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3:read"]	t	2021-05-19 22:30:12	2021-08-19 20:34:03	d250222b-10fd-487b-a94c-8c7aa5241cb3
\.


--
-- TOC entry 4607 (class 0 OID 16661)
-- Dependencies: 245
-- Data for Name: gqltokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.gqltokens (id, name, "accessToken", enabled, "expiryDate", "lastUsed", "schemaId", "dateCreated", "dateUpdated", uid) FROM stdin;
1	Public Token	__PUBLIC__	t	\N	\N	1	2021-05-19 22:30:12	2021-05-19 22:30:12	2891d0be-e8ee-4803-8805-95e818f1360d
\.


--
-- TOC entry 4609 (class 0 OID 16671)
-- Dependencies: 247
-- Data for Name: info; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.info (id, version, "schemaVersion", maintenance, "configVersion", "fieldVersion", "dateCreated", "dateUpdated", uid) FROM stdin;
1	3.7.17.1	3.7.8	f	pvcmjjstboqb	iggpqzruluca	2021-05-19 21:09:33	2021-10-22 19:45:28	393da067-9dd3-4b05-bf3f-a6e8e914ae1d
\.


--
-- TOC entry 4611 (class 0 OID 16680)
-- Dependencies: 249
-- Data for Name: matrixblocks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.matrixblocks (id, "ownerId", "fieldId", "typeId", "sortOrder", "deletedWithOwner", "dateCreated", "dateUpdated", uid) FROM stdin;
55	54	17	1	1	\N	2021-06-21 23:04:33	2021-06-21 23:04:33	3eb7d0eb-0083-41d2-92da-1b534ebbd489
56	54	17	1	2	\N	2021-06-21 23:04:33	2021-06-21 23:04:33	6d310f09-4a1e-4c59-96c4-23a4cfd3b312
62	61	17	1	1	\N	2021-06-21 23:06:50	2021-06-21 23:06:50	aff330d7-3be1-4f1e-9711-f11ee54c8770
63	61	17	1	2	\N	2021-06-21 23:06:50	2021-06-21 23:06:50	b7776e74-a9ee-4f56-8e4a-c99eee0a44a0
64	61	17	1	3	\N	2021-06-21 23:06:50	2021-06-21 23:06:50	6fbe6820-1fd5-4d81-a02c-65cf57392789
58	57	17	1	1	t	2021-06-21 23:06:50	2021-06-21 23:06:50	1c6fd4eb-e02f-44b8-bc1d-fc239bd9c86f
59	57	17	1	2	t	2021-06-21 23:06:50	2021-06-21 23:06:50	9b346fe0-7ac1-4186-9547-da7d51c13641
60	57	17	1	3	t	2021-06-21 23:06:50	2021-06-21 23:06:50	d2f84737-1b86-42e8-ad49-c383ed77fb7f
52	51	17	1	1	t	2021-06-21 23:04:33	2021-06-21 23:04:33	d2cd0d77-2d84-4329-b92a-772ad422203d
53	51	17	1	2	t	2021-06-21 23:04:33	2021-06-21 23:04:33	61492847-b4ce-45b2-a3f8-96b63bd102f9
69	67	17	1	1	\N	2021-06-22 21:51:07	2021-06-22 21:51:07	0da75060-e378-4ac5-9fa9-4da015838f10
71	70	17	1	1	\N	2021-06-22 21:51:08	2021-06-22 21:51:08	756e2dd6-29a2-4a85-b5e0-fbc3768b1caf
72	67	31	3	1	\N	2021-06-22 21:51:45	2021-06-22 21:51:45	19cfbfbb-2d8d-4aa9-a697-cfc2f10c66dc
73	67	35	2	1	\N	2021-06-22 21:51:45	2021-06-22 21:51:45	2d0ffec4-ce9b-4c89-a556-3967e4ab53af
75	74	17	1	1	\N	2021-06-22 21:51:45	2021-06-22 21:51:45	cf3c6903-cc76-41de-bc73-3c81bfd9ec85
76	74	31	3	1	\N	2021-06-22 21:51:45	2021-06-22 21:51:45	57fca382-aaa0-483c-9dd9-081a528540f2
77	74	35	2	1	\N	2021-06-22 21:51:45	2021-06-22 21:51:45	21c8290e-fa06-4463-9f92-8363b2462422
96	95	17	1	1	\N	2021-07-16 18:43:41	2021-07-16 18:43:41	008ae8f7-d50a-4c19-99ec-14435f102f01
97	95	31	3	1	\N	2021-07-16 18:43:41	2021-07-16 18:43:41	b39e9034-1077-452f-96b0-d29a2193000a
98	95	35	2	1	\N	2021-07-16 18:43:41	2021-07-16 18:43:41	df81f7b2-6bec-4787-8a3e-75409611efa9
100	99	17	1	1	\N	2021-07-16 18:43:42	2021-07-16 18:43:42	b51dd51e-3bb3-4e88-8f74-2ef6ea2d8e18
101	99	31	3	1	\N	2021-07-16 18:43:42	2021-07-16 18:43:42	55ecee8c-4427-4170-a5e7-cb6f622d49e3
102	99	35	2	1	\N	2021-07-16 18:43:42	2021-07-16 18:43:42	9ce3753b-0d7e-4d09-ace7-a55d2f1b08b7
105	104	17	1	1	\N	2021-07-16 18:45:52	2021-07-16 18:45:52	e9815813-cab9-4295-8d98-46b7836c5362
106	104	31	3	1	\N	2021-07-16 18:45:53	2021-07-16 18:45:53	ff6a8bb2-38e8-46a0-ade5-de258ae2e7fe
107	104	35	2	1	\N	2021-07-16 18:45:53	2021-07-16 18:45:53	bf892136-8307-4548-aa04-e9067b0800b3
109	108	17	1	1	\N	2021-07-19 22:32:20	2021-07-19 22:32:20	562cc616-a5b9-45f7-bd30-87e90914273d
110	108	31	3	1	\N	2021-07-19 22:32:26	2021-07-19 22:32:26	669287a7-d7cf-4263-8f26-76749856c34a
111	108	35	2	1	\N	2021-07-19 22:32:31	2021-07-19 22:32:31	b21d9ce1-67b9-40ef-93f8-124d945d8ecb
142	141	17	1	1	\N	2021-08-06 23:02:41	2021-08-06 23:02:41	bc668606-7d29-40cd-9ecd-56eac1192b60
143	141	31	3	1	\N	2021-08-06 23:02:41	2021-08-06 23:02:41	92335e86-5548-457e-9b74-cc8cb63f86bf
144	141	35	2	1	\N	2021-08-06 23:02:41	2021-08-06 23:02:41	ec7f67d7-0194-459d-8b2d-fccc254020bc
146	145	17	1	1	\N	2021-08-06 23:02:51	2021-08-06 23:02:51	a3e391cb-48eb-40e8-a3a3-94cfda799c58
147	145	31	3	1	\N	2021-08-06 23:02:51	2021-08-06 23:02:51	32c1fd26-a4de-4246-9f7b-36f978daef06
148	145	35	2	1	\N	2021-08-06 23:02:51	2021-08-06 23:02:51	8b6dbdde-8ff2-4813-af6f-3b0fa9d9a0c6
151	150	17	1	1	\N	2021-08-06 23:04:32	2021-08-06 23:04:32	d1142a82-8bef-4a93-85f6-304b03cbe013
152	150	31	3	1	\N	2021-08-06 23:04:32	2021-08-06 23:04:32	e4304e7b-52fb-45db-b2dc-b03d192c1d12
153	150	35	2	1	\N	2021-08-06 23:04:32	2021-08-06 23:04:32	db9ab9ee-866b-4d91-b465-fdb60082821d
155	154	17	1	1	\N	2021-08-06 23:04:44	2021-08-06 23:04:44	a31264a5-b46b-4221-b642-c0ef44e0eced
156	154	31	3	1	\N	2021-08-06 23:04:44	2021-08-06 23:04:44	caf9e46d-9f8e-4bd9-9373-3d2ad5601011
157	154	35	2	1	\N	2021-08-06 23:04:44	2021-08-06 23:04:44	09b62dbf-48d7-4d7f-8c85-c9660ba029e9
159	158	17	1	1	\N	2021-08-06 23:05:17	2021-08-06 23:05:17	6fe8efe7-1692-4442-bf40-fce656627c41
160	158	31	3	1	\N	2021-08-06 23:05:17	2021-08-06 23:05:17	05281e3f-cf69-4279-9e45-dcdfb29bde3c
161	158	35	2	1	\N	2021-08-06 23:05:17	2021-08-06 23:05:17	80ba2a1b-54bb-44d5-83e5-47c2f544bc18
169	168	17	1	1	\N	2021-08-17 20:25:12	2021-08-17 20:25:12	3a4c793f-0255-47fe-ab5e-38be2fecd2c0
170	168	31	3	1	\N	2021-08-17 20:25:12	2021-08-17 20:25:12	9d0a186d-c165-445d-8718-16bb2d1e5750
171	168	35	2	1	\N	2021-08-17 20:25:12	2021-08-17 20:25:12	feff0361-0d67-4ae1-88f2-c1aa79cc64da
174	173	17	1	1	\N	2021-08-17 20:25:35	2021-08-17 20:25:35	8875a66d-6f5f-428e-bc05-4bf435ee129f
175	173	31	3	1	\N	2021-08-17 20:25:35	2021-08-17 20:25:35	2f851f3a-5835-4a42-97b0-dd6f2e15f198
176	173	35	2	1	\N	2021-08-17 20:25:35	2021-08-17 20:25:35	be383e50-992b-42e3-bf90-0074b8e34dfd
180	179	17	1	1	\N	2021-08-17 20:28:35	2021-08-17 20:28:35	8da891b3-5f8c-4f65-b96a-dc3f884c7117
181	179	31	3	1	\N	2021-08-17 20:28:35	2021-08-17 20:28:35	50a083ee-8dcb-41fd-8aaa-f3117547419a
182	179	35	2	1	\N	2021-08-17 20:28:35	2021-08-17 20:28:35	cf738c0c-eb0d-4857-ae23-fa00c965e0df
184	183	17	1	1	\N	2021-08-17 20:29:07	2021-08-17 20:29:07	8602065d-9c16-49de-8113-26a3fe8cefac
185	183	31	3	1	\N	2021-08-17 20:29:07	2021-08-17 20:29:07	efb9ccae-a81d-4284-910f-daf565572f14
186	183	35	2	1	\N	2021-08-17 20:29:07	2021-08-17 20:29:07	4562c50b-83c4-48d1-a035-142e99f388d9
211	210	17	1	1	\N	2021-08-20 21:56:58	2021-08-20 21:56:58	0fc779b4-09c6-4e05-a34c-8180baa01597
212	210	31	3	1	\N	2021-08-20 21:56:58	2021-08-20 21:56:58	ba4da694-1480-4685-af95-66654af0dfdb
213	210	35	2	1	\N	2021-08-20 21:56:58	2021-08-20 21:56:58	5bad4731-7b1b-43c4-b5b1-9a17e21a3ec0
230	227	17	1	1	f	2021-08-30 21:31:49	2021-08-30 21:31:49	e90a648d-19bc-4663-9e07-ea92f320728e
232	227	17	1	1	\N	2021-08-30 21:31:54	2021-08-30 21:31:54	4388855b-9cbd-40ee-ab1d-d33d25d9af7d
231	227	17	1	1	f	2021-08-30 21:31:51	2021-08-30 21:31:51	eeb908ac-83cc-4767-a133-7407dee03b3f
233	227	31	3	1	f	2021-08-30 21:31:59	2021-08-30 21:31:59	ac4bf445-11fb-48b7-9817-77b12cd1ff72
234	227	31	3	1	f	2021-08-30 21:32:01	2021-08-30 21:32:01	d1bcc41e-5876-4b5e-b715-29f29f0cfc00
236	227	31	3	1	\N	2021-08-30 21:32:05	2021-08-30 21:32:05	1c1f0b41-6269-4baa-8a3a-017f2b43f632
235	227	31	3	1	f	2021-08-30 21:32:03	2021-08-30 21:32:03	c26f439f-613d-4a45-af04-ee70cf187e98
237	227	35	2	1	f	2021-08-30 21:32:07	2021-08-30 21:32:07	38497101-e22e-4b7a-b8dc-5281d9f44fc7
242	227	35	2	1	\N	2021-08-30 21:32:33	2021-08-30 21:32:33	41db6752-45b2-4d17-a277-306131d2e05b
238	227	35	2	1	f	2021-08-30 21:32:11	2021-08-30 21:32:11	73daa909-d6c9-4fd4-99bc-28f8a958bac6
244	243	17	1	1	\N	2021-08-30 21:32:35	2021-08-30 21:32:35	d7315df4-e477-4800-b25d-225ad3aa4e74
245	243	31	3	1	\N	2021-08-30 21:32:35	2021-08-30 21:32:35	04ac955c-6cd2-4dfa-b0a5-8b15bb51f12a
246	243	35	2	1	\N	2021-08-30 21:32:35	2021-08-30 21:32:35	5a96dc07-fcce-49ea-abb4-11016b984bfa
252	251	17	1	1	\N	2021-09-08 17:50:58	2021-09-08 17:50:58	d8301bd4-cc6b-4b9b-a3b0-96582265db38
253	251	31	3	1	\N	2021-09-08 17:50:58	2021-09-08 17:50:58	47845328-d18c-4cdf-b32e-1e9f6c2b36dc
254	251	35	2	1	\N	2021-09-08 17:50:58	2021-09-08 17:50:58	681621d7-966f-46ed-9498-7738b5149dcd
302	298	17	1	1	\N	2021-09-08 18:26:00	2021-09-08 18:26:00	b01d9652-b5bf-4c26-b16c-06991e2938b0
301	298	17	1	1	f	2021-09-08 18:25:58	2021-09-08 18:25:58	578116ab-6b0f-4b65-85ba-e11bd243614a
260	259	17	1	1	\N	2021-09-08 17:54:32	2021-09-08 17:54:32	be1da566-e3c1-4e68-9d9c-3b41e2ef794f
261	259	31	3	1	\N	2021-09-08 17:54:32	2021-09-08 17:54:32	c3ccf919-9275-4406-b408-af08bd5cc8c4
262	259	35	2	1	\N	2021-09-08 17:54:32	2021-09-08 17:54:32	c655ba19-1b9d-4164-93e9-a6731249d773
303	298	31	3	1	f	2021-09-08 18:26:05	2021-09-08 18:26:05	7d16afac-1b9e-496d-b397-3007d6c0e92f
305	298	31	3	1	\N	2021-09-08 18:26:12	2021-09-08 18:26:12	433e92b4-2092-411c-b09e-f4eb331edfb5
268	267	17	1	1	\N	2021-09-08 17:54:52	2021-09-08 17:54:52	c18f8da9-060b-4a59-8da1-cdc8e8e29c5b
269	267	31	3	1	\N	2021-09-08 17:54:52	2021-09-08 17:54:52	a7e60b93-6da3-4881-ab02-80ed76c196cf
270	267	35	2	1	\N	2021-09-08 17:54:52	2021-09-08 17:54:52	f3778040-2957-41b5-ae4f-b6efacd229c3
304	298	31	3	1	f	2021-09-08 18:26:08	2021-09-08 18:26:08	3b04f8fd-529e-4a8e-bd16-8a3c7e638aa0
276	275	17	1	1	\N	2021-09-08 17:55:09	2021-09-08 17:55:09	7dc12761-0709-4bfc-9a7c-354c9238c2f4
277	275	31	3	1	\N	2021-09-08 17:55:09	2021-09-08 17:55:09	e4517eae-3df0-4949-aaf0-ee15be55d484
278	275	35	2	1	\N	2021-09-08 17:55:09	2021-09-08 17:55:09	1f4f871d-231d-43dd-8903-5dc7847f25ad
306	298	35	2	1	f	2021-09-08 18:26:14	2021-09-08 18:26:14	862db15b-c2c1-4448-9770-f1f5f901712d
310	298	35	2	1	\N	2021-09-08 18:26:56	2021-09-08 18:26:56	20fe730c-50ea-474b-81b0-9e86662f3670
307	298	35	2	1	f	2021-09-08 18:26:17	2021-09-08 18:26:17	cf16eb72-5fc5-4bd8-8d10-8e55ddb7aa26
281	279	17	1	1	f	2021-09-08 17:57:46	2021-09-08 17:57:46	6deb808e-3ddd-4eb0-90ab-a73db3ef2a84
282	279	17	1	1	f	2021-09-08 17:57:48	2021-09-08 17:57:48	267ed794-62fa-47b5-a842-0d8a5fa9b1ab
283	279	17	1	1	f	2021-09-08 17:57:50	2021-09-08 17:57:50	2b959e36-a82c-4a55-8d85-e0a0207621cf
285	279	31	3	1	f	2021-09-08 17:58:07	2021-09-08 17:58:07	4142cb63-4638-4241-8315-020820f466dc
287	279	35	2	1	f	2021-09-08 17:58:14	2021-09-08 17:58:14	59af02ff-6d0f-44ef-9220-cf6901700af1
288	279	35	2	1	f	2021-09-08 17:58:17	2021-09-08 17:58:17	df961aa9-36a8-4384-a777-5b430ed2aaae
289	279	35	2	1	f	2021-09-08 17:58:18	2021-09-08 17:58:18	61ad4be7-e41d-415a-bb45-71df6e2c1e66
295	294	17	1	1	\N	2021-09-08 17:58:58	2021-09-08 17:58:58	faffb35d-9ab7-4c18-8261-979492fb0e4c
296	294	31	3	1	\N	2021-09-08 17:58:58	2021-09-08 17:58:58	78869a4d-db2b-4006-bc51-cc4095b80153
297	294	35	2	1	\N	2021-09-08 17:58:58	2021-09-08 17:58:58	36a5866e-2772-445c-b22c-e145d323517c
284	279	17	1	1	t	2021-09-08 17:57:52	2021-09-08 17:57:52	b529296a-7fe6-4057-bae1-10c8479e1b89
286	279	31	3	1	t	2021-09-08 17:58:11	2021-09-08 17:58:11	563ccedc-b384-43ab-9e1a-53f5b4396de8
293	279	35	2	1	t	2021-09-08 17:58:56	2021-09-08 17:58:56	1ce6d343-600d-47a2-a550-ec75fbaa0fcc
299	298	17	1	1	f	2021-09-08 18:25:54	2021-09-08 18:25:54	cd75d33d-7611-4ad3-a61b-4f5564742689
300	298	17	1	1	f	2021-09-08 18:25:56	2021-09-08 18:25:56	342c601f-b926-4b54-84f0-d09eb148728d
312	311	17	1	1	\N	2021-09-08 18:26:58	2021-09-08 18:26:58	93e67897-ec73-44a5-82ac-f05cce17ba44
313	311	31	3	1	\N	2021-09-08 18:26:58	2021-09-08 18:26:58	20578113-110f-428c-9f0f-8680b1915157
314	311	35	2	1	\N	2021-09-08 18:26:58	2021-09-08 18:26:58	be6a38f2-0617-4c68-8d12-0cb0907c02cc
413	412	17	1	1	\N	2021-10-08 23:06:44	2021-10-08 23:06:44	bf8ba173-5c25-4d48-891c-b773ec743930
414	412	31	3	1	\N	2021-10-08 23:06:44	2021-10-08 23:06:44	34a5964c-7f82-4d93-9bfb-962ad013ad06
415	412	35	2	1	\N	2021-10-08 23:06:44	2021-10-08 23:06:44	0a9c1f2e-8f13-4130-8145-211548e29af1
430	429	17	1	1	\N	2021-10-08 23:08:17	2021-10-08 23:08:17	78bd7c2c-7dfd-4883-b441-65c4c0c2f132
431	429	31	3	1	\N	2021-10-08 23:08:17	2021-10-08 23:08:17	e18a3850-b031-4ad5-a569-fabf4aaeed7d
432	429	35	2	1	\N	2021-10-08 23:08:17	2021-10-08 23:08:17	03051509-6721-4eae-9d60-83f379cf72b6
421	420	17	1	1	\N	2021-10-08 23:07:34	2021-10-08 23:07:34	d5fbbd35-ec56-4760-9bb1-482658b6bf7b
422	420	31	3	1	\N	2021-10-08 23:07:34	2021-10-08 23:07:34	6f47dd51-7b57-4101-ae96-fe2df69418de
423	420	35	2	1	\N	2021-10-08 23:07:34	2021-10-08 23:07:34	f3285a50-57da-4be8-91d0-86330c26be03
438	437	17	1	1	\N	2021-10-08 23:08:49	2021-10-08 23:08:49	93832f6b-c196-4712-a189-ee61ab122ee5
439	437	31	3	1	\N	2021-10-08 23:08:49	2021-10-08 23:08:49	95011adc-954b-4b19-879e-09a4d3781554
440	437	35	2	1	\N	2021-10-08 23:08:49	2021-10-08 23:08:49	96708143-2845-4ff9-afa5-bad8d439337e
\.


--
-- TOC entry 4612 (class 0 OID 16684)
-- Dependencies: 250
-- Data for Name: matrixblocktypes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.matrixblocktypes (id, "fieldId", "fieldLayoutId", name, handle, "sortOrder", "dateCreated", "dateUpdated", uid) FROM stdin;
1	17	8	Intro Content Block	introBlock	1	2021-06-21 22:20:10	2021-06-22 21:50:13	48d995fe-6d24-48f6-904a-c54f64964387
2	35	13	Tour POI	tourPoi	1	2021-06-22 21:50:13	2021-06-22 21:50:13	a8b34826-6a25-4e0a-b5dc-7e9820257899
3	31	14	Facts Content Block	factsContentBlock	1	2021-06-22 21:50:13	2021-06-22 21:50:13	8944198c-ff53-4323-ad48-976efeb3f56e
4	41	15	poiAstroObject	poiAstroObject	1	2021-07-16 17:47:52	2021-07-16 17:47:52	82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c
\.


--
-- TOC entry 4614 (class 0 OID 16693)
-- Dependencies: 252
-- Data for Name: matrixcontent_factscontentblocks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.matrixcontent_factscontentblocks (id, "elementId", "siteId", "dateCreated", "dateUpdated", uid, "field_factsContentBlock_body") FROM stdin;
3	76	1	2021-06-22 21:51:45	2021-06-22 21:51:45	f63c27ab-8ed2-4181-a2ba-8a55153f1625	<p>Aliens are <strong>kewl</strong>!</p>
4	76	2	2021-06-22 21:51:45	2021-06-22 21:51:45	7cedd0f5-2d83-46a3-b743-501e9ae03937	<p>Aliens are <strong>kewl</strong>!</p>
5	88	1	2021-07-16 18:42:31	2021-07-16 18:42:31	862e1bdc-da86-45b5-aae5-944d507b322f	\N
6	88	2	2021-07-16 18:42:31	2021-07-16 18:42:31	dcdb3ca4-b569-4d83-937f-819ee11366a4	\N
11	101	1	2021-07-16 18:43:42	2021-07-16 18:43:42	67fc7d9b-01d9-4276-810d-a2a0b943119e	<p><em>ha</em></p>
12	101	2	2021-07-16 18:43:42	2021-07-16 18:43:42	5f3d9899-bd88-4a19-a3be-0e2feea26b3c	<p><em>ha</em></p>
13	106	1	2021-07-16 18:45:53	2021-07-16 18:45:53	65738505-5227-4dcd-a09e-dc8668790dad	<p><em>ha</em></p>
14	106	2	2021-07-16 18:45:53	2021-07-16 18:45:53	133e1dc7-d4a5-4a4c-9d5a-82c9d3fcce9d	<p><em>ha</em></p>
15	110	1	2021-07-19 22:32:25	2021-07-19 22:32:25	3627f3ae-e2bf-404a-aa43-6092b4615f0d	<p>Aliens are <strong>kewl</strong>!</p>
16	110	2	2021-07-19 22:32:28	2021-07-19 22:32:28	16dc3dd2-2714-41fc-bc3b-fe37c6c290f2	<p>Aliens are <strong>kewl</strong>!</p>
17	143	1	2021-08-06 23:02:41	2021-08-06 23:02:41	ba8b4825-3ad4-4667-bf3c-5c90fb0cd93c	<p>Aliens are <strong>kewl</strong>!</p>
18	143	2	2021-08-06 23:02:41	2021-08-06 23:02:41	164faa7f-5dbb-41ed-b4d9-bfd8366f84d5	<p>Aliens are <strong>kewl</strong>!</p>
19	147	1	2021-08-06 23:02:51	2021-08-06 23:02:51	d44d3ba4-6872-47da-8e96-9c5ce818e91c	<p><em>ha</em></p>
20	147	2	2021-08-06 23:02:51	2021-08-06 23:02:51	8baea1e6-7114-4855-b7c6-fa9ac80e5d5d	<p><em>ha</em></p>
21	152	1	2021-08-06 23:04:32	2021-08-06 23:04:32	2f74e36e-0c91-4987-83a2-81567f29dc88	<p>Aliens are <strong>kewl</strong>!</p>
22	152	2	2021-08-06 23:04:32	2021-08-06 23:04:32	c8664fcc-dc25-4908-b032-c07739f91839	<p>Aliens are <strong>kewl</strong>!</p>
23	156	1	2021-08-06 23:04:44	2021-08-06 23:04:44	9e4201f2-a377-47db-a94c-1f58036ee355	<p><em>ha</em></p>
24	156	2	2021-08-06 23:04:44	2021-08-06 23:04:44	e8a1f803-1939-414e-8000-72f6dafa4413	<p><em>ha</em></p>
25	160	1	2021-08-06 23:05:17	2021-08-06 23:05:17	87c3e53f-aea2-4384-ab27-749cd2e3d8f5	<p><em>ha</em></p>
26	160	2	2021-08-06 23:05:17	2021-08-06 23:05:17	f242f92c-2b17-4648-b6c3-4603f752df4b	<p><em>ha</em></p>
27	170	1	2021-08-17 20:25:12	2021-08-17 20:25:12	96c07512-9a9f-4933-ae4f-25913b537fcf	<p>Aliens are <strong>kewl</strong>!</p>
28	170	2	2021-08-17 20:25:12	2021-08-17 20:25:12	ec6f3045-8ebb-4d45-8a72-089e1f457c23	<p>Aliens are <strong>kewl</strong>!</p>
29	175	1	2021-08-17 20:25:35	2021-08-17 20:25:35	60a50d83-e1dd-411a-b336-f3bfd935380c	<p><em>ha</em></p>
30	175	2	2021-08-17 20:25:35	2021-08-17 20:25:35	ddd7c266-47a8-43d1-bd02-398ea090c718	<p><em>ha</em></p>
31	181	1	2021-08-17 20:28:35	2021-08-17 20:28:35	1c89b620-6e45-4a25-9cde-fb09dce0ed34	<p><em>ha</em></p>
32	181	2	2021-08-17 20:28:35	2021-08-17 20:28:35	0724471e-f5e2-4b13-a49d-d8eb59db54c1	<p><em>ha</em></p>
33	185	1	2021-08-17 20:29:07	2021-08-17 20:29:07	a9d02280-78a9-4538-acdb-5c2e203c32a9	<p><em>ha</em></p>
34	185	2	2021-08-17 20:29:07	2021-08-17 20:29:07	d33df855-e7fe-41b2-8542-8af0ba31e23f	<p><em>ha</em></p>
35	212	1	2021-08-20 21:56:58	2021-08-20 21:56:58	780d335e-fef3-4132-9312-f763078f6a92	<p><em>ha</em></p>
36	212	2	2021-08-20 21:56:58	2021-08-20 21:56:58	309c69b2-7640-4ab0-871b-39dd8cf468b6	<p><em>ha</em></p>
37	233	1	2021-08-30 21:31:58	2021-08-30 21:31:58	7ce77544-10de-40c9-a489-8b3fca6bb02a	\N
38	233	2	2021-08-30 21:31:59	2021-08-30 21:31:59	14d9a0dc-d62e-4fcd-8147-489415156e19	\N
39	234	1	2021-08-30 21:32:00	2021-08-30 21:32:00	cfc98a73-b4e9-4bb1-a62f-6f6fff24bf4c	<p>Tours</p>
40	234	2	2021-08-30 21:32:01	2021-08-30 21:32:01	8b715184-8bc3-4e9f-b868-7c36493ba361	<p>Tours</p>
41	235	1	2021-08-30 21:32:03	2021-08-30 21:32:03	097917da-65c7-44e2-a2e1-5f244f3e5e2f	<p>Tours are fun!</p>
42	235	2	2021-08-30 21:32:03	2021-08-30 21:32:03	4f42d4b4-01a7-490f-8f38-33b72214b7e2	<p>Tours are fun!</p>
45	245	1	2021-08-30 21:32:35	2021-08-30 21:32:35	75de500c-33cb-421a-b4d2-145cf852eaec	<p>Tours <em>are</em> fun!</p>
46	245	2	2021-08-30 21:32:35	2021-08-30 21:32:35	c6fa19e2-4c40-4930-b6e4-8d6050e25b1e	<p>Tours <em>are</em> fun!</p>
49	253	1	2021-09-08 17:50:58	2021-09-08 17:50:58	fd4a4587-0861-476b-a3d2-08b79790c3ee	<p><em>ha</em></p>
50	253	2	2021-09-08 17:50:58	2021-09-08 17:50:58	c88de427-ed3b-40d5-8189-12df84e2deb2	<p><em>ha</em></p>
57	269	1	2021-09-08 17:54:52	2021-09-08 17:54:52	62394976-d7f1-4309-aa05-c062b93b3964	<p>Tours <em>are</em> fun!</p>
58	269	2	2021-09-08 17:54:52	2021-09-08 17:54:52	dd26e646-dd4b-457d-b393-59fbd3eb533e	<p>Tours <em>are</em> fun!</p>
9	97	1	2021-07-16 18:43:41	2021-10-08 23:07:33	6783b4ae-2599-4dc0-82a0-4131c36e0dc0	<p><em>ha</em></p>
10	97	2	2021-07-16 18:43:41	2021-10-08 23:07:33	67ebbb2d-4abc-446e-b013-2d1695c684c4	<p><em>ha</em></p>
53	261	1	2021-09-08 17:54:32	2021-09-08 17:54:32	cfe3d3ab-2499-47c9-b8c0-d36f2bb5516c	<p>Aliens are <strong>kewl</strong>!</p>
54	261	2	2021-09-08 17:54:32	2021-09-08 17:54:32	5564d874-219d-4f8e-91de-e85983ad9159	<p>Aliens are <strong>kewl</strong>!</p>
63	285	1	2021-09-08 17:58:07	2021-09-08 17:58:07	e0463bf5-4b6f-4efd-9982-b69f89b35c2c	\N
64	285	2	2021-09-08 17:58:07	2021-09-08 17:58:07	ed3e4bdd-d80c-40b7-905f-64b1dd9985f7	\N
65	286	1	2021-09-08 17:58:11	2021-09-08 17:58:11	89ca564f-26f3-42bc-b694-1080938bc8c6	<p>gnar</p>
73	305	1	2021-09-08 18:26:12	2021-10-08 23:08:49	abcc8713-411f-4caa-b275-c2108b76ab8d	<p>Cloudy clou<u>d</u></p>
74	305	2	2021-09-08 18:26:12	2021-10-08 23:08:49	4fdfa86e-ce72-4e4c-8319-dc7d6f5e7f3b	<p>Cloudy clou<u>d</u></p>
61	277	1	2021-09-08 17:55:09	2021-09-08 17:55:09	b9561d3a-df6b-481b-bb91-561301509d51	<p>Tours <em>are</em> fun!</p>
62	277	2	2021-09-08 17:55:09	2021-09-08 17:55:09	2d5fac52-ae21-4553-b735-8a56ee022cb1	<p>Tours <em>are</em> fun!</p>
66	286	2	2021-09-08 17:58:11	2021-09-08 17:58:11	ac5efed3-a39a-4b62-a27f-b04794cee983	<p>gnar</p>
67	296	1	2021-09-08 17:58:58	2021-09-08 17:58:58	0fc237e3-d6de-4dbb-be76-6f6e448704df	<p>gnar</p>
68	296	2	2021-09-08 17:58:58	2021-09-08 17:58:58	0eb5085c-eeec-4707-9083-096edf042f40	<p>gnar</p>
69	303	1	2021-09-08 18:26:05	2021-09-08 18:26:05	e3c716da-9ab3-4657-a44c-5a02c6e65ad2	\N
70	303	2	2021-09-08 18:26:05	2021-09-08 18:26:05	ccfb39b5-5793-4c90-9c64-5df5c39a3caf	\N
71	304	1	2021-09-08 18:26:08	2021-09-08 18:26:08	35101ec1-2ffd-4d69-b987-4e55abda9ff2	<p>Cloudy cloud</p>
72	304	2	2021-09-08 18:26:08	2021-09-08 18:26:08	3f42106e-e581-4ce5-976a-d5ee3cd8a085	<p>Cloudy cloud</p>
75	313	1	2021-09-08 18:26:58	2021-09-08 18:26:58	8b2c2647-a205-4446-8b2a-e5eaf1790eb4	<p>Cloudy clou<u>d</u></p>
76	313	2	2021-09-08 18:26:58	2021-09-08 18:26:58	69b8bb21-1a49-43de-83da-aa540c092b9f	<p>Cloudy clou<u>d</u></p>
43	236	1	2021-08-30 21:32:05	2021-10-08 23:08:16	61d47d66-73bb-4612-9bfa-9a8f9479e847	<p>Tours <em>are</em> fun!</p>
44	236	2	2021-08-30 21:32:05	2021-10-08 23:08:16	cb6def32-91e1-4908-9297-ddb2110baa13	<p>Tours <em>are</em> fun!</p>
1	72	1	2021-06-22 21:51:45	2021-10-08 23:06:43	a63bc58a-5e54-4ef6-9064-f920a03cdc4d	<p>Aliens are <strong>kewl</strong>!</p>
2	72	2	2021-06-22 21:51:45	2021-10-08 23:06:43	e1f95fec-c43e-4023-ae5f-c9d4d493decc	<p>Aliens are <strong>kewl</strong>!</p>
79	414	1	2021-10-08 23:06:44	2021-10-08 23:06:44	32634b89-c7ad-4bfb-9e88-148d14d99383	<p>Aliens are <strong>kewl</strong>!</p>
80	414	2	2021-10-08 23:06:44	2021-10-08 23:06:44	837b58ef-d88f-42bd-bf14-2999a30c1e5b	<p>Aliens are <strong>kewl</strong>!</p>
83	422	1	2021-10-08 23:07:34	2021-10-08 23:07:34	d9fa6715-a271-4ad1-b589-39988d82ee4b	<p><em>ha</em></p>
84	422	2	2021-10-08 23:07:34	2021-10-08 23:07:34	67bb375f-f6e3-4ac8-8ab8-abc9886794b3	<p><em>ha</em></p>
87	431	1	2021-10-08 23:08:17	2021-10-08 23:08:17	d2bf2dbf-27bc-4fb8-80e5-92764f46a44c	<p>Tours <em>are</em> fun!</p>
88	431	2	2021-10-08 23:08:17	2021-10-08 23:08:17	effc2815-901e-4777-9999-f1072de6a01e	<p>Tours <em>are</em> fun!</p>
91	439	1	2021-10-08 23:08:49	2021-10-08 23:08:49	6f448339-adea-44b4-98f6-3fbac7de4fd6	<p>Cloudy clou<u>d</u></p>
92	439	2	2021-10-08 23:08:49	2021-10-08 23:08:49	374c3e2c-1cca-46f0-8a1d-de0a8d7d7863	<p>Cloudy clou<u>d</u></p>
\.


--
-- TOC entry 4616 (class 0 OID 16702)
-- Dependencies: 254
-- Data for Name: matrixcontent_introcontentblocks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.matrixcontent_introcontentblocks (id, "elementId", "siteId", "dateCreated", "dateUpdated", uid, "field_introBlock_body") FROM stdin;
1	52	1	2021-06-21 23:04:33	2021-06-21 23:04:33	6b487aab-bcb3-4abd-9c5f-65632d6c8e78	<p>Blah <strong>blah <em>blah</em></strong></p>
2	52	2	2021-06-21 23:04:33	2021-06-21 23:04:33	da3ef638-0530-4210-8bd0-2b31ddd82d4c	<p>Blah <strong>blah <em>blah</em></strong></p>
3	53	1	2021-06-21 23:04:33	2021-06-21 23:04:33	07753d99-240f-4536-b3ca-b59925e6a1f5	<ul><li>More stuff</li></ul>
4	53	2	2021-06-21 23:04:33	2021-06-21 23:04:33	38e5bc86-e8b7-40e1-a3d5-49bdce055d8f	<ul><li>More stuff</li></ul>
5	55	1	2021-06-21 23:04:33	2021-06-21 23:04:33	d9dc99cd-cd9e-4a2a-b35e-4641ee5bd631	<p>Blah <strong>blah <em>blah</em></strong></p>
6	55	2	2021-06-21 23:04:33	2021-06-21 23:04:33	beb1b14e-89a7-40f2-95e7-4c50a29c3785	<p>Blah <strong>blah <em>blah</em></strong></p>
7	56	1	2021-06-21 23:04:33	2021-06-21 23:04:33	1edbf07d-d96f-4670-86c0-03e1114502a3	<ul><li>More stuff</li></ul>
8	56	2	2021-06-21 23:04:33	2021-06-21 23:04:33	f82c7d8c-034f-4ed1-9968-585ab30ba7b6	<ul><li>More stuff</li></ul>
9	58	1	2021-06-21 23:06:50	2021-06-21 23:06:50	5e9ffb63-5ff5-4cfb-a90b-0119004b4d90	<h1>They have cool technologies</h1>
10	58	2	2021-06-21 23:06:50	2021-06-21 23:06:50	0ba6230f-e37d-49a1-84c6-66460817d82e	<h1>They have cool technologies</h1>
11	59	1	2021-06-21 23:06:50	2021-06-21 23:06:50	fd39443b-bd73-4fa7-b4c9-8d33c47e50e9	<p>They have <strong>sweet</strong> <em>spaceships</em></p>
12	59	2	2021-06-21 23:06:50	2021-06-21 23:06:50	8f344c81-1076-4a71-bc9f-dc46be23ca1c	<p>They have <strong>sweet</strong> <em>spaceships</em></p>
13	60	1	2021-06-21 23:06:50	2021-06-21 23:06:50	77574c23-005c-4f05-913a-818c3162ae2e	<p>They can uplift us!</p>
14	60	2	2021-06-21 23:06:50	2021-06-21 23:06:50	7c1f2279-6db1-4074-be64-257abf64c679	<p>They can uplift us!</p>
15	62	1	2021-06-21 23:06:50	2021-06-21 23:06:50	bf7a3a5d-9fa4-4518-993c-03ebcb2350a7	<h1>They have cool technologies</h1>
16	62	2	2021-06-21 23:06:50	2021-06-21 23:06:50	26e188f5-9786-459f-8eb9-581f9a82553e	<h1>They have cool technologies</h1>
17	63	1	2021-06-21 23:06:50	2021-06-21 23:06:50	12139b87-c15e-4613-b7bb-a3590c079e7f	<p>They have <strong>sweet</strong> <em>spaceships</em></p>
18	63	2	2021-06-21 23:06:50	2021-06-21 23:06:50	0a7d3f9e-7131-4c39-9c77-83af47f0db91	<p>They have <strong>sweet</strong> <em>spaceships</em></p>
19	64	1	2021-06-21 23:06:50	2021-06-21 23:06:50	71b97447-abc3-4451-bbb1-c382b89a5b02	<p>They can uplift us!</p>
20	64	2	2021-06-21 23:06:50	2021-06-21 23:06:50	17e90226-31a6-4029-89f8-97519cef9d8f	<p>They can uplift us!</p>
23	71	1	2021-06-22 21:51:08	2021-06-22 21:51:08	eef0d0ab-8933-443c-96fd-815516243153	<p>blahbitty blah blah</p>
24	71	2	2021-06-22 21:51:08	2021-06-22 21:51:08	bf0bca17-dfb3-4c93-a20a-330d4f96f76d	<p>blahbitty blah blah</p>
25	75	1	2021-06-22 21:51:45	2021-06-22 21:51:45	f5812f4b-be95-4131-ae06-623602fd74ed	<p>blahbitty blah blah</p>
26	75	2	2021-06-22 21:51:45	2021-06-22 21:51:45	6dd73091-623f-40d8-a603-c1fb84b0c62f	<p>blahbitty blah blah</p>
27	86	1	2021-07-16 18:42:19	2021-07-16 18:42:19	1032b70d-0788-4b17-814b-466aac9379c7	\N
28	86	2	2021-07-16 18:42:19	2021-07-16 18:42:19	c1962db3-fd9b-4cf0-94f3-39ddd1ff8ac0	\N
33	100	1	2021-07-16 18:43:42	2021-07-16 18:43:42	06c171c4-280c-49ab-94ea-84a7f585a692	<p><strong>blah blah</strong></p>
34	100	2	2021-07-16 18:43:42	2021-07-16 18:43:42	d27de02b-56f5-4490-86d3-2a4805fd6c7f	<p><strong>blah blah</strong></p>
35	105	1	2021-07-16 18:45:52	2021-07-16 18:45:52	87ac416d-41f5-4ccc-9d98-08ba11e99a6f	<p><strong>blah blah</strong></p>
36	105	2	2021-07-16 18:45:53	2021-07-16 18:45:53	be1b96e2-0b53-492f-a642-567984655da4	<p><strong>blah blah</strong></p>
37	109	1	2021-07-19 22:32:19	2021-07-19 22:32:19	6ba0c527-f4e3-43e8-affc-0a927817df45	<p>blahbitty blah blah</p>
38	109	2	2021-07-19 22:32:23	2021-07-19 22:32:23	b37772b8-a88d-4b21-8a60-d2ced100ad66	<p>blahbitty blah blah</p>
39	142	1	2021-08-06 23:02:41	2021-08-06 23:02:41	7699e89f-5ca6-4211-8d1c-eb0478c05e01	<p>blahbitty blah blah</p>
40	142	2	2021-08-06 23:02:41	2021-08-06 23:02:41	43ba8e90-d037-4561-a8b6-78cfda07d74c	<p>blahbitty blah blah</p>
41	146	1	2021-08-06 23:02:51	2021-08-06 23:02:51	b601f201-32f7-4ef2-a867-df991846ec2f	<p><strong>blah blah</strong></p>
42	146	2	2021-08-06 23:02:51	2021-08-06 23:02:51	612ff249-f529-437a-aa1e-d10f37b23d11	<p><strong>blah blah</strong></p>
43	151	1	2021-08-06 23:04:32	2021-08-06 23:04:32	42d52489-83d2-4b38-9e48-695aa64d9b56	<p>blahbitty blah blah</p>
44	151	2	2021-08-06 23:04:32	2021-08-06 23:04:32	20583653-3653-453e-bae9-1b7692143773	<p>blahbitty blah blah</p>
45	155	1	2021-08-06 23:04:44	2021-08-06 23:04:44	43d19a1c-fe26-4c99-a9bd-63a2d17101db	<p><strong>blah blah</strong></p>
46	155	2	2021-08-06 23:04:44	2021-08-06 23:04:44	d7e5c319-4dd7-4018-aac7-882e385cb137	<p><strong>blah blah</strong></p>
47	159	1	2021-08-06 23:05:17	2021-08-06 23:05:17	9eac3d50-389d-4e07-84eb-b80abb83a462	<p><strong>blah blah</strong></p>
48	159	2	2021-08-06 23:05:17	2021-08-06 23:05:17	4a9abc7e-6498-47a9-a064-d4ca60b94fc8	<p><strong>blah blah</strong></p>
49	169	1	2021-08-17 20:25:12	2021-08-17 20:25:12	41605f8f-a420-456a-a26a-41279867abc8	<p>blahbitty blah blah</p>
50	169	2	2021-08-17 20:25:12	2021-08-17 20:25:12	4f716409-19f5-40c4-b05e-187394952575	<p>blahbitty blah blah</p>
51	174	1	2021-08-17 20:25:35	2021-08-17 20:25:35	0b49e14e-65c0-4948-8f09-4148ee2b448f	<p><strong>blah blah</strong></p>
52	174	2	2021-08-17 20:25:35	2021-08-17 20:25:35	e6903038-2f9e-4f5f-85ff-abb5b3af21cf	<p><strong>blah blah</strong></p>
53	180	1	2021-08-17 20:28:35	2021-08-17 20:28:35	65256c8d-533e-490d-9eda-949d139a8dd1	<p><strong>blah blah</strong></p>
54	180	2	2021-08-17 20:28:35	2021-08-17 20:28:35	585002b4-07a1-450b-b069-4e437f307c5d	<p><strong>blah blah</strong></p>
55	184	1	2021-08-17 20:29:07	2021-08-17 20:29:07	b2263ca0-4ebd-415b-add2-a8a057368fd8	<p><strong>blah blah</strong></p>
56	184	2	2021-08-17 20:29:07	2021-08-17 20:29:07	bf6f1fdf-c5ec-47ff-ba6a-7d2c3dd2f4a3	<p><strong>blah blah</strong></p>
57	211	1	2021-08-20 21:56:58	2021-08-20 21:56:58	a03162b7-e962-46e2-99ba-800683c97095	<p><strong>blah blah</strong></p>
58	211	2	2021-08-20 21:56:58	2021-08-20 21:56:58	20be5ccb-cf63-4a4d-99ac-ab3a72be8a98	<p><strong>blah blah</strong></p>
59	230	1	2021-08-30 21:31:49	2021-08-30 21:31:49	52e128d7-024d-48ea-918a-2942a3db0f48	\N
60	230	2	2021-08-30 21:31:49	2021-08-30 21:31:49	0d4efdae-60d0-45a4-bf4f-02801d6403f9	\N
61	231	1	2021-08-30 21:31:51	2021-08-30 21:31:51	c19d9681-fead-46f8-8368-fd060319570a	<p>Hip hip!</p>
62	231	2	2021-08-30 21:31:51	2021-08-30 21:31:51	d9e07deb-c39d-4a5f-95fb-4350c79aff82	<p>Hip hip!</p>
31	96	1	2021-07-16 18:43:41	2021-10-08 23:07:33	6364de4e-1c79-4f05-b785-8bea138a8c71	<p><strong>blah blah</strong></p>
32	96	2	2021-07-16 18:43:41	2021-10-08 23:07:33	4e0f9cd7-1fa8-4c74-b6b9-9eebed66d1c4	<p><strong>blah blah</strong></p>
63	232	1	2021-08-30 21:31:54	2021-10-08 23:08:16	6c58957a-c0a0-408c-8f56-6bdf6651183f	<p><strong>Hip hip!</strong></p>
64	232	2	2021-08-30 21:31:54	2021-10-08 23:08:16	dc125c49-368b-4882-a64a-3cbb80cb266c	<p><strong>Hip hip!</strong></p>
65	244	1	2021-08-30 21:32:35	2021-08-30 21:32:35	c5208330-5d19-4115-a193-67ec3676b04e	<p><strong>Hip hip!</strong></p>
66	244	2	2021-08-30 21:32:35	2021-08-30 21:32:35	6b8f2a9d-e304-41a8-87f5-a2c850dcfad2	<p><strong>Hip hip!</strong></p>
69	252	1	2021-09-08 17:50:58	2021-09-08 17:50:58	deb79ca1-04f6-4312-bdaa-a0a40f36ae72	<p><strong>blah blah</strong></p>
70	252	2	2021-09-08 17:50:58	2021-09-08 17:50:58	82a2931c-37b6-4fae-a81a-0f7373f44a3c	<p><strong>blah blah</strong></p>
109	421	1	2021-10-08 23:07:34	2021-10-08 23:07:34	b92c713c-7003-423d-bbad-5eb295059079	<p><strong>blah blah</strong></p>
110	421	2	2021-10-08 23:07:34	2021-10-08 23:07:34	1cabb208-4a7c-42a8-8477-61150c6131b8	<p><strong>blah blah</strong></p>
73	260	1	2021-09-08 17:54:32	2021-09-08 17:54:32	bdd34bd1-23b8-4a7f-833c-3f9f23a6355f	<p>blahbitty blah blah</p>
74	260	2	2021-09-08 17:54:32	2021-09-08 17:54:32	c2a8bb06-19cd-4736-bc78-14f93c5889b2	<p>blahbitty blah blah</p>
77	268	1	2021-09-08 17:54:52	2021-09-08 17:54:52	f9a371db-951f-47bb-994b-93bd74d65a06	<p><strong>Hip hip!</strong></p>
78	268	2	2021-09-08 17:54:52	2021-09-08 17:54:52	715a2566-4e71-407a-be8a-7e4daa6bfef2	<p><strong>Hip hip!</strong></p>
81	276	1	2021-09-08 17:55:09	2021-09-08 17:55:09	735d7327-3b7d-44fa-b4ae-26320b3b3e1e	<p><strong>Hip hip!</strong></p>
82	276	2	2021-09-08 17:55:09	2021-09-08 17:55:09	d795f109-ff59-48b0-b0a2-e140452cb05f	<p><strong>Hip hip!</strong></p>
83	281	1	2021-09-08 17:57:46	2021-09-08 17:57:46	2df0a79c-630b-4ed4-896a-f92542742162	\N
84	281	2	2021-09-08 17:57:46	2021-09-08 17:57:46	66bd5153-273e-4405-952c-0cc902c7a3c6	\N
85	282	1	2021-09-08 17:57:48	2021-09-08 17:57:48	e122944f-c489-4f6e-a70c-d31ab2b4aa48	<p>ho ha</p>
86	282	2	2021-09-08 17:57:48	2021-09-08 17:57:48	96c12525-44bd-4eb8-9212-2c5ad4cc5d10	<p>ho ha</p>
87	283	1	2021-09-08 17:57:50	2021-09-08 17:57:50	852675b6-5dad-48ee-9968-5c47dfcc7134	<p>hop ha</p>
88	283	2	2021-09-08 17:57:50	2021-09-08 17:57:50	83b6d98f-ba71-42ea-991e-fefa8f78bf0d	<p>hop ha</p>
89	284	1	2021-09-08 17:57:52	2021-09-08 17:57:52	c39dff76-8cd8-488f-bea2-299aece0df08	<p>hoo ha</p>
90	284	2	2021-09-08 17:57:52	2021-09-08 17:57:52	305664f2-173c-4eb7-8614-681b6e6a2e79	<p>hoo ha</p>
91	295	1	2021-09-08 17:58:58	2021-09-08 17:58:58	e5414b82-4435-42cb-9756-769387a6fe14	<p>hoo ha</p>
92	295	2	2021-09-08 17:58:58	2021-09-08 17:58:58	3a4b5ee3-a70e-4c40-9208-c2177400cbe5	<p>hoo ha</p>
93	299	1	2021-09-08 18:25:54	2021-09-08 18:25:54	7a93b8d4-28a4-4ae5-a209-a1ed48d2cfa6	\N
94	299	2	2021-09-08 18:25:54	2021-09-08 18:25:54	74d9c7ba-a0b5-468d-b8bc-dcb33c9a6f2e	\N
95	300	1	2021-09-08 18:25:56	2021-09-08 18:25:56	dc7df0dc-42b3-4fd4-8769-2f81593a4e75	<p>Cloud!</p>
96	300	2	2021-09-08 18:25:56	2021-09-08 18:25:56	d6a35ded-4c77-43bd-a2d8-efbece94553c	<p>Cloud!</p>
97	301	1	2021-09-08 18:25:58	2021-09-08 18:25:58	2eadcbb4-785b-4eb8-b1db-f1bceebf68a0	<p>Cl<strong>o</strong>ud!</p>
98	301	2	2021-09-08 18:25:58	2021-09-08 18:25:58	b58ef1cc-8949-473d-9538-8d2ef35794fa	<p>Cl<strong>o</strong>ud!</p>
101	312	1	2021-09-08 18:26:58	2021-09-08 18:26:58	4d44a6cc-f238-4aa2-a139-9a0295d0fb6c	<p>Cl<strong>o</strong>u<em>d</em>!</p>
102	312	2	2021-09-08 18:26:58	2021-09-08 18:26:58	0c6fbec2-c869-45da-a427-875293c0cf6c	<p>Cl<strong>o</strong>u<em>d</em>!</p>
113	430	1	2021-10-08 23:08:17	2021-10-08 23:08:17	68776bb1-4771-49c2-97b0-f8a6d42a41f4	<p><strong>Hip hip!</strong></p>
21	69	1	2021-06-22 21:51:07	2021-10-08 23:06:43	3ba9a9f5-09b7-4fa3-b7c8-13cd3d5796bd	<p>blahbitty blah blah</p>
22	69	2	2021-06-22 21:51:07	2021-10-08 23:06:43	83996f30-8ae1-4770-a3d4-3c2d0c62ca4c	<p>blahbitty blah blah</p>
105	413	1	2021-10-08 23:06:44	2021-10-08 23:06:44	a8cf4864-d835-4960-b662-8cb91499018d	<p>blahbitty blah blah</p>
106	413	2	2021-10-08 23:06:44	2021-10-08 23:06:44	1fff7a10-ea20-484e-a22f-cca16449ac3f	<p>blahbitty blah blah</p>
114	430	2	2021-10-08 23:08:17	2021-10-08 23:08:17	f3d6cf82-d013-454c-82ce-71d13498a255	<p><strong>Hip hip!</strong></p>
99	302	1	2021-09-08 18:26:00	2021-10-08 23:08:48	037e4c56-6d19-43d1-a3aa-81732a15419f	<p>Cl<strong>o</strong>u<em>d</em>!</p>
100	302	2	2021-09-08 18:26:00	2021-10-08 23:08:48	7beda9c6-c56e-4ade-a2a7-a5f46790b2f8	<p>Cl<strong>o</strong>u<em>d</em>!</p>
117	438	1	2021-10-08 23:08:49	2021-10-08 23:08:49	ca166c89-60c0-448b-aebf-a9551ed802f5	<p>Cl<strong>o</strong>u<em>d</em>!</p>
118	438	2	2021-10-08 23:08:49	2021-10-08 23:08:49	1167ba36-b955-4d3d-9873-de6aee15ef36	<p>Cl<strong>o</strong>u<em>d</em>!</p>
\.


--
-- TOC entry 4618 (class 0 OID 16711)
-- Dependencies: 256
-- Data for Name: matrixcontent_poiastroobject; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.matrixcontent_poiastroobject (id, "elementId", "siteId", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4620 (class 0 OID 16717)
-- Dependencies: 258
-- Data for Name: matrixcontent_tourpois; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.matrixcontent_tourpois (id, "elementId", "siteId", "dateCreated", "dateUpdated", uid, "field_tourPoi_description", "field_tourPoi_fov") FROM stdin;
3	77	1	2021-06-22 21:51:45	2021-06-22 21:51:45	a8597994-0b34-4b23-8fa0-4b3fc9fb53ed	<p>Who ha who ha</p>	\N
4	77	2	2021-06-22 21:51:45	2021-06-22 21:51:45	67834b16-5db5-4f5c-b8e5-46340dfa4da5	<p>Who ha who ha</p>	\N
5	90	1	2021-07-16 18:42:36	2021-07-16 18:42:36	0a210b99-7d43-42e2-9321-b3c731b9b2ce	\N	\N
6	90	2	2021-07-16 18:42:36	2021-07-16 18:42:36	beec783b-cfbd-46f8-9b8d-078a44c385bf	\N	\N
7	91	1	2021-07-16 18:42:41	2021-07-16 18:42:41	3c038448-e39c-4061-b421-07956f7c8d1a	<p>test test</p>	\N
8	91	2	2021-07-16 18:42:42	2021-07-16 18:42:42	e97777b7-290a-48e6-8f05-35fd9be0da32	<p>test test</p>	\N
13	102	1	2021-07-16 18:43:42	2021-07-16 18:43:42	64f524b5-4074-4de8-8861-79b6feeb61ea	<p>test test</p>	\N
14	102	2	2021-07-16 18:43:42	2021-07-16 18:43:42	63fb8f26-7e35-40e5-bb95-9417e784c711	<p>test test</p>	\N
15	107	1	2021-07-16 18:45:53	2021-07-16 18:45:53	cbd84f96-8801-4714-b061-d8919dcb8faa	<p>test test</p>	\N
16	107	2	2021-07-16 18:45:53	2021-07-16 18:45:53	9b9bd180-2fc9-4f8a-b32b-40cd9bea633e	<p>test test</p>	\N
40	237	2	2021-08-30 21:32:07	2021-08-30 21:32:07	58f61276-373a-445b-bda6-f7e6a8630d27	\N	20
41	238	1	2021-08-30 21:32:11	2021-08-30 21:32:11	31164a79-c3bf-49bc-ab91-515c1e42fc1e	<p>Eric Rosas</p>	20
17	111	1	2021-07-19 22:32:31	2021-07-19 22:32:31	b45a24b7-2933-429d-8e89-9eb54ede64bf	<p>Who ha who ha</p>	\N
18	111	2	2021-07-19 22:32:34	2021-07-19 22:32:34	40a32f48-2398-4ffd-a088-bb236facb7b8	<p>Who ha who ha</p>	\N
42	238	2	2021-08-30 21:32:11	2021-08-30 21:32:11	24ca451f-5ae6-4f12-bc8b-27e1e06f5e0f	<p>Eric Rosas</p>	20
19	144	1	2021-08-06 23:02:41	2021-08-06 23:02:41	e80c6fe7-d154-4e59-8b63-565f29bb1526	<p>Who ha who ha</p>	\N
20	144	2	2021-08-06 23:02:41	2021-08-06 23:02:41	4984eb2f-fcc5-453e-b40c-1035292c73d1	<p>Who ha who ha</p>	\N
45	246	1	2021-08-30 21:32:35	2021-08-30 21:32:35	535496bf-554b-49a6-a349-efd5968791b0	<p>Eric Rosas</p>	20
21	148	1	2021-08-06 23:02:51	2021-08-06 23:02:51	8d733ca4-b873-43ab-aab1-abde598b5494	<p>test test</p>	\N
22	148	2	2021-08-06 23:02:51	2021-08-06 23:02:51	0810a840-75eb-4daa-b3c5-edd1727db756	<p>test test</p>	\N
46	246	2	2021-08-30 21:32:35	2021-08-30 21:32:35	3f29449f-a5cf-467b-9872-9318dfb1b856	<p>Eric Rosas</p>	20
23	153	1	2021-08-06 23:04:32	2021-08-06 23:04:32	7e80e22c-aa13-4e49-aa9c-0a91d1cff5b3	<p>Who ha who ha</p>	\N
24	153	2	2021-08-06 23:04:32	2021-08-06 23:04:32	ea2af8f3-1381-43fe-819c-bcd692dca9b2	<p>Who ha who ha</p>	\N
11	98	1	2021-07-16 18:43:41	2021-10-08 23:07:33	e6792331-febd-4249-8a64-4f4f61e4c215	<p>test test</p>	\N
25	157	1	2021-08-06 23:04:44	2021-08-06 23:04:44	a6557758-bb17-4405-a7f9-ac7519ab41bb	<p>test test</p>	\N
26	157	2	2021-08-06 23:04:44	2021-08-06 23:04:44	cc10079f-a150-4a92-b16a-1a3301d4c549	<p>test test</p>	\N
12	98	2	2021-07-16 18:43:41	2021-10-08 23:07:33	8d650c5a-b05f-413e-b63e-1979f90f3a89	<p>test test</p>	\N
43	242	1	2021-08-30 21:32:33	2021-10-08 23:08:17	2951e874-14b3-4c80-a445-ba300a0ef595	<p>Eric Rosas</p>	20
27	161	1	2021-08-06 23:05:17	2021-08-06 23:05:17	01fe24f7-df63-4455-b203-53bccb892d87	<p>test test</p>	\N
28	161	2	2021-08-06 23:05:17	2021-08-06 23:05:17	79a043c7-b72c-437f-bf58-d629dbc0e4a4	<p>test test</p>	\N
58	270	2	2021-09-08 17:54:52	2021-09-08 17:54:52	ef86c5a9-b6bf-4dfb-96fb-24a761ad1a48	<p>Eric Rosas</p>	20
29	171	1	2021-08-17 20:25:12	2021-08-17 20:25:12	8dc6b967-7f99-498e-9304-db04b8b24e11	<p>Who ha who ha</p>	\N
30	171	2	2021-08-17 20:25:12	2021-08-17 20:25:12	4909dce1-511f-4760-ba8a-65d293d1a24c	<p>Who ha who ha</p>	\N
44	242	2	2021-08-30 21:32:33	2021-10-08 23:08:17	955ae8bd-399c-43d4-a9e2-89b8560e3029	<p>Eric Rosas</p>	20
49	254	1	2021-09-08 17:50:58	2021-09-08 17:50:58	a5f613f4-1aa5-4092-9278-27d28d1a772b	<p>test test</p>	\N
31	176	1	2021-08-17 20:25:35	2021-08-17 20:25:35	a76dd3c4-c78d-4951-be74-46668ce21293	<p>test test</p>	\N
32	176	2	2021-08-17 20:25:35	2021-08-17 20:25:35	a0ce24c7-b05e-43a0-8b7f-7357a2c8f335	<p>test test</p>	\N
50	254	2	2021-09-08 17:50:58	2021-09-08 17:50:58	d2680d8c-4790-49cf-b9e2-63ab95991a98	<p>test test</p>	\N
33	182	1	2021-08-17 20:28:35	2021-08-17 20:28:35	77f0f2a4-45ae-4368-9229-8e932b71b439	<p>test test</p>	\N
34	182	2	2021-08-17 20:28:35	2021-08-17 20:28:35	922986c7-1725-4e78-988b-78bf9dbe3058	<p>test test</p>	\N
35	186	1	2021-08-17 20:29:07	2021-08-17 20:29:07	d6bc9c03-a060-4b59-95fc-9797f070c9a4	<p>test test</p>	\N
36	186	2	2021-08-17 20:29:07	2021-08-17 20:29:07	e4fc6b6e-7e56-47d6-8956-e13bc79d90c1	<p>test test</p>	\N
53	262	1	2021-09-08 17:54:32	2021-09-08 17:54:32	1de6923b-db56-412e-9ae8-39408e50d0e9	<p>Who ha who ha</p>	\N
54	262	2	2021-09-08 17:54:32	2021-09-08 17:54:32	386ec8b2-4ae5-4941-ac06-b6eb10a2c0d3	<p>Who ha who ha</p>	\N
37	213	1	2021-08-20 21:56:58	2021-08-20 21:56:58	91ae211d-120c-495c-b50b-629c6bb7b9e3	<p>test test</p>	\N
38	213	2	2021-08-20 21:56:58	2021-08-20 21:56:58	2f1c990b-89a8-48e8-97e6-a4fd5f17b648	<p>test test</p>	\N
39	237	1	2021-08-30 21:32:07	2021-08-30 21:32:07	46a6ee3b-52d1-4b9d-891d-59ab96add709	\N	20
63	287	1	2021-09-08 17:58:14	2021-09-08 17:58:14	92b49d9c-8046-4d2a-99f8-28bb34b4bf1a	\N	20
64	287	2	2021-09-08 17:58:14	2021-09-08 17:58:14	355ca399-1c9a-4ceb-95c1-926c8b7863cd	\N	20
65	288	1	2021-09-08 17:58:17	2021-09-08 17:58:17	16b692bb-b8dc-4caf-81af-62e474b62683	<p>blah blajh</p>	20
57	270	1	2021-09-08 17:54:52	2021-09-08 17:54:52	673afaec-da8f-4d6c-b9b3-45b721e18049	<p>Eric Rosas</p>	20
61	278	1	2021-09-08 17:55:09	2021-09-08 17:55:09	cf9c3f1d-a7ef-47bb-a9bf-bf1a844e75c4	<p>Eric Rosas</p>	20
62	278	2	2021-09-08 17:55:09	2021-09-08 17:55:09	16933c84-7f3b-4b9a-9c20-1bbc5bac89aa	<p>Eric Rosas</p>	20
66	288	2	2021-09-08 17:58:17	2021-09-08 17:58:17	479ebae9-0c26-4ba0-b9bf-c137ab82c9d0	<p>blah blajh</p>	20
67	289	1	2021-09-08 17:58:18	2021-09-08 17:58:18	578fdaa6-554e-4987-aabc-47bdbd5d4644	<p>blah blah</p>	20
68	289	2	2021-09-08 17:58:18	2021-09-08 17:58:18	a5fdde9c-5ab8-4c95-9a76-3194b6e339e4	<p>blah blah</p>	20
69	293	1	2021-09-08 17:58:56	2021-09-08 17:58:56	da4b550d-cc2a-4cf2-90b8-4d6bc4a86b58	<p>blah blah</p>	20
70	293	2	2021-09-08 17:58:56	2021-09-08 17:58:56	70da67f9-89b8-4876-84d4-2e168e8fbbe6	<p>blah blah</p>	20
71	297	1	2021-09-08 17:58:58	2021-09-08 17:58:58	49f024b8-85fc-4b05-aa81-b1162cbb97cc	<p>blah blah</p>	20
72	297	2	2021-09-08 17:58:58	2021-09-08 17:58:58	efd6e058-ff50-42fb-bdfd-9032703a78ed	<p>blah blah</p>	20
73	306	1	2021-09-08 18:26:14	2021-09-08 18:26:14	cacbd4fd-3af9-479f-bff8-f247c1506c26	\N	20
74	306	2	2021-09-08 18:26:14	2021-09-08 18:26:14	6e63ec11-1a8e-4372-9be5-d0e23fb57e8a	\N	20
75	307	1	2021-09-08 18:26:17	2021-09-08 18:26:17	b7f2b00d-27c1-4868-ad0c-b8b9e9fd6d23	<p>Test</p>	20
76	307	2	2021-09-08 18:26:17	2021-09-08 18:26:17	ae36ade9-30f5-41e7-bf21-008f5f77d4af	<p>Test</p>	20
79	314	1	2021-09-08 18:26:58	2021-09-08 18:26:58	736ed42c-19f6-4e7f-8bf2-200e8ac65bbe	<p>Test</p>	20
80	314	2	2021-09-08 18:26:58	2021-09-08 18:26:58	643ea177-36a0-4967-b41d-cbe9e8fd4c50	<p>Test</p>	20
1	73	1	2021-06-22 21:51:45	2021-10-08 23:06:43	3624ccfb-d974-4bc9-986a-b9dc5563c568	<p>Who ha who ha</p>	\N
2	73	2	2021-06-22 21:51:45	2021-10-08 23:06:43	16df514f-71a8-4361-82c5-7f5942a0e7c5	<p>Who ha who ha</p>	\N
83	415	1	2021-10-08 23:06:44	2021-10-08 23:06:44	d14d4726-e195-4da7-bd6d-50ab1048f58a	<p>Who ha who ha</p>	\N
84	415	2	2021-10-08 23:06:44	2021-10-08 23:06:44	69385111-34ed-45d4-94cd-a6a198a58c63	<p>Who ha who ha</p>	\N
87	423	1	2021-10-08 23:07:34	2021-10-08 23:07:34	e27a11df-6353-45de-9770-21ac4ffe3a9e	<p>test test</p>	\N
88	423	2	2021-10-08 23:07:34	2021-10-08 23:07:34	932e0b2a-347f-47f6-9562-79d535fdfb4c	<p>test test</p>	\N
91	432	1	2021-10-08 23:08:17	2021-10-08 23:08:17	bc6395fc-4d68-4958-9f4f-a08f5d9af67a	<p>Eric Rosas</p>	20
92	432	2	2021-10-08 23:08:17	2021-10-08 23:08:17	b4e2a0db-2aab-4d26-bd41-f289038784ed	<p>Eric Rosas</p>	20
77	310	1	2021-09-08 18:26:56	2021-10-08 23:08:49	85aed684-3645-4158-9fc0-306257b77980	<p>Test</p>	20
78	310	2	2021-09-08 18:26:56	2021-10-08 23:08:49	48f4218e-776e-4041-bf59-4fd4a7c7afa7	<p>Test</p>	20
95	440	1	2021-10-08 23:08:49	2021-10-08 23:08:49	4097f506-5823-4b16-bf8e-a519db53ed0c	<p>Test</p>	20
96	440	2	2021-10-08 23:08:50	2021-10-08 23:08:50	142ef8f0-a378-4f49-a41d-9b54fb830481	<p>Test</p>	20
\.


--
-- TOC entry 4622 (class 0 OID 16726)
-- Dependencies: 260
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
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
185	plugin:redactor	m180430_204710_remove_old_plugins	2021-06-21 22:25:29	2021-06-21 22:25:29	2021-06-21 22:25:29	e6e697b0-aa18-45e5-bfa0-963c79c8da4c
186	plugin:redactor	Install	2021-06-21 22:25:29	2021-06-21 22:25:29	2021-06-21 22:25:29	571ccbee-c05a-473f-94ab-727fbe0c3513
187	plugin:redactor	m190225_003922_split_cleanup_html_settings	2021-06-21 22:25:29	2021-06-21 22:25:29	2021-06-21 22:25:29	e07ad510-fc86-40a1-9c71-a71f669b4332
190	craft	m210302_212318_canonical_elements	2021-08-30 21:28:53	2021-08-30 21:28:53	2021-08-30 21:28:53	b797ba7f-c205-45c6-8c22-844722b799d1
191	craft	m210329_214847_field_column_suffixes	2021-08-30 21:28:53	2021-08-30 21:28:53	2021-08-30 21:28:53	9634e372-8438-4dc4-818d-883b511aa597
192	craft	m210405_231315_provisional_drafts	2021-08-30 21:28:53	2021-08-30 21:28:53	2021-08-30 21:28:53	783a95bb-35c3-424e-813d-c7ac3ad58223
193	craft	m210602_111300_project_config_names_in_config	2021-08-30 21:28:53	2021-08-30 21:28:53	2021-08-30 21:28:53	a046a045-2e21-4fb5-9276-834eeb197a9e
194	craft	m210611_233510_default_placement_settings	2021-08-30 21:28:53	2021-08-30 21:28:53	2021-08-30 21:28:53	c156730e-a12e-4532-92f1-7f05a45530c0
195	craft	m210613_145522_sortable_global_sets	2021-08-30 21:28:53	2021-08-30 21:28:53	2021-08-30 21:28:53	8b234847-3dd3-4c5f-8303-1caab5ed65f6
196	craft	m210613_184103_announcements	2021-08-30 21:28:53	2021-08-30 21:28:53	2021-08-30 21:28:53	e1347d0b-e724-483e-a809-079a65f33372
199	craft	m210829_000000_element_index_tweak	2021-10-20 22:12:09	2021-10-20 22:12:09	2021-10-20 22:12:09	a694f640-2e84-4897-8829-2ec9d9324ea9
200	plugin:google-cloud	Install	2021-10-22 19:45:26	2021-10-22 19:45:26	2021-10-22 19:45:26	c44b74bc-ecb4-4ba4-8c42-d36b49452f29
201	plugin:google-cloud	m200529_110000_cleanup_expires_config	2021-10-22 19:45:28	2021-10-22 19:45:28	2021-10-22 19:45:28	8a9f2610-ba1e-42bd-b4e5-569c05897e93
\.


--
-- TOC entry 4624 (class 0 OID 16735)
-- Dependencies: 262
-- Data for Name: plugins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.plugins (id, handle, version, "schemaVersion", "licenseKeyStatus", "licensedEdition", "installDate", "dateCreated", "dateUpdated", uid) FROM stdin;
4	logs	3.0.4	3.0.0	unknown	\N	2021-09-08 19:59:58	2021-09-08 19:59:58	2021-10-27 22:10:06	0f75a2c1-4429-4100-b50c-ae246a557d40
7	nested-entries-graphql-queries	dev-develop	1.0.0	unknown	\N	2021-10-20 22:10:56	2021-10-20 22:10:56	2021-10-27 22:10:06	ef140772-43a6-4140-bc85-2dc23c8edbe4
1	redactor	2.8.8	2.3.0	unknown	\N	2021-06-21 22:25:29	2021-06-21 22:25:29	2021-10-27 22:10:06	1f823e62-7517-4ad7-8689-03ea02dee47a
8	google-cloud	1.4.1	1.1	unknown	\N	2021-10-22 19:45:24	2021-10-22 19:45:24	2021-10-27 22:10:05	4c7c2a3c-a63c-437a-acc5-5743190792fe
\.


--
-- TOC entry 4626 (class 0 OID 16746)
-- Dependencies: 264
-- Data for Name: projectconfig; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.projectconfig (path, value) FROM stdin;
fieldGroups.7d09d2f0-5c11-4a45-a805-a6d39128319e.name	"Common"
siteGroups.c1f0a2ee-3b87-486c-96ed-7e2d25fc952f.name	"Skyviewer API"
system.edition	"pro"
system.live	true
system.name	"Skyviewer API"
system.timeZone	"America/Los_Angeles"
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.0.fieldUid	"45720ab9-15e3-4cdc-8103-9c0495d2c1d2"
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.0.instructions	null
email.fromEmail	"erosas@lsst.org"
email.fromName	"Skyviewer API"
email.transportType	"craft\\\\mail\\\\transportadapters\\\\Sendmail"
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.0.label	null
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.0.required	false
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.0.tip	null
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\CustomField"
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.0.warning	null
fieldGroups.a3b0cf34-24af-41fe-8047-b1e5b65d5bd0.name	"Catalog"
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.0.width	100
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.1.fieldUid	"d2cd37c9-0e8a-4bbb-aff0-13584d58279b"
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.1.instructions	null
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.1.label	null
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.1.required	false
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.1.tip	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.field	"8fd439fe-660f-4cac-8ddf-b71b8ad6276f"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.0.fieldUid	"fe1835fb-8bd0-4e5a-b637-0e94330568ac"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.0.instructions	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.0.label	null
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.1.warning	null
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.elements.1.width	100
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.name	"Metadata"
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.fieldLayouts.3aff80ee-9ac7-4a11-8a1b-ed7f358711b6.tabs.0.sortOrder	1
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.handle	"siteInfo"
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.name	"Site Info"
globalSets.ea689411-d03e-48f0-8841-3318c457eee1.sortOrder	1
meta.__names__.0ecf9feb-ab77-470b-a2de-eb396a3a4682	"Survey"
meta.__names__.1f5ddbcd-4f3f-495c-95d9-dcd6af9e3f6f	"Astro Object"
meta.__names__.2c43566d-87e9-47af-b1e3-87577b58f06f	"Variety"
meta.__names__.02e3155f-23cf-4f36-a734-a3f447d04e85	"Surveys"
meta.__names__.3c645133-6daf-4632-a842-13662885ad1b	"Background Image"
meta.__names__.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d	"astroObject"
meta.__names__.4accd3e5-dd7d-4464-9f19-db2009adda71	"Globals"
meta.__names__.4b8d140e-8cb8-489e-9a89-0c30c4717e30	"Tour Theme"
meta.__names__.04fc1a9d-6240-4e69-ad81-2e02190a7e8d	"Fun Facts Content Blocks"
meta.__names__.5ef8f422-6773-4891-99b9-f56cdb8bced4	"Alternate Text"
meta.__names__.5fefc9c3-999f-4d02-988d-5a1738812936	"Variety Name"
meta.__names__.6ae58874-f4e1-4216-82c0-7af4094fdc0c	"Subheading"
meta.__names__.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5	"Site Image"
meta.__names__.6f7c799f-429a-486c-bde4-a5bd5ece3a78	"Body"
meta.__names__.7d09d2f0-5c11-4a45-a805-a6d39128319e	"Common"
meta.__names__.7e00543c-2735-49a3-96f0-d39d5d7333fe	"Icon"
meta.__names__.7f01b564-7d49-4139-be9d-07d369fd3408	"Thumbnail Image"
meta.__names__.8a653768-6c25-44d4-815e-182cd324b043	"Ra"
meta.__names__.008cb5a3-a777-476f-8410-4f2bf13ac492	"Intro Content Blocks"
meta.__names__.8d6803f5-ca34-46d8-a8d5-869896e34b65	"Tour"
meta.__names__.8fd439fe-660f-4cac-8ddf-b71b8ad6276f	"Tour POIs"
meta.__names__.9d2a5fce-1549-4e9f-8205-f1527f5064b2	"Catalog"
meta.__names__.9d28ee9c-bac6-404e-a24f-afde8a75ad1b	"Point of Interest"
meta.__names__.16b1feef-a5aa-449f-b011-919a9d6075ed	"Astro Object"
meta.__names__.18a685a4-2ce7-4ae8-b717-0154cff390c1	"Fun Facts Heading"
meta.__names__.25d2c2a6-169a-461c-b67d-54294c7d22d7	"Object Id"
meta.__names__.32b433c2-8fa2-439b-9678-d48e4f929b88	"Catalogs"
meta.__names__.36cb7208-d072-48ac-af5e-c034035afdfd	"Variety Handle"
meta.__names__.48d995fe-6d24-48f6-904a-c54f64964387	"Intro Content Block"
meta.__names__.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9	"Tour"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.isPublic	true
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.name	"Public Schema"
graphql.publicToken.enabled	true
graphql.publicToken.expiryDate	null
plugins.redactor.enabled	true
plugins.redactor.schemaVersion	"2.3.0"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.enableVersioning	true
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.handle	"astroObjects"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.name	"Astro Object"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.previewTargets.0.__assoc__.0.0	"label"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.previewTargets.0.__assoc__.0.1	"Primary entry page"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.previewTargets.0.__assoc__.1.0	"urlFormat"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.previewTargets.0.__assoc__.1.1	"{url}"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.previewTargets.0.__assoc__.2.0	"refresh"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.previewTargets.0.__assoc__.2.1	"1"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.propagationMethod	"all"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.enabledByDefault	true
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.hasUrls	true
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.template	null
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.uriFormat	"astro-object/{slug}"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.enabledByDefault	true
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.hasUrls	true
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.template	null
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.uriFormat	"astro-object/{slug}"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.structure.maxLevels	null
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.structure.uid	"84555b8e-d323-4457-8ba6-645d9ec367fc"
sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d.type	"structure"
meta.__names__.62b4e157-411a-433c-bdc0-dcd42a2d7ca4	"Points of Interest"
meta.__names__.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c	"poiAstroObject"
meta.__names__.84e9fa1d-8aed-40e1-a0e9-cb13152ea782	"Astro Object"
meta.__names__.85d34514-ec13-4850-a272-a3ab1bc790ef	"Icons"
meta.__names__.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62	"Duration"
meta.__names__.763c0189-f6eb-419c-9ca2-2574a743768a	"EN"
meta.__names__.774bddd7-f968-4015-957b-e33bc6dd5a7c	"Admins"
meta.__names__.860a3a7b-7ed5-4997-9a40-0d00e58b77d0	"Astro Images"
meta.__names__.31806af1-7467-49ea-9638-01ecf1c546cd	"Intro Subheading"
meta.__names__.40780a9f-1ee7-4c59-aaaf-159094330220	"Tour Theme"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.autocapitalize	true
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.autocomplete	false
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.autocorrect	true
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.class	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.disabled	false
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.id	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.instructions	null
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.name	"Surveys"
meta.__names__.45720ab9-15e3-4cdc-8103-9c0495d2c1d2	"Site Title"
meta.__names__.82510efa-cd7e-4f64-bfaa-1da05df2f53a	"Source Size"
meta.__names__.455216e8-f949-4521-911f-d50895102cd4	"Field of Vision (FOV) Maximum Value"
meta.__names__.0732995e-10da-4be7-944b-51b1135d12eb	"Field of Vision (FOV) Minimum Value"
meta.__names__.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4	"Description"
meta.__names__.8944198c-ff53-4323-ad48-976efeb3f56e	"Facts Content Block"
meta.__names__.99900237-7b20-49d9-ae09-b70c06489be7	"Heading"
meta.__names__.a0521bda-0df4-4937-9d6e-1534dfb98b58	"Field of Vision (FOV) Initial Value"
meta.__names__.a3b0cf34-24af-41fe-8047-b1e5b65d5bd0	"Catalog"
meta.__names__.a6b28fea-2f0c-49a2-b82c-fd16c51d9511	"ES"
meta.__names__.a8b34826-6a25-4e0a-b5dc-7e9820257899	"Tour POI"
meta.__names__.a469a047-d19a-421e-97f8-c58f1bda27d7	"Tour Images"
meta.__names__.a715351e-d465-4446-81f8-c9a15b3d1298	"Intro Heading"
meta.__names__.aa3e2ce5-e67a-4378-8a44-c660690cbcc3	"Tour Variety"
meta.__names__.b3f50442-f90e-42e6-986e-b2426abedaca	"Target"
meta.__names__.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	"Tours"
meta.__names__.b67e6d47-49f6-4385-85c7-ada70ffcf67e	"POI Astro Object"
meta.__names__.bae3d86b-064a-47c2-9af4-736639f79b7b	"Survey"
meta.__names__.c1f0a2ee-3b87-486c-96ed-7e2d25fc952f	"Skyviewer API"
meta.__names__.c8a76131-a217-46f6-9b2a-88d4f2a2f7de	"Dec"
meta.__names__.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3	"Body"
meta.__names__.cd879179-0c4d-47a3-90e9-61fdb3516cc4	"Image"
meta.__names__.d2cd37c9-0e8a-4bbb-aff0-13584d58279b	"Site Description"
meta.__names__.d4c658d8-0938-43f0-9ce0-0515d09ca162	"Complexity"
meta.__names__.d6f8219d-2a83-4ee6-967e-10720dec037b	"FOV"
meta.__names__.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0	"Variety"
meta.__names__.d250222b-10fd-487b-a94c-8c7aa5241cb3	"Public Schema"
meta.__names__.e2eb2e80-8e02-4a68-aa81-3d488f80543d	"Astro Object"
meta.__names__.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c	"Characteristics"
meta.__names__.e4521605-ff3a-4876-8c3c-cde0ffe5deaa	"Astro Objects"
meta.__names__.ea689411-d03e-48f0-8841-3318c457eee1	"Site Info"
meta.__names__.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377	"Path"
meta.__names__.fe74f2bf-6416-4c77-a05d-1ef924e575a8	"Image"
meta.__names__.fe1835fb-8bd0-4e5a-b637-0e94330568ac	"Description"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.contentColumnType	"string"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.handle	"image"
fieldGroups.0ecf9feb-ab77-470b-a2de-eb396a3a4682.name	"Survey"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.label	null
fields.99900237-7b20-49d9-ae09-b70c06489be7.contentColumnType	"text"
fields.99900237-7b20-49d9-ae09-b70c06489be7.fieldGroup	"7d09d2f0-5c11-4a45-a805-a6d39128319e"
fields.99900237-7b20-49d9-ae09-b70c06489be7.handle	"heading"
fields.99900237-7b20-49d9-ae09-b70c06489be7.instructions	""
fields.99900237-7b20-49d9-ae09-b70c06489be7.name	"Heading"
fields.99900237-7b20-49d9-ae09-b70c06489be7.searchable	false
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.instructions	""
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.name	"Image"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.searchable	true
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.translationKeyFormat	null
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.translationMethod	"site"
fields.99900237-7b20-49d9-ae09-b70c06489be7.settings.byteLimit	null
fields.99900237-7b20-49d9-ae09-b70c06489be7.settings.charLimit	null
fields.99900237-7b20-49d9-ae09-b70c06489be7.settings.code	""
fields.99900237-7b20-49d9-ae09-b70c06489be7.settings.columnType	null
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.type	"craft\\\\fields\\\\Assets"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.autocapitalize	true
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.autocomplete	false
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.autocorrect	true
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.class	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.disabled	false
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.id	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.instructions	""
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.label	""
fields.99900237-7b20-49d9-ae09-b70c06489be7.settings.initialRows	"4"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.max	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.min	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.name	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.orientation	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.placeholder	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.readonly	false
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.requirable	false
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.size	null
fields.99900237-7b20-49d9-ae09-b70c06489be7.settings.multiline	""
fields.99900237-7b20-49d9-ae09-b70c06489be7.settings.placeholder	null
fields.99900237-7b20-49d9-ae09-b70c06489be7.settings.uiMode	"normal"
fields.99900237-7b20-49d9-ae09-b70c06489be7.translationKeyFormat	null
fields.99900237-7b20-49d9-ae09-b70c06489be7.translationMethod	"none"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.step	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.tip	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.title	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\EntryTitleField"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.warning	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.0.width	100
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.1.fieldUid	"25d2c2a6-169a-461c-b67d-54294c7d22d7"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.1.instructions	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.1.label	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.1.required	false
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.1.tip	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.1.warning	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.1.width	100
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.2.fieldUid	"8a653768-6c25-44d4-815e-182cd324b043"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.2.instructions	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.2.label	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.2.required	false
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.2.tip	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.2.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.2.warning	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.2.width	100
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.3.fieldUid	"c8a76131-a217-46f6-9b2a-88d4f2a2f7de"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.3.instructions	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.3.label	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.3.required	false
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.max	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.min	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.name	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.orientation	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.placeholder	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.readonly	false
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.requirable	false
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.size	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.step	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.tip	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.title	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\EntryTitleField"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.warning	null
fields.99900237-7b20-49d9-ae09-b70c06489be7.type	"craft\\\\fields\\\\PlainText"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.0.width	100
fields.b3f50442-f90e-42e6-986e-b2426abedaca.contentColumnType	"text"
fields.b3f50442-f90e-42e6-986e-b2426abedaca.fieldGroup	"0ecf9feb-ab77-470b-a2de-eb396a3a4682"
fields.b3f50442-f90e-42e6-986e-b2426abedaca.handle	"target"
fields.b3f50442-f90e-42e6-986e-b2426abedaca.instructions	"The RA and DEC that the Skyviewer Explorer will focus on during page load, type RA first followed by a space and then DEC: <RA> <DEC>"
fields.b3f50442-f90e-42e6-986e-b2426abedaca.name	"Target"
fields.b3f50442-f90e-42e6-986e-b2426abedaca.searchable	false
fields.b3f50442-f90e-42e6-986e-b2426abedaca.settings.byteLimit	null
fields.b3f50442-f90e-42e6-986e-b2426abedaca.settings.charLimit	null
fields.b3f50442-f90e-42e6-986e-b2426abedaca.settings.code	""
fields.b3f50442-f90e-42e6-986e-b2426abedaca.settings.columnType	null
fields.b3f50442-f90e-42e6-986e-b2426abedaca.settings.initialRows	"4"
fields.b3f50442-f90e-42e6-986e-b2426abedaca.settings.multiline	""
fields.b3f50442-f90e-42e6-986e-b2426abedaca.settings.placeholder	"Ex: 267.0208333333 -24.7800000000"
fields.b3f50442-f90e-42e6-986e-b2426abedaca.settings.uiMode	"normal"
fields.b3f50442-f90e-42e6-986e-b2426abedaca.translationKeyFormat	null
fields.b3f50442-f90e-42e6-986e-b2426abedaca.translationMethod	"none"
fields.b3f50442-f90e-42e6-986e-b2426abedaca.type	"craft\\\\fields\\\\PlainText"
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.contentColumnType	"text"
fieldGroups.4accd3e5-dd7d-4464-9f19-db2009adda71.name	"Globals"
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.contentColumnType	"text"
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.fieldGroup	"4accd3e5-dd7d-4464-9f19-db2009adda71"
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.handle	"siteDescription"
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.instructions	""
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.name	"Site Description"
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.searchable	false
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.settings.byteLimit	null
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.settings.charLimit	null
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.settings.code	""
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.settings.columnType	null
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.settings.initialRows	"4"
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.settings.multiline	""
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.settings.placeholder	null
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.settings.uiMode	"normal"
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.translationKeyFormat	null
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.translationMethod	"site"
fields.d2cd37c9-0e8a-4bbb-aff0-13584d58279b.type	"craft\\\\fields\\\\PlainText"
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.contentColumnType	"string"
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.fieldGroup	"4accd3e5-dd7d-4464-9f19-db2009adda71"
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.handle	"siteImage"
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.instructions	""
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.name	"Site Image"
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.searchable	false
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.allowSelfRelations	false
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.allowUploads	true
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.allowedKinds	null
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.defaultUploadLocationSource	""
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.defaultUploadLocationSubpath	""
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.limit	"1"
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.localizeRelations	false
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.previewMode	"full"
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.restrictFiles	""
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.selectionLabel	""
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.showSiteMenu	false
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.showUnpermittedFiles	false
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.showUnpermittedVolumes	false
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.singleUploadLocationSource	""
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.singleUploadLocationSubpath	""
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.source	null
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.sources	"*"
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.targetSiteId	null
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.useSingleFolder	false
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.validateRelatedElements	false
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.settings.viewMode	"large"
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.translationKeyFormat	null
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.fieldGroup	"7d09d2f0-5c11-4a45-a805-a6d39128319e"
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.handle	"subheading"
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.instructions	""
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.name	"Subheading"
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.searchable	false
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.settings.byteLimit	null
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.settings.charLimit	null
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.settings.code	""
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.settings.columnType	null
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.settings.initialRows	"4"
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.settings.multiline	""
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.settings.placeholder	null
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.translationMethod	"site"
fields.6bca6d0b-7e18-41d5-a7c2-2c684e9af3a5.type	"craft\\\\fields\\\\Assets"
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.contentColumnType	"text"
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.fieldGroup	"4accd3e5-dd7d-4464-9f19-db2009adda71"
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.handle	"siteTitle"
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.instructions	""
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.name	"Site Title"
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.searchable	false
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.settings.byteLimit	null
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.settings.charLimit	null
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.settings.code	""
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.settings.columnType	null
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.settings.initialRows	"4"
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.settings.multiline	""
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.settings.placeholder	null
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.settings.uiMode	"normal"
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.translationKeyFormat	null
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.translationMethod	"site"
fields.45720ab9-15e3-4cdc-8103-9c0495d2c1d2.type	"craft\\\\fields\\\\PlainText"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.baseUrl	"$PRIMARY_SITE_URL"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.enabled	true
sites.763c0189-f6eb-419c-9ca2-2574a743768a.handle	"default"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.hasUrls	true
sites.763c0189-f6eb-419c-9ca2-2574a743768a.language	"en-US"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.name	"EN"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.primary	true
sites.763c0189-f6eb-419c-9ca2-2574a743768a.siteGroup	"c1f0a2ee-3b87-486c-96ed-7e2d25fc952f"
sites.763c0189-f6eb-419c-9ca2-2574a743768a.sortOrder	1
sites.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.baseUrl	"@web/es"
sites.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.enabled	true
sites.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.handle	"es"
sites.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.hasUrls	true
sites.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.language	"es-CL"
sites.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.name	"ES"
sites.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.primary	false
sites.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.siteGroup	"c1f0a2ee-3b87-486c-96ed-7e2d25fc952f"
sites.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.sortOrder	2
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.0.required	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.0.tip	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\CustomField"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.0.warning	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.0.width	100
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.3.tip	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.3.type	"craft\\\\fieldlayoutelements\\\\CustomField"
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.settings.uiMode	"normal"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.3.warning	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.3.width	100
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.name	"Content"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.sortOrder	1
fields.36cb7208-d072-48ac-af5e-c034035afdfd.contentColumnType	"text"
fields.36cb7208-d072-48ac-af5e-c034035afdfd.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.36cb7208-d072-48ac-af5e-c034035afdfd.handle	"varietyHandle"
fields.36cb7208-d072-48ac-af5e-c034035afdfd.instructions	""
fields.36cb7208-d072-48ac-af5e-c034035afdfd.name	"Variety Handle"
fields.36cb7208-d072-48ac-af5e-c034035afdfd.searchable	false
fields.36cb7208-d072-48ac-af5e-c034035afdfd.settings.byteLimit	null
fields.36cb7208-d072-48ac-af5e-c034035afdfd.settings.charLimit	null
fields.36cb7208-d072-48ac-af5e-c034035afdfd.settings.code	""
fields.36cb7208-d072-48ac-af5e-c034035afdfd.settings.columnType	null
fields.36cb7208-d072-48ac-af5e-c034035afdfd.settings.initialRows	"4"
fields.36cb7208-d072-48ac-af5e-c034035afdfd.settings.multiline	""
fields.36cb7208-d072-48ac-af5e-c034035afdfd.settings.placeholder	null
fields.36cb7208-d072-48ac-af5e-c034035afdfd.settings.uiMode	"normal"
fields.36cb7208-d072-48ac-af5e-c034035afdfd.translationKeyFormat	null
fields.36cb7208-d072-48ac-af5e-c034035afdfd.translationMethod	"none"
fields.36cb7208-d072-48ac-af5e-c034035afdfd.type	"craft\\\\fields\\\\PlainText"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.5.fieldUid	"e76c2c25-ca53-4f4c-bd93-a5af52ebb72c"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.5.instructions	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.5.label	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.5.required	false
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.5.tip	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.5.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.5.warning	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.5.width	100
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.name	"Content"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.sortOrder	1
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.handle	"astroObject"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.hasTitleField	true
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.translationKeyFormat	null
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.translationMethod	"none"
fields.6ae58874-f4e1-4216-82c0-7af4094fdc0c.type	"craft\\\\fields\\\\PlainText"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.1.warning	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.name	"Astro Object"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.section	"e2eb2e80-8e02-4a68-aa81-3d488f80543d"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.sortOrder	1
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.titleFormat	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.titleTranslationKeyFormat	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.titleTranslationMethod	"site"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.contentColumnType	"text"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.fieldGroup	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.handle	"description"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.instructions	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.name	"Description"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.searchable	true
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.1.width	100
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.2.fieldUid	"b3f50442-f90e-42e6-986e-b2426abedaca"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.2.instructions	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.2.label	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.2.required	false
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.2.tip	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.2.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.2.warning	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.2.width	100
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.3.fieldUid	"0732995e-10da-4be7-944b-51b1135d12eb"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.3.instructions	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.3.label	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.3.required	false
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.3.tip	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.3.type	"craft\\\\fieldlayoutelements\\\\CustomField"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.contentColumnType	"integer(10)"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.fieldGroup	"a3b0cf34-24af-41fe-8047-b1e5b65d5bd0"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.handle	"sourceSize"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.instructions	"Size of the marker icons"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.name	"Source Size"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.searchable	false
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.settings.decimals	0
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.settings.defaultValue	"20"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.settings.max	null
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.settings.min	"0"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.settings.prefix	null
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.settings.previewCurrency	""
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.settings.previewFormat	"none"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.settings.size	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.4.fieldUid	"fe74f2bf-6416-4c77-a05d-1ef924e575a8"
plugins.logs.edition	"standard"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.settings.suffix	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.3.warning	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.3.width	100
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.4.fieldUid	"455216e8-f949-4521-911f-d50895102cd4"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.4.instructions	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.4.label	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.4.required	false
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.4.tip	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.4.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.4.warning	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.4.width	100
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.5.fieldUid	"a0521bda-0df4-4937-9d6e-1534dfb98b58"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.translationKeyFormat	null
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.translationMethod	"none"
fields.82510efa-cd7e-4f64-bfaa-1da05df2f53a.type	"craft\\\\fields\\\\Number"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.availableTransforms	"*"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.availableVolumes	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.cleanupHtml	true
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.columnType	"text"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.configSelectionMode	"choose"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.defaultTransform	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.manualConfig	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.purifierConfig	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.purifyHtml	"1"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.redactorConfig	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.removeEmptyTags	"1"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.removeInlineStyles	"1"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.removeNbsp	"1"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.showHtmlButtonForNonAdmins	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.showUnpermittedFiles	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.showUnpermittedVolumes	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.settings.uiMode	"enlarged"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.translationKeyFormat	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.translationMethod	"site"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.fe1835fb-8bd0-4e5a-b637-0e94330568ac.type	"craft\\\\redactor\\\\Field"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.handle	"tourPoi"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.name	"Tour POI"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.sortOrder	1
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.4.instructions	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.4.label	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.4.required	false
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.4.tip	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.4.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.4.warning	null
entryTypes.16b1feef-a5aa-449f-b011-919a9d6075ed.fieldLayouts.1172933d-d14c-443e-a972-e0e3dae6d4f7.tabs.0.elements.4.width	100
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.0	"sections.e2eb2e80-8e02-4a68-aa81-3d488f80543d:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.1	"entrytypes.16b1feef-a5aa-449f-b011-919a9d6075ed:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.2	"sections.32b433c2-8fa2-439b-9678-d48e4f929b88:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.3	"entrytypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.4	"sections.02e3155f-23cf-4f36-a734-a3f447d04e85:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.5	"entrytypes.bae3d86b-064a-47c2-9af4-736639f79b7b:read"
plugins.logs.enabled	true
plugins.logs.schemaVersion	"3.0.0"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.6	"sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.7	"entrytypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.8	"volumes.a469a047-d19a-421e-97f8-c58f1bda27d7:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.9	"volumes.85d34514-ec13-4850-a272-a3ab1bc790ef:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.10	"volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.11	"globalsets.ea689411-d03e-48f0-8841-3318c457eee1:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.12	"categorygroups.40780a9f-1ee7-4c59-aaaf-159094330220:read"
graphql.schemas.d250222b-10fd-487b-a94c-8c7aa5241cb3.scope.13	"categorygroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3:read"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.allowSelfRelations	false
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.allowUploads	true
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.allowedKinds	null
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.defaultUploadLocationSource	"volume:77fd2a32-cdf7-4a77-8648-d79616eed462"
fields.455216e8-f949-4521-911f-d50895102cd4.contentColumnType	"integer(10)"
fields.455216e8-f949-4521-911f-d50895102cd4.fieldGroup	"0ecf9feb-ab77-470b-a2de-eb396a3a4682"
fields.455216e8-f949-4521-911f-d50895102cd4.handle	"fovMax"
fields.455216e8-f949-4521-911f-d50895102cd4.instructions	"An integer greater than 0 and also greater than the FOV min"
fields.455216e8-f949-4521-911f-d50895102cd4.name	"Field of Vision (FOV) Maximum Value"
fields.455216e8-f949-4521-911f-d50895102cd4.searchable	false
fields.455216e8-f949-4521-911f-d50895102cd4.settings.decimals	0
fields.455216e8-f949-4521-911f-d50895102cd4.settings.defaultValue	null
fields.455216e8-f949-4521-911f-d50895102cd4.settings.max	null
fields.455216e8-f949-4521-911f-d50895102cd4.settings.min	"0"
fields.455216e8-f949-4521-911f-d50895102cd4.settings.prefix	null
fields.455216e8-f949-4521-911f-d50895102cd4.settings.previewCurrency	""
fields.455216e8-f949-4521-911f-d50895102cd4.settings.previewFormat	"decimal"
fields.455216e8-f949-4521-911f-d50895102cd4.settings.size	null
fields.455216e8-f949-4521-911f-d50895102cd4.settings.suffix	null
fields.455216e8-f949-4521-911f-d50895102cd4.translationKeyFormat	null
fields.455216e8-f949-4521-911f-d50895102cd4.translationMethod	"none"
fields.455216e8-f949-4521-911f-d50895102cd4.type	"craft\\\\fields\\\\Number"
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.contentColumnType	"integer(10)"
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.handle	"duration"
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.instructions	"In minutes"
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.name	"Duration"
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.searchable	false
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.settings.decimals	0
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.settings.defaultValue	"5"
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.settings.max	null
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.settings.min	"0"
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.settings.prefix	null
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.settings.previewCurrency	""
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.settings.previewFormat	"decimal"
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.settings.size	null
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.settings.suffix	null
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.translationKeyFormat	null
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.translationMethod	"none"
fields.93cdcbba-f59d-41f1-ac65-5d9b0f83ef62.type	"craft\\\\fields\\\\Number"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.name	"Content"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.name	"Content"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.sortOrder	1
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.0.fieldUid	"a715351e-d465-4446-81f8-c9a15b3d1298"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.0.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.0.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.0.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.0.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.0.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.0.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.0.width	100
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.1.fieldUid	"31806af1-7467-49ea-9638-01ecf1c546cd"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.sortOrder	1
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.handle	"survey"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.hasTitleField	true
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.name	"Survey"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.section	"02e3155f-23cf-4f36-a734-a3f447d04e85"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.sortOrder	1
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.titleFormat	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.titleTranslationKeyFormat	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.titleTranslationMethod	"site"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.defaultUploadLocationSubpath	"/web/assets/astro-tours"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.limit	"1"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.localizeRelations	false
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.previewMode	"full"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.restrictFiles	""
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.selectionLabel	""
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.showSiteMenu	false
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.showUnpermittedFiles	false
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.showUnpermittedVolumes	false
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.singleUploadLocationSource	"volume:85d34514-ec13-4850-a272-a3ab1bc790ef"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.singleUploadLocationSubpath	""
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.source	null
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.sources	"*"
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.targetSiteId	null
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.useSingleFolder	false
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.validateRelatedElements	false
fields.cd879179-0c4d-47a3-90e9-61fdb3516cc4.settings.viewMode	"large"
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.contentColumnType	"text"
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.handle	"astroObjectId"
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.instructions	""
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.name	"Object Id"
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.searchable	false
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.1.fieldUid	"fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.1.instructions	""
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.1.label	""
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.1.required	"1"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.1.tip	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.5.instructions	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.5.label	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.5.required	false
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.5.tip	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.5.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.5.warning	null
entryTypes.bae3d86b-064a-47c2-9af4-736639f79b7b.fieldLayouts.a590a1dc-4372-4d00-9cf8-267c5e5e93f1.tabs.0.elements.5.width	100
fields.0732995e-10da-4be7-944b-51b1135d12eb.contentColumnType	"integer(10)"
fields.0732995e-10da-4be7-944b-51b1135d12eb.fieldGroup	"0ecf9feb-ab77-470b-a2de-eb396a3a4682"
fields.0732995e-10da-4be7-944b-51b1135d12eb.handle	"fovMin"
fields.0732995e-10da-4be7-944b-51b1135d12eb.instructions	"An integer greater than 0 and less than the FOV max value."
fields.0732995e-10da-4be7-944b-51b1135d12eb.name	"Field of Vision (FOV) Minimum Value"
fields.0732995e-10da-4be7-944b-51b1135d12eb.searchable	false
fields.0732995e-10da-4be7-944b-51b1135d12eb.settings.decimals	0
fields.0732995e-10da-4be7-944b-51b1135d12eb.settings.defaultValue	null
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.translationKeyFormat	null
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.translationMethod	"none"
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.type	"craft\\\\fields\\\\PlainText"
fields.0732995e-10da-4be7-944b-51b1135d12eb.settings.max	null
fields.0732995e-10da-4be7-944b-51b1135d12eb.settings.min	"0"
fields.0732995e-10da-4be7-944b-51b1135d12eb.settings.prefix	null
fields.0732995e-10da-4be7-944b-51b1135d12eb.settings.previewCurrency	""
fields.0732995e-10da-4be7-944b-51b1135d12eb.settings.previewFormat	"decimal"
fields.0732995e-10da-4be7-944b-51b1135d12eb.settings.size	null
fields.0732995e-10da-4be7-944b-51b1135d12eb.settings.suffix	null
fields.0732995e-10da-4be7-944b-51b1135d12eb.translationKeyFormat	null
fields.0732995e-10da-4be7-944b-51b1135d12eb.translationMethod	"none"
fields.0732995e-10da-4be7-944b-51b1135d12eb.type	"craft\\\\fields\\\\Number"
plugins.redactor.edition	"standard"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.autocapitalize	true
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.autocomplete	false
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.autocorrect	true
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.class	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.disabled	false
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.id	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.instructions	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.label	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.max	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.min	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.name	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.orientation	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.placeholder	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.readonly	false
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.requirable	false
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.size	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.step	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.tip	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.title	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\AssetTitleField"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.warning	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.0.width	100
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.1.fieldUid	"5ef8f422-6773-4891-99b9-f56cdb8bced4"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.1.instructions	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.1.label	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.1.required	false
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.1.tip	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.1.warning	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.elements.1.width	100
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.name	"Content"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.fieldLayouts.3bbfc7cd-6a6b-4534-bd52-9b7566850e2a.tabs.0.sortOrder	1
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.handle	"tourImages"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.hasUrls	true
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.name	"Tour Images"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.settings.bucket	"craft-test-erosas"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.settings.bucketSelectionMode	"choose"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.settings.expires	"5 minutes"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.settings.keyFileContents	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.2.fieldUid	"4a676166-cd4f-4c4e-a7ee-afca5c68fc2d"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.2.instructions	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.2.label	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.2.required	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.2.tip	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.2.type	"craft\\\\fieldlayoutelements\\\\CustomField"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.2.warning	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.2.width	100
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.settings.projectId	"$GCP_PROJECT_ID"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.settings.subfolder	"tours"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.sortOrder	0
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.titleTranslationKeyFormat	null
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.titleTranslationMethod	"site"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.type	"craft\\\\googlecloud\\\\Volume"
volumes.a469a047-d19a-421e-97f8-c58f1bda27d7.url	"$GCS_ASSET_BUCKET"
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.contentColumnType	"integer(10)"
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.fieldGroup	"7d09d2f0-5c11-4a45-a805-a6d39128319e"
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.handle	"fov"
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.instructions	"An integer indicating the initial Zoom level"
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.name	"Field of Vision (FOV) Initial Value"
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.searchable	false
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.settings.decimals	0
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.settings.defaultValue	null
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.settings.max	null
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.settings.min	"0"
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.settings.prefix	null
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.settings.previewCurrency	""
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.settings.previewFormat	"decimal"
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.settings.size	null
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.settings.suffix	null
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.translationKeyFormat	null
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.translationMethod	"none"
fields.a0521bda-0df4-4937-9d6e-1534dfb98b58.type	"craft\\\\fields\\\\Number"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.previewTargets.0.__assoc__.0.0	"label"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.previewTargets.0.__assoc__.0.1	"Primary entry page"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.previewTargets.0.__assoc__.1.0	"urlFormat"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.previewTargets.0.__assoc__.1.1	"{url}"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.previewTargets.0.__assoc__.2.0	"refresh"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.previewTargets.0.__assoc__.2.1	"1"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.propagationMethod	"all"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.enabledByDefault	true
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.hasUrls	true
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.template	null
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.uriFormat	"explorer/{slug}"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.enabledByDefault	true
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.hasUrls	true
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.settings.max	"5"
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.settings.min	"1"
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.settings.prefix	null
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.settings.previewCurrency	""
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.settings.previewFormat	"decimal"
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.settings.size	null
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.settings.suffix	null
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.translationKeyFormat	null
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.translationMethod	"none"
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.type	"craft\\\\fields\\\\Number"
fields.8a653768-6c25-44d4-815e-182cd324b043.contentColumnType	"integer(10)"
fields.8a653768-6c25-44d4-815e-182cd324b043.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.8a653768-6c25-44d4-815e-182cd324b043.handle	"ra"
fields.8a653768-6c25-44d4-815e-182cd324b043.instructions	"Right Acension"
fields.8a653768-6c25-44d4-815e-182cd324b043.name	"Ra"
fields.8a653768-6c25-44d4-815e-182cd324b043.searchable	false
fields.8a653768-6c25-44d4-815e-182cd324b043.settings.decimals	0
fields.8a653768-6c25-44d4-815e-182cd324b043.settings.defaultValue	null
fields.8a653768-6c25-44d4-815e-182cd324b043.settings.max	null
fields.8a653768-6c25-44d4-815e-182cd324b043.settings.min	"0"
fields.8a653768-6c25-44d4-815e-182cd324b043.settings.prefix	null
fields.8a653768-6c25-44d4-815e-182cd324b043.settings.previewCurrency	""
fields.8a653768-6c25-44d4-815e-182cd324b043.settings.previewFormat	"decimal"
fields.8a653768-6c25-44d4-815e-182cd324b043.settings.size	null
fields.8a653768-6c25-44d4-815e-182cd324b043.settings.suffix	null
fields.8a653768-6c25-44d4-815e-182cd324b043.translationKeyFormat	null
fields.8a653768-6c25-44d4-815e-182cd324b043.translationMethod	"none"
fields.8a653768-6c25-44d4-815e-182cd324b043.type	"craft\\\\fields\\\\Number"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.field	"008cb5a3-a777-476f-8410-4f2bf13ac492"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fieldLayouts.0fc0ae09-e999-401a-94f3-c849d44a6fc0.tabs.0.elements.0.fieldUid	"6f7c799f-429a-486c-bde4-a5bd5ece3a78"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fieldLayouts.0fc0ae09-e999-401a-94f3-c849d44a6fc0.tabs.0.elements.0.instructions	null
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fieldLayouts.0fc0ae09-e999-401a-94f3-c849d44a6fc0.tabs.0.elements.0.label	null
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fieldLayouts.0fc0ae09-e999-401a-94f3-c849d44a6fc0.tabs.0.elements.0.required	true
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fieldLayouts.0fc0ae09-e999-401a-94f3-c849d44a6fc0.tabs.0.elements.0.tip	null
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fieldLayouts.0fc0ae09-e999-401a-94f3-c849d44a6fc0.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\CustomField"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fieldLayouts.0fc0ae09-e999-401a-94f3-c849d44a6fc0.tabs.0.elements.0.warning	null
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fieldLayouts.0fc0ae09-e999-401a-94f3-c849d44a6fc0.tabs.0.elements.0.width	100
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fieldLayouts.0fc0ae09-e999-401a-94f3-c849d44a6fc0.tabs.0.name	"Content"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fieldLayouts.0fc0ae09-e999-401a-94f3-c849d44a6fc0.tabs.0.sortOrder	1
fieldGroups.8d6803f5-ca34-46d8-a8d5-869896e34b65.name	"Tour"
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.contentColumnType	"smallint(1)"
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.handle	"complexity"
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.instructions	"Between 1 - 5 where 1 - 2 is \\"Easy\\", 3 - 4 is \\"Medium\\", and 5 is \\"Hard\\""
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.name	"Complexity"
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.searchable	false
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.settings.decimals	0
fields.d4c658d8-0938-43f0-9ce0-0515d09ca162.settings.defaultValue	null
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.handle	"introBlock"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.name	"Intro Content Block"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.sortOrder	1
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.contentColumnType	"text"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.fieldGroup	null
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.handle	"body"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.instructions	""
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.name	"Body"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.searchable	true
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.availableTransforms	"*"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.availableVolumes	""
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.cleanupHtml	true
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.columnType	"text"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.configSelectionMode	"choose"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.defaultTransform	""
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.manualConfig	""
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.purifierConfig	""
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.purifyHtml	"1"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.redactorConfig	""
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.removeEmptyTags	"1"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.removeInlineStyles	"1"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.removeNbsp	"1"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.showHtmlButtonForNonAdmins	""
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.showUnpermittedFiles	false
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.showUnpermittedVolumes	false
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.settings.uiMode	"enlarged"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.translationKeyFormat	null
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.translationMethod	"site"
matrixBlockTypes.48d995fe-6d24-48f6-904a-c54f64964387.fields.6f7c799f-429a-486c-bde4-a5bd5ece3a78.type	"craft\\\\redactor\\\\Field"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.field	"04fc1a9d-6240-4e69-ad81-2e02190a7e8d"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fieldLayouts.01e3de18-5422-4982-8793-e0a34948e1d5.tabs.0.elements.0.fieldUid	"ccd123b4-00ff-4cdb-87e0-20be70c5f8f3"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fieldLayouts.01e3de18-5422-4982-8793-e0a34948e1d5.tabs.0.elements.0.instructions	null
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fieldLayouts.01e3de18-5422-4982-8793-e0a34948e1d5.tabs.0.elements.0.label	null
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fieldLayouts.01e3de18-5422-4982-8793-e0a34948e1d5.tabs.0.elements.0.required	false
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fieldLayouts.01e3de18-5422-4982-8793-e0a34948e1d5.tabs.0.elements.0.tip	null
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fieldLayouts.01e3de18-5422-4982-8793-e0a34948e1d5.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\CustomField"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fieldLayouts.01e3de18-5422-4982-8793-e0a34948e1d5.tabs.0.elements.0.warning	null
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fieldLayouts.01e3de18-5422-4982-8793-e0a34948e1d5.tabs.0.elements.0.width	100
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fieldLayouts.01e3de18-5422-4982-8793-e0a34948e1d5.tabs.0.name	"Content"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fieldLayouts.01e3de18-5422-4982-8793-e0a34948e1d5.tabs.0.sortOrder	1
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.handle	"factsContentBlock"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.name	"Facts Content Block"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.sortOrder	1
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.validateRelatedElements	false
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.contentColumnType	"text"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.fieldGroup	null
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.handle	"body"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.instructions	""
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.name	"Body"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.searchable	true
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.availableTransforms	"*"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.availableVolumes	""
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.cleanupHtml	true
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.columnType	"text"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.configSelectionMode	"choose"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.defaultTransform	""
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.manualConfig	""
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.purifierConfig	""
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.purifyHtml	"1"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.redactorConfig	""
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.removeEmptyTags	"1"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.removeInlineStyles	"1"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.removeNbsp	"1"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.showHtmlButtonForNonAdmins	""
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.showUnpermittedFiles	false
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.showUnpermittedVolumes	false
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.settings.uiMode	"enlarged"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.translationKeyFormat	null
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.translationMethod	"site"
matrixBlockTypes.8944198c-ff53-4323-ad48-976efeb3f56e.fields.ccd123b4-00ff-4cdb-87e0-20be70c5f8f3.type	"craft\\\\redactor\\\\Field"
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.contentColumnType	"string"
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.handle	"poiAstroObject"
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.instructions	""
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.name	"POI Astro Object"
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.searchable	true
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.settings.contentTable	"{{%matrixcontent_poiastroobject}}"
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.settings.maxBlocks	""
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.settings.minBlocks	""
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.settings.propagationMethod	"all"
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.translationKeyFormat	null
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.translationMethod	"site"
fields.b67e6d47-49f6-4385-85c7-ada70ffcf67e.type	"craft\\\\fields\\\\Matrix"
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.contentColumnType	"string"
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.handle	"tourPois"
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.instructions	""
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.name	"Tour POIs"
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.searchable	true
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.settings.contentTable	"{{%matrixcontent_tourpois}}"
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.settings.maxBlocks	""
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.settings.minBlocks	""
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.settings.propagationMethod	"all"
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.translationKeyFormat	null
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.translationMethod	"site"
fields.8fd439fe-660f-4cac-8ddf-b71b8ad6276f.type	"craft\\\\fields\\\\Matrix"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.1.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.1.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.1.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.1.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.1.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.1.width	100
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.2.fieldUid	"008cb5a3-a777-476f-8410-4f2bf13ac492"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.2.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.2.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.2.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.2.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.2.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.2.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.elements.2.width	100
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.name	"Intro"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.1.sortOrder	2
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.0.fieldUid	"18a685a4-2ce7-4ae8-b717-0154cff390c1"
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.contentColumnType	"string"
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.handle	"pois"
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.instructions	""
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.name	"Points of Interest"
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.searchable	true
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.settings.allowSelfRelations	false
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.settings.limit	""
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.settings.localizeRelations	false
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.settings.selectionLabel	""
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.settings.showSiteMenu	false
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.settings.source	null
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.settings.sources.0	"section:4a76eb6e-e209-42df-8ef6-43f1e5f7f745"
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.settings.targetSiteId	null
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.settings.validateRelatedElements	false
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.settings.viewMode	null
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.translationKeyFormat	null
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.translationMethod	"site"
fields.62b4e157-411a-433c-bdc0-dcd42a2d7ca4.type	"craft\\\\fields\\\\Entries"
fields.31806af1-7467-49ea-9638-01ecf1c546cd.contentColumnType	"text"
fields.31806af1-7467-49ea-9638-01ecf1c546cd.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.31806af1-7467-49ea-9638-01ecf1c546cd.handle	"introSubheading"
fields.31806af1-7467-49ea-9638-01ecf1c546cd.instructions	""
fields.31806af1-7467-49ea-9638-01ecf1c546cd.name	"Intro Subheading"
fields.31806af1-7467-49ea-9638-01ecf1c546cd.searchable	true
fields.31806af1-7467-49ea-9638-01ecf1c546cd.settings.byteLimit	null
fields.31806af1-7467-49ea-9638-01ecf1c546cd.settings.charLimit	null
fields.31806af1-7467-49ea-9638-01ecf1c546cd.settings.code	""
fields.31806af1-7467-49ea-9638-01ecf1c546cd.settings.columnType	null
fields.31806af1-7467-49ea-9638-01ecf1c546cd.settings.initialRows	"4"
fields.31806af1-7467-49ea-9638-01ecf1c546cd.settings.multiline	""
fields.31806af1-7467-49ea-9638-01ecf1c546cd.settings.placeholder	null
fields.31806af1-7467-49ea-9638-01ecf1c546cd.settings.uiMode	"normal"
fields.31806af1-7467-49ea-9638-01ecf1c546cd.translationKeyFormat	null
fields.31806af1-7467-49ea-9638-01ecf1c546cd.translationMethod	"site"
fields.31806af1-7467-49ea-9638-01ecf1c546cd.type	"craft\\\\fields\\\\PlainText"
fields.a715351e-d465-4446-81f8-c9a15b3d1298.contentColumnType	"text"
fields.a715351e-d465-4446-81f8-c9a15b3d1298.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.a715351e-d465-4446-81f8-c9a15b3d1298.handle	"introHeading"
fields.a715351e-d465-4446-81f8-c9a15b3d1298.instructions	""
fields.a715351e-d465-4446-81f8-c9a15b3d1298.name	"Intro Heading"
fields.a715351e-d465-4446-81f8-c9a15b3d1298.searchable	true
fields.a715351e-d465-4446-81f8-c9a15b3d1298.settings.byteLimit	null
fields.a715351e-d465-4446-81f8-c9a15b3d1298.settings.charLimit	null
fields.a715351e-d465-4446-81f8-c9a15b3d1298.settings.code	""
fields.a715351e-d465-4446-81f8-c9a15b3d1298.settings.columnType	null
fields.a715351e-d465-4446-81f8-c9a15b3d1298.settings.initialRows	"4"
fields.a715351e-d465-4446-81f8-c9a15b3d1298.settings.multiline	""
fields.a715351e-d465-4446-81f8-c9a15b3d1298.settings.placeholder	null
fields.a715351e-d465-4446-81f8-c9a15b3d1298.settings.uiMode	"normal"
fields.a715351e-d465-4446-81f8-c9a15b3d1298.translationKeyFormat	null
fields.a715351e-d465-4446-81f8-c9a15b3d1298.translationMethod	"site"
fields.a715351e-d465-4446-81f8-c9a15b3d1298.type	"craft\\\\fields\\\\PlainText"
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.contentColumnType	"string"
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.handle	"introContentBlocks"
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.instructions	""
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.name	"Intro Content Blocks"
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.searchable	true
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.settings.contentTable	"{{%matrixcontent_introcontentblocks}}"
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.settings.maxBlocks	""
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.settings.minBlocks	""
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.settings.propagationMethod	"all"
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.translationKeyFormat	null
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.translationMethod	"site"
fields.008cb5a3-a777-476f-8410-4f2bf13ac492.type	"craft\\\\fields\\\\Matrix"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.autocapitalize	true
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.autocomplete	false
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.autocorrect	true
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.class	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.disabled	false
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.id	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.instructions	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.label	null
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.contentColumnType	"text"
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.handle	"factsHeading"
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.instructions	""
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.name	"Fun Facts Heading"
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.searchable	true
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.settings.byteLimit	null
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.settings.charLimit	null
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.settings.code	""
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.settings.columnType	null
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.settings.initialRows	"4"
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.settings.multiline	""
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.max	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.min	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.name	null
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.settings.placeholder	"Fun Facts"
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.settings.uiMode	"normal"
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.translationKeyFormat	null
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.translationMethod	"site"
fields.18a685a4-2ce7-4ae8-b717-0154cff390c1.type	"craft\\\\fields\\\\PlainText"
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.contentColumnType	"string"
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.handle	"factsContentBlocks"
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.instructions	""
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.name	"Fun Facts Content Blocks"
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.searchable	true
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.settings.contentTable	"{{%matrixcontent_factscontentblocks}}"
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.settings.maxBlocks	""
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.settings.minBlocks	""
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.settings.propagationMethod	"all"
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.translationKeyFormat	null
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.translationMethod	"site"
fields.04fc1a9d-6240-4e69-ad81-2e02190a7e8d.type	"craft\\\\fields\\\\Matrix"
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.contentColumnType	"text"
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.handle	"description"
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.instructions	""
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.name	"Description"
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.searchable	true
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.settings.byteLimit	null
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.settings.charLimit	null
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.settings.code	""
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.settings.columnType	null
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.settings.initialRows	"4"
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.settings.multiline	"1"
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.settings.placeholder	null
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.settings.uiMode	"normal"
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.translationKeyFormat	null
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.translationMethod	"none"
fields.5244042f-c1bd-4262-8aa8-4cb92e5f2ea4.type	"craft\\\\fields\\\\PlainText"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.1.fieldUid	"d6f8219d-2a83-4ee6-967e-10720dec037b"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.1.instructions	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.1.label	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.1.required	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.1.tip	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.1.warning	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fieldLayouts.1b720c1b-b66f-4f5c-bd7d-a64b1bd32367.tabs.0.elements.1.width	100
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.orientation	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.placeholder	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.readonly	false
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.requirable	false
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.size	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.step	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.tip	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.title	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\AssetTitleField"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.warning	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.0.width	100
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.1.fieldUid	"5ef8f422-6773-4891-99b9-f56cdb8bced4"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.1.instructions	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.1.label	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.1.required	false
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.1.tip	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.1.warning	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.elements.1.width	100
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.name	"Content"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.fieldLayouts.9ad699b5-16f7-4d7f-a22c-2e886dd7970b.tabs.0.sortOrder	1
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.handle	"icons"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.hasUrls	true
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.name	"Icons"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.settings.bucket	"craft-test-erosas"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.settings.bucketSelectionMode	"choose"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.settings.expires	"5 minutes"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.settings.keyFileContents	""
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.settings.projectId	"$GCP_PROJECT_ID"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.settings.subfolder	"icons"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.sortOrder	0
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.titleTranslationKeyFormat	null
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.titleTranslationMethod	"site"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.type	"craft\\\\googlecloud\\\\Volume"
volumes.85d34514-ec13-4850-a272-a3ab1bc790ef.url	"$GCS_ASSET_BUCKET"
fields.3c645133-6daf-4632-a842-13662885ad1b.contentColumnType	"string"
fields.3c645133-6daf-4632-a842-13662885ad1b.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.3c645133-6daf-4632-a842-13662885ad1b.handle	"backgroundImage"
fields.3c645133-6daf-4632-a842-13662885ad1b.instructions	""
fields.3c645133-6daf-4632-a842-13662885ad1b.name	"Background Image"
fields.3c645133-6daf-4632-a842-13662885ad1b.searchable	true
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.autocapitalize	true
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.autocomplete	false
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.autocorrect	true
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.class	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.disabled	false
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.id	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.instructions	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.label	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.max	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.min	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.name	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.orientation	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.placeholder	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.readonly	false
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.requirable	false
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.size	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.step	null
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.enableVersioning	true
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.tip	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.title	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\AssetTitleField"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.warning	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.0.width	100
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.1.fieldUid	"5ef8f422-6773-4891-99b9-f56cdb8bced4"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.1.instructions	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.1.label	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.1.required	false
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.1.tip	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.1.warning	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.elements.1.width	100
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.name	"Content"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.fieldLayouts.f69d7e12-9845-48c1-8dd1-59b7d13fef81.tabs.0.sortOrder	1
fields.3c645133-6daf-4632-a842-13662885ad1b.translationKeyFormat	null
fields.3c645133-6daf-4632-a842-13662885ad1b.translationMethod	"site"
fields.3c645133-6daf-4632-a842-13662885ad1b.type	"craft\\\\fields\\\\Assets"
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.allowSelfRelations	false
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.allowUploads	true
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.allowedKinds	null
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.defaultUploadLocationSource	"volume:a469a047-d19a-421e-97f8-c58f1bda27d7"
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.defaultUploadLocationSubpath	""
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.limit	"1"
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.localizeRelations	false
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.previewMode	"thumbs"
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.restrictFiles	""
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.selectionLabel	""
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.showSiteMenu	false
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.showUnpermittedFiles	false
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.showUnpermittedVolumes	false
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.singleUploadLocationSource	"volume:85d34514-ec13-4850-a272-a3ab1bc790ef"
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.singleUploadLocationSubpath	""
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.source	null
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.sources	"*"
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.targetSiteId	null
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.useSingleFolder	false
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.validateRelatedElements	false
fields.3c645133-6daf-4632-a842-13662885ad1b.settings.viewMode	"large"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.handle	"astroImages"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.hasUrls	true
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.name	"Astro Images"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.settings.bucket	"craft-test-erosas"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.settings.bucketSelectionMode	"manual"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.settings.expires	"5 minutes"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.settings.keyFileContents	""
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.settings.projectId	"$GCP_PROJECT_ID"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.settings.subfolder	"astro"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.sortOrder	0
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.titleTranslationKeyFormat	null
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.titleTranslationMethod	"site"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.type	"craft\\\\googlecloud\\\\Volume"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.handle	"surveys"
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.contentColumnType	"string"
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.handle	"astroObjects"
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.instructions	""
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.name	"Astro Objects"
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.searchable	true
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.settings.allowSelfRelations	false
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.settings.limit	""
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.settings.localizeRelations	false
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.settings.selectionLabel	""
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.settings.showSiteMenu	false
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.enableVersioning	true
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.handle	"tours"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.name	"Tours"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.previewTargets.0.__assoc__.0.0	"label"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.previewTargets.0.__assoc__.0.1	"Primary entry page"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.previewTargets.0.__assoc__.1.0	"urlFormat"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.previewTargets.0.__assoc__.1.1	"{url}"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.previewTargets.0.__assoc__.2.0	"refresh"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.previewTargets.0.__assoc__.2.1	"1"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.propagationMethod	"all"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.enabledByDefault	true
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.hasUrls	true
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.template	null
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.uriFormat	"tour/{slug}"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.enabledByDefault	true
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.hasUrls	true
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.template	null
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.uriFormat	"tour/{slug}"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.structure.maxLevels	null
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.structure.uid	"2529bf86-1708-4969-b27e-0df6979598b4"
sections.b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f.type	"structure"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.template	null
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.uriFormat	"explorer/{slug}"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.structure.maxLevels	null
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.structure.uid	"505d6993-ce17-4b37-aa55-28a180963d52"
sections.02e3155f-23cf-4f36-a734-a3f447d04e85.type	"structure"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.enableVersioning	true
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.handle	"catalogs"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.name	"Catalogs"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.0.0	"label"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.0.1	"Primary entry page"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.1.0	"urlFormat"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.1.1	"{url}"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.2.0	"refresh"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.previewTargets.0.__assoc__.2.1	"1"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.propagationMethod	"all"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.enabledByDefault	true
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.hasUrls	true
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.template	null
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.uriFormat	"catalog/{slug}"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.enabledByDefault	true
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.hasUrls	true
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.template	null
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.uriFormat	"catalog/{slug}"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.structure.maxLevels	null
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.structure.uid	"ae4c1bfa-0825-4ccf-b090-4c79bed024bb"
sections.32b433c2-8fa2-439b-9678-d48e4f929b88.type	"structure"
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.contentColumnType	"integer(10)"
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.handle	"dec"
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.instructions	"Declination"
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.name	"Dec"
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.searchable	false
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.settings.decimals	0
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.settings.defaultValue	null
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.settings.max	null
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.settings.min	"0"
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.settings.prefix	null
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.settings.previewCurrency	""
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.settings.previewFormat	"decimal"
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.settings.size	null
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.settings.suffix	null
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.translationKeyFormat	null
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.translationMethod	"none"
fields.c8a76131-a217-46f6-9b2a-88d4f2a2f7de.type	"craft\\\\fields\\\\Number"
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.settings.source	null
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.settings.sources.0	"section:e2eb2e80-8e02-4a68-aa81-3d488f80543d"
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.settings.targetSiteId	null
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.settings.validateRelatedElements	false
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.settings.viewMode	null
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.translationKeyFormat	null
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.translationMethod	"site"
fields.e4521605-ff3a-4876-8c3c-cde0ffe5deaa.type	"craft\\\\fields\\\\Entries"
volumes.860a3a7b-7ed5-4997-9a40-0d00e58b77d0.url	"$GCS_ASSET_BUCKET"
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.settings.byteLimit	null
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.settings.charLimit	null
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.settings.code	""
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.settings.columnType	null
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.settings.initialRows	"4"
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.settings.multiline	""
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.settings.placeholder	null
fields.25d2c2a6-169a-461c-b67d-54294c7d22d7.settings.uiMode	"normal"
plugins.nested-entries-graphql-queries.edition	"standard"
plugins.nested-entries-graphql-queries.enabled	true
plugins.nested-entries-graphql-queries.schemaVersion	"1.0.0"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.field	"b67e6d47-49f6-4385-85c7-ada70ffcf67e"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fieldLayouts.ca79027c-e444-43f4-ac18-1a49f21083c6.tabs.0.elements.0.fieldUid	"84e9fa1d-8aed-40e1-a0e9-cb13152ea782"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fieldLayouts.ca79027c-e444-43f4-ac18-1a49f21083c6.tabs.0.elements.0.instructions	null
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fieldLayouts.ca79027c-e444-43f4-ac18-1a49f21083c6.tabs.0.elements.0.label	null
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fieldLayouts.ca79027c-e444-43f4-ac18-1a49f21083c6.tabs.0.elements.0.required	false
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fieldLayouts.ca79027c-e444-43f4-ac18-1a49f21083c6.tabs.0.elements.0.tip	null
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fieldLayouts.ca79027c-e444-43f4-ac18-1a49f21083c6.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\CustomField"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fieldLayouts.ca79027c-e444-43f4-ac18-1a49f21083c6.tabs.0.elements.0.warning	null
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fieldLayouts.ca79027c-e444-43f4-ac18-1a49f21083c6.tabs.0.elements.0.width	100
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fieldLayouts.ca79027c-e444-43f4-ac18-1a49f21083c6.tabs.0.name	"Content"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fieldLayouts.ca79027c-e444-43f4-ac18-1a49f21083c6.tabs.0.sortOrder	1
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.contentColumnType	"string"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.fieldGroup	null
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.handle	"astroObject"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.instructions	""
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.name	"Astro Object"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.searchable	true
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.settings.allowSelfRelations	false
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.settings.limit	"1"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.settings.localizeRelations	false
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.settings.selectionLabel	""
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.settings.showSiteMenu	false
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.settings.source	null
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.settings.sources.0	"section:e2eb2e80-8e02-4a68-aa81-3d488f80543d"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.settings.targetSiteId	null
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.settings.validateRelatedElements	false
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.viewMode	null
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.translationKeyFormat	null
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.translationMethod	"site"
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.type	"craft\\\\fields\\\\Categories"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.settings.viewMode	null
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.translationKeyFormat	null
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.translationMethod	"site"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.fields.84e9fa1d-8aed-40e1-a0e9-cb13152ea782.type	"craft\\\\fields\\\\Entries"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.handle	"poiAstroObject"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.name	"poiAstroObject"
matrixBlockTypes.82d2c4d7-37f1-458a-8a56-3cc1dcec6a0c.sortOrder	1
system.schemaVersion	"3.7.8"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.contentColumnType	"string"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.fieldGroup	"a3b0cf34-24af-41fe-8047-b1e5b65d5bd0"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.handle	"icon"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.instructions	"Icon for the marker on the UI"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.name	"Icon"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.searchable	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.0.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.0.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.0.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.0.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.0.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.0.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.0.width	100
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.translationKeyFormat	null
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.translationMethod	"site"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.type	"craft\\\\fields\\\\Assets"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.allowSelfRelations	false
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.allowUploads	true
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.allowedKinds	null
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.defaultUploadLocationSource	"volume:85d34514-ec13-4850-a272-a3ab1bc790ef"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.defaultUploadLocationSubpath	""
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.limit	"1"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.localizeRelations	false
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.previewMode	"thumbs"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.restrictFiles	""
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.selectionLabel	""
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.showSiteMenu	false
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.showUnpermittedFiles	false
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.showUnpermittedVolumes	false
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.singleUploadLocationSource	"volume:85d34514-ec13-4850-a272-a3ab1bc790ef"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.singleUploadLocationSubpath	""
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.source	null
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.sources	"*"
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.targetSiteId	null
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.useSingleFolder	false
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.validateRelatedElements	false
fields.7e00543c-2735-49a3-96f0-d39d5d7333fe.settings.viewMode	"large"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.contentColumnType	"string"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.handle	"thumbnail"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.instructions	""
fields.7f01b564-7d49-4139-be9d-07d369fd3408.name	"Thumbnail Image"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.searchable	true
dateModified	1634931928
plugins.google-cloud.edition	"standard"
plugins.google-cloud.enabled	true
fields.7f01b564-7d49-4139-be9d-07d369fd3408.translationKeyFormat	null
fields.7f01b564-7d49-4139-be9d-07d369fd3408.translationMethod	"site"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.type	"craft\\\\fields\\\\Assets"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.allowSelfRelations	false
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.allowUploads	true
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.allowedKinds	null
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.defaultUploadLocationSource	"volume:a469a047-d19a-421e-97f8-c58f1bda27d7"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.defaultUploadLocationSubpath	""
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.limit	""
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.localizeRelations	false
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.previewMode	"full"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.restrictFiles	""
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.selectionLabel	""
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.showSiteMenu	false
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.showUnpermittedFiles	false
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.showUnpermittedVolumes	false
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.singleUploadLocationSource	"volume:85d34514-ec13-4850-a272-a3ab1bc790ef"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.singleUploadLocationSubpath	""
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.source	null
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.sources	"*"
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.targetSiteId	null
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.useSingleFolder	false
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.validateRelatedElements	false
fields.7f01b564-7d49-4139-be9d-07d369fd3408.settings.viewMode	"list"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.contentColumnType	"text"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.handle	"characteristics"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.instructions	""
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.name	"Characteristics"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.searchable	true
plugins.google-cloud.schemaVersion	"1.1"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.translationKeyFormat	null
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.translationMethod	"none"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.type	"craft\\\\redactor\\\\Field"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.contentColumnType	"string(255)"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.fieldGroup	"7d09d2f0-5c11-4a45-a805-a6d39128319e"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.handle	"path"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.instructions	""
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.name	"Path"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.searchable	true
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.settings.maxLength	"255"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.settings.placeholder	null
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.settings.types.0	"url"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.translationKeyFormat	null
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.translationMethod	"none"
fields.fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377.type	"craft\\\\fields\\\\Url"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.contentColumnType	"string"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.fieldGroup	"a3b0cf34-24af-41fe-8047-b1e5b65d5bd0"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.handle	"catalogVariety"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.instructions	""
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.name	"Variety"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.searchable	true
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.optgroups	true
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.0.__assoc__.0.0	"label"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.0.__assoc__.0.1	"Stars"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.0.__assoc__.1.0	"value"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.0.__assoc__.1.1	"star"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.0.__assoc__.2.0	"default"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.0.__assoc__.2.1	""
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.1.__assoc__.0.0	"label"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.1.__assoc__.0.1	"Galaxies"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.1.__assoc__.1.0	"value"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.1.__assoc__.1.1	"galaxy"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.1.__assoc__.2.0	"default"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.1.__assoc__.2.1	""
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.2.__assoc__.0.0	"label"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.2.__assoc__.0.1	"Nebulas"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.2.__assoc__.1.0	"value"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.2.__assoc__.1.1	"nebula"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.2.__assoc__.2.0	"default"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.2.__assoc__.2.1	""
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.3.__assoc__.0.0	"label"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.3.__assoc__.0.1	"Transients"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.3.__assoc__.1.0	"value"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.3.__assoc__.1.1	"transient"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.3.__assoc__.2.0	"default"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.3.__assoc__.2.1	""
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.4.__assoc__.0.0	"label"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.4.__assoc__.0.1	"Goals"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.4.__assoc__.1.0	"value"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.4.__assoc__.1.1	"goal"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.4.__assoc__.2.0	"default"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.4.__assoc__.2.1	""
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.5.__assoc__.0.0	"label"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.5.__assoc__.0.1	"Landmarks"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.5.__assoc__.1.0	"value"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.5.__assoc__.1.1	"landmark"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.5.__assoc__.2.0	"default"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.settings.options.5.__assoc__.2.1	""
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.translationKeyFormat	null
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.translationMethod	"none"
fields.d7e99ce5-1dc7-4bac-94c6-91f86a5882e0.type	"craft\\\\fields\\\\Dropdown"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.1.fieldUid	"04fc1a9d-6240-4e69-ad81-2e02190a7e8d"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.1.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.1.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.1.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.1.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.1.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.elements.1.width	100
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.name	"Facts"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.2.sortOrder	3
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.3.elements.0.fieldUid	"8fd439fe-660f-4cac-8ddf-b71b8ad6276f"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.3.elements.0.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.3.elements.0.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.3.elements.0.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.3.elements.0.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.3.elements.0.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.3.elements.0.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.3.elements.0.width	100
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.3.name	"POI"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.3.sortOrder	4
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.handle	"tour"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.hasTitleField	true
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.name	"Tour"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.section	"b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.sortOrder	1
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.titleFormat	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.titleTranslationKeyFormat	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.titleTranslationMethod	"site"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.2.fieldUid	"4b8d140e-8cb8-489e-9a89-0c30c4717e30"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.2.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.2.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.2.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.2.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.2.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.2.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.2.width	100
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.contentColumnType	"string"
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.fieldGroup	"7d09d2f0-5c11-4a45-a805-a6d39128319e"
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.handle	"astroImage"
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.instructions	""
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.name	"Image"
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.searchable	false
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.allowSelfRelations	false
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.allowUploads	true
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.allowedKinds	null
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.defaultUploadLocationSource	"volume:860a3a7b-7ed5-4997-9a40-0d00e58b77d0"
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.defaultUploadLocationSubpath	""
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
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.limit	""
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.name	"Content"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.sortOrder	1
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.handle	"catalog"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.hasTitleField	true
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.name	"Catalog"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.section	"32b433c2-8fa2-439b-9678-d48e4f929b88"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.sortOrder	1
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.titleFormat	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.titleTranslationKeyFormat	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.titleTranslationMethod	"site"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.fieldUid	"7e00543c-2735-49a3-96f0-d39d5d7333fe"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.instructions	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.label	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.required	false
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.tip	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.warning	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.2.width	100
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.fieldUid	"fe3ef1fd-33fa-4aeb-9ed2-9e74f6694377"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.instructions	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.label	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.required	false
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.tip	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.warning	null
entryTypes.9d2a5fce-1549-4e9f-8205-f1527f5064b2.fieldLayouts.ab781cc4-81d9-4138-958a-fd7a2609cbda.tabs.0.elements.1.width	100
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.3.fieldUid	"93cdcbba-f59d-41f1-ac65-5d9b0f83ef62"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.3.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.3.label	null
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.localizeRelations	false
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.previewMode	"full"
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.restrictFiles	""
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.selectionLabel	""
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.showSiteMenu	false
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.showUnpermittedFiles	false
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.showUnpermittedVolumes	false
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.singleUploadLocationSource	"volume:85d34514-ec13-4850-a272-a3ab1bc790ef"
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.singleUploadLocationSubpath	""
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.source	null
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.sources.0	"volume:860a3a7b-7ed5-4997-9a40-0d00e58b77d0"
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.targetSiteId	null
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.useSingleFolder	false
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.validateRelatedElements	false
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.settings.viewMode	"list"
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.translationKeyFormat	null
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.translationMethod	"site"
fields.fe74f2bf-6416-4c77-a05d-1ef924e575a8.type	"craft\\\\fields\\\\Assets"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.autocapitalize	true
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.autocomplete	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.autocorrect	true
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.class	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.contentColumnType	"integer(10)"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.fieldGroup	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.handle	"fov"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.instructions	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.name	"FOV"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.searchable	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.settings.decimals	0
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.settings.defaultValue	"20"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.settings.max	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.settings.min	"0"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.settings.prefix	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.settings.previewCurrency	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.settings.previewFormat	"decimal"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.settings.size	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.settings.suffix	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.translationKeyFormat	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.translationMethod	"none"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.d6f8219d-2a83-4ee6-967e-10720dec037b.type	"craft\\\\fields\\\\Number"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.contentColumnType	"string"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.fieldGroup	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.handle	"astroObject"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.instructions	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.name	"astroObject"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.searchable	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.settings.allowSelfRelations	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.settings.limit	"1"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.settings.localizeRelations	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.settings.selectionLabel	""
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.settings.showSiteMenu	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.settings.source	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.settings.sources.0	"section:e2eb2e80-8e02-4a68-aa81-3d488f80543d"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.settings.targetSiteId	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.settings.validateRelatedElements	false
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.settings.viewMode	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.translationKeyFormat	null
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.translationMethod	"site"
matrixBlockTypes.a8b34826-6a25-4e0a-b5dc-7e9820257899.fields.4a676166-cd4f-4c4e-a7ee-afca5c68fc2d.type	"craft\\\\fields\\\\Entries"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.disabled	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.id	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.max	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.min	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.name	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.orientation	null
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.translationKeyFormat	null
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.availableTransforms	"*"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.availableVolumes	"*"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.cleanupHtml	true
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.columnType	"text"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.configSelectionMode	"choose"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.defaultTransform	""
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.manualConfig	""
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.purifierConfig	""
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.purifyHtml	"1"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.redactorConfig	""
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.removeEmptyTags	"1"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.removeInlineStyles	"1"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.removeNbsp	"1"
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.showHtmlButtonForNonAdmins	""
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.showUnpermittedFiles	false
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.showUnpermittedVolumes	false
fields.e76c2c25-ca53-4f4c-bd93-a5af52ebb72c.settings.uiMode	"enlarged"
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.translationMethod	"site"
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.type	"craft\\\\fields\\\\Categories"
fields.5fefc9c3-999f-4d02-988d-5a1738812936.contentColumnType	"text"
fields.5fefc9c3-999f-4d02-988d-5a1738812936.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.5fefc9c3-999f-4d02-988d-5a1738812936.handle	"varietyName"
fields.5fefc9c3-999f-4d02-988d-5a1738812936.instructions	""
fields.5fefc9c3-999f-4d02-988d-5a1738812936.name	"Variety Name"
fields.5fefc9c3-999f-4d02-988d-5a1738812936.searchable	false
fields.5fefc9c3-999f-4d02-988d-5a1738812936.settings.byteLimit	null
fields.5fefc9c3-999f-4d02-988d-5a1738812936.settings.charLimit	null
fields.5fefc9c3-999f-4d02-988d-5a1738812936.settings.code	""
fields.5fefc9c3-999f-4d02-988d-5a1738812936.settings.columnType	null
fields.5fefc9c3-999f-4d02-988d-5a1738812936.settings.initialRows	"4"
fields.5fefc9c3-999f-4d02-988d-5a1738812936.settings.multiline	""
fields.5fefc9c3-999f-4d02-988d-5a1738812936.settings.placeholder	null
fields.5fefc9c3-999f-4d02-988d-5a1738812936.settings.uiMode	"normal"
fields.5fefc9c3-999f-4d02-988d-5a1738812936.translationKeyFormat	null
fields.5fefc9c3-999f-4d02-988d-5a1738812936.translationMethod	"site"
fields.5fefc9c3-999f-4d02-988d-5a1738812936.type	"craft\\\\fields\\\\PlainText"
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.contentColumnType	"text"
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.fieldGroup	"7d09d2f0-5c11-4a45-a805-a6d39128319e"
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.handle	"altText"
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.instructions	""
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.name	"Alternate Text"
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.searchable	false
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.settings.byteLimit	null
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.settings.charLimit	null
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.settings.code	""
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.settings.columnType	null
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.settings.initialRows	"4"
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.settings.multiline	""
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.settings.placeholder	null
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.settings.uiMode	"normal"
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.translationKeyFormat	null
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.translationMethod	"site"
fields.5ef8f422-6773-4891-99b9-f56cdb8bced4.type	"craft\\\\fields\\\\PlainText"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.placeholder	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.readonly	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.requirable	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.size	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.step	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.title	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\EntryTitleField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.0.width	100
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.1.fieldUid	"2c43566d-87e9-47af-b1e3-87577b58f06f"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.1.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.1.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.1.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.1.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.1.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.1.width	100
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.3.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.3.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.3.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.3.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.3.width	100
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.4.fieldUid	"d4c658d8-0938-43f0-9ce0-0515d09ca162"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.4.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.4.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.4.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.4.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.4.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.4.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.4.width	100
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.5.fieldUid	"7f01b564-7d49-4139-be9d-07d369fd3408"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.5.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.5.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.5.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.5.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.5.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.5.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.5.width	100
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.contentColumnType	"string"
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.handle	"tourVariety"
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.instructions	""
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.name	"Variety"
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.searchable	true
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.structure.maxLevels	1
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.structure.uid	"729d74a0-ce22-4244-baeb-d1f7752c6877"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.autocapitalize	true
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.autocomplete	false
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.autocorrect	true
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.class	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.disabled	false
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.id	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.instructions	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.label	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.max	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.min	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.name	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.6.fieldUid	"3c645133-6daf-4632-a842-13662885ad1b"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.6.instructions	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.6.label	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.6.required	false
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.6.tip	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.6.type	"craft\\\\fieldlayoutelements\\\\CustomField"
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.6.warning	null
entryTypes.52d4af2b-ae9b-4f2f-a90b-5c4b5ce23eb9.fieldLayouts.05e3e818-d66c-4f2d-99ef-52fe1ee8904e.tabs.0.elements.6.width	100
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.allowLimit	false
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.allowMultipleSources	false
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.allowSelfRelations	false
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.branchLimit	"1"
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.limit	null
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.localizeRelations	false
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.selectionLabel	""
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.showSiteMenu	false
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.source	"group:aa3e2ce5-e67a-4378-8a44-c660690cbcc3"
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.sources	"*"
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.targetSiteId	null
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.validateRelatedElements	false
fields.2c43566d-87e9-47af-b1e3-87577b58f06f.settings.viewMode	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.autocapitalize	true
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.autocomplete	false
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.autocorrect	true
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.class	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.disabled	false
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.id	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.instructions	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.label	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.max	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.min	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.name	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.orientation	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.placeholder	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.readonly	false
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.requirable	false
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.size	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.step	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.tip	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.title	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\TitleField"
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.warning	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.elements.0.width	100
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.name	"Content"
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.fieldLayouts.80e1cd37-ef90-4e3b-817f-776176d2d5b2.tabs.0.sortOrder	1
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.handle	"tourTheme"
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.name	"Tour Theme"
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.hasUrls	true
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.template	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.uriFormat	"tour-theme/{slug}"
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.hasUrls	true
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.template	null
categoryGroups.40780a9f-1ee7-4c59-aaaf-159094330220.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.uriFormat	"tour-theme/{slug}"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.orientation	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.placeholder	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.readonly	false
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.requirable	false
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.size	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.step	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.tip	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.title	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.type	"craft\\\\fieldlayoutelements\\\\TitleField"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.warning	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.0.width	100
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.1.fieldUid	"36cb7208-d072-48ac-af5e-c034035afdfd"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.1.instructions	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.1.label	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.1.required	false
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.1.tip	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.1.type	"craft\\\\fieldlayoutelements\\\\CustomField"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.1.warning	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.1.width	100
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.2.fieldUid	"7f01b564-7d49-4139-be9d-07d369fd3408"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.2.instructions	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.2.label	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.2.required	false
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.2.tip	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.2.type	"craft\\\\fieldlayoutelements\\\\CustomField"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.2.warning	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.elements.2.width	100
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.name	"Content"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.fieldLayouts.1bd45809-7be7-4083-bdbc-bceb5876fdc8.tabs.0.sortOrder	1
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.handle	"tourVariety"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.name	"Tour Variety"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.hasUrls	true
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.template	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.siteSettings.763c0189-f6eb-419c-9ca2-2574a743768a.uriFormat	"tour-variety/{slug}"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.hasUrls	true
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.template	null
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.siteSettings.a6b28fea-2f0c-49a2-b82c-fd16c51d9511.uriFormat	"tour-variety/{slug}"
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.structure.maxLevels	1
categoryGroups.aa3e2ce5-e67a-4378-8a44-c660690cbcc3.structure.uid	"8df90f53-f24a-42e0-81aa-44869bab2bd1"
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.contentColumnType	"string"
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.fieldGroup	"8d6803f5-ca34-46d8-a8d5-869896e34b65"
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.handle	"tourTheme"
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.instructions	""
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.name	"Tour Theme"
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.searchable	true
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.allowLimit	false
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.allowMultipleSources	false
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.allowSelfRelations	false
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.branchLimit	"1"
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.limit	null
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.localizeRelations	false
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.selectionLabel	""
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.showSiteMenu	false
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.source	"group:40780a9f-1ee7-4c59-aaaf-159094330220"
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.sources	"*"
fields.4b8d140e-8cb8-489e-9a89-0c30c4717e30.settings.targetSiteId	null
\.


--
-- TOC entry 4627 (class 0 OID 16756)
-- Dependencies: 265
-- Data for Name: queue; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.queue (id, channel, job, description, "timePushed", ttr, delay, priority, "dateReserved", "timeUpdated", progress, "progressLabel", attempt, fail, "dateFailed", error) FROM stdin;
\.


--
-- TOC entry 4629 (class 0 OID 16769)
-- Dependencies: 267
-- Data for Name: relations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.relations (id, "fieldId", "sourceId", "sourceSiteId", "targetId", "sortOrder", "dateCreated", "dateUpdated", uid) FROM stdin;
2	8	18	\N	17	1	2021-06-15 17:23:28	2021-06-15 17:23:28	f4f0d5ad-aa2f-481b-91a9-752e4e9011af
4	8	20	\N	19	1	2021-06-15 17:23:49	2021-06-15 17:23:49	40b02347-e258-44fe-b93f-6febb98a2005
7	8	24	\N	22	1	2021-06-15 17:34:27	2021-06-15 17:34:27	9ac89b0d-47b5-4681-a453-0281cae81afe
10	8	28	\N	26	1	2021-06-15 17:51:12	2021-06-15 17:51:12	78c7dc91-f74c-4763-8323-bad2a1ceca49
13	8	32	\N	30	1	2021-06-15 17:54:45	2021-06-15 17:54:45	fed172f9-06b2-46b7-8c21-93d5525a85b8
16	8	36	\N	34	1	2021-06-15 17:58:33	2021-06-15 17:58:33	eaa0b356-0d99-4b71-974f-83defefbc609
21	26	65	\N	49	1	2021-06-21 23:15:44	2021-06-21 23:15:44	9b044d88-5a4d-45ae-b07b-104b134ea94b
22	26	66	\N	49	1	2021-06-21 23:15:44	2021-06-21 23:15:44	7a35124f-3376-4794-83ae-447113c5a338
28	29	67	\N	65	1	2021-06-21 23:15:49	2021-06-21 23:15:49	ef533997-926d-46da-b233-88a8959872f8
29	21	68	\N	49	1	2021-06-21 23:15:49	2021-06-21 23:15:49	d3f59f29-5b8f-4cb9-be55-053845a6a75e
30	22	68	\N	50	1	2021-06-21 23:15:49	2021-06-21 23:15:49	03aace8e-4e5b-43c8-870b-ab4a4f4cb7bd
33	29	68	\N	65	1	2021-06-21 23:15:49	2021-06-21 23:15:49	cc794948-beaa-4366-a790-15483442daae
34	21	70	\N	49	1	2021-06-22 21:51:08	2021-06-22 21:51:08	f24b9201-75f7-4695-9a28-ad0b14ebd5a8
35	22	70	\N	50	1	2021-06-22 21:51:08	2021-06-22 21:51:08	1f2b4233-8f05-465e-89ef-3915e8ac1d85
37	21	74	\N	49	1	2021-06-22 21:51:45	2021-06-22 21:51:45	2d225ac4-f57e-46b5-89a6-1e08008fe899
38	22	74	\N	50	1	2021-06-22 21:51:45	2021-06-22 21:51:45	0543fda1-86a0-44cf-acea-1178ca8962f4
41	8	82	\N	34	1	2021-07-16 17:53:05	2021-07-16 17:53:05	5cfa602c-fc17-4cf6-b4aa-a6cfcde0d4c5
42	8	83	\N	34	1	2021-07-16 17:53:05	2021-07-16 17:53:05	f3f9f8e0-7e99-4baa-a41a-ba866929a0dd
46	26	93	\N	50	1	2021-07-16 18:43:23	2021-07-16 18:43:23	78bac883-702c-41bb-89f4-af6bfb3c0613
51	21	99	\N	50	1	2021-07-16 18:43:41	2021-07-16 18:43:41	f70b5bc5-c808-41d3-bfe3-d0ce086a3a13
52	22	99	\N	49	1	2021-07-16 18:43:41	2021-07-16 18:43:41	62736b9e-3f6d-4bb5-9d9c-202c16e1f5fa
54	26	103	\N	50	1	2021-07-16 18:45:50	2021-07-16 18:45:50	6571908d-9d31-4806-824e-abe84dc12eeb
55	21	104	\N	50	1	2021-07-16 18:45:52	2021-07-16 18:45:52	cfaf427f-062a-4919-b329-7f18ce5952fb
56	22	104	\N	49	1	2021-07-16 18:45:52	2021-07-16 18:45:52	804a2862-965b-41cc-b6db-9a91cd53cc04
58	21	108	\N	49	1	2021-07-19 22:32:08	2021-07-19 22:32:08	4753e290-5215-4cc5-ae7f-e9760227578b
59	22	108	\N	50	1	2021-07-19 22:32:10	2021-07-19 22:32:10	dd1e1a49-d5eb-4f16-9c1b-edf8547f59b1
60	8	121	\N	17	1	2021-08-06 22:23:02	2021-08-06 22:23:02	411684a1-5772-43d2-9fb6-4be99fda394e
61	8	122	\N	19	1	2021-08-06 22:23:19	2021-08-06 22:23:19	790e7881-a76d-4cb9-bd53-ce916044d080
62	8	123	\N	17	1	2021-08-06 22:23:24	2021-08-06 22:23:24	9dfcf8be-1442-406c-ad9b-349a6ce2c4dc
63	8	124	\N	22	1	2021-08-06 22:23:40	2021-08-06 22:23:40	48193845-a1ef-4826-a660-d28dbf8ffdba
64	8	125	\N	26	1	2021-08-06 22:23:52	2021-08-06 22:23:52	4b9739f1-ff08-45a2-9646-b6072865abd8
65	8	126	\N	30	1	2021-08-06 22:24:07	2021-08-06 22:24:07	65621013-3e73-4648-8452-921e91bb9037
67	8	127	\N	117	1	2021-08-06 22:24:29	2021-08-06 22:24:29	5c13ef78-a7e1-48bf-ae6a-3206008c04da
68	8	128	\N	17	1	2021-08-06 22:25:32	2021-08-06 22:25:32	ea8ecf3a-de26-4abb-b241-cd8f8edccfcf
69	8	129	\N	19	1	2021-08-06 22:25:37	2021-08-06 22:25:37	b57d7840-192d-49d7-8179-8397917d98af
70	8	130	\N	22	1	2021-08-06 22:25:41	2021-08-06 22:25:41	3ab86322-4c7e-4472-8b85-afd6277ee4b2
71	8	131	\N	26	1	2021-08-06 22:25:45	2021-08-06 22:25:45	916db03f-b760-454b-a1d7-c4aba05345cc
73	8	132	\N	115	1	2021-08-06 22:25:54	2021-08-06 22:25:54	12aa8e22-c5c5-4c08-8a6c-5e6fc54e6adf
74	8	133	\N	115	1	2021-08-06 22:25:59	2021-08-06 22:25:59	190e1d85-18aa-4e1d-a9f8-916bb47deb34
75	8	134	\N	117	1	2021-08-06 22:26:07	2021-08-06 22:26:07	c3e9dc86-5cb3-48e2-9635-707c0297134b
77	21	138	\N	137	1	2021-08-06 22:54:56	2021-08-06 22:54:56	889a8ef5-71cd-4462-b14c-b14d705c56a9
78	21	139	\N	137	1	2021-08-06 22:54:56	2021-08-06 22:54:56	78250edb-02f1-4eec-b1b8-22c7b4e52dee
79	21	140	\N	137	1	2021-08-06 22:56:21	2021-08-06 22:56:21	b4b5f81c-b541-4585-ae25-d10cf09d17a0
81	30	141	\N	138	1	2021-08-06 23:02:41	2021-08-06 23:02:41	1921e950-7a3f-401e-8590-f2c66d566dc6
83	30	145	\N	138	1	2021-08-06 23:02:51	2021-08-06 23:02:51	f41c0442-d3b4-4fb0-a56a-37a2bd875c0a
84	21	149	\N	137	1	2021-08-06 23:03:19	2021-08-06 23:03:19	aaab5e4a-a3af-4fe2-bf92-3b63ae6cb009
87	30	150	\N	138	1	2021-08-06 23:04:32	2021-08-06 23:04:32	24b85673-b049-4d96-8e9b-6828e0e10fbc
88	21	150	\N	137	1	2021-08-06 23:04:32	2021-08-06 23:04:32	4a7a8e00-1893-4da1-bb9e-140df142d185
89	22	150	\N	137	1	2021-08-06 23:04:32	2021-08-06 23:04:32	6840466a-f4f5-4b33-a25e-bcca02f85811
92	30	154	\N	138	1	2021-08-06 23:04:44	2021-08-06 23:04:44	785cc286-c124-4514-8c08-bd279002d3ca
93	21	154	\N	137	1	2021-08-06 23:04:44	2021-08-06 23:04:44	b14a5c44-30a9-4e4c-acf7-e9e3652a8649
94	22	154	\N	137	1	2021-08-06 23:04:44	2021-08-06 23:04:44	0b398402-f6e3-4ead-8fdd-d6b7efcec9a5
95	49	98	\N	92	1	2021-08-06 23:05:17	2021-08-06 23:05:17	8493e0f1-96db-4331-af96-4391d87768e9
96	30	158	\N	138	1	2021-08-06 23:05:17	2021-08-06 23:05:17	35b2f2bd-d864-4a9f-87f8-69751547b402
97	21	158	\N	137	1	2021-08-06 23:05:17	2021-08-06 23:05:17	e91f49a0-f372-4867-b205-7e02fd1b45a0
98	22	158	\N	137	1	2021-08-06 23:05:17	2021-08-06 23:05:17	3aa941be-5219-4ac2-98fd-a7541bc0e43a
99	49	161	\N	92	1	2021-08-06 23:05:17	2021-08-06 23:05:17	18bbf72b-355c-4bc3-ba09-b68736c5125f
100	8	163	\N	19	1	2021-08-06 23:09:51	2021-08-06 23:09:51	0cc546cc-a795-4b54-93bf-930a0b0467cd
101	8	164	\N	22	1	2021-08-06 23:10:01	2021-08-06 23:10:01	ce65f6b9-2c69-4a87-919e-465579cf053e
102	8	165	\N	26	1	2021-08-06 23:10:10	2021-08-06 23:10:10	946c3359-9dd6-4deb-8209-e46f97820999
103	8	166	\N	115	1	2021-08-06 23:10:21	2021-08-06 23:10:21	454eec89-3cb3-4f78-8ef5-1e27df2df696
351	21	298	\N	424	1	2021-10-08 23:08:48	2021-10-08 23:08:48	5b18a9bb-377c-44ed-a444-2fa347e6e892
105	21	168	\N	137	1	2021-08-17 20:25:11	2021-08-17 20:25:11	809ca47f-e1a0-408c-bdbc-84fd0412164f
106	22	168	\N	167	1	2021-08-17 20:25:11	2021-08-17 20:25:11	f7855b92-3747-4380-9c81-a66a2ec90b35
352	22	298	\N	424	1	2021-10-08 23:08:48	2021-10-08 23:08:48	1443d3ba-a610-483e-a8d9-36c2aa924c6e
108	21	173	\N	137	1	2021-08-17 20:25:35	2021-08-17 20:25:35	4c746c7c-ae02-479e-8b33-fd6256482b49
109	22	173	\N	167	1	2021-08-17 20:25:35	2021-08-17 20:25:35	5de42616-ba03-42bf-9c0c-140334c4dfad
110	49	176	\N	92	1	2021-08-17 20:25:35	2021-08-17 20:25:35	403a0e13-b1ca-4db7-a8e0-07d2c729c94c
353	30	437	\N	177	1	2021-10-08 23:08:49	2021-10-08 23:08:49	114eb334-583b-4575-b14c-2a5e37d5b83e
112	30	95	\N	177	1	2021-08-17 20:28:34	2021-08-17 20:28:34	8714b8cc-5668-4f4d-b8c0-94a8795a0023
113	55	95	\N	178	1	2021-08-17 20:28:35	2021-08-17 20:28:35	df5cdf6a-63dd-499c-89f6-2babde2d438f
114	30	179	\N	177	1	2021-08-17 20:28:35	2021-08-17 20:28:35	26e3a6bc-b56c-4466-8fc4-6ce3070f450d
115	55	179	\N	178	1	2021-08-17 20:28:35	2021-08-17 20:28:35	50c2e1a3-ba9b-46b0-ac88-a043a6d6bf0c
116	21	179	\N	137	1	2021-08-17 20:28:35	2021-08-17 20:28:35	d56798c7-a830-48ec-83eb-05328a6fc817
117	22	179	\N	167	1	2021-08-17 20:28:35	2021-08-17 20:28:35	3dbaaee8-c41d-4f3f-999b-3004fb729e72
118	49	182	\N	92	1	2021-08-17 20:28:35	2021-08-17 20:28:35	d3751c08-9cd5-4746-ab7c-9962f57ff2fc
354	55	437	\N	178	1	2021-10-08 23:08:49	2021-10-08 23:08:49	5e728e5c-51bb-43f4-ad9a-70b6ef66dd1b
120	30	183	\N	177	1	2021-08-17 20:29:06	2021-08-17 20:29:06	a00d206a-ed6b-4436-ac9c-f3b878437b2d
121	55	183	\N	178	1	2021-08-17 20:29:06	2021-08-17 20:29:06	6d7a4363-db86-464a-8668-fc4947fa59c6
122	21	183	\N	167	1	2021-08-17 20:29:06	2021-08-17 20:29:06	071e7eba-4afc-4860-bb00-8b211513b2ab
123	22	183	\N	167	1	2021-08-17 20:29:06	2021-08-17 20:29:06	8ec06dd4-40de-4a8a-907b-ae6966214648
124	49	186	\N	92	1	2021-08-17 20:29:07	2021-08-17 20:29:07	53126c1c-3696-44f0-8156-dcf2c57b9a0e
125	8	188	\N	17	1	2021-08-17 20:35:45	2021-08-17 20:35:45	94dd13e2-adf6-4d03-acd9-325473f75c0c
126	8	190	\N	19	1	2021-08-17 20:36:03	2021-08-17 20:36:03	9ddded13-e5a4-42de-b147-c6a1474d84c6
127	8	192	\N	22	1	2021-08-17 20:36:18	2021-08-17 20:36:18	ffd57149-378b-4dc1-a001-e54c74fa4600
128	8	194	\N	26	1	2021-08-17 20:36:40	2021-08-17 20:36:40	0e97cddb-c3d7-4175-a295-a759a706be77
129	8	196	\N	115	1	2021-08-17 20:37:03	2021-08-17 20:37:03	36e1c09b-2ca2-4849-a295-2017fd5dda43
130	8	198	\N	117	1	2021-08-17 20:37:17	2021-08-17 20:37:17	0822c988-dd6b-484d-9d4a-04aaf0649533
131	26	92	\N	199	1	2021-08-17 20:41:24	2021-08-17 20:41:24	2eb75eab-089e-4b8d-80f7-0fd9a2961013
132	26	200	\N	199	1	2021-08-17 20:41:25	2021-08-17 20:41:25	53255fc5-fbc2-4007-9803-363aa3755c14
355	21	437	\N	424	1	2021-10-08 23:08:49	2021-10-08 23:08:49	cd93a19b-fcf2-48a4-ae2f-477c70ba498a
356	22	437	\N	424	1	2021-10-08 23:08:49	2021-10-08 23:08:49	e7816af7-d499-4f87-bc15-48b2eb203f5a
357	49	440	\N	308	1	2021-10-08 23:08:50	2021-10-08 23:08:50	35a114d5-0fb1-4d54-98c2-b87a02b73ea7
136	30	210	\N	177	1	2021-08-20 21:56:58	2021-08-20 21:56:58	63d9929e-b69a-454d-972c-1d95f88a607f
137	55	210	\N	178	1	2021-08-20 21:56:58	2021-08-20 21:56:58	adae6935-f0ba-4c3f-aac2-ac377f4e22fc
138	21	210	\N	204	1	2021-08-20 21:56:58	2021-08-20 21:56:58	b0846ca7-ad77-431d-843c-fbdb26f7834d
139	22	210	\N	204	1	2021-08-20 21:56:58	2021-08-20 21:56:58	7da7c5d6-2831-4822-870a-3be7774e0614
140	49	213	\N	92	1	2021-08-20 21:56:58	2021-08-20 21:56:58	b23718ef-df44-4e5a-9867-0f254e5bf30a
141	8	8	\N	215	1	2021-08-20 22:02:00	2021-08-20 22:02:00	24bfd9c7-8bc2-4e6d-a4c6-65d07c098fae
142	8	220	\N	215	1	2021-08-20 22:02:00	2021-08-20 22:02:00	4acac0ec-3cb8-4efa-9b50-9f02cee180d1
144	8	221	\N	219	1	2021-08-20 22:02:33	2021-08-20 22:02:33	d4741c4b-5f41-41cc-80d1-7fb30418d1c4
146	8	222	\N	217	1	2021-08-20 22:03:07	2021-08-20 22:03:07	8c177a14-789c-488b-be12-6bbabd57dddd
148	8	223	\N	214	1	2021-08-20 22:03:29	2021-08-20 22:03:29	95bf3173-68d3-473d-ab5c-4b4005064a60
150	8	224	\N	218	1	2021-08-20 22:04:11	2021-08-20 22:04:11	a1183f18-674c-4f69-843b-2e057c0d0319
152	8	225	\N	216	1	2021-08-20 22:04:39	2021-08-20 22:04:39	9c45658e-83b4-4ffc-b0fd-97e0869bbbe3
153	8	226	\N	218	1	2021-08-20 22:04:44	2021-08-20 22:04:44	a0784033-b9e0-4d2a-ad3b-99daa47fab44
159	56	241	\N	239	1	2021-08-30 21:32:31	2021-08-30 21:32:31	372a905e-216b-4fa7-831b-855cd9ce6e40
160	49	242	\N	240	1	2021-08-30 21:32:33	2021-08-30 21:32:33	8b770431-c40e-47eb-9b58-34f78d2243a1
161	30	243	\N	229	1	2021-08-30 21:32:35	2021-08-30 21:32:35	2ba464c7-c34f-4b94-a285-1cd9ea500761
162	21	243	\N	228	1	2021-08-30 21:32:35	2021-08-30 21:32:35	2d1aeeae-6331-4c5a-ad33-9ed10139af92
163	22	243	\N	228	1	2021-08-30 21:32:35	2021-08-30 21:32:35	867fd371-4783-4b2d-a85b-cba376298073
164	49	246	\N	240	1	2021-08-30 21:32:35	2021-08-30 21:32:35	71f21357-86ed-4e55-b375-28984dd65986
170	30	251	\N	177	1	2021-09-08 17:50:58	2021-09-08 17:50:58	67a1531a-dae4-4dd6-bd11-a5a0b8755046
171	55	251	\N	178	1	2021-09-08 17:50:58	2021-09-08 17:50:58	e52fec1b-5442-4bb9-8e3e-d95afd730711
172	21	251	\N	204	1	2021-09-08 17:50:58	2021-09-08 17:50:58	2e5ca456-f6f3-466a-b23e-df850248039f
173	22	251	\N	204	1	2021-09-08 17:50:58	2021-09-08 17:50:58	af99d05f-fa79-4f92-88e8-ef0d5c672769
174	49	254	\N	92	1	2021-09-08 17:50:58	2021-09-08 17:50:58	600e0fcd-5aa1-4a18-9739-81ec6653b97d
179	30	67	\N	177	1	2021-09-08 17:54:31	2021-09-08 17:54:31	0fbc6713-c37c-404f-add3-72fb0b486fbc
180	55	67	\N	178	1	2021-09-08 17:54:32	2021-09-08 17:54:32	117ec699-220a-47f7-9a51-3043ed391532
181	30	259	\N	177	1	2021-09-08 17:54:32	2021-09-08 17:54:32	361276ee-0d10-40f4-a5be-b9c2d12fc691
182	55	259	\N	178	1	2021-09-08 17:54:32	2021-09-08 17:54:32	2549f7be-a315-445b-a039-490f876ca589
183	21	259	\N	137	1	2021-09-08 17:54:32	2021-09-08 17:54:32	dc9c4530-2d46-4994-a0a7-d3a5d2754ecb
184	22	259	\N	167	1	2021-09-08 17:54:32	2021-09-08 17:54:32	85b447c1-a5f7-4605-bcd9-d86c37ffda22
190	55	227	\N	205	1	2021-09-08 17:54:51	2021-09-08 17:54:51	a3056f00-bd67-48ba-94f9-1ff68b484b27
191	30	267	\N	229	1	2021-09-08 17:54:52	2021-09-08 17:54:52	4f826335-577d-45d2-a945-f58f63c6099b
192	55	267	\N	205	1	2021-09-08 17:54:52	2021-09-08 17:54:52	207ff8d6-0f82-4cc7-be05-1e39c05e3052
193	21	267	\N	228	1	2021-09-08 17:54:52	2021-09-08 17:54:52	2512dda8-1430-4f12-b187-07b4b383302d
194	22	267	\N	228	1	2021-09-08 17:54:52	2021-09-08 17:54:52	62b8db54-fb45-47d9-ab24-23dfe6add940
195	49	270	\N	240	1	2021-09-08 17:54:52	2021-09-08 17:54:52	9663da31-2f6a-4edc-b355-2193e791d4f9
202	30	227	\N	177	1	2021-09-08 17:55:09	2021-09-08 17:55:09	9e7d9432-1f9e-481c-873d-8d2e2eb3fcd0
203	30	275	\N	177	1	2021-09-08 17:55:09	2021-09-08 17:55:09	3120e5fa-e883-42ea-8a9f-b918fdb9f697
204	55	275	\N	205	1	2021-09-08 17:55:09	2021-09-08 17:55:09	f1e4bf6b-064d-49bb-b6c7-376e80fbe899
205	21	275	\N	228	1	2021-09-08 17:55:09	2021-09-08 17:55:09	9752e2b8-7518-406c-b8ff-dcd980d9e9eb
206	22	275	\N	228	1	2021-09-08 17:55:09	2021-09-08 17:55:09	548d4946-01c6-4195-98a3-b8c1e623adfd
207	49	278	\N	240	1	2021-09-08 17:55:09	2021-09-08 17:55:09	21a6a3b2-3437-4656-aaba-16cdf0085c6d
208	30	279	\N	177	1	2021-09-08 17:55:47	2021-09-08 17:55:47	d9221a1b-a638-43bc-b62a-dcfacb3e3e4e
209	55	279	\N	205	1	2021-09-08 17:55:52	2021-09-08 17:55:52	55624c59-0062-4616-adcf-33517842cf40
210	21	279	\N	228	1	2021-09-08 17:57:33	2021-09-08 17:57:33	15c9db3b-fcb0-48a4-9be6-0af04e7af8d0
211	22	279	\N	228	1	2021-09-08 17:57:37	2021-09-08 17:57:37	5b4ed616-fbe7-454e-93b1-8bd2c022c312
213	56	292	\N	239	1	2021-09-08 17:58:54	2021-09-08 17:58:54	f6e1ed38-a21d-4ee5-8e17-a46330233148
214	49	293	\N	291	1	2021-09-08 17:58:56	2021-09-08 17:58:56	8e104443-0c80-4775-8482-f1b53dcbc33c
215	30	294	\N	177	1	2021-09-08 17:58:58	2021-09-08 17:58:58	8de10526-54dd-48b8-9e54-d0dd77999eab
216	55	294	\N	205	1	2021-09-08 17:58:58	2021-09-08 17:58:58	dd7f5a14-73af-4be2-bc2f-ee7048c73e94
217	21	294	\N	228	1	2021-09-08 17:58:58	2021-09-08 17:58:58	1aa8ab48-8c22-4b07-8456-8fe0e84ac872
218	22	294	\N	228	1	2021-09-08 17:58:58	2021-09-08 17:58:58	8fad5d65-0a71-409e-b677-ad7bc81ebdd5
219	49	297	\N	291	1	2021-09-08 17:58:58	2021-09-08 17:58:58	8623bd76-36cc-41d9-a4c6-1f01396e2bc3
220	30	298	\N	177	1	2021-09-08 18:25:26	2021-09-08 18:25:26	bfb058cd-cdf2-4195-ba21-151a34a3f1fd
221	55	298	\N	178	1	2021-09-08 18:25:31	2021-09-08 18:25:31	28e7d925-a0b4-4c8c-93c2-1b3dfaab33e4
225	56	309	\N	239	1	2021-09-08 18:26:41	2021-09-08 18:26:41	67a21fb7-f0ce-426a-bd2a-4f5261301809
226	49	310	\N	308	1	2021-09-08 18:26:56	2021-09-08 18:26:56	aed1d54a-939e-402b-b32e-a006d1f62182
227	30	311	\N	177	1	2021-09-08 18:26:58	2021-09-08 18:26:58	6f9e750c-708b-444e-a74b-96dc42ac1f0d
228	55	311	\N	178	1	2021-09-08 18:26:58	2021-09-08 18:26:58	4c3f16fa-0c55-4dcc-847b-f5f83dfd8c17
229	21	311	\N	228	1	2021-09-08 18:26:58	2021-09-08 18:26:58	32147784-1f2b-4c68-b394-1520f3ee663c
230	22	311	\N	228	1	2021-09-08 18:26:58	2021-09-08 18:26:58	3989faaa-ed68-4e82-83c1-707435a41918
231	49	314	\N	308	1	2021-09-08 18:26:58	2021-09-08 18:26:58	32f5270f-6335-4460-8df2-442b1be14537
233	8	316	\N	219	1	2021-09-14 22:23:01	2021-09-14 22:23:01	d8e3a90f-596e-4371-88b0-654139dc1b0a
235	8	318	\N	219	1	2021-09-14 22:23:30	2021-09-14 22:23:30	87fd4f9a-d27f-4d9a-9866-d1bd14975974
238	8	326	\N	217	1	2021-09-14 22:32:05	2021-09-14 22:32:05	8769fb39-a852-48f5-9883-5348a0af4194
239	8	335	\N	216	1	2021-09-16 23:29:40	2021-09-16 23:29:40	d35bb802-3f07-466f-a985-5c2a5057b281
240	8	336	\N	216	1	2021-09-16 23:29:43	2021-09-16 23:29:43	e78784fa-7c98-4ac4-864e-710ffcca319f
243	8	339	\N	219	1	2021-09-23 16:56:37	2021-09-23 16:56:37	ff452e07-2655-4a95-b6b9-46485a2e8f59
246	8	342	\N	217	1	2021-09-23 16:56:55	2021-09-23 16:56:55	c6cde7c0-ec6c-4be2-8884-b038aa363371
249	8	345	\N	214	1	2021-09-23 16:57:13	2021-09-23 16:57:13	7dd4f34a-0196-4cc1-aff6-aa1377c0acd6
252	8	348	\N	218	1	2021-09-23 16:57:44	2021-09-23 16:57:44	e03e5cd1-ebf5-47a6-b840-6b0355ef44cb
255	8	351	\N	216	1	2021-09-23 16:58:01	2021-09-23 16:58:01	6af9226a-6a87-44b7-83e8-5a8a04c234c8
259	8	354	\N	353	1	2021-09-28 23:40:54	2021-09-28 23:40:54	83c82d9e-86a4-4fd5-b69c-852227dcca4f
263	8	357	\N	356	1	2021-09-28 23:43:33	2021-09-28 23:43:33	bc1f2ae8-ec55-4132-a3d1-b6d3c835d271
267	8	360	\N	359	1	2021-09-28 23:46:32	2021-09-28 23:46:32	afcaf659-031c-4bbc-b696-375c14e6685d
271	8	363	\N	362	1	2021-09-28 23:49:47	2021-09-28 23:49:47	ebfa885b-3856-4be9-a7ec-aa568b3fe394
275	8	366	\N	365	1	2021-09-28 23:52:58	2021-09-28 23:52:58	ded54eda-e65b-40cb-a260-f8222caf37c1
278	8	378	\N	376	1	2021-10-01 20:33:23	2021-10-01 20:33:23	181c813d-a472-4122-a781-1f32364a33b5
281	8	14	\N	370	1	2021-10-08 22:40:17	2021-10-08 22:40:17	d477fe7d-5082-4c15-9dba-4bf3d187020f
282	8	383	\N	370	1	2021-10-08 22:40:17	2021-10-08 22:40:17	3babb836-3255-4c39-ae8d-d2baddb0abd9
284	8	23	\N	373	1	2021-10-08 22:40:48	2021-10-08 22:40:48	1c61c370-52dd-4403-9a52-700d572d41fe
285	8	386	\N	373	1	2021-10-08 22:40:48	2021-10-08 22:40:48	37d1e159-209a-4236-9046-83a417758f4c
359	56	442	\N	399	1	2021-10-22 19:54:07	2021-10-22 19:54:07	11363ce0-e8c0-4878-9f04-561ac18b6e53
287	8	27	\N	369	1	2021-10-08 22:42:36	2021-10-08 22:42:36	7f9d4672-117e-44e7-b4f6-eb56c6d1489b
288	8	389	\N	369	1	2021-10-08 22:42:36	2021-10-08 22:42:36	3b0964a6-eb8f-47bf-831a-d031372bf240
290	8	31	\N	372	1	2021-10-08 22:42:54	2021-10-08 22:42:54	04a4ad5f-5510-4f37-a581-f361569c1c5f
291	8	392	\N	372	1	2021-10-08 22:42:55	2021-10-08 22:42:55	2547bae7-3a26-4d6c-a22b-a89082fd613d
294	8	35	\N	371	1	2021-10-08 22:43:16	2021-10-08 22:43:16	48075625-6fb8-4fd2-bfba-da292d5ef89b
295	8	396	\N	371	1	2021-10-08 22:43:16	2021-10-08 22:43:16	573e80b9-b55a-4468-800c-0f3d3d66a433
297	8	397	\N	370	1	2021-10-08 22:43:20	2021-10-08 22:43:20	8edf9842-fd54-4ad2-afce-5fb58e6037c1
298	21	177	\N	380	1	2021-10-08 23:03:23	2021-10-08 23:03:23	f4c33d91-1834-4340-9720-115b0d59651d
299	21	229	\N	398	1	2021-10-08 23:04:06	2021-10-08 23:04:06	46c4d4d9-fc9d-4e85-a348-33dcc2e14ee4
301	56	92	\N	399	1	2021-10-08 23:04:52	2021-10-08 23:04:52	0cefef9f-4d4a-4aa9-b236-f8f8465a5327
302	56	401	\N	399	1	2021-10-08 23:04:53	2021-10-08 23:04:53	efa0ae17-da08-4ac5-947e-774dbb6293e2
304	56	240	\N	399	1	2021-10-08 23:05:09	2021-10-08 23:05:09	cbc6d19c-7d88-4619-8a50-403ad4f002cd
305	56	403	\N	399	1	2021-10-08 23:05:09	2021-10-08 23:05:09	ff3b28cc-d69e-4112-b997-e8232d9876a1
307	56	291	\N	399	1	2021-10-08 23:05:41	2021-10-08 23:05:41	0f87c342-6f37-4c75-a8b8-f1922e12b353
308	56	405	\N	399	1	2021-10-08 23:05:42	2021-10-08 23:05:42	f741b455-a076-48e9-9b13-bde8903dbd55
310	56	308	\N	399	1	2021-10-08 23:05:58	2021-10-08 23:05:58	37c08092-3dd2-4f0d-8455-95badc54fb27
311	56	407	\N	399	1	2021-10-08 23:05:58	2021-10-08 23:05:58	f709a9e5-4c47-4b9d-ad2e-32e6106cd59a
316	21	67	\N	380	1	2021-10-08 23:06:42	2021-10-08 23:06:42	f45566dc-7259-4cad-b717-090088032486
317	22	67	\N	380	1	2021-10-08 23:06:42	2021-10-08 23:06:42	bd54daf5-2a39-46f4-800d-7bcb71a419f1
318	30	412	\N	177	1	2021-10-08 23:06:43	2021-10-08 23:06:43	1064032b-68fb-42c9-8ea7-7ca874450e89
319	55	412	\N	178	1	2021-10-08 23:06:43	2021-10-08 23:06:43	64ae4a9d-130e-4d86-bd0d-059779fc321a
320	21	412	\N	380	1	2021-10-08 23:06:43	2021-10-08 23:06:43	947b16f3-725a-4815-9e55-9d858d663c49
321	22	412	\N	380	1	2021-10-08 23:06:43	2021-10-08 23:06:43	33637e58-b184-4e7b-ab95-e1f50cd581d1
327	21	95	\N	380	1	2021-10-08 23:07:33	2021-10-08 23:07:33	228efa3f-0e3c-4710-b7f5-d61293b373e3
328	22	95	\N	380	1	2021-10-08 23:07:33	2021-10-08 23:07:33	c0e03750-13b7-4494-b973-929c09569218
329	30	420	\N	177	1	2021-10-08 23:07:34	2021-10-08 23:07:34	a169883a-80e5-4e42-9b5d-800370a21a30
330	55	420	\N	178	1	2021-10-08 23:07:34	2021-10-08 23:07:34	ad53dcc6-10a7-40c8-8934-f42725709ce4
331	21	420	\N	380	1	2021-10-08 23:07:34	2021-10-08 23:07:34	df00edce-f6dd-4671-9830-aad0ca2c6062
332	22	420	\N	380	1	2021-10-08 23:07:34	2021-10-08 23:07:34	619de003-37a3-4c97-8d85-c79800f37cdd
333	49	423	\N	92	1	2021-10-08 23:07:34	2021-10-08 23:07:34	44c9e0ac-2c02-45af-b6b0-7834043fe94c
339	21	227	\N	424	1	2021-10-08 23:08:16	2021-10-08 23:08:16	516a1940-4764-4f09-a4fe-3e57437ce96c
340	22	227	\N	398	1	2021-10-08 23:08:16	2021-10-08 23:08:16	5f0d176f-a443-4adb-847f-29b1d1be2050
341	30	429	\N	177	1	2021-10-08 23:08:17	2021-10-08 23:08:17	c66e0667-79f9-41ed-9df2-36fd32596a1b
342	55	429	\N	205	1	2021-10-08 23:08:17	2021-10-08 23:08:17	7168fa75-f2fa-4ecd-b156-b6dc6385e86f
343	21	429	\N	424	1	2021-10-08 23:08:17	2021-10-08 23:08:17	03e98d10-6de4-4a69-adf9-c79f077162ed
344	22	429	\N	398	1	2021-10-08 23:08:17	2021-10-08 23:08:17	74ebb457-2664-4749-bbaf-dc69fbefee18
345	49	432	\N	240	1	2021-10-08 23:08:17	2021-10-08 23:08:17	c55dc31e-dc16-4b32-af21-c51c2ee9e654
\.


--
-- TOC entry 4631 (class 0 OID 16775)
-- Dependencies: 269
-- Data for Name: resourcepaths; Type: TABLE DATA; Schema: public; Owner: -
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
6cd2c45a	@craft/web/assets/matrix/dist
d5ece257	@app/web/assets/editsection/dist
4e6e3f9	@craft/web/assets/edituser/dist
dab5ff92	@craft/web/assets/matrixsettings/dist
ca22de7e	@app/web/assets/userpermissions/dist
9e8cd732	@craft/web/assets/graphiql/dist
70a16c8a	@app/web/assets/fieldsettings/dist
a198c1ca	@craft/web/assets/plugins/dist
cc5ac995	@app/web/assets/matrixsettings/dist
9a7f4a32	@app/web/assets/fields/dist
3f47228a	@craft/web/assets/editentry/dist
5450a4eb	@craft/web/assets/userpermissions/dist
27418c45	@craft/redactor/assets/redactor/dist
5ee2091c	@lib/velocity
fdcb22f8	@app/web/assets/fields/dist
84888ae	@app/web/assets/graphiql/dist
80b5c33a	@app/web/assets/login/dist
17150440	@app/web/assets/fieldsettings/dist
bd72f9a7	@app/web/assets/admintable/dist
37777185	@lib/vue
104b92b9	@lib/jquery-ui
14c48bd8	@app/web/assets/craftsupport/dist
e64fb174	@lib/d3
954ad125	@app/web/assets/updateswidget/dist
40ba0944	@app/web/assets/feed/dist
c6e5f4ad	@lib/prismjs
16e40af	@craft/redactor/assets/field/dist
faac0cb6	@app/web/assets/dashboard/dist
f55ef9d5	@app/web/assets/login/dist
84d50a97	@app/web/assets/updateswidget/dist
c5592de5	@app/web/assets/utilities/dist
31b18133	@lib/axios
a37479b8	@app/web/assets/recententries/dist
c3c7c2e6	@lib/picturefill
fedff531	@lib/garnishjs
97b9ef62	@lib/selectize
bf4f38f5	@craft/redactor/assets/redactor/dist
52b0f04d	@app/web/assets/matrix/dist
a22af39d	@lib/timepicker
42c5a6f4	@lib/jquery.payment
da0aceb6	@app/web/assets/editentry/dist
8b2fb0bc	@craft/web/assets/login/dist
563f72a1	@craft/web/assets/utilities/dist
b2d4802c	@lib/prismjs
6fad1cb	@craft/web/assets/dashboard/dist
8403553d	@app/web/assets/dashboard/dist
d4c6f657	@app/web/assets/utilities/dist
37801894	@craft/web/assets/pluginstore/dist
9eaff654	@craft/web/assets/fields/dist
470e1b71	@app/web/assets/cp/dist
f3582e55	@craft/web/assets/fieldsettings/dist
5d5e8da2	@app/web/assets/admintable/dist
6ffce064	@app/web/assets/graphiql/dist
d61b871c	@lib/timepicker
21ca97cb	@craft/web/assets/updater/dist
16b393fa	@craft/web/assets/updateswidget/dist
14cc2115	@lib/element-resize-detector
2809d194	@craft/web/assets/recententries/dist
66a2c641	@craft/web/assets/feed/dist
43460504	@lib/vue
6a6bd253	@app/web/assets/craftsupport/dist
40acca44	@craft/web/assets/craftsupport/dist
9fb39b6f	@app/web/assets/pluginstore/dist
7ddf61ac	@craft/web/assets/editsection/dist
8aee81b0	@lib/garnishjs
b371298c	@craft/redactor/assets/redactor-plugins/dist/video
abf0934b	@app/web/assets/recententries/dist
fd7ee5dc	@craft/web/assets/cp/dist
b9539636	@lib/d3
2ad37d9d	@lib/velocity
39e40e17	@lib/xregexp
242811b6	@craft/redactor/assets/field/dist
54dd51b	@app/web/assets/plugins/dist
36f4d275	@lib/jquery.payment
6eada671	@lib/axios
3b5c8ae0	@bower/jquery/dist
b7f6b667	@lib/picturefill
9fa8558e	@lib/fabric
b1243a2f	@craft/redactor/assets/redactor/dist
851f831a	@app/web/assets/updater/dist
270e618e	@app/web/assets/feed/dist
af1eb799	@lib/fileupload
e3889be3	@lib/selectize
bdbea67c	@app/web/assets/editentry/dist
b0528aa5	@lib/jquery-touch-events
647ae638	@lib/jquery-ui
b2588a9d	@app/web/assets/editsection/dist
f6e841e4	@app/web/assets/matrixsettings/dist
a0dfc57a	@app/web/assets/login/dist
a4e1d004	@app/web/assets/cp/dist
959b3672	@lib/axios
42650635	@lib/d3
effab116	@lib/element-resize-detector
71d811b3	@lib/garnishjs
c06a1ae3	@bower/jquery/dist
4b641aa6	@lib/jquery-touch-events
d1e5ed9e	@lib/velocity
9f4c763b	@lib/jquery-ui
cdc24276	@lib/jquery.payment
4cc02664	@lib/picturefill
18be0be0	@lib/selectize
5428279a	@lib/fileupload
12d24f6a	@lib/xregexp
649ec58d	@lib/fabric
588b188d	@lib/iframe-resizer
a4ca417b	@bower/jquery/dist
ec2dcb26	@app/web/assets/recententries/dist
3c2b4315	@lib/iframe-resizer
ed2442be	@app/web/assets/craftsupport/dist
2fc4413e	@lib/jquery-touch-events
dcd0ce9f	@lib/vue
39e6277c	@craft/redactor/assets/redactor-plugins/dist/fullscreen
bd1a2b56	@craft/redactor/assets/redactor-plugins/dist/video
902230f	@craft/web/assets/admintable/dist
418788c3	@app/web/assets/plugins/dist
faaddf3e	@app/web/assets/updateswidget/dist
b95ac022	@app/web/assets/feed/dist
c1fd2630	@app/web/assets/login/dist
c4179d50	@app/web/assets/recententries/dist
c262f7f6	@app/web/assets/pluginstore/dist
d2978948	@app/web/assets/updateswidget/dist
9222bc65	@app/web/assets/edituser/dist
887ba715	@app/web/assets/feed/dist
fbec2da3	@lib/jquery-ui
34cc5d0	@app/web/assets/dashboard/dist
8dff8613	@app/web/assets/userpermissions/dist
23ea07d0	@app/web/assets/editentry/dist
dc052589	@app/web/assets/craftsupport/dist
dbbd05cc	@app/web/assets/userpermissions/dist
326da2e7	@app/web/assets/dashboard/dist
c01a0add	@lib/axios
17e43a9a	@lib/d3
ba7b8db9	@lib/element-resize-detector
24592d1c	@lib/garnishjs
1ee52609	@lib/jquery-touch-events
c0418b9c	@app/web/assets/cp/dist
8464d131	@lib/velocity
cacd4a94	@lib/jquery-ui
98437ed9	@lib/jquery.payment
19411acb	@lib/picturefill
4d3f374f	@lib/selectize
1a91b35	@lib/fileupload
475373c5	@lib/xregexp
2d424bb7	@lib/prismjs
b7cf1f0e	@craft/redactor/assets/field/dist
7c1e5078	@lib/selectize
c5e48395	@app/web/assets/dbbackup/dist
5d890180	@app/web/assets/admintable/dist
311ff922	@lib/fabric
26c55dad	@lib/d3
2c9a9d1f	@app/web/assets/sites/dist
d0a2422	@lib/iframe-resizer
95eb264c	@bower/jquery/dist
f160ecab	@app/web/assets/cp/dist
d4f9267a	@app/web/assets/login/dist
d0c73304	@app/web/assets/cp/dist
e1bdd572	@lib/axios
3643e535	@lib/d3
9bdc5216	@lib/element-resize-detector
5fef2b3	@lib/garnishjs
b44cf9e3	@bower/jquery/dist
3f42f9a6	@lib/jquery-touch-events
ba074b4b	@app/web/assets/login/dist
a5c30e9e	@lib/velocity
eb6a953b	@lib/jquery-ui
30887c02	@lib/fileupload
b9e4a176	@lib/jquery.payment
4bd00657	@lib/element-resize-detector
c463fe24	@lib/jquery-touch-events
db2fc318	@lib/fileupload
38e6c564	@lib/picturefill
6c98e8e0	@lib/selectize
767214f2	@lib/xregexp
200ec49a	@lib/fileupload
1ca07665	@craft/redactor/assets/redactor-plugins/dist/fullscreen
22c33497	@craft/redactor/assets/redactor/dist
3e9e15	@lib/fabric
eaf88d01	@app/web/assets/updater/dist
b545b606	@lib/velocity
28607dfc	@lib/picturefill
66f4ac6a	@lib/xregexp
9dd5abe8	@lib/xregexp
c0b472cc	@lib/fabric
10b8268d	@lib/fabric
2cadfb8d	@lib/iframe-resizer
d78cfc0f	@lib/iframe-resizer
4f6dfe61	@bower/jquery/dist
5ae31234	@app/web/assets/edituser/dist
39a142fa	@app/web/assets/cp/dist
7b00c689	@app/web/assets/edittransform/dist
8f4778dd	@craft/redactor/assets/redactor-plugins/dist/fullscreen
20962734	@craft/redactor/assets/redactor-plugins/dist/video
a96219ee	@lib/jquery.payment
15784a2b	@lib/garnishjs
f13b6dea	@lib/axios
f712826e	@app/web/assets/generalsettings/dist
8b5aea8e	@lib/element-resize-detector
6a4d35fb	@app/web/assets/updates/dist
498d4c87	@lib/timepicker
6802783c	@app/web/assets/matrix/dist
8188082b	@craft/googlecloud/resources
c47f9ee2	@app/web/assets/login/dist
2347e57f	@lib/d3
f4b9d538	@lib/axios
c5c3334e	@app/web/assets/cp/dist
10faf2f9	@lib/garnishjs
8ed8525c	@lib/element-resize-detector
a3bd888e	@lib/iframe-resizer
28c0f365	@lib/prismjs
4c0ff455	@lib/timepicker
50e89b5d	@app/web/assets/matrix/dist
7d71f760	@app/web/assets/cp/dist
b85f205b	@app/web/assets/login/dist
4c0b1116	@lib/axios
9bf52151	@lib/d3
366a9672	@lib/element-resize-detector
780b5527	@app/web/assets/fields/dist
a84836d7	@lib/garnishjs
19fa3d87	@bower/jquery/dist
92f43dc2	@lib/jquery-touch-events
875cafa	@lib/velocity
a0f07026	@lib/vue
defb7e65	@app/web/assets/pluginstore/dist
794fe21e	@app/web/assets/login/dist
1a9534c	@app/web/assets/fields/dist
5fcab969	@app/web/assets/editentry/dist
bc613525	@app/web/assets/cp/dist
d88e14c3	@app/web/assets/recententries/dist
8d1bd353	@lib/axios
6091b418	@app/web/assets/updates/dist
5ae5e314	@lib/d3
a12c12a8	@app/web/assets/recententries/dist
f77a5437	@lib/element-resize-detector
e8a6fa6c	@app/web/assets/craftsupport/dist
e63456ad	@app/web/assets/updateswidget/dist
bcd878f0	@app/web/assets/feed/dist
6ce7d02	@app/web/assets/dashboard/dist
a148f9a9	@bower/jquery/dist
2a46f9ec	@lib/jquery-touch-events
b0c70ed4	@lib/velocity
fe6e9571	@lib/jquery-ui
ace0a13c	@lib/jquery.payment
2de2c52e	@lib/picturefill
799ce8aa	@lib/selectize
350ac4d0	@lib/fileupload
73f0ac20	@lib/xregexp
5bc26c7	@lib/fabric
b24da7dc	@craft/redactor/assets/field/dist
8ac5c00f	@craft/redactor/assets/redactor-plugins/dist/fullscreen
25149fe6	@craft/redactor/assets/redactor-plugins/dist/video
294a9d36	@app/web/assets/matrix/dist
39a9fbc7	@lib/iframe-resizer
8fc302f9	@app/web/assets/updater/dist
6958f492	@lib/garnishjs
21a9bf39	@app/web/assets/admintable/dist
580bb952	@app/web/assets/admintable/dist
f6610492	@app/web/assets/updater/dist
2668bf02	@app/web/assets/editentry/dist
d8eaffc2	@bower/jquery/dist
de1a77b4	@app/web/assets/utilities/dist
53e4ff87	@lib/jquery-touch-events
a7b871df	@app/web/assets/utilities/dist
a759780e	@app/web/assets/pluginstore/dist
c96508bf	@lib/velocity
87cc931a	@lib/jquery-ui
d542a757	@lib/jquery.payment
5440c345	@lib/picturefill
3eeec1	@lib/selectize
d952764d	@lib/vue
b95c59f6	@app/web/assets/userpermissions/dist
50379958	@lib/axios
4ca8c2bb	@lib/fileupload
a52aa4b	@lib/xregexp
87c9a91f	@lib/d3
7c1e20ac	@lib/fabric
400bfdac	@lib/iframe-resizer
50a4b57a	@app/web/assets/graphiql/dist
46dc515f	@lib/jquery-ui
5162f50e	@lib/prismjs
f9d9c335	@craft/redactor/assets/field/dist
6cd5e8ac	@craft/redactor/assets/redactor/dist
c151a4e6	@craft/redactor/assets/redactor-plugins/dist/fullscreen
14526512	@lib/jquery.payment
6e80fb0f	@craft/redactor/assets/redactor-plugins/dist/video
35adf23e	@lib/timepicker
8b323cd7	@app/web/assets/generalsettings/dist
95500100	@lib/picturefill
92d5739f	@app/web/assets/fieldsettings/dist
c12e2c84	@lib/selectize
8db800fe	@lib/fileupload
cb42680e	@lib/xregexp
9104fc07	@app/web/assets/craftsupport/dist
9f9650c6	@app/web/assets/updateswidget/dist
c57a7e9b	@app/web/assets/feed/dist
7f6c7b69	@app/web/assets/dashboard/dist
bd0ee2e9	@lib/fabric
8ec8b58c	@lib/jquery-touch-events
144942b4	@lib/velocity
918488b0	@lib/fileupload
8c4ebf05	@lib/prismjs
d77ee040	@lib/xregexp
a1326aa7	@lib/fabric
e881b835	@lib/timepicker
82e6f362	@app/web/assets/editentry/dist
5ae0d911	@lib/jquery-ui
b474be99	@lib/garnishjs
764686b3	@craft/web/assets/updater/dist
dd12a4ca	@lib/selectize
9d27b7a7	@lib/iframe-resizer
2a561e3c	@lib/element-resize-detector
86eed5c	@lib/jquery.payment
896c894e	@lib/picturefill
3dc12483	@app/web/assets/updates/dist
e08b7c71	@app/web/assets/plugins/dist
5c6b5c9	@bower/jquery/dist
4b2c2d3	@craft/redactor/assets/redactor-plugins/dist/video
4810d6d9	@craft/web/assets/generalsettings/dist
29a29f2	@app/web/assets/editentry/dist
ec045387	@craft/web/assets/dbbackup/dist
51da605f	@craft/googlecloud/resources
93ebfae9	@craft/redactor/assets/field/dist
cf85e304	@app/web/assets/fieldsettings/dist
7cf92fa2	@app/web/assets/admintable/dist
6e7d170	@craft/redactor/assets/redactor/dist
d0d86fea	@app/web/assets/graphiql/dist
d2939262	@app/web/assets/updater/dist
603cd0ed	@app/web/assets/recententries/dist
4a0cd2e5	@lib/element-resize-detector
50143e42	@app/web/assets/craftsupport/dist
5e869283	@app/web/assets/updateswidget/dist
46abcde	@app/web/assets/feed/dist
be7cb92c	@app/web/assets/dashboard/dist
9072374b	@lib/prismjs
4ed3c0bc	@app/web/assets/updater/dist
c57dd3f5	@app/web/assets/fields/dist
d42e7240	@lib/garnishjs
659c7910	@bower/jquery/dist
ee927955	@lib/jquery-touch-events
1f0ab5f1	@app/web/assets/utilities/dist
74138e6d	@lib/velocity
3aba15c8	@lib/jquery-ui
b91b9762	@app/web/assets/fields/dist
68342185	@lib/jquery.payment
e0b97d7c	@app/web/assets/admintable/dist
61e0b263	@lib/vue
e9364597	@lib/picturefill
811b3fe9	@lib/iframe-resizer
1c5a947a	@app/web/assets/recententries/dist
bd486813	@lib/selectize
f1de4469	@lib/fileupload
b7242c99	@lib/xregexp
c168a67e	@lib/fabric
fd7d7b7e	@lib/iframe-resizer
2c727ad5	@app/web/assets/craftsupport/dist
636cf166	@app/web/assets/utilities/dist
22e0d614	@app/web/assets/updateswidget/dist
780cf849	@app/web/assets/feed/dist
c21afdbb	@app/web/assets/dashboard/dist
9cdf39eb	@app/web/assets/admintable/dist
90919ab4	@app/web/assets/pluginstore/dist
7b602001	@lib/fileupload
3d9a48f1	@lib/xregexp
e2bc3fbb	@app/web/assets/editentry/dist
42ba1acd	@app/web/assets/updateswidget/dist
4bd6c216	@lib/fabric
c422b230	@craft/web/assets/plugins/dist
8aee7b90	@app/web/assets/editsection/dist
2fa3f54d	@app/web/assets/fieldsettings/dist
e693748b	@craft/web/assets/craftsupport/dist
77c31f16	@lib/iframe-resizer
a85eb27c	@app/web/assets/updateswidget/dist
f2b29c21	@app/web/assets/feed/dist
a6cc1ebd	@app/web/assets/craftsupport/dist
48a499d3	@app/web/assets/dashboard/dist
1d86f6f4	@lib/vue
ec1473dc	@lib/prismjs
e81a0aeb	@craft/redactor/assets/field/dist
7d162172	@craft/redactor/assets/redactor/dist
30fe79a3	@app/web/assets/graphiql/dist
d0926d38	@craft/redactor/assets/redactor-plugins/dist/fullscreen
7f4332d1	@craft/redactor/assets/redactor-plugins/dist/video
ed9e1d8f	@app/web/assets/matrix/dist
88db74ec	@lib/timepicker
66aa17b4	@lib/prismjs
ce11218f	@craft/redactor/assets/field/dist
49c6ac26	@app/web/assets/matrixsettings/dist
b80be043	@app/web/assets/updater/dist
16615d83	@app/web/assets/admintable/dist
672079e7	@app/web/assets/matrix/dist
68025bd3	@app/web/assets/editentry/dist
ef221d78	@bower/jquery/dist
8ba9d79f	@app/web/assets/cp/dist
a0c56f04	@craft/web/assets/dashboard/dist
5b1d0a16	@craft/redactor/assets/redactor/dist
f699465c	@craft/redactor/assets/redactor-plugins/dist/fullscreen
594819b5	@craft/redactor/assets/redactor-plugins/dist/video
529a689	@app/web/assets/login/dist
117b3f7	@app/web/assets/cp/dist
306d5581	@lib/axios
2651084	@lib/timepicker
e79365c6	@lib/d3
7f85c0ec	@craft/web/assets/recententries/dist
bad331e9	@lib/axios
96e4f012	@app/web/assets/recententries/dist
6d2d01ae	@lib/d3
9738929c	@lib/vue
ba401dcb	@app/web/assets/graphiql/dist
8f97c2e1	@app/web/assets/login/dist
c0b2b68d	@lib/element-resize-detector
5e901628	@lib/garnishjs
18563490	@app/web/assets/feed/dist
fc85f532	@app/web/assets/admintable/dist
a2403162	@app/web/assets/dashboard/dist
413f8282	@craft/web/assets/updateswidget/dist
a6fd4c0	@app/web/assets/plugins/dist
968b7a0	@craft/web/assets/matrix/dist
642c1d3d	@lib/jquery-touch-events
feadea05	@lib/velocity
7ddc3a2d	@lib/vue
4c28b60c	@app/web/assets/craftsupport/dist
b00471a0	@lib/jquery-ui
fda0e0bd	@lib/vue
21a858bc	@craft/web/assets/graphiql/dist
e28a45ed	@lib/jquery.payment
28a5810f	@craft/web/assets/admintable/dist
638821ff	@lib/picturefill
e9d2950e	@app/web/assets/utilities/dist
37f60c7b	@lib/selectize
d98649cf	@craft/web/assets/feed/dist
7c0058a3	@app/web/assets/recententries/dist
65736a50	@app/web/assets/login/dist
e50fb0c0	@app/web/assets/login/dist
614d7f2e	@app/web/assets/cp/dist
fc7c8233	@app/web/assets/recententries/dist
223cebf2	@app/web/assets/dashboard/dist
214eb037	@lib/fabric
cc546c9c	@app/web/assets/craftsupport/dist
d04b43c8	@lib/axios
5b415b13	@craft/web/assets/cp/dist
6ac86dd9	@app/web/assets/editsection/dist
f81f483a	@lib/garnishjs
49ad436a	@bower/jquery/dist
c2a3432f	@lib/jquery-touch-events
3dcb593	@craft/web/assets/userpermissions/dist
e6891c29	@craft/web/assets/utilities/dist
5822b417	@lib/velocity
c2c6c05d	@app/web/assets/updateswidget/dist
982aee00	@app/web/assets/feed/dist
523a6b6e	@craft/web/assets/pluginstore/dist
db80bc6	@app/web/assets/matrix/dist
e131a5be	@app/web/assets/cp/dist
7b5738f	@lib/d3
aa2ac4ac	@lib/element-resize-detector
255bc5bc	@app/web/assets/fields/dist
8063ad04	@craft/web/assets/editentry/dist
34086409	@lib/garnishjs
85ba6f59	@bower/jquery/dist
99143052	@craft/web/assets/updates/dist
eb46f1c	@lib/jquery-touch-events
94359824	@lib/velocity
da9c0381	@lib/jquery-ui
881237cc	@lib/jquery.payment
91053de	@lib/picturefill
5d6e7e5a	@lib/selectize
11f85220	@lib/fileupload
57023ad0	@lib/xregexp
1d5b6d37	@lib/iframe-resizer
168b2fb2	@lib/jquery-ui
c326595	@lib/prismjs
68fd62a5	@lib/timepicker
44051bff	@lib/jquery.payment
c5077fed	@lib/picturefill
91795269	@lib/selectize
ddef7e13	@lib/fileupload
ee95c346	@craft/web/assets/login/dist
9b1516e3	@lib/xregexp
ed599c04	@lib/fabric
fa09e895	@app/web/assets/pluginstore/dist
d14c4104	@lib/iframe-resizer
1a90b7b	@craft/web/assets/craftsupport/dist
a605fd72	@craft/web/assets/updateswidget/dist
47ff10f4	@craft/web/assets/dashboard/dist
7e2e4fa2	@craft/web/assets/updates/dist
8f24e8a5	@craft/web/assets/updateswidget/dist
9daecf06	@app/web/assets/userpermissions/dist
917cf943	@craft/web/assets/updater/dist
3363dbf	@app/web/assets/utilities/dist
bdbdfe13	@app/web/assets/updates/dist
1dd21596	@app/web/assets/userpermissions/dist
179d23e8	@craft/web/assets/feed/dist
c2290fb2	@lib/prismjs
cddaa7a	@app/web/assets/updateswidget/dist
9afbcb6	@craft/web/assets/login/dist
60f7a6e1	@app/web/assets/plugins/dist
56318427	@app/web/assets/feed/dist
ec2781d5	@app/web/assets/dashboard/dist
1b363d9	@craft/web/assets/utilities/dist
f3da4ea4	@app/web/assets/updates/dist
2b14dae7	@app/web/assets/login/dist
834ae72f	@app/web/assets/utilities/dist
6ede0523	@craft/web/assets/dashboard/dist
c0af053b	@lib/jquery-touch-events
98bfbf1c	@craft/web/assets/recententries/dist
bc7b24e3	@craft/web/assets/cp/dist
1c5c6ffb	@lib/axios
cba25fbc	@lib/d3
5a2ef203	@lib/velocity
663de89f	@lib/element-resize-detector
d36f0ef6	@app/web/assets/dbbackup/dist
2f2acf99	@app/web/assets/cp/dist
cc8143d5	@app/web/assets/editentry/dist
148769a6	@lib/jquery-ui
46095deb	@lib/jquery.payment
c70b39f9	@lib/picturefill
9375147d	@lib/selectize
dfe33807	@lib/fileupload
1c88f845	@app/web/assets/updater/dist
b19eaacb	@craft/web/assets/recententries/dist
3267e814	@app/web/assets/recententries/dist
991950f7	@lib/xregexp
ab639d3a	@craft/redactor/assets/redactor-plugins/dist/fullscreen
c3a361e1	@app/web/assets/matrix/dist
ef55da10	@lib/fabric
4d518d08	@app/web/assets/utilities/dist
33bb8a9a	@lib/vue
d3400710	@lib/iframe-resizer
341282b2	@app/web/assets/pluginstore/dist
208ea961	@craft/web/assets/login/dist
1e5029ef	@lib/axios
4ba1057e	@bower/jquery/dist
c9ae19a8	@lib/d3
955a3134	@craft/web/assets/cp/dist
6431ae8b	@lib/element-resize-detector
24f06bb	@app/web/assets/craftsupport/dist
28881eac	@craft/web/assets/craftsupport/dist
fa130e2e	@lib/garnishjs
a6e60882	@lib/timepicker
\.


--
-- TOC entry 4632 (class 0 OID 16781)
-- Dependencies: 270
-- Data for Name: revisions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.revisions (id, "sourceId", "creatorId", num, notes) FROM stdin;
1	8	1	1	
2	8	1	2	
3	14	1	1	
4	8	1	3	
5	8	1	4	
6	14	1	2	
7	23	1	1	
8	27	1	1	
9	31	1	1	
10	35	1	1	
11	38	1	1	
12	41	1	1	
13	45	1	1	
14	51	1	1	\N
15	57	1	1	\N
16	65	1	1	\N
17	67	1	1	
18	67	1	2	
19	67	1	3	
20	82	1	1	
21	92	1	1	\N
22	95	1	1	
23	92	1	2	\N
24	95	1	2	
25	67	1	4	
26	8	1	5	
27	14	1	3	
28	8	1	6	
29	23	1	2	
30	27	1	2	
31	31	1	2	
32	35	1	2	
33	8	1	7	
34	14	1	4	
35	23	1	3	
36	27	1	3	
37	31	1	3	
38	31	1	4	
39	35	1	3	
40	45	1	2	
41	138	1	1	
42	138	1	2	
43	67	1	5	
44	95	1	3	
45	138	1	3	
46	67	1	6	
47	95	1	4	
48	95	1	5	
49	45	1	3	
50	14	1	5	
51	23	1	4	
52	27	1	4	
53	31	1	5	
54	67	1	7	
55	45	1	4	
56	95	1	6	
57	95	1	7	
58	95	1	8	
59	8	1	8	
60	14	1	6	
61	23	1	5	
62	27	1	5	
63	31	1	6	
64	35	1	4	
65	92	1	3	
66	92	1	4	
67	95	1	9	
68	8	1	9	
69	14	1	7	
70	23	1	6	
71	27	1	6	
72	31	1	7	
73	35	1	5	
74	31	1	8	
75	240	1	1	\N
76	227	1	1	
77	95	1	10	
78	67	1	8	Applied “Draft 1”
79	227	1	2	
80	227	1	3	Applied “Draft 1”
81	291	1	1	\N
82	279	1	1	
83	308	1	1	\N
84	298	1	1	
85	14	1	8	Applied “Draft 1”
86	14	1	9	Applied “Draft 1”
87	23	1	7	Applied “Draft 1”
88	45	1	5	Applied “Draft 1”
89	45	1	6	Applied “Draft 1”
90	45	1	7	Applied “Draft 1”
91	45	1	8	Applied “Draft 1”
92	35	1	6	
93	35	1	7	
94	14	1	10	Applied “Draft 1”
95	23	1	8	Applied “Draft 1”
96	27	1	7	Applied “Draft 1”
97	31	1	9	Applied “Draft 1”
98	35	1	8	Applied “Draft 1”
99	14	1	11	Applied “Draft 1”
100	23	1	9	Applied “Draft 1”
101	27	1	8	Applied “Draft 1”
102	31	1	10	Applied “Draft 1”
103	35	1	9	Applied “Draft 1”
104	374	1	1	
105	14	1	12	Applied “Draft 1”
106	14	1	13	Applied “Draft 1”
107	23	1	10	Applied “Draft 1”
108	27	1	9	Applied “Draft 1”
109	31	1	11	Applied “Draft 1”
110	35	1	10	Applied “Draft 1”
111	14	1	14	Applied “Draft 1”
112	92	1	5	
113	240	1	2	Applied “Draft 1”
114	291	1	2	Applied “Draft 1”
115	308	1	2	Applied “Draft 1”
116	67	1	9	Applied “Draft 1”
117	95	1	11	Applied “Draft 1”
118	227	1	4	Applied “Draft 1”
119	298	1	2	Applied “Draft 1”
120	308	1	3	
\.


--
-- TOC entry 4634 (class 0 OID 16789)
-- Dependencies: 272
-- Data for Name: searchindex; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.searchindex ("elementId", attribute, "fieldId", "siteId", keywords, keywords_vector) FROM stdin;
1	username	0	1	 admin 	'admin'
1	firstname	0	1		
1	lastname	0	1		
1	fullname	0	1		
1	email	0	1	 erosas lsst org 	'erosas' 'lsst' 'org'
1	slug	0	1		
67	slug	0	1	 the search for aliens 	'aliens' 'for' 'search' 'the'
67	title	0	1	 the search for alienz 	'alienz' 'for' 'search' 'the'
3	slug	0	1	 temp evrzpzgcpethpqmdatvmjwitqytkxncfwgaw 	'evrzpzgcpethpqmdatvmjwitqytkxncfwgaw' 'temp'
3	title	0	1		
4	slug	0	1	 temp ignhzbtrxqwizdkionwdqgqexnhfusgiqkdj 	'ignhzbtrxqwizdkionwdqgqexnhfusgiqkdj' 'temp'
4	title	0	1		
5	slug	0	1	 allsky hips catalog data 	'allsky' 'catalog' 'data' 'hips'
5	title	0	1	 allsky hips catalog data 	'allsky' 'catalog' 'data' 'hips'
67	field	30	1	 test 	'test'
252	slug	0	1		
252	field	18	1	 blah blah 	'blah'
252	slug	0	2		
252	field	18	2	 blah blah 	'blah'
253	slug	0	1		
253	field	38	1	 ha 	'ha'
155	slug	0	1		
155	field	18	1	 blah blah 	'blah'
155	slug	0	2		
253	slug	0	2		
253	field	38	2	 ha 	'ha'
254	slug	0	1		
17	filename	0	1	 star icon png 	'icon' 'png' 'star'
17	extension	0	1	 png 	'png'
17	kind	0	1	 image 	'image'
17	slug	0	1		
17	title	0	1	 star icon 	'icon' 'star'
17	filename	0	2	 star icon png 	'icon' 'png' 'star'
17	extension	0	2	 png 	'png'
17	kind	0	2	 image 	'image'
17	slug	0	2		
17	title	0	2	 star icon 	'icon' 'star'
67	field	55	1	 stars 	'stars'
10	slug	0	2	 temp oiwlfgbxnzzylcjhnrdcrelfwippnbacrpil 	'oiwlfgbxnzzylcjhnrdcrelfwippnbacrpil' 'temp'
10	title	0	2		
10	slug	0	1	 temp oiwlfgbxnzzylcjhnrdcrelfwippnbacrpil 	'oiwlfgbxnzzylcjhnrdcrelfwippnbacrpil' 'temp'
10	title	0	1		
254	field	37	1	 test test 	'test'
254	slug	0	2		
11	slug	0	2	 temp wlmsgwxnqfwiyyaheimtfjazbxinsifesbdf 	'temp' 'wlmsgwxnqfwiyyaheimtfjazbxinsifesbdf'
11	title	0	2		
11	slug	0	1	 temp wlmsgwxnqfwiyyaheimtfjazbxinsifesbdf 	'temp' 'wlmsgwxnqfwiyyaheimtfjazbxinsifesbdf'
11	title	0	1		
254	field	37	2	 test test 	'test'
2	slug	0	2	 catalog data 	'catalog' 'data'
2	title	0	2	 allsky hips catalog data 	'allsky' 'catalog' 'data' 'hips'
2	slug	0	1	 catalog data 	'catalog' 'data'
2	title	0	1	 allsky hips catalog data 	'allsky' 'catalog' 'data' 'hips'
67	field	21	1	 ourneighborhood 	'ourneighborhood'
67	field	22	1	 ourneighborhood 	'ourneighborhood'
67	field	33	1	 some heading 	'heading' 'some'
67	field	34	1	 another subheading 	'another' 'subheading'
191	filename	0	1	 nebula icon 2021 08 17 203613 drvc png 	'08' '17' '2021' '203613' 'drvc' 'icon' 'nebula' 'png'
191	extension	0	1	 png 	'png'
191	kind	0	1	 image 	'image'
191	slug	0	1		
191	title	0	1	 nebula icon 	'icon' 'nebula'
191	filename	0	2	 nebula icon 2021 08 17 203613 drvc png 	'08' '17' '2021' '203613' 'drvc' 'icon' 'nebula' 'png'
191	extension	0	2	 png 	'png'
191	kind	0	2	 image 	'image'
191	slug	0	2		
191	title	0	2	 nebula icon 	'icon' 'nebula'
67	field	17	1	 blahbitty blah blah 	'blah' 'blahbitty'
67	field	32	1	 how about this fun fact 	'about' 'fact' 'fun' 'how' 'this'
67	field	31	1	 aliens are kewl 	'aliens' 'are' 'kewl'
92	field	40	1	 blah blah 	'blah'
30	filename	0	1	 fun goal icon png 	'fun' 'goal' 'icon' 'png'
30	extension	0	1	 png 	'png'
30	kind	0	1	 image 	'image'
30	slug	0	1		
279	field	30	1	 test 	'test'
279	field	55	1	 planets 	'planets'
279	field	21	1	 astrocat 	'astrocat'
30	title	0	1	 fun goal icon 	'fun' 'goal' 'icon'
30	filename	0	2	 fun goal icon png 	'fun' 'goal' 'icon' 'png'
30	extension	0	2	 png 	'png'
30	kind	0	2	 image 	'image'
30	slug	0	2		
30	title	0	2	 fun goal icon 	'fun' 'goal' 'icon'
92	field	40	2	 blah blah 	'blah'
49	filename	0	1	 astrocat jpeg 	'astrocat' 'jpeg'
49	extension	0	1	 jpeg 	'jpeg'
49	kind	0	1	 image 	'image'
49	slug	0	1		
49	title	0	1	 astrocat 	'astrocat'
49	filename	0	2	 astrocat jpeg 	'astrocat' 'jpeg'
49	extension	0	2	 jpeg 	'jpeg'
49	kind	0	2	 image 	'image'
49	slug	0	2		
49	title	0	2	 astrocat 	'astrocat'
50	filename	0	1	 fo4 pebbles artwork png 	'artwork' 'fo4' 'pebbles' 'png'
50	extension	0	1	 png 	'png'
50	kind	0	1	 image 	'image'
50	slug	0	1		
50	title	0	1	 fo4 pebbles artwork 	'artwork' 'fo4' 'pebbles'
50	filename	0	2	 fo4 pebbles artwork png 	'artwork' 'fo4' 'pebbles' 'png'
50	extension	0	2	 png 	'png'
50	kind	0	2	 image 	'image'
50	slug	0	2		
50	title	0	2	 fo4 pebbles artwork 	'artwork' 'fo4' 'pebbles'
34	filename	0	2	 landmark icon png 	'icon' 'landmark' 'png'
34	extension	0	2	 png 	'png'
34	kind	0	2	 image 	'image'
34	slug	0	2		
34	title	0	2	 landmark icon 	'icon' 'landmark'
34	filename	0	1	 landmark icon png 	'icon' 'landmark' 'png'
34	extension	0	1	 png 	'png'
34	kind	0	1	 image 	'image'
34	slug	0	1		
34	title	0	1	 landmark icon 	'icon' 'landmark'
289	slug	0	2		
212	slug	0	2		
289	field	37	2	 blah blah 	'blah'
289	slug	0	1		
38	slug	0	1	 control healpix catalog 	'catalog' 'control' 'healpix'
38	title	0	1	 control healpix catalog 	'catalog' 'control' 'healpix'
38	slug	0	2	 control healpix catalog 	'catalog' 'control' 'healpix'
38	title	0	2	 control healpix catalog 	'catalog' 'control' 'healpix'
52	slug	0	1		
52	slug	0	2		
41	slug	0	1	 akari catalog 	'akari' 'catalog'
41	title	0	1	 akari catalog 	'akari' 'catalog'
41	slug	0	2	 akari catalog 	'akari' 'catalog'
41	title	0	2	 akari catalog 	'akari' 'catalog'
53	slug	0	1		
53	slug	0	2		
55	slug	0	1		
55	slug	0	2		
142	slug	0	1		
56	slug	0	1		
56	slug	0	2		
43	slug	0	1	 temp xzbqvoiognclacxxyvdpslfigzmwlgbijarh 	'temp' 'xzbqvoiognclacxxyvdpslfigzmwlgbijarh'
43	title	0	1		
43	slug	0	2	 temp xzbqvoiognclacxxyvdpslfigzmwlgbijarh 	'temp' 'xzbqvoiognclacxxyvdpslfigzmwlgbijarh'
43	title	0	2		
51	slug	0	1	 alien hunting 	'alien' 'hunting'
51	title	0	1	 alien hunting 	'alien' 'hunting'
51	slug	0	2	 alien hunting 	'alien' 'hunting'
51	title	0	2	 alien hunting 	'alien' 'hunting'
142	field	18	1	 blahbitty blah blah 	'blah' 'blahbitty'
142	slug	0	2		
142	field	18	2	 blahbitty blah blah 	'blah' 'blahbitty'
143	slug	0	1		
47	slug	0	1	 temp cvhzapxbptraqzfbykkwjsikueriruymzvbh 	'cvhzapxbptraqzfbykkwjsikueriruymzvbh' 'temp'
47	title	0	1		
47	slug	0	2	 temp cvhzapxbptraqzfbykkwjsikueriruymzvbh 	'cvhzapxbptraqzfbykkwjsikueriruymzvbh' 'temp'
47	title	0	2		
58	slug	0	1		
58	slug	0	2		
59	slug	0	1		
59	slug	0	2		
60	slug	0	1		
60	slug	0	2		
62	slug	0	1		
62	slug	0	2		
63	slug	0	1		
63	slug	0	2		
64	slug	0	1		
64	slug	0	2		
57	slug	0	2	 why aliens 	'aliens' 'why'
57	title	0	2	 why aliens 	'aliens' 'why'
57	slug	0	1	 why aliens 	'aliens' 'why'
57	title	0	1	 why aliens 	'aliens' 'why'
105	slug	0	1		
105	field	18	1	 blah blah 	'blah'
105	slug	0	2		
105	field	18	2	 blah blah 	'blah'
106	slug	0	1		
143	field	38	1	 aliens are kewl 	'aliens' 'are' 'kewl'
143	slug	0	2		
212	field	38	2	 ha 	'ha'
213	slug	0	1		
213	field	37	1	 test test 	'test'
213	slug	0	2		
213	field	37	2	 test test 	'test'
106	field	38	1	 ha 	'ha'
106	slug	0	2		
106	field	38	2	 ha 	'ha'
107	slug	0	1		
107	field	37	1	 test test 	'test'
143	field	38	2	 aliens are kewl 	'aliens' 'are' 'kewl'
144	slug	0	1		
144	field	37	1	 who ha who ha 	'ha' 'who'
144	slug	0	2		
289	field	37	1	 blah blah 	'blah'
71	slug	0	1		
71	slug	0	2		
144	field	37	2	 who ha who ha 	'ha' 'who'
75	slug	0	1		
75	slug	0	2		
76	slug	0	1		
76	slug	0	2		
77	slug	0	1		
77	slug	0	2		
117	filename	0	1	 landmark icon png 	'icon' 'landmark' 'png'
117	extension	0	1	 png 	'png'
117	kind	0	1	 image 	'image'
78	username	0	1	 erosas 	'erosas'
78	firstname	0	1	 eric 	'eric'
78	lastname	0	1	 rosas 	'rosas'
78	fullname	0	1	 eric rosas 	'eric' 'rosas'
78	email	0	1	 ericdrosas gmail com 	'com' 'ericdrosas' 'gmail'
78	slug	0	1		
79	username	0	1	 testtest 	'testtest'
79	firstname	0	1	 testy 	'testy'
79	lastname	0	1	 mctesterson 	'mctesterson'
79	fullname	0	1	 testy mctesterson 	'mctesterson' 'testy'
79	email	0	1	 test test com 	'com' 'test'
79	slug	0	1		
80	username	0	1	 alsoadmin 	'alsoadmin'
80	firstname	0	1	 also 	'also'
80	lastname	0	1	 admin 	'admin'
80	fullname	0	1	 also admin 	'admin' 'also'
80	email	0	1	 also admin com 	'admin' 'also' 'com'
80	slug	0	1		
82	slug	0	1	 tester 	'tester'
82	title	0	1	 tester 	'tester'
82	field	6	1	 star 	'star'
82	field	1	1	 http eric rosas 	'eric' 'http' 'rosas'
82	slug	0	2	 tester 	'tester'
82	title	0	2	 tester 	'tester'
82	field	6	2	 star 	'star'
82	field	1	2	 http eric rosas 	'eric' 'http' 'rosas'
84	slug	0	1	 temp rsvcttdjtmsxoibthovpwyunadbivposekgt 	'rsvcttdjtmsxoibthovpwyunadbivposekgt' 'temp'
84	title	0	1		
84	slug	0	2	 temp rsvcttdjtmsxoibthovpwyunadbivposekgt 	'rsvcttdjtmsxoibthovpwyunadbivposekgt' 'temp'
84	title	0	2		
91	slug	0	1		
91	field	37	1	 test test 	'test'
91	slug	0	2		
91	field	37	2	 test test 	'test'
117	slug	0	1		
180	slug	0	1		
180	field	18	1	 blah blah 	'blah'
180	slug	0	2		
180	field	18	2	 blah blah 	'blah'
181	slug	0	1		
181	field	38	1	 ha 	'ha'
181	slug	0	2		
181	field	38	2	 ha 	'ha'
182	slug	0	1		
100	slug	0	1		
100	field	18	1	 blah blah 	'blah'
100	slug	0	2		
100	field	18	2	 blah blah 	'blah'
101	slug	0	1		
101	field	38	1	 ha 	'ha'
101	slug	0	2		
101	field	38	2	 ha 	'ha'
102	slug	0	1		
102	field	37	1	 test test 	'test'
182	field	37	1	 test test 	'test'
182	slug	0	2		
182	field	37	2	 test test 	'test'
102	slug	0	2		
102	field	37	2	 test test 	'test'
107	slug	0	2		
107	field	37	2	 test test 	'test'
117	title	0	1	 landmark icon 	'icon' 'landmark'
117	filename	0	2	 landmark icon png 	'icon' 'landmark' 'png'
117	extension	0	2	 png 	'png'
117	kind	0	2	 image 	'image'
109	slug	0	1		
109	field	18	1	 blahbitty blah blah 	'blah' 'blahbitty'
109	slug	0	2		
109	field	18	2	 blahbitty blah blah 	'blah' 'blahbitty'
110	slug	0	1		
110	field	38	1	 aliens are kewl 	'aliens' 'are' 'kewl'
110	slug	0	2		
110	field	38	2	 aliens are kewl 	'aliens' 'are' 'kewl'
111	slug	0	1		
111	field	37	1	 who ha who ha 	'ha' 'who'
111	slug	0	2		
111	field	37	2	 who ha who ha 	'ha' 'who'
117	slug	0	2		
117	title	0	2	 landmark icon 	'icon' 'landmark'
65	slug	0	1	 the mothership 	'mothership' 'the'
65	title	0	1	 the mothership 	'mothership' 'the'
65	field	25	1	 such and such 	'and' 'such'
65	field	39	1		
65	slug	0	2	 the mothership 	'mothership' 'the'
65	title	0	2	 the mothership 	'mothership' 'the'
65	field	25	2	 such and such 	'and' 'such'
65	field	39	2		
155	field	18	2	 blah blah 	'blah'
156	slug	0	1		
156	field	38	1	 ha 	'ha'
156	slug	0	2		
156	field	38	2	 ha 	'ha'
157	slug	0	1		
157	field	37	1	 test test 	'test'
157	slug	0	2		
157	field	37	2	 test test 	'test'
189	filename	0	1	 galaxy icon 2021 08 17 203557 bwkx png 	'08' '17' '2021' '203557' 'bwkx' 'galaxy' 'icon' 'png'
189	extension	0	1	 png 	'png'
112	username	0	1	 duder 	'duder'
112	firstname	0	1	 the 	'the'
112	lastname	0	1	 dude 	'dude'
112	fullname	0	1	 the dude 	'dude' 'the'
112	email	0	1	 123 321 123 	'123' '321'
112	slug	0	1		
113	username	0	1	 cloud 	'cloud'
113	firstname	0	1	 madethis 	'madethis'
113	lastname	0	1	 inthecloud 	'inthecloud'
113	fullname	0	1	 madethis inthecloud 	'inthecloud' 'madethis'
113	email	0	1	 1 1 1 	'1'
113	slug	0	1		
189	kind	0	1	 image 	'image'
189	slug	0	1		
189	title	0	1	 galaxy icon 	'galaxy' 'icon'
189	filename	0	2	 galaxy icon 2021 08 17 203557 bwkx png 	'08' '17' '2021' '203557' 'bwkx' 'galaxy' 'icon' 'png'
189	extension	0	2	 png 	'png'
189	kind	0	2	 image 	'image'
189	slug	0	2		
189	title	0	2	 galaxy icon 	'galaxy' 'icon'
22	filename	0	1	 nebula icon png 	'icon' 'nebula' 'png'
22	extension	0	1	 png 	'png'
22	kind	0	1	 image 	'image'
116	filename	0	1	 galaxy icon 2021 08 06 221957 rygb png 	'06' '08' '2021' '221957' 'galaxy' 'icon' 'png' 'rygb'
116	extension	0	1	 png 	'png'
116	kind	0	1	 image 	'image'
116	slug	0	1		
116	title	0	1	 galaxy icon 	'galaxy' 'icon'
116	filename	0	2	 galaxy icon 2021 08 06 221957 rygb png 	'06' '08' '2021' '221957' 'galaxy' 'icon' 'png' 'rygb'
116	extension	0	2	 png 	'png'
116	kind	0	2	 image 	'image'
116	slug	0	2		
116	title	0	2	 galaxy icon 	'galaxy' 'icon'
118	filename	0	1	 nebula icon 2021 08 06 221958 rmuk png 	'06' '08' '2021' '221958' 'icon' 'nebula' 'png' 'rmuk'
118	extension	0	1	 png 	'png'
118	kind	0	1	 image 	'image'
118	slug	0	1		
118	title	0	1	 nebula icon 	'icon' 'nebula'
118	filename	0	2	 nebula icon 2021 08 06 221958 rmuk png 	'06' '08' '2021' '221958' 'icon' 'nebula' 'png' 'rmuk'
118	extension	0	2	 png 	'png'
118	kind	0	2	 image 	'image'
118	slug	0	2		
118	title	0	2	 nebula icon 	'icon' 'nebula'
341	filename	0	1	 galaxy icon 2021 09 23 165649 esmt png 	'09' '165649' '2021' '23' 'esmt' 'galaxy' 'icon' 'png'
119	filename	0	1	 star icon 2021 08 06 221958 gggl png 	'06' '08' '2021' '221958' 'gggl' 'icon' 'png' 'star'
119	extension	0	1	 png 	'png'
119	kind	0	1	 image 	'image'
119	slug	0	1		
119	title	0	1	 star icon 	'icon' 'star'
119	filename	0	2	 star icon 2021 08 06 221958 gggl png 	'06' '08' '2021' '221958' 'gggl' 'icon' 'png' 'star'
119	extension	0	2	 png 	'png'
119	kind	0	2	 image 	'image'
119	slug	0	2		
119	title	0	2	 star icon 	'icon' 'star'
146	slug	0	1		
146	field	18	1	 blah blah 	'blah'
146	slug	0	2		
146	field	18	2	 blah blah 	'blah'
147	slug	0	1		
120	filename	0	1	 transient icon 2021 08 06 221958 jjls png 	'06' '08' '2021' '221958' 'icon' 'jjls' 'png' 'transient'
120	extension	0	1	 png 	'png'
120	kind	0	1	 image 	'image'
120	slug	0	1		
120	title	0	1	 transient icon 	'icon' 'transient'
120	filename	0	2	 transient icon 2021 08 06 221958 jjls png 	'06' '08' '2021' '221958' 'icon' 'jjls' 'png' 'transient'
120	extension	0	2	 png 	'png'
120	kind	0	2	 image 	'image'
120	slug	0	2		
120	title	0	2	 transient icon 	'icon' 'transient'
147	field	38	1	 ha 	'ha'
147	slug	0	2		
147	field	38	2	 ha 	'ha'
148	slug	0	1		
148	field	37	1	 test test 	'test'
202	slug	0	1	 temp qlrbnqfpuvhygmnithxetjribzikkqnrzjqh 	'qlrbnqfpuvhygmnithxetjribzikkqnrzjqh' 'temp'
202	title	0	1		
202	slug	0	2	 temp qlrbnqfpuvhygmnithxetjribzikkqnrzjqh 	'qlrbnqfpuvhygmnithxetjribzikkqnrzjqh' 'temp'
202	title	0	2		
178	slug	0	1	 stars 	'stars'
148	slug	0	2		
148	field	37	2	 test test 	'test'
184	slug	0	1		
178	title	0	1	 stars 	'stars'
178	slug	0	2	 tester 	'tester'
178	title	0	2	 tester 	'tester'
208	slug	0	2	 constellations 	'constellations'
208	title	0	2	 constellations 	'constellations'
208	slug	0	1	 constellations 	'constellations'
208	title	0	1	 constellations 	'constellations'
341	extension	0	1	 png 	'png'
341	kind	0	1	 image 	'image'
341	slug	0	1		
341	title	0	1	 galaxy icon 	'galaxy' 'icon'
341	filename	0	2	 galaxy icon 2021 09 23 165649 esmt png 	'09' '165649' '2021' '23' 'esmt' 'galaxy' 'icon' 'png'
341	extension	0	2	 png 	'png'
341	kind	0	2	 image 	'image'
341	slug	0	2		
341	title	0	2	 galaxy icon 	'galaxy' 'icon'
367	field	40	2		
367	slug	0	2	 temp kzfsfdmzolbqlsiyrjfmiyfuzrazzqbcospi 	'kzfsfdmzolbqlsiyrjfmiyfuzrazzqbcospi' 'temp'
367	title	0	2		
367	slug	0	1	 temp kzfsfdmzolbqlsiyrjfmiyfuzrazzqbcospi 	'kzfsfdmzolbqlsiyrjfmiyfuzrazzqbcospi' 'temp'
260	slug	0	1		
184	field	18	1	 blah blah 	'blah'
184	slug	0	2		
138	slug	0	1	 tours 	'tours'
138	title	0	1	 eric test 	'eric' 'test'
138	slug	0	2	 eric test 	'eric' 'test'
138	title	0	2	 eric test 	'eric' 'test'
184	field	18	2	 blah blah 	'blah'
185	slug	0	1		
185	field	38	1	 ha 	'ha'
185	slug	0	2		
185	field	38	2	 ha 	'ha'
159	slug	0	1		
159	field	18	1	 blah blah 	'blah'
159	slug	0	2		
159	field	18	2	 blah blah 	'blah'
160	slug	0	1		
160	field	38	1	 ha 	'ha'
160	slug	0	2		
160	field	38	2	 ha 	'ha'
161	slug	0	1		
161	field	37	1	 test test 	'test'
161	slug	0	2		
161	field	37	2	 test test 	'test'
186	slug	0	1		
186	field	37	1	 test test 	'test'
186	slug	0	2		
186	field	37	2	 test test 	'test'
260	field	18	1	 blahbitty blah blah 	'blah' 'blahbitty'
260	slug	0	2		
137	filename	0	1	 test png 	'png' 'test'
137	extension	0	1	 png 	'png'
137	kind	0	1	 image 	'image'
137	slug	0	1		
137	title	0	1	 test 	'test'
137	filename	0	2	 test png 	'png' 'test'
137	extension	0	2	 png 	'png'
137	kind	0	2	 image 	'image'
137	slug	0	2		
137	title	0	2	 test 	'test'
260	field	18	2	 blahbitty blah blah 	'blah' 'blahbitty'
261	slug	0	1		
261	field	38	1	 aliens are kewl 	'aliens' 'are' 'kewl'
261	slug	0	2		
261	field	38	2	 aliens are kewl 	'aliens' 'are' 'kewl'
262	slug	0	1		
262	field	37	1	 who ha who ha 	'ha' 'who'
262	slug	0	2		
199	filename	0	1	 astrocat jpeg 	'astrocat' 'jpeg'
262	field	37	2	 who ha who ha 	'ha' 'who'
367	title	0	1		
67	field	35	1	 who ha who ha 	'ha' 'who'
199	extension	0	1	 jpeg 	'jpeg'
199	kind	0	1	 image 	'image'
199	slug	0	1		
199	title	0	1	 astrocat 	'astrocat'
199	filename	0	2	 astrocat jpeg 	'astrocat' 'jpeg'
199	extension	0	2	 jpeg 	'jpeg'
199	kind	0	2	 image 	'image'
199	slug	0	2		
199	title	0	2	 astrocat 	'astrocat'
67	slug	0	2	 the search for aliens 	'aliens' 'for' 'search' 'the'
169	slug	0	1		
169	field	18	1	 blahbitty blah blah 	'blah' 'blahbitty'
169	slug	0	2		
169	field	18	2	 blahbitty blah blah 	'blah' 'blahbitty'
170	slug	0	1		
170	field	38	1	 aliens are kewl 	'aliens' 'are' 'kewl'
170	slug	0	2		
170	field	38	2	 aliens are kewl 	'aliens' 'are' 'kewl'
171	slug	0	1		
171	field	37	1	 who ha who ha 	'ha' 'who'
171	slug	0	2		
171	field	37	2	 who ha who ha 	'ha' 'who'
239	filename	0	1	 astrocat jpeg 	'astrocat' 'jpeg'
177	slug	0	1	 tours 	'tours'
203	slug	0	1	 temp asvbaheenfkzkergormysbgioexollrbeegn 	'asvbaheenfkzkergormysbgioexollrbeegn' 'temp'
203	title	0	1		
203	slug	0	2	 temp asvbaheenfkzkergormysbgioexollrbeegn 	'asvbaheenfkzkergormysbgioexollrbeegn' 'temp'
174	slug	0	1		
174	field	18	1	 blah blah 	'blah'
174	slug	0	2		
174	field	18	2	 blah blah 	'blah'
175	slug	0	1		
175	field	38	1	 ha 	'ha'
175	slug	0	2		
175	field	38	2	 ha 	'ha'
176	slug	0	1		
176	field	37	1	 test test 	'test'
176	slug	0	2		
176	field	37	2	 test test 	'test'
203	title	0	2		
228	filename	0	2	 astrocat jpeg 	'astrocat' 'jpeg'
205	slug	0	2	 planets 	'planets'
205	title	0	2	 planets 	'planets'
228	extension	0	2	 jpeg 	'jpeg'
205	slug	0	1	 planets 	'planets'
205	title	0	1	 planets 	'planets'
228	kind	0	2	 image 	'image'
228	slug	0	2		
228	title	0	2	 astrocat 	'astrocat'
6	slug	0	1		
6	slug	0	2		
228	filename	0	1	 astrocat jpeg 	'astrocat' 'jpeg'
228	extension	0	1	 jpeg 	'jpeg'
228	kind	0	1	 image 	'image'
228	slug	0	1		
228	title	0	1	 astrocat 	'astrocat'
239	extension	0	1	 jpeg 	'jpeg'
138	field	21	1	 test 	'test'
239	kind	0	1	 image 	'image'
268	slug	0	1		
138	field	21	2	 test 	'test'
268	field	18	1	 hip hip 	'hip'
268	slug	0	2		
187	filename	0	1	 star icon 2021 08 17 203539 jurm png 	'08' '17' '2021' '203539' 'icon' 'jurm' 'png' 'star'
187	extension	0	1	 png 	'png'
187	kind	0	1	 image 	'image'
151	slug	0	1		
151	field	18	1	 blahbitty blah blah 	'blah' 'blahbitty'
151	slug	0	2		
151	field	18	2	 blahbitty blah blah 	'blah' 'blahbitty'
152	slug	0	1		
152	field	38	1	 aliens are kewl 	'aliens' 'are' 'kewl'
152	slug	0	2		
152	field	38	2	 aliens are kewl 	'aliens' 'are' 'kewl'
153	slug	0	1		
153	field	37	1	 who ha who ha 	'ha' 'who'
153	slug	0	2		
153	field	37	2	 who ha who ha 	'ha' 'who'
187	slug	0	1		
187	title	0	1	 star icon 	'icon' 'star'
239	slug	0	1		
187	filename	0	2	 star icon 2021 08 17 203539 jurm png 	'08' '17' '2021' '203539' 'icon' 'jurm' 'png' 'star'
187	extension	0	2	 png 	'png'
187	kind	0	2	 image 	'image'
187	slug	0	2		
239	title	0	1	 astrocat 	'astrocat'
187	title	0	2	 star icon 	'icon' 'star'
238	slug	0	2		
19	filename	0	1	 galaxy icon png 	'galaxy' 'icon' 'png'
19	extension	0	1	 png 	'png'
19	kind	0	1	 image 	'image'
19	slug	0	1		
19	title	0	1	 galaxy icon 	'galaxy' 'icon'
19	filename	0	2	 galaxy icon png 	'galaxy' 'icon' 'png'
19	extension	0	2	 png 	'png'
19	kind	0	2	 image 	'image'
19	slug	0	2		
19	title	0	2	 galaxy icon 	'galaxy' 'icon'
238	field	37	2	 eric rosas 	'eric' 'rosas'
238	slug	0	1		
238	field	37	1	 eric rosas 	'eric' 'rosas'
268	field	18	2	 hip hip 	'hip'
269	slug	0	1		
269	field	38	1	 tours are fun 	'are' 'fun' 'tours'
269	slug	0	2		
204	filename	0	2	 screen shot 2021 08 20 at 2 02 37 pm png 	'02' '08' '2' '20' '2021' '37' 'at' 'pm' 'png' 'screen' 'shot'
204	extension	0	2	 png 	'png'
269	field	38	2	 tours are fun 	'are' 'fun' 'tours'
270	slug	0	1		
270	field	37	1	 eric rosas 	'eric' 'rosas'
67	title	0	2	 the search for aliens 	'aliens' 'for' 'search' 'the'
167	filename	0	1	 fo4 pebbles artwork png 	'artwork' 'fo4' 'pebbles' 'png'
167	extension	0	1	 png 	'png'
167	kind	0	1	 image 	'image'
167	slug	0	1		
167	title	0	1	 fo4 pebbles artwork 	'artwork' 'fo4' 'pebbles'
167	filename	0	2	 fo4 pebbles artwork png 	'artwork' 'fo4' 'pebbles' 'png'
167	extension	0	2	 png 	'png'
167	kind	0	2	 image 	'image'
167	slug	0	2		
167	title	0	2	 fo4 pebbles artwork 	'artwork' 'fo4' 'pebbles'
217	filename	0	1	 galaxy icon png 	'galaxy' 'icon' 'png'
217	extension	0	1	 png 	'png'
22	slug	0	1		
217	kind	0	1	 image 	'image'
217	slug	0	1		
217	title	0	1	 galaxy icon 	'galaxy' 'icon'
217	filename	0	2	 galaxy icon png 	'galaxy' 'icon' 'png'
217	extension	0	2	 png 	'png'
217	kind	0	2	 image 	'image'
22	title	0	1	 nebula icon 	'icon' 'nebula'
22	filename	0	2	 nebula icon png 	'icon' 'nebula' 'png'
22	extension	0	2	 png 	'png'
22	kind	0	2	 image 	'image'
22	slug	0	2		
22	title	0	2	 nebula icon 	'icon' 'nebula'
204	kind	0	2	 image 	'image'
204	slug	0	2		
204	title	0	2	 screen shot 2021 08 20 at 2 02 37 pm 	'02' '08' '2' '20' '2021' '37' 'at' 'pm' 'screen' 'shot'
204	filename	0	1	 screen shot 2021 08 20 at 2 02 37 pm png 	'02' '08' '2' '20' '2021' '37' 'at' 'pm' 'png' 'screen' 'shot'
204	extension	0	1	 png 	'png'
204	kind	0	1	 image 	'image'
204	slug	0	1		
204	title	0	1	 screen shot 2021 08 20 at 2 02 37 pm 	'02' '08' '2' '20' '2021' '37' 'at' 'pm' 'screen' 'shot'
217	slug	0	2		
67	field	30	2	 test 	'test'
206	slug	0	2	 nebulae 	'nebulae'
206	title	0	2	 nebulae 	'nebulae'
206	slug	0	1	 nebulae 	'nebulae'
206	title	0	1	 nebulae 	'nebulae'
67	field	55	2	 tester 	'tester'
67	field	21	2	 ourneighborhood 	'ourneighborhood'
67	field	22	2	 ourneighborhood 	'ourneighborhood'
270	slug	0	2		
270	field	37	2	 eric rosas 	'eric' 'rosas'
201	slug	0	1	 temp jadhvficvzmyewnlepqxovbswlgkuwlfpqiv 	'jadhvficvzmyewnlepqxovbswlgkuwlfpqiv' 'temp'
193	filename	0	1	 transient icon 2021 08 17 203634 fvww png 	'08' '17' '2021' '203634' 'fvww' 'icon' 'png' 'transient'
193	extension	0	1	 png 	'png'
193	kind	0	1	 image 	'image'
193	slug	0	1		
193	title	0	1	 transient icon 	'icon' 'transient'
193	filename	0	2	 transient icon 2021 08 17 203634 fvww png 	'08' '17' '2021' '203634' 'fvww' 'icon' 'png' 'transient'
193	extension	0	2	 png 	'png'
193	kind	0	2	 image 	'image'
193	slug	0	2		
193	title	0	2	 transient icon 	'icon' 'transient'
201	title	0	1		
201	slug	0	2	 temp jadhvficvzmyewnlepqxovbswlgkuwlfpqiv 	'jadhvficvzmyewnlepqxovbswlgkuwlfpqiv' 'temp'
201	title	0	2		
239	filename	0	2	 astrocat jpeg 	'astrocat' 'jpeg'
217	title	0	2	 galaxy icon 	'galaxy' 'icon'
26	filename	0	1	 transient icon png 	'icon' 'png' 'transient'
26	extension	0	1	 png 	'png'
26	kind	0	1	 image 	'image'
26	slug	0	1		
26	title	0	1	 transient icon 	'icon' 'transient'
26	filename	0	2	 transient icon png 	'icon' 'png' 'transient'
26	extension	0	2	 png 	'png'
26	kind	0	2	 image 	'image'
26	slug	0	2		
26	title	0	2	 transient icon 	'icon' 'transient'
67	field	33	2		
67	field	34	2		
67	field	17	2	 blahbitty blah blah 	'blah' 'blahbitty'
67	field	32	2		
67	field	31	2	 aliens are kewl 	'aliens' 'are' 'kewl'
67	field	35	2	 who ha who ha 	'ha' 'who'
69	slug	0	1		
368	filename	0	1	 fun goal icon png 	'fun' 'goal' 'icon' 'png'
368	extension	0	1	 png 	'png'
69	field	18	1	 blahbitty blah blah 	'blah' 'blahbitty'
69	slug	0	2		
69	field	18	2	 blahbitty blah blah 	'blah' 'blahbitty'
368	kind	0	1	 image 	'image'
368	slug	0	1		
195	filename	0	1	 fun goal icon 2021 08 17 203657 tbxa png 	'08' '17' '2021' '203657' 'fun' 'goal' 'icon' 'png' 'tbxa'
195	extension	0	1	 png 	'png'
195	kind	0	1	 image 	'image'
195	slug	0	1		
195	title	0	1	 fun goal icon 	'fun' 'goal' 'icon'
195	filename	0	2	 fun goal icon 2021 08 17 203657 tbxa png 	'08' '17' '2021' '203657' 'fun' 'goal' 'icon' 'png' 'tbxa'
195	extension	0	2	 png 	'png'
195	kind	0	2	 image 	'image'
195	slug	0	2		
195	title	0	2	 fun goal icon 	'fun' 'goal' 'icon'
207	slug	0	2	 galaxies 	'galaxies'
207	title	0	2	 galaxies 	'galaxies'
207	slug	0	1	 galaxies 	'galaxies'
207	title	0	1	 galaxies 	'galaxies'
368	title	0	1	 fun goal icon 	'fun' 'goal' 'icon'
115	filename	0	1	 fun goal icon png 	'fun' 'goal' 'icon' 'png'
115	extension	0	1	 png 	'png'
115	kind	0	1	 image 	'image'
115	slug	0	1		
115	title	0	1	 fun goal icon 	'fun' 'goal' 'icon'
115	filename	0	2	 fun goal icon png 	'fun' 'goal' 'icon' 'png'
115	extension	0	2	 png 	'png'
115	kind	0	2	 image 	'image'
115	slug	0	2		
115	title	0	2	 fun goal icon 	'fun' 'goal' 'icon'
239	extension	0	2	 jpeg 	'jpeg'
239	kind	0	2	 image 	'image'
239	slug	0	2		
239	title	0	2	 astrocat 	'astrocat'
72	slug	0	1		
72	field	38	1	 aliens are kewl 	'aliens' 'are' 'kewl'
72	slug	0	2		
177	title	0	1	 test 	'test'
211	slug	0	1		
211	field	18	1	 blah blah 	'blah'
211	slug	0	2		
211	field	18	2	 blah blah 	'blah'
197	filename	0	1	 landmark icon 2021 08 17 203711 mqou png 	'08' '17' '2021' '203711' 'icon' 'landmark' 'mqou' 'png'
197	extension	0	1	 png 	'png'
197	kind	0	1	 image 	'image'
197	slug	0	1		
197	title	0	1	 landmark icon 	'icon' 'landmark'
197	filename	0	2	 landmark icon 2021 08 17 203711 mqou png 	'08' '17' '2021' '203711' 'icon' 'landmark' 'mqou' 'png'
197	extension	0	2	 png 	'png'
197	kind	0	2	 image 	'image'
197	slug	0	2		
197	title	0	2	 landmark icon 	'icon' 'landmark'
212	slug	0	1		
212	field	38	1	 ha 	'ha'
177	field	21	1	 ourneighborhood 	'ourneighborhood'
177	slug	0	2	 test 	'test'
177	title	0	2	 test 	'test'
177	field	21	2	 ourneighborhood 	'ourneighborhood'
368	filename	0	2	 fun goal icon png 	'fun' 'goal' 'icon' 'png'
368	extension	0	2	 png 	'png'
368	kind	0	2	 image 	'image'
368	slug	0	2		
368	title	0	2	 fun goal icon 	'fun' 'goal' 'icon'
72	field	38	2	 aliens are kewl 	'aliens' 'are' 'kewl'
73	slug	0	1		
73	field	37	1	 who ha who ha 	'ha' 'who'
73	slug	0	2		
73	field	37	2	 who ha who ha 	'ha' 'who'
413	slug	0	1		
413	field	18	1	 blahbitty blah blah 	'blah' 'blahbitty'
413	slug	0	2		
413	field	18	2	 blahbitty blah blah 	'blah' 'blahbitty'
414	slug	0	1		
414	field	38	1	 aliens are kewl 	'aliens' 'are' 'kewl'
414	slug	0	2		
344	filename	0	1	 nebula icon 2021 09 23 165707 ykzv png 	'09' '165707' '2021' '23' 'icon' 'nebula' 'png' 'ykzv'
344	extension	0	1	 png 	'png'
344	kind	0	1	 image 	'image'
344	slug	0	1		
344	title	0	1	 nebula icon 	'icon' 'nebula'
344	filename	0	2	 nebula icon 2021 09 23 165707 ykzv png 	'09' '165707' '2021' '23' 'icon' 'nebula' 'png' 'ykzv'
344	extension	0	2	 png 	'png'
344	kind	0	2	 image 	'image'
344	slug	0	2		
344	title	0	2	 nebula icon 	'icon' 'nebula'
216	filename	0	1	 landmark icon png 	'icon' 'landmark' 'png'
216	extension	0	1	 png 	'png'
216	kind	0	1	 image 	'image'
216	slug	0	1		
216	title	0	1	 landmark icon 	'icon' 'landmark'
216	filename	0	2	 landmark icon png 	'icon' 'landmark' 'png'
216	extension	0	2	 png 	'png'
216	kind	0	2	 image 	'image'
216	slug	0	2		
216	title	0	2	 landmark icon 	'icon' 'landmark'
414	field	38	2	 aliens are kewl 	'aliens' 'are' 'kewl'
415	slug	0	1		
415	field	37	1	 who ha who ha 	'ha' 'who'
415	slug	0	2		
415	field	37	2	 who ha who ha 	'ha' 'who'
308	slug	0	1	 this is a cloud astro object 	'a' 'astro' 'cloud' 'is' 'object' 'this'
308	title	0	1	 this is a cloud astro object 	'a' 'astro' 'cloud' 'is' 'object' 'this'
308	field	40	1	 stuff and things 	'and' 'stuff' 'things'
308	slug	0	2	 this is a cloud astro object 	'a' 'astro' 'cloud' 'is' 'object' 'this'
308	title	0	2	 this is a cloud astro object 	'a' 'astro' 'cloud' 'is' 'object' 'this'
308	field	40	2	 stuff and things 	'and' 'stuff' 'things'
445	filename	0	2	 eric rosas png 	'eric' 'png' 'rosas'
445	extension	0	2	 png 	'png'
445	kind	0	2	 image 	'image'
445	slug	0	2		
445	title	0	2	 eric rosas 	'eric' 'rosas'
445	filename	0	1	 eric rosas png 	'eric' 'png' 'rosas'
445	extension	0	1	 png 	'png'
445	kind	0	1	 image 	'image'
8	slug	0	2	 stars catalog 	'catalog' 'stars'
8	title	0	2	 stars catalog 	'catalog' 'stars'
8	field	1	2	 https storage googleapis com hips data catalog goals 	'catalog' 'com' 'data' 'goals' 'googleapis' 'hips' 'https' 'storage'
8	slug	0	1	 goals 	'goals'
8	title	0	1	 goal 	'goal'
8	field	1	1	 https storage googleapis com hips data catalog goals 	'catalog' 'com' 'data' 'goals' 'googleapis' 'hips' 'https' 'storage'
445	slug	0	1		
445	title	0	1	 eric rosas 	'eric' 'rosas'
359	filename	0	1	 nebula icon 2021 09 28 234534 tnca png 	'09' '2021' '234534' '28' 'icon' 'nebula' 'png' 'tnca'
359	extension	0	1	 png 	'png'
359	kind	0	1	 image 	'image'
359	slug	0	1		
359	title	0	1	 nebula icon 	'icon' 'nebula'
359	filename	0	2	 nebula icon 2021 09 28 234534 tnca png 	'09' '2021' '234534' '28' 'icon' 'nebula' 'png' 'tnca'
359	extension	0	2	 png 	'png'
359	kind	0	2	 image 	'image'
359	slug	0	2		
359	title	0	2	 nebula icon 	'icon' 'nebula'
374	field	1	1	 http test path 	'http' 'path' 'test'
374	field	1	2	 http test path 	'http' 'path' 'test'
374	slug	0	2	 test cat 	'cat' 'test'
374	title	0	2	 test cat 	'cat' 'test'
374	slug	0	1	 test cat 	'cat' 'test'
374	title	0	1	 test cat 	'cat' 'test'
379	field	1	2		
95	slug	0	1	 tour de force 	'de' 'force' 'tour'
95	title	0	1	 tour de forcez 	'de' 'forcez' 'tour'
95	field	30	1	 test 	'test'
95	field	55	1	 stars 	'stars'
95	field	21	1	 ourneighborhood 	'ourneighborhood'
214	filename	0	1	 nebula icon png 	'icon' 'nebula' 'png'
214	extension	0	1	 png 	'png'
214	kind	0	1	 image 	'image'
95	field	22	1	 ourneighborhood 	'ourneighborhood'
95	field	33	1	 first you tour de force 	'de' 'first' 'force' 'tour' 'you'
95	field	34	1	 then you tour de nap 	'de' 'nap' 'then' 'tour' 'you'
95	field	17	1	 blah blah 	'blah'
95	field	32	1	 did you know tours are tours 	'are' 'did' 'know' 'tours' 'you'
95	field	31	1	 ha 	'ha'
214	slug	0	1		
95	field	35	1	 test test 	'test'
95	slug	0	2	 tour de force 	'de' 'force' 'tour'
276	slug	0	1		
276	field	18	1	 hip hip 	'hip'
276	slug	0	2		
276	field	18	2	 hip hip 	'hip'
277	slug	0	1		
277	field	38	1	 tours are fun 	'are' 'fun' 'tours'
277	slug	0	2		
277	field	38	2	 tours are fun 	'are' 'fun' 'tours'
278	slug	0	1		
278	field	37	1	 eric rosas 	'eric' 'rosas'
278	slug	0	2		
278	field	37	2	 eric rosas 	'eric' 'rosas'
95	title	0	2	 tour de force 	'de' 'force' 'tour'
95	field	30	2	 test 	'test'
95	field	55	2	 tester 	'tester'
95	field	21	2	 ourneighborhood 	'ourneighborhood'
214	title	0	1	 nebula icon 	'icon' 'nebula'
214	filename	0	2	 nebula icon png 	'icon' 'nebula' 'png'
95	field	22	2	 ourneighborhood 	'ourneighborhood'
95	field	33	2	 first you tour de force 	'de' 'first' 'force' 'tour' 'you'
95	field	34	2	 then you tour de nap 	'de' 'nap' 'then' 'tour' 'you'
95	field	17	2	 blah blah 	'blah'
95	field	32	2	 did you know tours are tours 	'are' 'did' 'know' 'tours' 'you'
312	slug	0	1		
312	field	18	1	 clo ud 	'clo' 'ud'
214	extension	0	2	 png 	'png'
214	kind	0	2	 image 	'image'
214	slug	0	2		
244	slug	0	1		
244	field	18	1	 hip hip 	'hip'
244	slug	0	2		
244	field	18	2	 hip hip 	'hip'
245	slug	0	1		
245	field	38	1	 tours are fun 	'are' 'fun' 'tours'
245	slug	0	2		
245	field	38	2	 tours are fun 	'are' 'fun' 'tours'
246	slug	0	1		
246	field	37	1	 eric rosas 	'eric' 'rosas'
246	slug	0	2		
246	field	37	2	 eric rosas 	'eric' 'rosas'
240	slug	0	1	 whoa 	'whoa'
240	title	0	1	 whoa 	'whoa'
240	field	40	1	 homer simpson 	'homer' 'simpson'
240	slug	0	2	 whoa 	'whoa'
240	title	0	2	 whoa 	'whoa'
240	field	40	2	 homer simpson 	'homer' 'simpson'
312	slug	0	2		
312	field	18	2	 clo ud 	'clo' 'ud'
313	slug	0	1		
313	field	38	1	 cloudy cloud 	'cloud' 'cloudy'
313	slug	0	2		
313	field	38	2	 cloudy cloud 	'cloud' 'cloudy'
314	slug	0	1		
314	field	37	1	 test 	'test'
314	slug	0	2		
314	field	37	2	 test 	'test'
293	slug	0	2		
293	field	37	2	 blah blah 	'blah'
293	slug	0	1		
293	field	37	1	 blah blah 	'blah'
214	title	0	2	 nebula icon 	'icon' 'nebula'
95	field	31	2	 ha 	'ha'
279	field	35	1	 blah blah 	'blah'
95	field	35	2	 test test 	'test'
96	slug	0	1		
96	field	18	1	 blah blah 	'blah'
280	filename	0	2	 astrocat 2021 09 08 175728 uomq jpeg 	'08' '09' '175728' '2021' 'astrocat' 'jpeg' 'uomq'
280	extension	0	2	 jpeg 	'jpeg'
280	kind	0	2	 image 	'image'
280	slug	0	2		
280	title	0	2	 astrocat 	'astrocat'
280	filename	0	1	 astrocat 2021 09 08 175728 uomq jpeg 	'08' '09' '175728' '2021' 'astrocat' 'jpeg' 'uomq'
280	extension	0	1	 jpeg 	'jpeg'
280	kind	0	1	 image 	'image'
280	slug	0	1		
280	title	0	1	 astrocat 	'astrocat'
96	slug	0	2		
96	field	18	2	 blah blah 	'blah'
97	slug	0	1		
97	field	38	1	 ha 	'ha'
97	slug	0	2		
97	field	38	2	 ha 	'ha'
215	filename	0	1	 fun goal icon png 	'fun' 'goal' 'icon' 'png'
215	extension	0	1	 png 	'png'
215	kind	0	1	 image 	'image'
215	slug	0	1		
215	title	0	1	 fun goal icon 	'fun' 'goal' 'icon'
215	filename	0	2	 fun goal icon png 	'fun' 'goal' 'icon' 'png'
215	extension	0	2	 png 	'png'
215	kind	0	2	 image 	'image'
215	slug	0	2		
215	title	0	2	 fun goal icon 	'fun' 'goal' 'icon'
98	slug	0	1		
98	field	37	1	 test test 	'test'
279	field	30	2	 test 	'test'
279	field	55	2	 planets 	'planets'
279	field	21	2	 astrocat 	'astrocat'
279	field	22	2	 astrocat 	'astrocat'
279	field	33	2	 temp temp 	'temp'
279	field	34	2	 just a test 	'a' 'just' 'test'
279	field	17	2	 hoo ha 	'ha' 'hoo'
279	field	32	2	 ttt 	'ttt'
279	field	31	2	 gnar 	'gnar'
279	field	35	2	 blah blah 	'blah'
295	slug	0	1		
295	field	18	1	 hoo ha 	'ha' 'hoo'
295	slug	0	2		
295	field	18	2	 hoo ha 	'ha' 'hoo'
296	slug	0	1		
296	field	38	1	 gnar 	'gnar'
296	slug	0	2		
296	field	38	2	 gnar 	'gnar'
297	slug	0	1		
297	field	37	1	 blah blah 	'blah'
297	slug	0	2		
297	field	37	2	 blah blah 	'blah'
279	slug	0	1	 this is a brand new tour 	'a' 'brand' 'is' 'new' 'this' 'tour'
279	title	0	1	 this is a brand new tour 	'a' 'brand' 'is' 'new' 'this' 'tour'
279	slug	0	2	 this is a brand new tour 	'a' 'brand' 'is' 'new' 'this' 'tour'
279	title	0	2	 this is a brand new tour 	'a' 'brand' 'is' 'new' 'this' 'tour'
98	slug	0	2		
98	field	37	2	 test test 	'test'
421	slug	0	1		
421	field	18	1	 blah blah 	'blah'
421	slug	0	2		
421	field	18	2	 blah blah 	'blah'
422	slug	0	1		
422	field	38	1	 ha 	'ha'
422	slug	0	2		
422	field	38	2	 ha 	'ha'
423	slug	0	1		
423	field	37	1	 test test 	'test'
376	filename	0	1	 star icon 2021 10 01 203317 odxg png 	'01' '10' '2021' '203317' 'icon' 'odxg' 'png' 'star'
376	extension	0	1	 png 	'png'
376	kind	0	1	 image 	'image'
279	field	22	1	 astrocat 	'astrocat'
376	slug	0	1		
376	title	0	1	 star icon 	'icon' 'star'
347	filename	0	1	 transient icon 2021 09 23 165723 wocf png 	'09' '165723' '2021' '23' 'icon' 'png' 'transient' 'wocf'
347	extension	0	1	 png 	'png'
347	kind	0	1	 image 	'image'
347	slug	0	1		
347	title	0	1	 transient icon 	'icon' 'transient'
347	filename	0	2	 transient icon 2021 09 23 165723 wocf png 	'09' '165723' '2021' '23' 'icon' 'png' 'transient' 'wocf'
320	filename	0	1	 fun goal icon 2021 09 14 223121 rjpb png 	'09' '14' '2021' '223121' 'fun' 'goal' 'icon' 'png' 'rjpb'
320	extension	0	1	 png 	'png'
320	kind	0	1	 image 	'image'
320	slug	0	1		
320	title	0	1	 fun goal icon 	'fun' 'goal' 'icon'
320	filename	0	2	 fun goal icon 2021 09 14 223121 rjpb png 	'09' '14' '2021' '223121' 'fun' 'goal' 'icon' 'png' 'rjpb'
320	extension	0	2	 png 	'png'
320	kind	0	2	 image 	'image'
320	slug	0	2		
279	field	33	1	 temp temp 	'temp'
279	field	34	1	 just a test 	'a' 'just' 'test'
320	title	0	2	 fun goal icon 	'fun' 'goal' 'icon'
347	extension	0	2	 png 	'png'
347	kind	0	2	 image 	'image'
347	slug	0	2		
347	title	0	2	 transient icon 	'icon' 'transient'
321	filename	0	1	 galaxy icon 2021 09 14 223128 bgdu png 	'09' '14' '2021' '223128' 'bgdu' 'galaxy' 'icon' 'png'
321	extension	0	1	 png 	'png'
376	filename	0	2	 star icon 2021 10 01 203317 odxg png 	'01' '10' '2021' '203317' 'icon' 'odxg' 'png' 'star'
376	extension	0	2	 png 	'png'
376	kind	0	2	 image 	'image'
376	slug	0	2		
376	title	0	2	 star icon 	'icon' 'star'
379	slug	0	2	 temp enzpusapxwopnnkpsqpjkpjcckhqtkiidcsa 	'enzpusapxwopnnkpsqpjkpjcckhqtkiidcsa' 'temp'
379	title	0	2		
379	slug	0	1	 temp enzpusapxwopnnkpsqpjkpjcckhqtkiidcsa 	'enzpusapxwopnnkpsqpjkpjcckhqtkiidcsa' 'temp'
379	title	0	1		
321	kind	0	1	 image 	'image'
321	slug	0	1		
321	title	0	1	 galaxy icon 	'galaxy' 'icon'
307	slug	0	2		
307	field	37	2	 test 	'test'
307	slug	0	1		
307	field	37	1	 test 	'test'
423	slug	0	2		
423	field	37	2	 test test 	'test'
321	filename	0	2	 galaxy icon 2021 09 14 223128 bgdu png 	'09' '14' '2021' '223128' 'bgdu' 'galaxy' 'icon' 'png'
321	extension	0	2	 png 	'png'
321	kind	0	2	 image 	'image'
321	slug	0	2		
321	title	0	2	 galaxy icon 	'galaxy' 'icon'
353	filename	0	1	 star icon 2021 09 28 234000 gtpe png 	'09' '2021' '234000' '28' 'gtpe' 'icon' 'png' 'star'
353	extension	0	1	 png 	'png'
353	kind	0	1	 image 	'image'
322	filename	0	1	 landmark icon 2021 09 14 223134 luqk png 	'09' '14' '2021' '223134' 'icon' 'landmark' 'luqk' 'png'
322	extension	0	1	 png 	'png'
322	kind	0	1	 image 	'image'
322	slug	0	1		
322	title	0	1	 landmark icon 	'icon' 'landmark'
322	filename	0	2	 landmark icon 2021 09 14 223134 luqk png 	'09' '14' '2021' '223134' 'icon' 'landmark' 'luqk' 'png'
322	extension	0	2	 png 	'png'
322	kind	0	2	 image 	'image'
322	slug	0	2		
322	title	0	2	 landmark icon 	'icon' 'landmark'
284	slug	0	2		
284	field	18	2	 hoo ha 	'ha' 'hoo'
284	slug	0	1		
284	field	18	1	 hoo ha 	'ha' 'hoo'
279	field	17	1	 hoo ha 	'ha' 'hoo'
279	field	32	1	 ttt 	'ttt'
286	slug	0	2		
286	field	38	2	 gnar 	'gnar'
286	slug	0	1		
286	field	38	1	 gnar 	'gnar'
279	field	31	1	 gnar 	'gnar'
323	filename	0	1	 nebula icon 2021 09 14 223140 whay png 	'09' '14' '2021' '223140' 'icon' 'nebula' 'png' 'whay'
323	extension	0	1	 png 	'png'
323	kind	0	1	 image 	'image'
323	slug	0	1		
323	title	0	1	 nebula icon 	'icon' 'nebula'
323	filename	0	2	 nebula icon 2021 09 14 223140 whay png 	'09' '14' '2021' '223140' 'icon' 'nebula' 'png' 'whay'
323	extension	0	2	 png 	'png'
323	kind	0	2	 image 	'image'
323	slug	0	2		
323	title	0	2	 nebula icon 	'icon' 'nebula'
424	filename	0	2	 screen shot 2021 10 07 at 10 58 24 am png 	'07' '10' '2021' '24' '58' 'am' 'at' 'png' 'screen' 'shot'
424	extension	0	2	 png 	'png'
424	kind	0	2	 image 	'image'
424	slug	0	2		
424	title	0	2	 screen shot 2021 10 07 at 10 58 24 am 	'07' '10' '2021' '24' '58' 'am' 'at' 'screen' 'shot'
424	filename	0	1	 screen shot 2021 10 07 at 10 58 24 am png 	'07' '10' '2021' '24' '58' 'am' 'at' 'png' 'screen' 'shot'
424	extension	0	1	 png 	'png'
424	kind	0	1	 image 	'image'
424	slug	0	1		
424	title	0	1	 screen shot 2021 10 07 at 10 58 24 am 	'07' '10' '2021' '24' '58' 'am' 'at' 'screen' 'shot'
218	filename	0	1	 transient icon png 	'icon' 'png' 'transient'
218	extension	0	1	 png 	'png'
218	kind	0	1	 image 	'image'
218	slug	0	1		
218	title	0	1	 transient icon 	'icon' 'transient'
324	filename	0	1	 star icon 2021 09 14 223147 umzx png 	'09' '14' '2021' '223147' 'icon' 'png' 'star' 'umzx'
324	extension	0	1	 png 	'png'
324	kind	0	1	 image 	'image'
324	slug	0	1		
324	title	0	1	 star icon 	'icon' 'star'
324	filename	0	2	 star icon 2021 09 14 223147 umzx png 	'09' '14' '2021' '223147' 'icon' 'png' 'star' 'umzx'
324	extension	0	2	 png 	'png'
324	kind	0	2	 image 	'image'
324	slug	0	2		
324	title	0	2	 star icon 	'icon' 'star'
218	filename	0	2	 transient icon png 	'icon' 'png' 'transient'
218	extension	0	2	 png 	'png'
218	kind	0	2	 image 	'image'
218	slug	0	2		
218	title	0	2	 transient icon 	'icon' 'transient'
443	filename	0	2	 cutout png 	'cutout' 'png'
353	slug	0	1		
353	title	0	1	 star icon 	'icon' 'star'
353	filename	0	2	 star icon 2021 09 28 234000 gtpe png 	'09' '2021' '234000' '28' 'gtpe' 'icon' 'png' 'star'
353	extension	0	2	 png 	'png'
353	kind	0	2	 image 	'image'
353	slug	0	2		
353	title	0	2	 star icon 	'icon' 'star'
443	extension	0	2	 png 	'png'
443	kind	0	2	 image 	'image'
325	filename	0	1	 transient icon 2021 09 14 223152 fiwl png 	'09' '14' '2021' '223152' 'fiwl' 'icon' 'png' 'transient'
325	extension	0	1	 png 	'png'
325	kind	0	1	 image 	'image'
325	slug	0	1		
325	title	0	1	 transient icon 	'icon' 'transient'
325	filename	0	2	 transient icon 2021 09 14 223152 fiwl png 	'09' '14' '2021' '223152' 'fiwl' 'icon' 'png' 'transient'
325	extension	0	2	 png 	'png'
325	kind	0	2	 image 	'image'
325	slug	0	2		
325	title	0	2	 transient icon 	'icon' 'transient'
443	slug	0	2		
443	title	0	2	 cutout 	'cutout'
443	filename	0	1	 cutout png 	'cutout' 'png'
443	extension	0	1	 png 	'png'
443	kind	0	1	 image 	'image'
443	slug	0	1		
443	title	0	1	 cutout 	'cutout'
356	filename	0	1	 galaxy icon 2021 09 28 234211 yspn png 	'09' '2021' '234211' '28' 'galaxy' 'icon' 'png' 'yspn'
356	extension	0	1	 png 	'png'
356	kind	0	1	 image 	'image'
356	slug	0	1		
356	title	0	1	 galaxy icon 	'galaxy' 'icon'
356	filename	0	2	 galaxy icon 2021 09 28 234211 yspn png 	'09' '2021' '234211' '28' 'galaxy' 'icon' 'png' 'yspn'
356	extension	0	2	 png 	'png'
356	kind	0	2	 image 	'image'
356	slug	0	2		
356	title	0	2	 galaxy icon 	'galaxy' 'icon'
45	slug	0	1	 control healpix catalog 	'catalog' 'control' 'healpix'
45	title	0	1	 control healpix catalog 	'catalog' 'control' 'healpix'
45	field	1	1	 http alasky u strasbg fr dss dsscolor 	'alasky' 'dss' 'dsscolor' 'fr' 'http' 'strasbg' 'u'
45	slug	0	2	 control healpix catalog 	'catalog' 'control' 'healpix'
45	title	0	2	 control healpix catalog 	'catalog' 'control' 'healpix'
45	field	1	2	 http alasky u strasbg fr dss dsscolor 	'alasky' 'dss' 'dsscolor' 'fr' 'http' 'strasbg' 'u'
227	slug	0	1	 another fine tour 	'another' 'fine' 'tour'
227	title	0	1	 another fine tour 	'another' 'fine' 'tour'
227	field	30	1	 test 	'test'
227	field	55	1	 planets 	'planets'
227	field	21	1	 screen shot 2021 10 07 at 10 58 24 am 	'07' '10' '2021' '24' '58' 'am' 'at' 'screen' 'shot'
227	field	22	1	 screen shot 2021 10 07 at 10 57 36 am 	'07' '10' '2021' '36' '57' 'am' 'at' 'screen' 'shot'
227	field	33	1	 yet another fine tour 	'another' 'fine' 'tour' 'yet'
227	field	34	1	 hooray 	'hooray'
227	field	17	1	 hip hip 	'hip'
227	field	32	1	 did you know 	'did' 'know' 'you'
227	field	31	1	 tours are fun 	'are' 'fun' 'tours'
227	field	35	1	 eric rosas 	'eric' 'rosas'
227	slug	0	2	 another fine tour 	'another' 'fine' 'tour'
227	title	0	2	 another fine tour 	'another' 'fine' 'tour'
380	filename	0	1	 ourneighborhood jpg 	'jpg' 'ourneighborhood'
380	extension	0	1	 jpg 	'jpg'
380	kind	0	1	 image 	'image'
380	slug	0	1		
380	title	0	1	 ourneighborhood 	'ourneighborhood'
338	filename	0	1	 star icon 2021 09 23 165629 vtwn png 	'09' '165629' '2021' '23' 'icon' 'png' 'star' 'vtwn'
338	extension	0	1	 png 	'png'
338	kind	0	1	 image 	'image'
338	slug	0	1		
338	title	0	1	 star icon 	'icon' 'star'
338	filename	0	2	 star icon 2021 09 23 165629 vtwn png 	'09' '165629' '2021' '23' 'icon' 'png' 'star' 'vtwn'
338	extension	0	2	 png 	'png'
338	kind	0	2	 image 	'image'
338	slug	0	2		
338	title	0	2	 star icon 	'icon' 'star'
350	filename	0	1	 landmark icon 2021 09 23 165755 airh png 	'09' '165755' '2021' '23' 'airh' 'icon' 'landmark' 'png'
350	extension	0	1	 png 	'png'
350	kind	0	1	 image 	'image'
350	slug	0	1		
350	title	0	1	 landmark icon 	'icon' 'landmark'
219	filename	0	1	 star icon png 	'icon' 'png' 'star'
219	extension	0	1	 png 	'png'
219	kind	0	1	 image 	'image'
219	slug	0	1		
219	title	0	1	 star icon 	'icon' 'star'
219	filename	0	2	 star icon png 	'icon' 'png' 'star'
219	extension	0	2	 png 	'png'
219	kind	0	2	 image 	'image'
219	slug	0	2		
219	title	0	2	 star icon 	'icon' 'star'
380	filename	0	2	 ourneighborhood jpg 	'jpg' 'ourneighborhood'
380	extension	0	2	 jpg 	'jpg'
380	kind	0	2	 image 	'image'
380	slug	0	2		
380	title	0	2	 ourneighborhood 	'ourneighborhood'
227	field	30	2	 test 	'test'
350	filename	0	2	 landmark icon 2021 09 23 165755 airh png 	'09' '165755' '2021' '23' 'airh' 'icon' 'landmark' 'png'
350	extension	0	2	 png 	'png'
350	kind	0	2	 image 	'image'
350	slug	0	2		
350	title	0	2	 landmark icon 	'icon' 'landmark'
227	field	55	2	 planets 	'planets'
227	field	21	2	 screen shot 2021 10 07 at 10 58 24 am 	'07' '10' '2021' '24' '58' 'am' 'at' 'screen' 'shot'
227	field	22	2	 screen shot 2021 10 07 at 10 57 36 am 	'07' '10' '2021' '36' '57' 'am' 'at' 'screen' 'shot'
227	field	33	2	 yet another fine tour 	'another' 'fine' 'tour' 'yet'
227	field	34	2	 hooray 	'hooray'
227	field	17	2	 hip hip 	'hip'
227	field	32	2	 did you know 	'did' 'know' 'you'
382	filename	0	1	 star icon 2021 10 08 224004 gyby png 	'08' '10' '2021' '224004' 'gyby' 'icon' 'png' 'star'
362	filename	0	1	 transient icon 2021 09 28 234840 bxwy png 	'09' '2021' '234840' '28' 'bxwy' 'icon' 'png' 'transient'
362	extension	0	1	 png 	'png'
362	kind	0	1	 image 	'image'
362	slug	0	1		
362	title	0	1	 transient icon 	'icon' 'transient'
362	filename	0	2	 transient icon 2021 09 28 234840 bxwy png 	'09' '2021' '234840' '28' 'bxwy' 'icon' 'png' 'transient'
362	extension	0	2	 png 	'png'
362	kind	0	2	 image 	'image'
362	slug	0	2		
362	title	0	2	 transient icon 	'icon' 'transient'
382	extension	0	1	 png 	'png'
382	kind	0	1	 image 	'image'
382	slug	0	1		
365	filename	0	1	 landmark icon 2021 09 28 235159 siwt png 	'09' '2021' '235159' '28' 'icon' 'landmark' 'png' 'siwt'
365	extension	0	1	 png 	'png'
365	kind	0	1	 image 	'image'
365	slug	0	1		
365	title	0	1	 landmark icon 	'icon' 'landmark'
365	filename	0	2	 landmark icon 2021 09 28 235159 siwt png 	'09' '2021' '235159' '28' 'icon' 'landmark' 'png' 'siwt'
365	extension	0	2	 png 	'png'
365	kind	0	2	 image 	'image'
365	slug	0	2		
365	title	0	2	 landmark icon 	'icon' 'landmark'
382	title	0	1	 star icon 	'icon' 'star'
382	filename	0	2	 star icon 2021 10 08 224004 gyby png 	'08' '10' '2021' '224004' 'gyby' 'icon' 'png' 'star'
382	extension	0	2	 png 	'png'
382	kind	0	2	 image 	'image'
382	slug	0	2		
382	title	0	2	 star icon 	'icon' 'star'
227	field	31	2	 tours are fun 	'are' 'fun' 'tours'
227	field	35	2	 eric rosas 	'eric' 'rosas'
232	slug	0	1		
232	field	18	1	 hip hip 	'hip'
232	slug	0	2		
370	filename	0	1	 star icon png 	'icon' 'png' 'star'
370	extension	0	1	 png 	'png'
370	kind	0	1	 image 	'image'
370	slug	0	1		
370	title	0	1	 star icon 	'icon' 'star'
370	filename	0	2	 star icon png 	'icon' 'png' 'star'
370	extension	0	2	 png 	'png'
370	kind	0	2	 image 	'image'
370	slug	0	2		
370	title	0	2	 star icon 	'icon' 'star'
232	field	18	2	 hip hip 	'hip'
236	slug	0	1		
236	field	38	1	 tours are fun 	'are' 'fun' 'tours'
236	slug	0	2		
236	field	38	2	 tours are fun 	'are' 'fun' 'tours'
242	slug	0	1		
242	field	37	1	 eric rosas 	'eric' 'rosas'
242	slug	0	2		
242	field	37	2	 eric rosas 	'eric' 'rosas'
430	slug	0	1		
430	field	18	1	 hip hip 	'hip'
384	filename	0	1	 galaxy icon 2021 10 08 224037 ojuo png 	'08' '10' '2021' '224037' 'galaxy' 'icon' 'ojuo' 'png'
384	extension	0	1	 png 	'png'
384	kind	0	1	 image 	'image'
384	slug	0	1		
384	title	0	1	 galaxy icon 	'galaxy' 'icon'
384	filename	0	2	 galaxy icon 2021 10 08 224037 ojuo png 	'08' '10' '2021' '224037' 'galaxy' 'icon' 'ojuo' 'png'
384	extension	0	2	 png 	'png'
384	kind	0	2	 image 	'image'
384	slug	0	2		
384	title	0	2	 galaxy icon 	'galaxy' 'icon'
430	slug	0	2		
430	field	18	2	 hip hip 	'hip'
431	slug	0	1		
431	field	38	1	 tours are fun 	'are' 'fun' 'tours'
431	slug	0	2		
373	filename	0	1	 galaxy icon png 	'galaxy' 'icon' 'png'
373	extension	0	1	 png 	'png'
373	kind	0	1	 image 	'image'
373	slug	0	1		
373	title	0	1	 galaxy icon 	'galaxy' 'icon'
373	filename	0	2	 galaxy icon png 	'galaxy' 'icon' 'png'
373	extension	0	2	 png 	'png'
373	kind	0	2	 image 	'image'
373	slug	0	2		
373	title	0	2	 galaxy icon 	'galaxy' 'icon'
23	slug	0	1	 galaxy 	'galaxy'
23	title	0	1	 galaxy 	'galaxy'
23	field	1	1	 https storage googleapis com hips data catalog galaxies 	'catalog' 'com' 'data' 'galaxies' 'googleapis' 'hips' 'https' 'storage'
23	slug	0	2	 nebulae catalog 	'catalog' 'nebulae'
23	title	0	2	 nebulae catalog 	'catalog' 'nebulae'
23	field	1	2	 https storage googleapis com hips data catalog galaxies 	'catalog' 'com' 'data' 'galaxies' 'googleapis' 'hips' 'https' 'storage'
431	field	38	2	 tours are fun 	'are' 'fun' 'tours'
387	filename	0	1	 nebula icon 2021 10 08 224227 zkks png 	'08' '10' '2021' '224227' 'icon' 'nebula' 'png' 'zkks'
387	extension	0	1	 png 	'png'
387	kind	0	1	 image 	'image'
387	slug	0	1		
387	title	0	1	 nebula icon 	'icon' 'nebula'
387	filename	0	2	 nebula icon 2021 10 08 224227 zkks png 	'08' '10' '2021' '224227' 'icon' 'nebula' 'png' 'zkks'
387	extension	0	2	 png 	'png'
387	kind	0	2	 image 	'image'
387	slug	0	2		
387	title	0	2	 nebula icon 	'icon' 'nebula'
369	filename	0	2	 nebula icon png 	'icon' 'nebula' 'png'
369	extension	0	2	 png 	'png'
369	kind	0	2	 image 	'image'
369	slug	0	2		
369	title	0	2	 nebula icon 	'icon' 'nebula'
369	filename	0	1	 nebula icon png 	'icon' 'nebula' 'png'
369	extension	0	1	 png 	'png'
369	kind	0	1	 image 	'image'
369	slug	0	1		
369	title	0	1	 nebula icon 	'icon' 'nebula'
27	slug	0	1	 nebula 	'nebula'
27	title	0	1	 nebula 	'nebula'
27	field	1	1	 https storage googleapis com hips data catalog nebulae 	'catalog' 'com' 'data' 'googleapis' 'hips' 'https' 'nebulae' 'storage'
27	slug	0	2	 transients catalog 	'catalog' 'transients'
27	title	0	2	 transients catalog 	'catalog' 'transients'
27	field	1	2	 https storage googleapis com hips data catalog nebulae 	'catalog' 'com' 'data' 'googleapis' 'hips' 'https' 'nebulae' 'storage'
390	filename	0	1	 transient icon 2021 10 08 224247 ykoz png 	'08' '10' '2021' '224247' 'icon' 'png' 'transient' 'ykoz'
390	extension	0	1	 png 	'png'
390	kind	0	1	 image 	'image'
390	slug	0	1		
390	title	0	1	 transient icon 	'icon' 'transient'
390	filename	0	2	 transient icon 2021 10 08 224247 ykoz png 	'08' '10' '2021' '224247' 'icon' 'png' 'transient' 'ykoz'
390	extension	0	2	 png 	'png'
390	kind	0	2	 image 	'image'
390	slug	0	2		
390	title	0	2	 transient icon 	'icon' 'transient'
432	slug	0	1		
432	field	37	1	 eric rosas 	'eric' 'rosas'
432	slug	0	2		
432	field	37	2	 eric rosas 	'eric' 'rosas'
372	filename	0	1	 transient icon png 	'icon' 'png' 'transient'
372	extension	0	1	 png 	'png'
372	kind	0	1	 image 	'image'
372	slug	0	1		
372	title	0	1	 transient icon 	'icon' 'transient'
372	filename	0	2	 transient icon png 	'icon' 'png' 'transient'
372	extension	0	2	 png 	'png'
372	kind	0	2	 image 	'image'
372	slug	0	2		
372	title	0	2	 transient icon 	'icon' 'transient'
31	slug	0	1	 transient 	'transient'
31	title	0	1	 transient 	'transient'
31	field	1	1	 https storage googleapis com hips data catalog transients 	'catalog' 'com' 'data' 'googleapis' 'hips' 'https' 'storage' 'transients'
31	slug	0	2	 goals catalog 	'catalog' 'goals'
31	title	0	2	 goals catalog 	'catalog' 'goals'
31	field	1	2	 https storage googleapis com hips data catalog transients 	'catalog' 'com' 'data' 'googleapis' 'hips' 'https' 'storage' 'transients'
393	filename	0	1	 landmark icon 2021 10 08 224309 lytq png 	'08' '10' '2021' '224309' 'icon' 'landmark' 'lytq' 'png'
393	extension	0	1	 png 	'png'
393	kind	0	1	 image 	'image'
393	slug	0	1		
393	title	0	1	 landmark icon 	'icon' 'landmark'
393	filename	0	2	 landmark icon 2021 10 08 224309 lytq png 	'08' '10' '2021' '224309' 'icon' 'landmark' 'lytq' 'png'
393	extension	0	2	 png 	'png'
393	kind	0	2	 image 	'image'
393	slug	0	2		
393	title	0	2	 landmark icon 	'icon' 'landmark'
371	filename	0	2	 landmark icon png 	'icon' 'landmark' 'png'
371	extension	0	2	 png 	'png'
371	kind	0	2	 image 	'image'
371	slug	0	2		
371	title	0	2	 landmark icon 	'icon' 'landmark'
371	filename	0	1	 landmark icon png 	'icon' 'landmark' 'png'
371	extension	0	1	 png 	'png'
371	kind	0	1	 image 	'image'
371	slug	0	1		
371	title	0	1	 landmark icon 	'icon' 'landmark'
35	slug	0	1	 landmarks 	'landmarks'
35	title	0	1	 landmark 	'landmark'
35	field	1	1	 https storage googleapis com hips data catalog goals 	'catalog' 'com' 'data' 'goals' 'googleapis' 'hips' 'https' 'storage'
35	slug	0	2	 landmarks catalog 	'catalog' 'landmarks'
35	title	0	2	 landmarks catalog 	'catalog' 'landmarks'
35	field	1	2	 https storage googleapis com hips data catalog goals 	'catalog' 'com' 'data' 'goals' 'googleapis' 'hips' 'https' 'storage'
14	slug	0	1	 stars 	'stars'
14	title	0	1	 star 	'star'
14	field	1	1	 https storage googleapis com hips data catalog stars 	'catalog' 'com' 'data' 'googleapis' 'hips' 'https' 'stars' 'storage'
14	slug	0	2	 galaxies catalog 	'catalog' 'galaxies'
14	title	0	2	 galaxies catalog 	'catalog' 'galaxies'
14	field	1	2	 https storage googleapis com hips data catalog stars 	'catalog' 'com' 'data' 'googleapis' 'hips' 'https' 'stars' 'storage'
398	filename	0	2	 screen shot 2021 10 07 at 10 57 36 am png 	'07' '10' '2021' '36' '57' 'am' 'at' 'png' 'screen' 'shot'
398	extension	0	2	 png 	'png'
398	kind	0	2	 image 	'image'
398	slug	0	2		
398	title	0	2	 screen shot 2021 10 07 at 10 57 36 am 	'07' '10' '2021' '36' '57' 'am' 'at' 'screen' 'shot'
398	filename	0	1	 screen shot 2021 10 07 at 10 57 36 am png 	'07' '10' '2021' '36' '57' 'am' 'at' 'png' 'screen' 'shot'
398	extension	0	1	 png 	'png'
398	kind	0	1	 image 	'image'
398	slug	0	1		
398	title	0	1	 screen shot 2021 10 07 at 10 57 36 am 	'07' '10' '2021' '36' '57' 'am' 'at' 'screen' 'shot'
229	slug	0	1	 some variety 	'some' 'variety'
229	title	0	1	 some variety 	'some' 'variety'
229	field	21	1	 screen shot 2021 10 07 at 10 57 36 am 	'07' '10' '2021' '36' '57' 'am' 'at' 'screen' 'shot'
229	slug	0	2	 some variety 	'some' 'variety'
229	title	0	2	 some variety 	'some' 'variety'
229	field	21	2	 screen shot 2021 10 07 at 10 57 36 am 	'07' '10' '2021' '36' '57' 'am' 'at' 'screen' 'shot'
399	filename	0	2	 screen shot 2021 10 07 at 9 53 18 am png 	'07' '10' '18' '2021' '53' '9' 'am' 'at' 'png' 'screen' 'shot'
399	extension	0	2	 png 	'png'
399	kind	0	2	 image 	'image'
399	slug	0	2		
399	title	0	2	 screen shot 2021 10 07 at 9 53 18 am 	'07' '10' '18' '2021' '53' '9' 'am' 'at' 'screen' 'shot'
399	filename	0	1	 screen shot 2021 10 07 at 9 53 18 am png 	'07' '10' '18' '2021' '53' '9' 'am' 'at' 'png' 'screen' 'shot'
399	extension	0	1	 png 	'png'
399	kind	0	1	 image 	'image'
399	slug	0	1		
399	title	0	1	 screen shot 2021 10 07 at 9 53 18 am 	'07' '10' '18' '2021' '53' '9' 'am' 'at' 'screen' 'shot'
298	slug	0	1	 a tour of the cloud 	'a' 'cloud' 'of' 'the' 'tour'
298	title	0	1	 a tour of the cloud 	'a' 'cloud' 'of' 'the' 'tour'
92	slug	0	1	 check out this tour 	'check' 'out' 'this' 'tour'
92	title	0	1	 check out this tour 	'check' 'out' 'this' 'tour'
92	slug	0	2	 check out this tour 	'check' 'out' 'this' 'tour'
92	title	0	2	 check out this tour 	'check' 'out' 'this' 'tour'
291	slug	0	1	 this is a brand new astro object 	'a' 'astro' 'brand' 'is' 'new' 'object' 'this'
291	title	0	1	 this is a brand new astro object 	'a' 'astro' 'brand' 'is' 'new' 'object' 'this'
291	field	40	1	 this is a test 	'a' 'is' 'test' 'this'
291	slug	0	2	 this is a brand new astro object 	'a' 'astro' 'brand' 'is' 'new' 'object' 'this'
291	title	0	2	 this is a brand new astro object 	'a' 'astro' 'brand' 'is' 'new' 'object' 'this'
291	field	40	2	 this is a test 	'a' 'is' 'test' 'this'
298	field	30	1	 test 	'test'
298	field	55	1	 stars 	'stars'
298	field	21	1	 screen shot 2021 10 07 at 10 58 24 am 	'07' '10' '2021' '24' '58' 'am' 'at' 'screen' 'shot'
298	field	22	1	 screen shot 2021 10 07 at 10 58 24 am 	'07' '10' '2021' '24' '58' 'am' 'at' 'screen' 'shot'
298	field	33	1	 cloud heading 	'cloud' 'heading'
298	field	34	1	 cloud subheading 	'cloud' 'subheading'
298	field	17	1	 clo ud 	'clo' 'ud'
298	field	32	1	 a cloud fact 	'a' 'cloud' 'fact'
298	field	31	1	 cloudy cloud 	'cloud' 'cloudy'
298	field	35	1	 test 	'test'
298	slug	0	2	 a tour of the cloud 	'a' 'cloud' 'of' 'the' 'tour'
298	title	0	2	 a tour of the cloud 	'a' 'cloud' 'of' 'the' 'tour'
298	field	30	2	 test 	'test'
298	field	55	2	 tester 	'tester'
298	field	21	2	 screen shot 2021 10 07 at 10 58 24 am 	'07' '10' '2021' '24' '58' 'am' 'at' 'screen' 'shot'
298	field	22	2	 screen shot 2021 10 07 at 10 58 24 am 	'07' '10' '2021' '24' '58' 'am' 'at' 'screen' 'shot'
298	field	33	2	 cloud heading 	'cloud' 'heading'
298	field	34	2	 cloud subheading 	'cloud' 'subheading'
298	field	17	2	 clo ud 	'clo' 'ud'
298	field	32	2	 a cloud fact 	'a' 'cloud' 'fact'
298	field	31	2	 cloudy cloud 	'cloud' 'cloudy'
298	field	35	2	 test 	'test'
302	slug	0	1		
302	field	18	1	 clo ud 	'clo' 'ud'
302	slug	0	2		
302	field	18	2	 clo ud 	'clo' 'ud'
305	slug	0	1		
305	field	38	1	 cloudy cloud 	'cloud' 'cloudy'
305	slug	0	2		
305	field	38	2	 cloudy cloud 	'cloud' 'cloudy'
310	slug	0	1		
310	field	37	1	 test 	'test'
310	slug	0	2		
310	field	37	2	 test 	'test'
438	slug	0	1		
438	field	18	1	 clo ud 	'clo' 'ud'
438	slug	0	2		
438	field	18	2	 clo ud 	'clo' 'ud'
439	slug	0	1		
439	field	38	1	 cloudy cloud 	'cloud' 'cloudy'
439	slug	0	2		
439	field	38	2	 cloudy cloud 	'cloud' 'cloudy'
440	slug	0	1		
440	field	37	1	 test 	'test'
440	slug	0	2		
440	field	37	2	 test 	'test'
444	filename	0	2	 sasquatch png 	'png' 'sasquatch'
444	extension	0	2	 png 	'png'
444	kind	0	2	 image 	'image'
444	slug	0	2		
444	title	0	2	 sasquatch 	'sasquatch'
444	filename	0	1	 sasquatch png 	'png' 'sasquatch'
444	extension	0	1	 png 	'png'
444	kind	0	1	 image 	'image'
444	slug	0	1		
444	title	0	1	 sasquatch 	'sasquatch'
\.


--
-- TOC entry 4635 (class 0 OID 16795)
-- Dependencies: 273
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sections (id, "structureId", name, handle, type, "enableVersioning", "propagationMethod", "previewTargets", "dateCreated", "dateUpdated", "dateDeleted", uid, "defaultPlacement") FROM stdin;
4	5	Tour Intro	tourIntro	structure	t	all	[{"label":"Primary entry page","urlFormat":"{url}","refresh":"1"}]	2021-06-21 22:43:52	2021-06-21 22:43:52	2021-06-22 21:50:12	38d911f8-ac18-4678-a8f8-72e96daf0732	end
5	6	Tour Fact	tourFact	structure	t	all	[{"label":"Primary entry page","urlFormat":"{url}","refresh":"1"}]	2021-06-21 22:47:44	2021-06-21 22:47:44	2021-06-22 21:50:12	240e4c6e-98e3-4186-8dd5-6a421d11e732	end
3	4	Tours	tours	structure	t	all	[{"label":"Primary entry page","urlFormat":"{url}","refresh":"1"}]	2021-06-21 21:46:12	2021-06-22 21:50:13	\N	b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	end
2	3	Surveys	surveys	structure	t	all	[{"label":"Primary entry page","urlFormat":"{url}","refresh":"1"}]	2021-06-15 20:53:27	2021-06-22 21:50:13	\N	02e3155f-23cf-4f36-a734-a3f447d04e85	end
1	2	Catalogs	catalogs	structure	t	all	[{"label":"Primary entry page","urlFormat":"{url}","refresh":"1"}]	2021-05-19 22:50:41	2021-06-22 21:50:13	\N	32b433c2-8fa2-439b-9678-d48e4f929b88	end
7	8	Astro Object	astroObjects	structure	t	all	[{"label":"Primary entry page","urlFormat":"{url}","refresh":"1"}]	2021-07-16 17:47:52	2021-07-16 18:17:12	\N	e2eb2e80-8e02-4a68-aa81-3d488f80543d	end
6	7	Points of Interest	pois	structure	t	all	[{"label":"Primary entry page","urlFormat":"{url}","refresh":"1"}]	2021-06-21 22:52:01	2021-07-20 00:12:12	2021-08-03 17:04:06	4a76eb6e-e209-42df-8ef6-43f1e5f7f745	end
8	9	Guided Experiences	guidedExperiences	structure	t	all	[{"label":"Primary entry page","urlFormat":"{url}","refresh":"1"}]	2021-08-03 17:05:04	2021-08-03 17:05:04	2021-08-12 21:49:08	58abf7ce-cf60-425f-9a8c-5f7d8c5b0cdc	end
\.


--
-- TOC entry 4637 (class 0 OID 16809)
-- Dependencies: 275
-- Data for Name: sections_sites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sections_sites (id, "sectionId", "siteId", "hasUrls", "uriFormat", template, "enabledByDefault", "dateCreated", "dateUpdated", uid) FROM stdin;
1	1	1	t	catalog/{slug}	\N	t	2021-05-19 22:50:41	2021-06-15 15:02:03	0d4011f3-3967-4678-9f47-a3d81dd80625
2	1	2	t	catalog/{slug}	\N	t	2021-06-15 15:02:03	2021-06-15 15:02:03	35914f52-7c28-4ac4-b90a-742b3d840965
3	2	1	t	explorer/{slug}	\N	t	2021-06-15 20:53:27	2021-06-15 20:53:27	92eb9b1b-8ec3-49c5-b498-1407bff9fe04
4	2	2	t	explorer/{slug}	\N	t	2021-06-15 20:53:27	2021-06-15 20:53:27	0e8ce80f-25ef-4f7c-a246-e063b7fd76a5
7	4	1	t	tour-intro/{slug}	\N	t	2021-06-21 22:43:52	2021-06-21 22:43:52	585e7620-bb75-4d4b-ac39-fbe2c1292915
8	4	2	t	tour-intro/{slug}	\N	t	2021-06-21 22:43:52	2021-06-21 22:43:52	6b643123-9c55-4d99-81f8-39dc2176b55b
9	5	1	t	tour-fact/{slug}	\N	t	2021-06-21 22:47:44	2021-06-21 22:47:44	586d9caa-f530-4f89-a8c6-d2c261c4d2c9
10	5	2	t	tour-fact/{slug}	\N	t	2021-06-21 22:47:44	2021-06-21 22:47:44	001a3c52-91bf-40c1-9fcc-d8de69afe587
11	6	1	t	tour-point-of-interest/{slug}	\N	t	2021-06-21 22:52:01	2021-06-21 22:52:01	a1231f12-c442-4ec9-8ef3-093384e0393f
12	6	2	t	tour-point-of-interest/{slug}	\N	t	2021-06-21 22:52:01	2021-06-21 22:52:01	bbe8e7f7-561d-4cc1-aeaa-9b00157a18ef
5	3	1	t	tour/{slug}	\N	t	2021-06-21 21:46:12	2021-06-22 21:50:13	1ae14921-707c-4818-8612-3b16501f7533
6	3	2	t	tour/{slug}	\N	t	2021-06-21 21:46:12	2021-06-22 21:50:13	a0d1d559-fd2c-4902-870d-4d47d1165faf
13	7	1	t	astro-object/{slug}	\N	t	2021-07-16 17:47:52	2021-07-16 17:47:52	7ba92473-3e18-4a8e-a37a-f03b27928abf
14	7	2	t	astro-object/{slug}	\N	t	2021-07-16 17:47:52	2021-07-16 17:47:52	39791106-028c-4588-adb4-e8f182748746
15	8	1	t	guided-experiences/{slug}	\N	t	2021-08-03 17:05:05	2021-08-03 17:05:05	6a5df3d6-40af-40ed-b531-2065cc54ec6e
16	8	2	t	guided-experiences/{slug}	\N	t	2021-08-03 17:05:05	2021-08-03 17:05:05	75969dc2-d4c3-4246-b001-6c2446929542
\.


--
-- TOC entry 4639 (class 0 OID 16820)
-- Dependencies: 277
-- Data for Name: sequences; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sequences (name, next) FROM stdin;
\.


--
-- TOC entry 4640 (class 0 OID 16824)
-- Dependencies: 278
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
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
101	1	DA4phYM7gRhDDIgzysvy0E3jFlvG0mxUY-asgrIsDZhefpmIwDD2gAzV3UegazvA8PUCMJgUCPMivX1zegKaijAGFFFJ4U39zJA4	2021-07-16 20:27:45	2021-07-16 21:34:29	eb66f860-12d4-45b5-9d67-3d4ed51e5a04
98	1	1z6FGmz0h68L-7PsazFXGRd0cHUVj8wWAwmCEF-Ow1EWvA1ySYSoyZdpyGnoOOMpyJ04_pqbwFPJI0r9R53N-uItOML2UOhDcwGW	2021-07-01 20:14:37	2021-07-01 20:44:05	6d1985e9-34d3-485a-a81e-65eb37b2f700
192	1	4vbV4fQc7ugDnrtfoNJkC6Mmgb9rYeDv6yRctBLw53JMe7bxWNFLaTtkdTdRTGdy-PH6Yebpd6QJwEZTcGQm341eDbXnHWeLS4Ol	2021-09-29 17:42:33	2021-09-29 17:42:33	78de6365-b551-4387-82a7-5c2837d6e838
108	112	qRwji429tq7_MZGPr8EruGaYedIf5NFwTfguP08pCM6yZMgStqAgXBlPoMURjoQxNzOnSEZ3FCygy8zf-llrd_7btlWLNCM3dl-u	2021-07-26 16:52:04	2021-07-26 17:29:41	b7dacd93-fbf3-4e77-a31c-dd4914367a90
139	1	KpdXrjkqkKF-iPPXQZlTcHH2gRdcZas2h6IBf77N7U5ZbuaY5YlxwSQgUPhDyhF6knOq6EbujSyWs1-GXbzD7rU55x_vLSy10R6G	2021-09-02 20:27:55	2021-09-02 20:31:57	4e42bf56-3ba3-4323-b2d1-15a0cccd639e
158	1	aFZp1tneRdgeryisLGHvZVqPlc2Azrwcv4cu3A4kHZRA7T1WCih2jOqWNCUYQSogC2OpEKm8DFKMvbZMJSGHRjfN5cIda0Dfhvz1	2021-09-23 22:30:55	2021-09-23 22:42:50	5bb0d9b7-47fd-4635-975e-7945beba444e
126	1	ads9BJ1uvcXXWqEdu3bwXx_YQL7QzC10AQlyz4_e-wnug_2NIELhJ2uPPN_jb2nOqgsmPou2uygMLV2ApAiwPx28AM6Puy8eTkdO	2021-08-17 20:23:11	2021-08-17 21:30:56	10e35bc5-ccf8-4dc2-8901-45646aca3ffa
123	1	HLcrty_ez6bLKyoTuUZBUXWZECCh6FmT5y7OzC9Aiv5x5lrsMyqhIhWQ1IwB4F2dFaOLVe-ipuUgSHOii62lLJJ0cSKEeINB9kkN	2021-08-06 22:55:32	2021-08-06 23:14:36	49c2d148-9aec-4b7d-98a6-a6be6bd9be62
136	1	keRK2dpJJ0SQ0l8MhJ5anI5hX9bgKXOEyTHf9okXruVS5ngI8Eul75zSNyUyy6jS3uYdYayql2kj2i5KieuOkw9dDW0WOx7Lkoxu	2021-08-30 17:18:21	2021-08-30 17:54:06	30ba337b-6c0a-4641-aba7-e4cca93984ba
114	1	62bU7Yhmn2tjyo9vMJEUTx_9PMhYYECtJdNNlrY0Rm7psvN3_yLKZoZecaxnQQ9h595n0a8HY1EUpg85wM0icacWTCl_qHWhkitv	2021-07-27 22:52:49	2021-07-27 22:55:59	25af5fa3-131a-483e-8740-0a8dad55002d
171	1	nhThQm1O10DitHCfdQ3x7OnOjh_I-dfUSP-50vyqLeiiXLfdrpbaYayQLYRxGOYKhWUtf75E8iMKUkOsc214W1EznNjd7rtpkf6W	2021-09-28 21:02:20	2021-09-28 21:29:18	eab15c88-adad-4e7b-be12-96bebaccbded
155	1	XkzcT8-l5GVvhrBJ6Gr0X-4DXnCmSliwvTd-OITK9iaWZfznUDpThVuvBud8k6aLddj8mDD7QP4LH-orovmfsTn6oUaqh03aM8kN	2021-09-23 16:46:08	2021-09-23 16:59:49	f68ea2c7-3211-4086-a511-032e62f7ff41
160	1	KyAsgFBmWDCFqH46F4kwjCJuMceUgpLxfixodNKLc4RFq8jR8mgRMybrA5uIwoglHw6xekbRFrNfvK8uRsldEzQCJndbKBSoojX-	2021-09-23 22:43:41	2021-09-23 22:46:48	690a6362-d658-4a16-b56e-1d95ea6a50dd
173	1	VKkD9PIBg_gFRoc-OrNHgaYL-oM7M9p-WwHFcPiGd8iIgs7XSvaSGnmFfVYqGI_kPvzT5MCf3mzRuDiXhJOomm3pQbf2iT05zfoy	2021-09-28 21:29:41	2021-09-28 21:29:41	33be8f0f-dd17-49d1-a8c5-966264b9e7b1
174	1	9Bzqcaxc4RdOfpKmHmBmtpj-8IuIU8wwvRJtpfntGFfQ6n7ozqKfafjWrCLSL40JsUBtV809V56dgAO3h5_ie__par2Zi7znRB9O	2021-09-28 21:29:43	2021-09-28 21:29:43	0a211993-a098-40a5-9660-13ddfe371a44
172	1	4WVo7-G_jYXCl3FIVUnOrvHxHJ0i-GbFhXPshIDOFq3AwWokAP1togrg1IRWWjdPscjOVJEUm_M2sNL-Bldo4qO4pzQudUE34EhN	2021-09-28 21:29:18	2021-09-28 21:29:47	b1283f2a-a38f-49fa-8402-67653d0ac05d
115	1	DrczDb_rOpxH25P8IQ2bRXKRTkvMHaB5tfi7t9bxKso2CSKyDqMcTQlVRKSdhvl2JhKdUD7bqp3e71MJNtYEhgU4mkccCa2rxnxz	2021-07-29 21:58:32	2021-07-29 22:02:41	5244fcaa-0a91-44b4-89bb-1e0b3f4b820a
102	1	oHJiS0LP2XYEA6KUh0gfr1zUeI-_K0IikH-5dtHj-_GuZdQflIu1WqbATbdNU1ZoZYYMIs3oB1-74kOPf4_LzUSlKX2AKfpG_Wt7	2021-07-19 22:29:18	2021-07-19 22:47:45	5dd494e0-8227-4949-9770-d0f9db981c91
162	1	gNXsj575awbLKktHoviCind8yp-MDdX2blKgsjqX04l78nG-v1l1CxmJqNxBb4ZbnQ2pQ4NNR6Guv8aHfzLVfTbBt9Vp0IKuIuNF	2021-09-23 23:04:44	2021-09-23 23:04:44	8ae5cd3e-b0cf-4f98-a81c-ccc54a826304
120	1	XKhR4INmw-_tdYe0G1yh7mxAHjCW-TuJF-jOfThJDnxpUPm2g8cC050tY0b88TAaTZNwbGODbHDZqzB_pnOh2bGppn6g9k-X_G_n	2021-08-04 20:09:54	2021-08-04 20:35:57	15d42eb9-0fd4-43eb-bb09-0710ae360206
161	1	fyY58W3gmSoYJjku60-Ihj8DRj-5PC7v83FIIfvd-qp5AIkx1ED25ynbWU7DFCZQMgT-m2auskQQmELaC5yIe5g-RqjGNy3_X43z	2021-09-23 22:46:49	2021-09-23 23:08:06	fbe197bc-798e-4525-8ab4-b64bd80819f3
104	1	tNSMqJzoAhLKxXd8TCxVIC5U5iov0_iIB_f1_tWCen8paVxfbo7JrWzk9KNWS03_pKpHERj06CFP3a7OPJif3H4YiOyI8awI6I6j	2021-07-26 16:23:25	2021-07-26 16:24:20	99ea420a-c934-45c4-b76f-c4dd06dd684b
163	1	Zr1kZ3IN2EDsb0leVVJlydMZ30Hibl9kI4MPte_RP8nGBWQ0HfSW1mmQJ8DEqvdbpM_ArKcpFWtibSOgHJ9SQFigRcWeLO-1cJr0	2021-09-23 23:08:06	2021-09-23 23:08:22	443587ec-d396-4074-a9b9-5ac5c9562ccb
116	1	2RW0ndriJD48YdUdYLUBUwg8Tw2N-mKJNMn5Md693jz-BJXhfEU65c0tstp07EVcxf6hazoju1wM0nWvNmBNTNJIkvET6CXwhO1Z	2021-08-03 17:01:05	2021-08-03 17:06:49	0f6ad281-2cfb-4257-b53b-bb64df7aa96d
164	1	MlBZyvlfyMoMHTAOz2DPL6cjqXr24diXS2WqQFqgTZucJ-8-7LOJ1yrTVTiRIYXXU5j1g2sGTPJy1-I3pc8GOjm6AaGboW8sbPMb	2021-09-25 00:03:49	2021-09-25 00:03:49	39317f65-7a55-447c-94e1-9e7d25c80d00
112	1	VbLZBF6NSC-AP9ngP8p5Ns3Vq0xdrbvAqxzSczzORVaJnwWF7aHfy03RayQPzsJhdz0PO6laMunvNg-w0w7yRrhAcztG8-4XZx5P	2021-07-26 18:24:08	2021-07-26 18:24:44	d678fce8-83ff-451d-b25f-e3cccf6a9251
165	1	egWP2FIRLg-oc-SVdQ6iSJSix8-I5zDcu7qmYUUrTyrEMXeA58UhCze86Q9xquG2bBRnJWC5DxueOAxmIcvz2f5x1LAAUXtoKodf	2021-09-25 00:09:51	2021-09-25 00:21:06	9eccd374-9432-4fa9-afcb-eeb7c8cffe0d
154	1	DJ-qpvY9WUyZHa33B9QXfN5lB8Nriq1Ih9ieCx7mEcsO1zG61iyfYeuuJIAK5QWotQ7jXd51ovOCceIX7hwwtXHBEm8U4voAj7kX	2021-09-23 16:43:24	2021-09-23 17:52:13	a1631171-1031-4e47-b354-cdc86259149e
134	1	LpO8KHVwG-Y1k359GO4FPd903Oo7gWptr2IACYC8e3As8VPK87ITki_z36AAIs7NOePSUtPLEEu6pT9qRHhpud8li0BcqWT5ICs9	2021-08-24 21:24:46	2021-08-24 22:41:09	592d0033-5d71-4654-ad64-19d48b8680e8
156	1	1ACDQw3Ep614TMhbd3o1jp5L6qxmHa71akwelfGYeYJeSoa3v7k9jKROZ1NPCbfowVtQPo9TFRqx6fRJS7hpsWvEozcQC4_nOOVj	2021-09-23 22:16:18	2021-09-23 22:17:33	92738245-b686-42ea-8efc-14c9397130b2
121	1	0qjwMQ14L7XqmyBvBNU1COXOYN_dWmEr328pi_pZPP3MAHizOkO7gLAzDuovx1PxLJ4opCNaHeaBz0NjftHjpBNbPWxKzBgPvhVa	2021-08-05 18:56:49	2021-08-05 18:58:17	91f09d21-0af1-4e14-bb1b-963927deeb35
167	1	RktrF8cY-ZJz3OxgkdZ6UFGvlihCxSVah8hycLhC1OmDtt8nIw-QlCM82ncgXkXTQQHyWuJQKP4ho59O3XqJwtIyerwFmnINY4My	2021-09-25 00:22:10	2021-09-25 00:35:26	dfc1ce59-de5c-4b9b-abeb-d193fba0ac02
169	1	4KI-HHp7xN3HBSa--8eN4YHf5yPCzEhLrlQNf4gJmKpwU1nDvsW-vWHgGfDoyYGBkhgR061Fk4_xuZtDVxvpJG6QSjSsVxRmXKnr	2021-09-28 17:43:53	2021-09-28 17:43:53	12451330-5d99-44de-878c-26587400fb44
170	1	50V6IUAOeCwgyLAIVPC4yOvzPTGs9Kf5tc4WmASf1DXbAS98CgzZed9Yjqo3uuxQ6uWtVU8dh0NnIcSiPH4wa553xd5Xwv-iv8pz	2021-09-28 20:36:29	2021-09-28 21:02:20	2c42feca-9d0e-4268-9a49-c61859bb6ee3
175	1	OYbZ8_E6Aes1sRkIu9Hxnezq0MYfCMyWs3694l_wRWw5zAvzn_zZCR7uqf1br64n_Yzhe9G4Jhi0ACPw41AMvvtms5iEfC2V9sX5	2021-09-28 21:29:44	2021-09-28 21:29:44	ddfdd527-e4ff-4502-a5b1-fb719be898f0
214	1	NHOr-DVZt8IxeBqu-0Z-sQNhJCK5yYByj4MF1ji_0mhrrRWUmczOLQrd3PtPeOuLbbSwymAfA93KPX449WyopLzSaNqRC9FZyrSb	2021-10-04 21:39:27	2021-10-04 21:44:26	f8226f9a-fad8-4d15-b9fd-36528b512780
223	1	HPqS7afhYPWohz7DJsu-GYv2uAmF1B9Apye2ClmMEpuJyeadsK0KPT6ZnfC4UemHIsNYo57ECoWvaE1Aq-m8yWkN88W-NSKISOG8	2021-10-06 13:27:25	2021-10-06 14:01:09	348f0e0b-b100-472b-bb8c-86384b09b065
208	1	-RQeyVR2TJdJjVgHR37VB-4Gw43fkmmebf8w8q7BU9_0-bzBN2zkXmiwneUBCIfveUWSdMI511KABbVNT2Y6EUjFajSvJdf9N2Cj	2021-10-01 21:20:56	2021-10-01 22:04:56	5fd8aaff-3a81-4cbe-ab2a-b67def722e3a
245	1	Suo3Jukkl96YDAnK7EQ_JQ6jhkWb6de-g9GU70qpP4hiKGfoupE7rX-FgCUjUhsCLIVgHpgtQg3Fg4lOkthZnUaFjaMT9-Q55XiU	2021-10-08 01:51:22	2021-10-08 01:51:22	76abcb4c-4d0b-4f6b-9da4-4840d6c356e0
206	1	rVIVSmq5HJCRCrfeamkX1LLfJxgEEGZvRKvUKE4EfMgCB5mQbApz_bhhW-fPX3QbB1P_WtfhcJFbQvybyafU9yVIPtTSZUyYxu8C	2021-10-01 20:05:11	2021-10-01 20:11:27	ef61b886-788d-4e6e-ae0e-24c01fcbb3ed
224	1	FQwgZl1y352gIQ7oEkzUoLGmICF-WpKA3L1nIA_IfIAM4pK4YbysCHmfubBmSbvDPM9SJCxwNQO8nNc0kpxe90QaUeq0S3lnclTK	2021-10-06 14:02:11	2021-10-06 14:10:19	22bb852f-96ac-444c-ada4-96e5fcef0bf0
221	1	cCU84249YunQ7snhrmJlD9l6aJbtC3Nz4tHzqO-uBZO7MvyTURQ7DbEiogxrlwaFxNYVAXxvFwdN7yISU0YQ0pluLxQ4shKnuoVK	2021-10-06 13:21:57	2021-10-06 14:11:21	0d51e9e3-b471-43f5-b4c2-2de0f62ff445
186	1	3Dw9Obv2DCBC6_Q_rc0Yk9h58Q8PJAvwUJ9l3kmsT-0YJHrUSfEQUiKiuxsVdrMj1d_lZ-YTmFuahCRC74jfkVGrOEC8F-rlrktZ	2021-09-29 00:00:58	2021-09-29 00:24:04	3bd66101-fbbf-4340-b1ea-03145e289170
185	1	PdH9UrasoRR6D_ElacrhoDH4yXXtDp-N60a_apbiy1aubShxaSKDOZU3ruqo-fr953jVeyF3Hw1jSx91kkNMMW2ffe76xKZdNVXS	2021-09-28 23:38:42	2021-09-29 00:25:11	501f03f0-bf77-4d7c-82fd-32eebdc39261
189	1	uUWgUgrMi9Zghn0Rz70JZHkRfjIrI9D7tap3ZCAKAHg7PhWJ09QWvGrnwsndHWdq22X8bVq02bk1nFOCTxKMnL1HLuuX2gKFCs3r	2021-09-29 00:25:12	2021-09-29 00:25:12	35cec057-2731-4338-8aa9-9f59426ea6a5
187	1	jRYzUvq6JCWUgz6g974hNrfNFu83BVGKOA-vIS5qglXGb5a_hXDWM4o4FKI9TflIfRaOkBF1rBRxpPQ6D1ImrDppHMe3R4TvlZgA	2021-09-29 00:02:33	2021-09-29 00:26:23	76cd0340-f49a-4f3c-85b9-8fb16d0c90ac
179	1	Qgu5KVNcnfsqSNglBmBLWH87FT685iEW1HqTcetzdvF4rRaLrmffJWGdJk4uX6je6syrD2vvc1J6Xe3gliXzBj_ipI3CWWxMLqtP	2021-09-28 21:55:05	2021-09-28 22:09:52	c886f502-c7f2-435a-b625-05d3d6f7502a
220	1	6vmmaP_yifWtowh7EBT4FFyQCK6JSD5gluGrVef7LcCbCrKXHmK1k-aeYcjbtE6J2DS1ZlTIhjpsfhjO3eHwzy8QN2OZwcOD62h6	2021-10-06 13:00:06	2021-10-06 13:22:00	bb9d0274-c337-4ee0-bc9a-2c3554bf8489
222	1	XNliCYPAbDZEv5gAyaRbovkjYufUEKVrKYqt-XCx7j6MyhFHF2N835tQ_gKPpjODI77M353tGGa6CcV8AH4_-scvgTKTB7ODrQnt	2021-10-06 13:22:00	2021-10-06 13:22:00	eb5ffd01-64e9-4652-84b9-ce3f46731fde
180	1	FRS5KppFSP38BGXcWjk9RbiNjjkTlYFvB8z_KvZTYWFwQRWgYxohRtR-uiYsmfwGGTsR7_gQJ2zkSawByFyrteTgy67bObrdX21p	2021-09-28 22:01:10	2021-09-28 22:17:17	7ad62e6d-d2f2-4fcc-a012-0e01a1d574bb
193	1	4z3TABEJEJ39ytt29h_u3HQ6vWVK3r6V7d2z1ZFqmV6rENWhhoepwNRKSlMDIMiSt8uGmN2Fge6p_vEjhne1wlhbyIO6Hn46VdXp	2021-09-29 17:42:35	2021-09-29 17:42:35	c7008bd6-2853-409b-8bb0-459f5c3d18a4
234	1	KlMydDjAwlx4c1CwX1ySoWTUvsDsYQYm99aRJuKPh96pEm9urloRwSLMtEI0rxYs9QVRKkQUT-64FO-53swgRtBkbXlASY_a4kOH	2021-10-08 00:32:10	2021-10-08 01:25:35	6ebd3f9d-c7f9-4dc4-aeeb-7f9d8d58ebda
191	1	nUDSOSH-fzWk9dB6bXm-NDGcYz26vmAmGWT3VS3PI_mOElHXQbwTHZUNURd5vT_uwMkFVfD30DD_bezeXrz8RqGElrM642Vdm78T	2021-09-29 16:31:30	2021-09-29 17:42:40	eb984c8b-26c9-429b-a928-da5fb783de43
181	1	fiPHbt8WFIkKPQtvxQKfI_pBh50LBuRiZxOfNM4EtyenKYktXn7c939IHocrNmE_cQFCW4K_TWE_3mLF3ODEYxPkX71TUTDuShIo	2021-09-28 22:08:16	2021-09-28 22:18:03	b0e68476-f1b6-4980-be07-7fd8b4df66b4
195	1	0owHEyh5owQjuKcfk_bHKPzkE7ILYbTi7baxhYyY6Yh0tNh6vdJtEn4Wvnw5Flv2lWzjCBQ0O13t3DegTFBNWmALtVH-4ZvpuHGi	2021-09-29 17:42:41	2021-09-29 17:42:41	a111109b-b0ac-4ed7-9c84-55d679c28aa3
177	1	S272P96RVbLwta2qQbhJmKD7VDwiWtK7tfcweWiNJm62ttkNqDuZ2-vjIDV7PgbjL2j-UqGdFwjSg5qv9iJwtLIx6laUHrKRItHB	2021-09-28 21:29:47	2021-09-28 21:54:20	74bb24ea-7490-4c3b-bf0c-f940f12cac4a
216	1	OJryQNU4bIIqt4rbYG22JBUPiIZ43TEqQyzRJ3cpwK4y-2uYChaUWvJP1BMcc6V1L4DNAbTaQF629GOvAXDrf2aVdEqyHMhhnSxi	2021-10-04 21:53:55	2021-10-04 22:07:08	27474ac9-d69d-4ccb-a307-4063bd352d96
178	1	cQD_RJaA9HupMAAVf3HCyIfy9v85oaOb5qYb92Rihnfm4jzbo2sppBZ7x41ecbTx2jOiKtyW8eKUjKusQzyUefJb4Br1IKU2ElXX	2021-09-28 21:55:01	2021-09-28 21:55:01	361995a5-92e7-4b3c-b7df-f573689a462e
176	1	WkfyVH8jmdlXb4d0iE4_yPZpsqfB4h58BYNGCusNRXQdglFdulkyzeJ-khcI_kRkatBskQvZYCgtAWAI8_zDlUO9CPyz1d3NYczx	2021-09-28 21:29:46	2021-09-28 21:55:04	1c927a7a-1392-407e-b25a-22ef949bbcbe
182	1	g9tI6-AvKYktE2RSuzQp0gHFXB5k3cXwZ5YNy9eqdZLE8VRTL846whg-TqgZJvDXZ9CsoimZXLZsKZRW6Ps78ptNxIALsGkptM7M	2021-09-28 22:34:22	2021-09-28 22:36:03	8a9277ce-8052-4893-8d9d-95cc6216cb98
201	1	f6BtGhsoIlqyzIN3hArjGpMlKpU5BSYukXdailEuu2jTx7bGZ3cTRTWzbbHmhvqQA0GGiFbnAbprK25H8HSnhCaLuxvvjzZGEB7t	2021-10-01 19:19:22	2021-10-01 19:24:19	f8bae7a9-1c21-410c-90cc-d5bc27c3a05b
184	1	bkvy9C02_-OrqNcbhkx4Iodv7MUWmX0tdaCuu5fL53NvvNRazKAr8S1MCT3RkxvzwOV_gj7XB4LAE11nN1xKU3C_Ug8_QGIJLK_R	2021-09-28 22:36:38	2021-09-28 22:36:41	f02c2d95-eb41-4212-a98c-48d5038cfe41
215	1	J8kYcRR72wIWksC0If_9UHpSFZbrqqTobnfeP3D5M409q5hQLgNGbzyfyCvzgDIftFsqb3EtD-LwGO1TdnNq4vHf6DmQ9ESZDsAN	2021-10-04 21:44:26	2021-10-04 22:22:00	05ae1800-6153-4e6c-8f9c-7e922cdabf4d
217	1	jtbJlxpo2aZBQHJJ3poArydS8GICgIr7oOdDo05f7GmZl82VczKN2ENFFr0DNNGsrq-ON5hIDTQrkahuiRMvaeh_rFAhrbyyjrl-	2021-10-04 22:12:55	2021-10-04 22:22:11	a0858940-5029-4ff2-9f8f-3ffdf50a5b6f
225	1	lYI_DqB3xvLXMB4JOos_xeEW3GXulhvlmChfxDWYAiNPQgbxLbj6O3pS4u99ZfH1MajuD-izcjwsNAXnZ_Tj8hSjrTZPVTSmxUCJ	2021-10-06 14:11:21	2021-10-06 14:15:17	5d4d7586-8ebe-4c27-8a93-91ebf2a796e9
202	1	lQicJkKQx1xC9nDryXIrsPvxwe_cVDJl6deXt5MOkzX4HzV9yiGuJPSzZIEmLRlYssYILV_EJCEfuKrhfJgyh5QSrPloEOHnyJ37	2021-10-01 19:24:20	2021-10-01 19:30:19	2c45ef7e-caf1-4eab-affd-eeecac4929bb
219	1	ejJMWOnOFHCyAmqW0KSdg0f6ThM6DnI-KzSxZB0c13GSFwsy_lKnGpvjHYwnnTwS7gbI4_YGXRSVLD3fJ5IkPtYQKuQfQFRtMFeE	2021-10-04 22:22:11	2021-10-04 22:24:25	a5dce18e-1863-4311-a7bc-1cc67f47c2e1
194	1	VkcPWiJEJLeGGYRDFVV2D_rakxK1mdd5wf37J_NZulwQndfM8-blxebrMgHKXxa9mA_Ygwi33o77g8lABWUwGSUQQ6Ai3TxMjIUp	2021-09-29 17:42:35	2021-09-29 17:59:48	cc844ec6-b461-4cf4-a4c8-38d749c53100
204	1	2WirumuLwoC_4ERcHXe2ppbgl02uTxCi2aivRWxJwpV3ji8LjoR58cyOf7kIBx4HBzTUlifKsGQ130o1VbF_LfL5nUMT-OfQdkiN	2021-10-01 19:30:56	2021-10-01 19:31:31	8a26d1b9-1c39-4810-bb4d-d99f3e7f9483
198	1	IjxAOJPJ0WFWkoq2gm4vqYQf9Bks4MhxZudxLFA6cTFBBg2TgyqTnDUdswHvs8QUYogauejmM_Bkzgi95ObDeqFPqTFOjgmgdKUI	2021-10-01 16:23:20	2021-10-01 16:29:39	3e8b1e3d-40c1-42a9-8ab1-cd915ed568c9
213	1	o-nIRxv9208kwP_Cs-JV-5zvxhHzPMyG_xMCVNxsqCdQ4pX2iJ2MDHcc28FfyLOMYs5v-e4uwuOZiYRQOYEgytcUFJ4YcjiGLYbK	2021-10-04 20:41:25	2021-10-04 21:39:27	e46662b7-b388-43d5-9814-67cb242dcd26
207	1	Q5K08jZPDWzkOeJupbmRJA9Ekf1KQuoRVfipZHHQQbPf9lWFdmRTGPL4JoEaeff4LAG7JYejFltP2eBzeSdGacR_lhlL9BmZDhe8	2021-10-01 20:32:28	2021-10-01 22:04:32	f7b1686b-4aeb-44a5-9d9e-55b1c0b01e8f
211	1	RbhNjd6yD5TrGSsrE9fhxc7YG1mnCXF7sLWkIpoT3dhbXeY9_pGTIwJRpgp8ozceF9_OF9lM0FeX29CjWtO6tCGjvAjAwCw8B1Z4	2021-10-01 22:46:41	2021-10-01 22:49:34	ecc983e3-fa02-4c08-910e-16e92b41264d
266	1	WInN6uI4TAYrEdy8EpoPp4nnL50STOhhL65LneGM8tBk7CPNcsgz2QhODXOijimXwyODBhKWtjX_cF_TavPh0Rj3jUfY9j5V_Tw-	2021-10-08 22:55:44	2021-10-09 00:02:27	bf53e545-2915-4f18-a947-22fd3105990a
257	1	yEqGBQuzeSQxdpcdsfhuLp4Zshevs_ORjjuV7rLuldn6ww4jp8NmahzWXmgF1YIcEpN3MHMmI85U_K0DpdmnXj-jZ4slAYCQOve3	2021-10-08 21:23:07	2021-10-08 21:46:34	16b06bb2-2054-4eb0-8005-cd7b5bded73c
239	1	6WmLY1yH32qFw12SXHHgQmPRH7ATdFwBf2bNI4lGJdE7OVpsg6mIXjFYnf8pGvTuDI7ZJtqozGlUtg2HznR_Wj4EfWc-_NwkeHoJ	2021-10-08 01:25:37	2021-10-08 01:51:22	4ee2e3da-48cc-4f7d-ab4f-1ed138603a3d
311	1	_HESxAqud6UhobfppgeSHpafv7xiI3Q4FzkX-_OgCWUoQMG4UPqMWPVK2UzVql5LC3vNnO9pZdf_wzJKM0dexXBDPZ4UIAVnrYn0	2021-10-25 22:08:23	2021-10-25 22:08:23	47e406ee-8b99-44bd-8ab5-70e834284753
228	1	PzUTmpdB1M9MMNt3oSpgkkQnwRSnCXMYPTXY-Zn6rwAUHJiJTJkbSrdNaV5kv_RlbXeTIdeP41RSlvOwst9doNurecKa2RxoXNnj	2021-10-07 22:26:54	2021-10-07 22:27:03	be813d2c-4142-4243-8b94-8b97dcdb7623
259	1	n5BjCWr2tPuJ5tf-2LD5eZXW0H4_4uLTQKxeohdrVtpJ7BLEJVX_Nw8wXT_LQ2EdM1kDvsKBc5AWj4182HwqG8zAG5xyIuz2K4Ay	2021-10-08 21:46:34	2021-10-08 21:49:35	9261b5c7-1e17-4521-a4ad-4562049671d9
244	1	HCVycKQ5bG2LtBqyzCY6rNCu--ltE6a7GTxe4XvlggtRk2bwkmrCqh0I-hT_55sjrpCq92Aa6xlqRiym_xIwbPWTpWmE702Yfe4l	2021-10-08 01:39:21	2021-10-08 01:41:09	d786f35d-bf36-4110-9de0-1e14462b43b1
233	1	-ODrl5hAuZdhtOht1fWFhzU6tB1i82P9kgo03jo_OD55iCKqZsb-Ko5NecvICZsKB0w7CqC1E2BdLvCMwkHDky3pEORq1T4G9zXP	2021-10-08 00:30:00	2021-10-08 00:37:02	291a88a9-96a3-4ebf-a858-3fe53c29247e
230	1	lw2FSqBXFKMWUmtOb7cee8R_Rh3Z_588F_vp6VYMItRQ6dR4oIS2QXFpHI3oxPkho2GJbwhVa1yF2zLsn_XLLZ-pjS0BAtbmhE07	2021-10-07 22:38:44	2021-10-07 22:38:44	729646b1-8270-4a72-90ad-466d35781480
264	1	ltf0sUsJRLj1LKi4Eyr3zF2Z2yx4WU6nkILG0D3FT08rKIclPF0ck9FtERzUf4u0o5CXxD66t352wp6RPkP_zGkdwoqvatyn22ub	2021-10-08 22:29:01	2021-10-08 22:54:30	ed2ca047-2511-4b1c-be6a-7fcba83f3306
265	1	q8Yt-h0m6iwzti1GENCSJjSz8Edop_EHPLVvVLy3j3X7bi2GhbyQOua0WEFodGREx4GNHNK91UOMIXI9iitGZ2AY-kOoJq0Zfts4	2021-10-08 22:29:14	2021-10-08 22:54:37	6132247b-388d-41db-a655-38da1c2febac
260	1	0W6mjnmdF3rEi3TYAAZtmTCFEyO_clOnizRdpXOEx-du0YIi20QC6YFtM-nrodyqChtD7tjFD3-1CQISy3wKge2IGZsHtIfN1u8T	2021-10-08 22:00:44	2021-10-08 22:55:44	b167f8bf-c346-41ea-a5ca-cf738c7bbe09
246	1	rY4kd2mMK5zBGjvDw8vlmILQAWbwJ4TafVI0uJnLtURYC-zEozQ4dxJLD5Uhv6sFwXERGmFBoRBmZOREk7LJvNmCSuVMyS8SSQCY	2021-10-08 13:30:16	2021-10-08 14:06:42	e3963ea6-e47d-47c2-aac2-6f42ed6d5c1e
258	1	jnYlL4-doMqvXfGHPPEnaRSaaD5DqxALG3JHuwFd7OhlXLoKRobtQc_SOnVdWLH4wN1K7XisQoQRNPSxXYkQZgLa2PV4a1vrauya	2021-10-08 21:42:06	2021-10-08 22:56:00	bc8867e4-018e-4599-9ad7-11e069ad27b8
247	1	Iwf5oDRahc84Egdo4m7zqmVoqGSDx6ErepkNW5Oj_Vzd2W48hbSaJKQuh9e_MkvH5G2FMuVUPAkkKUDa8cps6XIKNrLPAQKtGk-K	2021-10-08 14:06:43	2021-10-08 14:06:56	3c4aeda7-3075-4d5b-af5e-290870e9199d
249	1	ZQE1hV5mgFAlWXiZ29qDH64Ktd_LdwkciNd9Ho5-NW2ELtKXpN-RgfphOOcsIk1KzrEKmzEKGlH2H5ewbOhwxh9BdPIYdSfUY5DP	2021-10-08 14:06:56	2021-10-08 14:06:56	f1f1f996-08ed-4860-adc6-b1a9ccaabc44
250	1	oIF9wOiUHYSFk_oVRz93OL40UpUbKOdB-TM40TWonQcMRgOiwGe73daT5Pi2uXHWYGodVS8Uve_R63cUaaV2DyE8zq0sxlmagv-R	2021-10-08 14:06:56	2021-10-08 14:06:56	5ad3afe8-d20b-487d-9506-104c5c8fd6fe
270	1	5EfadCXrD954suffYDofPlazVT-O4a4_b9DgB_zNhfG0Hrwkc3d9rRrT03U1Pdz-6F3nnfsihml5NdKaT0k9qu7Dho0ysMIiD1d7	2021-10-13 18:38:01	2021-10-13 18:38:01	0467e49b-96d8-43a8-ad4d-1266d5de9159
248	1	TpMLiyzoGj2_pkGdmD035I98BLd5YIit63WOF1jrCW59lIbZ5ZFqEX8bBXULnzikJ8v0tMv4kOq_m7jjFAXeFGdb2YslmgsEFtiS	2021-10-08 14:06:56	2021-10-08 14:13:33	6fafdeec-ebd5-4096-9b59-a2da3e88d7a8
235	1	2C1Ciefh1L2AHql5rk5XBu7p8LbvdGQKkFXQJHNpnXvWCBVawMM9zftY1I4sTnA2UOjphaZfBQ1bgS5QkQEeAjGgVtPlFa_cgHmC	2021-10-08 00:41:37	2021-10-08 00:43:30	96167045-3bc9-468f-9c22-8afca0fb64a2
252	1	B36LmSVrBTEj1Fz4Labg3Vls9O4ZN1iLveS2eRRrjd3m1-pqMQfAlHQDd2Gdz76ga3Q0VRzfm4NiVIy-EWobeK0k0SqbmwHkgdUy	2021-10-08 14:13:33	2021-10-08 14:13:33	0d2e0494-ca29-4dae-9447-50ffe3b4d05c
271	1	fWxiNTdqAeGm8g6jJPO6OG4vvx3YQnV27NHddCPUk67hJ_k8vJMVRjOl8EO_dODxhmVmbj5nuJcLFZ9KkmDfw4UCAfKuCRxXJBiF	2021-10-13 18:38:02	2021-10-13 18:40:40	f7b26c32-9167-4298-a4ea-f55529cd78b0
237	1	diBblyjd_9_TB10poykKdAUKvk8J79I38GPUvEDX2jNKlHsGlUQ1VSMmwb02pUIVtgAnrkfeKWVaTxsIhfAENfkhEGyL4m77UXrq	2021-10-08 01:25:35	2021-10-08 01:25:35	9b48b112-9b67-40e0-917a-91a66fb6abaa
238	1	HnQR29yvwXa7cprlZcrr4l4QLs9awT2Ypzf_Yng3nL1oqZTuZLx4XCLySYL36r-V_p9fnr1Fl4-3mQwwxwtyC4YsiJdyOA2Kyeq4	2021-10-08 01:25:35	2021-10-08 01:25:35	8cdd6b2a-15be-4cdc-adbd-bbd4e2002c1e
251	1	Gp5iAM32Jd_hKjD4bGHqTwK-SytVoOv_R77503wXKukI8KfPOjZIFs2xXxsHMEVomdN1O3TgIsihLOWqIjr7wr3TPW45UHNtcamd	2021-10-08 14:13:33	2021-10-08 15:11:20	abc52886-7487-4472-8dd6-951e5e97cdfd
272	1	YYspoABQKO9uV9O93gKycG6Uy-hqfuwXeK36rfGdG9vV8MB4QxylQql_T_IS6y-asa2JjhfGLmq1Mgygy-rMDZ6pH2ZX-S5GIDMK	2021-10-13 18:42:02	2021-10-13 18:42:02	669577c8-5981-47e0-92c1-bb99c9c145cc
253	1	RlRd6tv47Gsebl3Er9T0Us7nF0Kxe0_U3sJ2iyZPZhVcHIWUR1ixHvSxTzeiYBPr9FRzkoiBZkueChr5FySQt_X15wZMYaVdiYgo	2021-10-08 20:18:57	2021-10-08 20:21:02	255111ac-9457-400e-b5aa-c2b81e92a0e8
240	1	kVkumxsTDevJZpvLPehraDuSO7Hi17WcybfydNRtD5eidUMY1UqZgbaasIkkbkMAcq1QO1lk1lTM69D-uInkPHAlqQefJVpKfrDK	2021-10-08 01:25:37	2021-10-08 01:25:37	314da3aa-952b-4480-b866-15dbfe5223e5
241	1	mlILYmmbEIOhoAJnQJbIDuOdBVGPG_qTjdlOHyDZwbFIzAR7isPnTG8LYJJH6CUoemqCMOmqOmFVlA9sEXS7zWBy1uNHL0aCny9A	2021-10-08 01:25:37	2021-10-08 01:25:37	4d503ff6-0670-4a9e-ae70-fb86a999046b
242	1	PouOtI4ZcpogofaJwbMWEdt2Uh8-1kk41B6Ny1-8U-mtMPJ44-Q3_G2Wj5JsaCEQrRL6iVdZTPgShK_aPr0h-Rk7WlXrc1vvA3W5	2021-10-08 01:25:37	2021-10-08 01:25:37	0029406f-beb7-4915-98eb-edf8f46c27ef
236	1	qY38DPV7k0qvotBlmQpbcElpMiv1CJC3TMF4QZJ6jGR4EXmdDz9ohDWed4ljUReIfdigGEr78skkgUHeTX_rfkgf3VOEoNWHjc83	2021-10-08 01:25:35	2021-10-08 01:25:37	668735de-c8d8-4a89-b674-092fd9a2b197
243	1	zkRuM0IVmbK0o0znT7MLLA62g0vh65cuon4gTmv0gk-XEn4kknPEF_Dgj62MOwjCyYPQpPJ8UFzLSmiNSo28JwT1TJfhDr3EESGs	2021-10-08 01:25:37	2021-10-08 01:25:37	a59add1b-aed4-4b0f-815f-8a664d9a241a
269	1	URaVNfq_w1DCBkqVSIakwlqCiqhKNcOxUXB6nRE5_Z_QSak11vQsTndeF3lN9CqHl7Y4BDHnS4bXg0UTaQ6kd8bmgPPH4RKScDQw	2021-10-13 18:09:05	2021-10-13 19:13:34	db268702-c6e3-492f-ae34-098da777cb99
261	1	sFWIJZcSb7R550_zJF0zj5tASgH21Kk8WtGUxYr73iewIAJYEWYHcesGDz7GALCCiruEFTclntUxxXwOs2Uxy6iyo2RQjfpN7HIt	2021-10-08 22:18:58	2021-10-08 22:18:58	c120f063-0db0-4ff2-952f-f71a0a87dfe2
268	1	9cMiH2Vt_iC4rpRMOB8DM0N083RKxW8aCxkgbcCOSdcQ8b8Ng-sVY0Z2MMiMRlxU8sAtPf_LkNApqYOOyNB9SmSMYcL6Y4A-P_pc	2021-10-11 14:37:27	2021-10-11 14:55:54	5e6bb6c8-4d9b-483e-9e62-85e97896cf31
256	1	SROCtepr-e7wPFcqyaehIgxK-Snu08VRfUwCYOyToJwydaCCz6vHYk2x2POnf0yPTTY0ftWLhYF6WtWZiutzJCn6NTqGcSMLJZbu	2021-10-08 21:12:42	2021-10-08 21:23:07	c1c22f2b-fd94-43f2-88fa-fd8efebddf2a
262	1	brRIbJ7CEYgm3hdVsdeUQ2PJMbpHF6Ol089xWLSOaOoHcgXSmDFgksMp2bWsg3Y_uuwPlakoRl_M-b75TuYR1tk5bDxZ7JL-pDfz	2021-10-08 22:19:15	2021-10-08 22:27:56	7ef915d9-e20c-481f-aeca-f4c9e3acc4c9
255	1	n5hXfLytWbjElrug29QaywIvRA7-GDC7VX4IvQTRODAsMoO3csRJ3U-edFsvcvcqxLGVXtaO1OkWvjy-DD4satCHnHbW3Q9RvqB4	2021-10-08 20:25:16	2021-10-08 21:12:42	3caeb92d-5ad3-4a06-a2c7-c06fc3996f88
263	1	epu7ebzPn_6-BTDdYSaXOMPKIY8E77pESkjVct_yerW6-sZu-D_drckO65q_DD9ef_8Fems4M4A-KAScyC_yv8-GlQdFyuD9-RmB	2021-10-08 22:20:00	2021-10-08 22:28:12	f32663d7-2da8-4516-aef7-7ee3f55a4c0b
295	1	HSP7xu_jL4S0e8mxezekqPR6eqtsEiZOptqWdN071aWOMaGPErcw47JIzErjecNfV2yl3ObjsUQcPRa5B9MZQzbi4T6pn7dTOVTA	2021-10-21 15:29:44	2021-10-21 16:28:32	f5c09a06-e3d9-4a3c-b140-135ca84d380a
273	1	8LpIv972qwoGstg5KMvH07Xunnl1-v4X-Zh9Lmwg5S64qzuVGT6JuUn4BsyS7Dy8MjwYht0DM7vRXddNZIcVgO3mEjowugp9QDt4	2021-10-13 18:42:02	2021-10-13 18:44:34	e3341c0a-47e9-4a23-879c-ce9734b5f24d
274	1	cIDSrONeU5w1GAr4fyjnfFetdchq7KZHRwkXW0WDlj4o8oW2iCOH_WBsoB8kLpnIDiJrZe76pCZ96TTagZ8AoXGYuAcBw2BHrq4i	2021-10-13 18:45:49	2021-10-13 18:45:49	9d93fe42-8fc3-4395-b321-b1be2f3ba078
287	1	iWhNXozZ1HKO7_62i_y8MgNeEsega8eON7r-vM_EW6k2ZtxGtAcykiVbb_bumvn4cvdXXvI0vtltN8Dyju98je_xqnLFecxXsuqb	2021-10-20 21:22:40	2021-10-20 21:23:45	11eaef04-03fb-4e8b-b9f2-aaa93a36969d
288	1	Wnd5Twq5VlyNXm7c_ZgMx84hNFMqN-nzkYshVvP0zdCu-bVTL4c8W7NcZ5HHfAsKwKuZyqRyrwftxxUghk_vYgSzT0YN3V1vjAUo	2021-10-20 21:25:14	2021-10-20 21:25:14	7d0a7b25-5ce3-40ba-98f8-52f853b5d0ad
291	1	I3k6xk3Qm7qn380XoQPk-4MkR6l9IWb4pMehTEIC-cU5y3-5FZ9dqxxiQA7aOrkTe4o0Oe57LCF2zoQhBe5eOj3xANhJV2_KmphM	2021-10-20 21:51:03	2021-10-20 22:09:08	cf293ad7-55ec-4e47-9f4b-42b3b343c0cf
286	1	Psc9SiWodQy9NjySsW0w9xidHVMXE9SyFMJW8wABAOpxCaeOkiu3DkCm4Ko2vNYolvdgff79GcHEwFLx1QEHnAvM3AxrjG3Gfa5C	2021-10-20 21:10:32	2021-10-20 22:10:18	12f763fa-cfc1-4597-a0d8-3b4d0cfe63eb
289	1	jLONNLW_8zFYhK1Zx0P1gIh26HX4pv7Ucod0nSbXOSrD0TWt9DnB-_oFNzZ_SauM6zUsxug73dUiIhrsEPGzDCO9mhdBGAlxCD5l	2021-10-20 21:26:23	2021-10-20 21:27:52	429a1b4a-9b9a-4715-89f2-284ef13b70bd
275	1	SZ_eDmAfAxS7a3t4jZbxILAVMg0QIbjf7HuayZtiAFShNTx00cZx-8Uto3kKiWghPg2Cuh2SFRKhHRIAlc_ywr-NJ2tYx5X2rI8X	2021-10-13 18:45:50	2021-10-13 18:50:56	6732ea48-f170-4094-bdda-6a2095b23beb
276	1	w2AQCUZLlHk4I9ZVFTHkZe2cPzPxzqRGeSTuLFGrYYQCSo2O9VC5GzUayxfYRguhuW3FKM80QyCKYsM3ozpWA9DyAj5QUfKlTcPh	2021-10-13 18:52:09	2021-10-13 18:52:09	74bbccc5-682a-44d8-84fd-10cddad9a51c
277	1	J8h3WRkVCrFXB2ZGJQ18t4_nNAPW_2S-OpspNmiCOXygQeALfk4LHJ87f3OJlA6T0byKmltBghl8ctmRwmWK0y5Ez3scby63fjnJ	2021-10-13 18:52:25	2021-10-13 18:52:25	27bb0e78-0ccb-41f5-a632-15c1a0ff2b63
278	1	4OCmn_tu2vFVOIriQQG3SCsK1hsUlZa5da9xglXjozEPXTGeuiWxCUL-JmNMLXYfOU2Qt_6g8JafkNG-hizlFJ8g82EWGokwgnrU	2021-10-13 18:53:39	2021-10-13 18:53:39	a0b23af1-1495-4645-b8ff-3e09865b08bc
297	1	xZ4ON_Qhv3-nmNquCxqjJqynl4HS_HgsBn7FhWyYk_Rl-l29R8AwRwZZgwhxwzj1QicX4Ovv728YF9cUmObTKRJhPmeRs1-QJ0av	2021-10-21 17:17:04	2021-10-21 17:20:13	7b7def75-7344-4f42-ae8d-e0729fcab6b1
280	1	qO_UULo40qA29mOZmEERJ24niSMdYvnYb6ZKOgOxiXeoIiArJrIe9Jz5Nmrlg-Sf7E6TNj_ZtZ3gglzdPHayT2NrmjyjjGzuIKkK	2021-10-13 19:06:39	2021-10-13 19:08:12	7b9c67ab-730c-4984-bbc3-589bbaeac45b
296	1	NO_A3HGuhHB0o6KOwe1H7GU5hp_yY9Y1giTt1gCoJ-I6tICPuHGQbP0cfTSzGTGIvkAisLPVN13JoBaTnYLUY5T1iuR0CKKCqmu0	2021-10-21 16:28:32	2021-10-21 17:17:04	75a6c893-807e-45b6-bc09-1abe87306671
292	1	_A4bb9BJZWeJUaIzO5f1D1iNbi10iOy3gW7wiAgQImkEfjxDL0ANFOIfs7t_UAZbhGWnw8xrKhcTDAtGMBmTIRRhT7REQ8RRLvsF	2021-10-20 22:10:18	2021-10-20 22:11:08	3831d037-22a3-4868-b17b-e98d887c83ac
281	1	4mZz98B77mTQZLSC_yU-Bqg5M1n8mHxZq-uIDw8-EU20y-OoFG_of_sYNMNVPCp5Ej1CwW_bYp0txOz_PfSvaCJ9FdFWzd4CjGfn	2021-10-13 19:09:14	2021-10-13 19:09:18	e607f413-bea9-476f-940b-9c70c233f934
279	1	dZZSkXUU744Wncz6hS_eStqLzFzvPpb1uvJA5krQ5PIR3VoTi35CiOELE14emndz7vRES6O7eS5I2gbm8vPt2ghvJcB_DoRD2sZi	2021-10-13 18:53:55	2021-10-13 19:05:12	5a71ae2b-a11b-471e-8731-4770c62d3054
282	1	k1Zop_BoHzEyQCfZkhczFeuanLMmi00HMkdjcNG92F-j_xAS-begO5wADvUt099J5J8ksbc46NCgHSusMmIoH1aylyTZkNU8Ywe9	2021-10-13 19:10:43	2021-10-13 19:12:12	6b9ae2a1-0ddb-4db4-8893-e14cee4b4cff
283	1	aNnjdV_ZhspeW-1iZiGFWV0zu70sNGL60DF6e4IRnO_2IX--e9MHwAhT20NETlnwmBDcEBJx1f3yKLO3PJjkMGIjuxZdGjp_iPm7	2021-10-13 19:12:18	2021-10-13 19:12:18	2029a8d3-95b2-40b5-b79d-1b989478c84e
284	1	T6uQo7xaoSxNEFVJcHU_meX4PAdk-KhbQRi8nJW149W0gkpavPlzTRLCets1LTdoxXTaN7ATyc4GyRjT7qL_dQDo4vryxVnnC3AI	2021-10-13 19:13:33	2021-10-13 19:13:33	c237f9fd-28a3-4703-8d2b-eddd4932ede6
293	1	tDnv5yr4Tlu4NpQ9C2v-m-FqpvFs9nsBq7NMLURlmZtbTUJysP3qgceHYsWiqbNulMwcoyKsyVX4SUgkajLa_9WbLWZuHCEAKJV-	2021-10-20 22:12:15	2021-10-20 22:13:30	0b0fd023-474e-41bb-a740-20370e20d5e9
309	1	Xq4V02QE4BmFmIwq36lKtVg_z92NMSd6nwHCMwvy_CwU-QMQ5NJDpNDJVxpo0TZzFZNlX7MVifwnspZPsyHFjTJ0varTBDez9B-n	2021-10-25 22:01:44	2021-10-25 22:04:02	807a93a6-8948-4649-b182-80ea6576e9bf
310	1	8Dk2JvZU2tLlrV2EU7LZ_tUwGWGsy7r7EAuRFtYjPwciVHqb5n5vIrCgyKtl83u_mFJ6Cig1TpMmDopgaa2VSrIsQnaLrqr1DqUx	2021-10-25 22:05:08	2021-10-25 22:07:11	bca07a8b-3cd9-4586-9f0c-d943ea157c6c
285	1	vOiuZDzAmCrSkQpD2D7Wln5ZZTPaWXquPr9zspFsqnulhMtWxG6opXohMRf_h3jtkPaXlpOFOzuFTJTVZ20gHmu7gSlpqFRjbICj	2021-10-13 19:13:34	2021-10-13 19:22:55	27fe8151-62c2-4cf2-9275-c6ec5fff0985
290	1	VRddXvoBDsO9Ppg69FFqMm55R_C-gFnzl61vO50OMFbeRBM5kUiGQBWoGFsF-9Lo5ZDJi0PH2WqE43VoeBp_djXf21MfNKcQyy3p	2021-10-20 21:28:53	2021-10-20 21:49:59	c1463b29-7f77-4cc3-bcf1-b5f641fe7fd5
312	1	LE6hD82_WM8U6TqTptAojtCsSlUe1_LzZvTCNkgZA6CDpaBGpxwroypm54J1tGY-up3xckYFfk1Kf1-HFcC_aS1iwDgtWXADJaYb	2021-10-25 22:09:25	2021-10-25 22:12:29	c9a6ae9e-3393-4fe0-92d1-07b924b3ae04
303	1	5Zdih61GZHY8DSmfc3-q7y0_nFhxcO5KAAj6uZUy2KvXqLemYpnswJT_QnYd1yfrJlk4orY6i3gXcm6QBbSgVagLMTSKxp6zdBfI	2021-10-22 19:51:05	2021-10-22 20:19:44	6b87a5b7-03a9-4ce5-a49c-475ed5407873
313	1	tjhLYwydJrMWTD0zzyPEE-na8wlrI-Pys2XYMnI-U_S7A8g27ABEs_k2KASArt0NOs3X6kgjcpZjuzn-rb5KsD5gToZI2Ak9EHDm	2021-10-25 22:13:33	2021-10-25 22:17:55	faae542c-8e75-4cdb-8f03-700d2819dc5b
314	1	v2cs6QsmyE0Mvy9g-2OW4tUFmB4mm4Nl2IbCJt1RHyu-8QlG6aLax32NhqBf8pCBPuo54vP23iyyNyVzO79jgIC_hQP8q6h_y2WG	2021-10-25 22:18:58	2021-10-25 22:18:58	123142b4-5a5f-47d3-b73d-4ba0bfc68aa1
302	1	dN1TSX2n_DvRwzgtLbfbCfIAki74QNDXI--e51yrIGnL9rfvN7dnRBVRY6dhavVKumyaajLcYBpHnK3HvLAh_3lvyDrcF0-cDQ_Q	2021-10-22 19:10:03	2021-10-22 19:10:16	9ee129ee-ccab-4c4b-8850-99efb01052eb
305	1	lE223hZpEyH9kHIUyHvZTvzBu1bw8qc8tR6HFUktRs218fBs1NZUV21Z4KeWrs1cquYOKTSeViX5Gf3gAAtAfntSnFHDnGSxrAzr	2021-10-22 20:25:46	2021-10-22 20:38:59	3fce8dfb-189e-4061-9a00-737fc8ab264b
304	1	nQr2KV28PV6byR4CMM1xivzlQCHWoQM0EmpLGXM_o761nvAdz94GkNlvMdZM6fURtSDL2OfuR6uV4UaOgdkIus2cZu85uMM3xBMz	2021-10-22 20:00:50	2021-10-22 20:40:01	4cae5cbf-a1eb-4e3c-8a6b-5b45f8a164db
315	1	7x6J7NPsh6YTk-N6e37W3QwykJZU4WPMzvTLC5oOlPL-ooaMFHNlnOTEreJeAqRWHV-7VzBv7YajhC7iPAd3wKSECqxbvW74yLrv	2021-10-25 22:20:28	2021-10-25 22:39:24	7587a36c-f875-4679-8864-0d0c5abb6bc6
316	1	lI9Z-Zz_1iUHt7fEK1z0gBxcwur44QeIATDfFaXoAQLswDjGco2rte63IHysTrDlLQKdiFLf-4wl0To92P7LE7DE2aQzk29exmEC	2021-10-25 22:40:25	2021-10-25 22:40:25	824b16ca-76b7-4a89-9196-d32fefba4dda
308	1	gEITS-8JusCwKfilnvglTmo6htQaaBmtPf0jvrQyQZAp96knmR9UH9S0eQ2gzusPC6eGH4oWS46xJLdQMVflKbRShAIGyrrAfB4G	2021-10-25 21:50:14	2021-10-25 22:49:56	8719315b-0f25-4c27-adff-1f780e10be33
299	1	ciyvlXOVlckPslKj9gCeGMR6ZR24HwOD2D-DirXm_Mp_WDa8LOnlk6F2eBr_6vVc1b16dnvW5lhzdaotk7RWJ4gKjzDxNbArqUmW	2021-10-21 17:48:54	2021-10-21 17:57:39	7057644e-c4de-4715-824d-4308c94ec094
300	1	4DXCw4ssrTPsvBdfHel_P9RE4-8IbrbBPr0InvyuIa-Pm-Skzn7jEVSQ6nQZcvtLweMDHReDICni77P3G30Yd88X5LpY4-NIgrae	2021-10-21 18:24:48	2021-10-21 18:25:52	795c45ca-aad5-4741-b166-90b2518ade60
317	1	a5sRadrFafKy2MOWn-fT_8CQ1RWE_uUAXkWMCW6Xm_WqHtRw88zd44QKFBqFSqZQ-4H60_GPHc7F_PQemy9w2XbF2xxPWe7qBE__	2021-10-25 22:41:55	2021-10-25 22:47:32	26a1a1df-8a18-48c7-a4bc-094cb6797a7f
318	1	p4O4QLZTHQjNqgHLlz7I4PRz-SZcVXYBLGaz_--w2_Wzr9k5L_ADLuoZCvcS48MTZSDhsLBcRB5D0KdwdCr-f4nQWEe4oAOUfayW	2021-10-25 22:48:33	2021-10-25 22:48:33	aa7d2d99-1f1f-4b61-88bb-ddd20307ab8f
323	1	5pqSoGcRKYXISSOwDeN3GpFdEc6iktZu1eTUvpNHLRTeZNpiFeIdKrZpXhyDeJEhTZf73Kav-WPt3z1x9NtBJCyr4yrqd9pSaFa7	2021-10-26 17:30:30	2021-10-26 17:34:06	1514b7db-19db-4411-920d-7724eae0d632
320	1	X-QXhnYCLKztDnbmQXZH8Ph2Q9oXSKrMdWcVye3ULFXyW1FpBY08l_J1pKAh6SMzA7hessVhQj2slQy_AT3aq-Nkr8vwml12unnj	2021-10-26 17:01:58	2021-10-26 17:10:32	b477e25d-f321-4ac6-9179-da845d87a8e1
335	1	JRNM8RdmRFCYJ7GiamaHZ_rkkok65FWt24xMTBGfTSw7wlquGFHwiKAUD_oHXxmyj0Yo6L9LUTT1C74IPN9PpTP2gqG-Lw5-ond3	2021-10-27 21:52:50	2021-10-27 21:54:02	a7012468-413c-49c5-8b43-90bfd40e8090
324	1	M8WkwBmuU-JlMdcJK7HujE_83Wsk2iwQS9PbxoKyCi_duUe2w37OIXZdpm_rnNgAY8XJyTRmhIHfoXILR_c6u8gUUxK8bhqkXdCS	2021-10-26 17:35:36	2021-10-26 17:35:36	42120c4a-1466-4922-a2a5-3c0fda60564c
325	1	qG7ZRop25jx_4_kKqvNI8KJhE6ItWBS0huEbJY8BVGnrnG-7X7xWU2s-S5A_wFgPDpMLpr38U_zizp0XGC-Xun66RVe1nAZ9jhIm	2021-10-26 17:36:40	2021-10-26 17:36:40	1716831a-9644-4190-ad79-c6aebbf826f4
336	1	lWTlBaTyz6Wme0uqHge0Ex0qrxTsJU0zaNk3p2Sf-H2dtx4XqOa8xfNrKnSnACsuIHF1OELaNgCpFrzoyPLfHN_VIwZyBaIbT2Mw	2021-10-27 22:08:10	2021-10-27 22:10:30	c20b5ba5-3c8f-416a-ac40-ac79a5e516be
326	1	E7UL7NI_svQx4FVb-YlkS4bNlKa4cFakkZ5vN4WFWq42Lq0OeacWDTFEQp-mCLLFYAHjzDs-lJIS98Y4ck3vz4b0nFvyEdb64ooK	2021-10-26 17:38:09	2021-10-26 17:38:09	0b2f899b-fedb-4369-8d8f-67fe3aeadb63
322	1	nMhuG0msQnFYA4IDeZYvW8_EMjJBHCpo3Ue4n_C78Qgcfkgp56zkgYckFV08IBSiD4lJkOvtOrGoM9NVloSiQi7GIc9Da858Ez8a	2021-10-26 17:28:15	2021-10-26 17:29:27	03bf5678-566d-411b-ab39-39646ecb3cd3
327	1	fmpNiadV0S24ZCH0DEz7TpGjVR5V-Vnx6RMoy0B2bUX21g9Ha2cAM2hD4n5kpoXOGznKRNmyWW_SXH4sZmeUfn7F6qRcSPDgESa7	2021-10-26 17:39:13	2021-10-26 17:39:13	f5b04806-ea50-429e-a25b-ae38a484c449
328	1	hnHJh04EGEc2Ox-Ok_RIuxXloMkSStjFqbkc4X18DTyTSxq96aM5F_-HS5ysEMTjId1-UFlbprMipGH85o0XRo3j_S3VbVtlfPEb	2021-10-26 17:40:34	2021-10-26 17:43:15	c8e92f0b-89b0-460a-bc1b-304da74d4add
329	1	XfSbQxdDpgJjnONZAbJntW0KcQ_5QzEMHhpv9MoWQZJR52daUWY93306tCccfKGrrTF-75f-HGqR628J3sBsfWDNWwL4nYa5ES-N	2021-10-26 17:44:21	2021-10-26 17:44:21	8e3b991e-69a0-418b-bc6e-ff4a413b8ac9
330	1	_RMvLK3IZtsfn2QGTXU4p2suZ_yrtyRkCo4IhGBeh-97kw80UkEj96YskBGVUnc7A30H6Dglyl3y9kCt5LmY8sk4KJEVeG_1hMpJ	2021-10-26 17:45:51	2021-10-26 17:47:09	60d50b18-a270-45f1-b83f-a6f8190d44d4
331	1	-kYRhwwcAXxFwMakdBqPjZ1g6DwU7y_eP-i6DBECsI2qEQNSb4FNHicASuoUFpe17oBKU4bOKmYZwBqPcG33-7bmHLymo73jrxWr	2021-10-26 17:48:33	2021-10-26 18:08:33	d70a544d-9cea-4d1d-9cbc-62779748e23a
332	1	4OX7lM1B9EhxIGoZtYzZnwm-hCivvVafed7xEZEli_157iP43eYoNn4fkBa1DBhldmUTbxY2nDMkyJ5jLW9w_98V_WKHGwBVC1n9	2021-10-26 18:09:58	2021-10-26 18:09:58	0999dd4a-260d-4ac0-a9e0-7151f50b3a24
333	1	-2iEQ1kSLuLUtFvcfml0v3RtmaEkrmQ4mGlalwf4pdDBaqzKHtGlyrsb7M26tdQxH3-66KoJWGuTSUQebJ3NjUcheHj6RNDzQ0D6	2021-10-26 18:11:12	2021-10-26 18:11:12	947e7b75-2ba0-43aa-a999-961ffc4d8fa2
321	1	eTqZMa4oxhc9Oo1D3E8gC914jqPK1w_1IXBLU2-L00XOw1CWbIhwTlC0UCF3sqDqKEFN8-uyEAdb82-JEOqOGdRvL9NJOYxft50n	2021-10-26 17:14:21	2021-10-26 18:12:41	8fa5e161-efad-4bda-91f8-04c249e59979
\.


--
-- TOC entry 4642 (class 0 OID 16830)
-- Dependencies: 280
-- Data for Name: shunnedmessages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.shunnedmessages (id, "userId", message, "expiryDate", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4644 (class 0 OID 16836)
-- Dependencies: 282
-- Data for Name: sitegroups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sitegroups (id, name, "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	Skyviewer API	2021-05-19 21:09:33	2021-05-19 21:09:33	\N	c1f0a2ee-3b87-486c-96ed-7e2d25fc952f
\.


--
-- TOC entry 4646 (class 0 OID 16843)
-- Dependencies: 284
-- Data for Name: sites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sites (id, "groupId", "primary", enabled, name, handle, language, "hasUrls", "baseUrl", "sortOrder", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
1	1	t	t	EN	default	en-US	t	$PRIMARY_SITE_URL	1	2021-05-19 21:09:33	2021-06-15 15:02:03	\N	763c0189-f6eb-419c-9ca2-2574a743768a
2	1	f	t	ES	es	es-CL	t	@web/es	2	2021-06-15 15:02:03	2021-06-15 15:02:03	\N	a6b28fea-2f0c-49a2-b82c-fd16c51d9511
\.


--
-- TOC entry 4648 (class 0 OID 16855)
-- Dependencies: 286
-- Data for Name: structureelements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.structureelements (id, "structureId", "elementId", root, lft, rgt, level, "dateCreated", "dateUpdated", uid) FROM stdin;
1	1	\N	1	1	2	0	2021-05-19 21:19:04	2021-08-12 21:49:08	72e1b935-3657-45d4-95c2-a8b577f88d76
35	3	43	34	2	3	1	2021-06-15 21:36:09	2021-06-15 21:36:09	46f24914-6955-4f7e-9540-6c2cd6bc6fe1
89	9	140	85	4	5	1	2021-08-06 22:56:21	2021-08-12 21:49:08	d794eb74-162d-4740-b1ee-91f18a0c4a3f
106	11	\N	106	1	12	0	2021-08-17 20:28:31	2021-09-14 22:40:56	b30a8873-fd22-43d0-9df6-99db2ddb9ea7
123	11	208	106	10	11	1	2021-08-20 21:55:51	2021-09-14 22:40:56	e6fbd9cf-02cf-4fb9-aae3-550097bdf211
60	8	\N	60	1	36	0	2021-07-16 18:43:22	2021-10-22 19:54:15	b0cc3688-7746-4b6d-92c6-f7e7cbfa87d2
40	4	47	39	2	3	1	2021-06-21 22:42:31	2021-06-21 22:42:31	c2b0c426-1b64-4516-a210-589339b8e26b
190	8	367	60	34	35	1	2021-09-29 00:03:19	2021-10-22 19:54:15	e0e01564-9c29-4e13-afb7-fc104db07f7d
137	4	243	39	60	61	1	2021-08-30 21:32:35	2021-10-08 23:08:18	4c58a99c-c20e-43f9-9604-28d25717a063
45	6	\N	45	1	4	0	2021-06-21 23:06:50	2021-06-22 21:50:11	3f3080be-b4ce-4d10-be64-ce56d01bc5a2
47	6	61	45	2	3	1	2021-06-21 23:06:50	2021-06-22 21:50:11	237f1a25-74fc-4684-8ad9-7a8b8b2aa5a0
42	5	\N	42	1	4	0	2021-06-21 23:04:33	2021-06-22 21:50:11	f1fc6068-4646-4395-aab3-ee1797c5fff4
44	5	54	42	2	3	1	2021-06-21 23:04:33	2021-06-22 21:50:11	ee943f6b-e8ec-407b-9879-d8e8f9bb5da4
133	4	227	39	56	57	1	2021-08-30 21:31:02	2021-10-08 23:08:18	2e1c9308-e2f6-4f7e-aaa0-941a1b45ac94
34	3	\N	34	1	24	0	2021-06-15 21:36:09	2021-09-16 20:37:21	f7d5b331-ff60-4d2e-9257-ac70e842742e
50	7	66	48	2	3	1	2021-06-21 23:15:44	2021-07-16 18:39:45	ea7d804d-7281-4ae8-9729-7d80360a9cf5
38	3	46	34	20	21	1	2021-06-15 21:38:14	2021-09-16 20:37:21	43228843-7d6f-41f6-8c09-924288d7fc97
37	3	45	34	12	13	1	2021-06-15 21:38:14	2021-09-16 20:37:21	211fa683-1359-4d32-a018-74527fcb60dc
61	8	92	60	2	3	1	2021-07-16 18:43:22	2021-07-16 18:43:22	ba71ac17-9cf9-4dec-9de3-49e4dc494e52
110	2	188	3	4	5	1	2021-08-17 20:35:46	2021-09-16 20:39:46	5dc19bf1-a62f-4611-a1fc-d442cf30fdba
109	4	183	39	32	33	1	2021-08-17 20:29:06	2021-10-08 23:07:35	ec3580c8-4306-4be2-936d-f2d44cd28e66
62	8	93	60	12	13	1	2021-07-16 18:43:23	2021-10-08 23:04:53	899f2cdd-74f2-4482-b8e9-ee8702c03aab
65	8	103	60	10	11	1	2021-07-16 18:45:50	2021-10-08 23:04:53	6019f75d-cd10-4d5f-ad1f-adfcf678bdc2
125	4	210	39	30	31	1	2021-08-20 21:56:58	2021-10-08 23:07:35	4e8077e5-f562-41fd-9e18-6c606b17e562
48	7	\N	48	1	4	0	2021-06-21 23:15:44	2021-08-03 17:03:52	7504d616-6b61-4fa0-9405-ec307fa7885c
107	11	178	106	2	3	1	2021-08-17 20:28:31	2021-08-17 20:28:31	b1c2b2e1-cf0b-4095-bd98-a1edc727df78
148	8	292	60	24	25	1	2021-09-08 17:58:54	2021-10-08 23:05:42	0d76f5fb-fe1c-420d-b357-064ed4ac5070
147	8	291	60	22	23	1	2021-09-08 17:58:53	2021-10-08 23:05:42	b6555d10-651c-4b0c-bec1-26105314a298
134	10	229	104	4	5	1	2021-08-30 21:31:28	2021-08-30 21:31:28	4c709b2c-117f-4f6f-bbd1-931955c74156
225	8	442	60	30	31	1	2021-10-22 19:54:09	2021-10-22 19:54:09	64dcff40-8df7-4ae5-80a3-0297a1feac49
120	11	205	106	4	5	1	2021-08-20 21:55:12	2021-08-20 21:55:12	738c057d-5ee1-4d37-bd5b-69c375482134
215	8	407	60	26	27	1	2021-10-08 23:05:58	2021-10-08 23:05:58	abb657f8-cd3d-47cc-b577-067c03f7932c
221	4	429	39	54	55	1	2021-10-08 23:08:17	2021-10-08 23:08:18	e02508ed-178d-4065-986c-c04600d47a67
209	8	401	60	4	5	1	2021-10-08 23:04:53	2021-10-08 23:04:53	b530de0e-266f-4a0f-b35e-c4998dc48e75
116	8	200	60	8	9	1	2021-08-17 20:41:25	2021-10-08 23:04:53	cdea30df-3d42-47a4-a443-b7a25b8f8d41
124	8	209	60	6	7	1	2021-08-20 21:56:12	2021-10-08 23:04:53	5a754427-72e0-437f-8ec5-f8b7b0ce5b18
163	3	330	34	6	7	1	2021-09-16 20:36:17	2021-09-16 20:36:17	50e46fb5-e4f5-46e4-8cc6-2713959a96d6
167	3	334	34	10	11	1	2021-09-16 20:37:21	2021-09-16 20:37:21	9b1fe3d1-8795-478c-8880-b06fd181a420
161	3	328	34	4	5	1	2021-09-14 22:43:07	2021-09-14 22:43:07	1e41db4c-9877-4f13-8ebf-f7f7d18bb017
181	2	354	3	30	31	1	2021-09-28 23:40:56	2021-09-28 23:41:01	dc08b0dc-6572-4009-9191-a703ade6de14
84	3	135	34	18	19	1	2021-08-06 22:26:30	2021-09-16 20:37:21	bf3ce327-a16d-45b6-8691-097269bf1c3d
96	3	162	34	16	17	1	2021-08-06 23:06:48	2021-09-16 20:37:21	4a7bc929-e9fd-44e1-8c8b-9d4bb9f53ca4
102	3	172	34	14	15	1	2021-08-17 20:25:16	2021-09-16 20:37:21	4f137821-9108-4184-a1aa-a942d03b5a70
171	2	339	3	28	29	1	2021-09-23 16:56:37	2021-09-23 16:56:37	4d78dfc7-77d8-4847-b281-f110d6b95d17
6	2	9	3	18	19	1	2021-06-15 16:50:17	2021-09-16 20:39:46	158dbe22-d813-4741-96ca-19e92a110aa2
7	2	10	3	20	21	1	2021-06-15 16:58:55	2021-09-16 20:39:46	ab9375b3-08a8-4fc2-8208-935b4c4d4fc6
8	2	11	3	22	23	1	2021-06-15 16:59:52	2021-09-16 20:39:46	62fd90b0-8279-43f6-b3fa-e642a93312e9
9	2	12	3	16	17	1	2021-06-15 17:04:56	2021-09-16 20:39:46	90732259-4489-4127-b473-e4ccd83eebeb
13	2	16	3	14	15	1	2021-06-15 17:21:23	2021-09-16 20:39:46	050f9431-cb8d-41a6-aeba-acf340543915
14	2	18	3	12	13	1	2021-06-15 17:23:28	2021-09-16 20:39:46	e7964ede-821c-4e28-8413-c1b3bdce12b2
70	2	121	3	10	11	1	2021-08-06 22:23:03	2021-09-16 20:39:46	2258a692-0e7d-4a67-8f51-a4b972f2d8d1
219	4	420	39	24	25	1	2021-10-08 23:07:34	2021-10-08 23:07:34	afc2aa64-1d52-4a51-b076-65445c244918
203	2	392	3	100	101	1	2021-10-08 22:42:55	2021-10-08 22:43:21	6fd0157f-6a19-4918-931e-f51650997e7b
85	9	\N	85	1	8	0	2021-08-06 22:54:32	2021-08-12 21:49:08	0b6a9b32-716b-4899-8bde-62f014aa2ba4
136	8	241	60	18	19	1	2021-08-30 21:32:31	2021-10-08 23:05:10	cd5df6fa-38f8-4292-a258-9354dc602de2
121	11	206	106	8	9	1	2021-08-20 21:55:30	2021-09-14 22:40:56	92ac28ae-a5a9-49e6-8fa3-483876857446
135	8	240	60	16	17	1	2021-08-30 21:32:31	2021-10-08 23:05:10	cfb4ba92-1f34-4adb-a98b-0ddcf6214d7d
143	4	267	39	58	59	1	2021-09-08 17:54:52	2021-10-08 23:08:18	84489e75-40d6-46f9-9d59-c297208aa6b7
149	4	294	39	62	63	1	2021-09-08 17:58:58	2021-10-08 23:08:18	7839df44-f424-447c-ac77-3e41891ab6c0
197	2	383	3	34	35	1	2021-10-08 22:40:17	2021-10-08 22:40:17	3bee82ff-7b3b-4d5e-836f-926c9225b314
63	4	95	39	26	27	1	2021-07-16 18:43:41	2021-10-08 23:07:35	8ffacab8-cf02-4100-bd57-72e0c2f8da53
145	4	275	39	52	53	1	2021-09-08 17:55:09	2021-10-08 23:07:35	4d0cf6b5-3632-45eb-9127-f1e6d2f216c8
119	4	203	39	50	51	1	2021-08-20 21:48:32	2021-10-08 23:07:35	f83b5f31-d9cb-4239-86f9-50a00d02ddba
64	4	99	39	46	47	1	2021-07-16 18:43:41	2021-10-08 23:07:35	e7066de4-c61a-4429-b0d4-fe61a06352e1
95	4	158	39	38	39	1	2021-08-06 23:05:17	2021-10-08 23:07:35	919c04cd-0122-4a12-b99b-f62b79e6e1e1
139	4	251	39	28	29	1	2021-09-08 17:50:58	2021-10-08 23:07:35	73dfd31a-eb73-4095-be68-5768187bc006
94	4	154	39	40	41	1	2021-08-06 23:04:44	2021-10-08 23:07:35	6c0d98bf-a295-4ddf-adbb-880b1908dc00
108	4	179	39	34	35	1	2021-08-17 20:28:35	2021-10-08 23:07:35	daa995d7-d660-4076-a185-6a83cb7defcb
117	4	201	39	48	49	1	2021-08-17 20:43:58	2021-10-08 23:07:35	54172e7f-a47d-4b95-aa04-a603534e10ef
91	4	145	39	42	43	1	2021-08-06 23:02:51	2021-10-08 23:07:35	4c78cbab-3dab-4e58-9607-fca86df6548c
103	4	173	39	36	37	1	2021-08-17 20:25:35	2021-10-08 23:07:35	ec93edd5-86a3-4760-8c6f-b950a33eb6fd
39	4	\N	39	1	70	0	2021-06-21 22:42:31	2021-10-08 23:08:50	5fe7bae2-03d6-4e1b-bb75-8f9d159f127a
153	4	311	39	68	69	1	2021-09-08 18:26:58	2021-10-08 23:08:50	3490dc69-99aa-4704-8c76-9da46967522d
150	4	298	39	66	67	1	2021-09-08 18:23:50	2021-10-08 23:08:50	62534936-63c7-4d74-aa72-56b89ac1a0f7
132	2	226	3	104	105	1	2021-08-20 22:04:44	2021-10-08 22:43:21	01b57a1a-ba71-4471-9ada-c115b904ac10
130	2	224	3	106	107	1	2021-08-20 22:04:11	2021-10-08 22:43:21	7a0d6112-ac42-4f9c-b575-a4ddb1a621fd
199	2	386	3	60	61	1	2021-10-08 22:40:48	2021-10-08 22:43:21	adc611eb-c92b-4e73-8142-4b490e406c59
104	10	\N	104	1	6	0	2021-08-17 20:28:22	2021-08-30 21:31:28	370fd9cf-66c4-4555-a1f0-b1110201e845
88	9	139	85	6	7	1	2021-08-06 22:54:56	2021-08-12 21:49:08	de9c283a-820c-41f1-b37e-d2201f09ba35
92	9	149	85	2	3	1	2021-08-06 23:03:19	2021-08-12 21:49:08	ad9c1520-59a1-409d-83c1-0b106aced71f
223	4	437	39	64	65	1	2021-10-08 23:08:49	2021-10-08 23:08:50	878f1ea7-38df-4ffd-bb7b-7df30c63f9df
122	11	207	106	6	7	1	2021-08-20 21:55:41	2021-09-14 22:40:56	e7f12d89-8041-4e17-bf62-d0cf8d0573fb
105	10	177	104	2	3	1	2021-08-17 20:28:22	2021-08-17 20:28:22	74a7dda3-27c4-4c90-897c-6f50e6bc8f81
152	8	309	60	32	33	1	2021-09-08 18:26:41	2021-10-22 19:54:15	9c287bd3-e4fa-4ee1-b06f-90729480eb24
118	3	202	34	22	23	1	2021-08-17 21:26:23	2021-09-16 20:37:21	3adc404f-b8b4-4fc6-a80f-b153f6afa843
151	8	308	60	28	29	1	2021-09-08 18:26:41	2021-10-08 23:05:58	c3c36510-cd30-480d-a1be-b076083dd891
165	3	332	34	8	9	1	2021-09-16 20:36:42	2021-09-16 20:36:42	9024d442-1496-4b32-91cd-4740b0c8afb0
194	2	378	3	32	33	1	2021-10-01 20:33:23	2021-10-01 20:33:23	a54b6d78-cc38-42d7-bc2e-046f28d317d2
141	4	259	39	4	5	1	2021-09-08 17:54:32	2021-09-08 17:54:32	907b4ad1-009c-4a7c-bd98-1c0bad6b1dca
211	8	403	60	14	15	1	2021-10-08 23:05:09	2021-10-08 23:05:09	69caefd3-5b44-406d-af73-931ecee8461b
72	2	123	3	8	9	1	2021-08-06 22:23:25	2021-09-16 20:39:46	1a50d59f-476b-4406-a732-12f2119049dd
77	2	128	3	6	7	1	2021-08-06 22:25:32	2021-09-16 20:39:46	0e8c6468-edea-4613-ad0f-df1e00c8e70c
126	2	220	3	2	3	1	2021-08-20 22:02:00	2021-09-16 20:39:46	1482c600-b26d-4022-9e7b-c76e3059c25f
155	2	316	3	24	25	1	2021-09-14 22:23:01	2021-09-16 20:39:46	97d3ea85-c4cb-445c-bcd7-d4ed28b84a33
213	8	405	60	20	21	1	2021-10-08 23:05:42	2021-10-08 23:05:42	6423d59f-d3e0-48be-b305-1b3d61fb22b1
217	4	412	39	6	7	1	2021-10-08 23:06:43	2021-10-08 23:06:44	a8f3144f-6a71-494e-b57f-3315c3a8a8d9
52	4	68	39	22	23	1	2021-06-21 23:15:49	2021-10-08 23:06:44	2740cef1-a005-4b88-88a4-fe7d33cf344c
67	4	108	39	16	17	1	2021-07-19 22:32:13	2021-10-08 23:06:44	6108b9cc-b18b-48bf-b467-393fd1ab49ed
93	4	150	39	12	13	1	2021-08-06 23:04:32	2021-10-08 23:06:44	f1a86b98-f876-4a3f-a3b6-a5e43230b0d1
101	4	168	39	10	11	1	2021-08-17 20:25:11	2021-10-08 23:06:44	7fc3a58c-b64b-4c2e-8d96-b5edc0fefc96
90	4	141	39	14	15	1	2021-08-06 23:02:41	2021-10-08 23:06:44	00e9e63d-d266-407f-b99c-913b19dc4351
53	4	70	39	20	21	1	2021-06-22 21:51:08	2021-10-08 23:06:44	def3940a-ffa1-4ae2-9fc9-94939ecad26c
54	4	74	39	18	19	1	2021-06-22 21:51:45	2021-10-08 23:06:44	87216df8-083f-485e-8a06-1652fcc47fbb
51	4	67	39	8	9	1	2021-06-21 23:15:49	2021-10-08 23:06:44	dd5abeed-edd8-4805-8092-f8cc7ccd6400
207	2	397	3	36	37	1	2021-10-08 22:43:20	2021-10-08 22:43:21	a0d68074-4809-4304-8a3f-22b246cc7d3b
66	4	104	39	44	45	1	2021-07-16 18:45:52	2021-10-08 23:07:35	d8685071-ae45-4a84-8701-08ef1fa86672
206	2	396	3	124	125	1	2021-10-08 22:43:16	2021-10-08 22:43:21	e035ac94-2b79-49bf-9ff7-cb7cc9d3b2c5
195	2	379	3	152	153	1	2021-10-04 22:28:15	2021-10-08 22:43:21	915e89be-196c-4d66-bbca-3730923e5514
168	2	335	3	130	131	1	2021-09-16 23:29:40	2021-10-08 22:43:21	1b07b43d-6daa-46b9-85d1-3af5a9839f89
76	2	127	3	138	139	1	2021-08-06 22:24:29	2021-10-08 22:43:21	9a675ab3-4eb8-49e3-8431-9f90a303fdfb
30	2	39	3	142	143	1	2021-06-15 18:07:52	2021-10-08 22:43:21	1f49419e-669c-44a1-a119-da314aad80ac
27	2	36	3	140	141	1	2021-06-15 17:58:33	2021-10-08 22:43:21	20b9c168-6808-4f5a-9a9e-fba4c2a419c0
58	2	84	3	148	149	1	2021-07-16 18:41:34	2021-10-08 22:43:21	74386108-d0c8-4678-aabb-d29fb24c9ba8
169	2	336	3	128	129	1	2021-09-16 23:29:43	2021-10-08 22:43:21	bf048cf8-957d-4b9a-83f7-2edac3c2d7e3
26	2	35	3	126	127	1	2021-06-15 17:58:33	2021-10-08 22:43:21	1dcaf544-cbf4-4414-a4e0-6f35fd79d250
201	2	389	3	80	81	1	2021-10-08 22:42:36	2021-10-08 22:43:21	5e2fad9a-1bfd-4e7d-b4fc-eb37c9dff7a4
185	2	360	3	78	79	1	2021-09-28 23:46:33	2021-10-08 22:43:21	eadd4e9c-b17a-4263-ab73-e298e85d9ef4
112	2	192	3	66	67	1	2021-08-17 20:36:18	2021-10-08 22:43:21	1f37dcad-861a-4741-859b-163f2e8b8ac2
128	2	222	3	64	65	1	2021-08-20 22:03:07	2021-10-08 22:43:21	63d54c4a-e49a-4d83-81bd-c072829cdef4
18	2	24	3	74	75	1	2021-06-15 17:34:27	2021-10-08 22:43:21	097765bc-4380-4dbc-abcf-22dd10ff18b6
73	2	124	3	72	73	1	2021-08-06 22:23:40	2021-10-08 22:43:21	52290587-c3b9-4a8d-b3f0-127dd2b147ac
17	2	23	3	62	63	1	2021-06-15 17:34:27	2021-10-08 22:43:21	d373803e-b70a-4ee3-b770-e4ff175a3185
175	2	345	3	76	77	1	2021-09-23 16:57:13	2021-10-08 22:43:21	5be748c3-cbd7-49f5-8d55-a4c1e4b9958f
79	2	130	3	70	71	1	2021-08-06 22:25:41	2021-10-08 22:43:21	ff7f86ce-4c20-4d91-a072-7a910f9cc325
192	2	375	3	150	151	1	2021-10-01 20:06:06	2021-10-08 22:43:21	4768d5ce-b0b2-4881-8741-13010f221f8b
57	2	83	3	146	147	1	2021-07-16 17:53:05	2021-10-08 22:43:21	e24927cb-8f79-4e66-be98-11d5c3fca835
131	2	225	3	132	133	1	2021-08-20 22:04:39	2021-10-08 22:43:21	d6c0f7ad-eb77-4a03-b9bc-f570f013f6bf
21	2	28	3	94	95	1	2021-06-15 17:51:12	2021-10-08 22:43:21	81d3431a-de5c-443e-bbcb-9e33a1476f3e
74	2	125	3	92	93	1	2021-08-06 22:23:52	2021-10-08 22:43:21	e7c77835-751a-4cb3-8197-9869e7047da1
187	2	363	3	98	99	1	2021-09-28 23:49:49	2021-10-08 22:43:21	2dca7b29-5b9b-4325-8c32-8e170ed0265f
99	2	165	3	88	89	1	2021-08-06 23:10:10	2021-10-08 22:43:21	481fa16f-5065-4e60-9907-318f5db1eefe
113	2	194	3	86	87	1	2021-08-17 20:36:40	2021-10-08 22:43:21	9ffbbedc-67a3-4f33-8c88-5ced0c667882
129	2	223	3	84	85	1	2021-08-20 22:03:29	2021-10-08 22:43:21	d01d09fb-2838-4dfa-ad13-4b405b4ea3b3
80	2	131	3	90	91	1	2021-08-06 22:25:45	2021-10-08 22:43:21	63d8a808-e2ea-4b3f-b791-ad181b8b8cfa
20	2	27	3	82	83	1	2021-06-15 17:51:12	2021-10-08 22:43:21	32cb872c-a3ea-40fb-befe-e2c75ac9f8cc
183	2	357	3	58	59	1	2021-09-28 23:43:35	2021-10-08 22:43:21	1f69ee1d-d5c1-42ab-b9ff-ad458b839366
179	2	351	3	120	121	1	2021-09-23 16:58:01	2021-10-08 22:43:21	965455d9-584c-460a-a221-7127a16412a0
114	2	196	3	108	109	1	2021-08-17 20:37:03	2021-10-08 22:43:21	ef1bd96a-7743-4753-a013-bbf4ee2f0d0d
189	2	366	3	122	123	1	2021-09-28 23:52:59	2021-10-08 22:43:21	e3845525-85d8-4632-8a87-41de49f8dc32
23	2	31	3	102	103	1	2021-06-15 17:54:45	2021-10-08 22:43:21	e7b52c26-5de6-45b4-89f8-2a87eb0595b6
173	2	342	3	56	57	1	2021-09-23 16:56:55	2021-10-08 22:43:21	3e62157b-2153-40e5-8221-39294ed1f5d3
159	2	326	3	54	55	1	2021-09-14 22:32:05	2021-10-08 22:43:21	02bb8e3e-1ebf-4441-a63e-a25641584d76
177	2	348	3	96	97	1	2021-09-23 16:57:44	2021-10-08 22:43:21	f317a7c0-ccfb-401c-8d81-fcd18246b953
157	2	318	3	26	27	1	2021-09-14 22:23:30	2021-09-16 20:39:46	9df2efc3-395c-4550-9abe-000c61947f6e
82	2	133	3	112	113	1	2021-08-06 22:25:59	2021-10-08 22:43:21	7acc77f6-f27f-4e14-b636-717c40fea99b
81	2	132	3	114	115	1	2021-08-06 22:25:54	2021-10-08 22:43:21	e3735dda-ecdd-4f38-afa3-04d52327a492
100	2	166	3	110	111	1	2021-08-06 23:10:21	2021-10-08 22:43:21	536af618-3d09-4a0b-87c9-fb11229d8e75
75	2	126	3	116	117	1	2021-08-06 22:24:07	2021-10-08 22:43:21	fd7a58f7-bedc-484c-abab-74118001d39e
24	2	32	3	118	119	1	2021-06-15 17:54:45	2021-10-08 22:43:21	8f3f8082-075f-4d7e-9c15-e33d52dcf803
3	2	\N	3	1	154	0	2021-06-15 16:49:55	2021-10-08 22:43:21	8814538e-d087-4892-9069-f4eadd70429a
98	2	164	3	68	69	1	2021-08-06 23:10:01	2021-10-08 22:43:21	362d8fa3-1e70-4ba6-b984-9d050a419597
12	2	15	3	52	53	1	2021-06-15 17:17:51	2021-10-08 22:43:21	88a40907-cb12-4ddc-b4e0-5d9883fc3d8d
15	2	20	3	50	51	1	2021-06-15 17:23:49	2021-10-08 22:43:21	046741fc-75af-4a09-ada5-881718bc886f
33	2	42	3	144	145	1	2021-06-15 18:11:30	2021-10-08 22:43:21	640fc284-4380-47a2-888e-fc6ec8b7d8d2
83	2	134	3	136	137	1	2021-08-06 22:26:08	2021-10-08 22:43:21	0f84e659-24fe-47dc-8fe6-42b5aec0bf16
115	2	198	3	134	135	1	2021-08-17 20:37:17	2021-10-08 22:43:21	995ab449-bbe1-458e-a4c3-44a0f5dd611d
127	2	221	3	40	41	1	2021-08-20 22:02:33	2021-10-08 22:43:21	e6a70aa2-4f03-4afc-ac40-4279d8d0d3aa
111	2	190	3	42	43	1	2021-08-17 20:36:03	2021-10-08 22:43:21	913e33ab-4b81-4fa7-a9ea-9d9ce6a13e5b
71	2	122	3	48	49	1	2021-08-06 22:23:19	2021-10-08 22:43:21	6c933095-02dc-4b97-bf7b-30c39e6c5ef5
97	2	163	3	44	45	1	2021-08-06 23:09:51	2021-10-08 22:43:21	3aef8f64-3190-4d99-bc42-dfe859dcec7b
78	2	129	3	46	47	1	2021-08-06 22:25:37	2021-10-08 22:43:21	a3098dba-b62d-4fbf-bc22-47b5268a926c
11	2	14	3	38	39	1	2021-06-15 17:17:51	2021-10-08 22:43:21	06b9fbd6-a1b2-4ae5-91e8-994715385796
\.


--
-- TOC entry 4650 (class 0 OID 16861)
-- Dependencies: 288
-- Data for Name: structures; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.structures (id, "maxLevels", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
2	\N	2021-05-19 22:59:19	2021-05-19 22:59:19	\N	ae4c1bfa-0825-4ccf-b090-4c79bed024bb
3	\N	2021-06-15 20:53:27	2021-06-15 20:53:27	\N	505d6993-ce17-4b37-aa55-28a180963d52
4	\N	2021-06-21 22:26:43	2021-06-21 22:26:43	\N	2529bf86-1708-4969-b27e-0df6979598b4
5	\N	2021-06-21 22:43:52	2021-06-21 22:43:52	2021-06-22 21:50:12	391fac75-0d10-40d5-8677-eb57b1c2632d
6	\N	2021-06-21 22:47:44	2021-06-21 22:47:44	2021-06-22 21:50:12	2577f702-a3a0-451e-adb7-e2889c1bbb11
8	\N	2021-07-16 17:47:52	2021-07-16 17:47:52	\N	84555b8e-d323-4457-8ba6-645d9ec367fc
7	\N	2021-06-21 22:52:01	2021-07-20 00:12:12	2021-08-03 17:04:05	9c20a2ce-242e-46ab-919e-7f35c842c8f6
1	\N	2021-05-19 21:15:41	2021-05-19 21:15:41	2021-08-12 21:49:08	c5f91141-fb7a-4467-8e9d-d1f025206c1b
9	\N	2021-08-03 17:05:04	2021-08-03 17:05:04	2021-08-12 21:49:08	b559a732-7379-480d-8e97-658fec4a0b3d
10	1	2021-08-12 21:49:09	2021-08-12 21:49:09	\N	8df90f53-f24a-42e0-81aa-44869bab2bd1
11	1	2021-08-12 21:49:09	2021-08-12 21:49:09	\N	729d74a0-ce22-4244-baeb-d1f7752c6877
\.


--
-- TOC entry 4652 (class 0 OID 16868)
-- Dependencies: 290
-- Data for Name: systemmessages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.systemmessages (id, language, key, subject, body, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4654 (class 0 OID 16877)
-- Dependencies: 292
-- Data for Name: taggroups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.taggroups (id, name, handle, "fieldLayoutId", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
\.


--
-- TOC entry 4656 (class 0 OID 16887)
-- Dependencies: 294
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tags (id, "groupId", "deletedWithGroup", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4657 (class 0 OID 16891)
-- Dependencies: 295
-- Data for Name: templatecacheelements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.templatecacheelements (id, "cacheId", "elementId") FROM stdin;
\.


--
-- TOC entry 4659 (class 0 OID 16896)
-- Dependencies: 297
-- Data for Name: templatecachequeries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.templatecachequeries (id, "cacheId", type, query) FROM stdin;
\.


--
-- TOC entry 4661 (class 0 OID 16904)
-- Dependencies: 299
-- Data for Name: templatecaches; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.templatecaches (id, "siteId", "cacheKey", path, "expiryDate", body) FROM stdin;
\.


--
-- TOC entry 4663 (class 0 OID 16912)
-- Dependencies: 301
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tokens (id, token, route, "usageLimit", "usageCount", "expiryDate", "dateCreated", "dateUpdated", uid) FROM stdin;
1	-M3VNwawAGxkLQvCrdU0PMkIViE1hfO-	["users/impersonate-with-token",{"userId":"112","prevUserId":1}]	1	0	2021-07-26 17:47:31	2021-07-26 16:47:32	2021-07-26 16:47:32	e36bb156-8d51-4624-a7b0-288bac7870a2
\.


--
-- TOC entry 4665 (class 0 OID 16921)
-- Dependencies: 303
-- Data for Name: usergroups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usergroups (id, name, handle, description, "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4667 (class 0 OID 16930)
-- Dependencies: 305
-- Data for Name: usergroups_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.usergroups_users (id, "groupId", "userId", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4669 (class 0 OID 16936)
-- Dependencies: 307
-- Data for Name: userpermissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.userpermissions (id, name, "dateCreated", "dateUpdated", uid) FROM stdin;
1	accesssitewhensystemisoff	2021-06-28 17:38:43	2021-06-28 17:38:43	c476a6a0-984c-402d-bf62-7bb52e2a987c
2	accesscpwhensystemisoff	2021-06-28 17:38:43	2021-06-28 17:38:43	5ea260d6-469e-41c2-88e4-714c595b880e
3	performupdates	2021-06-28 17:38:43	2021-06-28 17:38:43	1049dc73-fec7-4e77-ac8c-c63bbc916d11
4	accesscp	2021-06-28 17:38:43	2021-06-28 17:38:43	1006b9eb-9251-419b-b2d2-7c2e4297ae49
5	customizesources	2021-06-28 17:38:43	2021-06-28 17:38:43	78af3b18-8101-4b60-bbd9-cd89514e6bcc
6	registerusers	2021-06-28 17:38:43	2021-06-28 17:38:43	640db858-ac6b-47dc-8584-0a21305fac02
7	moderateusers	2021-06-28 17:38:43	2021-06-28 17:38:43	c5358399-eaf3-4f06-99b5-5242a6900b95
8	assignuserpermissions	2021-06-28 17:38:43	2021-06-28 17:38:43	aab21723-94bd-41cd-be82-2e4173e3c3a0
9	assignusergroups	2021-06-28 17:38:43	2021-06-28 17:38:43	bdf7db96-4495-41da-8f46-f145d7d39bcd
10	administrateusers	2021-06-28 17:38:43	2021-06-28 17:38:43	464d7510-beb7-4895-b6e1-839a1ab27757
11	impersonateusers	2021-06-28 17:38:43	2021-06-28 17:38:43	db7ef910-fc24-465e-9bf0-efaf45f4bf3e
12	editusers	2021-06-28 17:38:43	2021-06-28 17:38:43	a67a5f23-be72-4a9c-9fb7-b80ee8e5488d
13	deleteusers	2021-06-28 17:38:43	2021-06-28 17:38:43	f644bcee-91ee-4d90-8a3b-8c815272c03e
14	editsite:763c0189-f6eb-419c-9ca2-2574a743768a	2021-06-28 17:38:43	2021-06-28 17:38:43	7971c94a-0744-4f09-a3a3-8707a4d90ea0
15	editsite:a6b28fea-2f0c-49a2-b82c-fd16c51d9511	2021-06-28 17:38:43	2021-06-28 17:38:43	7f1f9f46-7bd5-4040-8d70-db8d8c1f04ad
16	createentries:32b433c2-8fa2-439b-9678-d48e4f929b88	2021-06-28 17:38:43	2021-06-28 17:38:43	911afea9-c17e-4b48-bfbf-34f70eaf97aa
17	publishentries:32b433c2-8fa2-439b-9678-d48e4f929b88	2021-06-28 17:38:43	2021-06-28 17:38:43	73a71de1-57d4-47b1-9bd9-b20faeeb6b96
18	deleteentries:32b433c2-8fa2-439b-9678-d48e4f929b88	2021-06-28 17:38:43	2021-06-28 17:38:43	50d78e52-8440-4902-a451-61648fad54e8
19	publishpeerentries:32b433c2-8fa2-439b-9678-d48e4f929b88	2021-06-28 17:38:43	2021-06-28 17:38:43	a6112eae-e9dc-4232-b9fc-e18b96510497
20	deletepeerentries:32b433c2-8fa2-439b-9678-d48e4f929b88	2021-06-28 17:38:43	2021-06-28 17:38:43	7fe1cd89-4135-4fdf-bf4b-2f264f5300cf
21	editpeerentries:32b433c2-8fa2-439b-9678-d48e4f929b88	2021-06-28 17:38:43	2021-06-28 17:38:43	7782cf33-c823-4da5-bf19-6bcf210fd2c1
22	publishpeerentrydrafts:32b433c2-8fa2-439b-9678-d48e4f929b88	2021-06-28 17:38:43	2021-06-28 17:38:43	1ebba181-8015-42ec-80c9-4209b894a0eb
23	deletepeerentrydrafts:32b433c2-8fa2-439b-9678-d48e4f929b88	2021-06-28 17:38:43	2021-06-28 17:38:43	7c8445c0-476f-4203-a331-28fefd509ca9
24	editpeerentrydrafts:32b433c2-8fa2-439b-9678-d48e4f929b88	2021-06-28 17:38:43	2021-06-28 17:38:43	de7e1191-1777-4d01-8ff3-0a3d285da6b7
25	editentries:32b433c2-8fa2-439b-9678-d48e4f929b88	2021-06-28 17:38:43	2021-06-28 17:38:43	88257dd3-aead-4679-924a-4e10613128ed
26	createentries:4a76eb6e-e209-42df-8ef6-43f1e5f7f745	2021-06-28 17:38:43	2021-06-28 17:38:43	34f9179d-834e-4e32-84c2-a4c63f3c7a11
27	publishentries:4a76eb6e-e209-42df-8ef6-43f1e5f7f745	2021-06-28 17:38:43	2021-06-28 17:38:43	157662d6-d0ea-4d29-8b1c-fe27d47ce022
28	deleteentries:4a76eb6e-e209-42df-8ef6-43f1e5f7f745	2021-06-28 17:38:43	2021-06-28 17:38:43	8960d7af-18d7-4a68-ab21-c7780fb7ff0e
29	publishpeerentries:4a76eb6e-e209-42df-8ef6-43f1e5f7f745	2021-06-28 17:38:43	2021-06-28 17:38:43	80d21271-2a84-40b6-9dbd-f8d28f1d9966
30	deletepeerentries:4a76eb6e-e209-42df-8ef6-43f1e5f7f745	2021-06-28 17:38:43	2021-06-28 17:38:43	5fd33928-196b-4d5e-af69-46ba5ee511da
31	editpeerentries:4a76eb6e-e209-42df-8ef6-43f1e5f7f745	2021-06-28 17:38:43	2021-06-28 17:38:43	e473b86e-80fd-411f-b41f-16bbf64db884
32	publishpeerentrydrafts:4a76eb6e-e209-42df-8ef6-43f1e5f7f745	2021-06-28 17:38:43	2021-06-28 17:38:43	0b44611a-c8f9-4470-980b-b9112cad5a9f
33	deletepeerentrydrafts:4a76eb6e-e209-42df-8ef6-43f1e5f7f745	2021-06-28 17:38:43	2021-06-28 17:38:43	f30efe57-a645-4553-be1e-a736c2ff1278
34	editpeerentrydrafts:4a76eb6e-e209-42df-8ef6-43f1e5f7f745	2021-06-28 17:38:43	2021-06-28 17:38:43	39727dc0-334b-4484-97e6-a8398ca0e392
35	editentries:4a76eb6e-e209-42df-8ef6-43f1e5f7f745	2021-06-28 17:38:43	2021-06-28 17:38:43	c2d366b7-8f97-4e7d-bced-747e8fd6638e
36	createentries:02e3155f-23cf-4f36-a734-a3f447d04e85	2021-06-28 17:38:43	2021-06-28 17:38:43	bcbd24d9-5854-48b6-945a-a6677fcfbafa
37	publishentries:02e3155f-23cf-4f36-a734-a3f447d04e85	2021-06-28 17:38:43	2021-06-28 17:38:43	82d8801b-2407-43a3-92e7-62e7b0d11c8c
38	deleteentries:02e3155f-23cf-4f36-a734-a3f447d04e85	2021-06-28 17:38:43	2021-06-28 17:38:43	1c23847b-0859-4035-bd43-a6aa54850037
39	publishpeerentries:02e3155f-23cf-4f36-a734-a3f447d04e85	2021-06-28 17:38:43	2021-06-28 17:38:43	201b299f-a539-49cd-b201-2f737adcf5a1
40	deletepeerentries:02e3155f-23cf-4f36-a734-a3f447d04e85	2021-06-28 17:38:43	2021-06-28 17:38:43	1362fbca-2694-45e8-99e3-7a253b6fa0b9
41	editpeerentries:02e3155f-23cf-4f36-a734-a3f447d04e85	2021-06-28 17:38:43	2021-06-28 17:38:43	08149ee5-d684-4033-bb8d-87c86948aaec
42	publishpeerentrydrafts:02e3155f-23cf-4f36-a734-a3f447d04e85	2021-06-28 17:38:43	2021-06-28 17:38:43	0f0dee20-aabe-4300-9a04-46eac4ce43ba
43	deletepeerentrydrafts:02e3155f-23cf-4f36-a734-a3f447d04e85	2021-06-28 17:38:43	2021-06-28 17:38:43	4b22048a-4fad-4c12-8ccf-8c4016f2df96
44	editpeerentrydrafts:02e3155f-23cf-4f36-a734-a3f447d04e85	2021-06-28 17:38:43	2021-06-28 17:38:43	8d94e6e3-7019-48af-b3d7-9f51a4ba6c0d
45	editentries:02e3155f-23cf-4f36-a734-a3f447d04e85	2021-06-28 17:38:43	2021-06-28 17:38:43	16b6d8ce-587c-472b-82e4-09a2054ece69
46	createentries:b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	2021-06-28 17:38:43	2021-06-28 17:38:43	a259538b-7873-4d3c-8360-f34f382967b2
47	publishentries:b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	2021-06-28 17:38:43	2021-06-28 17:38:43	47f1cebd-4847-4268-98aa-f272c26023c8
48	deleteentries:b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	2021-06-28 17:38:43	2021-06-28 17:38:43	f4dd188c-bb9e-459f-b0ae-5b7c0ccf0793
49	publishpeerentries:b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	2021-06-28 17:38:43	2021-06-28 17:38:43	8d93c808-bdbf-4f00-9ff8-63c18b2b8b61
50	deletepeerentries:b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	2021-06-28 17:38:43	2021-06-28 17:38:43	30650413-b81a-4875-95b1-1fc5754c1b04
51	editpeerentries:b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	2021-06-28 17:38:43	2021-06-28 17:38:43	8711d4b6-b6c5-4bfa-bd77-c412c94f813b
52	publishpeerentrydrafts:b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	2021-06-28 17:38:43	2021-06-28 17:38:43	2cb2b989-4c70-4b25-9af1-926537e6b317
53	deletepeerentrydrafts:b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	2021-06-28 17:38:43	2021-06-28 17:38:43	742a705c-24ae-469c-93ef-94c3d23a2dbd
54	editpeerentrydrafts:b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	2021-06-28 17:38:43	2021-06-28 17:38:43	1e5cd73f-fa64-4057-91f7-0cb68bde9a9f
55	editentries:b22ca822-e7e2-4f8c-8be5-d3b0fcab1c9f	2021-06-28 17:38:43	2021-06-28 17:38:43	ad0a1538-b6b3-4730-b7b0-1c90f6e030c1
56	editglobalset:ea689411-d03e-48f0-8841-3318c457eee1	2021-06-28 17:38:43	2021-06-28 17:38:43	8d57d9b9-9538-4cfc-9efb-a5d40f3795ff
57	editcategories:43c5d827-8706-4863-a676-17bf911ce931	2021-06-28 17:38:43	2021-06-28 17:38:43	fb4b472a-b0cf-4e28-ba0d-25475bbce792
58	saveassetinvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	5f79ba4a-5b78-4691-8be7-78e83181f310
59	createfoldersinvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	cd23b92d-68ab-42d2-8523-ddeabae354a2
60	deletefilesandfoldersinvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	3830a4cc-14cb-4f39-ac2f-1a0665911957
61	replacefilesinvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	56d915c6-14a3-4be5-a07e-cea6190790f2
62	editimagesinvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	2cf755b4-bb9b-4d1d-b471-f78b40c697eb
63	editpeerfilesinvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	1cd2d857-72f1-494b-92bf-de2df733e8b5
64	replacepeerfilesinvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	070b0701-6a53-41ec-a75c-70dab2421dc5
65	deletepeerfilesinvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	8784b6ff-cee8-4fa3-9263-8aca5da266cf
66	editpeerimagesinvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	2a6e5d7a-044b-4d97-a4cc-08bca8797379
67	viewpeerfilesinvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	41049c89-aa2e-485d-8502-7154d331c4af
68	viewvolume:85d34514-ec13-4850-a272-a3ab1bc790ef	2021-06-28 17:38:43	2021-06-28 17:38:43	4c38797e-0ff2-4f1e-a8df-d7b680cff09f
69	saveassetinvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	14d62d6f-7dbc-439f-b948-67746ada5e3f
70	createfoldersinvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	4d265cf2-48be-4c7f-ad3b-9246ffca5e87
71	deletefilesandfoldersinvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	33db5e75-1090-41b9-9f0a-6795168599e1
72	replacefilesinvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	af47892e-1aa6-4db3-9373-e4ea8f16296c
73	editimagesinvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	32029809-716c-422f-955d-708efb8a6dea
74	editpeerfilesinvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	152aa305-fd6c-4f3e-b9b9-d18b944bdca7
75	replacepeerfilesinvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	7331a748-11c0-4f74-807b-42a85f945366
76	deletepeerfilesinvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	81dd830c-3fd2-4043-87d9-5b66553a91bf
77	editpeerimagesinvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	35b455b5-eac8-4673-8e73-085f14897c14
78	viewpeerfilesinvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	765ee7de-5473-42f4-b728-b2c935e63266
79	viewvolume:77fd2a32-cdf7-4a77-8648-d79616eed462	2021-06-28 17:38:43	2021-06-28 17:38:43	f41727f3-5e01-4287-a051-111173372516
80	utility:updates	2021-06-28 17:38:43	2021-06-28 17:38:43	f5d1abe6-b7a0-47ba-805b-f4ac9d9e13ac
81	utility:system-report	2021-06-28 17:38:43	2021-06-28 17:38:43	225df1d7-796d-4ea8-8a5e-bfb856845d8b
82	utility:php-info	2021-06-28 17:38:43	2021-06-28 17:38:43	62f30cd8-2e31-4b38-aa89-7a895db754e8
83	utility:system-messages	2021-06-28 17:38:43	2021-06-28 17:38:43	4da7fcd0-d92b-47c7-846b-5208c67c0da1
84	utility:asset-indexes	2021-06-28 17:38:43	2021-06-28 17:38:43	2ee523df-b6d7-4e0d-b458-78aca7fd7819
85	utility:queue-manager	2021-06-28 17:38:43	2021-06-28 17:38:43	b828c642-c3f3-495e-83d0-97be00988084
86	utility:clear-caches	2021-06-28 17:38:43	2021-06-28 17:38:43	35450da2-218e-4cae-91f1-e3d15259eea6
87	utility:deprecation-errors	2021-06-28 17:38:43	2021-06-28 17:38:43	eccd3f48-df06-40cf-819c-0083a857bee5
88	utility:db-backup	2021-06-28 17:38:43	2021-06-28 17:38:43	b4348f8d-895c-4196-bb7c-9d61577b05ba
89	utility:find-replace	2021-06-28 17:38:43	2021-06-28 17:38:43	27bdbad0-6b02-48d4-a491-25815937ae86
90	utility:migrations	2021-06-28 17:38:43	2021-06-28 17:38:43	af56d571-25ec-4869-93af-f1a4207b0e90
\.


--
-- TOC entry 4671 (class 0 OID 16942)
-- Dependencies: 309
-- Data for Name: userpermissions_usergroups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.userpermissions_usergroups (id, "permissionId", "groupId", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4673 (class 0 OID 16948)
-- Dependencies: 311
-- Data for Name: userpermissions_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.userpermissions_users (id, "permissionId", "userId", "dateCreated", "dateUpdated", uid) FROM stdin;
\.


--
-- TOC entry 4675 (class 0 OID 16954)
-- Dependencies: 313
-- Data for Name: userpreferences; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.userpreferences ("userId", preferences) FROM stdin;
1	{"language":"en-US"}
78	{"language":null,"locale":null,"weekStartDay":null,"useShapes":false,"underlineLinks":false}
79	{"language":null,"locale":null,"weekStartDay":null,"useShapes":false,"underlineLinks":false}
80	{"language":null,"locale":null,"weekStartDay":null,"useShapes":false,"underlineLinks":false,"showFieldHandles":false,"enableDebugToolbarForSite":false,"enableDebugToolbarForCp":false,"showExceptionView":false,"profileTemplates":false}
112	{"language":null,"locale":null,"weekStartDay":null,"useShapes":false,"underlineLinks":false,"showFieldHandles":false,"enableDebugToolbarForSite":false,"enableDebugToolbarForCp":false,"showExceptionView":false,"profileTemplates":false}
113	{"language":null,"locale":null,"weekStartDay":null,"useShapes":false,"underlineLinks":false}
\.


--
-- TOC entry 4677 (class 0 OID 16962)
-- Dependencies: 315
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, "photoId", "firstName", "lastName", email, password, admin, locked, suspended, pending, "lastLoginDate", "lastLoginAttemptIp", "invalidLoginWindowStart", "invalidLoginCount", "lastInvalidLoginDate", "lockoutDate", "hasDashboard", "verificationCode", "verificationCodeIssuedDate", "unverifiedEmail", "passwordResetRequired", "lastPasswordChangeDate", "dateCreated", "dateUpdated", uid) FROM stdin;
78	erosas	\N	Eric	Rosas	ericdrosas@gmail.com	\N	f	f	f	t	\N	\N	\N	\N	\N	\N	f	$2y$13$PpdVH7TZFCjI7q5lOTzjxuD/P6jtCIWbR9owhiTL4UZVfMSn484/6	2021-06-28 17:39:28	ericdrosas@gmail.com	f	\N	2021-06-28 17:39:27	2021-06-28 17:39:28	dc60b03c-4ed9-4777-bcb0-6d92d0af8bc4
79	testtest	\N	Testy	McTesterson	test@test.com	\N	f	f	f	t	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	2021-06-28 17:41:30	2021-06-28 17:41:30	e9b80e96-7635-49a6-8c17-d2fae403a4c3
80	alsoadmin	\N	also	admin	also@admin.com	\N	t	f	f	t	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	2021-06-28 17:42:18	2021-06-28 17:42:18	d1cd31fd-451c-4347-adb8-97e7603fcb19
1	admin	\N	\N	\N	erosas@lsst.org	$2y$13$kWYreAF/KSf6akVAJsZhnuRBQ1Iu2/yOGwQC/Qw/tSmfYRa9PM.5a	t	f	f	f	2021-10-27 22:08:11	\N	\N	\N	2021-10-26 17:01:52	\N	t	$2y$13$PBkSBOcNfYw.lBlkOOYU9eQ.Szrpj6FffOQBzHdeylwIQe5bg1VLa	2021-07-23 22:27:56	\N	f	2021-05-19 21:09:34	2021-05-19 21:09:34	2021-10-27 22:08:13	2300d535-6e4f-4040-a28b-e024deda748c
113	cloud	\N	madeThis	inTheCloud	1@1.1	\N	f	f	f	t	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	f	\N	2021-07-26 17:36:47	2021-07-26 17:36:47	3afec3ad-8ee5-4545-9a2f-d6c297e96083
112	duder	\N	The	Dude	123@321.123	$2y$13$E6rBcpIahjAtJw5dA3yL4.KeWuEOSQrL9A8euqqYzPvL0HCrFIaVe	t	f	f	f	2021-07-26 21:49:57	\N	\N	\N	\N	\N	t	\N	\N	\N	f	2021-07-26 16:51:45	2021-07-26 16:36:02	2021-07-26 21:49:57	3c84c678-5eb1-4f79-a247-01ea465f9362
\.


--
-- TOC entry 4678 (class 0 OID 16975)
-- Dependencies: 316
-- Data for Name: volumefolders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.volumefolders (id, "parentId", "volumeId", name, path, "dateCreated", "dateUpdated", uid) FROM stdin;
1	\N	1	Icons		2021-06-15 17:03:52	2021-06-15 17:03:52	edaba540-474d-4c0d-95e7-f54762684902
2	\N	\N	Temporary source	\N	2021-06-15 17:04:49	2021-06-15 17:04:49	7d103f83-1ece-436c-8073-5e9942b23999
3	2	\N	user_1	user_1/	2021-06-15 17:04:49	2021-06-15 17:04:49	7739451f-7a01-427e-aeee-6898258c8432
7	\N	2	Astro Tour Images		2021-06-21 22:32:34	2021-06-21 22:32:34	3ebd6432-4037-4677-a4fc-a5f61437aed3
8	7	2	web	web/	2021-06-21 22:42:32	2021-06-21 22:42:32	d79d5dbe-3974-41a8-b4e8-d83d990d0e10
9	8	2	assets	web/assets/	2021-06-21 22:42:32	2021-06-21 22:42:32	cd63f004-0f2a-430f-ae23-2bafbdc80aff
10	9	2	astro-tours	web/assets/astro-tours/	2021-06-21 22:42:32	2021-06-21 22:42:32	1e561bd5-a51e-4351-8525-4629f5a9dbc3
11	\N	3	Tour Images		2021-08-03 17:05:02	2021-08-03 17:05:02	d723b7d1-a9c4-44e6-875f-3bb0cf6a357b
12	\N	4	Test Google Cloud Storage		2021-08-03 21:16:43	2021-08-03 21:16:43	a87a2d2a-52ef-4f1a-b404-879610a56c06
16	\N	5	Astro Images		2021-08-19 20:34:03	2021-08-19 20:34:03	9783e373-46db-4d84-87df-c91d668df64e
\.


--
-- TOC entry 4680 (class 0 OID 16984)
-- Dependencies: 318
-- Data for Name: volumes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.volumes (id, "fieldLayoutId", name, handle, type, "hasUrls", url, "titleTranslationMethod", "titleTranslationKeyFormat", settings, "sortOrder", "dateCreated", "dateUpdated", "dateDeleted", uid) FROM stdin;
2	9	Astro Tour Images	astroTourImages	craft\\volumes\\Local	t	/astro-tour-assets	site	\N	{"path":"@webroot/assets/astro-tours"}	1	2021-06-21 22:32:34	2021-06-21 22:32:34	2021-08-03 17:04:00	77fd2a32-cdf7-4a77-8648-d79616eed462
3	17	Tour Images	tourImages	craft\\googlecloud\\Volume	t	$GCS_ASSET_BUCKET	site	\N	{"bucket":"craft-test-erosas","bucketSelectionMode":"choose","expires":"5 minutes","keyFileContents":"","projectId":"$GCP_PROJECT_ID","subfolder":"tours"}	0	2021-08-03 17:05:01	2021-10-08 22:29:25	\N	a469a047-d19a-421e-97f8-c58f1bda27d7
1	4	Icons	icons	craft\\googlecloud\\Volume	t	$GCS_ASSET_BUCKET	site	\N	{"bucket":"craft-test-erosas","bucketSelectionMode":"choose","expires":"5 minutes","keyFileContents":"","projectId":"$GCP_PROJECT_ID","subfolder":"icons"}	0	2021-06-15 17:03:52	2021-10-08 22:57:45	\N	85d34514-ec13-4850-a272-a3ab1bc790ef
4	19	Test Google Cloud Storage	testGoogleCloudStorage	craft\\googlecloud\\Volume	t	@web/asset	site	\N	{"bucket":"craft-test-erosas","bucketSelectionMode":"manual","expires":"","keyFileContents":"","projectId":"skyviewer","subfolder":""}	0	2021-08-03 21:16:42	2021-08-19 20:34:03	2021-08-30 21:29:11	42fe85e3-1e91-4f99-9751-ed6ed734f7aa
5	22	Astro Images	astroImages	craft\\googlecloud\\Volume	t	$GCS_ASSET_BUCKET	site	\N	{"bucket":"craft-test-erosas","bucketSelectionMode":"manual","expires":"5 minutes","keyFileContents":"","projectId":"$GCP_PROJECT_ID","subfolder":"astro"}	0	2021-08-19 20:34:03	2021-10-11 14:41:22	\N	860a3a7b-7ed5-4997-9a40-0d00e58b77d0
\.


--
-- TOC entry 4682 (class 0 OID 16996)
-- Dependencies: 320
-- Data for Name: widgets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.widgets (id, "userId", type, "sortOrder", colspan, settings, enabled, "dateCreated", "dateUpdated", uid) FROM stdin;
1	1	craft\\widgets\\RecentEntries	1	\N	{"siteId":1,"section":"*","limit":10}	t	2021-05-19 21:09:36	2021-05-19 21:09:36	6d01e2cd-b482-4cf8-86d4-8bf7d9f4225c
2	1	craft\\widgets\\CraftSupport	2	\N	[]	t	2021-05-19 21:09:36	2021-05-19 21:09:36	0be85e31-00f6-454f-a31b-0c41bc31652f
3	1	craft\\widgets\\Updates	3	\N	[]	t	2021-05-19 21:09:36	2021-05-19 21:09:36	4ec54126-dcc9-4641-8d2e-ecf71ea44ec4
4	1	craft\\widgets\\Feed	4	\N	{"url":"https://craftcms.com/news.rss","title":"Craft News","limit":5}	t	2021-05-19 21:09:36	2021-05-19 21:09:36	b722b0db-0dad-46d2-ad72-a22aabb4bd18
5	112	craft\\widgets\\RecentEntries	1	\N	{"siteId":1,"section":"*","limit":10}	t	2021-07-26 16:52:14	2021-07-26 16:52:14	44fb47af-cacf-40e1-9c9f-10858b64124a
6	112	craft\\widgets\\CraftSupport	2	\N	[]	t	2021-07-26 16:52:15	2021-07-26 16:52:15	65b0286c-b3e6-41c4-b820-ccfe42be1774
7	112	craft\\widgets\\Updates	3	\N	[]	t	2021-07-26 16:52:15	2021-07-26 16:52:15	c69a44ee-ce55-4736-8134-b5367f6d4ec0
8	112	craft\\widgets\\Feed	4	\N	{"url":"https://craftcms.com/news.rss","title":"Craft News","limit":5}	t	2021-07-26 16:52:16	2021-07-26 16:52:16	f6d13c02-f8e2-4554-a650-62ef7adbde8e
\.


--
-- TOC entry 4748 (class 0 OID 0)
-- Dependencies: 322
-- Name: announcements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.announcements_id_seq', 4, true);


--
-- TOC entry 4749 (class 0 OID 0)
-- Dependencies: 201
-- Name: assetindexdata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.assetindexdata_id_seq', 1, false);


--
-- TOC entry 4750 (class 0 OID 0)
-- Dependencies: 204
-- Name: assettransformindex_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.assettransformindex_id_seq', 123, true);


--
-- TOC entry 4751 (class 0 OID 0)
-- Dependencies: 206
-- Name: assettransforms_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.assettransforms_id_seq', 1, false);


--
-- TOC entry 4752 (class 0 OID 0)
-- Dependencies: 209
-- Name: categorygroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categorygroups_id_seq', 3, true);


--
-- TOC entry 4753 (class 0 OID 0)
-- Dependencies: 211
-- Name: categorygroups_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categorygroups_sites_id_seq', 6, true);


--
-- TOC entry 4754 (class 0 OID 0)
-- Dependencies: 215
-- Name: content_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.content_id_seq', 575, true);


--
-- TOC entry 4755 (class 0 OID 0)
-- Dependencies: 217
-- Name: craftidtokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.craftidtokens_id_seq', 1, false);


--
-- TOC entry 4756 (class 0 OID 0)
-- Dependencies: 219
-- Name: deprecationerrors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.deprecationerrors_id_seq', 1, false);


--
-- TOC entry 4757 (class 0 OID 0)
-- Dependencies: 221
-- Name: drafts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.drafts_id_seq', 68, true);


--
-- TOC entry 4758 (class 0 OID 0)
-- Dependencies: 223
-- Name: elementindexsettings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.elementindexsettings_id_seq', 1, false);


--
-- TOC entry 4759 (class 0 OID 0)
-- Dependencies: 225
-- Name: elements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.elements_id_seq', 445, true);


--
-- TOC entry 4760 (class 0 OID 0)
-- Dependencies: 227
-- Name: elements_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.elements_sites_id_seq', 881, true);


--
-- TOC entry 4761 (class 0 OID 0)
-- Dependencies: 230
-- Name: entrytypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.entrytypes_id_seq', 9, true);


--
-- TOC entry 4762 (class 0 OID 0)
-- Dependencies: 232
-- Name: fieldgroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fieldgroups_id_seq', 5, true);


--
-- TOC entry 4763 (class 0 OID 0)
-- Dependencies: 234
-- Name: fieldlayoutfields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fieldlayoutfields_id_seq', 321, true);


--
-- TOC entry 4764 (class 0 OID 0)
-- Dependencies: 236
-- Name: fieldlayouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fieldlayouts_id_seq', 22, true);


--
-- TOC entry 4765 (class 0 OID 0)
-- Dependencies: 238
-- Name: fieldlayouttabs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fieldlayouttabs_id_seq', 147, true);


--
-- TOC entry 4766 (class 0 OID 0)
-- Dependencies: 240
-- Name: fields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fields_id_seq', 56, true);


--
-- TOC entry 4767 (class 0 OID 0)
-- Dependencies: 242
-- Name: globalsets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.globalsets_id_seq', 1, false);


--
-- TOC entry 4768 (class 0 OID 0)
-- Dependencies: 244
-- Name: gqlschemas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gqlschemas_id_seq', 1, true);


--
-- TOC entry 4769 (class 0 OID 0)
-- Dependencies: 246
-- Name: gqltokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.gqltokens_id_seq', 1, true);


--
-- TOC entry 4770 (class 0 OID 0)
-- Dependencies: 248
-- Name: info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.info_id_seq', 1, false);


--
-- TOC entry 4771 (class 0 OID 0)
-- Dependencies: 251
-- Name: matrixblocktypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.matrixblocktypes_id_seq', 4, true);


--
-- TOC entry 4772 (class 0 OID 0)
-- Dependencies: 253
-- Name: matrixcontent_factscontentblocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.matrixcontent_factscontentblocks_id_seq', 92, true);


--
-- TOC entry 4773 (class 0 OID 0)
-- Dependencies: 255
-- Name: matrixcontent_introcontentblocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.matrixcontent_introcontentblocks_id_seq', 118, true);


--
-- TOC entry 4774 (class 0 OID 0)
-- Dependencies: 257
-- Name: matrixcontent_poiastroobject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.matrixcontent_poiastroobject_id_seq', 1, false);


--
-- TOC entry 4775 (class 0 OID 0)
-- Dependencies: 259
-- Name: matrixcontent_tourpois_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.matrixcontent_tourpois_id_seq', 96, true);


--
-- TOC entry 4776 (class 0 OID 0)
-- Dependencies: 261
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.migrations_id_seq', 201, true);


--
-- TOC entry 4777 (class 0 OID 0)
-- Dependencies: 263
-- Name: plugins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.plugins_id_seq', 8, true);


--
-- TOC entry 4778 (class 0 OID 0)
-- Dependencies: 266
-- Name: queue_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.queue_id_seq', 2073, true);


--
-- TOC entry 4779 (class 0 OID 0)
-- Dependencies: 268
-- Name: relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.relations_id_seq', 359, true);


--
-- TOC entry 4780 (class 0 OID 0)
-- Dependencies: 271
-- Name: revisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.revisions_id_seq', 120, true);


--
-- TOC entry 4781 (class 0 OID 0)
-- Dependencies: 274
-- Name: sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sections_id_seq', 8, true);


--
-- TOC entry 4782 (class 0 OID 0)
-- Dependencies: 276
-- Name: sections_sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sections_sites_id_seq', 16, true);


--
-- TOC entry 4783 (class 0 OID 0)
-- Dependencies: 279
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sessions_id_seq', 336, true);


--
-- TOC entry 4784 (class 0 OID 0)
-- Dependencies: 281
-- Name: shunnedmessages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.shunnedmessages_id_seq', 1, false);


--
-- TOC entry 4785 (class 0 OID 0)
-- Dependencies: 283
-- Name: sitegroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sitegroups_id_seq', 1, true);


--
-- TOC entry 4786 (class 0 OID 0)
-- Dependencies: 285
-- Name: sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sites_id_seq', 2, true);


--
-- TOC entry 4787 (class 0 OID 0)
-- Dependencies: 287
-- Name: structureelements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.structureelements_id_seq', 225, true);


--
-- TOC entry 4788 (class 0 OID 0)
-- Dependencies: 289
-- Name: structures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.structures_id_seq', 11, true);


--
-- TOC entry 4789 (class 0 OID 0)
-- Dependencies: 291
-- Name: systemmessages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.systemmessages_id_seq', 1, false);


--
-- TOC entry 4790 (class 0 OID 0)
-- Dependencies: 293
-- Name: taggroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.taggroups_id_seq', 1, false);


--
-- TOC entry 4791 (class 0 OID 0)
-- Dependencies: 296
-- Name: templatecacheelements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.templatecacheelements_id_seq', 1, false);


--
-- TOC entry 4792 (class 0 OID 0)
-- Dependencies: 298
-- Name: templatecachequeries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.templatecachequeries_id_seq', 1, false);


--
-- TOC entry 4793 (class 0 OID 0)
-- Dependencies: 300
-- Name: templatecaches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.templatecaches_id_seq', 1, false);


--
-- TOC entry 4794 (class 0 OID 0)
-- Dependencies: 302
-- Name: tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tokens_id_seq', 1, true);


--
-- TOC entry 4795 (class 0 OID 0)
-- Dependencies: 304
-- Name: usergroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usergroups_id_seq', 2, true);


--
-- TOC entry 4796 (class 0 OID 0)
-- Dependencies: 306
-- Name: usergroups_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.usergroups_users_id_seq', 1, true);


--
-- TOC entry 4797 (class 0 OID 0)
-- Dependencies: 308
-- Name: userpermissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.userpermissions_id_seq', 90, true);


--
-- TOC entry 4798 (class 0 OID 0)
-- Dependencies: 310
-- Name: userpermissions_usergroups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.userpermissions_usergroups_id_seq', 180, true);


--
-- TOC entry 4799 (class 0 OID 0)
-- Dependencies: 312
-- Name: userpermissions_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.userpermissions_users_id_seq', 1, false);


--
-- TOC entry 4800 (class 0 OID 0)
-- Dependencies: 314
-- Name: userpreferences_userId_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public."userpreferences_userId_seq"', 1, false);


--
-- TOC entry 4801 (class 0 OID 0)
-- Dependencies: 317
-- Name: volumefolders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.volumefolders_id_seq', 16, true);


--
-- TOC entry 4802 (class 0 OID 0)
-- Dependencies: 319
-- Name: volumes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.volumes_id_seq', 5, true);


--
-- TOC entry 4803 (class 0 OID 0)
-- Dependencies: 321
-- Name: widgets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.widgets_id_seq', 8, true);


--
-- TOC entry 4334 (class 2606 OID 18002)
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- TOC entry 4054 (class 2606 OID 17062)
-- Name: assetindexdata assetindexdata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assetindexdata
    ADD CONSTRAINT assetindexdata_pkey PRIMARY KEY (id);


--
-- TOC entry 4058 (class 2606 OID 17064)
-- Name: assets assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- TOC entry 4063 (class 2606 OID 17066)
-- Name: assettransformindex assettransformindex_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assettransformindex
    ADD CONSTRAINT assettransformindex_pkey PRIMARY KEY (id);


--
-- TOC entry 4066 (class 2606 OID 17068)
-- Name: assettransforms assettransforms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assettransforms
    ADD CONSTRAINT assettransforms_pkey PRIMARY KEY (id);


--
-- TOC entry 4070 (class 2606 OID 17070)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4073 (class 2606 OID 17072)
-- Name: categorygroups categorygroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorygroups
    ADD CONSTRAINT categorygroups_pkey PRIMARY KEY (id);


--
-- TOC entry 4080 (class 2606 OID 17074)
-- Name: categorygroups_sites categorygroups_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorygroups_sites
    ADD CONSTRAINT categorygroups_sites_pkey PRIMARY KEY (id);


--
-- TOC entry 4084 (class 2606 OID 17076)
-- Name: changedattributes changedattributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changedattributes
    ADD CONSTRAINT changedattributes_pkey PRIMARY KEY ("elementId", "siteId", attribute);


--
-- TOC entry 4087 (class 2606 OID 17078)
-- Name: changedfields changedfields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changedfields
    ADD CONSTRAINT changedfields_pkey PRIMARY KEY ("elementId", "siteId", "fieldId");


--
-- TOC entry 4090 (class 2606 OID 17080)
-- Name: content content_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT content_pkey PRIMARY KEY (id);


--
-- TOC entry 4095 (class 2606 OID 17082)
-- Name: craftidtokens craftidtokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.craftidtokens
    ADD CONSTRAINT craftidtokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4097 (class 2606 OID 17084)
-- Name: deprecationerrors deprecationerrors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deprecationerrors
    ADD CONSTRAINT deprecationerrors_pkey PRIMARY KEY (id);


--
-- TOC entry 4100 (class 2606 OID 17086)
-- Name: drafts drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drafts
    ADD CONSTRAINT drafts_pkey PRIMARY KEY (id);


--
-- TOC entry 4104 (class 2606 OID 17088)
-- Name: elementindexsettings elementindexsettings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elementindexsettings
    ADD CONSTRAINT elementindexsettings_pkey PRIMARY KEY (id);


--
-- TOC entry 4107 (class 2606 OID 17090)
-- Name: elements elements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT elements_pkey PRIMARY KEY (id);


--
-- TOC entry 4115 (class 2606 OID 17092)
-- Name: elements_sites elements_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elements_sites
    ADD CONSTRAINT elements_sites_pkey PRIMARY KEY (id);


--
-- TOC entry 4122 (class 2606 OID 17094)
-- Name: entries entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4129 (class 2606 OID 17096)
-- Name: entrytypes entrytypes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entrytypes
    ADD CONSTRAINT entrytypes_pkey PRIMARY KEY (id);


--
-- TOC entry 4136 (class 2606 OID 17098)
-- Name: fieldgroups fieldgroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldgroups
    ADD CONSTRAINT fieldgroups_pkey PRIMARY KEY (id);


--
-- TOC entry 4140 (class 2606 OID 17100)
-- Name: fieldlayoutfields fieldlayoutfields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldlayoutfields
    ADD CONSTRAINT fieldlayoutfields_pkey PRIMARY KEY (id);


--
-- TOC entry 4146 (class 2606 OID 17102)
-- Name: fieldlayouts fieldlayouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldlayouts
    ADD CONSTRAINT fieldlayouts_pkey PRIMARY KEY (id);


--
-- TOC entry 4150 (class 2606 OID 17104)
-- Name: fieldlayouttabs fieldlayouttabs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldlayouttabs
    ADD CONSTRAINT fieldlayouttabs_pkey PRIMARY KEY (id);


--
-- TOC entry 4154 (class 2606 OID 17106)
-- Name: fields fields_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fields
    ADD CONSTRAINT fields_pkey PRIMARY KEY (id);


--
-- TOC entry 4159 (class 2606 OID 17108)
-- Name: globalsets globalsets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.globalsets
    ADD CONSTRAINT globalsets_pkey PRIMARY KEY (id);


--
-- TOC entry 4165 (class 2606 OID 17110)
-- Name: gqlschemas gqlschemas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gqlschemas
    ADD CONSTRAINT gqlschemas_pkey PRIMARY KEY (id);


--
-- TOC entry 4167 (class 2606 OID 17112)
-- Name: gqltokens gqltokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gqltokens
    ADD CONSTRAINT gqltokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4171 (class 2606 OID 17114)
-- Name: info info_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.info
    ADD CONSTRAINT info_pkey PRIMARY KEY (id);


--
-- TOC entry 4177 (class 2606 OID 17116)
-- Name: matrixblocks matrixblocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixblocks
    ADD CONSTRAINT matrixblocks_pkey PRIMARY KEY (id);


--
-- TOC entry 4183 (class 2606 OID 17118)
-- Name: matrixblocktypes matrixblocktypes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixblocktypes
    ADD CONSTRAINT matrixblocktypes_pkey PRIMARY KEY (id);


--
-- TOC entry 4186 (class 2606 OID 17120)
-- Name: matrixcontent_factscontentblocks matrixcontent_factscontentblocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_factscontentblocks
    ADD CONSTRAINT matrixcontent_factscontentblocks_pkey PRIMARY KEY (id);


--
-- TOC entry 4192 (class 2606 OID 17122)
-- Name: matrixcontent_poiastroobject matrixcontent_poiastroobject_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_poiastroobject
    ADD CONSTRAINT matrixcontent_poiastroobject_pkey PRIMARY KEY (id);


--
-- TOC entry 4189 (class 2606 OID 17124)
-- Name: matrixcontent_introcontentblocks matrixcontent_tourcontent_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_introcontentblocks
    ADD CONSTRAINT matrixcontent_tourcontent_pkey PRIMARY KEY (id);


--
-- TOC entry 4195 (class 2606 OID 17126)
-- Name: matrixcontent_tourpois matrixcontent_tourpois_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_tourpois
    ADD CONSTRAINT matrixcontent_tourpois_pkey PRIMARY KEY (id);


--
-- TOC entry 4198 (class 2606 OID 17128)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4222 (class 2606 OID 17130)
-- Name: searchindex pk_lxfgkaypfkbmlezqetvjapqydsjlbjwtrksy; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.searchindex
    ADD CONSTRAINT pk_lxfgkaypfkbmlezqetvjapqydsjlbjwtrksy PRIMARY KEY ("elementId", attribute, "fieldId", "siteId");


--
-- TOC entry 4201 (class 2606 OID 17132)
-- Name: plugins plugins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plugins
    ADD CONSTRAINT plugins_pkey PRIMARY KEY (id);


--
-- TOC entry 4203 (class 2606 OID 17134)
-- Name: projectconfig projectconfig_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projectconfig
    ADD CONSTRAINT projectconfig_pkey PRIMARY KEY (path);


--
-- TOC entry 4207 (class 2606 OID 17138)
-- Name: queue queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.queue
    ADD CONSTRAINT queue_pkey PRIMARY KEY (id);


--
-- TOC entry 4213 (class 2606 OID 17140)
-- Name: relations relations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT relations_pkey PRIMARY KEY (id);


--
-- TOC entry 4215 (class 2606 OID 17142)
-- Name: resourcepaths resourcepaths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.resourcepaths
    ADD CONSTRAINT resourcepaths_pkey PRIMARY KEY (hash);


--
-- TOC entry 4218 (class 2606 OID 17144)
-- Name: revisions revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revisions
    ADD CONSTRAINT revisions_pkey PRIMARY KEY (id);


--
-- TOC entry 4228 (class 2606 OID 17146)
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- TOC entry 4232 (class 2606 OID 17148)
-- Name: sections_sites sections_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections_sites
    ADD CONSTRAINT sections_sites_pkey PRIMARY KEY (id);


--
-- TOC entry 4234 (class 2606 OID 17150)
-- Name: sequences sequences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sequences
    ADD CONSTRAINT sequences_pkey PRIMARY KEY (name);


--
-- TOC entry 4240 (class 2606 OID 17152)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4243 (class 2606 OID 17154)
-- Name: shunnedmessages shunnedmessages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shunnedmessages
    ADD CONSTRAINT shunnedmessages_pkey PRIMARY KEY (id);


--
-- TOC entry 4246 (class 2606 OID 17156)
-- Name: sitegroups sitegroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sitegroups
    ADD CONSTRAINT sitegroups_pkey PRIMARY KEY (id);


--
-- TOC entry 4251 (class 2606 OID 17158)
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- TOC entry 4259 (class 2606 OID 17160)
-- Name: structureelements structureelements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structureelements
    ADD CONSTRAINT structureelements_pkey PRIMARY KEY (id);


--
-- TOC entry 4262 (class 2606 OID 17162)
-- Name: structures structures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT structures_pkey PRIMARY KEY (id);


--
-- TOC entry 4266 (class 2606 OID 17164)
-- Name: systemmessages systemmessages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.systemmessages
    ADD CONSTRAINT systemmessages_pkey PRIMARY KEY (id);


--
-- TOC entry 4271 (class 2606 OID 17166)
-- Name: taggroups taggroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggroups
    ADD CONSTRAINT taggroups_pkey PRIMARY KEY (id);


--
-- TOC entry 4274 (class 2606 OID 17168)
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- TOC entry 4278 (class 2606 OID 17170)
-- Name: templatecacheelements templatecacheelements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templatecacheelements
    ADD CONSTRAINT templatecacheelements_pkey PRIMARY KEY (id);


--
-- TOC entry 4282 (class 2606 OID 17172)
-- Name: templatecachequeries templatecachequeries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templatecachequeries
    ADD CONSTRAINT templatecachequeries_pkey PRIMARY KEY (id);


--
-- TOC entry 4287 (class 2606 OID 17174)
-- Name: templatecaches templatecaches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templatecaches
    ADD CONSTRAINT templatecaches_pkey PRIMARY KEY (id);


--
-- TOC entry 4291 (class 2606 OID 17176)
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4295 (class 2606 OID 17178)
-- Name: usergroups usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usergroups
    ADD CONSTRAINT usergroups_pkey PRIMARY KEY (id);


--
-- TOC entry 4299 (class 2606 OID 17180)
-- Name: usergroups_users usergroups_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usergroups_users
    ADD CONSTRAINT usergroups_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4302 (class 2606 OID 17182)
-- Name: userpermissions userpermissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpermissions
    ADD CONSTRAINT userpermissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4306 (class 2606 OID 17184)
-- Name: userpermissions_usergroups userpermissions_usergroups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpermissions_usergroups
    ADD CONSTRAINT userpermissions_usergroups_pkey PRIMARY KEY (id);


--
-- TOC entry 4310 (class 2606 OID 17186)
-- Name: userpermissions_users userpermissions_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpermissions_users
    ADD CONSTRAINT userpermissions_users_pkey PRIMARY KEY (id);


--
-- TOC entry 4312 (class 2606 OID 17188)
-- Name: userpreferences userpreferences_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpreferences
    ADD CONSTRAINT userpreferences_pkey PRIMARY KEY ("userId");


--
-- TOC entry 4318 (class 2606 OID 17190)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4323 (class 2606 OID 17192)
-- Name: volumefolders volumefolders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volumefolders
    ADD CONSTRAINT volumefolders_pkey PRIMARY KEY (id);


--
-- TOC entry 4329 (class 2606 OID 17194)
-- Name: volumes volumes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volumes
    ADD CONSTRAINT volumes_pkey PRIMARY KEY (id);


--
-- TOC entry 4332 (class 2606 OID 17196)
-- Name: widgets widgets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT widgets_pkey PRIMARY KEY (id);


--
-- TOC entry 4155 (class 1259 OID 17197)
-- Name: idx_aibvszhglagfecfikfbsmqtnvuapcwrqvcab; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_aibvszhglagfecfikfbsmqtnvuapcwrqvcab ON public.fields USING btree (context);


--
-- TOC entry 4292 (class 1259 OID 17198)
-- Name: idx_akczfxbpvrqogoubxmhpsshuiumiomrtbrdf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_akczfxbpvrqogoubxmhpsshuiumiomrtbrdf ON public.usergroups USING btree (name);


--
-- TOC entry 4081 (class 1259 OID 17199)
-- Name: idx_algqvqvwjlroryfjykwybcgqiwhqgntlipes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_algqvqvwjlroryfjykwybcgqiwhqgntlipes ON public.categorygroups_sites USING btree ("siteId");


--
-- TOC entry 4196 (class 1259 OID 17201)
-- Name: idx_awhozleetinzjdkbcjzxoljutdayfqbsotlp; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_awhozleetinzjdkbcjzxoljutdayfqbsotlp ON public.migrations USING btree (track, name);


--
-- TOC entry 4108 (class 1259 OID 17202)
-- Name: idx_axfpcqicozeksdqwxanvhaigfnidigynadfj; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_axfpcqicozeksdqwxanvhaigfnidigynadfj ON public.elements USING btree ("fieldLayoutId");


--
-- TOC entry 4123 (class 1259 OID 17203)
-- Name: idx_aywjsrxhznfumtuaqcnfnisrndoyxqxyqelu; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_aywjsrxhznfumtuaqcnfnisrndoyxqxyqelu ON public.entries USING btree ("sectionId");


--
-- TOC entry 4160 (class 1259 OID 17204)
-- Name: idx_bfbcsmslvamqcysctsvrgkyonfsmiueduylv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bfbcsmslvamqcysctsvrgkyonfsmiueduylv ON public.globalsets USING btree (name);


--
-- TOC entry 4330 (class 1259 OID 17205)
-- Name: idx_bfmwmtoctdvvupebqhfagygayolmhzlnfemt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bfmwmtoctdvvupebqhfagygayolmhzlnfemt ON public.widgets USING btree ("userId");


--
-- TOC entry 4141 (class 1259 OID 17206)
-- Name: idx_bghhvycgfmhyggeagfixijirnhbznjqqfjrx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bghhvycgfmhyggeagfixijirnhbznjqqfjrx ON public.fieldlayoutfields USING btree ("tabId");


--
-- TOC entry 4137 (class 1259 OID 17207)
-- Name: idx_bhpgeezebucqwzvpsupdxvgqzpabspsytnxs; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bhpgeezebucqwzvpsupdxvgqzpabspsytnxs ON public.fieldgroups USING btree (name);


--
-- TOC entry 4168 (class 1259 OID 17208)
-- Name: idx_bjssnpzxdbgoakkblkmfnmutukpmawykusml; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_bjssnpzxdbgoakkblkmfnmutukpmawykusml ON public.gqltokens USING btree (name);


--
-- TOC entry 4208 (class 1259 OID 17209)
-- Name: idx_brlliucjsjmqrwcwsgnqodychkslautofkqa; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_brlliucjsjmqrwcwsgnqodychkslautofkqa ON public.relations USING btree ("sourceSiteId");


--
-- TOC entry 4204 (class 1259 OID 17210)
-- Name: idx_bscvmgytpkjixuhlqquefekhokzykbuxtdwy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bscvmgytpkjixuhlqquefekhokzykbuxtdwy ON public.queue USING btree (channel, fail, "timeUpdated", "timePushed");


--
-- TOC entry 4172 (class 1259 OID 17211)
-- Name: idx_bviglcmlytlingcnqsnxfketurjehjwjwldz; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bviglcmlytlingcnqsnxfketurjehjwjwldz ON public.matrixblocks USING btree ("ownerId");


--
-- TOC entry 4085 (class 1259 OID 17212)
-- Name: idx_bwwmprokloqchpvqysxisopcetejuzyzupwr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_bwwmprokloqchpvqysxisopcetejuzyzupwr ON public.changedattributes USING btree ("elementId", "siteId", "dateUpdated");


--
-- TOC entry 4293 (class 1259 OID 17213)
-- Name: idx_ccagxxmwawdxcnmxwcurpeyntziysrqrzcpz; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ccagxxmwawdxcnmxwcurpeyntziysrqrzcpz ON public.usergroups USING btree (handle);


--
-- TOC entry 4209 (class 1259 OID 17214)
-- Name: idx_cdkqbsnfahbjmvtzcatpmuxbvvoqynexmsqg; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdkqbsnfahbjmvtzcatpmuxbvvoqynexmsqg ON public.relations USING btree ("targetId");


--
-- TOC entry 4275 (class 1259 OID 17215)
-- Name: idx_cdttticbvkoslbgksuepwlvsyhtczuugtyrb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdttticbvkoslbgksuepwlvsyhtczuugtyrb ON public.templatecacheelements USING btree ("elementId");


--
-- TOC entry 4130 (class 1259 OID 17216)
-- Name: idx_cfsoakqbmwalizuunryofycpykdbqgqndxxd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cfsoakqbmwalizuunryofycpykdbqgqndxxd ON public.entrytypes USING btree ("fieldLayoutId");


--
-- TOC entry 4124 (class 1259 OID 17217)
-- Name: idx_cjuyyrpdlfwkmusstdcesomsirnoqvnyqpqj; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cjuyyrpdlfwkmusstdcesomsirnoqvnyqpqj ON public.entries USING btree ("authorId");


--
-- TOC entry 4319 (class 1259 OID 17218)
-- Name: idx_clkdwfcohiejtslimqsybwsngwectagegknb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_clkdwfcohiejtslimqsybwsngwectagegknb ON public.volumefolders USING btree ("parentId");


--
-- TOC entry 4138 (class 1259 OID 17219)
-- Name: idx_cnpzflbqudzwjxxvsznxqgrssibrwjbnneer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cnpzflbqudzwjxxvsznxqgrssibrwjbnneer ON public.fieldgroups USING btree ("dateDeleted", name);


--
-- TOC entry 4074 (class 1259 OID 17220)
-- Name: idx_crfiycgffgjafkdwnawltzmpfxkfhnnvcxtb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_crfiycgffgjafkdwnawltzmpfxkfhnnvcxtb ON public.categorygroups USING btree (handle);


--
-- TOC entry 4055 (class 1259 OID 17221)
-- Name: idx_ctaszbolxbztbtzprhhuhdxejyjfznvyulqe; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ctaszbolxbztbtzprhhuhdxejyjfznvyulqe ON public.assetindexdata USING btree ("sessionId", "volumeId");


--
-- TOC entry 4335 (class 1259 OID 18003)
-- Name: idx_dbghsbpgoikbjrymprdhprpigshuqktzhxfs; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dbghsbpgoikbjrymprdhprpigshuqktzhxfs ON public.announcements USING btree ("userId", unread, "dateRead", "dateCreated");


--
-- TOC entry 4131 (class 1259 OID 17222)
-- Name: idx_dfalodovprinwkniorhrxpcdqihwixuaifjf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dfalodovprinwkniorhrxpcdqihwixuaifjf ON public.entrytypes USING btree ("dateDeleted");


--
-- TOC entry 4173 (class 1259 OID 17223)
-- Name: idx_dicisttfktbpuugyjynbzqxdjjnclaridqma; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dicisttfktbpuugyjynbzqxdjjnclaridqma ON public.matrixblocks USING btree ("typeId");


--
-- TOC entry 4296 (class 1259 OID 17224)
-- Name: idx_digsuhzentnvowzcjiajuujcqfytgkxwbgnh; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_digsuhzentnvowzcjiajuujcqfytgkxwbgnh ON public.usergroups_users USING btree ("groupId", "userId");


--
-- TOC entry 4174 (class 1259 OID 17225)
-- Name: idx_dlyoewgvggsaokpraelqlgsrpwhgdwffuohj; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dlyoewgvggsaokpraelqlgsrpwhgdwffuohj ON public.matrixblocks USING btree ("sortOrder");


--
-- TOC entry 4223 (class 1259 OID 17226)
-- Name: idx_dsmjrvkozsqliisdwfucenifiorfesqvqyht; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dsmjrvkozsqliisdwfucenifiorfesqvqyht ON public.sections USING btree (name);


--
-- TOC entry 4071 (class 1259 OID 17227)
-- Name: idx_dzadiotbdrmrxknlkmscakdwxvluhstcdoqm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dzadiotbdrmrxknlkmscakdwxvluhstcdoqm ON public.categories USING btree ("groupId");


--
-- TOC entry 4267 (class 1259 OID 17228)
-- Name: idx_ehecjefsyolrdvuiwbntylhdhctsckrjokiw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ehecjefsyolrdvuiwbntylhdhctsckrjokiw ON public.taggroups USING btree (handle);


--
-- TOC entry 4313 (class 1259 OID 17229)
-- Name: idx_ehepbjqeqphmjxgclpmmxmwienrzyxkvjfva; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ehepbjqeqphmjxgclpmmxmwienrzyxkvjfva ON public.users USING btree ("verificationCode");


--
-- TOC entry 4161 (class 1259 OID 17230)
-- Name: idx_ehtthrejpzodhyduxbqagnpvnpexfufrndbz; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ehtthrejpzodhyduxbqagnpvnpexfufrndbz ON public.globalsets USING btree ("fieldLayoutId");


--
-- TOC entry 4247 (class 1259 OID 17231)
-- Name: idx_enbhxbbkiwapcanipnsrramikokfqgrjresx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_enbhxbbkiwapcanipnsrramikokfqgrjresx ON public.sites USING btree ("dateDeleted");


--
-- TOC entry 4205 (class 1259 OID 17232)
-- Name: idx_enzejhlkulsuinjeplfmijgjszkpsoepynkk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_enzejhlkulsuinjeplfmijgjszkpsoepynkk ON public.queue USING btree (channel, fail, "timeUpdated", delay);


--
-- TOC entry 4283 (class 1259 OID 17233)
-- Name: idx_eorssjrepsdyhmerukmsjovvmmmpnloajmvd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_eorssjrepsdyhmerukmsjovvmmmpnloajmvd ON public.templatecaches USING btree ("siteId");


--
-- TOC entry 4235 (class 1259 OID 17234)
-- Name: idx_esejseinmaiyuvummbilzzfwqenrsmoyhfty; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_esejseinmaiyuvummbilzzfwqenrsmoyhfty ON public.sessions USING btree ("userId");


--
-- TOC entry 4075 (class 1259 OID 17235)
-- Name: idx_ewuqzbedrkcttgsmndhjeyoyiejfgfcjnjkl; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ewuqzbedrkcttgsmndhjeyoyiejfgfcjnjkl ON public.categorygroups USING btree ("dateDeleted");


--
-- TOC entry 4279 (class 1259 OID 17236)
-- Name: idx_eyugiickbncgkcldyfbsxntpkcpbifhttvov; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_eyugiickbncgkcldyfbsxntpkcpbifhttvov ON public.templatecachequeries USING btree ("cacheId");


--
-- TOC entry 4303 (class 1259 OID 17237)
-- Name: idx_fbpuehfsjjagfdlqiaxuzlcdfhrmxvxmjbjp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fbpuehfsjjagfdlqiaxuzlcdfhrmxvxmjbjp ON public.userpermissions_usergroups USING btree ("groupId");


--
-- TOC entry 4263 (class 1259 OID 17238)
-- Name: idx_fedwtexeakktsjlurghohpjdcvnoeajqzwli; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fedwtexeakktsjlurghohpjdcvnoeajqzwli ON public.systemmessages USING btree (language);


--
-- TOC entry 4064 (class 1259 OID 17239)
-- Name: idx_fumezaiflrfozsojqiezdhrpdbltwmteywmv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fumezaiflrfozsojqiezdhrpdbltwmteywmv ON public.assettransformindex USING btree ("volumeId", "assetId", location);


--
-- TOC entry 4147 (class 1259 OID 17240)
-- Name: idx_fxpbopwlgdqteycqtwsycqopycilqmffcgfk; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fxpbopwlgdqteycqtwsycqopycilqmffcgfk ON public.fieldlayouts USING btree (type);


--
-- TOC entry 4098 (class 1259 OID 17241)
-- Name: idx_fxpizzrhvufyitaecmqjeriygvybexnukcjz; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_fxpizzrhvufyitaecmqjeriygvybexnukcjz ON public.deprecationerrors USING btree (key, fingerprint);


--
-- TOC entry 4175 (class 1259 OID 17242)
-- Name: idx_gacfibtuowsanbmeqfcmeklkzeiyriuvwqqw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gacfibtuowsanbmeqfcmeklkzeiyriuvwqqw ON public.matrixblocks USING btree ("fieldId");


--
-- TOC entry 4224 (class 1259 OID 17243)
-- Name: idx_gbzwzqkmedeynftktegqiyworxunctqhvtzw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gbzwzqkmedeynftktegqiyworxunctqhvtzw ON public.sections USING btree ("dateDeleted");


--
-- TOC entry 4284 (class 1259 OID 17244)
-- Name: idx_ggwalfquahfsgvhzdqfrvmxpxjdwhfkditdy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ggwalfquahfsgvhzdqfrvmxpxjdwhfkditdy ON public.templatecaches USING btree ("cacheKey", "siteId", "expiryDate", path);


--
-- TOC entry 4236 (class 1259 OID 17245)
-- Name: idx_gksboxtdnwodiuiupoicfpxiuyacrsnsrerm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gksboxtdnwodiuiupoicfpxiuyacrsnsrerm ON public.sessions USING btree ("dateUpdated");


--
-- TOC entry 4116 (class 1259 OID 17246)
-- Name: idx_gnvaxsdbapattxwadeynexxuexmvpzgvlcob; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_gnvaxsdbapattxwadeynexxuexmvpzgvlcob ON public.elements_sites USING btree ("elementId", "siteId");


--
-- TOC entry 4076 (class 1259 OID 17247)
-- Name: idx_gompunhsmjqdsfuzzspaaegknwshhongvjqy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gompunhsmjqdsfuzzspaaegknwshhongvjqy ON public.categorygroups USING btree ("fieldLayoutId");


--
-- TOC entry 4101 (class 1259 OID 17985)
-- Name: idx_gsncbjjkzrdmknstiutqhlfspddmsobgjzqs; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_gsncbjjkzrdmknstiutqhlfspddmsobgjzqs ON public.drafts USING btree ("creatorId", provisional);


--
-- TOC entry 4148 (class 1259 OID 17248)
-- Name: idx_hlffxdhxhqusafcctzzfjtheambbyncgfbyx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_hlffxdhxhqusafcctzzfjtheambbyncgfbyx ON public.fieldlayouts USING btree ("dateDeleted");


--
-- TOC entry 4142 (class 1259 OID 17249)
-- Name: idx_ikmufzsvdltyjzuxfhbmctmefaaplccjfenp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ikmufzsvdltyjzuxfhbmctmefaaplccjfenp ON public.fieldlayoutfields USING btree ("fieldId");


--
-- TOC entry 4088 (class 1259 OID 17250)
-- Name: idx_innyzhysxpaasctawligntkzucepxtoiqcdd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_innyzhysxpaasctawligntkzucepxtoiqcdd ON public.changedfields USING btree ("elementId", "siteId", "dateUpdated");


--
-- TOC entry 4187 (class 1259 OID 17251)
-- Name: idx_jktluwxgmojcngujcsprshnwowqqbkgnjjzy; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_jktluwxgmojcngujcsprshnwowqqbkgnjjzy ON public.matrixcontent_introcontentblocks USING btree ("elementId", "siteId");


--
-- TOC entry 4125 (class 1259 OID 17252)
-- Name: idx_jnpjrmqrmmrbsendjuyxcsvppgkefwfdcdbb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_jnpjrmqrmmrbsendjuyxcsvppgkefwfdcdbb ON public.entries USING btree ("typeId");


--
-- TOC entry 4059 (class 1259 OID 17253)
-- Name: idx_kadqgpvmkcmvfuaudcczydeoudsqanlnmxqq; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kadqgpvmkcmvfuaudcczydeoudsqanlnmxqq ON public.assets USING btree ("folderId");


--
-- TOC entry 4091 (class 1259 OID 17254)
-- Name: idx_klycdbxfjkgrhfoktklzgpflanntdubizshw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_klycdbxfjkgrhfoktklzgpflanntdubizshw ON public.content USING btree (title);


--
-- TOC entry 4276 (class 1259 OID 17255)
-- Name: idx_kshifhmuqvgpjydcoxjkgslplehlkmegbscs; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kshifhmuqvgpjydcoxjkgslplehlkmegbscs ON public.templatecacheelements USING btree ("cacheId");


--
-- TOC entry 4307 (class 1259 OID 17256)
-- Name: idx_kusdxabnuybytvoqpqynsctniohsjrjdgnxz; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kusdxabnuybytvoqpqynsctniohsjrjdgnxz ON public.userpermissions_users USING btree ("userId");


--
-- TOC entry 4314 (class 1259 OID 17257)
-- Name: idx_kvmmgwsoowryueksxnnfhauffnmqaajsqoce; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kvmmgwsoowryueksxnnfhauffnmqaajsqoce ON public.users USING btree (lower((email)::text));


--
-- TOC entry 4126 (class 1259 OID 17258)
-- Name: idx_kvvoxurgpnjojsmstchtfzxprowqobagonla; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kvvoxurgpnjojsmstchtfzxprowqobagonla ON public.entries USING btree ("expiryDate");


--
-- TOC entry 4297 (class 1259 OID 17259)
-- Name: idx_kxhqocactthunplyzmkfdujxaibrtfhdbeig; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kxhqocactthunplyzmkfdujxaibrtfhdbeig ON public.usergroups_users USING btree ("userId");


--
-- TOC entry 4193 (class 1259 OID 17260)
-- Name: idx_kyomllkbybcoswefoifehqeuxftyacknduvt; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_kyomllkbybcoswefoifehqeuxftyacknduvt ON public.matrixcontent_tourpois USING btree ("elementId", "siteId");


--
-- TOC entry 4109 (class 1259 OID 26124)
-- Name: idx_lfidzehkdfpwpdepwiuytsdreguxmfauvxcg; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lfidzehkdfpwpdepwiuytsdreguxmfauvxcg ON public.elements USING btree (archived, "dateDeleted", "draftId", "revisionId", "canonicalId");


--
-- TOC entry 4132 (class 1259 OID 17261)
-- Name: idx_lfkszeaczqeuukacvkqepjxpraqpoyptansj; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lfkszeaczqeuukacvkqepjxpraqpoyptansj ON public.entrytypes USING btree ("sectionId");


--
-- TOC entry 4225 (class 1259 OID 17262)
-- Name: idx_lqeaodofyzagtpgrwenumtsxonjsojkznifz; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lqeaodofyzagtpgrwenumtsxonjsojkznifz ON public.sections USING btree ("structureId");


--
-- TOC entry 4300 (class 1259 OID 17263)
-- Name: idx_lqsfxhxwmkqosblnviciymxkqnvxbfusbtjy; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_lqsfxhxwmkqosblnviciymxkqnvxbfusbtjy ON public.userpermissions USING btree (name);


--
-- TOC entry 4133 (class 1259 OID 17264)
-- Name: idx_lrypalgtkudwbhhsczxghxsbqvrckuznhzww; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lrypalgtkudwbhhsczxghxsbqvrckuznhzww ON public.entrytypes USING btree (handle, "sectionId");


--
-- TOC entry 4178 (class 1259 OID 17265)
-- Name: idx_lwbpeawpsxxvdhvvzixckuzhrbudfdzppqni; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_lwbpeawpsxxvdhvvzixckuzhrbudfdzppqni ON public.matrixblocktypes USING btree ("fieldId");


--
-- TOC entry 4241 (class 1259 OID 17266)
-- Name: idx_mdpfppuruvsemeisbpwcsxsoygvvjxzdagle; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_mdpfppuruvsemeisbpwcsxsoygvvjxzdagle ON public.shunnedmessages USING btree ("userId", message);


--
-- TOC entry 4308 (class 1259 OID 17267)
-- Name: idx_mewmjrwtloapupmfkmitakpmfekwhsqcnbhe; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_mewmjrwtloapupmfkmitakpmfekwhsqcnbhe ON public.userpermissions_users USING btree ("permissionId", "userId");


--
-- TOC entry 4117 (class 1259 OID 17268)
-- Name: idx_mhufqbryfvlnymhzimkqrsltadxfjswhbcda; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mhufqbryfvlnymhzimkqrsltadxfjswhbcda ON public.elements_sites USING btree ("siteId");


--
-- TOC entry 4264 (class 1259 OID 17269)
-- Name: idx_molvdyoqbatpezwtmvzrslwfpqxoahhpgrzg; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_molvdyoqbatpezwtmvzrslwfpqxoahhpgrzg ON public.systemmessages USING btree (key, language);


--
-- TOC entry 4156 (class 1259 OID 17270)
-- Name: idx_mqmligqbbyutclonhejnfasmmdavtiaegtyr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mqmligqbbyutclonhejnfasmmdavtiaegtyr ON public.fields USING btree (handle, context);


--
-- TOC entry 4324 (class 1259 OID 17271)
-- Name: idx_mtxyzqiblpxnkptlvngobzhvkzhcnfpgfxza; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mtxyzqiblpxnkptlvngobzhvkzhcnfpgfxza ON public.volumes USING btree ("fieldLayoutId");


--
-- TOC entry 4118 (class 1259 OID 17272)
-- Name: idx_mtzclsstwkywflzowjodzgxzhjrqmkoltpnf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_mtzclsstwkywflzowjodzgxzhjrqmkoltpnf ON public.elements_sites USING btree (slug, "siteId");


--
-- TOC entry 4237 (class 1259 OID 17273)
-- Name: idx_naceylbsdjafrhifxzefxcclmuvxeraieuij; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_naceylbsdjafrhifxzefxcclmuvxeraieuij ON public.sessions USING btree (uid);


--
-- TOC entry 4315 (class 1259 OID 17274)
-- Name: idx_nfcvuhvuyihgvffqaorndyextbsehocgrrif; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nfcvuhvuyihgvffqaorndyextbsehocgrrif ON public.users USING btree (lower((username)::text));


--
-- TOC entry 4219 (class 1259 OID 17275)
-- Name: idx_ngapqmosuzkrwmizkphenmuxdwxfyvnrqqju; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ngapqmosuzkrwmizkphenmuxdwxfyvnrqqju ON public.searchindex USING btree (keywords);


--
-- TOC entry 4151 (class 1259 OID 17276)
-- Name: idx_ngttnoentmqqqjpjfpfxnjwqhrkiymeuurdc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ngttnoentmqqqjpjfpfxnjwqhrkiymeuurdc ON public.fieldlayouttabs USING btree ("layoutId");


--
-- TOC entry 4285 (class 1259 OID 17277)
-- Name: idx_nitbxxodacivlpxiudtembhpmcfiixwwazxp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nitbxxodacivlpxiudtembhpmcfiixwwazxp ON public.templatecaches USING btree ("cacheKey", "siteId", "expiryDate");


--
-- TOC entry 4184 (class 1259 OID 17278)
-- Name: idx_nmzznfhminijiihshczxoyxdienswbikzbnq; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_nmzznfhminijiihshczxoyxdienswbikzbnq ON public.matrixcontent_factscontentblocks USING btree ("elementId", "siteId");


--
-- TOC entry 4077 (class 1259 OID 17279)
-- Name: idx_nunxmdrpvwxaododzhytzhghnvpetyducgrb; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_nunxmdrpvwxaododzhytzhghnvpetyducgrb ON public.categorygroups USING btree ("structureId");


--
-- TOC entry 4102 (class 1259 OID 17280)
-- Name: idx_odpihnhdhqitcbbcbaggkxexsswmujfesisi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_odpihnhdhqitcbbcbaggkxexsswmujfesisi ON public.drafts USING btree (saved);


--
-- TOC entry 4288 (class 1259 OID 17281)
-- Name: idx_ofvqhwjoofgywybnttmigawptysxawrbbgfm; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_ofvqhwjoofgywybnttmigawptysxawrbbgfm ON public.tokens USING btree (token);


--
-- TOC entry 4280 (class 1259 OID 17282)
-- Name: idx_oqmmeyljxxjipeptaywrfmajncyxnhatlbai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_oqmmeyljxxjipeptaywrfmajncyxnhatlbai ON public.templatecachequeries USING btree (type);


--
-- TOC entry 4272 (class 1259 OID 17283)
-- Name: idx_ozvnjluwhaxftfjffqkmcizeojcqlqoexdst; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ozvnjluwhaxftfjffqkmcizeojcqlqoexdst ON public.tags USING btree ("groupId");


--
-- TOC entry 4143 (class 1259 OID 17284)
-- Name: idx_pdxnhcznrgxsjdkowroebghgruaweneeopsl; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pdxnhcznrgxsjdkowroebghgruaweneeopsl ON public.fieldlayoutfields USING btree ("sortOrder");


--
-- TOC entry 4110 (class 1259 OID 17285)
-- Name: idx_pfdrctzhuvmlijxplhokrgwuxxhpnttzhmvo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pfdrctzhuvmlijxplhokrgwuxxhpnttzhmvo ON public.elements USING btree (type);


--
-- TOC entry 4119 (class 1259 OID 17286)
-- Name: idx_pqegcqoexvbdcgdgnmsyvmpcitdeoesfvnrc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pqegcqoexvbdcgdgnmsyvmpcitdeoesfvnrc ON public.elements_sites USING btree (enabled);


--
-- TOC entry 4060 (class 1259 OID 17287)
-- Name: idx_pzsvwjjhpzfvzxfhvftgwlglemrfckixenfr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pzsvwjjhpzfvzxfhvftgwlglemrfckixenfr ON public.assets USING btree ("volumeId");


--
-- TOC entry 4248 (class 1259 OID 17288)
-- Name: idx_qcojqnkqasrzepyvzuihctalasbusfbmqxlu; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_qcojqnkqasrzepyvzuihctalasbusfbmqxlu ON public.sites USING btree (handle);


--
-- TOC entry 4127 (class 1259 OID 17289)
-- Name: idx_qhdvlwuacpsgfdwfhfsddanozcemgfsnicwr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_qhdvlwuacpsgfdwfhfsddanozcemgfsnicwr ON public.entries USING btree ("postDate");


--
-- TOC entry 4134 (class 1259 OID 17290)
-- Name: idx_qsjubbhvxnrrxglpqxrdlcmxmmzpserdjvhd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_qsjubbhvxnrrxglpqxrdlcmxmmzpserdjvhd ON public.entrytypes USING btree (name, "sectionId");


--
-- TOC entry 4162 (class 1259 OID 17291)
-- Name: idx_quoqtowoigtgjyvjafneylwttvfkbluvfjvf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_quoqtowoigtgjyvjafneylwttvfkbluvfjvf ON public.globalsets USING btree (handle);


--
-- TOC entry 4325 (class 1259 OID 17292)
-- Name: idx_raxapfrkooshohqwnsttqzbmjmneaubrjywp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_raxapfrkooshohqwnsttqzbmjmneaubrjywp ON public.volumes USING btree (name);


--
-- TOC entry 4229 (class 1259 OID 17293)
-- Name: idx_rdanlqdzozimxsvbdkdwebcutvlwnvokphvv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rdanlqdzozimxsvbdkdwebcutvlwnvokphvv ON public.sections_sites USING btree ("siteId");


--
-- TOC entry 4230 (class 1259 OID 17294)
-- Name: idx_rfwgzjbbybxgobvzcthuaynttiylycwcqbpr; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_rfwgzjbbybxgobvzcthuaynttiylycwcqbpr ON public.sections_sites USING btree ("sectionId", "siteId");


--
-- TOC entry 4252 (class 1259 OID 17295)
-- Name: idx_rhijawpoyksyqnzcdofjzckuaohzotlmjwls; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rhijawpoyksyqnzcdofjzckuaohzotlmjwls ON public.structureelements USING btree (lft);


--
-- TOC entry 4092 (class 1259 OID 17296)
-- Name: idx_rpnbljhhzohrjzbwtxaszvxwlyaktwgatkes; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rpnbljhhzohrjzbwtxaszvxwlyaktwgatkes ON public.content USING btree ("siteId");


--
-- TOC entry 4304 (class 1259 OID 17297)
-- Name: idx_rpxsxevuykubuyidwnxyvsphjonxgxvwshlu; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_rpxsxevuykubuyidwnxyvsphjonxgxvwshlu ON public.userpermissions_usergroups USING btree ("permissionId", "groupId");


--
-- TOC entry 4163 (class 1259 OID 17990)
-- Name: idx_seeyqjpnheychuiwutselxsxfaequbbbwcns; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_seeyqjpnheychuiwutselxsxfaequbbbwcns ON public.globalsets USING btree ("sortOrder");


--
-- TOC entry 4111 (class 1259 OID 17298)
-- Name: idx_sfqvyfdoxlbwdtlckzohzcbofhcrymxnibao; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sfqvyfdoxlbwdtlckzohzcbofhcrymxnibao ON public.elements USING btree ("dateDeleted");


--
-- TOC entry 4112 (class 1259 OID 17299)
-- Name: idx_shyasyalysnodnfacqievotxdybtwxloxtjn; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_shyasyalysnodnfacqievotxdybtwxloxtjn ON public.elements USING btree (archived, "dateCreated");


--
-- TOC entry 4226 (class 1259 OID 17300)
-- Name: idx_sqaybshkxvjzciecdlmbvxxkqhcevisxrstr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sqaybshkxvjzciecdlmbvxxkqhcevisxrstr ON public.sections USING btree (handle);


--
-- TOC entry 4061 (class 1259 OID 17301)
-- Name: idx_sucfqgpljyauzkaercsyxfbbuihgqgejravw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_sucfqgpljyauzkaercsyxfbbuihgqgejravw ON public.assets USING btree (filename, "folderId");


--
-- TOC entry 4244 (class 1259 OID 17302)
-- Name: idx_swbdhkcyldrymmimnyyzhoruusqzieqzqkoj; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_swbdhkcyldrymmimnyyzhoruusqzieqzqkoj ON public.sitegroups USING btree (name);


--
-- TOC entry 4144 (class 1259 OID 17303)
-- Name: idx_sxmmpdncyboznlkdhwiqqhogqjfugcljetcv; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_sxmmpdncyboznlkdhwiqqhogqjfugcljetcv ON public.fieldlayoutfields USING btree ("layoutId", "fieldId");


--
-- TOC entry 4253 (class 1259 OID 17304)
-- Name: idx_tibckudppxjixabnwitmstncmonzyfcljxwp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tibckudppxjixabnwitmstncmonzyfcljxwp ON public.structureelements USING btree ("elementId");


--
-- TOC entry 4268 (class 1259 OID 17305)
-- Name: idx_tisltfobstngapxhxwhgjmyrcgncfowhbumi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tisltfobstngapxhxwhgjmyrcgncfowhbumi ON public.taggroups USING btree (name);


--
-- TOC entry 4078 (class 1259 OID 17306)
-- Name: idx_tkhgjlhpsahimpdzkdespdvitrlqmbbzinfs; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tkhgjlhpsahimpdzkdespdvitrlqmbbzinfs ON public.categorygroups USING btree (name);


--
-- TOC entry 4199 (class 1259 OID 17307)
-- Name: idx_tutojnrimafslbculxiyhtqlhmtjxsdycodm; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_tutojnrimafslbculxiyhtqlhmtjxsdycodm ON public.plugins USING btree (handle);


--
-- TOC entry 4056 (class 1259 OID 17308)
-- Name: idx_tyxwtvkxmivthgakhwfzpfusqhfpoqpefwjh; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_tyxwtvkxmivthgakhwfzpfusqhfpoqpefwjh ON public.assetindexdata USING btree ("volumeId");


--
-- TOC entry 4120 (class 1259 OID 17309)
-- Name: idx_ubeonauvklsmksdrviihehxaebkdfwstmftt; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ubeonauvklsmksdrviihehxaebkdfwstmftt ON public.elements_sites USING btree (lower((uri)::text), "siteId");


--
-- TOC entry 4326 (class 1259 OID 17310)
-- Name: idx_ueluuquebchhwfpsjenjoefhomovbdbpovor; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ueluuquebchhwfpsjenjoefhomovbdbpovor ON public.volumes USING btree (handle);


--
-- TOC entry 4269 (class 1259 OID 17311)
-- Name: idx_ugmrktthadekhnyawajexhfslnvlugbcpgay; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ugmrktthadekhnyawajexhfslnvlugbcpgay ON public.taggroups USING btree ("dateDeleted");


--
-- TOC entry 4254 (class 1259 OID 17312)
-- Name: idx_ujlortvoloqawkvpyhqxoxrvinmrqebqciqr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_ujlortvoloqawkvpyhqxoxrvinmrqebqciqr ON public.structureelements USING btree (level);


--
-- TOC entry 4327 (class 1259 OID 17313)
-- Name: idx_unwswmwqqllvbixmraomayyygydxsnxhkutm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_unwswmwqqllvbixmraomayyygydxsnxhkutm ON public.volumes USING btree ("dateDeleted");


--
-- TOC entry 4220 (class 1259 OID 17314)
-- Name: idx_uxfqbahutggwjubvwsfvkoegeluazksytkju; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_uxfqbahutggwjubvwsfvkoegeluazksytkju ON public.searchindex USING gin (keywords_vector) WITH (fastupdate=yes);


--
-- TOC entry 4190 (class 1259 OID 17315)
-- Name: idx_vcwwquzxaartpfiiknmxwsyuuheifzpqptgx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_vcwwquzxaartpfiiknmxwsyuuheifzpqptgx ON public.matrixcontent_poiastroobject USING btree ("elementId", "siteId");


--
-- TOC entry 4179 (class 1259 OID 17316)
-- Name: idx_vewziwqascthqjmxznvqfjhcsxhndhyzaxpj; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vewziwqascthqjmxznvqfjhcsxhndhyzaxpj ON public.matrixblocktypes USING btree ("fieldLayoutId");


--
-- TOC entry 4320 (class 1259 OID 17317)
-- Name: idx_vkbtvweombmisfvayfkzzkdirurvlcvlsztu; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_vkbtvweombmisfvayfkzzkdirurvlcvlsztu ON public.volumefolders USING btree (name, "parentId", "volumeId");


--
-- TOC entry 4260 (class 1259 OID 17318)
-- Name: idx_vkdnqkhzdlykulcvnzghtithnsbrrqecubyf; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vkdnqkhzdlykulcvnzghtithnsbrrqecubyf ON public.structures USING btree ("dateDeleted");


--
-- TOC entry 4316 (class 1259 OID 17319)
-- Name: idx_vohwgrkpnvinjzeftawuztuhkminmupepvvu; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vohwgrkpnvinjzeftawuztuhkminmupepvvu ON public.users USING btree (uid);


--
-- TOC entry 4067 (class 1259 OID 17320)
-- Name: idx_vqrexmlapffadgvlkjxrfypkgijshndffhft; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vqrexmlapffadgvlkjxrfypkgijshndffhft ON public.assettransforms USING btree (name);


--
-- TOC entry 4068 (class 1259 OID 17321)
-- Name: idx_vxholinzobnlbwtgyaluqutqngzetijhtwfe; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vxholinzobnlbwtgyaluqutqngzetijhtwfe ON public.assettransforms USING btree (handle);


--
-- TOC entry 4216 (class 1259 OID 17322)
-- Name: idx_warcvjhvekwsfazlbslnlhhwyvmvhxdombgu; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_warcvjhvekwsfazlbslnlhhwyvmvhxdombgu ON public.revisions USING btree ("sourceId", num);


--
-- TOC entry 4180 (class 1259 OID 17323)
-- Name: idx_wasqfkxrvoapoopfusuhwkswbwaloqfxuqrz; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wasqfkxrvoapoopfusuhwkswbwaloqfxuqrz ON public.matrixblocktypes USING btree (handle, "fieldId");


--
-- TOC entry 4152 (class 1259 OID 17324)
-- Name: idx_wbilfpsakocknvryuoqlsjavvbbhocdcqvpn; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wbilfpsakocknvryuoqlsjavvbbhocdcqvpn ON public.fieldlayouttabs USING btree ("sortOrder");


--
-- TOC entry 4336 (class 1259 OID 18004)
-- Name: idx_wihtlvghkxxamqiqronpcjkayntcikintgeq; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wihtlvghkxxamqiqronpcjkayntcikintgeq ON public.announcements USING btree ("dateRead");


--
-- TOC entry 4289 (class 1259 OID 17325)
-- Name: idx_wysyhamnxufkthhfmeffcdduvwpirckxiwra; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_wysyhamnxufkthhfmeffcdduvwpirckxiwra ON public.tokens USING btree ("expiryDate");


--
-- TOC entry 4093 (class 1259 OID 17326)
-- Name: idx_xcvciijipsangbimzlvroajksznflvorwpmm; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_xcvciijipsangbimzlvroajksznflvorwpmm ON public.content USING btree ("elementId", "siteId");


--
-- TOC entry 4113 (class 1259 OID 17327)
-- Name: idx_xjimybbwkmpbcsdoxftapqumcsksaaayxgdc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_xjimybbwkmpbcsdoxftapqumcsksaaayxgdc ON public.elements USING btree (enabled);


--
-- TOC entry 4255 (class 1259 OID 17328)
-- Name: idx_xlpmulmmghjebuqfpgrgcwgljbauuhmzkxer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_xlpmulmmghjebuqfpgrgcwgljbauuhmzkxer ON public.structureelements USING btree (root);


--
-- TOC entry 4181 (class 1259 OID 17329)
-- Name: idx_xqxdgmprxluthfbnbckshsdnhtkyygvbspyv; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_xqxdgmprxluthfbnbckshsdnhtkyygvbspyv ON public.matrixblocktypes USING btree (name, "fieldId");


--
-- TOC entry 4210 (class 1259 OID 17330)
-- Name: idx_xuqowaqrrvgqlistluqihtadujctqwakdxwu; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_xuqowaqrrvgqlistluqihtadujctqwakdxwu ON public.relations USING btree ("fieldId", "sourceId", "sourceSiteId", "targetId");


--
-- TOC entry 4082 (class 1259 OID 17331)
-- Name: idx_ybksgjflahutfceyqeaflvbcopvvytdonfaf; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_ybksgjflahutfceyqeaflvbcopvvytdonfaf ON public.categorygroups_sites USING btree ("groupId", "siteId");


--
-- TOC entry 4249 (class 1259 OID 17332)
-- Name: idx_yrxftlnxpsmciukckimyjfeqwzntvcqipqxi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_yrxftlnxpsmciukckimyjfeqwzntvcqipqxi ON public.sites USING btree ("sortOrder");


--
-- TOC entry 4238 (class 1259 OID 17333)
-- Name: idx_zasfvpoahplcfxeumgzgnzxbgcpfagpnvndo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_zasfvpoahplcfxeumgzgnzxbgcpfagpnvndo ON public.sessions USING btree (token);


--
-- TOC entry 4256 (class 1259 OID 17334)
-- Name: idx_zdndeeuuwcedatjtgftdnsmwlhxglvgpxaus; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_zdndeeuuwcedatjtgftdnsmwlhxglvgpxaus ON public.structureelements USING btree (rgt);


--
-- TOC entry 4105 (class 1259 OID 17335)
-- Name: idx_zgcnapihnimdsbybbsupdjvrptppmwvrzqzs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_zgcnapihnimdsbybbsupdjvrptppmwvrzqzs ON public.elementindexsettings USING btree (type);


--
-- TOC entry 4257 (class 1259 OID 17336)
-- Name: idx_ziqrgwirypwcmgbhxholppoirzukpgviiyty; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_ziqrgwirypwcmgbhxholppoirzukpgviiyty ON public.structureelements USING btree ("structureId", "elementId");


--
-- TOC entry 4211 (class 1259 OID 17337)
-- Name: idx_zjokdikzipkpbjrzpcjhbyklqfsupadfszkh; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_zjokdikzipkpbjrzpcjhbyklqfsupadfszkh ON public.relations USING btree ("sourceId");


--
-- TOC entry 4157 (class 1259 OID 17338)
-- Name: idx_zjsqazfrdnpaauhxyufuqlbskizitghwlcwz; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_zjsqazfrdnpaauhxyufuqlbskizitghwlcwz ON public.fields USING btree ("groupId");


--
-- TOC entry 4169 (class 1259 OID 17339)
-- Name: idx_zjyrvkmarmvzgtgqxshnjxhzdpbkpgnxvdxv; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_zjyrvkmarmvzgtgqxshnjxhzdpbkpgnxvdxv ON public.gqltokens USING btree ("accessToken");


--
-- TOC entry 4321 (class 1259 OID 17340)
-- Name: idx_zmsizsccwslchutbplrheudfbqrwmdrlppah; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_zmsizsccwslchutbplrheudfbqrwmdrlppah ON public.volumefolders USING btree ("volumeId");


--
-- TOC entry 4405 (class 2606 OID 17341)
-- Name: sessions fk_acapcwrtxkcbfpvcrircmxmzajykqkdrapda; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT fk_acapcwrtxkcbfpvcrircmxmzajykqkdrapda FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4358 (class 2606 OID 17346)
-- Name: craftidtokens fk_anncddwkkgbeknhwdmqtunlpmekxuhzfvrzs; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.craftidtokens
    ADD CONSTRAINT fk_anncddwkkgbeknhwdmqtunlpmekxuhzfvrzs FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4381 (class 2606 OID 17351)
-- Name: gqltokens fk_aourqrpugkkibrapdozivhaolxpylahiwfug; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gqltokens
    ADD CONSTRAINT fk_aourqrpugkkibrapdozivhaolxpylahiwfug FOREIGN KEY ("schemaId") REFERENCES public.gqlschemas(id) ON DELETE SET NULL;


--
-- TOC entry 4382 (class 2606 OID 17356)
-- Name: matrixblocks fk_araaqeavsmgffynlfsrtyibkfmwmqmrispuc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixblocks
    ADD CONSTRAINT fk_araaqeavsmgffynlfsrtyibkfmwmqmrispuc FOREIGN KEY ("fieldId") REFERENCES public.fields(id) ON DELETE CASCADE;


--
-- TOC entry 4424 (class 2606 OID 17361)
-- Name: users fk_avooeanabxpkxyponktscntoanrcdfcxgpbg; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_avooeanabxpkxyponktscntoanrcdfcxgpbg FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4352 (class 2606 OID 17366)
-- Name: changedfields fk_azzkhjytfotjfwabxpvccgbnxcthgdecdysu; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changedfields
    ADD CONSTRAINT fk_azzkhjytfotjfwabxpvccgbnxcthgdecdysu FOREIGN KEY ("fieldId") REFERENCES public.fields(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4365 (class 2606 OID 17371)
-- Name: elements_sites fk_baalghwvkgkaubibaxabpxeogzvepwrhrujt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elements_sites
    ADD CONSTRAINT fk_baalghwvkgkaubibaxabpxeogzvepwrhrujt FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4396 (class 2606 OID 17376)
-- Name: relations fk_bcyfwivvzyxxvobykfcknsaxnsevrvztdnxz; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_bcyfwivvzyxxvobykfcknsaxnsevrvztdnxz FOREIGN KEY ("targetId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4342 (class 2606 OID 17381)
-- Name: categories fk_bhtscovzuwfwndtvugsyrvumfhcwmpikdaui; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_bhtscovzuwfwndtvugsyrvumfhcwmpikdaui FOREIGN KEY ("groupId") REFERENCES public.categorygroups(id) ON DELETE CASCADE;


--
-- TOC entry 4338 (class 2606 OID 17386)
-- Name: assets fk_blxwfdyggrimtvtcesmrepbcrsfwytlcszyi; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_blxwfdyggrimtvtcesmrepbcrsfwytlcszyi FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4372 (class 2606 OID 17391)
-- Name: entrytypes fk_btbdzklkalrnmahnydzzgqhidmiwvlhfgmzv; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entrytypes
    ADD CONSTRAINT fk_btbdzklkalrnmahnydzzgqhidmiwvlhfgmzv FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- TOC entry 4349 (class 2606 OID 17396)
-- Name: changedattributes fk_bvrqiovnqfjapcrgbzfvzsjsccrxbkaerazr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changedattributes
    ADD CONSTRAINT fk_bvrqiovnqfjapcrgbzfvzsjsccrxbkaerazr FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4390 (class 2606 OID 17401)
-- Name: matrixcontent_introcontentblocks fk_bwfyjnywrrlkdokpeclsrjaqlkjwmtlqunvr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_introcontentblocks
    ADD CONSTRAINT fk_bwfyjnywrrlkdokpeclsrjaqlkjwmtlqunvr FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4361 (class 2606 OID 17406)
-- Name: elements fk_clpcbyoxvqwzfofatabglgbebvompowgcyfp; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT fk_clpcbyoxvqwzfofatabglgbebvompowgcyfp FOREIGN KEY ("revisionId") REFERENCES public.revisions(id) ON DELETE CASCADE;


--
-- TOC entry 4373 (class 2606 OID 17411)
-- Name: entrytypes fk_cqgvrielnebilxqkzjnvoaadnocaqyobztpc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entrytypes
    ADD CONSTRAINT fk_cqgvrielnebilxqkzjnvoaadnocaqyobztpc FOREIGN KEY ("sectionId") REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- TOC entry 4364 (class 2606 OID 17979)
-- Name: elements fk_csvtrxvubinilymfxjefmenbslssivcaywgv; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT fk_csvtrxvubinilymfxjefmenbslssivcaywgv FOREIGN KEY ("canonicalId") REFERENCES public.elements(id) ON DELETE SET NULL;


--
-- TOC entry 4421 (class 2606 OID 17416)
-- Name: userpermissions_users fk_dphsfwlqyruxsalrsiivumtnscxrbormhyok; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpermissions_users
    ADD CONSTRAINT fk_dphsfwlqyruxsalrsiivumtnscxrbormhyok FOREIGN KEY ("permissionId") REFERENCES public.userpermissions(id) ON DELETE CASCADE;


--
-- TOC entry 4343 (class 2606 OID 17421)
-- Name: categories fk_dppvwxstbmhlmphrljswdkuyytaqhbdfanzi; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_dppvwxstbmhlmphrljswdkuyytaqhbdfanzi FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4345 (class 2606 OID 17426)
-- Name: categorygroups fk_dqbnjjtzjzmidwljrscnqjpehqxekfqldqtl; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorygroups
    ADD CONSTRAINT fk_dqbnjjtzjzmidwljrscnqjpehqxekfqldqtl FOREIGN KEY ("structureId") REFERENCES public.structures(id) ON DELETE CASCADE;


--
-- TOC entry 4386 (class 2606 OID 17431)
-- Name: matrixblocktypes fk_dskhmacthjwrlinugyolppexvwweuqjkurrx; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixblocktypes
    ADD CONSTRAINT fk_dskhmacthjwrlinugyolppexvwweuqjkurrx FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- TOC entry 4367 (class 2606 OID 17436)
-- Name: entries fk_dsklafpetxkeadsfrvihyvjmpohxjcidjiqr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_dsklafpetxkeadsfrvihyvjmpohxjcidjiqr FOREIGN KEY ("typeId") REFERENCES public.entrytypes(id) ON DELETE CASCADE;


--
-- TOC entry 4378 (class 2606 OID 17441)
-- Name: fields fk_dveexxlnibjkmyeakcgoteribufsqfwajafq; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fields
    ADD CONSTRAINT fk_dveexxlnibjkmyeakcgoteribufsqfwajafq FOREIGN KEY ("groupId") REFERENCES public.fieldgroups(id) ON DELETE CASCADE;


--
-- TOC entry 4359 (class 2606 OID 17446)
-- Name: drafts fk_dxcryxmtajlhgoprjbiuxkuwpzwxxnwuzjwe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drafts
    ADD CONSTRAINT fk_dxcryxmtajlhgoprjbiuxkuwpzwxxnwuzjwe FOREIGN KEY ("creatorId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4397 (class 2606 OID 17451)
-- Name: relations fk_ebqmmgphfynuftwxcalphnjofzflasbyaasn; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_ebqmmgphfynuftwxcalphnjofzflasbyaasn FOREIGN KEY ("fieldId") REFERENCES public.fields(id) ON DELETE CASCADE;


--
-- TOC entry 4411 (class 2606 OID 17456)
-- Name: tags fk_ewbidcsefcwzbbeanwrnwrfgihcqnamsbvrp; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_ewbidcsefcwzbbeanwrnwrfgihcqnamsbvrp FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4362 (class 2606 OID 17461)
-- Name: elements fk_ewtmyjcqvkqrfytglpijzwcfhmcapqwzgpsc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT fk_ewtmyjcqvkqrfytglpijzwcfhmcapqwzgpsc FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- TOC entry 4400 (class 2606 OID 17466)
-- Name: revisions fk_eyetqcrufhfxelkkjlzuvrdbjmzkjlapelim; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revisions
    ADD CONSTRAINT fk_eyetqcrufhfxelkkjlzuvrdbjmzkjlapelim FOREIGN KEY ("sourceId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4353 (class 2606 OID 17471)
-- Name: changedfields fk_fdkqndlqpvzklxzwtbhfzokomgabwgzturby; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changedfields
    ADD CONSTRAINT fk_fdkqndlqpvzklxzwtbhfzokomgabwgzturby FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4394 (class 2606 OID 17476)
-- Name: matrixcontent_tourpois fk_fmqrxondapetavjrkcsajkyqjkufqioqxvry; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_tourpois
    ADD CONSTRAINT fk_fmqrxondapetavjrkcsajkyqjkufqioqxvry FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4407 (class 2606 OID 17481)
-- Name: sites fk_fqnltiqgnuduvdksbrxdswgpicwjtqfyxllw; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT fk_fqnltiqgnuduvdksbrxdswgpicwjtqfyxllw FOREIGN KEY ("groupId") REFERENCES public.sitegroups(id) ON DELETE CASCADE;


--
-- TOC entry 4413 (class 2606 OID 17486)
-- Name: templatecacheelements fk_frhrwzpyrjzxdgeednauxfbdgbuvwpwqmpjz; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templatecacheelements
    ADD CONSTRAINT fk_frhrwzpyrjzxdgeednauxfbdgbuvwpwqmpjz FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4377 (class 2606 OID 17491)
-- Name: fieldlayouttabs fk_fykpcumxtmiiccsyqftpyihmtixchdfeylxy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldlayouttabs
    ADD CONSTRAINT fk_fykpcumxtmiiccsyqftpyihmtixchdfeylxy FOREIGN KEY ("layoutId") REFERENCES public.fieldlayouts(id) ON DELETE CASCADE;


--
-- TOC entry 4419 (class 2606 OID 17496)
-- Name: userpermissions_usergroups fk_gadsjqcmbnfuxubomxqkpuwdynuktnkplxpf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpermissions_usergroups
    ADD CONSTRAINT fk_gadsjqcmbnfuxubomxqkpuwdynuktnkplxpf FOREIGN KEY ("permissionId") REFERENCES public.userpermissions(id) ON DELETE CASCADE;


--
-- TOC entry 4422 (class 2606 OID 17501)
-- Name: userpermissions_users fk_gifjhtsudjlgnzhuylqngacpwbftnykqczym; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpermissions_users
    ADD CONSTRAINT fk_gifjhtsudjlgnzhuylqngacpwbftnykqczym FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4374 (class 2606 OID 17506)
-- Name: fieldlayoutfields fk_gpddbfuvkqhnliuceyxowviqxdcjujfkbrkv; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldlayoutfields
    ADD CONSTRAINT fk_gpddbfuvkqhnliuceyxowviqxdcjujfkbrkv FOREIGN KEY ("fieldId") REFERENCES public.fields(id) ON DELETE CASCADE;


--
-- TOC entry 4347 (class 2606 OID 17511)
-- Name: categorygroups_sites fk_gqjmczlxxqtogtausixmprwqdgdofeyqjqvt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorygroups_sites
    ADD CONSTRAINT fk_gqjmczlxxqtogtausixmprwqdgdofeyqjqvt FOREIGN KEY ("groupId") REFERENCES public.categorygroups(id) ON DELETE CASCADE;


--
-- TOC entry 4350 (class 2606 OID 17516)
-- Name: changedattributes fk_gulsscrjmelxhtibudradswtohnzktpddpjy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changedattributes
    ADD CONSTRAINT fk_gulsscrjmelxhtibudradswtohnzktpddpjy FOREIGN KEY ("userId") REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 4348 (class 2606 OID 17521)
-- Name: categorygroups_sites fk_hcqydxndhjvqlhqwancewqwyeeizsxigtmwb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorygroups_sites
    ADD CONSTRAINT fk_hcqydxndhjvqlhqwancewqwyeeizsxigtmwb FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4346 (class 2606 OID 17526)
-- Name: categorygroups fk_hlcsoqhdgxfwvuykndjycdpzovgyhffgtqne; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categorygroups
    ADD CONSTRAINT fk_hlcsoqhdgxfwvuykndjycdpzovgyhffgtqne FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- TOC entry 4356 (class 2606 OID 17531)
-- Name: content fk_hlmvwoxokzqvetfzwpkqhqqufgvdixthcjym; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT fk_hlmvwoxokzqvetfzwpkqhqqufgvdixthcjym FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4417 (class 2606 OID 17536)
-- Name: usergroups_users fk_iajjspnankfmhexucrqruyzntgitzvkdaazc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usergroups_users
    ADD CONSTRAINT fk_iajjspnankfmhexucrqruyzntgitzvkdaazc FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4383 (class 2606 OID 17541)
-- Name: matrixblocks fk_ibajiagocgofbtckkfshgiiklubaxtouyelc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixblocks
    ADD CONSTRAINT fk_ibajiagocgofbtckkfshgiiklubaxtouyelc FOREIGN KEY ("ownerId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4388 (class 2606 OID 17546)
-- Name: matrixcontent_factscontentblocks fk_ielkpgacqtzajgjgvakfteyegepwybqugvxk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_factscontentblocks
    ADD CONSTRAINT fk_ielkpgacqtzajgjgvakfteyegepwybqugvxk FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4428 (class 2606 OID 17551)
-- Name: volumes fk_ijeqltjxlgxltsrdrygzzqgiaekdglzayjba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volumes
    ADD CONSTRAINT fk_ijeqltjxlgxltsrdrygzzqgiaekdglzayjba FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- TOC entry 4398 (class 2606 OID 17556)
-- Name: relations fk_jfeksulqfdslnpmddungigupphrvuvdmrsfn; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_jfeksulqfdslnpmddungigupphrvuvdmrsfn FOREIGN KEY ("sourceSiteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4403 (class 2606 OID 17561)
-- Name: sections_sites fk_kamsfgleoyuhjndbtdhvxvjbcokmtlglmawn; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections_sites
    ADD CONSTRAINT fk_kamsfgleoyuhjndbtdhvxvjbcokmtlglmawn FOREIGN KEY ("sectionId") REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- TOC entry 4412 (class 2606 OID 17566)
-- Name: tags fk_kcxjvsbicqxkkxdcowaoroysdhwapfwxgkpj; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT fk_kcxjvsbicqxkkxdcowaoroysdhwapfwxgkpj FOREIGN KEY ("groupId") REFERENCES public.taggroups(id) ON DELETE CASCADE;


--
-- TOC entry 4410 (class 2606 OID 17571)
-- Name: taggroups fk_keoxpzseiorfxllgseuxgxmwslhbayembhrk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.taggroups
    ADD CONSTRAINT fk_keoxpzseiorfxllgseuxgxmwslhbayembhrk FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- TOC entry 4368 (class 2606 OID 17576)
-- Name: entries fk_kgjjbfilryyjpgxwthrszqubszgzvcvcucgx; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_kgjjbfilryyjpgxwthrszqubszgzvcvcucgx FOREIGN KEY ("sectionId") REFERENCES public.sections(id) ON DELETE CASCADE;


--
-- TOC entry 4369 (class 2606 OID 17581)
-- Name: entries fk_kgtgxhxbkvczpdevtbyliplsvzbddesrjwhj; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_kgtgxhxbkvczpdevtbyliplsvzbddesrjwhj FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4389 (class 2606 OID 17586)
-- Name: matrixcontent_factscontentblocks fk_kmikzgvgqcnylulchxpnollbmrshetncnczf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_factscontentblocks
    ADD CONSTRAINT fk_kmikzgvgqcnylulchxpnollbmrshetncnczf FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4351 (class 2606 OID 17591)
-- Name: changedattributes fk_kqdcmaygxrbqenaibrsxifpblthmdvtoddhy; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changedattributes
    ADD CONSTRAINT fk_kqdcmaygxrbqenaibrsxifpblthmdvtoddhy FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4392 (class 2606 OID 17596)
-- Name: matrixcontent_poiastroobject fk_kvruazwauxpzaxvgjhmfdfzjxtqxyldmfkgi; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_poiastroobject
    ADD CONSTRAINT fk_kvruazwauxpzaxvgjhmfdfzjxtqxyldmfkgi FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4370 (class 2606 OID 17601)
-- Name: entries fk_myepbwawycrfseryfoeenlelcjjrabboeiba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_myepbwawycrfseryfoeenlelcjjrabboeiba FOREIGN KEY ("authorId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4430 (class 2606 OID 18010)
-- Name: announcements fk_nmnmaxjxbowmfbljuxfmjvumizvpeivrjygn; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT fk_nmnmaxjxbowmfbljuxfmjvumizvpeivrjygn FOREIGN KEY ("pluginId") REFERENCES public.plugins(id) ON DELETE CASCADE;


--
-- TOC entry 4423 (class 2606 OID 17606)
-- Name: userpreferences fk_nvdnlrjoxgtibyniomlscxndfzgrofhhwkyk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpreferences
    ADD CONSTRAINT fk_nvdnlrjoxgtibyniomlscxndfzgrofhhwkyk FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4425 (class 2606 OID 17611)
-- Name: users fk_nxffqauqqwhrrhjnespsyofevqqlwpnnplfq; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_nxffqauqqwhrrhjnespsyofevqqlwpnnplfq FOREIGN KEY ("photoId") REFERENCES public.assets(id) ON DELETE SET NULL;


--
-- TOC entry 4387 (class 2606 OID 17616)
-- Name: matrixblocktypes fk_nxpjahxiyspjualpicbxjriyfvzbpdcpthkz; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixblocktypes
    ADD CONSTRAINT fk_nxpjahxiyspjualpicbxjriyfvzbpdcpthkz FOREIGN KEY ("fieldId") REFERENCES public.fields(id) ON DELETE CASCADE;


--
-- TOC entry 4379 (class 2606 OID 17621)
-- Name: globalsets fk_nzuzfxncmaojysjehxlkexofdflkltwpxiks; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.globalsets
    ADD CONSTRAINT fk_nzuzfxncmaojysjehxlkexofdflkltwpxiks FOREIGN KEY ("fieldLayoutId") REFERENCES public.fieldlayouts(id) ON DELETE SET NULL;


--
-- TOC entry 4408 (class 2606 OID 17626)
-- Name: structureelements fk_oglcfvchxbliovjeouunigqnewaetyviilqa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structureelements
    ADD CONSTRAINT fk_oglcfvchxbliovjeouunigqnewaetyviilqa FOREIGN KEY ("structureId") REFERENCES public.structures(id) ON DELETE CASCADE;


--
-- TOC entry 4384 (class 2606 OID 17631)
-- Name: matrixblocks fk_pevbofdckhgqybzjjbfmnoiamgjbaknilpjx; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixblocks
    ADD CONSTRAINT fk_pevbofdckhgqybzjjbfmnoiamgjbaknilpjx FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4339 (class 2606 OID 17636)
-- Name: assets fk_pliaqhtmpxdcobtmuemgeczinaylamcmsjnw; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_pliaqhtmpxdcobtmuemgeczinaylamcmsjnw FOREIGN KEY ("folderId") REFERENCES public.volumefolders(id) ON DELETE CASCADE;


--
-- TOC entry 4375 (class 2606 OID 17641)
-- Name: fieldlayoutfields fk_prwczdkhxoskdsmjmuuikwkkcxoxdkqqzpei; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldlayoutfields
    ADD CONSTRAINT fk_prwczdkhxoskdsmjmuuikwkkcxoxdkqqzpei FOREIGN KEY ("tabId") REFERENCES public.fieldlayouttabs(id) ON DELETE CASCADE;


--
-- TOC entry 4426 (class 2606 OID 17646)
-- Name: volumefolders fk_qifhwkhhqhjvptudynzkavzfxuwcexqxsfjr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volumefolders
    ADD CONSTRAINT fk_qifhwkhhqhjvptudynzkavzfxuwcexqxsfjr FOREIGN KEY ("volumeId") REFERENCES public.volumes(id) ON DELETE CASCADE;


--
-- TOC entry 4416 (class 2606 OID 17651)
-- Name: templatecaches fk_qmbduzqhpbnsalyrmsejnulqgtscakxaepqm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templatecaches
    ADD CONSTRAINT fk_qmbduzqhpbnsalyrmsejnulqgtscakxaepqm FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4366 (class 2606 OID 17656)
-- Name: elements_sites fk_qulxgorjhbrrkxryqiydqoszksyyhmapfclm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elements_sites
    ADD CONSTRAINT fk_qulxgorjhbrrkxryqiydqoszksyyhmapfclm FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4427 (class 2606 OID 17661)
-- Name: volumefolders fk_qwnetumldqouglypoexfxvvqecnqdtltdenw; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.volumefolders
    ADD CONSTRAINT fk_qwnetumldqouglypoexfxvvqecnqdtltdenw FOREIGN KEY ("parentId") REFERENCES public.volumefolders(id) ON DELETE CASCADE;


--
-- TOC entry 4415 (class 2606 OID 17666)
-- Name: templatecachequeries fk_rssrrjnxgojeloqdytmgqqjpbzkyekvdmgtu; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templatecachequeries
    ADD CONSTRAINT fk_rssrrjnxgojeloqdytmgqqjpbzkyekvdmgtu FOREIGN KEY ("cacheId") REFERENCES public.templatecaches(id) ON DELETE CASCADE;


--
-- TOC entry 4406 (class 2606 OID 17671)
-- Name: shunnedmessages fk_salqvlhiukuadtjrkdpoqpadgxyxwfgswbvp; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shunnedmessages
    ADD CONSTRAINT fk_salqvlhiukuadtjrkdpoqpadgxyxwfgswbvp FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4404 (class 2606 OID 17676)
-- Name: sections_sites fk_sapdvsolxaeqxpjsofzhhbhhsinkwfebvrke; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections_sites
    ADD CONSTRAINT fk_sapdvsolxaeqxpjsofzhhbhhsinkwfebvrke FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4429 (class 2606 OID 17681)
-- Name: widgets fk_ssooxbzzpxuzcksmvdzdewhxtdzevncbfnnb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.widgets
    ADD CONSTRAINT fk_ssooxbzzpxuzcksmvdzdewhxtdzevncbfnnb FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4409 (class 2606 OID 17686)
-- Name: structureelements fk_tcrgzpgjihvbacgyeifolwlpmmicfcadjdxk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structureelements
    ADD CONSTRAINT fk_tcrgzpgjihvbacgyeifolwlpmmicfcadjdxk FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4354 (class 2606 OID 17691)
-- Name: changedfields fk_ttzvlzzvlpywtkzakiotqbvtbaedcohjpwzc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changedfields
    ADD CONSTRAINT fk_ttzvlzzvlpywtkzakiotqbvtbaedcohjpwzc FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4393 (class 2606 OID 17696)
-- Name: matrixcontent_poiastroobject fk_udxciptpcidijvsffsmncslrhqjdhhikftah; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_poiastroobject
    ADD CONSTRAINT fk_udxciptpcidijvsffsmncslrhqjdhhikftah FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4357 (class 2606 OID 17701)
-- Name: content fk_uhpbzxedulgcilqpceuecavtiiirrtbvhcsq; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.content
    ADD CONSTRAINT fk_uhpbzxedulgcilqpceuecavtiiirrtbvhcsq FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4395 (class 2606 OID 17706)
-- Name: matrixcontent_tourpois fk_usleqcymxjqtvhiuvkjkojxmoiketyntmcjo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_tourpois
    ADD CONSTRAINT fk_usleqcymxjqtvhiuvkjkojxmoiketyntmcjo FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4420 (class 2606 OID 17711)
-- Name: userpermissions_usergroups fk_uvipnepqohqvckydpoffratpsojuevuglwks; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.userpermissions_usergroups
    ADD CONSTRAINT fk_uvipnepqohqvckydpoffratpsojuevuglwks FOREIGN KEY ("groupId") REFERENCES public.usergroups(id) ON DELETE CASCADE;


--
-- TOC entry 4363 (class 2606 OID 17716)
-- Name: elements fk_uxksfnwvglvkmkhhombxfrqazqkjgectxhvc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.elements
    ADD CONSTRAINT fk_uxksfnwvglvkmkhhombxfrqazqkjgectxhvc FOREIGN KEY ("draftId") REFERENCES public.drafts(id) ON DELETE CASCADE;


--
-- TOC entry 4414 (class 2606 OID 17721)
-- Name: templatecacheelements fk_vbjbessmrosfylraudllwxtufzehmjhhudbj; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.templatecacheelements
    ADD CONSTRAINT fk_vbjbessmrosfylraudllwxtufzehmjhhudbj FOREIGN KEY ("cacheId") REFERENCES public.templatecaches(id) ON DELETE CASCADE;


--
-- TOC entry 4371 (class 2606 OID 17726)
-- Name: entries fk_vfdogasytasksaavoaupnedeivxvzdyjrfbg; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT fk_vfdogasytasksaavoaupnedeivxvzdyjrfbg FOREIGN KEY ("parentId") REFERENCES public.entries(id) ON DELETE SET NULL;


--
-- TOC entry 4344 (class 2606 OID 17731)
-- Name: categories fk_vogfdrxhlwzawqhxmlipsoaepvqlbboaweoi; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT fk_vogfdrxhlwzawqhxmlipsoaepvqlbboaweoi FOREIGN KEY ("parentId") REFERENCES public.categories(id) ON DELETE SET NULL;


--
-- TOC entry 4340 (class 2606 OID 17736)
-- Name: assets fk_vqvjysrngzlhivsudijmrbnnlxvjrvbwsklv; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_vqvjysrngzlhivsudijmrbnnlxvjrvbwsklv FOREIGN KEY ("volumeId") REFERENCES public.volumes(id) ON DELETE CASCADE;


--
-- TOC entry 4380 (class 2606 OID 17741)
-- Name: globalsets fk_vtlhnmgkgflbatxapriuhfjhczeqesirbqam; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.globalsets
    ADD CONSTRAINT fk_vtlhnmgkgflbatxapriuhfjhczeqesirbqam FOREIGN KEY (id) REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4360 (class 2606 OID 17746)
-- Name: drafts fk_wgkdcxubcosrjalbbrbcbtjzvkqlzkvlcnwg; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.drafts
    ADD CONSTRAINT fk_wgkdcxubcosrjalbbrbcbtjzvkqlzkvlcnwg FOREIGN KEY ("sourceId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4431 (class 2606 OID 18005)
-- Name: announcements fk_wkstljofyoqxsexdnxzjpllgthcapeztsnbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT fk_wkstljofyoqxsexdnxzjpllgthcapeztsnbd FOREIGN KEY ("userId") REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 4355 (class 2606 OID 17751)
-- Name: changedfields fk_wwecvotqkkkvetdmsqkoeisqdtoilmutjmok; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.changedfields
    ADD CONSTRAINT fk_wwecvotqkkkvetdmsqkoeisqdtoilmutjmok FOREIGN KEY ("elementId") REFERENCES public.elements(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4341 (class 2606 OID 17756)
-- Name: assets fk_wxxpowhecgzxdomankczvkhvlpkiqxmcpgnm; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT fk_wxxpowhecgzxdomankczvkhvlpkiqxmcpgnm FOREIGN KEY ("uploaderId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4391 (class 2606 OID 17761)
-- Name: matrixcontent_introcontentblocks fk_xgdhevoybwjapvtavhnddtdzajxmbbncevlj; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixcontent_introcontentblocks
    ADD CONSTRAINT fk_xgdhevoybwjapvtavhnddtdzajxmbbncevlj FOREIGN KEY ("siteId") REFERENCES public.sites(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4399 (class 2606 OID 17766)
-- Name: relations fk_xsxmugogqbsskvakqzkeoyrwtnzibejqchky; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.relations
    ADD CONSTRAINT fk_xsxmugogqbsskvakqzkeoyrwtnzibejqchky FOREIGN KEY ("sourceId") REFERENCES public.elements(id) ON DELETE CASCADE;


--
-- TOC entry 4402 (class 2606 OID 17771)
-- Name: sections fk_yfwjnmvmyksxuiylfyystjetqpyjrijaosbl; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT fk_yfwjnmvmyksxuiylfyystjetqpyjrijaosbl FOREIGN KEY ("structureId") REFERENCES public.structures(id) ON DELETE SET NULL;


--
-- TOC entry 4376 (class 2606 OID 17776)
-- Name: fieldlayoutfields fk_yretsbatlsvddfusomhjctpsiqticzuqhqjr; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fieldlayoutfields
    ADD CONSTRAINT fk_yretsbatlsvddfusomhjctpsiqticzuqhqjr FOREIGN KEY ("layoutId") REFERENCES public.fieldlayouts(id) ON DELETE CASCADE;


--
-- TOC entry 4337 (class 2606 OID 17781)
-- Name: assetindexdata fk_yrnoyuydmxlmlydmcxmwcqwrsqmreeeiywtq; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.assetindexdata
    ADD CONSTRAINT fk_yrnoyuydmxlmlydmcxmwcqwrsqmreeeiywtq FOREIGN KEY ("volumeId") REFERENCES public.volumes(id) ON DELETE CASCADE;


--
-- TOC entry 4401 (class 2606 OID 17786)
-- Name: revisions fk_ysabcqjrntaviyfxmufksdighinpjuplkgvs; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.revisions
    ADD CONSTRAINT fk_ysabcqjrntaviyfxmufksdighinpjuplkgvs FOREIGN KEY ("creatorId") REFERENCES public.users(id) ON DELETE SET NULL;


--
-- TOC entry 4418 (class 2606 OID 17791)
-- Name: usergroups_users fk_ywabfwubrrvwmfqkbtqdntpssdsrndpbgfkh; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.usergroups_users
    ADD CONSTRAINT fk_ywabfwubrrvwmfqkbtqdntpssdsrndpbgfkh FOREIGN KEY ("groupId") REFERENCES public.usergroups(id) ON DELETE CASCADE;


--
-- TOC entry 4385 (class 2606 OID 17796)
-- Name: matrixblocks fk_ziuwxjfdaktbzbjffckkspykcokzjsvtezpt; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.matrixblocks
    ADD CONSTRAINT fk_ziuwxjfdaktbzbjffckkspykcokzjsvtezpt FOREIGN KEY ("typeId") REFERENCES public.matrixblocktypes(id) ON DELETE CASCADE;


-- Completed on 2021-10-27 16:08:11 MST

--
-- PostgreSQL database dump complete
--

