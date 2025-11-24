--Hospital DataBase Project

CREATE DATABASE Save_A_Life_Hospital_Database_Project;
USE Save_A_Life_Hospital_Database_Project;

/* === TABLE CREATION === */

CREATE TABLE employee (
    emp_id DECIMAL(9,0),
    emp_type VARCHAR(3) NOT NULL,
    fname VARCHAR(20) NOT NULL,
    minit CHAR(1),
    lname VARCHAR(20),
    bdate DATE,
    address VARCHAR(30) NOT NULL,
    sex CHAR(1),
    contact_no VARCHAR(15) NOT NULL,
    relative_contact_no VARCHAR(15),
    date_of_join DATE NOT NULL,
    date_of_resign DATE,
    PRIMARY KEY (emp_id)
);

CREATE TABLE department (
    dep_no SMALLINT,
    dep_name VARCHAR(25) NOT NULL,
    dep_head_id DECIMAL(9,0),
    PRIMARY KEY (dep_no)
);

CREATE TABLE doctors (
    doc_emp_id DECIMAL(9,0),
    qualification VARCHAR(30),
    dno SMALLINT NOT NULL,
    PRIMARY KEY(doc_emp_id),
    FOREIGN KEY (doc_emp_id) REFERENCES employee(emp_id),
    FOREIGN KEY (dno) REFERENCES department(dep_no)
);

-- Remove FK from department to doctors to avoid circular dependency
-- Will be added after doctor data is inserted

CREATE TABLE general_staff (
    staff_emp_id DECIMAL(9,0),
    charge_per_hour INT NOT NULL,
    PRIMARY KEY(staff_emp_id),
    FOREIGN KEY (staff_emp_id) REFERENCES employee(emp_id)
);

CREATE TABLE patient_general_details (
    patient_id DECIMAL(9,0),
    fname VARCHAR(20) NOT NULL,
    minit CHAR(1),
    lname VARCHAR(20),
    sex CHAR(1),
    contact_no VARCHAR(15) NOT NULL,
    bdate DATE,
    relative_contact_no VARCHAR(15),
    address VARCHAR(30),
    PRIMARY KEY (patient_id)
);

CREATE TABLE patient_medical_conditions (
    pid DECIMAL(9,0),
    medical_history VARCHAR(50),
    PRIMARY KEY(pid, medical_history),
    FOREIGN KEY(pid) REFERENCES patient_general_details(patient_id)
);

CREATE TABLE room_type (
    room_type VARCHAR(30),
    room_abbrev VARCHAR(10),
    charge_per_bed INT NOT NULL,
    PRIMARY KEY (room_abbrev)
);

CREATE TABLE room_details (
    room_no VARCHAR(10),
    r_type VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    no_of_beds_occupied INT,
    PRIMARY KEY (room_no),
    FOREIGN KEY (r_type) REFERENCES room_type(room_abbrev)
);

CREATE TABLE intermediate_bill (
    case_A_no DECIMAL(9,0),
    bill_id DECIMAL(9,0) PRIMARY KEY,
    pt_id DECIMAL(9,0) NOT NULL,
    bill_date DATE NOT NULL,
    rno VARCHAR(10),
    room_charges INT,
    diagnosis VARCHAR(35),
    doctor_charge INT,
    total_charge INT,
    FOREIGN KEY(rno) REFERENCES room_details(room_no),
    FOREIGN KEY(pt_id) REFERENCES patient_general_details(patient_id)
);

CREATE TABLE discharge_summary (
    case_A_no DECIMAL(9,0),
    pid DECIMAL(9,0),
    diagnosis_details VARCHAR(100),
    patient_status CHAR(20),
    PRIMARY KEY(case_A_no),
    FOREIGN KEY (case_A_no) REFERENCES intermediate_bill(bill_id),
    FOREIGN KEY (pid) REFERENCES patient_general_details(patient_id)
);

/* === TRIGGER SUPPORT TABLES === */
CREATE TABLE DischargeTrigger (
    pid DECIMAL(9,0),
    Status_Message VARCHAR(30)
);

GO
CREATE TRIGGER DischargeTrigger_Insert
ON discharge_summary
AFTER INSERT
AS
BEGIN
    INSERT INTO DischargeTrigger (pid , Status_Message) 
    SELECT pid, 'Success'
    FROM inserted;
END;
GO

CREATE TABLE BillTrigger (
    BeforeUpdate VARCHAR(50),
    AfterUpdate VARCHAR(50)
);

GO
CREATE TRIGGER BillTrigger_Update
ON intermediate_bill
AFTER UPDATE
AS
BEGIN
    INSERT INTO BillTrigger (BeforeUpdate , AfterUpdate) 
    SELECT CONCAT('Before Update: ', d.total_charge), CONCAT('After Update: ', i.total_charge)
    FROM deleted d
    JOIN inserted i ON d.bill_id = i.bill_id;
