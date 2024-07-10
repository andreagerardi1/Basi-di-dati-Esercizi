-- selezionare il titolo delle pellicole del 2010
select m.id, m.official_title 
from imdb.movie m 
where year = '2010';

-- selezionare tutti gli attributi delle pellicole del 2010 di durata superiore all'ora
select *
from imdb.movie m 
where m."year" = '2010' and m.length > 60;  

-- selezionare tutti gli attributi delle pellicole del 2010 di durata compresa fra una e due ore
select *
from imdb.movie m 
where m."year" = '2010' and m.length between 60 and 120;
-- between include gli estremi

-- selezionare tutti gli attributi delle pellicole di durata compresa fra una e due ore (estremi inclusi) realizzate in anni diversi dal 2010
select *
from imdb.movie m 
where m."year" != '2010' and m.length between 60 and 120;

-- selezionare le pellicole di genere Drama, Thriller o Crime
select distinct g.movie 
from imdb.genre g
where g.genre = 'Drama' or g.genre = 'Thriller' or g.genre = 'Crime'; 
-- altrimenti
select distinct g.movie 
from imdb.genre g
where g.genre in ('Drama', 'Thriller', 'Crime');

-- restituire le pellicole con almeno un genere in comune a quelli di Inception
select distinct g.movie 
from imdb.genre g 
where g.genre in (
	select g2.genre
	from imdb.movie m join imdb.genre g2 on m.id = g2.movie 
	where m.official_title = 'Inception'
);

-- selezionare le pellicole che sono Drama, Thriller e Crime (tutti e tre i generi)
select g.movie 
from imdb.genre g 
where g.genre = 'Drama'
intersect 
select g.movie 
from imdb.genre g 
where g.genre = 'Thriller'
intersect 
select g.movie 
from imdb.genre g 
where g.genre = 'Crime';

-- selezionare il nome delle persone delle quali si conosce la data di decesso
select p.given_name 
from imdb.person p 
where p.death_date is not null

