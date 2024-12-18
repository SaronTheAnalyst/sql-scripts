
--standardize data format
select saledateConverted, CONVERT(Date,saledate)
from PortfolioProject.dbo.NahvileHousing

Alter table NahvileHousing
Add SaleDateConverted Date

update NahvileHousing
SET SaledateConverted = Convert(date,saledate)

--populate property address data

select *
from PortfolioProject.dbo.NahvileHousing
order by ParcelID
where propertyaddress is NULL

select A.ParcelID, A.Propertyaddress, B.ParcelID, B.Propertyaddress, ISNULL(A.Propertyaddress, B.Propertyaddress)
from PortfolioProject.dbo.NahvileHousing A
JOIN PortfolioProject.dbo.NahvileHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID] <> B.[UniqueID]
where A.Propertyaddress is NULL

update A
set Propertyaddress = ISNULL(A.Propertyaddress, B.Propertyaddress)
from PortfolioProject.dbo.NahvileHousing A
JOIN PortfolioProject.dbo.NahvileHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID] <> B.[UniqueID]
where A.Propertyaddress is NULL

--Breakingout address into individual columns(address, city, state)

select Propertyaddress
from PortfolioProject.dbo.NahvileHousing
--order by ParcelID
--where propertyaddress is NULL

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) as Address
from PortfolioProject.dbo.NahvileHousing

Alter table NahvileHousing
Add PropertysplitAddress Varchar(255)

update NahvileHousing
SET PropertysplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter table NahvileHousing
Add PropertysplitCity Varchar(255)

update NahvileHousing
SET PropertysplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress))


select *
from PortfolioProject.dbo.NahvileHousing


Select OwnerAddress
from PortfolioProject.dbo.Nahvilehousing


select
ParseName(replace(OwnerAddress,',', '.'), 3)
,ParseName(replace(OwnerAddress,',', '.'), 2)
,ParseName(replace(OwnerAddress,',', '.'), 1)
from PortfolioProject.dbo.Nahvilehousing


Alter table NahvileHousing
Add OwnersplitAddress Varchar(255)

update NahvileHousing
SET OwnersplitAddress = ParseName(replace(OwnerAddress,',', '.'), 3)

Alter table NahvileHousing
Add OwnersplitCity Varchar(255)

update NahvileHousing
SET OwnersplitCity = ParseName(replace(OwnerAddress,',', '.'), 2)


Alter table NahvileHousing
Add Ownersplitstate Varchar(255)

update NahvileHousing
SET Ownersplitstate = ParseName(replace(OwnerAddress,',', '.'), 1)


--change Y and N to YES AND no IN "sold as Vacant" field


select distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.Nahvilehousing
Group By SoldAsVacant
order by 2

alter table NahvileHousing
alter column SoldAsVacant varchar(50)

select SoldAsVacant
, case when SoldAsVacant = '1' then 'Yes'
when SoldAsVacant = '0' then 'NO'
else SoldAsVacant 
end
from PortfolioProject.dbo.Nahvilehousing

update NahvileHousing
SET SoldAsVacant = case when SoldAsVacant = '1' then 'Yes'
when SoldAsVacant = '0' then 'NO'
else SoldAsVacant 
end

--remove duplicates

with RowNumCTE As(
select *,
     ROW_NUMBER() over(
     Partition by ParcelID,
                  propertyaddress,
                  SalePrice,
                  LegalReference
Order by 
UniqueID
) ROW_NUM
from PortfolioProject.dbo.Nahvilehousing
--Order by ParcelID
)
Delete
from RowNumCTE
where row_num > 1 
--order by Propertyaddress

--delete unused columns

select *
from PortfolioProject.dbo.Nahvilehousing


alter table PortfolioProject.dbo.Nahvilehousing
drop column Owneraddress, TaxDistrict, Propertyaddress

alter table PortfolioProject.dbo.Nahvilehousing
drop column Saledate