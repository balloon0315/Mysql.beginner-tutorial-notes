/* 
This project analyzed data based on Amazon smart product consumer review,  
dataset from kaggle (https://www.kaggle.com/datafiniti/consumer-reviews-of-amazon-products#Datafiniti_Amazon_Consumer_Reviews_of_Amazon_Products_May19.csv)

Questions we try to solve in this project:
1# The most popular products in Amazon.com. And the products with most of low-rating.
2# The relation between the number of reviews and the product-added date.
3# The average rating of each product. And the relation between number of reviews and rating.
4# Deep diving into one specific product, the rating change among different time.
5# wordcloud for positive and negative review using python

Ruixie Fang
--------------------------------------
*/
# drop unnecessary(null-value,repeated) variables
ALTER TABLE `review`
DROP `dateUpdated`,
DROP `primaryCategories`,
DROP `imageURLs`,
DROP `manufacturerNumber`,
DROP `reviews.id`,
DROP `reviews.didPurchase`,
DROP `reviews.doRecommend`,
DROP `reviews.numHelpful`,
DROP `reviews.dateSeen`,
DROP `sourceURLs`;

# check missing values, result=0
select id
from review
where 'name' is null 
   or 'dateAdded' is null
   or 'id' is null 
   or 'asins' is null 
   or 'brand' is null 
   or 'categories' is null 
   or 'keys' is null
   or 'manufacturer' is null
   or 'reviews.date' is null
   or 'reviews.dateSeen' is null
   or 'reviews.rating' is null
   or 'reviews.sourceURLs' is null
   or 'reviews.text' is null
   or 'reviews.title' is null
   or 'reviews.username' is null;
   
#extract date
ALTER TABLE review ADD dateadd VARCHAR(30) NOT null AFTER id; 
UPDATE review SET dateadd = `dateAdded`;
UPDATE review SET dateadd = REPLACE(dateadd,dateadd,SUBSTRING_INDEX(dateadd,'T',1));

ALTER TABLE review ADD reviewdate VARCHAR(30) NOT null AFTER manufacturer; 
UPDATE review SET reviewdate = `reviews.date`;
UPDATE review SET reviewdate = REPLACE(reviewdate,reviewdate,SUBSTRING_INDEX(reviewdate,'T',1));

ALTER TABLE `review`
DROP dateAdded, 
DROP `reviews.date`;

/*1# The most popular products in Amazon.com. 
Due to the limitation of dataset, we assume the standard to judge the popular level based on number of reviews*/

SELECT asins,
count(asins) as numofreview,
CONCAT(ROUND(count(asins)*100/(SELECT count(*) FROM review),2),'%') as percentage
FROM review
GROUP BY asins
ORDER BY numofreview DESC
LIMIT 15; 


/* And the products with most of low-rating. Here we define the low-rating as rating = 1 */
SELECT asins, 
COUNT(asins)
FROM review
WHERE `reviews.rating` = 1
GROUP BY asins
ORDER BY COUNT(asins) DESC
LIMIT 15;

#compare top2 date distribution to analysis the reason.
SELECT reviewdate,
COUNT(reviewdate) as cd1
FROM review
WHERE asins = 'B00QWO9P0O,B00LH3DMUO'
GROUP BY reviewdate
ORDER BY reviewdate;

SELECT reviewdate,
COUNT(reviewdate) as cd2
FROM review
WHERE asins = 'B00QWO9P0O,B01IB83NZG,B00MNV8E0C'
GROUP BY reviewdate
ORDER BY reviewdate;

/*Sorted result based on review number. Following is top2:
The product with #'B00QWO9P0O,B00LH3DMUO' have 8343 reviews, 29.45%.
The product with #'B00QWO9P0O,B01IB83NZG,B00MNV8E0C' have 3728 reviews, 13.16%.
*/

/*2# The relation between the number of reviews and the product-added date.*/

SELECT asins,
MIN(dateadd) as earliest_date,
COUNT(reviewdate) as cd
FROM review
GROUP BY asins
ORDER BY earliest_date;

/*3# The average rating of each product. And the relation between number of reviews and rating.
The product rating have 5 levels :1,2,3,4,5. greater number, higher satisfaction.
And whether the products with greater number of reviews can get higher rating
*/

SELECT asins, 
count(asins) as num_of_review,
avg(`reviews.rating`) as avg_rate
FROM review 
GROUP BY asins
ORDER BY num_of_review DESC;

/*4# Deep diving into one specific product, the rating change among different time.
Here, we choose the product with #'B00QWO9P0O,B00LH3DMUO'
*/
SELECT asins,`reviews.rating`,
count(asins) as num_of_rate,
CONCAT(ROUND(count(asins)*100/(SELECT count(asins) FROM review WHERE asins = 'B00QWO9P0O,B00LH3DMUO'),2),'%') as percentage
FROM review 
WHERE asins = 'B00QWO9P0O,B00LH3DMUO'
GROUP BY `reviews.rating`
ORDER BY `reviews.rating` DESC;

SELECT reviewdate, avg(`reviews.rating`) as avg_rate 
FROM review
GROUP BY reviewdate
ORDER BY reviewdate;


