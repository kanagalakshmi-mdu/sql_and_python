import pymysql
import pandas as pd
import matplotlib.pyplot as plt

# 1. Connect to the MySQL database
connection = pymysql.connect(
    host='localhost',
    user='root',
    password='susi123',  # Replace with your MySQL root password
    database='Mall_project',
    port = 3307
)

# 2. Load data into Pandas DataFrames
mall_df = pd.read_sql("SELECT * FROM mall", connection)
store_df = pd.read_sql("SELECT * FROM store", connection)
customer_df = pd.read_sql("SELECT * FROM customer", connection)
purchase_df = pd.read_sql("SELECT * FROM purchase", connection)

# 3. Merge DataFrames for Analytics
mall_store = pd.merge(store_df, mall_df, left_on='m_id', right_on='id', suffixes=('_store', '_mall'))
full_df = pd.merge(customer_df, mall_store, left_on='s_id', right_on='id_store')

# 4. Example Analytics

# a) Total sales per store
sales_per_store = purchase_df.groupby('s_id')['amount'].sum().reset_index()
sales_per_store = pd.merge(sales_per_store, store_df[['id','store_name']], left_on='s_id', right_on='id')
print("Total Sales per Store:")
print(sales_per_store[['store_name', 'amount']])

# Plot Total Sales per Store
plt.figure(figsize=(12,6))
plt.bar(sales_per_store['store_name'], sales_per_store['amount'])
plt.xticks(rotation=90)
plt.ylabel("Total Sales")
plt.title("Total Sales per Store")
plt.show()

# b) Top 5 Customers by Spending
top_customers = purchase_df.groupby('cust_id')['amount'].sum().reset_index()
top_customers = pd.merge(top_customers, customer_df[['id','cust_name']], left_on='cust_id', right_on='id')
top_customers = top_customers.sort_values('amount', ascending=False).head(5)
print("Top 5 Customers:")
print(top_customers[['cust_name','amount']])

# c) Sales by Mall
sales_by_mall = pd.merge(purchase_df, store_df[['id','m_id']], left_on='s_id', right_on='id')
sales_by_mall = pd.merge(sales_by_mall, mall_df[['id','mall_name']], left_on='m_id', right_on='id')
sales_by_mall = sales_by_mall.groupby('mall_name')['amount'].sum().reset_index()
print("Sales by Mall:")
print(sales_by_mall)

# Plot Sales by Mall
plt.figure(figsize=(10,5))
plt.bar(sales_by_mall['mall_name'], sales_by_mall['amount'], color='green')
plt.xticks(rotation=45)
plt.ylabel("Total Revenue")
plt.title("Revenue per Mall")
plt.show()

# d) Customers per Store Category
customer_category = full_df.groupby('category')['cust_name'].count().reset_index()
print("Customers per Store Category:")
print(customer_category)

# Plot Customers per Category
plt.figure(figsize=(8,5))
plt.bar(customer_category['category'], customer_category['cust_name'], color='orange')
plt.ylabel("Number of Customers")
plt.title("Customers per Store Category")
plt.show()

# Close the database connection
connection.close()
