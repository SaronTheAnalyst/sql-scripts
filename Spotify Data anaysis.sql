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

-- EDA

select COUNT(*) FROM spotify;

select count(distinct artist) from spotify;

select count(distinct album) from spotify;

select distinct album_type from spotify;

select min(duration_min) from spotify;

select min(duration_min) from spotify;

select * from spotify
where duration_min = 0

-- Delete duration min, because it is not possible to have a view and no duration_min

delete from spotify
where duration_min = 0;

select * from spotify
where duration_min = 0;

select distinct channel from spotify;

select distinct most_played_on from spotify;

----------------------------------
-- Data analysis - easy catagorie
-----------------------------------

-- Retrieving all names of tracks that have more than billion streams 

select * from spotify
where stream > 1000000000;

-- lsiting all the albums with their respective artists

select Distinct album, artist 
from spotify
order by 1;

-- total number of comments for tracks where licensed = True

select sum(comments) as total_comment from spotify
where licensed = 'true';

-- All tracks that belong to the album type single.

select * from spotify
where album_type = 'single';

-- Counting the total number of tracks by each artist.

select Distinct artist, count(track) as total_track from spotify
group by artist
order by 1

-------------------------------------
-- Data Analysis - Medium Catrgories
--------------------------------------

-- creating average Daceability of tracks in each album

select album, avg(danceability) from spotify
group by 1
order by 2 DESC

-- Finding the top 5 traks with the highest energy

select track, max(energy) from spotify
group by track
order by 2 DESC
limit 5

-- List all tracks along with their views and likes where official_video = TRUE.

select track, sum(views) as total_views, sum(likes) as total_likes from spotify
where official_video = 'True'
group by track 
order by 1

-- For each album, calculate the total views of all associated tracks.

select album, track, sum(views) from spotify
group by 1,2
order by 3 DESC

-- Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM
(SELECT track,
 COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as stream_on_youtube,
 COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as stream_on_spotify    
FROM spotify
GROUP BY track) AS t1
where stream_on_spotify > stream_on_youtube
       and stream_on_youtube <> 0

-----------------------------------
-- Data analysis - Advanced Categorie
-----------------------------------

-- Finding the top 3 most-viewed tracks for each artist using window functions.
-- first each artists and total view for each track
-- second track with highest view for each artist (we need top 3)
-- third dense rank
-- cte and filter rank <= 3


select * from
(select artist, 
       track, 
	   sum(views) as total_view,
	   DENSE_RANK() over(partition by artist order by sum(views)DESC) AS rank
from spotify
group by 1,2
order by 1,3 DESC) as t2
 where rank <= 3

-- Write a query to find tracks where the liveness score is above the average.

select
     track,
	 artist,
	 liveness
from spotify
where liveness > (select avg(liveness) from spotify)

-- Using a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC

-- Finding tracks where the energy-to-liveness ratio is greater than 1.2.

select track, (sum(energy) / sum(liveness) )as energy_to_liveness from spotify
group by track
having (sum(energy) / sum(liveness) ) > 1.2

-- Calculating the cumulative sum of likes for tracks ordered by the number of views, using window functions.


select sum(likes) as total_likes, track 
from 
    (select * from spotify
	 order by views DESC) as t3
group by 2



















































