/* 
Cleaning Data in SQL Queries

*/

SELECT *
FROM PortfolioProject..NashvilleHousing;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------




-- Standardize Date Format

SELECT Improved_SaleDate, CONVERT(Date,SaleDate2)
FROM PortfolioProject..NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD Improved_SaleDate Date;

UPDATE NashvilleHousing
SET Improved_SaleDate = CONVERT(Date,SaleDate2)


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------






-- Populate property address data 

SELECT  PropertyAddress
FROM PortfolioProject..NashvilleHousing
-- WHERE PropertyAddress IS NULL
ORDER BY ParcelID;


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;


------------------------------------------------------------------------------------------------------------------------------------------------------------------------







-- Breaking out Address into individual columns (Address, City, State)


SELECT  PropertyAddress
FROM PortfolioProject..NashvilleHousing
-- WHERE PropertyAddress IS NULL
-- ORDER BY ParcelID;

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) AS Address
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET PropertySplitCity =SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
FROM PortfolioProject..NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255)

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

SELECT * 
FROM PortfolioProject..NashvilleHousing

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------







-- Change Y and N to Yes and No in "Sold as Vacant" Field

SELECT DISTINCT(SoldASVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant);



SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No' 
		ELSE SoldAsVacant
		END
FROM PortfolioProject..NashvilleHousing;

UPDATE NashvilleHousing 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No' 
		ELSE SoldAsVacant
		END
FROM PortfolioProject..NashvilleHousing;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------





-- Remove Duplicates
 
WITH RowNumCTE AS(
 SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 LegalReference
					ORDER BY ParcelID
					) row_num
 FROM PortfolioProject..NashvilleHousing
 ) 
 DELETE  
 FROM RowNumCTE
 WHERE row_num > 1
 -- ORDER BY PropertyAddress;

WITH RowNumCTE AS(
SELECT *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SaleDate,
				 LegalReference
					ORDER BY ParcelID
					) row_num
 FROM PortfolioProject..NashvilleHousing
 ) 
SELECT *
 FROM RowNumCTE
 WHERE row_num > 1
 -- ORDER BY PropertyAddress;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------




 -- Delete Unused Columns

 ALTER TABLE PortfolioProject..NashvilleHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress;

 SELECT * 
 FROM  PortfolioProject..NashvilleHousing;

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SalesDate2, SaleDate2;

SELECT * 
FROM  PortfolioProject..NashvilleHousing;

