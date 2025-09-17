/*
Basic description:
- Goal: country-level KPIs (CR, CPA, CPM, ROAS).
- Data: campaigns + ad_stats (join on campaign_id).
- Filter: include only rows with spend_usd > 0.
- Nulls: revenue_usd NULL treated as 0 in totals; NULLIF prevents divide-by-zero.
- Output per country: total_impressions, total_conversions, total_spend_usd,
  total_revenue_usd, cr (4d), cpa (2d), cpm (2d), roas (2d).
- Order: ROAS descending, then CPA ascending.
*/


SELECT
  c.country,
  SUM(a.impressions)  AS total_impressions,
  SUM(a.conversions)  AS total_conversions,
  SUM(a.spend_usd)    AS total_spend_usd,
  SUM(IFNULL(a.revenue_usd, 0)) AS total_revenue_usd,
  ROUND(SUM(a.conversions) / NULLIF(SUM(a.impressions), 0), 4)       AS cr,
  ROUND(SUM(a.spend_usd) / NULLIF(SUM(a.conversions), 0), 2)         AS cpa,
  ROUND(SUM(a.spend_usd) / NULLIF((SUM(a.impressions) / 1000), 0), 2) AS cpm,
  ROUND(SUM(IFNULL(a.revenue_usd,0)) / NULLIF(SUM(a.spend_usd), 0), 2) AS roas
FROM campaigns c 
JOIN ad_stats a
  ON c.campaign_id = a.campaign_id
WHERE a.spend_usd IS NOT NULL
  AND a.spend_usd > 0
GROUP BY c.country
ORDER BY roas DESC, cpa ASC;
