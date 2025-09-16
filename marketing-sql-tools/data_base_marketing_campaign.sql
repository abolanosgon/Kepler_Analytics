-- Drop and create database
DROP DATABASE IF EXISTS marketing_sql_tools;
CREATE DATABASE marketing_sql_tools
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE marketing_sql_tools;

-- Disable FK checks to drop in correct order
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS ad_stats;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS platforms;
SET FOREIGN_KEY_CHECKS = 1;

-- =========================
-- 1) Tables
-- =========================
-- Platforms master table
CREATE TABLE platforms (
  platform_id   TINYINT UNSIGNED PRIMARY KEY,
  platform_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Campaigns table
CREATE TABLE campaigns (
  campaign_id   VARCHAR(20)  PRIMARY KEY,
  campaign_name VARCHAR(100) NOT NULL,
  platform_id   TINYINT UNSIGNED NOT NULL,
  objective     ENUM('Purchases','Leads','Reach') NOT NULL,
  start_date    DATE NOT NULL,
  end_date      DATE NOT NULL,
  country       CHAR(2),
  CONSTRAINT fk_campaign_platform
    FOREIGN KEY (platform_id) REFERENCES platforms(platform_id)
) ENGINE=InnoDB;

-- Daily ad stats table
CREATE TABLE ad_stats (
  stat_id       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  campaign_id   VARCHAR(20) NOT NULL,
  stat_date     DATE NOT NULL,
  impressions   INT UNSIGNED,
  clicks        INT UNSIGNED,
  conversions   INT UNSIGNED,
  spend_usd     DECIMAL(12,2),
  revenue_usd   DECIMAL(12,2),
  PRIMARY KEY (stat_id),
  KEY idx_campaign_date (campaign_id, stat_date),
  KEY idx_date (stat_date),
  CONSTRAINT fk_adstats_campaign
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
) ENGINE=InnoDB;

-- =========================
-- 2) Platforms data (5)
-- =========================
INSERT INTO platforms (platform_id, platform_name) VALUES
  (1, 'Meta'),
  (2, 'Google'),
  (3, 'LinkedIn'),
  (4, 'TikTok'),
  (5, 'X');

-- =========================
-- 3) Campaigns data (20)
-- =========================
INSERT INTO campaigns (campaign_id, campaign_name, platform_id, objective, start_date, end_date, country) VALUES
('META-C1','Back to School Shoes',1,'Purchases','2025-08-15','2025-09-30','CR'),
('META-C2','LeadGen Newsletter',1,'Leads','2025-09-01','2025-09-30','CR'),
('META-C3','Retargeting Q3',1,'Purchases','2025-09-01','2025-09-30','CR'),
('META-C4','Brand Awareness Fall',1,'Reach','2025-09-05','2025-09-30','CR'),

('GGL-C1','Search Running Shoes',2,'Purchases','2025-08-20','2025-09-30','CR'),
('GGL-C2','Display Branding',2,'Reach','2025-09-01','2025-09-30','CR'),
('GGL-C3','YouTube Pre-Roll',2,'Purchases','2025-09-05','2025-09-30','CR'),
('GGL-C4','Search Smart Bidding',2,'Leads','2025-09-03','2025-09-30','CR'),

('LNK-C1','InMail B2B SaaS',3,'Leads','2025-09-05','2025-09-25','CR'),
('LNK-C2','Sponsored Content HR',3,'Reach','2025-09-02','2025-09-30','CR'),
('LNK-C3','Lead Gen Form SaaS',3,'Leads','2025-09-04','2025-09-30','CR'),
('LNK-C4','Recruiting Tech Talent',3,'Leads','2025-09-05','2025-09-30','CR'),

('TTK-C1','Spark Ads New Launch',4,'Purchases','2025-09-01','2025-09-30','CR'),
('TTK-C2','Hashtag Challenge',4,'Reach','2025-09-03','2025-09-30','CR'),
('TTK-C3','Branded Effects',4,'Reach','2025-09-04','2025-09-30','CR'),
('TTK-C4','Retargeting Conversions',4,'Purchases','2025-09-06','2025-09-30','CR'),

('X-C1','Awareness Launch',5,'Reach','2025-09-01','2025-09-30','CR'),
('X-C2','Click-to-Website Ads',5,'Purchases','2025-09-05','2025-09-30','CR'),
('X-C3','Lead Ads New Product',5,'Leads','2025-09-06','2025-09-30','CR'),
('X-C4','Engagement Boost',5,'Reach','2025-09-03','2025-09-30','CR');

