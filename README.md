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

Output:

![image](https://user-images.githubusercontent.com/121368375/223908497-77e14c62-32d3-4059-a555-69c6d82163dd.png)

### 2.	Populate the missing property address data
On querying the following statement:

![image](https://user-images.githubusercontent.com/121368375/223908584-ca33a492-161f-440c-a3bf-8600f92ed3b5.png)

Output:

![image](https://user-images.githubusercontent.com/121368375/223908635-e5f76fbf-798d-40bc-841a-0e0f40992162.png)

We can spot that many values in ‘PropertyAddress’ column are null/missing.
But when we take a closer look at the ParcelID as follow:

![image](https://user-images.githubusercontent.com/121368375/223908687-d7aed6f0-75ae-465b-a25c-bdbd15ff5bcb.png)

Output:

![image](https://user-images.githubusercontent.com/121368375/223908725-2e994f9b-6a12-4f70-a8d7-5b97d024a01f.png)

It is apparent from the results of above query that when ParcelID’s are the same, PropertyAddress’s are also same with each other. For instance, observe the row 44&45, 57&58, and 61&62. Hence, we can use the ParcelID column as a reference to populate the missing values in the PropertyAddress column.
To implement this, we essentially need to query such that if ParcelID = ParcelID and UniqueID <> UniqueID and PropertyAddress is missing, populate the PropertyAddress.

Let’s try our query first:

![image](https://user-images.githubusercontent.com/121368375/223908803-76451be5-a022-43f9-a519-ea884c8c8b00.png)

Output:

![image](https://user-images.githubusercontent.com/121368375/223908844-222f791b-39b7-4eec-b786-8383c3829c3a.png)

The query works!
Now, update the PropertyAddress column.

![image](https://user-images.githubusercontent.com/121368375/223908882-26f08f1c-e1ec-4685-9fa2-5bc3a852ef95.png)

### 3.	Parsing the long-formatted address into separate columns (Address, City, State)
The PropertyAddress column contains Address of the property, City in which it exists. We need to standardize it by splitting them into three separate columns. This can be done in two steps:
1.	Create new columns for Address, City and State.
2.	Update the columns.
Query:

![image](https://user-images.githubusercontent.com/121368375/223908997-aeffa399-8477-43f1-bc44-23fe3a387f3c.png)

Output:
 
 ![image](https://user-images.githubusercontent.com/121368375/223909140-c0abec30-8965-4c92-be9e-808b519e4d83.png)
 
Similarly, the OwnerAddress column constitute of Address, City and State. We should split them to three separate columns to make data easier to read. Same steps as PropertyAddress can be implemented for OwnerAddress parsing.
Query:
 
 ![image](https://user-images.githubusercontent.com/121368375/223909169-55f8e868-3048-48dd-b942-15fe630fc600.png)

Output:
 
![image](https://user-images.githubusercontent.com/121368375/223909190-5c6f91ea-fb72-40a2-959d-eab3172bd537.png)
 
### 4.	Standardizing “SoldAsVacant” field 
In SoldAsVacant field, we have four categorical variables – Y, N, Yes, No. 

Query:
 
 ![image](https://user-images.githubusercontent.com/121368375/223909218-2d92ec50-c31e-485a-8f79-aec18419dede.png)

Output:

![image](https://user-images.githubusercontent.com/121368375/223909235-d7be5d1a-8552-420c-a3a4-2659ec8ce074.png)
 
Replacing Y and N with Yes and No because Y and N are used as abbreviations. It can be done using CASE statement.
Query:
 
 ![image](https://user-images.githubusercontent.com/121368375/223909284-7c92cfdb-7c18-45dc-9fbd-0fa8e935a93a.png)

Output:

![image](https://user-images.githubusercontent.com/121368375/223909305-752900d0-715a-4c8c-8fb7-b47b068faf90.png)
 
### 5.	Removing the duplicates
To remove the duplicates, I have considered that if ParcelID, PropertyAddress, SalePrice, SaleDate, and LegalRefernce are the same, it is duplicated.
I have used CTE and window function ROW_NUMBER() to separate records into groups based on the above mentioned conditions. 

Query:
 
 ![image](https://user-images.githubusercontent.com/121368375/223909332-082a27d1-cf5b-48a1-bbf1-a68ac09a35de.png)

Output:

![image](https://user-images.githubusercontent.com/121368375/223909360-1e7fdc23-37d2-400f-b7b8-3d28b7befd7a.png)
 
RowNum field having value greater than 1 indicates that record has been duplicated. Delete the duplicates from the table. 

Query:
 
  ![image](https://user-images.githubusercontent.com/121368375/223909381-9c4a7653-a271-4300-aaac-0bdd76f4d8f0.png)
  
### 6.	Deleting the extra columns
There are few columns which we have recreated into multiple separate columns such as OwnerAddress and PropertyAddress. Moreover, SaleDate column has also been recreated to standardize the date format. Therefore, original columns can be deleted from the table.

Query:
 
![image](https://user-images.githubusercontent.com/121368375/223909444-aadac84a-ea53-47a6-8831-2879bd4fa886.png)



