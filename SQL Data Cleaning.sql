/* Cleaning Data in SQL Queries */

SELECT *
FROM dbo.NashvilleDataCleaning

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Standardize Date Format and Drop Column */

SELECT SaleDate, CONVERT (Date, SaleDate) AS SalesDate
FROM dbo.NashvilleDataCleaning

ALTER TABLE NashVilleDataCleaning
ADD SalesDate Date

UPDATE NashvilleDataCleaning
SET SalesDate = CONVERT (Date, SaleDate)

ALTER TABLE NashVilleDataCleaning
DROP COLUMN SaleDate

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Populate Property Address */

SELECT a.ParcelID, b.ParcelID, a.PropertyAddress, b.PropertyAddress, ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM NashvilleDataCleaning.dbo.NashvilleDataCleaning a
JOIN NashvilleDataCleaning.dbo.NashvilleDataCleaning b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL (a.PropertyAddress, b.PropertyAddress)
FROM NashvilleDataCleaning.dbo.NashvilleDataCleaning a
JOIN NashvilleDataCleaning.dbo.NashvilleDataCleaning b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Breaking Out Address into individual Columns (Address, City, State) */

SELECT PropertyAddress
FROM NashvilleDataCleaning

SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1) AS Address
,SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM NashvilleDataCleaning

ALTER TABLE NashVilleDataCleaning
ADD PropertySplitAddress NVARCHAR (255)

UPDATE NashvilleDataCleaning
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX (',', PropertyAddress) -1)

ALTER TABLE NashVilleDataCleaning
ADD PropertySplitCity NVARCHAR (255)

UPDATE NashvilleDataCleaning
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX (',', PropertyAddress) +1, LEN(PropertyAddress))

ALTER TABLE NashVilleDataCleaning
DROP COLUMN ProperySplitCity, ProperySplitAddress

SELECT OwnerAddress
FROM NashvilleDataCleaning

SELECT
PARSENAME (REPLACE (OwnerAddress, ',', '.') , 3)
, PARSENAME (REPLACE (OwnerAddress, ',', '.') , 2)
, PARSENAME (REPLACE (OwnerAddress, ',', '.') , 1)
FROM NashvilleDataCleaning

ALTER TABLE NashVilleDataCleaning
ADD OwnerSplitAddress NVARCHAR (255)

UPDATE NashvilleDataCleaning
SET OwnerSplitAddress = PARSENAME (REPLACE (OwnerAddress, ',', '.') , 3)

ALTER TABLE NashVilleDataCleaning
ADD OwnerSplitCity NVARCHAR (255)

UPDATE NashvilleDataCleaning
SET OwnerSplitCity = PARSENAME (REPLACE (OwnerAddress, ',', '.') , 2)

ALTER TABLE NashVilleDataCleaning
ADD OwnerSplitState NVARCHAR (255)

UPDATE NashvilleDataCleaning
SET OwnerSplitState = PARSENAME (REPLACE (OwnerAddress, ',', '.') , 1)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Change Y and N to Yes and No in "Sold as Vacant" field */

SELECT DISTINCT (SoldAsVacant), COUNT (SoldAsVacant)
FROM NashvilleDataCleaning
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleDataCleaning

UPDATE NashvilleDataCleaning
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Remove Duplicates */

WITH RowNumCTE AS (
sELECT *,
	ROW_NUMBER () OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SalesDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) RowNumber
FROM NashvilleDataCleaning
)
SELECT *
FROM RowNumCTE
WHERE RowNumber > 1

-------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Delete Unused Columns */

ALTER TABLE NashvilleDataCleaning
DROP COLUMN PropertyAddress, OwnerAddress