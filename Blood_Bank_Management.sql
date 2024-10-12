
CREATE DATABASE BLOOD_BANK_MANAGEMENT;
USE BLOOD_BANK_MANAGEMENT;

CREATE TABLE Hospitals(
	Hospital_id INT PRIMARY KEY,
    Name VARCHAR(255),
    Location VARCHAR(255),
    Contact_number VARCHAR(15)
);

CREATE TABLE Donors (
	Donor_id INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Blood_group VARCHAR(3),
    Contact_number VARCHAR(15),
    Address VARCHAR(255),
    Has_disease TINYINT(1), 
    Disease_details VARCHAR(255)
);

CREATE TABLE Recipients (
	Recipient_id INT PRIMARY KEY,
    Name VARCHAR(20),
    Age int,
    Blood_group VARCHAR(3),
    Contact_number VARCHAR(15),
    Hospital_id INT,
	Requested_date DATE,
    Required_units INT,
    Foreign key (Hospital_id)
		REFERENCES Hospitals(Hospital_id)
);

CREATE TABLE Blood_Donations (
	Donation_id INT PRIMARY KEY,
    Donor_id INT, 
	Blood_group VARCHAR(3),
    Quantity INT,
    Donation_date DATE,
    Quality VARCHAR(20),
	FOREIGN KEY (Donor_id)
		REFERENCES Donors(Donor_id)
);

CREATE TABLE Blood_Inventory (
	Blood_group VARCHAR(3) PRIMARY KEY,
    Total_units INT
);

INSERT INTO Hospitals (Hospital_id, Name, Location, Contact_number)
	VALUES (1, 'Medanta The Medicity', 'Gurgaon, India', '890-439-5588'),
			(2, 'Fortis Memorial', 'Gurgaon, India', '9205 010 100'),
			(3, 'Max Hospitals', 'New Delhi, India', '92688 80303');

INSERT INTO Blood_Inventory (Blood_group, Total_units)
	VALUES ('A+', 5),
			('A-', 0),
			('B+', 3),
            ('B-', 4),
            ('AB+', 3),
			('AB-', 1),
			('O-', 4),
            ('O+', 4);

-- SQL Trigger for Donations
DELIMITER //

CREATE TRIGGER after_blood_donation
AFTER INSERT ON Blood_Donations
FOR EACH ROW
BEGIN
    -- Check if the blood group already exists in the inventory
    IF EXISTS (SELECT 1 FROM Blood_Inventory WHERE Blood_group = NEW.blood_group) THEN
        -- Update the quantity for the existing blood group
        UPDATE Blood_Inventory
        SET Total_units = Total_units + NEW.quantity
        WHERE Blood_group = NEW.blood_group;
    ELSE
        -- Insert a new record if the blood group doesn't exist
        INSERT INTO Blood_Inventory (Blood_group, Total_units)
        VALUES (NEW.blood_group, NEW.quantity);
    END IF;
END //

DELIMITER ;

-- SQL Trigger for Blood Provision
DELIMITER //

CREATE TRIGGER after_blood_provision
AFTER INSERT ON Recipients
FOR EACH ROW
BEGIN
    -- Check if the blood group exists in the inventory and if there is enough quantity
    IF EXISTS (SELECT 1 FROM Blood_Inventory WHERE Blood_group = NEW.Blood_group AND Total_units >= NEW.Required_units) THEN
        -- Subtract the quantity provided to the recipient from the inventory
        UPDATE Blood_Inventory
        SET Total_units = Total_units - NEW.Required_units
        WHERE Blood_group = NEW.Blood_group;
    ELSE
        -- If there is not enough blood available, raise an error
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough blood available in inventory for the requested blood group';
    END IF;
END //

DELIMITER ;

