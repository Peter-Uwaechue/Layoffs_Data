create table layoffs_staging
like layoffs;

insert into layoffs_staging
select * from layoffs;

with cte1 as (
select *, row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num from layoffs_staging)
select * from cte1 where row_num > 1 ;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL, `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffs_staging2
select *, row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num from layoffs_staging;

delete from layoffs_staging2 where row_num > 1 ;

update layoffs_staging2
set company = trim(company);

update layoffs_staging2 set industry = 'crypto' where industry like 'crypto%';

set sql_safe_updates = 0;
update layoffs_staging2 set country = trim(trailing '.' from country)
where country like 'united states%';

Update layoffs_staging2 set `date` = str_to_date(`DATE`, '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;

update layoffs_staging2 set industry = null where industry = '';

update layoffs_staging2 l1
join layoffs_staging2 l2
on l1.company = l2.company 
set l1.industry = l2.industry
where l1.industry is null
and l2.industry is not null;

delete from layoffs_staging2  where percentage_laid_off is null and total_laid_off is null;

alter table layoffs_staging2
drop column row_num;
