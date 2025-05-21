-- Запросы для функциональных требований (15 шт.):

-- 1. Найти всех кандидатов и их вакансии
SELECT candidate.FullName, vacancy.EmploymentType
FROM candidate
INNER JOIN vacancy ON candidate.vacancy_idVacancy = vacancy.idVacancy;

-- 2. Вывести проекты и их руководителей
SELECT project.Name, `head of proj`.FullName
FROM project
INNER JOIN `head of proj` ON project.`head of proj_idHead of proj` = `head of proj`.`idHead of proj`;

-- 3. Получить список вакансий с зарплатой по должностям
SELECT vacancy.idVacancy, position.Name, position.Salary
FROM vacancy
INNER JOIN position ON vacancy.position_idPosition = position.idPosition;

-- 4. Вывести количество активных вакансий по каждому HR-менеджеру
SELECT `hr-manager`.ContactsOFcandidates, `hr-manager`.ActiveVacancies
FROM `hr-manager`;

-- 5. Список сотрудников отделов с руководителями
SELECT department.Name AS 'Отдел', `head of dep`.FullName AS 'Руководитель'
FROM department
INNER JOIN `head of dep` ON department.`head of dep_idHead of Dep` = `head of dep`.`idHead of Dep`;

-- 6. Вывести названия проектов и даты их завершения
SELECT Name, `End Date`
FROM project;

-- 7. Получить данные об отделах и количестве участников приемной комиссии
SELECT department.Name, `admissions committee`.NumOFmembers
FROM department
INNER JOIN `admissions committee` ON department.idDepartment = `admissions committee`.department_idDepartment;

-- 8. Вывести роли и зарплаты по проектам
SELECT role.Name, role.Salary, `head of proj`.FullName
FROM role
INNER JOIN `head of proj` ON role.`head of proj_idHead of proj` = `head of proj`.`idHead of proj`;

-- 9. Список кандидатов с номерами телефонов HR
SELECT candidate.FullName, `hr-manager`.ContactsOFcandidates
FROM candidate
INNER JOIN `hr-manager` ON candidate.`hr-manager_idHR-Manager` = `hr-manager`.`idHR-Manager`;

-- 10. Вывести список вакансий с типом занятости \"Полный день\"
SELECT * FROM vacancy WHERE EmploymentType = 'Полный день';

-- 11. Список ролей с зарплатами
SELECT Name, Salary FROM role;

-- 12. Показать все проекты с датами начала и окончания
SELECT Name, StartDate, `End Date` FROM project;

-- 13. Показать список позиций и зарплат
SELECT Name, Salary FROM position;

-- 14. Вывести кандидатов с указанием типа занятости вакансий
SELECT candidate.FullName, vacancy.EmploymentType
FROM candidate
JOIN vacancy ON candidate.vacancy_idVacancy = vacancy.idVacancy;

-- 15. Показать количество вакансий каждого HR-менеджера
SELECT ContactsOFcandidates, ActiveVacancies FROM `hr-manager`;


-- Дополнительные простые SELECT запросы (85 шт.):

-- Запросы с WHERE и AND/OR
-- 16. Кандидаты с резюме и документами
SELECT FullName FROM candidate WHERE Summary = 1 AND Docs = 1;

-- 17. Отделы с активностью \"Разработка ПО\"
SELECT Name FROM department WHERE Activity = 'Разработка ПО';

-- 18. Руководители отделов без одобрения
SELECT FullName FROM `head of dep` WHERE NOT FinDecision = 'Одобрено';

-- 19. Проекты, которые заканчиваются после июня 2025 года
SELECT Name FROM project WHERE `End Date` > '2025-06-30';

-- 20. Роли с зарплатой от 90000 до 150000
SELECT Name FROM role WHERE Salary BETWEEN 90000 AND 150000;

-- Запросы с LIKE
-- 21. Кандидаты, чья фамилия начинается на \"С\"
SELECT FullName FROM candidate WHERE FullName LIKE 'С%';

-- 22. Отделы, содержащие слово \"маркетинг\"
SELECT Name FROM department WHERE Name LIKE '%маркетинг%';

-- INSERT SELECT
-- 23. Создание резервной копии позиций
CREATE TABLE position_backup AS SELECT * FROM position;

