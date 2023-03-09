/* 

Data Cleaning in SQL 

*/


Use PortfolioProject


-- Overview of the dataset


SELECT * 
FROM NashvilleHousingData


----------------------------------------------------------------------------------------------------------------------


-- 1. Standardize date format

SELECT SaleDate, CONVERT(date,SaleDate)
FROM NashvilleHousingData

ALTER TABLE NashvilleHousingData
ADD SaleDateConverted Date

UPDATE NashvilleHousingData
SET SaleDateConverted=CONVERT(date,SaleDate)

-- Check if it works
SELECT TOP 5 SaleDateConverted
FROM NashvilleHousingData


----------------------------------------------------------------------------------------------------------------------


-- 2. Populate missing Property Address data

SELECT *
FROM NasHvilleHousingData
WHERE PropertyAddress IS NULL


SELECT ParcelID, PropertyAddress
FROM NashvilleHousingData
ORDER BY ParcelID


SELECT nh1.ParcelId, nh1.PropertyAddress,nh2.ParcelId, nh2.PropertyAddress, 
	   ISNULL(nh1.PropertyAddress,nh2.PropertyAddress)
FROM NashvilleHousingData nh1
JOIN NashvilleHousingData nh2
ON nh1.ParcelID=nh2.ParcelID
And nh1.UniqueID <> nh2.UniqueID
where nh1.PropertyAddress is null


Update nh1
SET PropertyAddress=ISNULL(nh1.PropertyAddress,nh2.PropertyAddress)
From NashvilleHousingData nh1
Join NashvilleHousingData nh2
	On nh1.ParcelID=nh2.ParcelID
	And nh1.UniqueID <> nh2.UniqueID
where nh1.PropertyAddress is null


----------------------------------------------------------------------------------------------------------------------


-- 3. Breaking out the address onto individual columns (Address, City, State)


SELECT PropertyAddress
FROM NashvilleHousingData


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(propertyAddress)) AS City
FROM NashvilleHousingData


ALTER TABLE NashvilleHousingData
ADD PropertySplitAddress Nvarchar(255)


UPDATE NashvilleHousingData
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER TABLE NashvilleHousingData
ADD PropertySplitCity Nvarchar(255)


UPDATE NashvilleHousingData
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(propertyAddress))


SELECT TOP 10 PropertySplitAddress, PropertySplitCity
FROM NashvilleHousingData


----------------------------------------------------------------------------------------------------------------------


--- 4. Splitting the owner address


SELECT OwnerAddress
FROM NashvilleHousingData


SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From NashvilleHousing


ALTER TABLE NashvilleHousingData
ADD OwnerAddressSplit NVARCHAR(255)


UPDATE NashvilleHousingData
SET OwnerAddressSplit=PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE NashvilleHousingData
ADD OwnerCitySplit NVARCHAR(255)


UPDATE NashvilleHousingData
SET OwnerCitySplit=PARSENAME(REPLACE(OwnerAddress,',','.'),2)


ALTER TABLE NashvilleHousingData
ADD OwnerStateSplit NVARCHAR(255)


UPDATE NashvilleHousingData
SET OwnerStateSplit=PARSENAME(REPLACE(OwnerAddress,',','.'),1)


SELECT TOP 10 OwnerAddressSplit, OwnerCitySplit,OwnerStateSplit
FROM NashvilleHousingData


----------------------------------------------------------------------------------------------------------------------


-- 5. Change Y and N to Yes and No in "Sold as Vacant" field


Select distinct(SoldAsVacant), count(SoldAsVacant)
From NashvilleHousingData
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
       CASE When SoldAsVacant='Y' THEN 'Yes'
       When SoldAsVacant='N' THEN 'No'
	   Else SoldAsVacant
	   END
From NashvilleHousingData


Update NashvilleHousingData
SET SoldAsVacant = CASE When SoldAsVacant='Y' THEN 'Yes'
       When SoldAsVacant='N' THEN 'No'
	   Else SoldAsVacant
	   END

-- Check the conversion

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousingData
GROUP BY SoldAsVacant
ORDER BY 2


----------------------------------------------------------------------------------------------------------------------


-- 5. Remove Duplicates using CTE and Window Function

WITH cte AS
(
SELECT *, 
		ROW_NUMBER() OVER (PARTITION BY ParcelID, 
				   PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY UniqueID) as RowNum
FROM NashvilleHousingData
)
SELECT *
FROM cte
WHERE RowNum > 1
ORDER BY PropertyAddress


WITH cte AS
(
SELECT *, 
		ROW_NUMBER() OVER (PARTITION BY ParcelID, 
				   PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY UniqueID) as RowNum
FROM NashvilleHousingData
)
DELETE
FROM cte
WHERE RowNum>1


----------------------------------------------------------------------------------------------------------------------


--- 6. Delete unused columns


ALTER TABLE NashvilleHousingData
DROP COLUMN Owneraddress, TaxDistrict, PropertyAddress, SaleDate

