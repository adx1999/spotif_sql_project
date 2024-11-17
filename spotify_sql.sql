--create table
create table spotify (

	Artist varchar(300),
	Track 	varchar(300),
	Album   varchar(300),
	Album_type varchar(70),
	Danceability float,
	Energy float,
	Loudness float,
	Speechiness float,
	Acousticness float,
	Instrumentalness float,
	Liveness float,
	Valence float,
	Tempo float,
	Duration_min float,
	Title varchar(270),
	Channel varchar(270),
	Views float,
	Likes bigint,
	Comments bigint,
	Licensed boolean,
	official_video boolean,
	Stream	bigint,
	EnergyLiveness float,
	most_playedon varchar(50)

);

select * from spotify;

--EDA 

select count(*) from spotify;
select count(Track) from spotify;

select max(Danceability) from spotify;
select count(Valence) from spotify;   
select * from spotify
where Duration_min = 0;
delete  from spotify
where Duration_min = 0;
select distinct most_playedon from spotify;

------------------------------------------
-- DATA ANALYSIS
------------------------------------------
/*
Easy Level
Retrieve the names of all tracks that have more than 1 billion streams.
List all albums along with their respective artists.
Get the total number of comments for tracks where licensed = TRUE.
Find all tracks that belong to the album type single.
Count the total number of tracks by each artist.

*/

-- Q1. Retrieve the names of all tracks that have more than 1 billion streams.


select track
from spotify
where stream > 1000000000;

-- Q2.List all albums along with their respective artists.


select album,artist
from spotify;

-- Q3. Get the total number of comments for tracks where licensed = TRUE.


select 
 sum(comments)as total_comments
from spotify
where licensed = 'true';

-- Q4.Find all tracks that belong to the album type single.

select * from spotify;
select track,album_type
from spotify
where album_type = 'single';


-- Q5.Count the total number of tracks by each artist.


select artist, count(track) as total_track
from spotify
group by artist;

/*
Medium Level
Calculate the average danceability of tracks in each album.
Find the top 5 tracks with the highest energy values.
List all tracks along with their views and likes where official_video = TRUE.
For each album, calculate the total views of all associated tracks.
Retrieve the track names that have been streamed on Spotify more than YouTube.
*/

-- Q6. Calculate the average danceability of tracks in each album.

select  album,avg(danceability) as total_avg
from spotify
group by album;

--Q7.Find the top 5 tracks with the highest energy values.


select track , max(energy) total_max
from spotify
group by track
order by total_max desc
limit 5;

-- Q8.List all tracks along with their views and likes where official_video = TRUE.


select track,
sum(views) as total_views,
sum(likes) as total_likes
from spotify
where official_video = 'true'
group by track;

-- Q9.For each album, calculate the total views of all associated tracks.

select album,track, sum(views) as total_views
from spotify
group by album,track;

--Q10.Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from spotify;
select * from (
select track,
   coalesce(sum(case when most_playedon = 'Spotify' then stream end),0) as stream_on_spotify,
   coalesce(sum(case when most_playedon = 'Youtube' then stream end),0) as stream_on_youtube
from spotify
group by track
) as t1
where stream_on_spotify > stream_on_youtube
 and 
 stream_on_youtube <> 0;

/*
 Advanced Level
Find the top 3 most-viewed tracks for each artist using window functions.
Write a query to find tracks where the liveness score is above the average.
Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
Find tracks where the energy-to-liveness ratio is greater than 1.2.

*/

--Q10. Find the top 3 most-viewed tracks for each artist using window functions.
select * from
(
select 
 artist,
 track,
 sum(views) as most_view,
 dense_rank() over(partition by artist order by sum(views) desc) as total_rank
 from spotify
 group by 1,2
 ) as t1
 where total_rank<=3;
 
--Q11.Write a query to find tracks where the liveness score is above the average.

select track,liveness
from spotify
where liveness >(select avg(liveness) as total_avg from spotify);

--Q12.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with diff
as
(
select
album,
max(energy) as highest_energy,
min(energy) as lowest_energy
from spotify
group by album
)

select album,
highest_energy- lowest_energy as energy_difference
from diff
order by 2 desc;





--Q13.Find tracks where the energy-to-liveness ratio is greater than 1.2.
select * from
(
select track,
sum(energy)/sum(liveness) as ratio_
from spotify
group by track
) as t1
where ratio_ >1.2;



