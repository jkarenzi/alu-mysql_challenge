-- Functions

-- Create a function to calculate the number of days remaining until a project deadline
CREATE FUNCTION DaysUntilDeadline (pID INT) RETURNS INT
BEGIN
    DECLARE daysRemaining INT;
    SELECT DATEDIFF(Deadline, CURDATE()) INTO daysRemaining 
    FROM Projects 
    WHERE ProjectID = pID;
    RETURN daysRemaining;
END;

-- Create a function to calculate the number of days a project is overdue
CREATE FUNCTION DaysOverdue (pID INT) RETURNS INT
BEGIN
    DECLARE daysOverdue INT;
    SELECT DATEDIFF(CURDATE(), Deadline) INTO daysOverdue 
    FROM Projects 
    WHERE ProjectID = pID AND Deadline < CURDATE();
    RETURN daysOverdue;
END;