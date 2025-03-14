# SQL-SCRIPTS

This Repository holds all of the SQL scripts from my Portfolio Projects.

# COVID-19 Data Analysis with SQL & Tableau

## Project Overview
This project analyzes global COVID-19 data using SQL to extract insights on infection rates, mortality rates, and vaccination progress. The dataset includes information on cases, deaths, and vaccinations from different countries and continents. The results are visualized in an interactive Tableau dashboard to better understand trends and patterns.

## Key Objectives
- Analyze COVID-19 infection rates and mortality rates across different locations.
- Compare total cases against total population to determine infection percentages.
- Identify countries and continents with the highest death tolls.
- Track global vaccination progress and its impact on infection rates.
- Create SQL views for efficient data storage and visualization.

## Tools Used
- **SQL Server** for data extraction and transformation.
- **Tableau** for interactive data visualization.

## Tableau Dashboard
![Tableau Dashboard Preview](Covid%20Dashboard.png)

# Data Cleaning SQL Project

## Objective
This project focuses on cleaning and transforming a housing dataset using SQL. The primary tasks include standardizing data formats, handling missing values, breaking out combined columns into individual ones, and removing duplicates to ensure data integrity and consistency.

## Key Tasks:
1. **Standardizing Date Format**: Converted date fields to a uniform format for consistency.
2. **Populating Missing Property Address Data**: Filled in missing addresses by matching based on `ParcelID`.
3. **Breaking Out Combined Address Fields**: Split property and owner addresses into individual columns for easier analysis.
4. **Changing Field Values**: Updated the 'SoldAsVacant' field to replace 'Y'/'N' with 'Yes'/'No'.
5. **Removing Duplicates**: Eliminated duplicate records based on unique identifiers.
6. **Deleting Unused Columns**: Dropped irrelevant or unnecessary columns from the dataset.

## Tools Used:
- SQL Server

## Dataset:
The project uses a housing dataset from the following link:  
[Nashville Housing Data for Data Cleaning](https://github.com/SaronTheAnalyst/Portfolio-Project/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx)
