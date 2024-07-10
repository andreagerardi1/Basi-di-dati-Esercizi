-- selezionare le persone che sono decedute in un paese diverso da quello di nascita
select distinct l.person
from imdb."location" l join imdb."location" l2 on l.person = l2.person 
where l.d_role <> l2.d_role and l.city <> l2.city;

-- selezionare i film che non hanno materiali associati
-- restituire anche il titolo nel risultato
select distinct m.id, m.official_title
from imdb.movie m 
except
select distinct m2.movie, m3.official_title
from imdb.material m2 join imdb.movie m3 on m2.movie = m3.id;

-- selezionare i paesi nei quali non sono prodotti film
select c.iso3, c."name"
from imdb.country c 
except 
select distinct p.country, c2."name"
from imdb.produced p join imdb.country c2 on p.country = c2.iso3

-- selezionare i film per i quali esistono materiali multimediali di tipo immagine o materiali testuali di qualche genere
select distinct m.movie 
from imdb.material m
where m.id in (
	select distinct m2.material
	from imdb.multimedia m2 
) or m.id in (
	select distinct t.material
	from imdb."text" t 
)

-- selezionare i film per i quali esistono materiali multimediali di tipo immagine e materiali testuali di qualche genere
with movie_media as (
	select ma.movie
	from imdb.material ma join imdb.multimedia mu on ma.id = mu.material
), movie_text as(
	select m.movie
	from imdb.material m join imdb."text" t on m.id = t.material
)
select movie from movie_media
intersect 
select movie from movie_text

-- selezionare i film per i quali esistono materiali multimediali di tipo immagine o materiali testuali, ma non entrambi (or esclusivo)
with movie_media as (
	select ma.movie
	from imdb.material ma join imdb.multimedia mu on ma.id = mu.material
), movie_text as(
	select m.movie
	from imdb.material m join imdb."text" t on m.id = t.material
), movie_intersection as (
	select movie from movie_media
	intersect 
	select movie from movie_text
), movie_union as (
	select movie from movie_media
	union
	select movie from movie_text
)
select movie from movie_union
except 
select movie from movie_intersection;

-- restituire il titolo dei film con durata superiore alla durata di Inception
select m1.id, m1.official_title 
from imdb.movie m1 
where m1.length > (
	select m.length 
	from imdb.movie m
	where m.official_title = 'Inception'
);

-- restituire il titolo dei film con durata superiore alla durata di tutti i film con titolo Inception
-- notare l'utilizzo di all
select m1.id, m1.official_title 
from imdb.movie m1 
where m1.length > all (
	select m.length 
	from imdb.movie m
	where m.official_title = 'Inception'
);

-- restituire il titolo dei film con durata superiore alla durata di almeno un film con titolo Inception
-- notare l'utilizzo di any
select m1.id, m1.official_title 
from imdb.movie m1 
where m1.length > any (
	select m.length 
	from imdb.movie m
	where m.official_title = 'Inception'
);


-- selezionare le persone che hanno recitato in film nei quali erano registi
select distinct p.id, p.given_name 
from imdb.person p
where p.id in (
	select distinct c1.person
	from imdb.crew c1 join imdb.crew c2 on c1.person = c2.person
	where c1.movie = c2.movie and c1.p_role = 'actor' and c2.p_role = 'director'
)