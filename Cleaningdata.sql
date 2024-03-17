SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[NashvilleHousing]


  select SaleDateConverted , CONVERT (Date, SaleDate) as Datewewant
  from PortfolioProject.dbo.NashvilleHousing

  update NashvilleHousing
  set SaleDate= CONVERT(Date,SaleDate)

  ALTER TABLE Nashvillehousing
  Add SaleDateConverted Date 

  update NashvilleHousing
  set SaleDateConverted= CONVERT(Date,SaleDate)



  --populate property addressd ddata

  select a.ParcelID, a.PropertyAddress , b.ParcelID , b.PropertyAddress , ISNULL(a.PropertyAddress, b.PropertyAddress)
  
  from NashvilleHousing a 
  JOIN NashvilleHousing b
--  where PropertyAddress is NULL
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 


update b
SET PropertyAddress = ISNULL(b.PropertyAddress, a.PropertyAddress)

from NashvilleHousing a 
  JOIN NashvilleHousing b
--  where PropertyAddress is NULL
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where b.PropertyAddress is null 


select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing

select 
SUBSTRING ( PropertyAddress , 1 , CHARINDEX (',',PropertyAddress) -1 ) as Address ,
SUBSTRING ( PropertyAddress , CHARINDEX (',',PropertyAddress) +1  , LEN (PropertyAddress) ) as Address 
from PortfolioProject.dbo.NashvilleHousing


select PropertyAddress ,  PropertySplitAddress ,  PropertySplitCity , LEN (PropertyAddress)
from NashvilleHousing

  ALTER TABLE Nashvillehousing
  Add PropertySplitAddress Nvarchar(255)

  update NashvilleHousing
  set PropertySplitAddress= SUBSTRING ( PropertyAddress , 1 , CHARINDEX (',',PropertyAddress) -1 )

    ALTER TABLE Nashvillehousing
    Add PropertySplitCity Nvarchar(255)

  update NashvilleHousing
  set PropertySplitCity= SUBSTRING ( PropertyAddress , CHARINDEX (',',PropertyAddress) +1  , LEN (PropertyAddress) )



  select ownerAddress from PortfolioProject.dbo.NashvilleHousing


  select 
  PARSENAME (REPLACE(ownerAddress , ',' , '.') , 1) ,
    PARSENAME (REPLACE(ownerAddress , ',' , '.') , 2) ,
	  PARSENAME (REPLACE(ownerAddress , ',' , '.') , 3) 
  from NashvilleHousing

    ALTER TABLE NashvilleHousing
    Add OwnerSplitCity Nvarchar(255);

  update NashvilleHousing
  set OwnerSplitCity = PARSENAME (REPLACE(ownerAddress , ',' , '.') , 2)

      ALTER TABLE Nashvillehousing

    Add OwnerSplitCity Nvarchar(255)

  ALTER TABLE Nashvillehousing
  Add OwnerSplitAddress Nvarchar(255)

  update NashvilleHousing
  set OwnerSplitAddress= PARSENAME (REPLACE(ownerAddress , ',' , '.') , 3)

    ALTER TABLE Nashvillehousing
  Add OwnerSplitState Nvarchar(255)

  update NashvilleHousing
  set OwnerSplitState=  PARSENAME (REPLACE(ownerAddress , ',' , '.') , 1)


 select OwnerSplitAddress , OwnerSplitCity , OwnerSplitState from NashvilleHousing

 select Distinct (SoldAsVacant) ,  count (SoldAsVacant)
  from NashvilleHousing
  group by SoldAsVacant
 order by 2 

 select SoldAsVacant
 , Case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		End
	from NashvilleHousing


Update NashvilleHousing
set  SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
		End
	from NashvilleHousing



	--Remove Duplicates

With rownumcte As (
	select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				SalePrice,
				Saledate,
				legalReference
				Order by uniqueID
	) row_num
	from NashvilleHousing
	)
	select * from rownumcte where row_num > 1 order by PropertyAddress
	--DELETE from rownumcte where row_num > 1


--Deletere unused columns 

select * from NashvilleHousing

Alter table NashvilleHousing
DROP column SaleDate