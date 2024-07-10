-- reperire le pellicole con valutazione superiore a 8 su una scala di 10
select *
from imdb.rating r 
where r."scale" = 10 and r.score > 8;

-- reperire le pellicole con valutazione superiore a 80%
select *
from imdb.rating r 
where r.score/r."scale" > 0.8;

-- selezionare pellicole che hanno "murder" nel titolo
select *
from imdb.movie m 
where m.official_title ilike '%murder%';

-- selezionare pellicole che hanno "murder" nel titolo escludendo quelli che hanno murderer
select *
from imdb.movie m 
where m.official_title ilike '%murder%' and (m.official_title not ilike '%murderer%');

-- selezionare le pellicole che contengono murder o Murder all'inizio del titolo (senza usare ilike)
select *
from imdb.movie m 
where m.official_title like 'murder%' or m.official_title like 'Murder%';

-- selezionare le persone che hanno 'Mark' nel nominativo
select *
from imdb.person p 
where p.given_name like '%Mark%';

-- selezionare le persone che si chiamano 'Mark' di cognome
select *
from imdb.person p 
where p.given_name like '%Mark';

-- selezionare il titolo delle pellicole prodotte negli Stati Uniti
select m.official_title 
from imdb.produced p join imdb.movie m on p.movie = m.id 
where p.country = 'USA';

-- selezionare i paesi nei quali sono state distribuite le pellicole del 2010 (si restituisca anche il titolo della pellicola - sia quello ufficiale, sia quello usato nella distribuzione dove presente)
select r.country, m.official_title , r.title 
from imdb.movie m join imdb.released r on m.id = r.movie 
where m."year" = '2010';


--con ordinamenti
select r.country, m.official_title , r.title 
from imdb.movie m join imdb.released r on m.id = r.movie 
where m."year" = '2010'
order by r.country, m.official_title;

-- selezionare le pellicole distribuite in Italia per le quali non è noto il titolo locale (released.title) 
select r.movie 
from imdb.released r 
where r.country = 'ITA' and r.title is null;

-- selezionare gli attori che hanno recitato nel film Inception
select c.person 
from imdb.crew c join imdb.movie m on c.movie = m.id 
where m.official_title = 'Inception' and c.p_role = 'actor';


-- selezionare id, nome degli attori che hanno recitato in pellicole del 2010
select p.id , p.given_name 
from imdb.person p 
where p.id in (
	select distinct c.person 
	from imdb.movie m join imdb.crew c on c.movie = m.id
	where m."year" = '2010' and c.p_role = 'actor'
);


