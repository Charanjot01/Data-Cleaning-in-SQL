# Nashville Housing Data Cleaning 
## About the project
In this project, I have cleaned the Nashville Housing data using SQL. The dataset is taken from Kaggle and has 56,000+ rows. The tasks performed to clean the data are following:
1.	Standardize the sales date format.
2.	Populate the missing property address data.
3.	Parsing the long-formatted address into separate columns (Address, City, State)
4.	Standardize “Sold as Vacant” field (from Y/N to Yes/No)
5.	Removing the duplicate values
6.	Deleting extra columns
## Overview of the dataset
Query:

![image](https://user-images.githubusercontent.com/121368375/223907750-efbe806c-ee52-4f7b-b09e-a2ba38270957.png)

Output:

![image](https://user-images.githubusercontent.com/121368375/223907797-a24eaf2a-c27b-4263-a463-bca3c050f625.png)

### 1.	Standardize the date format
The ‘SaleDate’ column contains date and time stamp, and its format is YYYY-MM-DD HH:MM:SS. However, the values of  HH:MM:SS are all 0, therefore, changing the date format to YYYY-MM-DD using CONVERT() function.
Query:

![image](https://user-images.githubusercontent.com/121368375/223907978-97f1b936-8795-41aa-a663-765685438871.png)

