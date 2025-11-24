# 🏥 Save-A-Life Hospital Database Project

A relational database project designed to simulate the operations of a hospital management system. This project provides a comprehensive schema that includes employee management, patient records, department structures, billing, and discharge processes, all modeled in SQL.

---

## 📘 Overview

This project demonstrates:

- Normalized table design
- Complex relationships between entities (employees, patients, departments, billing)
- Use of **foreign keys**, **triggers**, **views**, and **stored procedures**
- Sample data for realistic simulation and testing

---

## 🧱 Database Structure

### 🧑‍⚕️ Employees & Departments

- `employee`: Stores personal and contact information for hospital staff
- `department`: Contains department names and head assignments
- `doctors`: Links doctors to departments and qualifications
- `general_staff`: Stores general staff wage data

### 👩‍💼 Patients

- `patient_general_details`: Stores personal information
- `patient_medical_conditions`: Tracks each patient’s medical history

### 🛏️ Rooms

- `room_type`: Defines room categories and their charges
- `room_details`: Tracks individual rooms, capacity, and current usage

### 💳 Billing & Discharge

- `intermediate_bill`: Contains billing information for patient stays
- `discharge_summary`: Final discharge notes with patient outcomes

---

## ⚙️ Triggers

| Trigger Name | Purpose |
|--------------|---------|
| `DischargeTrigger_Insert` | Inserts status confirmation upon discharge |
| `BillTrigger_Update` | Logs billing amount before and after updates |
| `BeforeBillTrigger_Delete` | Logs deleted bill entries |

---

## 📊 Views

| View | Description |
|------|-------------|
| `view_patient_medical_history` | Lists all patients with medical history |
| `view_billing_summary` | Displays consolidated billing records |
| `view_discharged_patients` | Shows patients with discharge details |
| `view_doctor_department` | Maps doctors to their departments |
| `view_room_utilization` | Shows room availability and charges |

---

## 🧠 Stored Procedures

| Procedure | Purpose |
|----------|---------|
| `GetPatientBillSummary` | Retrieves billing summary for a patient |
| `AddNewPatient` | Adds a new patient to the system |
| `InsertBill` | Adds a new billing entry |
| `DischargePatient` | Records a discharge summary |
| `GetDoctorPatients` | Lists patients linked to a specific doctor (by doctor ID) |

---

## 🧪 Sample Data

The database is preloaded with:

- 8 Employees
- 7 Doctors
- 7 Departments
- 10+ Patients
- Room types and availability
- Billing entries and discharge records

Use the sample data to test queries, views, triggers, and procedures.

---

## 🚀 How to Use

1. Clone the repository:
    ```bash
    git clone https://github.com/visionbyangelic/hospital-database-project.git
    cd hospital-database-project
    ```

2. Open the SQL script in your preferred SQL environment (e.g., SSMS, MySQL Workbench).

3. Execute the script section-by-section:
    - Database & tables
    - Sample inserts
    - Triggers & views
    - Stored procedures

4. Run the predefined procedures or custom queries to explore database functionality.

---

## ✅ Requirements

- A relational database system (e.g., **SQL Server**, **MySQL**, or **PostgreSQL**)  
- Basic understanding of SQL syntax and relational concepts

---

## 📌 Project Use Cases

- Academic database design projects
- Demonstration of advanced SQL features
- Simulation of hospital administrative systems
- Backend for health management dashboards

---

## 📝 License

This project is open-source under the MIT License.

---

## 🔗 Contact

Project maintained by [visionbyangelic](https://github.com/visionbyangelic)

---

