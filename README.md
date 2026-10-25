# Olist E-Commerce Analytics | PostgreSQL

## Project overview
SQL analysis of the public Brazilian Olist e-commerce dataset (~100k orders) to examine order trends, revenue, customer purchasing, product/seller performance, and delivery experience.

**Tools:** PostgreSQL, DBeaver, GitHub.  
**Dataset:** [Brazilian E-Commerce Public Dataset by Olist (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

## Business questions
1. Which states generate the most orders?
2. How does order volume change month to month?
3. What are merchandise revenue and average order value?
4. How common are repeat purchases?
5. Which product categories and sellers generate the most sales?
6. How do delivery delays relate to review scores?

## Findings (verified so far)
- São Paulo generated **41,746 orders (41.98%)** in the geographic order analysis.
- Orders per unique customer rounded to **1.04** in São Paulo versus **1.05** in RO and AC. These small differences do not establish meaningful differences in retention.

**To complete:** Add actual outputs from scripts `05`–`09` only after running and validating them. Add 3–5 concise insights, limitations, and an ER diagram.

## Repository structure
- `sql/01_create_tables.sql` — nine-table schema
- `sql/02_import_data.psql` — psql CSV imports (customers/orders commented out for existing DB)
- `sql/03_data_validation.sql` — row counts and checks
- `sql/04_geographic_analysis.sql` — order distribution by state
- `sql/05_monthly_trends.sql` — monthly order volumes and growth
- `sql/06_revenue_analysis.sql` — merchandise revenue, AOV, payments
- `sql/07_customer_analysis.sql` — repeat behaviour and customer value
- `sql/08_product_seller_analysis.sql` — category, product and seller rankings
- `sql/09_delivery_reviews_analysis.sql` — delivery speed and review scores

## Reproduce
1. Download the nine original Olist CSV files from Kaggle and place them in a local `data/` folder (not committed to Git).
2. Create a PostgreSQL database named `olist_ecommerce`.
3. Execute `sql/01_create_tables.sql` in DBeaver.
4. From the repository root, run `psql -h localhost -U postgres -d olist_ecommerce -v ON_ERROR_STOP=1 -f sql/02_import_data.psql`. **For a fresh database, uncomment the two customers/orders import lines first.** For an existing database with those tables already populated, leave them commented out.
5. Run the remaining `.sql` scripts in DBeaver and record the outputs.

## Methodology and limitations
- Merchandise revenue is `SUM(order_items.price)` for orders whose status is not `canceled` or `unavailable`; freight is reported separately. This is **not profit** and does not reconcile automatically to payment totals.
- Customer repeat purchasing uses `customer_unique_id`, not order-specific `customer_id`.
- One-to-many order items and payments are aggregated before order-level analysis to prevent double counting.
- Partial months near the beginning/end of dataset coverage should not be used to infer sustained business trends.
- Observational comparisons (e.g., review score vs delivery timing) do not prove causation.
- Raw CSVs are excluded from version control; obtain them from the linked source.
