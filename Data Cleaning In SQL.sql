/* 

Data Cleaning in SQL 

*/


Use PortfolioProject


SELECT * 
FROM NashvilleHousing

----------------------------------------------------------------------------------------------------------------------

-- 1. Standardize date format

Select SaleDate, CONVERT(date,SaleDate)
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add SalesDateConverted Date

Update NashvilleHousing
Set SalesDateConverted=CONVERT(date,SaleDate)


----------------------------------------------------------------------------------------------------------------------


-- 2. Populate missing Property Address data


Select *
From NashvilleHousing 
Order by ParcelID


Select nh1.ParcelId, nh1.PropertyAddress,nh2.ParcelId, nh2.PropertyAddress, ISNULL(nh1.PropertyAddress,nh2.PropertyAddress)
From NashvilleHousing nh1
Join NashvilleHousing nh2
On nh1.ParcelID=nh2.ParcelID
And nh1.UniqueID <> nh2.UniqueID
where nh1.PropertyAddress is null


Update nh1
SET PropertyAddress=ISNULL(nh1.PropertyAddress,nh2.PropertyAddress)
From NashvilleHousing nh1
Join NashvilleHousing nh2
	On nh1.ParcelID=nh2.ParcelID
	And nh1.UniqueID <> nh2.UniqueID
where nh1.PropertyAddress is null


----------------------------------------------------------------------------------------------------------------------


-- 3. Breaking out the address onto individual columns (Address, City, State)


SELECT PropertyAddress
FROM NashvilleHousing


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(propertyAddress)) AS City
FROM NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255)


Update NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


Alter Table NashvilleHousingProject
Add PropertySplitCity Nvarchar(255)


Update NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(propertyAddress))


----------------------------------------------------------------------------------------------------------------------


--- 4. Splitting the owner address


Select OwnerAddress
From NashvilleHousing


SELECT
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From NashvilleHousing


Alter table NashvilleHousing
Add OwnerAddressSplit NVARCHAR(255)


Update NashvilleHousing
Set OwnerAddressSplit=PARSENAME(Replace(OwnerAddress,',','.'),3)


Alter table NashvilleHousing
Add OwnerCitySplit NVARCHAR(255)


Update NashvilleHousing
Set OwnerCitySplit=PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter table NashvilleHousing
Add OwnerStateSpilt NVARCHAR(255)


Update NashvilleHousing 
Set OwnerStateSpilt=PARSENAME(Replace(OwnerAddress,',','.'),1)

-
----------------------------------------------------------------------------------------------------------------------


-- 5. Change Y and N to Yes and No in "Sold as Vacant" field


Select distinct(SoldAsVacant), count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant='Y' THEN 'Yes'
       When SoldAsVacant='N' THEN 'No'
	   Else SoldAsVacant
	   END
From NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant='Y' THEN 'Yes'
       When SoldAsVacant='N' THEN 'No'
	   Else SoldAsVacant
	   END


----------------------------------------------------------------------------------------------------------------------


-- 5. Remove Duplicates

With cte as
(
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY ParcelID, 
				   PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY UniqueID) as RowNum
FROM NashvilleHousing
)
Delete
From cte
Where RowNum>1


--- 6. Delete unused columns


ALTER TABLE NashvilleHousingProject
DROP COLUMN Owneraddress, TaxDistrict, PropertyAddress, SaleDate


SELECT *
FROM NashvilleHousing