INSERT INTO Donors (Donor_id, Name, Age, Blood_group, Contact_number, Address, Has_disease, Disease_details)
	VALUES (1, 'Priya', 58, 'AB+', '917805745017', 'Address_1', 0, 'Syphilis'),
			(2, 'Manish', 25, 'A+', '917010379415', 'Address_2', 1, 'Syphilis'),
			(3, 'Pranav', 19, 'O-', '915284391408', 'Address_3', 1, 'HIV'),
			(4, 'Tanvi', 65, 'A-', '917483366056', 'Address_4', 1, 'Hepatitis'),
			(5,	'Nikhil', 35, 'O+', '911470939445', 'Address_5', 0, 'Syphilis'),
			(6, 'Neha', 33, 'A-', '913694860228', 'Address_6', 0, 'Hepatitis'),
			(7, 'Esha', 32, 'AB+', '915567816720', 'Address_7', 1, 'HIV'),
			(8, 'Deepak', 26, 'AB-', '919573276057', 'Address_8', 1, 'Hepatitis'),
			(9, 'Harsh', 65, 'B-', '917567496105', 'Address_9', 1, 'Syphilis'),
			(10, 'Gauri', 24, 'A-', '919639245200', 'Address_10', 1, 'Hepatitis'),
            (11, 'Varun', 61, 'A+', '914095476665', 'Address_11', 0,'HIV'),
			(12, 'Ishaan', 65, 'B-', '918047877267', 'Address_12', 1, 'Malaria'),
			(13, 'Bhavna', 52, 'AB+', '915774080233', 'Address_13', 0, 'Hepatitis'),
			(14, 'Harsh', 23, 'A-', '912867302554', 'Address_14', 1, 'Syphilis'),
			(15, 'Dhanush', 55, 'B-', '912948728483', 'Address_15', 0, 'HIV'),
			(16, 'Monoj', 45, 'A-', '914919706735', 'Address_16', 0, 'Syphilis'),
			(17, 'Kartik', 20, 'O+', '913615507143', 'Address_17', 1, 'Syphilis'),
			(18, 'Bhavna', 19, 'AB+', '915951406973', 'Address_18', 1, 'Hepatitis'),
			(19, 'Sohan', 23, 'O-', '914274958945', 'Address_19', 0, 'Syphilis'),
			(20, 'Mahendra', 31, 'AB-', '919592390865', 'Address_20', 1,	'Hepatitis'),
			(21, 'Ishaan', 32, 'B+', '916687206971', 'Address_21', 1, 'Malaria'),
			(22, 'Harsh', 50, 'AB-', '911083651970', 'Address_22', 1, 'Syphilis'),
			(23, 'Pranav', 56, 'AB-', '919285415473', 'Address_23', 1, 'Syphilis'),
			(24, 'Rahul', 19, 'B-', '912320763135', 'Address_24', 1, 'Syphilis'),
			(25, 'Deepak', 53, 'AB+', '911248786714', 'Address_25', 1, 'None'),
			(26, 'Abhishek', 30, 'A-', '915067116918', 'Address_26', 0,	'None'),
			(27, 'Sawan', 63, 'B+', '919957813353', 'Address_27', 0, 'HIV'),
			(28, 'Aryan', 59, 'B-', '914289233844', 'Address_28', 0, 'None'),
			(29, 'Harman', 62, 'B+', '913361388464', 'Address_29', 1, 'HIV'),
			(30, 'Abhi', 52, 'O-', '916633778586', 'Address_30', 0,	'None'),
			(31, 'Raushan', 44, 'O+', '918086172302', 'Address_31', 1, 'Malaria'),
			(32, 'Praful', 32, 'AB+', '917517938612', 'Address_32', 1, 'HIV'),
			(33, 'Ritik', 46, 'B-', '911519709079', 'Address_33', 0, 'None'),
			(34, 'Vivek', 55, 'AB-', '911965067727', 'Address_34', 1, 'Malaria'),
			(35, 'Shivam', 35, 'A+', '912452066459', 'Address_35', 0, 'None'),
			(36, 'Tejshvi', 18, 'B-', '911945826486', 'Address_36', 0,	'Hepatitis'),
			(37, 'Akshay', 28, 'A+', '919894847574', 'Address_37', 0, 'Hepatitis'),
			(38, 'Rahul', 62, 'AB-', '913710566582',	'Address_38', 0, 'Malaria'),
			(39, 'Brijesh', 45, 'O+', '911983297492', 'Address_39', 0, 'Syphilis'),
			(40, 'Mohan', 39, 'AB+', '914888749350', 'Address_40', 0, 'Syphilis');

