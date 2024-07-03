-- Triggers

-- Create a trigger to log any updates made to project records in a separate table for auditing purposes
CREATE TABLE ProjectLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectID INT,
    ChangeType VARCHAR(10),
    ChangeTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER LogProjectUpdates
AFTER UPDATE ON Projects
FOR EACH ROW
BEGIN
    INSERT INTO ProjectLog (ProjectID, ChangeType) VALUES (OLD.ProjectID, 'UPDATE');
END;

-- Create a trigger to ensure a team lead assigned to a project is a valid employee
CREATE TRIGGER ValidateTeamLead
BEFORE INSERT ON ProjectTeam
FOR EACH ROW
BEGIN
    IF NEW.IsTeamLead = 1 THEN
        IF (SELECT COUNT(*) FROM Employees WHERE EmployeeID = NEW.EmployeeID) = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid team lead ID';
        END IF;
    END IF;
END;

-- Create a view to display project details along with the total number of team members assigned
CREATE VIEW ProjectDetailsWithTeamSize AS
SELECT p.ProjectName, COUNT(pt.EmployeeID) AS TeamSize 
FROM Projects p
JOIN ProjectTeam pt ON p.ProjectID = pt.ProjectID
GROUP BY p.ProjectName;

-- Create a view to show overdue projects with the number of days overdue
CREATE VIEW OverdueProjects AS
SELECT p.ProjectName, DATEDIFF(CURDATE(), p.Deadline) AS DaysOverdue 
FROM Projects p
WHERE p.Deadline < CURDATE();

-- Create a stored procedure to update project team members (remove existing, add new ones)
CREATE PROCEDURE UpdateProjectTeam (
    IN pID INT, IN newTeamMembers JSON
)
BEGIN
    DECLARE teamMemberID INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur CURSOR FOR 
        SELECT JSON_UNQUOTE(JSON_EXTRACT(newTeamMembers, CONCAT('$[', n, '].EmployeeID'))) 
        FROM (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) n;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    DELETE FROM ProjectTeam WHERE ProjectID = pID AND IsTeamLead = 0;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO teamMemberID;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO ProjectTeam (ProjectID, EmployeeID, IsTeamLead) VALUES (pID, teamMemberID, 0);
    END LOOP;
    CLOSE cur;
END;

-- Create a trigger to prevent deleting a project that still has assigned team members
CREATE TRIGGER PreventProjectDeletion
BEFORE DELETE ON Projects
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM ProjectTeam WHERE ProjectID = OLD.ProjectID) > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete a project with assigned team members';
    END IF;
END;
