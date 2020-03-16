create sequence hibernate_sequence start with 1 increment by 1;

create table book
(
    id                 bigint    not null,
    created_date       timestamp not null,
    last_modified_date timestamp not null,
    file_last_modified timestamp not null,
    name               varchar   not null,
    url                varchar   not null,
    book_metadata_id   bigint    not null,
    serie_id           bigint    not null,
    index              integer,
    primary key (id)
);

create table book_metadata
(
    id         bigint  not null,
    media_type varchar,
    status     varchar not null,
    thumbnail  bytea,
    primary key (id)
);

create table book_metadata_page
(
    book_metadata_id bigint  not null,
    file_name        varchar not null,
    media_type       varchar not null,
    number           integer
);

create table serie
(
    id                 bigint    not null,
    created_date       timestamp not null,
    last_modified_date timestamp not null,
    file_last_modified timestamp not null,
    name               varchar   not null,
    url                varchar   not null,
    primary key (id)
);

alter table book
    add constraint uk_book_book_metadata_id unique (book_metadata_id);

alter table book
    add constraint fk_book_book_metadata_book_metadata_id foreign key (book_metadata_id) references book_metadata (id);

alter table book
    add constraint fk_book_serie_serie_id foreign key (serie_id) references serie (id);

alter table book_metadata_page
    add constraint fk_book_metadata_page_book_metadata_book_metadata_id foreign key (book_metadata_id) references book_metadata (id);
update BOOK_METADATA
set STATUS = 'UNKNOWN'
where ID in (
    select m.id
    from BOOK_METADATA m,
         BOOK_METADATA_PAGE p
    where m.ID = p.BOOK_METADATA_ID
      and m.THUMBNAIL is null
      and p.NUMBER = 0
      and p.MEDIA_TYPE = 'image/webp');
update BOOK_METADATA
set STATUS = 'UNKNOWN'
where ID in (
    SELECT ID FROM BOOK_METADATA where MEDIA_TYPE = 'application/pdf'
    );
update BOOK_METADATA
set STATUS = 'UNKNOWN'
where ID in (
    SELECT ID FROM BOOK_METADATA where MEDIA_TYPE = 'application/pdf'
    );
update BOOK_METADATA
set STATUS = 'UNKNOWN'
where ID in (
    SELECT ID FROM BOOK_METADATA where MEDIA_TYPE = 'application/pdf'
    );
update serie set file_last_modified = '1970-01-01 00:00:00';
create table library
(
    id                 bigint    not null,
    created_date       timestamp not null,
    last_modified_date timestamp not null,
    name               varchar   not null,
    root               varchar   not null,
    primary key (id)
);

alter table library
    add constraint uk_library_name unique (name);

alter table serie
    add (library_id bigint);

alter table serie
    add constraint fk_serie_library_library_id foreign key (library_id) references library (id);
alter table serie
    alter column library_id set not null;
alter table serie
    rename to series;

alter table series
    rename constraint fk_serie_library_library_id to fk_series_library_library_id;

alter index if exists fk_serie_library_library_id_index_4 rename to fk_series_library_library_id_index_4;


alter table book
    alter column serie_id
        rename to series_id;

alter table book
    rename constraint fk_book_serie_serie_id to fk_book_series_series_id;

alter index if exists fk_book_serie_serie_id_index_1 rename to fk_book_series_series_id_index_1;
update book_metadata
set thumbnail = null;
create table user
(
    id                 bigint    not null,
    created_date       timestamp not null,
    last_modified_date timestamp not null,
    email              varchar   not null,
    password           varchar   not null,
    primary key (id)
);

alter table user
    add constraint uk_user_login unique (email);

create table user_role
(
    user_id bigint not null,
    roles   varchar
);

alter table user_role
    add constraint fk_user_role_user_user_id foreign key (user_id) references user (id);
alter table user
    add (shared_all_libraries boolean not null default true);

create table user_library_sharing
(
    user_id    bigint not null,
    library_id bigint not null,
    primary key (user_id, library_id)
);

alter table user_library_sharing
    add constraint fk_user_library_sharing_library_id foreign key (library_id) references library (id);

alter table user_library_sharing
    add constraint fk_user_library_sharing_user_id foreign key (user_id) references user (id);
alter table book
    add (file_size bigint default 0);

-- force rescan to update file size of all books
update series
set file_last_modified = '1970-01-01 00:00:00';
update book
set file_last_modified = '1970-01-01 00:00:00';
alter table book
    add (number float4 default 0);
update book
set number = (index + 1);
alter table book
    drop column index;
alter table book_metadata
    rename to media;

alter table book
    alter column book_metadata_id
        rename to media_id;

alter table book
    rename constraint uk_book_book_metadata_id to uk_book_media_id;

alter table book
    rename constraint fk_book_book_metadata_book_metadata_id to fk_book_media_media_id;

alter table book_metadata_page
    rename to media_page;

alter table media_page
    alter column book_metadata_id
        rename to media_id;

alter table media_page
    rename constraint fk_book_metadata_page_book_metadata_book_metadata_id to fk_media_page_media_media_id;

alter index if exists uk_book_book_metadata_id_index_7 rename to uk_book_media_id_index_7;
alter index if exists fk_book_metadata_page_book_metadata_book_metadata_id_index_9 rename to fk_media_page_media_media_id_index_9;
alter table media
    add (created_date timestamp);
alter table media
    add (last_modified_date timestamp);

update media
set created_date       = CURRENT_TIMESTAMP(),
    last_modified_date = CURRENT_TIMESTAMP();

alter table media
    alter column created_date set not null;
alter table media
    alter column last_modified_date set not null;
alter table media
    add (comment varchar);
create table series_metadata
(
    id                 bigint    not null,
    created_date       timestamp not null,
    last_modified_date timestamp not null,
    status             varchar   not null,
    primary key (id)
);

alter table series
    add (metadata_id bigint);

alter table series
    add constraint fk_series_series_metadata_metadata_id foreign key (metadata_id) references series_metadata (id);

alter table series
    alter column metadata_id set not null;
alter table series_metadata
    add (
        status_lock boolean default false,
        title varchar,
        title_lock boolean default false,
        title_sort varchar,
        title_sort_lock boolean default false
        );

update series_metadata m
set m.title      = (select name from series where metadata_id = m.id),
    m.title_sort = (select name from series where metadata_id = m.id);

alter table series_metadata
    alter column title set not null;

alter table series_metadata
    alter column title_sort set not null;
alter table book
    alter column number set data type int;
