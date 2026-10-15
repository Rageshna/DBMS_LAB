SET SERVEROUTPUT ON; SET LINESIZE 120;
SET PAGESIZE 50;

CREATE TABLE Doctors (
DoctorID NUMBER PRIMARY KEY,
DoctorName VARCHAR2(100), Specialization VARCHAR2(100), Phone VARCHAR2(15)
);

CREATE TABLE Patients (
PatientID NUMBER PRIMARY KEY,
PatientName VARCHAR2(100), Age NUMBER,
Gender VARCHAR2(10), Address VARCHAR2(200)
);

CREATE TABLE Appointments ( AppointmentID NUMBER PRIMARY KEY, PatientID NUMBER,
DoctorID NUMBER, AppointmentDate DATE, Diagnosis VARCHAR2(200),

CONSTRAINT fk_patient FOREIGN KEY (PatientID)
REFERENCES Patients(PatientID),

CONSTRAINT fk_doctor FOREIGN KEY (DoctorID)
REFERENCES Doctors(DoctorID)
);

CREATE TABLE Bills (
BillID NUMBER PRIMARY KEY,
PatientID NUMBER, Amount NUMBER(10,2),
BillDate DATE, CONSTRAINT fk_bill_patient
 
FOREIGN KEY (PatientID)
REFERENCES Patients(PatientID)
);

INSERT INTO Doctors VALUES
(101, 'Dr. Rajesh', 'Cardiology', '9876543210');

INSERT INTO Doctors VALUES
(102, 'Dr. Priya', 'Neurology', '9876543211');

INSERT INTO Doctors VALUES
(103, 'Dr. Kumar', 'Orthopedics', '9876543212');

INSERT INTO Patients VALUES
(1, 'Arun', 25, 'Male', 'Chennai');

INSERT INTO Patients VALUES
(2, 'Divya', 30, 'Female', 'Coimbatore');

INSERT INTO Patients VALUES
(3, 'Karthik', 40, 'Male', 'Madurai');

INSERT INTO Appointments VALUES (1001, 1, 101,
TO_DATE('10-09-2026', 'DD-MM-YYYY'),
'Heart Checkup');

INSERT INTO Appointments VALUES (1002, 2, 102,
TO_DATE('12-09-2026', 'DD-MM-YYYY'),
'Migraine');

INSERT INTO Appointments VALUES (1003, 3, 103,
TO_DATE('15-09-2026', 'DD-MM-YYYY'),
'Fracture');

INSERT INTO Bills VALUES (501, 1, 2500, SYSDATE);

INSERT INTO Bills VALUES (502, 2, 1800, SYSDATE);

INSERT INTO Bills VALUES
 
(503, 3, 3200, SYSDATE); COMMIT;
CREATE OR REPLACE VIEW PatientDoctorView AS SELECT
p.PatientName, d.DoctorName, d.Specialization, a.AppointmentDate
FROM Patients p JOIN Appointments a
ON p.PatientID = a.PatientID JOIN Doctors d
ON a.DoctorID = d.DoctorID;

CREATE OR REPLACE PROCEDURE ShowPatientCount IS
total_patients NUMBER; BEGIN
SELECT COUNT(*)
INTO total_patients FROM Patients;

DBMS_OUTPUT.PUT_LINE(
'Total Patients = ' || total_patients
); END;
/

CREATE OR REPLACE FUNCTION GetBillAmount (
p_billid NUMBER
)
RETURN NUMBER IS
v_amount NUMBER;
BEGIN
SELECT Amount INTO v_amount FROM Bills
WHERE BillID = p_billid; RETURN v_amount;
 
END;
/

CREATE OR REPLACE TRIGGER Patient_Insert_Trigger AFTER INSERT ON Patients
FOR EACH ROW BEGIN
DBMS_OUTPUT.PUT_LINE(
'New Patient Added: ' || :NEW.PatientName
); END;
/

SELECT * FROM Doctors;	
/* OUTPUT:	
DOCTORID DOCTORNAME	SPECIALIZATION	PHONE
101	Dr. Rajesh	Cardiology	9876543210	
102	Dr. Priya	Neurology	9876543211	
103	Dr. Kumar	Orthopedics
*/	9876543212	

SELECT * FROM Patients;

/* OUTPUT:

PATIENTID PATIENTNAME AGE GENDER ADDRESS
1	Arun	25 Male  Chennai
2	Divya	30 Female Coimbatore
3	Karthik	40 Male  Madurai
*/		

SELECT * FROM Appointments;

/* OUTPUT:

APPOINTMENTID PATIENTID DOCTORID APPOINTMENTDATE DIAGNOSIS
1001	1	101	10-SEP-26	Heart Checkup
1002	2	102	12-SEP-26	Migraine
1003	3	103	15-SEP-26	Fracture
 
*/

SELECT
p.PatientName, d.DoctorName, d.Specialization
FROM Patients p JOIN Appointments a
ON p.PatientID = a.PatientID JOIN Doctors d
ON a.DoctorID = d.DoctorID;

/* OUTPUT:

PATIENTNAME DOCTORNAME SPECIALIZATION
Arun	Dr. Rajesh Cardiology Divya		Dr. Priya Neurology Karthik		 Dr. Kumar Orthopedics
*/

SELECT * FROM Bills;

/* OUTPUT:

BILLID PATIENTID AMOUNT BILLDATE
501	1	2500	25-SEP-26
502	2	1800	25-SEP-26
503	3	3200	25-SEP-26
*/			

SELECT * FROM PatientDoctorView;

/* OUTPUT:

PATIENTNAME DOCTORNAME SPECIALIZATION APPOINTMENTDATE
Arun	Dr. Rajesh Cardiology		10-SEP-26 Divya		Dr. Priya Neurology	12-SEP-26 Karthik		 Dr. Kumar Orthopedics			15-SEP-26
*/

SELECT GetBillAmount(501) AS Bill_Amount
 
FROM Dual;

/* OUTPUT:

BILL_AMOUNT 2500
*/

EXEC ShowPatientCount;

/* OUTPUT:

Total Patients = 3
*/

INSERT INTO Patients VALUES
(4, 'Meena', 35, 'Female', 'Trichy');

/* OUTPUT:

New Patient Added: Meena
*/