-- 24. Создание копии руководителей проектов
CREATE TABLE head_of_proj_backup AS SELECT * FROM `head of proj`;

-- GROUP BY
-- 25. Средняя зарплата по позициям
SELECT Name, AVG(Salary) FROM position GROUP BY Name;

-- 26. Количество проектов по статусу решения руководителя
SELECT FinDecision, COUNT(*) FROM `head of proj` GROUP BY FinDecision;

-- Сложные запросы
-- 1. Список кандидатов с данными по их вакансии, роли и позиции
SELECT 
    c.idCandidate,
    c.FullName AS CandidateName,
    v.idVacancy,
    v.EmploymentType,
    p.Name AS PositionName,
    r.Name AS RoleName
FROM candidate c
JOIN vacancy v ON c.vacancy_idVacancy = v.idVacancy
JOIN `position` p ON v.position_idPosition = p.idPosition
JOIN role r ON v.role_idRole = r.idRole
WHERE v.EmploymentType = 'Full-time'
ORDER BY c.FullName
LIMIT 100000;

-- 2. Находит проекты с описанием, содержащим "Design", и сортирует их по числу членов комиссии.
SELECT 
    pr.idProject,
    pr.Name,
    pr.Description,
    ac.NumOfMembers
FROM project pr
JOIN admissions_committee ac ON pr.admissions_committee_idAdmissionsCommittee = ac.idAdmissionsCommittee
WHERE pr.Description LIKE '%Design%'
GROUP BY pr.idProject
ORDER BY ac.NumOfMembers DESC
LIMIT 100000;

-- 3. Сколько вакансий у каждого HR-менеджера, сгруппировано по имени менеджера
SELECT 
    hr.idHR_Manager,
    COUNT(c.idCandidate) AS CandidateCount,
    COUNT(DISTINCT v.idVacancy) AS VacancyCount
FROM hr_manager hr
JOIN candidate c ON hr.idHR_Manager = c.hr_manager_idHR_Manager
JOIN vacancy v ON c.vacancy_idVacancy = v.idVacancy
GROUP BY hr.idHR_Manager
ORDER BY CandidateCount DESC
LIMIT 100000;

-- 4.Выбирает роли, у которых зарплата с надбавкой превышает 100,000.
SELECT 
    r.idRole,
    r.Name,
    r.Salary
FROM role r
JOIN vacancy v ON r.idRole = v.role_idRole
WHERE (r.Salary * 1.2) > 100000
ORDER BY r.Salary DESC
LIMIT 100000;

-- 5. Средняя зарплата по ролям с заданным начальником проекта
SELECT r.idRole, r.Name, AVG(r.Salary) AS AvgSalary
FROM role r
WHERE r.head_of_proj_idHead_of_proj + 0 = 5
GROUP BY r.idRole
ORDER BY AvgSalary DESC;

-- 6. Связывает кандидатов с ролями и проектами по совпадению ID.
SELECT 
    c.FullName,
    r.Name AS RoleName,
    pr.Name AS ProjectName
FROM candidate c
JOIN role r ON r.idRole = c.idCandidate  -- нет логической связи
JOIN project pr ON pr.idProject = c.idCandidate  -- тоже нет
ORDER BY c.FullName
LIMIT 100000;

-- 7. Число вакансий по типу занятости
SELECT 
    v.EmploymentType,
    COUNT(*) AS VacancyCount
FROM vacancy v
GROUP BY v.EmploymentType
ORDER BY VacancyCount DESC;

-- 8. Средняя зарплата по ролям с заданным начальником проекта
SELECT r.idRole, r.Name, AVG(r.Salary) AS AvgSalary
FROM role r
WHERE r.head_of_proj_idHead_of_proj = 3
GROUP BY r.idRole
ORDER BY AvgSalary DESC;

-- 9НЕРАБОТАЕТ. Список вакансий с количеством привязанных кандидатов и их типом занятости
SELECT 
    v.idVacancy,
    v.EmploymentType,
    COUNT(c.idCandidate) AS CandidateCount