END;
GO

CREATE TABLE BillTrigger_Delete (
    DeletedValue VARCHAR(64)
);

GO
CREATE TRIGGER BeforeBillTrigger_Delete
ON intermediate_bill
INSTEAD OF DELETE
AS
BEGIN
    INSERT INTO BillTrigger_Delete (DeletedValue) 
    SELECT CONCAT('Before Trigger Deleted Visitor Id: ', bill_id) FROM deleted;
    DELETE FROM intermediate_bill WHERE bill_id IN (SELECT bill_id FROM deleted);
END;
GO

/* === SAMPLE DATA INSERTS === */
-- EMPLOYEES
INSERT INTO employee VALUES (1,'DOC','Alice','B','Smith','1985-01-10','123 Main St','F','1112223333','4445556666','2010-05-20',NULL);
INSERT INTO employee VALUES (2,'DOC','John','C','Doe','1978-07-19','456 Oak Ave','M','2223334444','5556667777','2008-08-15',NULL);
INSERT INTO employee VALUES (3,'NUR','Jane','D','Brown','1990-03-25','789 Pine Rd','F','3334445555','6667778888','2015-09-10',NULL);
INSERT INTO employee VALUES (4,'DOC','Jemma','T','Achodor','1999-02-15','867 Agip Rd','F','3334449999','666777(090','2015-09-10',NULL);
INSERT INTO employee VALUES (5,'DOC','Angelic','C','Charles','2000-03-25','78 Wokoma St','F','3334442222','6667777777','2015-09-10',NULL);
INSERT INTO employee VALUES (6,'DOC','Heaven','A','Benga','1990-03-25','15 Forces Avenue Rd','F','3334440002','6667770989','2012-09-10',NULL);
INSERT INTO employee VALUES (7,'DOC','Dammy','D','Clinton','1997-10-25','14 GRA phase 1 Rd','F','3334448888','6667778989','2016-09-10',NULL);
INSERT INTO employee VALUES (8,'DOC','Prince','D','Ekine','1972-03-25','789 Dine Rd','M','3334442223','6667779099','2015-09-10',NULL);


-- DOCTORS
INSERT INTO doctors VALUES (1,'MBBS',1);
INSERT INTO doctors VALUES (2,'MD',2);
INSERT INTO doctors VALUES (4,'MBBS',3);
INSERT INTO doctors VALUES (5,'MBBS',4);
INSERT INTO doctors VALUES (6,'MBBS',5);
INSERT INTO doctors VALUES (7,'MBBS',6);
INSERT INTO doctors VALUES (8,'MBBS',7);

-- DEPARTMENTS (after doctors exist)
INSERT INTO department VALUES (1,'Cardiology',1);
INSERT INTO department VALUES (2,'Neurology',2);
INSERT INTO department(dep_no,dep_name,dep_head_id) VALUES
(3,'oncology',4),
(4,'Gynegology',5),
(5,'Primary care Physician',6),
(6,'Psycology',7),
(7,'Radiology',8)


-- Add FK now that doctor data exists
ALTER TABLE department
ADD CONSTRAINT FK_department_head FOREIGN KEY (dep_head_id) REFERENCES doctors(doc_emp_id);

-- GENERAL STAFF
INSERT INTO general_staff VALUES (1,110);
INSERT INTO general_staff VALUES (2,120);
INSERT INTO general_staff VALUES (3,333);

-- PATIENTS
INSERT INTO patient_general_details VALUES (100,'Tom','A','Jones','M','4445556666','1995-02-18','7778889999','12 Elm St');
INSERT INTO patient_general_details VALUES (101,'Lucy','B','Adams','F','5556667777','1988-11-12','8889990000','30 Oak Lane');
INSERT INTO patient_general_details VALUES (103,'Lucy','H','Abram','F','5500918888','1975-04-08','8889991010','34 Kaduna Street');
INSERT INTO patient_general_details VALUES (102,'Tom','F','Micheal','M','8909895555','1977-02-15','8889995454','14 Agip Road');
INSERT INTO patient_general_details VALUES (106,'Brenda','B','Charles','F','5510902323','1968-11-24','8889237809','3 eagle island');
INSERT INTO patient_general_details VALUES (107,'Danielle','D','Martins','F','5551239090','1988-11-17','8889991990','21 okania street');
INSERT INTO patient_general_details VALUES (104,'laila','S','Andrew','F','5559002222','1999-01-14','8889991562','38 st johns street');
INSERT INTO patient_general_details VALUES (108,'Pedro','O','Andreas','M','5555665599','1987-09-11','8889921468','34 ikwerre road');
INSERT INTO patient_general_details VALUES (109,'Allen','E','Periera','M','5558883333','1960-12-12','8881079356','12 waterlines');
INSERT INTO patient_general_details VALUES (110,'Mina','I','Allison','F','1116660909','1978-10-12','8880824431','10 Elioparanwo');

