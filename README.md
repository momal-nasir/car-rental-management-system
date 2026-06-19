# Car Rental Management System

## Overview

This project is a full-stack Car Rental Management System that integrates a relational database with a web-based application. It manages the complete workflow of a rental service including customers, vehicles, reservations, contracts, and payments.

The system ensures data consistency, prevents double booking, and maintains accurate records of car usage, availability, and financial transactions.

---

## Features

### Database Layer (SQL Server)

* Designed a normalized relational database (up to 3NF)
* Implemented entities: Customer, Car, Reservation, Contract, Employee, Payment
* Enforced data integrity using primary/foreign keys and constraints
* Developed stored procedures for business logic
* Implemented triggers for rule enforcement and automation
* Designed role-based access control for secure operations

### Application Layer (ASP.NET Core)

* Built web-based interface using ASP.NET Core (Razor Pages)
* Implemented user interaction through dynamic forms
* Integrated backend database operations
* Managed reservations, payments, and car availability

---

## Project Structure

```
car-rental-management-system/
│
├── application/
│   ├── CarBooking/
│   └── CarBooking.sln
│
├── database/
│   ├── schema.sql
│   ├── insert_data.sql
│   ├── procedures.sql
│   ├── triggers.sql
│   ├── roles_permissions.sql
│   └── queries.sql
│
├── docs/
│   └── report.pdf
│
├── README.md
└── .gitignore
```

---

## Technologies Used

* **Backend:** C#, ASP.NET Core (Razor Pages)
* **Database:** SQL Server
* **Languages:** SQL, C#
* **Concepts:** Database Design, Normalization, Full-Stack Development

---

## Key Concepts Implemented

* Relational Database Design (1NF, 2NF, 3NF)
* Entity-Relationship Modeling
* Stored Procedures & Triggers
* Role-Based Access Control
* Data Integrity & Constraints
* Full-stack integration (Application + Database)

---

## How to Run (Application)

1. Install .NET SDK
2. Open solution file:

   ```
   CarBooking.sln
   ```
3. Run using:

   ```
   dotnet run
   ```

   or Visual Studio

---

## Database Setup

1. Open SQL Server Management Studio
2. Run:

   * `schema.sql`
   * `insert_data.sql`
   * `procedures.sql`
   * `triggers.sql`
   * `roles_permissions.sql`

---

## Learning Outcomes

* Designed a complete database system with real-world constraints
* Integrated database with application layer
* Implemented business rules using SQL procedures and triggers
* Gained experience in full-stack system design

---

## Future Improvements

* REST API integration
* Modern frontend (React / Angular)
* Authentication system enhancement
* Cloud deployment

---

