with cte1 as (select substring(`date`, 1,7) as new_date, sum(total_laid_off) as sum_total_laid_off  from layoffs_staging2
where substring(`date`, 1,7) is not null
group by 1 order by 1)
select *, sum(sum_total_laid_off) over(order by new_date)as rolling_total from cte1;

 with cte1 as (select company, sum(total_laid_off) as total_off, year(`date`) as years from layoffs_staging2
 group by company, years), 
 cte2 as ( select *, dense_rank() over(partition by years order by total_off desc ) as ranking from cte1
 where years is not null),
 cte3 as (select * from cte2 where ranking <= 5)
 select * from cte3;
 
with cte1 as (select industry, sum(total_laid_off) as total_off, year(`date`) as years from layoffs_staging2
 group by industry, years),
 cte2 as (select *, dense_rank() over(partition by years order by total_off desc) as ranking from cte1
 where years is not null),
 cte3 as (select * from cte2 where ranking <= 5)
 select * from cte3;
 
with cte1 as (select location, sum(total_laid_off) as total_off, year(`date`) as years from layoffs_staging2
group by 1,3),
cte2 as (select *, dense_rank() over(partition by years order by total_off desc) as ranking from cte1
where years is not null),
cte3 as (select * from cte2 where ranking <= 5)
select * from cte3;
 
 with cte1 as (select country, sum(total_laid_off) as total_off, year(`date`) as years from layoffs_staging2
 group by country, years),
 cte2 as (select *, dense_rank() over (partition by years order by total_off desc ) as ranking from cte1
where years is not null ),
cte3 as(select * from cte2
where ranking <= 5)
select * from cte3;

with cte1 as (select company, location, industry, sum(total_laid_off) total_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
from layoffs_staging2
group by company, location, industry, percentage_laid_off, `date`, stage, country, funds_raised_millions),
cte2 as (select *, dense_rank() over(order by total_off desc) as ranking from cte1)
select * from cte2 where ranking <= 5;


 
 
 
 
 
 
 
 
 
 
 
 
 
 