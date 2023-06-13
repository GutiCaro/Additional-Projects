--Cleaning Dataset containing Nashville Housing Info 

 --populate property address data
 
select *
FROM Nashville
--WHERE propertyaddress is NULL
order by parcelid;

select a.parcelid, a.propertyaddress, b.parcelid,  b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress)
FROM Nashville a
JOIN Nashville b
on a.parcelid = b.parcelid
AND a.[uniqueid] <> b.[uniqueid]
WHERE a.propertyaddress is NULL

update a
SET propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
FROM Nashville a
JOIN Nashville b
on a.parcelid = b.parcelid
AND a.[uniqueid] <> b.[uniqueid]
WHERE a.propertyaddress is NULL;

--Separate address into individual columns (address, city, state).
--Raw data has city right after address, seperated by a comma.

SELECT SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address
, SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress)) as City
FROM nashville

--create columns for the address and city 
ALTER TABLE Nashville 
ADD PropertyAddressSplit NVARCHAR(255)

ALTER TABLE nashville 
add PropertyCity NVARCHAR (255)

--add the info into the columns
update Nashville
SET PropertyAddressSplit = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1)

update Nashville
SET PropertyCity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) +1, LEN(propertyaddress)) 

--Same as above, with owner address (make address and city separate columns),but using parsename 
--PARSENAME function finds punctutations (periods or commas) 
Select owneraddress
from Nashville 

select 
PARSENAME (REPLACE(OwnerAddress,',', '.'), 1),
PARSENAME (REPLACE(OwnerAddress,',', '.'), 2),
PARSENAME (REPLACE(OwnerAddress,',', '.'), 3)
FROM [Nashville]

ALTER TABLE Nashville
ADD owneraddy NVARCHAR (255)

ALTER TABLE Nashville
ADD ownercity NVARCHAR (255)

ALTER TABLE Nashville
ADD ownerState NVARCHAR (255)

UPDATE Nashville
SET owneraddy = PARSENAME (REPLACE(OwnerAddress,',', '.'), 3)

UPDATE Nashville
SET ownercity = PARSENAME (REPLACE(OwnerAddress,',', '.'), 2)

UPDATE Nashville
SET ownerState = PARSENAME (REPLACE(OwnerAddress,',', '.'), 1)


--Change "Y" and "N" to "Yes" and "No" in soldasvacant Column 

select distinct (soldasvacant) FROM [Nashville] 

Select soldasvacant,
 CASE WHEN soldasvacant = 'Y' THEN 'Yes'
        WHEN soldasvacant = 'N' THEN 'No'
    ELSE soldasvacant
    END
FROM Nashville

UPDATE nashville 
SET soldasvacant = CASE WHEN soldasvacant = 'Y' THEN 'Yes'
        WHEN soldasvacant = 'N' THEN 'No'
    ELSE soldasvacant
    END
FROM Nashville

SELECT Distinct(soldasvacant), COUNT(soldasvacant)
FROM Nashville
GROUP BY soldasvacant 
Order by 2

--Delete Unused Columns 

Select * 
FROM Nashville 

ALTER TABLE Nashville
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict
