import pymysql
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Database connection
connection = pymysql.connect(
    host="localhost",
    user="root",
    password="susi123",
    database="smart_parking_lot",
    port= 3307
)

# Load Data into Pandas DataFrame
# Query parking records with vehicles
query = """
SELECT pr.record_id, v.plate_no, v.vehicle_type, pr.entry_time, pr.exit_time, pr.fee
FROM parking_records pr
JOIN vehicles v ON pr.vehicle_id = v.vehicle_id
"""
df = pd.read_sql(query, connection)

print(df.head())

# Analytics with NumPy & Pandas
# Total Revenue
total_revenue = df['fee'].sum()
print("Total Revenue:", total_revenue)

# Average Parking Duration
df['duration_hours'] = (df['exit_time'] - df['entry_time']).dt.total_seconds() / 3600
print("Average Parking Duration (hours):", df['duration_hours'].mean())

# Revenue by Vehicle Type
revenue_by_type = df.groupby('vehicle_type')['fee'].sum()
print(revenue_by_type)

# Visualization with Matplotlib
# Revenue by Vehicle Type (Bar Chart)
revenue_by_type.plot(kind='bar')
plt.title("Revenue by Vehicle Type")
plt.xlabel("Vehicle Type")
plt.ylabel("Revenue (₹)")
plt.show()

# Parking Duration Distribution (Histogram)
plt.hist(df['duration_hours'].dropna(), bins=10, edgecolor='black')
plt.title("Parking Duration Distribution")
plt.xlabel("Hours Parked")
plt.ylabel("Number of Vehicles")
plt.show()

# Daily Revenue Trend (Line Chart)
df['date'] = df['exit_time'].dt.date
daily_revenue = df.groupby('date')['fee'].sum()

daily_revenue.plot(kind='line', marker='o')
plt.title("Daily Revenue Trend")
plt.xlabel("Date")
plt.ylabel("Revenue (₹)")
plt.show()

