CREATE TABLE profiles (
  id uuid NOT NULL,
  name text DEFAULT 'ユーザーネーム未定' :: text,
  image_url text DEFAULT 'https://inngzyruhkuljrsvujfw.supabase.co/storage/v1/object/public/images/no-images.png' :: text,
  email text NOT NULL,
  created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc' :: text),
  comment text DEFAULT 'コメントを入力してください' :: text
);

CREATE TABLE idols (
  id bigint NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  name character varying NOT NULL,
  color character varying NOT NULL,
  image_url text,
  group_id bigint,
  birthday character varying,
  height bigint,
  hometown character varying,
  debut_year bigint,
  comment text,
  official_url text,
  twitter_url text,
  instagram_url text,
  birth_year bigint,
  other_url text
);