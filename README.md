# SimWaze Traffic Database System

## Overview

This workshop project presents the design and implementation of a high-performance, distributed database system for **SimWaze**, a traffic navigation platform inspired by Waze. The system is built to ingest and process massive real-time traffic data, support intelligent route suggestions, and provide insights to users, drivers, and administrators.

The platform must handle:
- **137,957 road segments per city**
- **Data updates every 2 minutes**
- **Over 198 million records per day per city**
- **Response times <140ms for 180M users**

## Key Features

- **Three-layer architecture**: 
  - Real-time ingestion (MongoDB)
  - Structured historical storage (PostgreSQL)
  - Fast user-facing query service (Redis cache + optimized SQL)

- **User Stories Implemented**:
  - Real-time traffic updates
  - Route alternatives and congestion-based suggestions
  - Public transport arrival estimates
  - Eco-friendly routing and premium analytics
  - Fleet tracking and administrative dashboards

- **Modular System Components**:
  - User & Session Management
  - Route Search & Navigation
  - Notifications & Alerts
  - External Data Integration
  - Transactions & Subscriptions
  - Security & Audit Logging

## Technologies Used

- **MongoDB** – Staging area for raw external traffic data
- **PostgreSQL** – Data warehouse for structured, optimized access
- **Redis** – Fast-access datamart for frequent queries
- **ETL Pipeline** – To transform and load data from NoSQL to SQL

## Authors

- **Rubén Darío Fúquene Castiblanco** – `20192020004`  
- **Thomas Felipe Sarmiento Oñate** – `20201020068`

