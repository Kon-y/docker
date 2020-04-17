CREATE TABLE public.centerinfo
(
   centerid text NOT NULL,
   publicurl text NOT NULL,
   user text NOT NULL,
   pw text NOT NULL,
   PRIMARY KEY (centerid)
)
WITH (
   OIDS = FALSE
);

INSERT INTO centerinfo VALUES ('MAC', 'https://daichan.club', 'testuser', '+testpass==');
