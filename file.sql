-- Create Database
CREATE DATABASE IF NOT EXISTS SoftwareProjectCompany;
USE SoftwareProjectCompany;

-- Create Clients Table
CREATE TABLE Clients (
    ClientID INT AUTO_INCREMENT PRIMARY KEY,
    ClientName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100),
    ContactEmail VARCHAR(100) UNIQUE
);

-- Create Employees Table
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL
);

-- Create Projects Table
CREATE TABLE Projects (
    ProjectID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectName VARCHAR(100) NOT NULL,
    Requirements TEXT,
    Deadline DATE,
    ClientID INT,
    FOREIGN KEY (ClientID) REFERENCES Clients(ClientID) ON DELETE SET NULL
);

-- Create Team Members Table
CREATE TABLE TeamMembers (
    TeamMemberID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectID INT,
    EmployeeID INT,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) ON DELETE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);

-- Create Project Team Table
CREATE TABLE ProjectTeam (
    ProjectTeamID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectID INT,
    EmployeeID INT,
    IsTeamLead BOOLEAN,
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID) ON DELETE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);

-- Populate Clients Table
INSERT INTO Clients (ClientName, ContactName, ContactEmail) VALUES
('Big Retail Inc.', 'Peter Parker', 'peter.parker@example.com'),
('EduTech Solutions', 'Walter White', 'walter.white@example.com'),
('Trendsetters Inc.', 'Sandra Bullock', 'sandra.bullock@example.com'),
('Gearhead Supply Co.', 'Daniel Craig', 'daniel.craig@example.com'),
('Fine Dine Group', 'Olivia Rodriguez', 'olivia.rodriguez@example.com'),
('Green Thumb Gardens', 'Mark Robinson', 'mark.robinson@example.com'),
('Busy Bees Daycare', 'Emily Blunt', 'emily.blunt@example.com'),
('Acme Pharmaceuticals', 'David Kim', 'david.kim@example.com'),
('Knowledge Stream Inc.', 'Matthew McConaughey', 'matthew.mcconaughey@example.com'),
('Software Craft LLC', 'Jennifer Lopez', 'jennifer.lopez@example.com');

-- Populate Employees Table
INSERT INTO Employees (EmployeeName) VALUES
('Alice Brown'),
('David Lee'),
('Jane Doe'),
('Michael Young'),
('Emily Chen'),
('William Green'),
('Sarah Jones');

-- Populate Projects Table
INSERT INTO Projects (ProjectName, Requirements, Deadline, ClientID) VALUES
('E-commerce Platform', 'Extensive documentation', '2024-12-01', 1),
('Mobile App for Learning', 'Gamified learning modules', '2024-08-15', 2),
('Social Media Management Tool', 'User-friendly interface with analytics', '2024-10-31', 3),
('Inventory Management System', 'Barcode integration and real-time stock tracking', '2024-11-01', 4),
('Restaurant Reservation System', 'Online booking with table management', '2024-09-01', 5),
('Content Management System (CMS)', 'Drag-and-drop interface for easy content updates', '2024-12-15', 6),
('Customer Relationship Management (CRM)', 'Secure parent portal and communication tools', '2024-10-01', 7),
('Data Analytics Dashboard', 'Real-time visualization of key performance indicators (KPIs)', '2024-11-30', 8),
('E-learning Platform Development', 'Interactive course creation and delivery tools', '2024-09-15', 9),
('Bug Tracking and Issue Management System', 'Prioritization and collaboration features for bug reporting', '2024-12-31', 10);

-- Populate Project Team Table
INSERT INTO ProjectTeam (ProjectID, EmployeeID, IsTeamLead) VALUES
(1, 1, 0), (1, 2, 1), (1, 3, 0),
(2, 2, 1), (2, 4, 0), (2, 5, 0),
(3, 1, 0), (3, 3, 0), (3, 6, 1),
(4, 2, 1), (4, 4, 0), (4, 5, 0),
(5, 1, 0), (5, 6, 0), (5, 7, 1),
(6, 2, 1), (6, 3, 0), (6, 4, 0),
(7, 1, 0), (7, 6, 0), (7, 7, 1),
(8, 2, 1), (8, 4, 0), (8, 5, 0),
(9, 1, 0), (9, 3, 0), (9, 6, 1),
(10, 2, 1), (10, 4, 0), (10, 7, 0);