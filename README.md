# Bakery Sales Performance & Analytics Pipeline

An end-to-end data analytics project transforming raw retail transactional logs into an interactive 3-page business intelligence dashboard using SQL and Power BI.

## Project Files
* [bakery queries.sql](bakery%20queries.sql) – Database creation, bulk ingestion, and data cleaning scripts.
* [Bakery Sales Dashboard.pbix](Bakery%20Sales%20Dashboard.pbix) – Compiled Power BI dashboard with data model and DAX measures.
* [Bakery Sales.csv](Bakery%20Sales.csv) – Raw transactional volume dataset.
* [Bakery price.csv](Bakery%20price.csv) – Raw menu item pricing dataset.

## Dashboard Preview

### Page 1: Sales Performance
![Sales Performance](Screenshot%20(364).jpg)

### Page 2: Store Performance
![Store Performance](Screenshot%20(365).jpg)

### Page 3: Insights & Recommendations
![Insights](Screenshot%20(366).jpg)

## 1. SQL Data Engineering & Cleaning
The raw unstructured tables were imported, cleaned, and structured using MySQL:
* **Bulk Ingestion:** Utilized `LOAD DATA INFILE` routines to efficiently handle the transaction records into staging tables.
* **De-duplication:** Identified and pruned duplicate transaction IDs to protect analytical accuracy.
* **Category Standardization:** Resolved mismatched string values between item tables and pricing dimensions to secure error-free joins.
* **Temporal Parsing:** Isolated raw datetime fields into clean, queryable Date, Hour, and Day columns for downstream time-series tracking.

## 2. Power BI Data Modeling
* Connected the cleaned SQL staging views into a relational star schema inside Power BI.
* Authored core performance DAX measures including Total Revenue, Total Orders, and Average Order Value (AOV).
* Implemented cross-filtering slicers allowing real-time filtering by Date, Day, and Product Category.

## 3. Dashboard Architecture
The final portfolio asset contains a high-contrast dark-themed layout across three distinct navigation pages:
* **Sales Performance:** Tracks hourly distributions across morning, afternoon, and evening shifts alongside dynamic sales volume trends.
* **Store Performance:** Visualizes geographical distribution across 14 store locations, utilizing a leaderboard to identify high-revenue regions and underperforming locations.
* **Insights & Recommendations:** Translates product and regional demand concentration metrics into structured, data-driven business action items.
