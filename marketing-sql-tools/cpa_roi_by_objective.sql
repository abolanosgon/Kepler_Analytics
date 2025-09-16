/*
Basic description:
- Goal: show KPIs by objective.
- Data: campaigns + ad_stats (join on campaign_id).
- Filter: only rows where spend_usd > 0.
- Nulls: revenue_usd NULL counted as 0; NULLIF avoids divide-by-zero.
- Outputs per objective: total_revenue_usd, total_spend_usd, total_conversions,
  CPA (spend/conversions, 2 decimals), ROI% ((revenue-spend)/spend*100, 2 decimals).
- Order: ROI descending, then CPA ascending.
*/

SELECT 
  c.objective,
  SUM(IFNULL(a.revenue_usd, 0)) AS total_revenue_usd,
  SUM(a.spend_usd) AS total_spend_usd,
  SUM(a.conversions) AS total_conversions,
  ROUND(SUM(a.spend_usd) / NULLIF(SUM(a.conversions), 0), 2) AS cpa,
  ROUND( (SUM(IFNULL(a.revenue_usd,0)) - SUM(a.spend_usd)) / NULLIF(SUM(a.spend_usd),0) * 100, 2) AS roi
FROM campaigns c 
JOIN ad_stats a 
  ON c.campaign_id = a.campaign_id
WHERE a.spend_usd IS NOT NULL
  AND a.spend_usd > 0
GROUP BY c.objective
ORDER BY roi DESC, cpa ASC;