INSERT INTO Blood_Donations (donation_id, donor_id, blood_group, quantity, donation_date, quality)
	VALUES (1, 1, 'O+', 2, '2024-09-20', 'Good'),
			(2, 5, 'A-', 1, '2024-09-25', 'Contaminated'),
            (3, 7, 'B+', 3, '2024-09-30', 'Good'),
            (4, 10, 'AB-', 1, '2024-09-28', 'Good'),
            (5, 13, 'O-', 4, '2024-10-01', 'Good'),
            (6, 15, 'O+', 3, '2024-10-05', 'Good'),
            (7, 20, 'A-', 2, '2024-10-06', 'Good'),
            (8, 22, 'B+', 1, '2024-10-07', 'Contaminated'),
            (9, 25, 'AB-', 2, '2024-10-08', 'Good'),
            (10, 28, 'O-', 3, '2024-10-09', 'Good'),
            (11, 30, 'O+', 1, '2024-10-10', 'Good'),
            (12, 33, 'A-', 4, '2024-10-11', 'Contaminated'),
            (13, 35, 'B+', 2, '2024-10-12', 'Good'),
            (14, 37, 'AB-', 1, '2024-10-13', 'Good'),
            (15, 38, 'O-', 2, '2024-10-14', 'Good'),
            (16, 39, 'O+', 4, '2024-10-15', 'Good'),
            (17, 2, 'A-', 1, '2024-10-16', 'Good'),
            (18, 3, 'B+', 2, '2024-10-17', 'Contaminated'),
            (19, 6, 'AB-', 3, '2024-10-18', 'Good'),
            (20, 8, 'O-', 1, '2024-10-19', 'Good');

INSERT INTO Recipients (Recipient_id, Name, Age, Blood_group, Contact_number, Hospital_id, Requested_date, Required_units)
	VALUES (1, 'Aarav', 30, 'A+', '912320763135', 1, '2023-01-09', 3),
			(2, 'Pallavi', 24, 'O+', '914888749350', 2, '2013-09-04', 2),
            (3, 'Kavya', 25, 'O-', '913710566582', 3, '2024-07-23', 1),
            (4, 'Raghav', 31, 'O+', '912320763135', 1, '2016-10-01', 4),
            (5, 'Sahil', 23, 'B+', '913710566582', 3, '2022-06-23', 3);


-- Queries
select * from Donors;
select * from Hospitals;
select * from Blood_Donations;
select * from Recipients;
select * from Blood_Inventory;


-- Check Blood Availability
SELECT 
	Blood_group, Total_units
FROM 
	Blood_Inventory
WHERE 
	Total_units > 0;

-- Check for Donors with Blood-borne Diseases
SELECT 
	Donor_id, Name, Blood_group, Disease_details
FROM 
	Donors
WHERE 
	Has_disease = TRUE;

-- Check Blood Units for Specific Blood Group
SELECT 
	Blood_group, Total_units
FROM 
	Blood_Inventory
WHERE 
	Blood_group = 'O+' ;

-- Match Recipients with Available Blood
SELECT 
	r.Recipient_id, r.Name, r.Blood_group, r.Required_units, b.Total_units
FROM 
	Recipients AS r
JOIN 
	Blood_Inventory AS b 
ON 
	r.Blood_group = b.Blood_group
WHERE 
	b.Total_units >= r.Required_units;