FROM vacancy v
LEFT JOIN candidate c ON v.idVacancy = c.vacancy_idVacancy
GROUP BY v.idVacancy, v.EmploymentType
ORDER BY CandidateCount DESC
LIMIT 100000;

-- 10. Средняя зарплата позиций по каждому департаменту
SELECT 
    d.idDepartment,
    d.Name AS DepartmentName,
    AVG(p.Salary) AS AvgPositionSalary
FROM department d
JOIN head_of_dep hd ON d.head_of_dep_idHead_of_Dep = hd.idHead_of_Dep
JOIN `position` p ON p.head_of_dep_idHead_of_Dep = hd.idHead_of_Dep
GROUP BY d.idDepartment
ORDER BY AvgPositionSalary DESC
LIMIT 50000;

-- 11. Ищет проекты, которые начались в 2022 году.
SELECT 
    pr.idProject,
    pr.Name,
    pr.StartDate
FROM project pr
WHERE YEAR(pr.StartDate) = 2022
ORDER BY pr.StartDate
LIMIT 100000;

-- 12. Ищет HR-менеджеров с email-контактами на gmail.com и сортирует по приоритету первичного отбора.
SELECT 
    hr.idHR_Manager,
    hr.ContactOfCandidates,
    hr.PrimarySelection
FROM hr_manager hr
WHERE hr.ContactOfCandidates LIKE '%gmail.com%'
ORDER BY hr.PrimarySelection DESC;
SHOW PROFILES;

-- Запросы UPDATE
-- 28. Обновить тип занятости вакансии
UPDATE vacancy SET EmploymentType = 'Удалённая работа' WHERE EmploymentType = 'Полный день';

-- 29. Увеличить зарплату всех разработчиков на 5000
UPDATE position SET Salary = Salary + 5000 WHERE Name = 'Разработчик';

-- Запросы DELETE
-- 30. Удалить HR-менеджеров с менее чем 3 вакансиями
DELETE FROM `hr-manager` WHERE ActiveVacancies < 3;

-- 31. Удалить проект, заканчивающийся до мая 2025 года
DELETE FROM project WHERE `End Date` < '2025-05-01';

-- Доп запросы join.
-- 32. Все возможные комбинации кандидатов и HR-менеджеров (перекрёстно):
SELECT c.FullName AS "Кандидат", h.ContactsOFcandidates AS "Контакты HR"
FROM candidate c
CROSS JOIN `hr-manager` h;

-- 33.Полный список отделов и руководителей (даже если у руководителя нет отдела и наоборот):
SELECT d.Name AS "Департамент", hd.FullName AS "Руководитель"
FROM department d
LEFT JOIN `head of dep` hd ON d.`head of dep_idHead of Dep` = hd.`idHead of Dep`

UNION

SELECT d.Name, hd.FullName
FROM department d
RIGHT JOIN `head of dep` hd ON d.`head of dep_idHead of Dep` = hd.`idHead of Dep`;

-- 34. Создание связи многие ко многим.
CREATE TABLE skills (
  idSkill INT PRIMARY KEY,
  SkillName VARCHAR(45)
);

CREATE TABLE candidate_skills (
  idCandidate INT,
  idSkill INT,
  PRIMARY KEY(idCandidate, idSkill),
  FOREIGN KEY (idCandidate) REFERENCES candidate(idCandidate),
  FOREIGN KEY (idSkill) REFERENCES skills(idSkill)
);
INSERT INTO skills (idSkill, SkillName) VALUES
(1, 'SQL'), (2, 'Java'), (3, 'Python');

INSERT INTO candidate_skills (idCandidate, idSkill) VALUES
(1000, 1), (1000, 2), (1001, 2), (1002, 3), (1003, 1);

-- Запросы многие ко многим
-- 35. Навыки кандидата.
SELECT c.FullName, s.SkillName
FROM candidate c
INNER JOIN candidate_skills cs ON c.idCandidate = cs.idCandidate
INNER JOIN skills s ON cs.idSkill = s.idSkill;

-- 36. Все кандидаты с навыком SQL.
SELECT c.FullName
FROM candidate c
INNER JOIN candidate_skills cs ON c.idCandidate = cs.idCandidate
INNER JOIN skills s ON cs.idSkill = s.idSkill
WHERE s.SkillName = 'SQL';

