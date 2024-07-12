-- restituire le pellicole che hanno più di 10 attori
select c.movie, count(*)
from imdb.crew c 
where c.p_role = 'actor'
group by c.movie 
having count(*) > 10;

-- restituire le persone che hanno svolto più di un ruolo
select c.person
from imdb.crew c 
group by c.person 
having count(c.p_role) >1

-- restituire gli anni nei quali ci sono più di 10 film a partire dal 2010
select m."year", count(*) 
from imdb.movie m 
where m."year" >= '2010'
group by m."year" 
having count(*) > 10

-- selezionare l'attore che ha recitato nel maggior numero di film
select c.person
from imdb.crew c 
where c.p_role = 'actor'
group by c.person 
having count(*) >= all (
	select count(*)
	from imdb.crew c2 
	where c2.p_role = 'actor'
	group by c2.person
)

-- selezionare i film che non sono stati distribuiti nei paesi nei quali sono stati prodotti
select m.id, m.official_title
from imdb.movie m 
where m.id in (
select p.movie 
from imdb.produced p 
where p.country not in (
	select r.country
	from imdb.released r 
	where r.movie = p.movie
))

-- selezionare i film nel cui cast non figurano attori nati in paesi dove il film è stato prodotto
with mpc as (
select c.movie as mm, c.person as pm, p.country as cm
from imdb.crew c join imdb.produced p on c.movie = p.movie
)
select distinct mpc.mm 
from mpc
except
select distinct mpc.mm
from mpc join imdb."location" l on mpc.pm = l.person 
where mpc.cm = l.country and l.d_role = 'B';

-- selezionare il titolo dei film che hanno valutazioni superiori alla media delle valutazioni dei film prodotti nel medesimo anno
with mean_by_year as (
	select m."year" as anno, avg(r.score) media
	from imdb.movie m join imdb.rating r on m.id = r.movie
	group by m."year"
	order by m."year"
), rating_con_anno as (
	select m."year" as anno_film, m.id as id, m.official_title as titolo, r.score as voto
	from imdb.movie m join imdb.rating r on m.id = r.movie
)
select r.id, r.titolo
from mean_by_year m join rating_con_anno r on m.anno = r.anno_film
where r.voto > m.media












