
-- Q1: retrieve USA customers FirstName, LastName, Country 
Select FirstName, LastName, Country from customer
where country = 'USA';

-- Q2: retrieve all invoices for 2021
Select * from invoice
where year(InvoiceDate) = 2021;

-- Q3: retrieve the names of all tracks in the "Rock" genre
select t.name name_of_track, g.name rock_genre from track t
join genre g 
on t.GenreId=g.GenreId
where g.name = 'Rock';

-- Q4: for each album, count the number of tracks and show the album's name and the total count.
select a.title album_title, count(t.AlbumId) total_tracks from album a
left join track t
on a.AlbumId=t.AlbumId
group by a.AlbumId
order by total_tracks desc;

-- Q5: the total amount spent by each customer. Display the customer's name and their total spending, sorted in descending order
select concat(c.firstname,' ', c.lastname) name, sum(i.total) total_spending
from customer c 
join invoice i 
on c.CustomerId=i.CustomerId 
group by name
order by total_spending desc;

-- Q6: For each city, determine the most popular genre based on the number of tracks sold
with CityGenre as (Select c.city, g.name, sum(il.quantity) as total_sales from customer c
left join invoice i on c.CustomerId=i.CustomerId
left join invoiceline il on i.InvoiceId=il.InvoiceId
left join track t on il.TrackId=t.TrackId
left join genre g on t.GenreId=g.GenreId
group by c.city, g.name), 
RankedSales as (select city, name, total_sales,
rank() over (partition by city order by total_sales desc) as ranked from CityGenre)
select city, name, total_sales
from RankedSales
where ranked = 1;

-- Q7: Best-Selling Artists: Find the artists whose tracks have been sold in the highest quantity.
--  Display the artist's name and the number of tracks sold.
select a.name, sum(il.quantity) as total_sold_tracks
from artist a
join album al on a.ArtistId=al.ArtistId
join track t on al.AlbumId=t.AlbumId
join invoiceline il on t.TrackId=il.TrackId
group by a.name
order by total_sold_tracks desc
limit 1;

-- Q8: Customers who spent more than the average: 
-- Find the names of customers whose total spending exceeds the average spending of all customers.
select concat(c.firstname, ' ', c.lastname) as customer_name, sum(i.total) as total_sales from customer c
join invoice i on 
c.customerId=i.customerId
group by customer_name
having total_sales > (select avg(total) as avg_sales from invoice);

-- Q9: Repeat Customers: Find the customers who have made more than one order.
select concat(c.firstname, ' ', c.lastname) as customer_name, count(i.InvoiceId) as total_orders from customer c
join invoice i on 
c.customerId=i.customerId
group by customer_name
having total_orders>1;

-- Q10: Sales Ranking by Country: For each country, find the artist with the highest sales volume. 
-- Display the country, the artist's name, and the sales volume. 
with TopCountryArtist as (Select c.country, ar.name, sum(il.quantity) as total_sales from customer c
left join invoice i on c.CustomerId=i.CustomerId
left join invoiceline il on i.InvoiceId=il.InvoiceId
left join track t on il.TrackId=t.TrackId
left join album al on t.AlbumId=al.AlbumId
left join artist ar on al.ArtistId=ar.ArtistId
group by c.country, ar.name), 
RankedSales as (select country, name, total_sales,
rank() over (partition by country order by total_sales desc) as ranked from TopCountryArtist)
select country, name, total_sales
from RankedSales
where ranked = 1;