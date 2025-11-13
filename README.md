Google Sheets formulas and functions were utilized to update the Music Store CSV Files. The spreadsheet file does not contain many of the formulas and functions due to the fact that these files 
had to be reformatted and cleaned to be import-ready into SQL database 

Album csv
- Ordered title of albums based on album_id in ascending order
- Used conditional formatting to identify any duplicates; almost every album_id number had a duplicate except for the last number 
- Recreated album_id number so each number is unique
- removed any unnecessary whitespace in album names

Artist_id
- used conditional formatting to find any duplicate artist_ids and names 
- essentially, any ids that require distinct ids used conditional formatting to find any duplicates

For Any Dates
- Generally, the dates in the files were formatted as the following 'mm-dd-yyyy 00:00:00'
- Used Find and Replace to remove the timestamp
- First used DATEVALUE() to convert strings into dates 
- I realized that some strings couldn't be identified correctly (still maintained the 'mm-dd-yyy' format, creating different formats of dates 
- To solve this problem, split the string using SPLIT(Cell Value,"-")
- After split, used TO_DATE() to convert the cells into a date, DD/MM/YYYY

Invoice
- Dublin was perceived as a state, it is not
- Used conditional formatting to find any duplicates of Ireland in the billing_country column, used Find and Replace to remove Dublin in billing_state column
- The same process was used for any sheets containing a billing_state

I used POSTGRESQL to compete the SQL queries. Some of the functions used: cte queries, subqueries, inner joins, aggregate functions, Group By, Order By.
I developed a script to update tables - removing existing tables and create a table with columns, ready to re-import csv files
Under the SQL Scripts Folder, I added txt files of my SQL coding to make it easier for viewing purposes

Two screenshots were taken of the Power BI dashboard. It is not published to Power BI service because I do not want to pay for the pricing plan at the moment. The dashboard is a visualization of the SQL query returns. The SQL data into PowerBI utilized the Direct Query method. Real time updates will occur once tables in the SQL database are updated. The first screenshot shows the original returns from the SQL query. In the second screenshot, you'll notice that the billing city with the highest invoice total has changed to Mountain Views. A pbix file is also uploaded.

My own thoughts: It is pretty cool how I can visualize SQL returns differently using Power BI and the returns will update using the Direct Query Method. It is my first time using Power BI and it's awesome.