-- PATIENT CONDITIONS
INSERT INTO patient_medical_conditions VALUES (100,'Hypertension');
INSERT INTO patient_medical_conditions VALUES (101,'Diabetes');
INSERT INTO patient_medical_conditions VALUES (102,'Pneumonia');
INSERT INTO patient_medical_conditions VALUES (103,'Fibroid');
INSERT INTO patient_medical_conditions VALUES (104,'Conjuctivitis');
INSERT INTO patient_medical_conditions VALUES (106,'Jaundice');
INSERT INTO patient_medical_conditions VALUES (107,'Colon Cancer');
INSERT INTO patient_medical_conditions VALUES (108,'Cervical Cancer');
INSERT INTO patient_medical_conditions VALUES (109,'Diabetes');
INSERT INTO patient_medical_conditions VALUES (110,'Diabetes');
-- ROOM TYPES
INSERT INTO room_type VALUES ('General Ward','GW',200);
INSERT INTO room_type VALUES ('Intensive Care Unit','ICU',500);
INSERT INTO room_type VALUES ('High Dependency Unit','HDU',700);
INSERT INTO room_type VALUES ('Private Room','PR',1000);

-- ROOM DETAILS
INSERT INTO room_details VALUES ('GW101','GW',10,5);
INSERT INTO room_details VALUES ('ICU201','ICU',5,2);
INSERT INTO room_details VALUES ('HdU301','HDU',3,2);
INSERT INTO room_details VALUES ('PR401','PR',2,1);

-- INTERMEDIATE BILL
INSERT INTO intermediate_bill VALUES (5001,9001,100,'2024-06-01','GW101',200,'Hypertension',150,350);
INSERT INTO intermediate_bill VALUES (5002,9002,101,'2024-06-02','ICU201',500,'Diabetes',300,800);
INSERT INTO intermediate_bill VALUES (5003,9003,103,'2024-06-02','GW101',200,'Fibroid',300,500);
INSERT INTO intermediate_bill VALUES (5004,9004,104,'2024-06-02','GW101',200,'Conjuctivitis',400,600);
INSERT INTO intermediate_bill VALUES (5006,9006,106,'2024-06-02','GW101',200,'Jaundice',200,400);
INSERT INTO intermediate_bill VALUES (5007,9007,107,'2024-06-02','GW101',200,'Colon Cancer',650,850);
INSERT INTO intermediate_bill VALUES (5008,9008,108,'2024-06-02','ICU201',500,'Cervical Cancer',600,1100);
INSERT INTO intermediate_bill VALUES (5009,9009,109,'2024-06-02','HDU301',700,'Diabetes',300,1000);
INSERT INTO intermediate_bill VALUES (5010,9010,110,'2024-06-02','HDU301',700,'Diabetes',300,1000);
INSERT INTO intermediate_bill VALUES (5011,9011,102,'2024-06-02','PR401',1000,'Pneumonia',500,1500);

-- DISCHARGE SUMMARY
INSERT INTO discharge_summary VALUES (9001,100,'Hypertension','A');
INSERT INTO discharge_summary VALUES (9003,103,'Fibroid','D');

/* === VIEW ALL TABLES === */
SELECT * FROM employee;
SELECT * FROM department;
SELECT * FROM doctors;
SELECT * FROM general_staff;
SELECT * FROM patient_general_details;
SELECT * FROM patient_medical_conditions;
SELECT * FROM room_type;
SELECT * FROM room_details;
SELECT * FROM intermediate_bill;
SELECT * FROM discharge_summary;
SELECT * FROM DischargeTrigger;
SELECT * FROM BillTrigger;
SELECT * FROM BillTrigger_Delete;

/* === USEFUL VIEWS BASED ON ER DIAGRAM === */

-- 1. View: All Patients with Medical History
CREATE VIEW view_patient_medical_history AS
SELECT 
    p.patient_id,
    p.fname,
    p.lname,
    p.sex,
    p.contact_no,
    pmc.medical_history
FROM patient_general_details p
LEFT JOIN patient_medical_conditions pmc ON p.patient_id = pmc.pid;

-- 2. View: Current Patient Billing Summary
CREATE VIEW view_billing_summary AS
SELECT 
    b.case_A_no,
    b.bill_id,
    b.pt_id AS patient_id,
    p.fname,
    p.lname,
    b.bill_date,
    b.diagnosis,
    b.room_charges,
    b.doctor_charge,
    b.total_charge