-- Доп запросы UPDATE
-- 37. Изменить решение руководителя департамента на "Одобрено":
UPDATE `head of dep`
SET FinDecision = 'Одобрено'
WHERE idHeadofDep = 3;

-- 38. Повысить зарплату всем уборщицам на 5000 руб.:
UPDATE position
SET Salary = Salary + 5000
WHERE Name = 'Уборщица';

-- 39.Обновить номер телефона HR-менеджера по его ID:
UPDATE `hr-manager`
SET ContactsOFcandidates = '+7 (900) 111-22-33'
WHERE `idHR-Manager` = 5004;

-- 40.Изменить количество активных вакансий на 0
-- у менеджеров, у которых больше 10 вакансий:
UPDATE `hr-manager`
SET ActiveVacancies = 0
WHERE ActiveVacancies > 10;

-- 41.Обновить название роли с «Дурочка» на «Ассистент»:
UPDATE role
SET Name = 'Ассистент'
WHERE Name = 'Дурочка';

-- 42. Обновить тип занятости на "Удалёнка" для конкретной вакансии:
UPDATE vacancy
SET EmploymentType = 'Удалёнка'
WHERE idVacancy = 8003;

-- 43. Изменить время работы вакансий с "9:00 - 18:00" на "10:00 - 19:00":
UPDATE vacancy
SET WorkTime = '10:00 - 19:00'
WHERE WorkTime = '9:00 - 18:00';

-- 44.Обновить имя руководителя проекта с ID 4002:
UPDATE `head of proj`
SET FullName = 'Петров С.С.'
WHERE `idHead of proj` = 4002;

-- 45. Установить зарплату 80000 всем поварам:
UPDATE position
SET Salary = 80000
WHERE Name = 'Повар';

-- 46.Изменить описание проекта с ID 7004:
UPDATE project
SET Description = 'Новая версия документа'
WHERE idProject = 7004;

-- 47. Изменить статус проверки качества комиссии с 1 на 3:
UPDATE `admissions committee`
SET QualityControl = 3
WHERE QualityControl = 1;

-- 48. Поменять имя кандидата с ID 1005:
UPDATE candidate
SET FullName = 'Васильева Ольга Леонидовна'
WHERE idCandidate = 1005;

-- 49. Изменить количество членов комиссии до 7 там, где оно равно 5:
UPDATE `admissions committee`
SET NumOFmembers = 7
WHERE NumOFmembers = 5;

-- 50.Обновить контакт HR-менеджера с конкретным телефоном:
UPDATE `hr-manager`
SET ContactsOFcandidates = '+7 (977) 123-00-00'
WHERE ContactsOFcandidates = '+7 (917) 123-45-67';

-- 51. Изменить должностные обязанности роли "Плейбой":
UPDATE role
SET Responsibilities = 'Контроль процессов'
WHERE Name = 'Плейбой';

-- 52. Сменить должность с «работяга» на «Специалист»:
UPDATE position
SET Name = 'Специалист'
WHERE Name = 'работяга';

-- 53. Изменить решение руководителя проекта с "Отклонено" на "Одобрено":
UPDATE `head of proj`
SET FinDecision = 'Одобрено'
WHERE FinDecision = 'Отклонено';

-- 54.Обновить тип документа у кандидатов на "Загранпаспорт":
UPDATE candidate
SET Docs = 'Загранпаспорт'
WHERE Docs = 'Паспорт';

-- 55. Уменьшить зарплату всех сотрудников, у которых она выше 70000, на 5000:
UPDATE position
SET Salary = Salary - 5000
WHERE Salary > 70000;

-- 56. Изменить статус проверки качества комиссии по конкретному ID на максимальный (5):
UPDATE `admissions committee`
SET QualityControl = 5
WHERE idAdmissionsCommittee = 2;

-- Доп запросы DELETE
-- 57.Удалить кандидата с конкретным ID:
DELETE FROM candidate
WHERE idCandidate = 1009;

-- 58. Удалить HR-менеджера с номером телефона "+7 (343) 222-11-00":
DELETE FROM `hr-manager`
WHERE ContactsOFcandidates = '+7 (343) 222-11-00';

