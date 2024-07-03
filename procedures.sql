-- Procedures

-- Create a stored procedure to add a new client and their first project in one call
CREATE PROCEDURE AddClientAndProject (
    IN cName VARCHAR(100), IN contactName VARCHAR(100), IN contactEmail VARCHAR(100),
    IN pName VARCHAR(100), IN requirements TEXT, IN deadline DATE
)
BEGIN
    DECLARE newClientID INT;
    INSERT INTO Clients (ClientName, ContactName, ContactEmail) 
    VALUES (cName, contactName, contactEmail);
    SET newClientID = LAST_INSERT_ID();
    INSERT INTO Projects (ProjectName, Requirements, Deadline, ClientID) 
    VALUES (pName, requirements, deadline, newClientID);
END;

-- Create a stored procedure to move completed projects (past deadlines) to an archive table
CREATE PROCEDURE ArchiveCompletedProjects ()
BEGIN
    CREATE TABLE IF NOT EXISTS ArchivedProjects LIKE Projects;
    INSERT INTO ArchivedProjects SELECT * FROM Projects WHERE Deadline < CURDATE();
    DELETE FROM Projects WHERE Deadline < CURDATE();
END;
