TABLE CREATION & DATA INSERTION

• RANK TABLE

CREATE TABLE Rank
(
rank_id    NUMBER PRIMARY KEY,
rank_name  VARCHAR2(50) NOT NULL
);

INSERT INTO Rank VALUES (1, 'Private');
INSERT INTO Rank VALUES (2, 'Sergeant');
INSERT INTO Rank VALUES (3, 'Captain');
INSERT INTO Rank VALUES (4, 'Major');
SELECT * FROM Rank;

• UNIT TABLE

CREATE TABLE Unit
(
unit_id    NUMBER PRIMARY KEY,
unit_name  VARCHAR2(50) NOT NULL,
location   VARCHAR2(100) NOT NULL
);

INSERT INTO Unit VALUES (101, 'Northern Command', 'Jammu & Kashmir');
INSERT INTO Unit VALUES (102, 'Eastern Command', 'Assam');
INSERT INTO Unit VALUES (103, 'Naval Fleet Alpha', 'Mumbai');
SELECT * FROM Unit;


• SOLDIER TABLE

CREATE TABLE Soldier
(
soldier_id  NUMBER PRIMARY KEY,
name        VARCHAR2(50) NOT NULL,
age         NUMBER,
rank_id     NUMBER,
unit_id     NUMBER,
CONSTRAINT fk_soldier_rank FOREIGN KEY (rank_id) REFERENCES Rank(rank_id),
CONSTRAINT fk_soldier_unit FOREIGN KEY (unit_id) REFERENCES Unit(unit_id)
);
INSERT INTO Soldier VALUES (1001, 'Rahul Singh', 25, 1, 101);
INSERT INTO Soldier VALUES (1002, 'Arjun Mehta', 28, 2, 101);
INSERT INTO Soldier VALUES (1003, 'Vikram Rao', 32, 3, 102);
INSERT INTO Soldier VALUES (1004, 'Karan Kapoor', 40, 4, 103);
SELECT * FROM Soldier;

• OPERATION TABLE

CREATE TABLE Operation
(
operation_id    NUMBER PRIMARY KEY,
operation_name  VARCHAR2(100) NOT NULL,
start_date      DATE,
end_date        DATE
);
INSERT INTO Operation VALUES (201, 'Operation Vijay', TO_DATE('1999-05-01', 'YYYY-MM-DD'), TO_DATE('1999-07-26', 'YYYY-MM-DD'));
INSERT INTO Operation VALUES (202, 'Operation Trident', TO_DATE('1971-12-04', 'YYYY-MM-DD'), TO_DATE('1971-12-06', 'YYYY-MM-DD'));
INSERT INTO Operation VALUES (203, 'Operation Parakram', TO_DATE('2001-12-15', 'YYYY-MM-DD'), TO_DATE('2002-10-16', 'YYYY-MM-DD'));
SELECT * FROM Operation;

• PARTICIPATION TABLE

CREATE TABLE Participation
(
soldier_id    NUMBER,
operation_id  NUMBER,
role          VARCHAR2(50),
CONSTRAINT pk_participation PRIMARY KEY (soldier_id, operation_id),
CONSTRAINT fk_participation_soldier FOREIGN KEY (soldier_id) REFERENCES Soldier(soldier_id),
CONSTRAINT fk_participation_operation FOREIGN KEY (operation_id) REFERENCES Operation(operation_id)
);

INSERT INTO Participation VALUES (1001, 201, 'Infantry');
INSERT INTO Participation VALUES (1002, 201, 'Medic');
INSERT INTO Participation VALUES (1003, 202, 'Commander');
INSERT INTO Participation VALUES (1004, 203, 'Naval Officer');
SELECT * FROM Participation;
________________________________________

	Queries 

• COMMIT
COMMIT;

• SAVEPOINT
SAVEPOINT before_update;

• UPDATE
UPDATE Soldier SET age = 26 WHERE soldier_id = 1001;

• ROLLBACK TO SAVEPOINT (undo update)
ROLLBACK TO before_update;

• DELETE
DELETE FROM Soldier WHERE soldier_id = 1002;

• ROLLBACK (undo delete)
ROLLBACK;

________________________________________

• DCL
GRANT SELECT, INSERT ON Soldier TO trainee_user;
REVOKE INSERT ON Soldier FROM trainee_user;

________________________________________

• STORED PROCEDURE

CREATE OR REPLACE PROCEDURE add_soldier
(
p_id NUMBER, p_name VARCHAR2, p_age NUMBER, p_rank NUMBER, p_unit NUMBER
) AS
BEGIN
  INSERT INTO Soldier VALUES (p_id, p_name, p_age, p_rank, p_unit);
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Soldier added successfully: ' || p_name);
END;
/
________________________________________
• FUNCTION

CREATE OR REPLACE FUNCTION get_soldier_count(p_unit NUMBER) RETURN NUMBER IS
v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM Soldier WHERE unit_id = p_unit;
  RETURN v_count;
END;
/
________________________________________
• TRIGGER

CREATE OR REPLACE TRIGGER trg_check_age
BEFORE INSERT OR UPDATE ON Soldier
FOR EACH ROW
BEGIN
  IF :NEW.age < 18 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Soldier age must be at least 18.');
  END IF;
END;
/
________________________________________
 JOIN QUERIES

• INNER JOIN: Soldier with Rank and Unit

SELECT s.soldier_id, s.name, r.rank_name, u.unit_name
FROM Soldier s
JOIN Rank r ON s.rank_id = r.rank_id
JOIN Unit u ON s.unit_id = u.unit_id;

• LEFT JOIN: Soldier count per unit

SELECT u.unit_name, COUNT(s.soldier_id) AS soldier_count
FROM Unit u
LEFT JOIN Soldier s ON u.unit_id = s.unit_id
GROUP BY u.unit_name;

• JOIN with filter: Soldiers in Operation Vijay

SELECT s.name, p.role
FROM Soldier s
JOIN Participation p ON s.soldier_id = p.soldier_id
JOIN Operation o ON p.operation_id = o.operation_id
WHERE o.operation_name = 'Operation Vijay';
________________________________________

• DROP TABLE
DROP TABLE Participation CASCADE CONSTRAINTS;