-- 59. Удалить роль с названием "Филантро":
DELETE FROM role
WHERE Name = 'Филантро';

-- 60. Удалить вакансию с ID = 8004:
DELETE FROM vacancy
WHERE idVacancy = 8004;

-- 61. Удалить департамент с названием "Кофетерий":
DELETE FROM department
WHERE Name = 'Кофетерий';

-- c LIKE
-- 62. Удалить всех кандидатов с ID меньше 1003:
DELETE FROM candidate
WHERE idCandidate < 1003;

-- 63. Удалить всех руководителей департаментов, чьё решение — "Отклонено":
DELETE FROM `head of dep`
WHERE FinDecision = 'Отклонено';

-- 64. Удалить все роли, зарплата которых меньше 2000:
DELETE FROM role
WHERE Salary < 2000;

-- 65.Удалить проекты, имя которых начинается на 'Ю':
DELETE FROM project
WHERE Name LIKE 'К%';

-- 66.Удалить всех кандидатов, у которых имя содержит "Иванов":
DELETE FROM candidate
WHERE FullName LIKE '%Иванов%';

-- 67.Удалить все вакансии, которые не назначены ни одному HR-менеджеру:
DELETE FROM vacancy
WHERE idVacancy NOT IN (
  SELECT vacancy_idVacancy FROM `hr-manager`
);

-- 68.Удалить все департаменты, у которых нет связанных комиссий:
DELETE FROM department
WHERE idDepartment NOT IN (
  SELECT department_idDepartment FROM `admissions committee`
);

-- 69.Удалить всех кандидатов, у которых нет резюме (например, если поле пустое — условное значение):
DELETE FROM candidate
WHERE Summary = '';

-- 70. Удалить все проекты, у которых дата окончания раньше 2023-12-01:
DELETE FROM project
WHERE `End Date` < '2023-12-01';

-- 71. Количество кандидатов у каждого HR-менеджера:
SELECT `hr-manager_idHR-Manager`, COUNT(*) AS Количество
FROM candidate
GROUP BY `hr-manager_idHR-Manager`;

-- 72.Количество ролей у каждого руководителя проектов:
SELECT `head of proj_idHead of proj`, COUNT(*) AS роли
FROM role
GROUP BY `head of proj_idHead of proj`;

-- 73. Количество вакансий по каждой должности:
SELECT position_idPosition, COUNT(*) AS кол_во_вакансий
FROM vacancy
GROUP BY position_idPosition;

-- 74.Количество вакансий у каждого HR-менеджера:
SELECT vacancy_idVacancy, COUNT(*) AS использований
FROM `hr-manager`
GROUP BY vacancy_idVacancy;

-- 75.Средняя зарплата по должностям:
SELECT Name, AVG(Salary) AS средняя_зарплата
FROM position
GROUP BY Name;

-- 76.Максимальная зарплата по ролям:
SELECT Name, MAX(Salary) AS макс_зарплата
FROM role
GROUP BY Name;

-- 77.Суммарное количество активных вакансий по каждому HR:
SELECT `idHR-Manager`, SUM(ActiveVacancies) AS всего_вакансий
FROM `hr-manager`
GROUP BY `idHR-Manager`;

-- 78. Минимальное количество членов в комиссиях по каждому департаменту:
SELECT department_idDepartment, MIN(NumOFmembers) AS мин_члены
FROM `admissions committee`
GROUP BY department_idDepartment;

-- 79.Среднее значение проверки качества по каждому отделу:
SELECT department_idDepartment, AVG(QualityControl) AS средний_контроль
FROM `admissions committee`
GROUP BY department_idDepartment;

-- 80. HR-менеджеры, у которых более 1 активной вакансии:
SELECT `idHR-Manager`, ActiveVacancies
FROM `hr-manager`
GROUP BY `idHR-Manager`, ActiveVacancies
HAVING ActiveVacancies > 1;

-- 81. Руководители департаментов с более чем 1 подчинённым департаментом:
SELECT `head of dep_idHead of Dep`, COUNT(*) AS кол_во
FROM department
GROUP BY `head of dep_idHead of Dep`
HAVING COUNT(*) > 1;