FROM intermediate_bill b
JOIN patient_general_details p ON b.pt_id = p.patient_id;

-- 3. View: Discharged Patients Overview
CREATE VIEW view_discharged_patients AS
SELECT 
    d.case_A_no,
    d.pid AS patient_id,
    p.fname,
    p.lname,
    d.diagnosis_details,
    d.patient_status
FROM discharge_summary d
JOIN patient_general_details p ON d.pid = p.patient_id
WHERE d.patient_status = 'D';

-- 4. View: Doctors with Departments
CREATE VIEW view_doctor_department AS
SELECT 
    d.doc_emp_id,
    e.fname,
    e.lname,
    d.qualification,
    dp.dep_name
FROM doctors d
JOIN employee e ON d.doc_emp_id = e.emp_id
JOIN department dp ON d.dno = dp.dep_no;

-- 5. View: Room Utilization
CREATE VIEW view_room_utilization AS
SELECT 
    r.room_no,
    rt.room_type,
    r.capacity,
    r.no_of_beds_occupied,
    rt.charge_per_bed
FROM room_details r
JOIN room_type rt ON r.r_type = rt.room_abbrev;


/* === STORED PROCEDURE EXAMPLE === */
GO
CREATE PROCEDURE GetPatientBillSummary
    @PatientID DECIMAL(9,0)
AS
BEGIN
    SELECT 
        b.bill_id,
        b.case_A_no,
        b.bill_date,
        b.total_charge,
        p.fname + ' ' + p.lname AS patient_name
    FROM intermediate_bill b
    JOIN patient_general_details p ON b.pt_id = p.patient_id
    WHERE b.pt_id = @PatientID;
END;
GO

EXEC GetPatientBillSummary @PatientID = 100;
SELECT * FROM intermediate_bill;

--2
GO
CREATE PROCEDURE AddNewPatient
    @PatientID DECIMAL(9,0),
    @FName VARCHAR(20),
    @Minit CHAR(1),
    @LName VARCHAR(20),
    @Sex CHAR(1),
    @ContactNo VARCHAR(15),
    @BDate DATE,
    @RelativeContactNo VARCHAR(15),
    @Address VARCHAR(30)
AS
BEGIN
    INSERT INTO patient_general_details
    VALUES (@PatientID, @FName, @Minit, @LName, @Sex, @ContactNo, @BDate, @RelativeContactNo, @Address);
END;
GO
EXEC AddNewPatient 102, 'Mark', 'T', 'Lee', 'M', '5555555555', '1990-01-01', '6666666666', '100 Palm Street';
SELECT * FROM patient_general_details;

-- 3. Insert a new bill for a patient
GO
CREATE PROCEDURE InsertBill
    @CaseNo DECIMAL(9,0),
    @BillID DECIMAL(9,0),
    @PatientID DECIMAL(9,0),
    @BillDate DATE,
    @RoomNo VARCHAR(30),
    @RoomCharges INT,
    @Diagnosis VARCHAR(35),
    @DoctorCharge INT,
    @TotalCharge INT
AS
BEGIN
    INSERT INTO intermediate_bill
    VALUES (@CaseNo, @BillID, @PatientID, @BillDate, @RoomNo, @RoomCharges, @Diagnosis, @DoctorCharge, @TotalCharge);
END;
GO
EXEC InsertBill 5003, 9003, 102, '2025-06-01', 'GW101', 200, 'Checkup', 100, 300;
SELECT * FROM intermediate_bill;

-- 4. Discharge a patient
GO
CREATE PROCEDURE DischargePatient
    @CaseNo DECIMAL(9,0),
    @PatientID DECIMAL(9,0),
    @DiagnosisDetails VARCHAR(100),
    @Status CHAR(20)
AS
BEGIN
    INSERT INTO discharge_summary
    VALUES (@CaseNo, @PatientID, @DiagnosisDetails, @Status);
END;
GO
EXEC DischargePatient 9003, 102, 'Routine Checkup', 'D';
SELECT * FROM discharge_summary;

-- 5. Get all patients linked to a specific doctor
GO
CREATE PROCEDURE GetDoctorPatients
    @DoctorID DECIMAL(9,0)
AS
BEGIN
    SELECT DISTINCT p.patient_id, p.fname, p.lname, b.diagnosis
    FROM intermediate_bill b
    JOIN patient_general_details p ON b.pt_id = p.patient_id
    WHERE b.doctor_charge IS NOT NULL
    AND EXISTS (
        SELECT 1 FROM doctors d WHERE d.doc_emp_id = @DoctorID AND d.doc_emp_id = b.pt_id
    );
END;
GO
EXEC GetDoctorPatients @DoctorID = 1;
SELECT * FROM patient_general_details;


-- End of script
 