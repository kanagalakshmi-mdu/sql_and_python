import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Load datasets
athletes = pd.read_csv("athlete_events.csv")
regions = pd.read_csv("noc_regions.csv")

# Merge datasets on NOC
df = athletes.merge(regions, on="NOC", how="left")

print("Dataset shape:", df.shape)
print("Columns:", df.columns)

# 1. Top 10 countries by medals
medals = df.dropna(subset=["Medal"])
top_countries = medals["region"].value_counts().head(10)

plt.figure(figsize=(10,6))
top_countries.plot(kind="bar", color="orange")
plt.title("Top 10 Countries by Total Medals")
plt.xlabel("Country")
plt.ylabel("Medals")
plt.show()

# 2. Male vs Female participation over time
gender_trend = df.groupby(["Year", "Sex"])["ID"].nunique().unstack()
gender_trend.plot(marker='o', figsize=(12,6))
plt.title("Male vs Female Participation Over Years")
plt.xlabel("Year")
plt.ylabel("Number of Athletes")
plt.grid(True)
plt.show()

# 3. Age distribution of athletes
plt.figure(figsize=(10,6))
df["Age"].dropna().hist(bins=30, edgecolor="black", color="skyblue")
plt.title("Distribution of Athlete Ages")
plt.xlabel("Age")
plt.ylabel("Frequency")
plt.show()

# 4. NumPy : Average height & weight by sport
sport_stats = df.groupby("Sport")[["Height", "Weight"]].mean().round(2)
print("\nAverage height & weight per sport:\n", sport_stats.head(10))

# 5. Athletes per year trend
athletes_per_year = df.groupby("Year")["ID"].nunique()
plt.figure(figsize=(12,6))
plt.plot(athletes_per_year.index, athletes_per_year.values, marker='o', color='green')
plt.title("Number of Athletes per Year")
plt.xlabel("Year")
plt.ylabel("Athletes")
plt.grid(True)
plt.show()