-- =========================
-- 4) Daily stats (60 rows)
-- 3 days per campaign
-- =========================
INSERT INTO ad_stats (campaign_id, stat_date, impressions, clicks, conversions, spend_usd, revenue_usd) VALUES
-- Day 1: 2025-09-10
('META-C1','2025-09-10',12000,480,42,360.00,1200.00),
('META-C2','2025-09-10',5000,150,25,100.00,NULL),
('META-C3','2025-09-10',8000,320,28,240.00,1100.00),
('META-C4','2025-09-10',15000,200,0,180.00,0.00),
('GGL-C1','2025-09-10',15000,600,50,500.00,2000.00),
('GGL-C2','2025-09-10',40000,120,0,200.00,0.00),
('GGL-C3','2025-09-10',13000,520,40,420.00,1500.00),
('GGL-C4','2025-09-10',9000,310,20,180.00,600.00),
('LNK-C1','2025-09-10',3000,45,8,180.00,900.00),
('LNK-C2','2025-09-10',4500,70,0,150.00,0.00),
('LNK-C3','2025-09-10',3200,60,10,190.00,700.00),
('LNK-C4','2025-09-10',2800,55,9,160.00,640.00),
('TTK-C1','2025-09-10',14000,500,44,360.00,1250.00),
('TTK-C2','2025-09-10',25000,150,0,170.00,0.00),
('TTK-C3','2025-09-10',27000,180,0,190.00,0.00),
('TTK-C4','2025-09-10',10000,400,35,280.00,980.00),
('X-C1','2025-09-10',20000,100,0,120.00,0.00),
('X-C2','2025-09-10',11000,430,37,350.00,1180.00),
('X-C3','2025-09-10',8000,300,22,210.00,750.00),
('X-C4','2025-09-10',15000,200,0,150.00,0.00),

-- Day 2: 2025-09-11
('META-C1','2025-09-11',13000,520,48,375.00,1350.00),
('META-C2','2025-09-11',5200,140,20,95.00,400.00),
('META-C3','2025-09-11',8200,300,26,230.00,1000.00),
('META-C4','2025-09-11',15500,250,0,190.00,0.00),
('GGL-C1','2025-09-11',16000,640,52,520.00,2100.00),
('GGL-C2','2025-09-11',38000,110,0,190.00,0.00),
('GGL-C3','2025-09-11',13500,540,42,430.00,1580.00),
('GGL-C4','2025-09-11',9500,320,24,190.00,720.00),
('LNK-C1','2025-09-11',3100,40,7,175.00,840.00),
('LNK-C2','2025-09-11',4600,80,0,155.00,0.00),
('LNK-C3','2025-09-11',3300,65,12,195.00,740.00),
('LNK-C4','2025-09-11',2850,58,10,165.00,660.00),
('TTK-C1','2025-09-11',14200,510,45,370.00,1300.00),
('TTK-C2','2025-09-11',26000,160,0,175.00,0.00),
('TTK-C3','2025-09-11',27500,190,0,195.00,0.00),
('TTK-C4','2025-09-11',10200,410,36,285.00,1020.00),
('X-C1','2025-09-11',21000,120,0,130.00,0.00),
('X-C2','2025-09-11',11200,440,38,355.00,1200.00),
('X-C3','2025-09-11',8100,310,23,215.00,780.00),
('X-C4','2025-09-11',15200,210,0,155.00,0.00),

-- Day 3: 2025-09-12
('META-C1','2025-09-12',9000,390,33,310.00,980.00),
('META-C2','2025-09-12',5100,160,24,102.00,480.00),
('META-C3','2025-09-12',8500,310,27,235.00,1030.00),
('META-C4','2025-09-12',14800,230,0,185.00,0.00),
('GGL-C1','2025-09-12',15500,620,49,510.00,1950.00),
('GGL-C2','2025-09-12',0,0,0,0.00,0.00),
('GGL-C3','2025-09-12',14000,560,44,440.00,1620.00),
('GGL-C4','2025-09-12',9700,330,26,195.00,760.00),
('LNK-C1','2025-09-12',2950,38,6,170.00,750.00),
('LNK-C2','2025-09-12',4700,85,0,158.00,0.00),
('LNK-C3','2025-09-12',3400,68,14,200.00,780.00),
('LNK-C4','2025-09-12',2900,60,11,170.00,690.00),
('TTK-C1','2025-09-12',14500,520,46,375.00,1320.00),
('TTK-C2','2025-09-12',27000,170,0,180.00,0.00),
('TTK-C3','2025-09-12',28000,200,0,200.00,0.00),
('TTK-C4','2025-09-12',10500,420,37,290.00,1050.00),
('X-C1','2025-09-12',22000,130,0,140.00,0.00),
('X-C2','2025-09-12',11500,450,39,360.00,1230.00),
('X-C3','2025-09-12',8200,320,24,220.00,800.00),
('X-C4','2025-09-12',15400,220,0,160.00,0.00);