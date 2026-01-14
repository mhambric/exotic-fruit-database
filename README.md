## Exotic Fruit Database System (CS340)

This repository contains the relational database design and SQL implementation for the Of The World Exotic Fruit Storefront, a database driven web application developed as part of Oregon State University’s CS340 Database course.

The system supports core storefront and administrative workflows including product management, customer records, order processing, and reporting.

## Technologies Used

- MySQL
- SQL (DDL, DML, PL SQL)
- Stored Procedures
- Relational Database Design (3NF)

## Project Context

This was a team based academic project.
The database schema and SQL logic were developed collaboratively, while application level responsibilities were divided between frontend integration and backend implementation.

This repository focuses on the database layer and my frontend integration work.

## My Contributions

- Codesigned the relational database schema and entity relationships
- Authored and refined SQL DDL and DML scripts
- Implemented stored procedures for database reset and reporting
- Integrated the database with an existing backend by:
- Updating and aligning API request routes
- Modifying frontend fetch logic to work with the OSU hosted server
- Ensuring frontend CRUD operations correctly reflected database state
- Built and maintained the client dashboard and administrative UI
- Validated database behavior through frontend driven workflows

Note: The backend server implementation was created by a teammate and is not included in this repository. My work focused on database design, SQL logic, and frontend to database integration.

## Database Features

Normalized relational schema (Third Normal Form)
Tables for:
- Products
- Categories
- Customers
- Orders
- Order Items
- Primary and foreign key constraints enforcing data integrity
- Stored procedures used for:
- Resetting database tables to sample data
- Supporting reporting and administrative queries

## Included Files

- DDL.sql Database schema creation scripts
- DML.sql Sample data insertion scripts
- PL.SQL Stored procedures and database logic
- Includes schema diagram, Database schema (ER diagram), Example query output, Frontend dashboard connected to backend, and sample data located here in the documentation/screenshots folder:
- https://github.com/mhambric/exotic-fruit-database/tree/main/documentation/screenshots

## Frontend Integration

This database was designed to support the Exotic Fruit storefront and administrative dashboard.

A live frontend demo showcasing these workflows is available here:
https://exotic-fruit-frontend.vercel.app/

The frontend demonstrates how the database supports:
- Product browsing
- Cart interactions
- Administrative product and category management
- Order and customer workflows

## What This Project Demonstrates

- Relational database design for real world applications
- SQL proficiency including joins, constraints, and procedures
- Understanding of frontend to backend to database interaction
- Ability to integrate with an existing backend system
- Clear separation of responsibilities in a team environment
