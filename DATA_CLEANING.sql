----------------------------------------------------------------------Cleaning Data Using sql--------------------------------------------------------------------------------

--slaeDate transformation

select SaleDate from dbo.Sheet1$

ALTER TABLE dbo.Sheet1$    ADD  Transformed_SaleDate date;

update dbo.Sheet1$
set Transformed_SaleDate = convert(date, SaleDate)

ALTER TABLE dbo.Sheet1$   drop column SaleDate ;

select * from dbo.Sheet1$


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--populating  propertyAddress


select a.parcelID,a.PropertyAddress,b.parcelID,b.PropertyAddress,isnull(b.PropertyAddress,a.PropertyAddress) 
from dbo.Sheet1$ a
inner join dbo.Sheet1$ b
on a.parcelID=b.parcelID
and a.[UniqueID ]!=b.[UniqueID ]
where b.PropertyAddress is null


update b
set PropertyAddress = isnull(b.PropertyAddress,a.PropertyAddress)
from dbo.Sheet1$ a
inner join dbo.Sheet1$ b
on a.parcelID=b.parcelID
and a.[UniqueID ]!=b.[UniqueID ]
where b.PropertyAddress is null

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- breaking PropertyAddress into address and city 

select PropertyAddress from dbo.Sheet1$

select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from dbo.Sheet1$



ALTER TABLE dbo.Sheet1$    ADD AddressOfPropeerty   varchar(255);

update dbo.Sheet1$
set AddressOfPropeerty = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE dbo.Sheet1$    ADD CityOfProperty   varchar(255);

update dbo.Sheet1$
set CityOfProperty = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select * from dbo.Sheet1$



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--breaking ownerAddress


select OwnerAddress from dbo.Sheet1$

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)as Address ,
PARSENAME(REPLACE(OwnerAddress,',','.'),2)as City ,
PARSENAME(REPLACE(OwnerAddress,',','.'),1)as State 
from dbo.Sheet1$

ALTER TABLE dbo.Sheet1$    ADD AddressOfOwner   varchar(255);

update dbo.Sheet1$
set AddressOfOwner = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE dbo.Sheet1$    ADD CityOfOwner  varchar(255);

update dbo.Sheet1$
set CityOfOwner = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE dbo.Sheet1$    ADD StateOfOwner  varchar(255);

update dbo.Sheet1$
set StateOfOwner = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select * from dbo.Sheet1$


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--changing values of Y and N to Yes and No--


select distinct(SoldAsVacant) ,count(SoldAsVacant)
from dbo.Sheet1$
group by SoldAsVacant

update dbo.Sheet1$
set SoldAsVacant=Case 
	when SoldAsVacant='Y' then 'Yes'
	when SoldAsVacant='N' then 'No'  
	else SoldAsVacant
End 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- removing deuplicates --


with temp as (
select *,
row_number() over (partition by ParcelID,PropertyAddress,SalePrice,Transformed_SaleDate,LegalReference order by uniqueID ) row_num
from dbo.Sheet1$)
select * from temp where row_num>1
order by PropertyAddress

select * from dbo.Sheet1$


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--deleting unused columns--


select * from dbo.Sheet1$

alter table dbo.Sheet1$
drop column PropertyAddress,OwnerAddress,TaxDistrict





---------------------------------------------------------------------------THE-END---------------------------------------------------------------------------------------------------