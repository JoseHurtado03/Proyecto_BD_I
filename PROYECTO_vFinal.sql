PGDMP     3    8                {            Proyecto2_v29    15.3    15.3 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    25657    Proyecto2_v29    DATABASE     �   CREATE DATABASE "Proyecto2_v29" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Venezuela.1252';
    DROP DATABASE "Proyecto2_v29";
                postgres    false                        2615    25658    starwars    SCHEMA        CREATE SCHEMA starwars;
    DROP SCHEMA starwars;
                postgres    false            g           1247    25660 	   dom_dieta    DOMAIN     q  CREATE DOMAIN public.dom_dieta AS character varying NOT NULL
	CONSTRAINT dom_dieta_check CHECK (((VALUE)::text = ANY (ARRAY[('Herbivoro'::character varying)::text, ('Carnivoro'::character varying)::text, ('Omnivero'::character varying)::text, ('Carroñero'::character varying)::text, ('Geofagos'::character varying)::text, ('Electrofago'::character varying)::text])));
    DROP DOMAIN public.dom_dieta;
       public          postgres    false            k           1247    25663    dom_tipo_nave    DOMAIN       CREATE DOMAIN public.dom_tipo_nave AS character varying NOT NULL
	CONSTRAINT dom_tipo_nave_check CHECK (((VALUE)::text = ANY (ARRAY[('Carga'::character varying)::text, ('Combate'::character varying)::text, ('Contrabando'::character varying)::text, ('Otro'::character varying)::text])));
 "   DROP DOMAIN public.dom_tipo_nave;
       public          postgres    false            o           1247    25666    dom_tipo_pelicula    DOMAIN       CREATE DOMAIN public.dom_tipo_pelicula AS character varying NOT NULL
	CONSTRAINT dom_tipo_pelicula_check CHECK (((VALUE)::text = ANY (ARRAY[('Live action'::character varying)::text, ('Animada'::character varying)::text, ('Otro'::character varying)::text])));
 &   DROP DOMAIN public.dom_tipo_pelicula;
       public          postgres    false            s           1247    25669 	   dom_dieta    DOMAIN     s  CREATE DOMAIN starwars.dom_dieta AS character varying NOT NULL
	CONSTRAINT dom_dieta_check CHECK (((VALUE)::text = ANY (ARRAY[('Herbivoro'::character varying)::text, ('Carnivoro'::character varying)::text, ('Omnivero'::character varying)::text, ('Carroñero'::character varying)::text, ('Geofagos'::character varying)::text, ('Electrofago'::character varying)::text])));
     DROP DOMAIN starwars.dom_dieta;
       starwars          postgres    false    6            w           1247    25672 
   dom_genero    DOMAIN     ,  CREATE DOMAIN starwars.dom_genero AS character varying NOT NULL DEFAULT 'Desc'::character varying
	CONSTRAINT dom_genero_check CHECK (((VALUE)::text = ANY (ARRAY[('M'::character varying)::text, ('F'::character varying)::text, ('Desc'::character varying)::text, ('Otro'::character varying)::text])));
 !   DROP DOMAIN starwars.dom_genero;
       starwars          postgres    false    6            {           1247    25675    dom_tipoactor    DOMAIN     �   CREATE DOMAIN starwars.dom_tipoactor AS character varying NOT NULL
	CONSTRAINT dom_tipoactor_check CHECK (((VALUE)::text = ANY (ARRAY[('Interpreta'::character varying)::text, ('Presta su voz'::character varying)::text])));
 $   DROP DOMAIN starwars.dom_tipoactor;
       starwars          postgres    false    6            �            1255    25986    actualizar_ganancia()    FUNCTION     �   CREATE FUNCTION public.actualizar_ganancia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.ganancia = NEW.ingreso_taquilla - NEW.coste_prod;
  RETURN NEW;
END;
$$;
 ,   DROP FUNCTION public.actualizar_ganancia();
       public          postgres    false            �            1255    25677    validar_especie()    FUNCTION       CREATE FUNCTION public.validar_especie() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF not ((NEW.nombre_especie_h is not null and NEW.nombre_especie_c is null and NEW.nombre_especie_r is null) or (NEW.nombre_especie_h is null and NEW.nombre_especie_c is not null and NEW.nombre_especie_r is null) or (NEW.nombre_especie_h is null and NEW.nombre_especie_c is null and NEW.nombre_especie_r is not null))  THEN
        RAISE EXCEPTION 'El personaje debe tener sólo un tipo de especie';
    END IF;

    RETURN NEW;
END;
$$;
 (   DROP FUNCTION public.validar_especie();
       public          postgres    false            �            1255    25678    validar_fechas_nm()    FUNCTION       CREATE FUNCTION public.validar_fechas_nm() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.fecha_nacimiento>new.fecha_muerte THEN
        RAISE EXCEPTION 'El valor de la fecha de nacimiento no puede ser mayor a la fecha de muerte';
    END IF;

    RETURN NEW;
END;
$$;
 *   DROP FUNCTION public.validar_fechas_nm();
       public          postgres    false            �            1255    25679    validar_ganancia()    FUNCTION       CREATE FUNCTION public.validar_ganancia() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.ingreso_taquilla<new.coste_prod THEN
        RAISE EXCEPTION 'El ingreso de la taquilla no puede ser menor al coste de producción';
    END IF;

    RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.validar_ganancia();
       public          postgres    false            �            1255    25680    validar_robot()    FUNCTION     �  CREATE FUNCTION public.validar_robot() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.nombre_especie_r IN (SELECT nombre_especie_robot FROM starwars.robot) THEN
        IF (NEW.creador IS NULL) THEN
            RAISE EXCEPTION 'El valor del creador no puede ser nulo cuando el valor especial es %', NEW.nombre_especie_r;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;
 &   DROP FUNCTION public.validar_robot();
       public          postgres    false            �            1255    25681    validar_valores()    FUNCTION     �  CREATE FUNCTION public.validar_valores() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.nombre_especie_h IN (SELECT nombre_especie_humanoide FROM starwars.humanoide) THEN
        IF (NEW.fecha_nacimiento IS NULL) THEN
            RAISE EXCEPTION 'El valor de la fecha de nacimiento no puede ser nulo cuando el valor especial es %', NEW.nombre_especie_h;
        END IF;
    END IF;
	
	IF NEW.nombre_especie_h is null and NEW.fecha_muerte Is not NULL THEN
       	 RAISE EXCEPTION 'El valor de la fecha de muerte no puede ser llenado cuando la especie no es parte de la tabla Humanoide';
    END IF;

    RETURN NEW;
END;
$$;
 (   DROP FUNCTION public.validar_valores();
       public          postgres    false            �            1255    25682    verificar_destructor_estelar()    FUNCTION     �  CREATE FUNCTION public.verificar_destructor_estelar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.nombre_nave = 'Destructor Estelar' THEN
        IF NEW.longitud < 900 OR NEW.uso <> 'Combate' THEN
            RAISE EXCEPTION 'Un Destructor Estelar debe tener una longitud mayor o igual a 900 y un uso de Combate.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;
 5   DROP FUNCTION public.verificar_destructor_estelar();
       public          postgres    false            �            1259    25683    criatura    TABLE     �   CREATE TABLE public.criatura (
    nombre_especie_criatura character varying(100) NOT NULL,
    color_piel character varying(100),
    dieta public.dom_dieta NOT NULL
);
    DROP TABLE public.criatura;
       public         heap    postgres    false    871            �            1259    25688    ejemplo    TABLE     S   CREATE TABLE public.ejemplo (
    id integer,
    nombre character varying(255)
);
    DROP TABLE public.ejemplo;
       public         heap    postgres    false            �            1259    25691    especie    TABLE     w   CREATE TABLE public.especie (
    nombre_especie character varying(100) NOT NULL,
    idioma character varying(100)
);
    DROP TABLE public.especie;
       public         heap    postgres    false            �            1259    25694    robot    TABLE     �   CREATE TABLE public.robot (
    nombre_especie_robot character varying(100) NOT NULL,
    clase character varying(100),
    creador character varying(100)
);
    DROP TABLE public.robot;
       public         heap    postgres    false            �            1259    25697    actor    TABLE     �   CREATE TABLE starwars.actor (
    nombre_actor character varying(100) NOT NULL,
    fecha_nacimiento date,
    nacionalidad character varying(100),
    tipo starwars.dom_tipoactor NOT NULL,
    genero starwars.dom_genero NOT NULL
);
    DROP TABLE starwars.actor;
       starwars         heap    postgres    false    887    6    891            �            1259    25702 
   afiliacion    TABLE     �   CREATE TABLE starwars.afiliacion (
    nombre_afiliacion character varying(20) NOT NULL,
    tipo character varying(25) NOT NULL
);
     DROP TABLE starwars.afiliacion;
       starwars         heap    postgres    false    6            �            1259    25705    afiliado    TABLE     �   CREATE TABLE starwars.afiliado (
    nombre_afi character varying(100) NOT NULL,
    nombre_personaje_afi character varying(100) NOT NULL,
    fecha_afi date NOT NULL
);
    DROP TABLE starwars.afiliado;
       starwars         heap    postgres    false    6            �            1259    25708    aparece    TABLE     y   CREATE TABLE starwars.aparece (
    nombre_personajea character varying(100) NOT NULL,
    id_medioa integer NOT NULL
);
    DROP TABLE starwars.aparece;
       starwars         heap    postgres    false    6            �            1259    25711    ciudad    TABLE     �   CREATE TABLE starwars.ciudad (
    nombre_ciudad character varying(20) NOT NULL,
    nombre_planeta character varying(20) NOT NULL
);
    DROP TABLE starwars.ciudad;
       starwars         heap    postgres    false    6            �            1259    25714    combate    TABLE     �   CREATE TABLE starwars.combate (
    participante_uno character varying(20) NOT NULL,
    participante_dos character varying(20) NOT NULL,
    lugar character varying(30),
    id_medio integer NOT NULL,
    fecha_comb date NOT NULL
);
    DROP TABLE starwars.combate;
       starwars         heap    postgres    false    6            �            1259    25717    criatura    TABLE     �   CREATE TABLE starwars.criatura (
    nombre_especie_criatura character varying(100) NOT NULL,
    color_piel character varying(100),
    dieta starwars.dom_dieta NOT NULL,
    idioma character varying(25)
);
    DROP TABLE starwars.criatura;
       starwars         heap    postgres    false    883    6            �            1259    25722    dueno    TABLE     �   CREATE TABLE starwars.dueno (
    nombre_personajed character varying(100) NOT NULL,
    fecha_comprad date NOT NULL,
    id_naved integer NOT NULL
);
    DROP TABLE starwars.dueno;
       starwars         heap    postgres    false    6            �            1259    25725 	   humanoide    TABLE     �   CREATE TABLE starwars.humanoide (
    nombre_especie_humanoide character varying(100) NOT NULL,
    idioma character varying(25)
);
    DROP TABLE starwars.humanoide;
       starwars         heap    postgres    false    6            �            1259    25728    idiomas    TABLE     �   CREATE TABLE starwars.idiomas (
    nombre_planeta character varying(100) NOT NULL,
    idioma character varying(100) NOT NULL
);
    DROP TABLE starwars.idiomas;
       starwars         heap    postgres    false    6            �            1259    25731    interpretado    TABLE     �   CREATE TABLE starwars.interpretado (
    nombre_personajei character varying(100) NOT NULL,
    nombre_actori character varying(100) NOT NULL,
    id_medioi integer NOT NULL
);
 "   DROP TABLE starwars.interpretado;
       starwars         heap    postgres    false    6            �            1259    25734    lugar_interes    TABLE     �   CREATE TABLE starwars.lugar_interes (
    nombre_ciudad character varying(25) NOT NULL,
    lugar character varying(30) NOT NULL
);
 #   DROP TABLE starwars.lugar_interes;
       starwars         heap    postgres    false    6            �            1259    25737    medio    TABLE     �   CREATE TABLE starwars.medio (
    id_medio integer NOT NULL,
    titulo character varying(100),
    fecha_estreno date,
    rating integer,
    sinopsis character varying(250),
    CONSTRAINT rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);
    DROP TABLE starwars.medio;
       starwars         heap    postgres    false    6            �            1259    25741    nave    TABLE     �   CREATE TABLE starwars.nave (
    id_nave integer NOT NULL,
    nombre_nave character varying(100),
    fabricante character varying(100),
    longitud integer,
    uso public.dom_tipo_nave,
    modelo character varying(100)
);
    DROP TABLE starwars.nave;
       starwars         heap    postgres    false    6    875            �            1259    25746    pelicula    TABLE     '  CREATE TABLE starwars.pelicula (
    id_medio_pelicula integer NOT NULL,
    director character varying(100),
    duracion integer,
    distribuidor character varying(100),
    tipo_pelicula public.dom_tipo_pelicula,
    coste_prod integer,
    ingreso_taquilla integer,
    ganancia integer
);
    DROP TABLE starwars.pelicula;
       starwars         heap    postgres    false    879    6            �            1259    25751 	   personaje    TABLE     �  CREATE TABLE starwars.personaje (
    nombre_personaje character varying(100) NOT NULL,
    altura double precision,
    peso integer,
    nombreplanetap character varying(100),
    fecha_nacimiento date,
    fecha_muerte date,
    nombre_especie_r character varying,
    nombre_especie_h character varying,
    nombre_especie_c character varying,
    creador character varying(100),
    genero starwars.dom_genero DEFAULT 'Desc'::character varying NOT NULL
);
    DROP TABLE starwars.personaje;
       starwars         heap    postgres    false    887    887    6            �            1259    25757    planeta    TABLE     �   CREATE TABLE starwars.planeta (
    nombre_planeta character varying(100) NOT NULL,
    sistema_solar character varying(100),
    sector character varying(100),
    clima character varying(100)
);
    DROP TABLE starwars.planeta;
       starwars         heap    postgres    false    6            �            1259    25760    plataformas_disp    TABLE     �   CREATE TABLE starwars.plataformas_disp (
    id_medio_videojuegop integer NOT NULL,
    plataforma character varying(100) NOT NULL
);
 &   DROP TABLE starwars.plataformas_disp;
       starwars         heap    postgres    false    6            �            1259    25763    robot    TABLE     �   CREATE TABLE starwars.robot (
    nombre_especie_robot character varying(100) NOT NULL,
    clase character varying(100),
    idioma character varying(25)
);
    DROP TABLE starwars.robot;
       starwars         heap    postgres    false    6            �            1259    25766    sede    TABLE     ~   CREATE TABLE starwars.sede (
    nombre_af character varying(100) NOT NULL,
    nombre_pla character varying(100) NOT NULL
);
    DROP TABLE starwars.sede;
       starwars         heap    postgres    false    6            �            1259    25769    serie    TABLE     �   CREATE TABLE starwars.serie (
    id_medio_serie integer NOT NULL,
    creador character varying(100),
    canal character varying(100),
    tipo_serie character varying(100),
    total_epi integer
);
    DROP TABLE starwars.serie;
       starwars         heap    postgres    false    6            �            1259    25772    tripula    TABLE     �   CREATE TABLE starwars.tripula (
    nombre_personajet character varying(100) NOT NULL,
    id_navet integer NOT NULL,
    tipo_tripulacion character varying(100)
);
    DROP TABLE starwars.tripula;
       starwars         heap    postgres    false    6            �            1259    25775 
   videojuego    TABLE     �   CREATE TABLE starwars.videojuego (
    id_medio_videojuego integer NOT NULL,
    "compañía" character varying(100),
    tipo_juego character varying(20)
);
     DROP TABLE starwars.videojuego;
       starwars         heap    postgres    false    6            �          0    25683    criatura 
   TABLE DATA           N   COPY public.criatura (nombre_especie_criatura, color_piel, dieta) FROM stdin;
    public          postgres    false    215   �       �          0    25688    ejemplo 
   TABLE DATA           -   COPY public.ejemplo (id, nombre) FROM stdin;
    public          postgres    false    216   -�       �          0    25691    especie 
   TABLE DATA           9   COPY public.especie (nombre_especie, idioma) FROM stdin;
    public          postgres    false    217   J�       �          0    25694    robot 
   TABLE DATA           E   COPY public.robot (nombre_especie_robot, clase, creador) FROM stdin;
    public          postgres    false    218   w�       �          0    25697    actor 
   TABLE DATA           ]   COPY starwars.actor (nombre_actor, fecha_nacimiento, nacionalidad, tipo, genero) FROM stdin;
    starwars          postgres    false    219   ��       �          0    25702 
   afiliacion 
   TABLE DATA           ?   COPY starwars.afiliacion (nombre_afiliacion, tipo) FROM stdin;
    starwars          postgres    false    220   ��       �          0    25705    afiliado 
   TABLE DATA           Q   COPY starwars.afiliado (nombre_afi, nombre_personaje_afi, fecha_afi) FROM stdin;
    starwars          postgres    false    221   S�       �          0    25708    aparece 
   TABLE DATA           A   COPY starwars.aparece (nombre_personajea, id_medioa) FROM stdin;
    starwars          postgres    false    222   ��       �          0    25711    ciudad 
   TABLE DATA           A   COPY starwars.ciudad (nombre_ciudad, nombre_planeta) FROM stdin;
    starwars          postgres    false    223   ��       �          0    25714    combate 
   TABLE DATA           d   COPY starwars.combate (participante_uno, participante_dos, lugar, id_medio, fecha_comb) FROM stdin;
    starwars          postgres    false    224   &�       �          0    25717    criatura 
   TABLE DATA           X   COPY starwars.criatura (nombre_especie_criatura, color_piel, dieta, idioma) FROM stdin;
    starwars          postgres    false    225   	�       �          0    25722    dueno 
   TABLE DATA           M   COPY starwars.dueno (nombre_personajed, fecha_comprad, id_naved) FROM stdin;
    starwars          postgres    false    226   e�       �          0    25725 	   humanoide 
   TABLE DATA           G   COPY starwars.humanoide (nombre_especie_humanoide, idioma) FROM stdin;
    starwars          postgres    false    227   ��       �          0    25728    idiomas 
   TABLE DATA           ;   COPY starwars.idiomas (nombre_planeta, idioma) FROM stdin;
    starwars          postgres    false    228   :�       �          0    25731    interpretado 
   TABLE DATA           U   COPY starwars.interpretado (nombre_personajei, nombre_actori, id_medioi) FROM stdin;
    starwars          postgres    false    229   ��       �          0    25734    lugar_interes 
   TABLE DATA           ?   COPY starwars.lugar_interes (nombre_ciudad, lugar) FROM stdin;
    starwars          postgres    false    230   x�       �          0    25737    medio 
   TABLE DATA           T   COPY starwars.medio (id_medio, titulo, fecha_estreno, rating, sinopsis) FROM stdin;
    starwars          postgres    false    231   ��       �          0    25741    nave 
   TABLE DATA           Y   COPY starwars.nave (id_nave, nombre_nave, fabricante, longitud, uso, modelo) FROM stdin;
    starwars          postgres    false    232   ��       �          0    25746    pelicula 
   TABLE DATA           �   COPY starwars.pelicula (id_medio_pelicula, director, duracion, distribuidor, tipo_pelicula, coste_prod, ingreso_taquilla, ganancia) FROM stdin;
    starwars          postgres    false    233   Y�       �          0    25751 	   personaje 
   TABLE DATA           �   COPY starwars.personaje (nombre_personaje, altura, peso, nombreplanetap, fecha_nacimiento, fecha_muerte, nombre_especie_r, nombre_especie_h, nombre_especie_c, creador, genero) FROM stdin;
    starwars          postgres    false    234   `�       �          0    25757    planeta 
   TABLE DATA           Q   COPY starwars.planeta (nombre_planeta, sistema_solar, sector, clima) FROM stdin;
    starwars          postgres    false    235   ��       �          0    25760    plataformas_disp 
   TABLE DATA           N   COPY starwars.plataformas_disp (id_medio_videojuegop, plataforma) FROM stdin;
    starwars          postgres    false    236   
�       �          0    25763    robot 
   TABLE DATA           F   COPY starwars.robot (nombre_especie_robot, clase, idioma) FROM stdin;
    starwars          postgres    false    237   t�       �          0    25766    sede 
   TABLE DATA           7   COPY starwars.sede (nombre_af, nombre_pla) FROM stdin;
    starwars          postgres    false    238   ��       �          0    25769    serie 
   TABLE DATA           X   COPY starwars.serie (id_medio_serie, creador, canal, tipo_serie, total_epi) FROM stdin;
    starwars          postgres    false    239   \�       �          0    25772    tripula 
   TABLE DATA           R   COPY starwars.tripula (nombre_personajet, id_navet, tipo_tripulacion) FROM stdin;
    starwars          postgres    false    240   ?�       �          0    25775 
   videojuego 
   TABLE DATA           U   COPY starwars.videojuego (id_medio_videojuego, "compañía", tipo_juego) FROM stdin;
    starwars          postgres    false    241   ��       �           2606    25779    criatura criatura_dieta_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.criatura
    ADD CONSTRAINT criatura_dieta_key UNIQUE (dieta);
 E   ALTER TABLE ONLY public.criatura DROP CONSTRAINT criatura_dieta_key;
       public            postgres    false    215            �           2606    25781    criatura criatura_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.criatura
    ADD CONSTRAINT criatura_pkey PRIMARY KEY (nombre_especie_criatura);
 @   ALTER TABLE ONLY public.criatura DROP CONSTRAINT criatura_pkey;
       public            postgres    false    215            �           2606    25783    especie especie_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.especie
    ADD CONSTRAINT especie_pkey PRIMARY KEY (nombre_especie);
 >   ALTER TABLE ONLY public.especie DROP CONSTRAINT especie_pkey;
       public            postgres    false    217            �           2606    25785    robot robot_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.robot
    ADD CONSTRAINT robot_pkey PRIMARY KEY (nombre_especie_robot);
 :   ALTER TABLE ONLY public.robot DROP CONSTRAINT robot_pkey;
       public            postgres    false    218            �           2606    25787    actor actor_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY starwars.actor
    ADD CONSTRAINT actor_pkey PRIMARY KEY (nombre_actor);
 <   ALTER TABLE ONLY starwars.actor DROP CONSTRAINT actor_pkey;
       starwars            postgres    false    219            �           2606    25789    afiliacion afiliacion_pk 
   CONSTRAINT     g   ALTER TABLE ONLY starwars.afiliacion
    ADD CONSTRAINT afiliacion_pk PRIMARY KEY (nombre_afiliacion);
 D   ALTER TABLE ONLY starwars.afiliacion DROP CONSTRAINT afiliacion_pk;
       starwars            postgres    false    220            �           2606    25791    afiliado afiliado_pkey 
   CONSTRAINT        ALTER TABLE ONLY starwars.afiliado
    ADD CONSTRAINT afiliado_pkey PRIMARY KEY (nombre_afi, nombre_personaje_afi, fecha_afi);
 B   ALTER TABLE ONLY starwars.afiliado DROP CONSTRAINT afiliado_pkey;
       starwars            postgres    false    221    221    221            �           2606    25793    aparece aparece_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY starwars.aparece
    ADD CONSTRAINT aparece_pkey PRIMARY KEY (id_medioa, nombre_personajea);
 @   ALTER TABLE ONLY starwars.aparece DROP CONSTRAINT aparece_pkey;
       starwars            postgres    false    222    222            �           2606    25795    ciudad ciudad_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY starwars.ciudad
    ADD CONSTRAINT ciudad_pkey PRIMARY KEY (nombre_ciudad);
 >   ALTER TABLE ONLY starwars.ciudad DROP CONSTRAINT ciudad_pkey;
       starwars            postgres    false    223                       2606    25797    combate combate_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY starwars.combate
    ADD CONSTRAINT combate_pkey PRIMARY KEY (participante_uno, participante_dos, id_medio, fecha_comb);
 @   ALTER TABLE ONLY starwars.combate DROP CONSTRAINT combate_pkey;
       starwars            postgres    false    224    224    224    224                       2606    25799    criatura criatura_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY starwars.criatura
    ADD CONSTRAINT criatura_pkey PRIMARY KEY (nombre_especie_criatura);
 B   ALTER TABLE ONLY starwars.criatura DROP CONSTRAINT criatura_pkey;
       starwars            postgres    false    225                       2606    25801    dueno dueno_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY starwars.dueno
    ADD CONSTRAINT dueno_pkey PRIMARY KEY (nombre_personajed, fecha_comprad, id_naved);
 <   ALTER TABLE ONLY starwars.dueno DROP CONSTRAINT dueno_pkey;
       starwars            postgres    false    226    226    226                       2606    25803    humanoide humano_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY starwars.humanoide
    ADD CONSTRAINT humano_pkey PRIMARY KEY (nombre_especie_humanoide);
 A   ALTER TABLE ONLY starwars.humanoide DROP CONSTRAINT humano_pkey;
       starwars            postgres    false    227            	           2606    25805    idiomas idiomas_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY starwars.idiomas
    ADD CONSTRAINT idiomas_pkey PRIMARY KEY (nombre_planeta, idioma);
 @   ALTER TABLE ONLY starwars.idiomas DROP CONSTRAINT idiomas_pkey;
       starwars            postgres    false    228    228                       2606    25807    interpretado interpretado_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY starwars.interpretado
    ADD CONSTRAINT interpretado_pkey PRIMARY KEY (id_medioi, nombre_actori, nombre_personajei);
 J   ALTER TABLE ONLY starwars.interpretado DROP CONSTRAINT interpretado_pkey;
       starwars            postgres    false    229    229    229                       2606    25809 %   lugar_interes lugar_interes_lugar_key 
   CONSTRAINT     c   ALTER TABLE ONLY starwars.lugar_interes
    ADD CONSTRAINT lugar_interes_lugar_key UNIQUE (lugar);
 Q   ALTER TABLE ONLY starwars.lugar_interes DROP CONSTRAINT lugar_interes_lugar_key;
       starwars            postgres    false    230                       2606    25811     lugar_interes lugar_interes_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY starwars.lugar_interes
    ADD CONSTRAINT lugar_interes_pkey PRIMARY KEY (lugar);
 L   ALTER TABLE ONLY starwars.lugar_interes DROP CONSTRAINT lugar_interes_pkey;
       starwars            postgres    false    230                       2606    25813    medio medio_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY starwars.medio
    ADD CONSTRAINT medio_pkey PRIMARY KEY (id_medio);
 <   ALTER TABLE ONLY starwars.medio DROP CONSTRAINT medio_pkey;
       starwars            postgres    false    231                       2606    25815    nave nave_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY starwars.nave
    ADD CONSTRAINT nave_pkey PRIMARY KEY (id_nave);
 :   ALTER TABLE ONLY starwars.nave DROP CONSTRAINT nave_pkey;
       starwars            postgres    false    232                       2606    25817    pelicula pelicula_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY starwars.pelicula
    ADD CONSTRAINT pelicula_pkey PRIMARY KEY (id_medio_pelicula);
 B   ALTER TABLE ONLY starwars.pelicula DROP CONSTRAINT pelicula_pkey;
       starwars            postgres    false    233                       2606    25819    personaje personaje_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY starwars.personaje
    ADD CONSTRAINT personaje_pkey PRIMARY KEY (nombre_personaje);
 D   ALTER TABLE ONLY starwars.personaje DROP CONSTRAINT personaje_pkey;
       starwars            postgres    false    234                       2606    25821    planeta planeta_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY starwars.planeta
    ADD CONSTRAINT planeta_pkey PRIMARY KEY (nombre_planeta);
 @   ALTER TABLE ONLY starwars.planeta DROP CONSTRAINT planeta_pkey;
       starwars            postgres    false    235                       2606    25823 &   plataformas_disp plataformas_disp_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY starwars.plataformas_disp
    ADD CONSTRAINT plataformas_disp_pkey PRIMARY KEY (id_medio_videojuegop, plataforma);
 R   ALTER TABLE ONLY starwars.plataformas_disp DROP CONSTRAINT plataformas_disp_pkey;
       starwars            postgres    false    236    236                       2606    25825    robot robot_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY starwars.robot
    ADD CONSTRAINT robot_pkey PRIMARY KEY (nombre_especie_robot);
 <   ALTER TABLE ONLY starwars.robot DROP CONSTRAINT robot_pkey;
       starwars            postgres    false    237                       2606    25827    sede sede_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY starwars.sede
    ADD CONSTRAINT sede_pkey PRIMARY KEY (nombre_af, nombre_pla);
 :   ALTER TABLE ONLY starwars.sede DROP CONSTRAINT sede_pkey;
       starwars            postgres    false    238    238            !           2606    25829    serie serie_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY starwars.serie
    ADD CONSTRAINT serie_pkey PRIMARY KEY (id_medio_serie);
 <   ALTER TABLE ONLY starwars.serie DROP CONSTRAINT serie_pkey;
       starwars            postgres    false    239            #           2606    25831    tripula tripula_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY starwars.tripula
    ADD CONSTRAINT tripula_pkey PRIMARY KEY (nombre_personajet, id_navet);
 @   ALTER TABLE ONLY starwars.tripula DROP CONSTRAINT tripula_pkey;
       starwars            postgres    false    240    240            %           2606    25833    videojuego videojuego_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY starwars.videojuego
    ADD CONSTRAINT videojuego_pkey PRIMARY KEY (id_medio_videojuego);
 F   ALTER TABLE ONLY starwars.videojuego DROP CONSTRAINT videojuego_pkey;
       starwars            postgres    false    241            D           2620    25987 $   pelicula actualizar_ganancia_trigger    TRIGGER     �   CREATE TRIGGER actualizar_ganancia_trigger BEFORE INSERT OR UPDATE ON starwars.pelicula FOR EACH ROW EXECUTE FUNCTION public.actualizar_ganancia();
 ?   DROP TRIGGER actualizar_ganancia_trigger ON starwars.pelicula;
       starwars          postgres    false    248    233            F           2620    25834 #   personaje validar_especie_personaje    TRIGGER     �   CREATE TRIGGER validar_especie_personaje BEFORE INSERT OR UPDATE ON starwars.personaje FOR EACH ROW EXECUTE FUNCTION public.validar_especie();
 >   DROP TRIGGER validar_especie_personaje ON starwars.personaje;
       starwars          postgres    false    242    234            G           2620    25835    personaje validar_fechas    TRIGGER     �   CREATE TRIGGER validar_fechas BEFORE INSERT OR UPDATE ON starwars.personaje FOR EACH ROW EXECUTE FUNCTION public.validar_valores();
 3   DROP TRIGGER validar_fechas ON starwars.personaje;
       starwars          postgres    false    246    234            H           2620    25836    personaje validar_fechasnm    TRIGGER     �   CREATE TRIGGER validar_fechasnm BEFORE INSERT OR UPDATE ON starwars.personaje FOR EACH ROW EXECUTE FUNCTION public.validar_fechas_nm();
 5   DROP TRIGGER validar_fechasnm ON starwars.personaje;
       starwars          postgres    false    243    234            E           2620    25837    pelicula validar_ganancia    TRIGGER     �   CREATE TRIGGER validar_ganancia BEFORE INSERT OR UPDATE ON starwars.pelicula FOR EACH ROW EXECUTE FUNCTION public.validar_ganancia();
 4   DROP TRIGGER validar_ganancia ON starwars.pelicula;
       starwars          postgres    false    233    244            I           2620    25838    personaje validar_robot_p    TRIGGER     �   CREATE TRIGGER validar_robot_p BEFORE INSERT OR UPDATE ON starwars.personaje FOR EACH ROW EXECUTE FUNCTION public.validar_robot();
 4   DROP TRIGGER validar_robot_p ON starwars.personaje;
       starwars          postgres    false    245    234            C           2620    25839 !   nave verificar_destructor_estelar    TRIGGER     �   CREATE TRIGGER verificar_destructor_estelar BEFORE INSERT OR UPDATE ON starwars.nave FOR EACH ROW EXECUTE FUNCTION public.verificar_destructor_estelar();
 <   DROP TRIGGER verificar_destructor_estelar ON starwars.nave;
       starwars          postgres    false    247    232            &           2606    25840 .   criatura criatura_nombre_especie_criatura_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.criatura
    ADD CONSTRAINT criatura_nombre_especie_criatura_fkey FOREIGN KEY (nombre_especie_criatura) REFERENCES public.especie(nombre_especie);
 X   ALTER TABLE ONLY public.criatura DROP CONSTRAINT criatura_nombre_especie_criatura_fkey;
       public          postgres    false    3315    217    215            '           2606    25845 %   robot robot_nombre_especie_robot_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.robot
    ADD CONSTRAINT robot_nombre_especie_robot_fkey FOREIGN KEY (nombre_especie_robot) REFERENCES public.especie(nombre_especie);
 O   ALTER TABLE ONLY public.robot DROP CONSTRAINT robot_nombre_especie_robot_fkey;
       public          postgres    false    218    217    3315            (           2606    25850 !   afiliado afiliado_nombre_afi_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.afiliado
    ADD CONSTRAINT afiliado_nombre_afi_fkey FOREIGN KEY (nombre_afi) REFERENCES starwars.afiliacion(nombre_afiliacion);
 M   ALTER TABLE ONLY starwars.afiliado DROP CONSTRAINT afiliado_nombre_afi_fkey;
       starwars          postgres    false    221    220    3321            )           2606    25855 +   afiliado afiliado_nombre_personaje_afi_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.afiliado
    ADD CONSTRAINT afiliado_nombre_personaje_afi_fkey FOREIGN KEY (nombre_personaje_afi) REFERENCES starwars.personaje(nombre_personaje);
 W   ALTER TABLE ONLY starwars.afiliado DROP CONSTRAINT afiliado_nombre_personaje_afi_fkey;
       starwars          postgres    false    234    3351    221            *           2606    25860    aparece aparece_id_medioa_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.aparece
    ADD CONSTRAINT aparece_id_medioa_fkey FOREIGN KEY (id_medioa) REFERENCES starwars.medio(id_medio);
 J   ALTER TABLE ONLY starwars.aparece DROP CONSTRAINT aparece_id_medioa_fkey;
       starwars          postgres    false    222    3345    231            +           2606    25865 &   aparece aparece_nombre_personajea_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.aparece
    ADD CONSTRAINT aparece_nombre_personajea_fkey FOREIGN KEY (nombre_personajea) REFERENCES starwars.personaje(nombre_personaje);
 R   ALTER TABLE ONLY starwars.aparece DROP CONSTRAINT aparece_nombre_personajea_fkey;
       starwars          postgres    false    234    3351    222            0           2606    25870    dueno dueno_id_naved_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.dueno
    ADD CONSTRAINT dueno_id_naved_fkey FOREIGN KEY (id_naved) REFERENCES starwars.nave(id_nave);
 E   ALTER TABLE ONLY starwars.dueno DROP CONSTRAINT dueno_id_naved_fkey;
       starwars          postgres    false    232    3347    226            1           2606    25875 "   dueno dueno_nombre_personajed_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.dueno
    ADD CONSTRAINT dueno_nombre_personajed_fkey FOREIGN KEY (nombre_personajed) REFERENCES starwars.personaje(nombre_personaje);
 N   ALTER TABLE ONLY starwars.dueno DROP CONSTRAINT dueno_nombre_personajed_fkey;
       starwars          postgres    false    234    3351    226            -           2606    25880    combate id_medio_fk    FK CONSTRAINT     }   ALTER TABLE ONLY starwars.combate
    ADD CONSTRAINT id_medio_fk FOREIGN KEY (id_medio) REFERENCES starwars.medio(id_medio);
 ?   ALTER TABLE ONLY starwars.combate DROP CONSTRAINT id_medio_fk;
       starwars          postgres    false    224    231    3345            2           2606    25885 #   idiomas idiomas_nombre_planeta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.idiomas
    ADD CONSTRAINT idiomas_nombre_planeta_fkey FOREIGN KEY (nombre_planeta) REFERENCES starwars.planeta(nombre_planeta);
 O   ALTER TABLE ONLY starwars.idiomas DROP CONSTRAINT idiomas_nombre_planeta_fkey;
       starwars          postgres    false    228    3353    235            3           2606    25890 (   interpretado interpretado_id_medioi_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.interpretado
    ADD CONSTRAINT interpretado_id_medioi_fkey FOREIGN KEY (id_medioi) REFERENCES starwars.medio(id_medio);
 T   ALTER TABLE ONLY starwars.interpretado DROP CONSTRAINT interpretado_id_medioi_fkey;
       starwars          postgres    false    229    231    3345            4           2606    25895 ,   interpretado interpretado_nombre_actori_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.interpretado
    ADD CONSTRAINT interpretado_nombre_actori_fkey FOREIGN KEY (nombre_actori) REFERENCES starwars.actor(nombre_actor);
 X   ALTER TABLE ONLY starwars.interpretado DROP CONSTRAINT interpretado_nombre_actori_fkey;
       starwars          postgres    false    219    229    3319            5           2606    25900 0   interpretado interpretado_nombre_personajei_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.interpretado
    ADD CONSTRAINT interpretado_nombre_personajei_fkey FOREIGN KEY (nombre_personajei) REFERENCES starwars.personaje(nombre_personaje);
 \   ALTER TABLE ONLY starwars.interpretado DROP CONSTRAINT interpretado_nombre_personajei_fkey;
       starwars          postgres    false    229    234    3351            6           2606    25905    lugar_interes nombre_ciudad_fk    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.lugar_interes
    ADD CONSTRAINT nombre_ciudad_fk FOREIGN KEY (nombre_ciudad) REFERENCES starwars.ciudad(nombre_ciudad);
 J   ALTER TABLE ONLY starwars.lugar_interes DROP CONSTRAINT nombre_ciudad_fk;
       starwars          postgres    false    230    3327    223            .           2606    25910    combate particpante1_fk    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.combate
    ADD CONSTRAINT particpante1_fk FOREIGN KEY (participante_uno) REFERENCES starwars.personaje(nombre_personaje);
 C   ALTER TABLE ONLY starwars.combate DROP CONSTRAINT particpante1_fk;
       starwars          postgres    false    234    224    3351            /           2606    25915    combate particpante2_fk    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.combate
    ADD CONSTRAINT particpante2_fk FOREIGN KEY (participante_dos) REFERENCES starwars.personaje(nombre_personaje);
 C   ALTER TABLE ONLY starwars.combate DROP CONSTRAINT particpante2_fk;
       starwars          postgres    false    234    3351    224            7           2606    25920 (   pelicula pelicula_id_medio_pelicula_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.pelicula
    ADD CONSTRAINT pelicula_id_medio_pelicula_fkey FOREIGN KEY (id_medio_pelicula) REFERENCES starwars.medio(id_medio);
 T   ALTER TABLE ONLY starwars.pelicula DROP CONSTRAINT pelicula_id_medio_pelicula_fkey;
       starwars          postgres    false    231    3345    233            8           2606    25925 )   personaje personaje_nombre_especie_c_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.personaje
    ADD CONSTRAINT personaje_nombre_especie_c_fkey FOREIGN KEY (nombre_especie_c) REFERENCES starwars.criatura(nombre_especie_criatura);
 U   ALTER TABLE ONLY starwars.personaje DROP CONSTRAINT personaje_nombre_especie_c_fkey;
       starwars          postgres    false    225    3331    234            9           2606    25930 )   personaje personaje_nombre_especie_h_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.personaje
    ADD CONSTRAINT personaje_nombre_especie_h_fkey FOREIGN KEY (nombre_especie_h) REFERENCES starwars.humanoide(nombre_especie_humanoide);
 U   ALTER TABLE ONLY starwars.personaje DROP CONSTRAINT personaje_nombre_especie_h_fkey;
       starwars          postgres    false    3335    227    234            :           2606    25935 )   personaje personaje_nombre_especie_r_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.personaje
    ADD CONSTRAINT personaje_nombre_especie_r_fkey FOREIGN KEY (nombre_especie_r) REFERENCES starwars.robot(nombre_especie_robot);
 U   ALTER TABLE ONLY starwars.personaje DROP CONSTRAINT personaje_nombre_especie_r_fkey;
       starwars          postgres    false    234    237    3357            ;           2606    25940 '   personaje personaje_nombreplanetap_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.personaje
    ADD CONSTRAINT personaje_nombreplanetap_fkey FOREIGN KEY (nombreplanetap) REFERENCES starwars.planeta(nombre_planeta);
 S   ALTER TABLE ONLY starwars.personaje DROP CONSTRAINT personaje_nombreplanetap_fkey;
       starwars          postgres    false    234    3353    235            ,           2606    25945    ciudad planeta_fk    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.ciudad
    ADD CONSTRAINT planeta_fk FOREIGN KEY (nombre_planeta) REFERENCES starwars.planeta(nombre_planeta);
 =   ALTER TABLE ONLY starwars.ciudad DROP CONSTRAINT planeta_fk;
       starwars          postgres    false    223    3353    235            <           2606    25950 ;   plataformas_disp plataformas_disp_id_medio_videojuegop_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.plataformas_disp
    ADD CONSTRAINT plataformas_disp_id_medio_videojuegop_fkey FOREIGN KEY (id_medio_videojuegop) REFERENCES starwars.videojuego(id_medio_videojuego);
 g   ALTER TABLE ONLY starwars.plataformas_disp DROP CONSTRAINT plataformas_disp_id_medio_videojuegop_fkey;
       starwars          postgres    false    241    236    3365            =           2606    25955    sede sede_nombre_af_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.sede
    ADD CONSTRAINT sede_nombre_af_fkey FOREIGN KEY (nombre_af) REFERENCES starwars.afiliacion(nombre_afiliacion);
 D   ALTER TABLE ONLY starwars.sede DROP CONSTRAINT sede_nombre_af_fkey;
       starwars          postgres    false    3321    238    220            >           2606    25960    sede sede_nombre_pla_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.sede
    ADD CONSTRAINT sede_nombre_pla_fkey FOREIGN KEY (nombre_pla) REFERENCES starwars.planeta(nombre_planeta);
 E   ALTER TABLE ONLY starwars.sede DROP CONSTRAINT sede_nombre_pla_fkey;
       starwars          postgres    false    238    3353    235            ?           2606    25965    serie serie_id_medio_serie_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.serie
    ADD CONSTRAINT serie_id_medio_serie_fkey FOREIGN KEY (id_medio_serie) REFERENCES starwars.medio(id_medio);
 K   ALTER TABLE ONLY starwars.serie DROP CONSTRAINT serie_id_medio_serie_fkey;
       starwars          postgres    false    239    231    3345            @           2606    25970    tripula tripula_id_navet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.tripula
    ADD CONSTRAINT tripula_id_navet_fkey FOREIGN KEY (id_navet) REFERENCES starwars.nave(id_nave);
 I   ALTER TABLE ONLY starwars.tripula DROP CONSTRAINT tripula_id_navet_fkey;
       starwars          postgres    false    3347    240    232            A           2606    25975 &   tripula tripula_nombre_personajet_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.tripula
    ADD CONSTRAINT tripula_nombre_personajet_fkey FOREIGN KEY (nombre_personajet) REFERENCES starwars.personaje(nombre_personaje);
 R   ALTER TABLE ONLY starwars.tripula DROP CONSTRAINT tripula_nombre_personajet_fkey;
       starwars          postgres    false    3351    240    234            B           2606    25980 .   videojuego videojuego_id_medio_videojuego_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY starwars.videojuego
    ADD CONSTRAINT videojuego_id_medio_videojuego_fkey FOREIGN KEY (id_medio_videojuego) REFERENCES starwars.medio(id_medio);
 Z   ALTER TABLE ONLY starwars.videojuego DROP CONSTRAINT videojuego_id_medio_videojuego_fkey;
       starwars          postgres    false    3345    241    231            �      x������ � �      �      x������ � �      �      x��M,J�L�����K�I-����� T��      �      x������ � �      �     x��VKR�H]˧���Ƕ쥍?`C�����MbU�
���*	F��,{ѧ�b�Y2��ꭝ��|���J�l�BJ/B?�����2])�qe�w�Jn�/�K{�WP,�,��L��8Ĥ�޼����
63�S�(����'+�@	Rpv�MY��4�1�޼Kk�˷ߟ�s0����`臁�'�,z�d�bm2L�G~��a|��ܲ9�VZq�y1��#%�y����V�E�0�Z 7�cIj1r%ޥ���l�PT\��3��Ͷ���0:=Vڛ��5���5挱N���'�-b�BY�k����`l����$�����*�x�':����8gS����Ub���?'�6�O��2ck��c�pL[몜"EJ�PS]�dLh�AW�k]�+P|�*����q���YFƂ;�V��I'��+�ֲX
���t�C"�۪i��PaKn�1-%�$�}�_p-�*�T@#F�RTO���5TR�;���9(@ Z�l��3��]s�4BH~�xS#ʷ����ÔK�63�N�}�K��ݨ2תf3P�K�gqw����ڲ�v���0�����ipG��8�л�zǿ��J�Mu͟`�̘|�/8R�.r�`K�����ٻƑ�����&� �֦�����t�wb�&y�	�QD��}Mq�)����@{"p�7�liкq�ǣ(\�۱d;�&�y.�'8[WY���,�ӏ$Qq������L��=h�Ռ� ��Z]k�o��� v.�v�G͵��lA�z�R�#�gֈzd���B)V�+��3-��Z!���ȏ��� i��9�9y�;���v�T:�>\p�G7EL�r�*����<�b��]�hp��� �;�.g��)��ҡ�<K�;�c��QZ�g����}�μG#���w�q�K����������L}������hvvT089F�/�ՑۭE�^,Ո��s�WP��ǧH���DG��5; �J۷_�q�/
�x/�\�1��$�c����"z�8g�%��Z�3n7�VB���YO#Zg� ��z���݁�      �   �   x��/JI�S�JM���1��R�J��LNTpO�9�0���tKLN�<�9��H!8�$��3� �(3�8��1'31�*Q!(5)5'%!P���Z�� 6!�W�ZDv�Ȅ���Լ�L$���qqq ��G>      �      x���MN�0���)|�8%M�,��S
YTHl&��Xq��J@p�\�m.�SBk*�����o�s�Q�K�»�Yi�t�� �,���������3W�KA7��*]
Ō��؅�5�1k�G�$�$����zg4]ຯ���3�����.t�j���wHQ6���>J)�@V ��mg��x3��E#8H�/�'�PP�#�?�}c��W�Bt����*r����XjődZ��8ٕ�DQ!>�5�:�p�3��Ѵh�>���A�lu!�o��X�~8�}�����      �   E  x�m�Mn�0���� ���4Y���
Z�R7�7��ܸܨ���:Ɇ��ݼO��ӛ��Z�}}���Vn����!�CP� *���Ǝ�|�o�����)|�``2Vb���G�`3�6w	E)EE�?/�{�DJBM�������ZBh" �#)���6]�W|�<vFr��FU��gթ=T�(~p�����A�-r4$�������m+==�����J�� �!HB��9!�&����tmG��ڧ����i)���~b�K�Z���.������->{���ꠍ��4�+a+���V��Hث��ɖ���`��c�*/	      �   >  x�]�K��0D��)r��b��� ��Nia�#@�~� �r�s��vWQ]�qP5��M9KrD�H�㭗c�)XH,�����F�����$�T~s���01�9�<�]d�B����h�����C!�bwsSA�Q/s)=�JC9���VT��,Ա��EFb��0W�����-G����+������*2��w�>I��
yu��,��8ЀL�һ��3)��X�5c��Y�k�3�M�����S2U�$׋�sO̽��7X�9_����f��x_E���w�s�����ک�U��o�3��9����<��8~��1�+���      �   �   x�u��JAE��_�?�2=����d�c�,���)I�M��C��m��A����s����	Y���`�������)�PR�w����Z�t�Y���Dz'���=	Kr	n�m��X[�\8�KzC�UR7+Sc���E&���P<�h���#�����
�L`�?]��hW��x*p<}�'���w=��0��x.N��G��������z�����i�      �   L   x��(-)�K-JI�tN,��,�/��� 
^Y��X��������^�Y�$�� �	�/J�tr��T�D�b���� �~"�      �   u   x��)�NUή,O��N-�420��50�50�4�r�K���C�5�)0�4�rI,*�P�M,́�2�52���JLJJ�
Y�pZb5� dP�Ѐ�#(����ihi��$l����� ��(b      �   @   x�)�L9�0�$3��=1�J�Wp:��Hsy��&��c��JL*J��tI,*���,������ ��      �   �  x�}R�n1<��bn9	�qKvQB���@\z<f�YO7�#K>'ߒ��w%�������G�=2z	�J�\(�*���6Ǆ?0����1�;�������0�y,�J�n&O��r"s��t�3��f+ܭ��#Yj�+',�"���8ɀ3|��b瑧��3\�*hީ��o��.H2�(���o7��|�]�,����u�%��m��Ɛ3k�kM�/�c�w�5�Y
���{2����É�2D��Y�wPQ#�_A�8���L*����A"(._j4���G��Jw���=��p�GPwoh��5t��r]ީ��������=[�.��OiN�?�wM�c�96��|�7wݹ�����Wl��o�=��ZRw��H�����Wω���z�	��|a���
Ys      �   �  x��QAn�@<s_�؀�h���u�حr�����jPR�G}G?V*����ȝ�3;OT��E�_)V����s��EC�rj8���?���!�g�c:ʦ���E�m��(�Iث���E�|u[i��ƍ������3����-�zaŜٮ��\K�<P�̍^�!�
�;���qK��)���v�c�	��'R�|q�SK	ﵿ1X͌�)/��2����H+�P��pw7%\h�g�����V����0����V�Nk�(L���B�X�j�$�J������˒�������M��:x3�s ���r�2�Bc��@�� �ƤH�`΢�Ѷ�!�-�%An����oI�K̺�a������1nu��{OQ�p��3���;��6C{��3�<v����ϡ      �   M  x�u�MN�0���)|�E�"RD+6�dZ�:3�퀚�p V�ch~Z������'߄�T��;�l��1*1+��Gm)I.�,mpt\d��S��^�ꆧ�h�G1�p@i�M��]p:�@p�������&��x�@3���dR��j�j(Z�>9�v�H=�xRy����r-�άtJ�7	#��u)co�l��w�=�1��`����+�3ћ�R|e1\�R��ɶ���eǀ&!�Sw��o�G8j/�v�M�^amC��<��g�
|~�n'��/��l����؝��=F�V|�Kރ[�V�dZ�-E�O�˽��4��Z�sH�o�$��#��      �   �  x��X�n�8]�_Ad�8�_y�.�Gu��N&��-16�Ԑ��\�2�^f��`v�Տ͹�dˊ�i`K���sϹ���C�-��[����9�ًg.�민3<9:��:�w��cNμ`�]�g�����z�	͜gɟ˹��ki��8;U��{1*=��h�.�?uj�%�2�<5�*�MҰ�\�&�L[2%S���b�����%�p����%�(��/��/l!��Q3�������rK(ǃ��!@�.�ϕO��V,	ȥ�N���ֽ��0V�R�'�J�t�-�[��c��H�KS�La>J��!�v�w�]�m\v����/�.��(''���3��Y�pG�X9C�a�T�g������G_xk�9�Ŝ��Q�>�υ*_5�0	Nk�I|0�cfB���P,�/D,�?���h4�Ij��n�r�w��'��T�X�`���G,EOn�W��A+ŧETY�ؙ2Z��h0���C�v��_�ٓY ���L:�i�D�X��S���a����}vS����;�f��"S���u�ȧ�Y8�$��pg⧖�/ɘX�rk�r*�c��a��	=��R� �9%�*}&����e��הoC�DQA��������K���DM��U�sA�C_�N�Do��F�!\���۪\�sHXk$��o��|�F�:d�c�PwF�6�� ��{C��Y ���;+3�g�6��=�H�S�[����W���s/Po��E�o"��Ի��i#�"����lDŨ�.r	����+���.���Q'�h�i�۶��bA>/��4�xw��Hp0x�U�~�Dj����.�AP�~w8����V��]?"�ଐݕ��aU�Igoud�%>�7���3������Q��g@n"k��O}�+�Cj�B���Ώ���(��+�ثO�U<��sEΊ��'��B9�lؓ�qV������l.>Oy���pC2��O�W$D�!�4���k�2+Ū��Om�sΨ4���%Q�$P-K=�Y!l���R� �>"S�"f�km�K�ND���}@��� a��լ%����Nb�#��C�<�K`�4*��hY�9ig.K��}rO;���I����Zf�+T� ��A�i�S��\p8����:�1���Uo��-��|S?�gG

}�6�������䝧bU.���P�W�,Q�~_�����I:�F�;/���v[J���h�|�����w����m��+G�G� ��<���f�Zuw�	5t"�j��'d��>��?A8�;S(����pET�+�;�f�'�b�!T����ژ	 0�3�u�3�._�#��xI	?`�T
�H��ڙ8�+z͋YL�{���@I���؎�V��?#5���Ǝ3t�'�)2(^�˗mиȥ3)�wuu��w�<]��|�r6/3��@�oU���~�d;}p�66�R3D�M	9�ih�@��ʁAa�e���=����������,|�s̆U�VPR�+�*2Fkq�mԪ;�ܔB6�T���4�f���m��y5����@aA���5����c����X�-<���d�,��>6.=<,_���Pq�H��ߙ���4�Ѹ�뭪�ޠg�jT��U�\���v��^�]y�����
4C�N8���K�.�E����B���i�;[V�D����1I��*��VC?�T���1�lnDU���|*���tEQli�#���B��5�֦g������h�6����Yq�r�:�O��
�nc �,<�q�����۰�0-���)wa�a��6�-�bLEG����/�t�]m j�����i�e��oGM��m<n��M, 0�Ba@�i�Oѕ�ZWZ�B_7����cC��Wv:w晳_H(е�0ᣅM��d��KeґsЋ���4R�eM|'qH��8�����`�8~1j��a�R��Zb2��-eb�M�[}�r�yT�Ć�:V����ą�<��� ���q�}��gA�l I�'��!�7PF\�-�%�I/P�=Ohu�K��0m2�PP��q���_��[E�z[C��9%�g�5�� \�»<���9af��<�اt��*���i���n��v���-_i-�)�m�T5L�6�tǃ��}�E�Œ��ꎪij�H+��Q�<,/�"�?�*,���ZW%�����aU��߰��T�]@c��#O��*(uǣ�_����`(b?�?*_-#��&�{���'�&f���g�������W      �   t  x���Mn�0���S������D��ע@d��X&�(RR	|����n}�R��&@
dIp���ѰΞ�5p�j�b��B��=�ҷ�V�tr�FpI�>�r���q$�ӄk�.\��I�w�b%ICp��t�窀�ңA7=E��!�6���H'��Br[K:�}Vh5�%�H��O�����]��t��܄(}��"[X8����ᧃY��M~�v�JV�?R>��4�$� z��6�-��Na�Ė�]�Lk��^��������r$����(`��Ipk�ޚ��{c���� ��Ye����l`��L$��(�ߑۃ�g��������Y9 $�~0���v�vܥ����Y��D)�w�҅      �   �  x��T�n1<���_���8B�V��6$���8��ffv���i�#�.�OuWu���:����oU�AJ��uj���ȯڟp��'�}n��p������j3"f�����ؼ�:�∘��j�����@d��������7�����:�=�m�+�H�	�2�JX���ʀ�J��y����u�m�2���ӡ��ѽ��Y85a���fR8#�Q&�aDL
��]����?bW���Kl���)��ψI	���-
$�/p���(�q��g�Qr�8�s%g!8kF��9�Y �j�iL� ��T�jK��m�bS�/,	=�DH�	. ����w��@�r�U㈘rp�㫼k�LV��tM�����WOoq��XG��><.�q`���O_�|sȿ�]����2�']����L�/Y/<�D��LeK�=2-�C����X�n��GX3MP��
�-"�~�T����v|�j���,��Ə8�����$�j��}\1�~�uw      �   \  x��TKn�0]ӧ�h��%�K'j���8@�"��EČe����m��9r�m96�8E �7�>Եd�$� �$P{O�.�u-�����V1Xh鸋~	�;R��lPYG��1T��ɱw3Dr�x�4�n	nK~>8�?t҅�Gx�H.��\L�����}<Nj��_t��Q��`~#�V�lɅޭ��[g��z�ޛ.4�2]����Ix��]��)���;%L����[\i���9�Z�?<�<8��"����l6����uC���Gh&�������=n���3������ �(��~�.r�sr��|m����-�M��k�v��#2���!E��?:� t�[��x�δ-�N�R�ވ��΍�E���	q�qX�����Т`B��ܜ����;���|�<��y�}Luf,��p��y���mL p�	H��ɑ��7I^A���4^Z�^�؊JF����w���	�5�l���r�S�y�u3�t_��chMM�n�l�b����d\3�{��	G�w� �â �$���D�~�"�EK&F��l���Y��+A!��9tm
3Om� ���b,z�y��D&S��~@`��q7kO�      �   .  x��TKr�0]S��ҙ6��d���V��jV��c��H�ɲG�z
_��,Qv�q�!@�@`@#���k�˕c�J'��M�O������$���3P8��F��a��`)Hi4���ZC�IQ�z�
̾�=,�e\c�H��1��R r0U�T�i��J��J��k���_�i�U��"���ڲЉ���oR왣I��uJ��S��Z.:*=]���]2�������
���Z�r�=�̴�(��L�QE'��h���ʋ��O�?4�x��UK;q��#��	E1��R'��6�+����:��l�%��Zfr�f�'f0euY_(z9���Ny`Ղ����<�Fl��*'/r�Ztb���:��5R�(ԣ��"l���)��,�]��Z��� ���E���;X�0Ɯ�C�{�J�tģ,�ɋ�|DC��$i��޿߿�3&�Q�d�����V�m	ƉA�}����ʭ<	.����!d�O�wӝ>2�HObc�z�����ї'�ݼ�y�oΫ0�17���Y�%���=)��=���M{��C�$"z      �   Z   x�32��I�.I,���S0�22��HʯP��K�����" �3B�`�H�����	��Ș�h1	��063 ��33�j��b���� %+$�      �   1   x�3��(�/�O����t��K,���
2�t,.)��MMN���qqq ��      �   �   x�u�=
1��:9E.��[TW�be3��	ČL��x۽�va���->��'��.��(�O�gAJ�,�k��J�Z�Ԓιfy���mb��6Ǘ-�)`�&Z�g�4���O���9H���J��=D�H�έ��n59�䅼̥�"Ta�      �   �   x�u�=k�0��_�=,ˉ�1�I!��C�.�D��ΩH����I�4���/YBK�;8����f^���.r�R�!����
�<��,�ȏԻ)�3�T;��Ō���Y(7(7Ip�j�)�)�n�s�R�}K����ף9R%���	�m��4��c�4yC1?�d�G��:��BU$*��N�F�����U	��6�x����~K�)�c���HT{�      �   S   x��H�S����4�tN�JJM��+HͫJ,��)�NUή,O��N-�4��JM��JMJ�II-�r�K���CR`V����� ;Z      �   �   x�m�A
1E��)rѨ����8��M�U*���U�\����f����?�a��W�)zrV8����h y�T�IA^��y)?�ˊ���}�?���M��0�tkZ�]�y��}>��Ln���oTV��_�3D� *?�     