# Olist E-Commerce Analytics | PostgreSQL

An end-to-end SQL analysis of the **Brazilian E-Commerce Public Dataset by Olist**, exploring sales performance, customer retention, product and seller activity, geographic demand, and delivery experience.

The project uses PostgreSQL to organise data from nine related tables, validate the imported records, and answer business questions through SQL queries. Summary outputs are provided as CSV files in [`results/`](results/).

## Key findings

| Metric | Result |
|---|---:|
| Orders with merchandise items | 98,199 |
| Merchandise revenue | R$13,494,400.74 |
| Average order value | R$137.42 |
| Repeat-customer rate | 3.04% |
| Delivered orders analysed | 96,470 |
| On-time delivery rate | 91.89% |
| Average delivery time | 12.56 days |

**Business observations**

- **Geographic concentration:** São Paulo (SP) accounted for **41.98% of orders** (41,746 orders), making it the largest state-level market by order volume in this analysis.
- **Repeat purchasing:** Of **94,990 unique customers** included in the repeat-purchase analysis, **2,888** placed more than one order (**3.04%**). This suggests that customer retention is worth investigating further.
- **Delivery experience:** On-time deliveries had an average review score of **4.29**, compared with **2.57** for late deliveries. This is an association, not evidence that delivery timing alone caused the difference.
- **Revenue:** Merchandise revenue totalled approximately **R$13.49 million**, with an average order value of **R$137.42**. Merchandise revenue excludes freight and should not be interpreted as profit.

*Metrics use the filters and definitions in the respective SQL analyses; their underlying populations may differ.*

## Business questions explored

- How do order volume and merchandise revenue change over time?
- Which Brazilian states contribute the most orders and revenue?
- How frequently do customers make repeat purchases?
- Which product categories, products, and sellers perform best?
- How do payment methods contribute to recorded transactions?
- How is delivery timeliness associated with customer review scores?

## Tools and techniques

- **Database:** PostgreSQL
- **Database client:** DBeaver
- **SQL:** JOINs, common table expressions (CTEs), subqueries, aggregation, conditional logic, and window functions
- **Outputs:** CSV summaries of query results

## Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

The dataset contains information about orders, customers, order items, payments, reviews, products, sellers, geolocation, and product-category translations. This project uses nine related tables.

The raw dataset is **not included** in this repository. Download it from Kaggle to reproduce the analysis.

## Repository structure

```text
olist-ecommerce-sql/
├── README.md
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_import_data.psql
│   ├── data_validation.sql
│   ├── geographic_analysis.sql
│   ├── monthly_analysis.sql
│   ├── revenue_analysis.sql
│   ├── customer_analysis.sql
│   ├── product_seller_analysis.sql
│   └── delivery_reviews_analysis.sql
└── results/
    ├── annual_order_counts.csv
    ├── customer_behaviour_by_state.csv
    ├── customer_repeat_purchase_metrics.csv
    ├── delivery_performance.csv
    ├── delivery_review_impact.csv
    ├── geographic_order_distribution.csv
    ├── monthly_delivery_reliability.csv
    ├── monthly_order_counts.csv
    ├── monthly_repeat_orders.csv
    ├── monthly_revenue.csv
    ├── overall_revenue.csv
    ├── payment_methods.csv
    ├── product_categories_by_revenue.csv
    ├── revenue_by_state.csv
    ├── review_score_distribution.csv
    ├── top_products_by_units.csv
    └── top_sellers_by_revenue.csv
```

## SQL analysis files

| Script | Purpose |
|---|---|
| [`01_create_tables.sql`](sql/01_create_tables.sql) | Defines the database tables and relationships |
| [`02_import_data.psql`](sql/02_import_data.psql) | Loads raw CSV data using `psql` and `\copy` |
| [`data_validation.sql`](sql/data_validation.sql) | Checks record counts and data quality |
| [`geographic_analysis.sql`](sql/geographic_analysis.sql) | Explores geographic order distribution and customer activity |
| [`monthly_analysis.sql`](sql/monthly_analysis.sql) | Examines monthly and annual order trends |
| [`revenue_analysis.sql`](sql/revenue_analysis.sql) | Calculates merchandise revenue, order value, payment mix, and state-level revenue |
| [`customer_analysis.sql`](sql/customer_analysis.sql) | Examines repeat purchasing and customer behaviour |
| [`product_seller_analysis.sql`](sql/product_seller_analysis.sql) | Ranks product categories, products, and sellers |
| [`delivery_reviews_analysis.sql`](sql/delivery_reviews_analysis.sql) | Explores delivery reliability and review scores |

## How to reproduce

**Requirements:** PostgreSQL and the `psql` command-line client.

1. Clone the repository and download the Olist CSV dataset from the Kaggle link above.
2. Place the downloaded CSV files in a local `data/` directory at the repository root.
3. Create an **empty** PostgreSQL database:

   ```bash
   createdb olist_ecommerce
   ```

4. Create the tables:

   ```bash
   psql -d olist_ecommerce -f sql/01_create_tables.sql
   ```

5. Open [`sql/02_import_data.psql`](sql/02_import_data.psql) and confirm that its CSV paths match your local dataset location. Run the imports **only once, into empty tables**:

   ```bash
   psql -v ON_ERROR_STOP=1 -d olist_ecommerce -f sql/02_import_data.psql
   ```

6. Run the validation and analysis scripts with `psql` or a SQL client such as DBeaver. For example:

   ```bash
   psql -d olist_ecommerce -f sql/data_validation.sql
   psql -d olist_ecommerce -f sql/revenue_analysis.sql
   ```

*Database authentication and connection options depend on your local PostgreSQL installation. The import script uses `psql`-specific commands and should be executed with `psql`, not as ordinary SQL in a query editor.*

## Results

The [`results/`](results/) folder contains **17 CSV summaries** covering revenue, orders, customer repeat purchases, geographic activity, product and seller performance, payment methods, and delivery/review patterns.

These are analytical summaries, not the original Olist tables.

## Limitations and interpretation

- The dataset is historical; results should not be interpreted as current market performance.
- Revenue calculations are based on merchandise prices and are **not** measures of profit.
- Repeat-customer analysis uses the dataset's unique customer identifier to distinguish customers across orders.
- Delivery and review comparisons are observational; they do not establish causation.
- Results may have different denominators depending on availability of order items, delivery records, reviews, or other required fields.

## Possible extensions

- Add an entity-relationship diagram for the nine-table schema.
- Build a Power BI or Tableau dashboard from the exported summaries.
- Investigate customer cohorts and retention patterns in more detail.
