/*
Basic description:
- Goal: KPIs by campaign (CTR, CPC, CPA, ROAS).
- Data: campaigns + ad_stats (join on campaign_id).
- Filter: include only rows with spend_usd > 0.
- Nulls: revenue_usd NULL treated as 0; NULLIF avoids divide-by-zero.
- Output per campaign: total_impressions, total_clicks, total_conversions,
  total_spend_usd, total_revenue_usd, ctr (4d), cpc (2d), cpa (2d), roas (2d).
- Order: ROAS descending, then CPA ascending.
*/


select
	c.campaign_name,
    sum(a.impressions) as total_impressions,
    sum(a.clicks) as total_clicks,
    sum(a.conversions) as total_conversions,
    sum(a.spend_usd) as total_spend_usd,
    sum(ifnull(a.revenue_usd,0)) as total_revenue_usd,
    round(sum(a.clicks)/nullif(sum(a.impressions),0),4) as ctr,
    round(sum(a.spend_usd)/nullif(sum(a.clicks),0),2) as cpc,
    round(sum(a.spend_usd)/nullif(sum(a.conversions),0),2) as cpa,
    round(sum(a.revenue_usd)/nullif(sum(a.spend_usd),0),2) as roas
from campaigns c 
join ad_stats a 
	on c.campaign_id = a.campaign_id 
where a.spend_usd is not null
	and a.spend_usd > 0
group by c.campaign_name
order by roas DESC, cpa ASC;