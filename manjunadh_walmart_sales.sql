CREATE DATABASE Manjunadh_sales_walmart;
USE manjunadh_sales_walmart;
CREATE TABLE WALMART_SALES (
	Invoice_id VARCHAR(100),
    Branch VARCHAR(100),
    City VARCHAR(100),
    customer_type VARCHAR (100),
    Gender VARCHAR(100),
    Product_line VARCHAR(100),
    Unit_price DOUBLE,
    Quantity INT,
    VAT DOUBLE,
    Total DOUBLE,
    date  DATE,
    time TIME,
    Payment_methord VARCHAR(100),
    Cogs DOUBLE,
    Gross_margin_percentage DOUBLE,
    Gross_income DOUBLE,
    Rating DOUBLE,
    Day_name VARCHAR(100),
    Month_name VARCHAR(100),
    Year_of_purchase INT(4),
    Hour_of_purchase int(2),
    Time_of_day VARCHAR(100))
    ;
SHOW tables;
SELECT * FROM WALMART_SALES;

###############################################################################################
#PRODUCT_ANALYSIS
##################################################################################################
#Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.

SELECT DISTINCT(Product_line) FROM WALMART_SALES;
#TO HAVE THE DIFFERENT PRODUCT LINE WITH THE WALMART.

SELECT Product_line ,COUNT(*) AS "highest_Performing product_line" FROM WALMART_SALES
GROUP BY Product_line
ORDER BY COUNT(*) DESC
LIMIT 1;
#This query defines the best product_line in walmart 
# It is observed that Fashion and accessories are most sold in walmart with 174 as a count.



SELECT Product_line, COUNT(*) AS "least_performing product_line" FROM  WALMART_SALES
GROUP BY Product_line
ORDER BY COUNT(*)
LIMIT 1;

# Health and beauty are the least performing product lines in walmart with 152 as its count.

###########################################################################################
SELECT * FROM WALMART_SALES;
/******************************
#EXPLORATORY DATA ANALYSIS
/************************/
SELECT City,Branch , COUNT(*) AS Count_branch FROM WALMART_SALES
GROUP BY City
ORDER BY Branch ;
# There are 3 cities named Yangon, Mandalay and Naypyitaw
/************************/
SELECT customer_type , count(*) from WALMART_SALES
GROUP BY customer_type;
# there are 2 types of customers present in the data (members-501, Normal-499)
/************************/
SELECT Gender, COUNT(*) from WALMART_SALES
GROUP BY Gender
ORDER BY COUNT(Gender);
# Females and males are almost in same number with a difference of 2.

#to find Gender based customer_type we use cross tab in pandas 
# pd. crosstab(df["Customer_type", df["Gender"])
/***********Generic Questions********/
#How many unique cities does the data have?
SELECT DISTINCT(City), count(*) FROM WALMART_SALES
GROUP BY City;
/***********Generic Questions********/
# In which city is each branch?
SELECT Branch,City FROM WALMART_SALES
GROUP BY City
ORDER BY Branch;
/***********PRODUCT Questions********/
#.How many unique product lines does the data have?
SELECT COUNT(DISTINCT(Product_line)) AS " No_Unique_product_lines" FROM WALMART_SALES;

#.What is the most common payment method?
SELECT Payment_methord, Count(*)AS "Common_payment_method" FROM WALMART_SALES
GROUP BY Payment_methord
ORDER BY COUNT(*) DESC
LIMIT 1;

#. What is the most selling product line?
WITH LINE AS (
SELECT Product_line , SUM(QUANTITY)AS "Most_selling_product_line" FROM WALMART_SALES
GROUP BY Product_line
ORDER BY COUNT(*) DESC)
SELECT * FROM LINE
 WHERE Most_selling_product_line=(SELECT MAX(Most_selling_product_line) FROM LINE)
;

#What is the total revenue by month?
SELECT Month_name,SUM(Total) AS "Total sales" FROM WALMART_SALES
GROUP BY Month_name
ORDER BY SUM(Total);

# What month had the largest COGS?
WITH LARGE AS (
SELECT Month_name,SUM(Cogs)AS "largest_Cags" FROM WALMART_SALES
GROUP BY Month_name
ORDER BY SUM(Cogs) DESC)
SELECT * FROM LARGE 
WHERE largest_Cags=(SELECT MAX(largest_Cags) FROM LARGE);

SELECT * FROM  WALMART_SALES;

# What product line had the largest revenue?

WITH REVENUE AS (
SELECT PRODUCT_LINE, SUM(TOTAL) AS "MAX_REVENUE" FROM walmart_sales
GROUP BY Product_line
)
SELECT * FROM REVENUE 
WHERE MAX_REVENUE=(SELECT MAX(MAX_REVENUE) FROM REVENUE);

