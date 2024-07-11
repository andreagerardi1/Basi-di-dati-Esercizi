-- selezionare le pellicole prodotte in Italia e Stati Uniti
select m.id, m.official_title 
from imdb.movie m 
where m.id in (
	select distinct p1.movie
	from imdb.produced p1 join imdb.produced p2 on p1.movie = p2.movie 
	where p1.country = 'ITA' and p2.country = 'USA'
);

-- selezionare le pellicole prodotte solo in Italia
select m.id, m.official_title 
from imdb.movie m 
where m.id in (
	select p1.movie 
	from imdb.produced p1 
	except 
	select distinct p.movie
	from imdb.produced p
	where p.country <> 'ITA'
);

-- trovare le coppie di pellicole che non hanno generi in comune
-- 1) trovare tutte le coppie possibili
with couples as (
	select g1.movie as m1, g1.genre as gr1, g2.movie as m2, g2.genre as gr2
	from imdb.genre g1 join imdb.genre g2 on g1.movie > g2.movie 
)
select *
from couples 
except 
select *
from couples
where couples.gr1 = couples.gr2
-- da finire

-- selezionare il film di durata maggiore
select max(m.length)
from imdb.movie m;

-- selezionare il film di durata minore
select min(m.length)
from imdb.movie m;

-- restituire la durata media delle pellicole
select avg(m.length)
from imdb.movie m;

-- restituire la durata media delle pellicole prodotte a partire dal 2010
select avg(m.length)
from imdb.movie m 
where m."year" >= '2010'

-- restituire la durata complessiva delle pellicole del 2010
select sum(m.length)
from imdb.movie m 
where m."year" = '2010';

-- restituire il numero di pellicole memorizzate 
select count(*)
from imdb.movie m 

-- restituire il numero di pellicole memorizzate a partire dal 2010
select count(*)
from imdb.movie m 
where m."year" >= '2010';

-- restituire il numero di pellicole per le quali è noto il titolo
select count(*)
from imdb.movie m 
where m.official_title is not null

-- restituire il numero di titoli diversi delle pellicole
select count(distinct m.official_title)
from imdb.movie m;

-- trovare la media della durata delle pellicole senza usare avg
select sum(m.length)::decimal/count(length)
from imdb.movie m 
-- consiglio: occhio ai null, per esempio in count l'argomento è length e non *


-- restituire il numero di pellicole per ogni anno disponibile (con ordinamento)
select m.year, count(*) as conteggio
from imdb.movie m 
group by m."year" 
order by m."year" asc 

-- trovare l'anno con il maggior numero di pellicole (non necessariamente un unico anno)
with coppie as (
	select m."year" as anno, count(*) as conteggio
	from imdb.movie m 
	group by m."year" 
)
select * 
from coppie
where coppie.conteggio = (
	select max(coppie.conteggio)
	from coppie
)

-- restituire per ciascun film il numero di persone coinvolte
select c.movie, count(c.person)
from imdb.crew c 
group by c.movie;

-- restituire per ciascun film il numero di persone coinvolte per ciascun ruolo
select c.movie,c.p_role, count(c.p_role)
from imdb.crew c 
group by c.movie, c.p_role
order by 1;

-- restituire il numero di persone per ruolo
select c.p_role ,count(*)
from imdb.crew c 
group by c.p_role;
