-- 82. Должности с зарплатой в среднем выше 60,000:
SELECT Name, AVG(Salary) AS средняя
FROM position
GROUP BY Name
HAVING AVG(Salary) > 60000;

-- 83.Роли, у которых средняя зарплата ровно 200000:
SELECT Name
FROM role
GROUP BY Name
HAVING AVG(Salary) = 200000;

-- 84. Топ-3 вакансии по ID:
SELECT idVacancy, WorkTime
FROM vacancy
ORDER BY idVacancy DESC
LIMIT 3;

-- 85. Топ-5 самых высокооплачиваемых должностей:
SELECT Name, Salary
FROM position
ORDER BY Salary DESC
LIMIT 5;

-- 86. 2 отдела с наименьшим количеством подчинённых комиссий:
SELECT department_idDepartment, COUNT(*) AS комиссии
FROM `admissions committee`
GROUP BY department_idDepartment
ORDER BY COUNT(*) ASC
LIMIT 2;

-- 87. Среднее, минимум и максимум по активным вакансиям HR-менеджеров:
SELECT 
  AVG(ActiveVacancies) AS среднее,
  MIN(ActiveVacancies) AS минимум,
  MAX(ActiveVacancies) AS максимум
FROM `hr-manager`;

-- 88. Количество кандидатов по ФИО (для проверки уникальности):
SELECT FullName, COUNT(*) AS сколько
FROM candidate
GROUP BY FullName
ORDER BY COUNT(*) DESC;

-- 89. Подсчёт количества вакансий и суммарной зарплаты по каждой роли:
SELECT r.Name AS Роль, COUNT(v.idVacancy) AS вакансии, SUM(p.Salary) AS сумма_зарплат
FROM vacancy v
JOIN role r ON v.role_idrole = r.idrole
JOIN position p ON v.position_idPosition = p.idPosition
GROUP BY r.Name
ORDER BY сумма_зарплат DESC;

-- 90. Получить список имён всех кандидатов и руководителей департаментов (объединённый список):
SELECT FullName FROM candidate
UNION
SELECT FullName FROM `head of dep`;

-- 91. То же самое, но с повторениями (UNION ALL):
SELECT FullName FROM candidate
UNION ALL
SELECT FullName FROM `head of dep`;

-- 92.Все телефоны HR и имена руководителей проектов (разные типы данных, приведём к строке):
SELECT ContactsOFcandidates AS info FROM `hr-manager`
UNION
SELECT FullName FROM `head of proj`;

-- 93. Все вакансии и роли по ID, которые меньше 8005 (только уникальные):
SELECT idVacancy AS id FROM vacancy WHERE idVacancy < 8005
UNION
SELECT idrole FROM role WHERE idrole < 8005;

-- 94. Все сотрудники с зарплатой выше 75000 — из двух таблиц:
SELECT Name, Salary FROM role WHERE Salary > 75000
UNION
SELECT Name, Salary FROM position WHERE Salary > 75000;

-- Эмуляция INTERSECT (через IN / INNER JOIN)
-- 95. Все FullName, которые одновременно есть у кандидатов и у руководителей департаментов:
SELECT FullName FROM candidate
WHERE FullName IN (SELECT FullName FROM `head of dep`);

-- 96.Все роли, у которых Salary такой же, как у какой-либо позиции:
SELECT Name FROM role
WHERE Salary IN (SELECT Salary FROM position);

-- 97. Проекты, у которых есть одно и то же название с другим проектом (эмуляция пересечений по полю):
SELECT p1.Name
FROM project p1
INNER JOIN project p2 ON p1.Name = p2.Name AND p1.idProject != p2.idProject;

-- 98. Кандидаты, которые не являются руководителями департаментов:
SELECT FullName FROM candidate
WHERE FullName NOT IN (SELECT FullName FROM `head of dep`);

-- 99. Роли, которых нет в таблице вакансий (по ID):
SELECT idrole FROM role
WHERE idrole NOT IN (SELECT role_idrole FROM vacancy);

-- 100.Названия департаментов, у которых нет комиссий (аналог EXCEPT):
SELECT Name FROM department d
WHERE d.idDepartment NOT IN (
  SELECT department_idDepartment FROM `admissions committee`
);