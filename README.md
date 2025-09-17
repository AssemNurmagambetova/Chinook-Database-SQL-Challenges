# Chinook Database SQL Challenges

This repository contains my solutions to a series of SQL challenges using the **Chinook database**, a sample database representing a digital media store.

The purpose of this project is to showcase my proficiency in SQL, demonstrating key skills such as:

  * **Data Retrieval**: Basic `SELECT` queries with `WHERE` and `ORDER BY`.
  * **Data Aggregation**: Using `GROUP BY` with functions like `SUM()`, `COUNT()`, and `AVG()`.
  * **Joins**: Combining data from multiple tables.
  * **Subqueries and CTEs**: Using nested queries and Common Table Expressions to solve complex problems.
  * **Window Functions**: Applying advanced functions like `RANK()` for data analysis.

-----

## Solved Challenges

### Q1: Customers from the USA

**Objective**: Retrieve the first name, last name, and country of all customers from the USA.

```sql
Select FirstName, LastName, Country from customer
where country = 'USA';
```

### Q2: Invoices for 2012

**Objective**: Retrieve all invoices from the year 2021.

```sql
Select * from invoice
where year(InvoiceDate) = 2021;
```

### Q3: Rock Tracks

**Objective**: Retrieve the names of all tracks in the "Rock" genre.

```sql
select t.name name_of_track, g.name rock_genre from track t
join genre g 
on t.GenreId=g.GenreId
where g.name = 'Rock';
```

### Q4: Tracks per Album

**Objective**: For each album, count the number of tracks and display the album's title and the total count.

```sql
select a.title album_title, count(t.AlbumId) total_tracks from album a
left join track t
on a.AlbumId=t.AlbumId
group by a.AlbumId
order by total_tracks desc;
```

### Q5: Total Spending per Customer

**Objective**: Calculate the total amount spent by each customer. Display the customer's full name and their total spending, sorted in descending order.

```sql
select concat(c.firstname,' ', c.lastname) name, sum(i.total) total_spending
from customer c 
join invoice i 
on c.CustomerId=i.CustomerId 
group by name
order by total_spending desc;
```

### Q6: Most Popular Genre per City

**Objective**: For each city, determine the most popular genre based on the number of tracks sold.

```sql
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
```

### Q7: Best-Selling Artist

**Objective**: Find the artist whose tracks have been sold in the highest quantity. Display the artist's name and the total number of tracks sold.

```sql
select a.name, sum(il.quantity) as total_sold_tracks
from artist a
join album al on a.ArtistId=al.ArtistId
join track t on al.AlbumId=t.AlbumId
join invoiceline il on t.TrackId=il.TrackId
group by a.name
order by total_sold_tracks desc
limit 1;
```

### Q8: Customers Who Spent More Than the Average

**Objective**: Find the names of customers whose total spending exceeds the average spending of all customers.

```sql
select concat(c.firstname, ' ', c.lastname) as customer_name, sum(i.total) as total_sales from customer c
join invoice i on 
c.customerId=i.CustomerId
group by customer_name
having total_sales > (select avg(total) as avg_sales from invoice);
```

### Q9: Repeat Customers

**Objective**: Find all customers who have made more than one order.

```sql
select concat(c.firstname, ' ', c.lastname) as customer_name, count(i.InvoiceId) as total_orders from customer c
join invoice i on 
c.customerId=i.CustomerId
group by customer_name
having total_orders>1;
```

### Q10: Top Artist per Country

**Objective**: For each country, find the artist with the highest sales volume. Display the country, the artist's name, and the sales volume.

```sql
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
```
