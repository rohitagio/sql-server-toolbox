--RUN ENTIRE SCRIPT
DROP TABLE IF EXISTS dbo.fragmented_table --new syntax in SQL 2016!
go
CREATE TABLE dbo.fragmented_table
	(
	fragid uniqueidentifier NOT NULL DEFAULT (newid()),
	fragtext varchar(100) NOT NULL,
	fragtext2 varchar(100) NOT NULL

	)  
GO
ALTER TABLE dbo.fragmented_table ADD CONSTRAINT
	PK_fragmented_table PRIMARY KEY CLUSTERED 
	(
	fragid
	) 
go
CREATE NONCLUSTERED INDEX IDX_NC_fragmented_table
ON dbo.fragmented_table (fragtext) 
 WITH (SORT_IN_TEMPDB = ON	)
GO


--Insert roughly 131072k records

	insert into dbo.fragmented_table ( fragtext, fragtext2) 
	select  replicate(char(round(rand()*100,0)),round(rand()*100,0)), replicate(char(round(rand()*100,0)),round(rand()*100,0))
go
declare @x integer
set @x = 1 
while @x < 19
begin
	insert into dbo.fragmented_table ( fragtext, fragtext2) 
	select replicate(char(round(rand()*100,0)),round(rand()*100,0)), replicate(char(round(rand()*100,0)),round(rand()*100,0))
	from fragmented_table
set @x = @x + 1
end
go

--Add needle to haystack
insert into fragmented_table ( fragtext, fragtext2) values ('aaa','bbb')

select count(1) from dbo.fragmented_table




