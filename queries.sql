-- Queries

-- Find all projects with a deadline before December 1st, 2024
SELECT * FROM Projects WHERE Deadline < '2024-12-01';

-- List all projects for "Big Retail Inc." ordered by deadline
SELECT p.ProjectName, p.Requirements, p.Deadline 
FROM Projects p
JOIN Clients c ON p.ClientID = c.ClientID
WHERE c.ClientName = 'Big Retail Inc.'
ORDER BY p.Deadline;

-- Find the team lead for the "Mobile App for Learning" project
SELECT e.EmployeeName 
FROM Employees e
JOIN ProjectTeam pt ON e.EmployeeID = pt.EmployeeID
JOIN Projects p ON pt.ProjectID = p.ProjectID
WHERE p.ProjectName = 'Mobile App for Learning' AND pt.IsTeamLead = 1;

-- Find projects containing "Management" in the name
SELECT * FROM Projects WHERE ProjectName LIKE '%Management%';

-- Count the number of projects assigned to David Lee
SELECT COUNT(*) AS ProjectCount 
FROM ProjectTeam pt
JOIN Employees e ON pt.EmployeeID = e.EmployeeID
WHERE e.EmployeeName = 'David Lee';

-- Find the total number of employees working on each project
SELECT p.ProjectName, COUNT(pt.EmployeeID) AS EmployeeCount 
FROM Projects p
JOIN ProjectTeam pt ON p.ProjectID = pt.ProjectID
GROUP BY p.ProjectName;

-- Find all clients with projects having a deadline after October 31st, 2024
SELECT DISTINCT c.ClientName 
FROM Clients c
JOIN Projects p ON c.ClientID = p.ClientID
WHERE p.Deadline > '2024-10-31';

-- List employees who are not currently team leads on any project
SELECT e.EmployeeName 
FROM Employees e
LEFT JOIN ProjectTeam pt ON e.EmployeeID = pt.EmployeeID AND pt.IsTeamLead = 1
WHERE pt.IsTeamLead IS NULL;

-- Combine a list of projects with deadlines before December 1st and another list with "Management" in the project name
SELECT * FROM Projects 
WHERE Deadline < '2024-12-01'
UNION
SELECT * FROM Projects 
WHERE ProjectName LIKE '%Management%';

-- Display a message indicating if a project is overdue (deadline passed)
SELECT ProjectName, 
    CASE 
        WHEN Deadline < CURDATE() THEN 'Overdue'
        ELSE 'Not overdue'
    END AS Status
FROM Projects;