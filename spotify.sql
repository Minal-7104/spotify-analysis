--SPOTIFY ANALYSIS PROJECT
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--ELEBORATORY DATA ANALYSIS 
select count(*)
from spotify;

select count( distinct artist) 
	from spotify ;

select  distinct album_type
	from spotify ;

select  max(duration_min)
	from spotify ;

select  min(duration_min)
	from spotify ;


select *from spotify 
	where duration_min=0;

delete from spotify
where duration_min=0;

select distinct channel
	from spotify ;

-- EASY CATEGORY

--Retrieve the names of all tracks that have more than 1 billion streams.
select *from spotify
	where stream >1000000000;

--List all albums along with their respective artists.
select distinct album,artist
	from spotify
order by 1;

--Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comments from spotify
	where licensed ='true';
	
--Find all tracks that belong to the album type single.
select track from spotify
	where album_type ='single';

--Count the total number of tracks by each artist.
select artist,
	count(*)as total_song 
from spotify
group by artist
order by 2 ;

-- MEDIUM CATEGORY
--Calculate the average danceability of tracks in each album.
Select 
	album, 
	avg(danceability)as avg_danceability 
from spotify
group by 1
order by 2 asc;

--Find the top 5 tracks with the highest energy values.
Select 
	track, 
	max(energy) 
from spotify
group by 1
order by 2 asc
limit 5;

--List all tracks along with their views and likes where official_video = TRUE.
Select 
	track, 
	sum( views) as total_view,
	sum(likes) as total_like
from spotify
where official_video = TRUE
group by 1
order by 2 desc

--For each album, calculate the total views of all associated tracks.

Select
	album,
	track, 
	sum( views) as total_view
from spotify
group by 1,2
	
--Retrieve the track names that have been streamed on Spotify more than YouTube.
select *from 
	(Select 
	track ,
	--most_played_on,
	coalesce(sum(case when most_played_on= 'Youtube'then stream END),0) as stream_on_youtube,
	coalesce(sum(case when most_played_on= 'Spotify'then stream END),0) as stream_on_spotify
	from spotify
	group by 1
)as t1
where stream_on_spotify >stream_on_youtube
	and
	stream_on_youtube<>0

--ADVANCED CATEGORY
--Find the top 3 most-viewed tracks for each artist using window functions.
with ranking_artist as (
    select 
        artist,
        track,
        sum(views) as total_views,
        dense_rank() over (partition by artist order by sum(views) desc) as rank
    from spotify
    group by artist, track
)
select * 
from ranking_artist
where rank <= 3
order by artist, total_views desc;


--Write a query to find tracks where the liveness score is above the average.
select
	track,
	artist,
	liveness  
	from spotify
	where liveness > (select avg(liveness) from spotify)

--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with cte as (
    select 
        album,
        max(energy) as highest_energy,
        min(energy) as lowest_energy
    from spotify
    group by 1
)
select 
    album,
    highest_energy - lowest_energy as energy_diff
from cte
order by 2 desc;





