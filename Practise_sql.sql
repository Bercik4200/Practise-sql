#Problem Statements
#1 Fetch all the paintings which are not displayed on any museum?
select * 
from work 
where museum_id is null;

#Are there museums without any paintings?
select distinct m.museum_id as "all_museum_id", w.museum_id as "musuem_id_with_paintings"
from museum m
cross join work w;
#To zadanie na razie jest błędne 

#3 How many paintings have an asking price of more than their regular price?
Select *
from product_size
where sale_price > regular_price;
#The awnser is 0

#4 Identify the paintings whose asking price is less than 50% of its regular price
Select count(*) 
from product_size
where sale_price < (0.5 * regular_price);
#58 obrazów
#5 which canva size costs the most
Select size_id
from product_size
order by regular_price desc
limit 1; 
#size id 0 

#6 Delete duplicate records from work, product_size, subject and image_link

Delete 
from work
where work_id not in (
select min(work_id)
from work
group by name, artist_id, style
);

#10 Identify the museums which are open on both Sunday and Monday. Display musuem name, city 

/*
Select museum_id
from museum_hours
where day = "Sunday"
union
Select museum_id
from museum_hours
where day = "Monday"
*/
select m.name as museum_name, m.city 
from museum_hours mh1
join museum m on m.museum_id = mh1.museum_id
where day = "Sunday"
and exists (
select 1 from museum_hours mh2 
where mh2.museum_id = mh1.museum_id
and mh2.day = "Monday"
) ;
#Which museum is open for the longest during a day. Dipslay musuem name, state and hours open adn which day?
SELECT m.name as museum_name, m.state, mh.day,
    STR_TO_DATE(open, '%l:%i:%p') AS open_time,
    STR_TO_DATE(close, '%l:%i:%p') AS close_time,
    timediff(STR_TO_DATE(close, '%l:%i:%p'), STR_TO_DATE(open, '%l:%i:%p')) as duration
	FROM museum_hours mh
    join museum m on m.museum_id=mh.museum_id
	order by duration desc;   #Limit 1
    
#Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country.
# If there are multiple value, seperate them with comma.

Select * from (
    Select 'country' as level, country as location, count(1) as total
    from museum
    group by country 
    having count(1) = (
        select max(cnt) 
        from (
            select count(1) as cnt 
            from museum 
            group by country
        ) as max_country
    )

    UNION ALL

    Select 'city' as level, city as location, count(1) as total
    from museum
    group by city 
    having count(1) = (
        select max(cnt) 
        from (
            select count(1) as cnt 
            from museum 
            group by city
        ) as max_city
    )
) as combined_results
order by total desc;