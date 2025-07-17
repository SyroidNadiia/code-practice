select * from global_unemployment_data g  limit 100;
select * from unemployment_rate u   limit 100;

--Get the unemployment rate among females aged 15–24 in Ukraine for the year 2019
select 
	country_name 
	, indicator_name 
	, sex
	, year_2019 
from global_unemployment_data g
where country_name = 'Ukraine'
	and sex = 'Female'
	and age_group = '15-24';


--Compare the unemployment rate among females aged 15–24 across all countries in the year 2019. Display the results in descending order.
select 
	country_name 
	, indicator_name 
	, sex
	, year_2019 
from global_unemployment_data g
where sex = 'Female'
	and age_group = '15-24'
order by year_2019 desc;
	


--Compare the unemployment rate between females and males aged 15–24 in Ukraine in 2019. 
select 
	country_name 
	, indicator_name 
	, sex
	, year_2019 
from global_unemployment_data g
where country_name = 'Ukraine'
	and age_group = '15-24';



--Find the 10 countries with the lowest unemployment rate among youth aged 15–24, regardless of gender, in the year 2019.
select 
	country_name 
	, AVG(year_2019) AS avg_unemployment_2019
from global_unemployment_data g
where age_group = '15-24'
group by country_name
order by avg_unemployment_2019
limit 10;


--Find the average youth unemployment rate (ages 15–24) for females in European countries in 2019. Show the country, the average value, and sort in descending order.
select 
	country_name 
	, AVG(year_2019 * 1.0) AS avg_unemployment_2019
from global_unemployment_data g
where age_group = '15-24'
	and sex = 'Female'
	and country_name in ( 'Albania', 'Andorra', 'Armenia', 'Austria', 'Azerbaijan', 'Belarus',
    'Belgium', 'Bosnia and Herzegovina', 'Bulgaria', 'Croatia', 'Cyprus',
    'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 'Georgia',
    'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland', 'Italy', 'Kazakhstan',
    'Kosovo', 'Latvia', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Malta',
    'Moldova, Republic of', 'Monaco', 'Montenegro', 'Netherlands', 'North Macedonia',
    'Norway', 'Poland', 'Portugal', 'Romania', 'San Marino',
    'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland',
    'Turkey', 'Ukraine', 'United Kingdom')
group by 1
order by 2 desc;




--10 countries with the highest unemployment rates among men aged 15–24 in Europe in 2024
select 
	country_name 
	, year_2024
from global_unemployment_data g
where age_group = '15-24'
	and sex = 'Male'
	and country_name in ( 'Albania', 'Andorra', 'Armenia', 'Austria', 'Azerbaijan', 'Belarus',
    'Belgium', 'Bosnia and Herzegovina', 'Bulgaria', 'Croatia', 'Cyprus',
    'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 'Georgia',
    'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland', 'Italy', 'Kazakhstan',
    'Kosovo', 'Latvia', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Malta',
    'Moldova, Republic of', 'Monaco', 'Montenegro', 'Netherlands', 'North Macedonia',
    'Norway', 'Poland', 'Portugal', 'Romania', 'San Marino',
    'Serbia', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland',
    'Turkey', 'Ukraine', 'United Kingdom')
    and year_2024 is not null
order by year_2024 desc
limit 10;



--Show the 5 countries with the lowest unemployment rate in 2022 among females aged 15–24, worldwide.

select 
	country_name 
	, year_2022
from global_unemployment_data g
where age_group = '15-24'
	and sex = 'Female'
order by year_2022
limit 5;




--Find the 10 countries with the largest gender gap in youth unemployment (ages 15–24) in 2024. Show the absolute difference between male and female unemployment rates.
with unemployment_female as (
	select 
		country_name 
		, sex
		, year_2024 as female_u
	from global_unemployment_data g
	where age_group = '15-24'
		and sex = 'Female'
),
unemployment_male as (
	select 
		country_name 
		, sex
		, year_2024 as male_u
	from global_unemployment_data g
	where age_group = '15-24'
		and sex = 'Male'
)
select 
	m.country_name
	, abs(m.male_u - f.female_u) as gender_gap
from unemployment_male m
join unemployment_female f on m.country_name = f.country_name
where m.male_u is not null
	and f.female_u is not null
order by gender_gap desc 
limit 10;




--Find the 10 countries with the biggest decrease or increase in the gender gap in youth unemployment (ages 15–24) between 2010 and 2024.
-- Show the difference between the gender gap in 2010 and in 2024 (gap_2024 - gap_2010). Sort the result by absolute change descending.

with unemployment_female as (
	select 
		country_name 
		, sex
		, year_2014 as f_2014
		, year_2024 as f_2024
	from global_unemployment_data g
	where age_group = '15-24'
		and sex = 'Female'
),
unemployment_male as (
	select 
		country_name 
		, sex
		, year_2014 as m_2014
		, year_2024 as m_2024
	from global_unemployment_data g
	where age_group = '15-24'
		and sex = 'Male'
)
select 
	m.country_name
	, (m.m_2014 - f.f_2014) as gap_2014
	, (m.m_2024 - f.f_2024) as gap_2024
	, ((m.m_2024 - f.f_2024) - (m.m_2014 - f.f_2014)) as gap_change
	, case 
		when ((m.m_2024 - f.f_2024) - (m.m_2014 - f.f_2014)) > 0 then 'Increase'
		when ((m.m_2024 - f.f_2024) - (m.m_2014 - f.f_2014)) < 0 then 'Decrease'
		else 'No change'
	end as trends
from unemployment_male m
join unemployment_female f on m.country_name = f.country_name
where m.m_2014 is not null 
	and m.m_2024 is not null
	and f.f_2014 is not null
	and f.f_2024 is not null
order by ((m.m_2024 - f.f_2024) - (m.m_2014 - f.f_2014))  desc 
limit 10;



--Detect сountries with Gпender parity in youth unemployment (2024)
with unemployment_female as (
	select 
		country_name 
		, sex
		, year_2014 as f_2014
		, year_2024 as f_2024
	from global_unemployment_data g
	where age_group = '15-24'
		and sex = 'Female'
),
unemployment_male as (
	select 
		country_name 
		, sex
		, year_2014 as m_2014
		, year_2024 as m_2024
	from global_unemployment_data g
	where age_group = '15-24'
		and sex = 'Male'
)
select 
	m.country_name
	, m.m_2024
	, f.f_2024
	, (m.m_2024 - f.f_2024) as gap_2024
from unemployment_male m
join unemployment_female f on m.country_name = f.country_name
where m.m_2014 is not null 
	and m.m_2024 is not null
	and abs(m.m_2024 - f.f_2024) < 0.1