# What is the city with the largest revenue?
SELECT * FROM walmart_sales;
WITH  LARGE_C AS (
SELECT DISTINCT(CITY), SUM(TOTAL) AS"REVENUE"   FROM walmart_sales
GROUP BY CITY)
SELECT * FROM LARGE_C
WHERE REVENUE= (SELECT MAX( REVENUE) FROM LARGE_C);

#What product line had the largest VAT?

WITH  L_VAT AS ( 
SELECT DISTINCT(Product_line), SUM(VAT) AS "Largest_VAT" FROM WALMART_SALES
GROUP BY PRODUCT_LINE)
SELECT * FROM L_VAT 
WHERE Largest_VAT=(SELECT MAX(Largest_VAT) FROM L_VAT);


#Fetch each product line and add a column to those product line showing "Good","Bad". Good if its greaterthan average sales




#hich branch sold more products than average product sold?

with avg_b as (
select branch ,sum( quantity) as "productss" from walmart_sales
group by branch)

SELECT * FROM AVG_B WHERE PRODUCTSS>(
SELECT AVG(PRODUCTSS) AS PRO FROM AVG_B);



# What is the most common product line by gender?
SELECT * FROM walmart_sales;

WITH MALE AS (
SELECT GENDER,Product_line, COUNT(PRODUCT_LINE) AS PRODUCTS FROM walmart_sales
WHERE GENDER="MALE"
GROUP BY Product_line
)
SELECT * FROM MALE 
WHERE PRODUCTS=(SELECT MAX(PRODUCTS) FROM MALE);


WITH FEMALE AS (
SELECT GENDER, Product_line, COUNT(PRODUCT_LINE) AS PRODUCTS FROM walmart_sales
WHERE GENDER="FEMALE"
GROUP BY Product_line
)
SELECT * FROM FEMALE 
WHERE PRODUCTS=(SELECT MAX(PRODUCTS) FROM FEMALE);




# What is the average rating of each product line?
SELECT Product_line, AVG(Rating) AS "Average_rating" FROM WALMART_SALES
GROUP BY Product_line
ORDER BY AVG(Rating);

########################## 		sales analysis     ##################################################

# Number of sales made in each time of the day per weekday

SELECT * FROM walmart_sales;

SELECT Time_of_day,COUNT(Time_of_day) FROM walmart_sales
WHERE Day_name !="SATURDAY" AND Day_name !="SUNDAY"
GROUP BY Time_of_day;


#Which of the customer types brings the most revenue?

WITH REVENUE AS(
SELECT Customer_type ,SUM(Total) AS "Most_revenue" FROM WALMART_SALES
GROUP BY Customer_type
ORDER BY SUM(Total) DESC)
SELECT * FROM REVENUE 
WHERE MOST_REVENUE= (SELECT MAX(MOST_REVENUE) FROM REVENUE);


# Which city has the largest tax percent/ VAT (Value Added Tax)?
WITH VAT_C AS (
SELECT City, SUM(VAT) AS "Largest_VAT_CITY" FROM WALMART_SALES
GROUP BY City
ORDER BY SUM(VAT) DESC	)
SELECT * FROM VAT_C
WHERE Largest_VAT_CITY=(SELECT MAX( Largest_VAT_CITY) FROM VAT_C);


#Which customer type pays the most in VAT?
WITH VAT AS (
SELECT Customer_type,SUM(VAT) AS "Most_VAT_paying_customer_type" FROM WALMART_SALES
GROUP BY Customer_type 
ORDER BY SUM(VAT) DESC)
SELECT * FROM VAT
WHERE Most_VAT_paying_customer_type= (SELECT MAX( Most_VAT_paying_customer_type) FROM VAT);


########################### CUSTOMERS ANALYSIS  ########################################

# How many unique customer types does the data have?
SELECT COUNT(DISTINCT(Customer_type))	AS "Count_of_unique customer_types" FROM WALMART_SALES;
SELECT DISTINCT(Customer_type) AS "unique customer_types" FROM WALMART_SALES;



# How many unique payment methods does the data have?
SELECT COUNT(DISTINCT(Payment_methord)) AS "COunt_of_Unique_payment_methords" FROM WALMART_SALES;
SELECT DISTINCT(Payment_methord) AS "Unique_payment_methords" FROM WALMART_SALES;

# What is the most common customer type?
WITH CUSTOMER AS (
SELECT Customer_type,COUNT(*) AS NO_OF_CUSTOMERS FROM WALMART_SALES
GROUP BY Customer_type 
Order BY COUNT(Customer_type) DESC)
 SELECT * FROM CUSTOMER 
 WHERE  NO_OF_CUSTOMERS=(SELECT MAX( NO_OF_CUSTOMERS) FROM CUSTOMER);


# Which customer type buys the most?
WITH MOST AS (
SELECT Customer_type , COUNT(Invoice_id) AS  NUMB FROM WALMART_SALES
GROUP BY Customer_type
ORDER BY COUNT(Invoice_id) DESC)
SELECT * FROM MOST 
WHERE NUMB=(SELECT MAX(NUMB) FROM MOST); 


#What is the gender of most of the customers?
WITH  MOST1  AS(
SELECT Gender, COUNT(Gender) AS MOST	FROM WALMART_SALES
GROUP BY Gender
)
SELECT * FROM MOST1
WHERE MOST=(SELECT MAX(MOST) FROM MOST1);

/***********************************************************/
#What is the gender distribution per branch?
SELECT DISTINCT(BRANCH)FROM WALMART_SALES
GROUP BY BRANCH ;
/***********************************************************/

#. Which time of the day do customers give most ratings?
WITH RATINGS AS ( 
SELECT Time_of_day , COUNT(Rating) AS"Count_of_Ratings" FROM WALMART_SALES
GROUP BY Time_of_day )
SELECT * FROM RATINGS WHERE Count_of_Ratings=(SELECT MAX(Count_of_Ratings) FROM RATINGS);


# Which time of the day do customers give most ratings per branch?
WITH RATE AS ( 
SELECT TIME_OF_DAY , MAX(RATING) AS MOST_RATINGS  FROM walmart_sales 
GROUP  BY Time_of_day) 
SELECT * FROM  RATE 
WHERE MOST_RATINGS= (SELECT MAX( MOST_RATINGS) FROM RATE);

#Which day of the week has the best avg ratings?
WITH DAYS AS (
SELECT Day_name, AVG(Rating) AS "Average_ratings" FROM WALMART_SALES
GROUP BY Day_name) 
SELECT * FROM DAYS 
WHERE Average_ratings= (SELECT MAX( Average_ratings) FROM DAYS);


#Which day of the week have Best Average rating?
WITH AV AS (
SELECT DISTINCT(Day_name) , AVG(Rating) AS "BEST"
FROM WALMART_SALES
GROUP BY DAY_NAME
)
SELECT * FROM AV 
WHERE BEST=( SELECT MAX( BEST) FROM AV);


/***********ANalysis end here*******/


SELECT DISTINCT(Month_name)	FROM WALMART_SALES;

SELECT Day_name ,COUNT(Invoice_id),Time_of_day
 FROM WALMART_SALES
GROUP BY Day_name
ORDER BY COUNT(Invoice_id)
LIMIT 7;


SELECT Gender,SUM(Total) FROM WALMART_SALES
GROUP BY Gender 
ORDER BY SUM(Total) DESC;

SELECT Gender,AVG(Rating) FROM WALMART_SALES
GROUP BY Gender 
ORDER BY AVG(Rating) DESC;

SELECT Day_name, Time_of_day,COUNT(Invoice_id),SUM(Total),Product_line
 FROM WALMART_SALES
GROUP BY Time_of_day 
ORDER BY Product_line
 DESC;
 SELECT DISTINCT(Product_line) FROM WALMART_SALES;




SELECT Day_name ,Time_of_day ,Product_line, COUNT(Product_line) FROM WALMART_SALES 
GROUP BY Product_line 
ORDER BY COUNT(Product_line) DESC;


SELECT Day_name ,Time_of_day ,Product_line, COUNT(Product_line) FROM WALMART_SALES 
GROUP BY Product_line ;


/**************************************
# My conclusions after looking on the results of the Queries is as follows:
- This data belongs to the sales of the WALMART of 2019 from January to march.
- The whole sales are doens between the !0:00:00 to 23:00:00.
- Based on my Analysis Large number of customer purchases in walmart on saturday afternoon and least no of customers purchases in  walmart on monday evening.
-	Females make more revenue than males.
- The average rating of the walmart of both the males and females are recorded almost same with 6.98, 6.96 respectively.
- Saturday afternoon generates more revenue to the walmart by 439 customers with 146402.67 revenue.
-Saturday and sunday has the major purchases on Health and beauty product lines.
- on the friday moring electronics and accessories have most sales 
- WALMART focusses on the 6 Product lines, all the products are related to these 6 product lines
- Most of the customers use Evallet fot the payment.

/*******	RECOMENDATIONS **************
-	products of health and beauty product lines should br updated on or before Friday
-	To attract large no of customers evolute the marginal discount for the credit card payers
 to maintain the  balance over other payment methords.