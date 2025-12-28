DROP TABLE IF EXISTS AppointmentServices;
DROP TABLE IF EXISTS WorkRecords;
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS SalaryRates;
DROP TABLE IF EXISTS Services;
DROP TABLE IF EXISTS Employees;


CREATE TABLE Employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    position TEXT NOT NULL CHECK(position IN ('Мастер', 'Администратор', 'Менеджер', 'Директор')),
    specialization TEXT NOT NULL CHECK(specialization IN ('Мужчины', 'Женщины', 'Универсал')),
    hire_date DATE NOT NULL DEFAULT (date('now')),
    dismissal_date DATE,
    is_active INTEGER NOT NULL DEFAULT 1 CHECK(is_active IN (0, 1)),
    phone TEXT UNIQUE,
    email TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CHECK(dismissal_date IS NULL OR dismissal_date >= hire_date),
    CHECK(phone IS NOT NULL OR email IS NOT NULL)
);


CREATE TABLE Services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    client_gender TEXT NOT NULL CHECK(client_gender IN ('Мужчины', 'Женщины', 'Универсал')),
    duration_minutes INTEGER NOT NULL CHECK(duration_minutes > 0),
    price DECIMAL(10, 2) NOT NULL CHECK(price >= 0),
    description TEXT,
    is_active INTEGER NOT NULL DEFAULT 1 CHECK(is_active IN (0, 1)),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(name, client_gender)
);


CREATE TABLE SalaryRates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    rate_percent DECIMAL(5, 2) NOT NULL CHECK(rate_percent > 0 AND rate_percent <= 100),
    effective_from DATE NOT NULL DEFAULT (date('now')),
    effective_to DATE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employees(id) ON DELETE RESTRICT,
    CHECK(effective_to IS NULL OR effective_to >= effective_from)
);


CREATE TABLE Appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status TEXT NOT NULL DEFAULT 'Запланировано' CHECK(status IN ('Запланировано', 'Выполнено', 'Отменено', 'Неявка')),
    client_name TEXT NOT NULL,
    client_phone TEXT,
    client_gender TEXT NOT NULL CHECK(client_gender IN ('Мужчина', 'Женщина')),
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES Employees(id) ON DELETE RESTRICT
);


CREATE TABLE AppointmentServices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES Services(id) ON DELETE RESTRICT,
    UNIQUE(appointment_id, service_id)
);


CREATE TABLE WorkRecords (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    work_date DATE NOT NULL DEFAULT (date('now')),
    work_time TIME NOT NULL DEFAULT (time('now')),
    actual_price DECIMAL(10, 2) NOT NULL CHECK(actual_price >= 0),
    completed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(id) ON DELETE SET NULL,
    FOREIGN KEY (employee_id) REFERENCES Employees(id) ON DELETE RESTRICT,
    FOREIGN KEY (service_id) REFERENCES Services(id) ON DELETE RESTRICT
);


CREATE INDEX idx_employees_active ON Employees(is_active);
CREATE INDEX idx_employees_position ON Employees(position);
CREATE INDEX idx_employees_specialization ON Employees(specialization);
CREATE INDEX idx_services_gender ON Services(client_gender);
CREATE INDEX idx_appointments_date ON Appointments(appointment_date, appointment_time);
CREATE INDEX idx_appointments_status ON Appointments(status);
CREATE INDEX idx_appointments_employee ON Appointments(employee_id);
CREATE INDEX idx_appointmentservices_appointment ON AppointmentServices(appointment_id);
CREATE INDEX idx_appointmentservices_service ON AppointmentServices(service_id);
CREATE INDEX idx_workrecords_date ON WorkRecords(work_date);
CREATE INDEX idx_workrecords_employee ON WorkRecords(employee_id);
CREATE INDEX idx_workrecords_service ON WorkRecords(service_id);
CREATE INDEX idx_salaryrates_employee ON SalaryRates(employee_id);
CREATE INDEX idx_salaryrates_dates ON SalaryRates(effective_from, effective_to);


BEGIN TRANSACTION;


INSERT INTO Employees (name, position, specialization, hire_date, phone, email) VALUES ('Иванова Мария Сергеевна', 'Мастер', 'Женщины', '2023-01-15', '+7-900-123-45-67', 'ivanova@salon.ru');
INSERT INTO Employees (name, position, specialization, hire_date, phone, email) VALUES ('Петров Петр Петрович', 'Мастер', 'Мужчины', '2023-02-20', '+7-900-234-56-78', 'petrov@salon.ru');
INSERT INTO Employees (name, position, specialization, hire_date, phone, email) VALUES ('Сидорова Анна Сергеевна', 'Мастер', 'Универсал', '2023-03-10', '+7-900-345-67-89', 'sidorova@salon.ru');
INSERT INTO Employees (name, position, specialization, hire_date, phone, email) VALUES ('Смирнова Елена Александровна', 'Администратор', 'Универсал', '2023-01-10', '+7-900-567-89-01', 'smirnova@salon.ru');
INSERT INTO Employees (name, position, specialization, hire_date, phone, email) VALUES ('Волков Алексей Николаевич', 'Менеджер', 'Универсал', '2023-04-01', '+7-900-678-90-12', 'volkov@salon.ru');
INSERT INTO Employees (name, position, specialization, hire_date, phone, email) VALUES ('Новикова Ольга Павловна', 'Мастер', 'Женщины', '2023-05-15', '+7-900-789-01-23', 'novikova@salon.ru');
INSERT INTO Employees (name, position, specialization, hire_date, dismissal_date, is_active, phone, email) VALUES ('Козлов Дмитрий Викторович', 'Мастер', 'Мужчины', '2022-11-05', '2024-06-30', 0, '+7-900-456-78-90', 'kozlov@salon.ru');

INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Стрижка мужская', 'Мужчины', 30, 800.00, 'Классическая мужская стрижка');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Стрижка + укладка мужская', 'Мужчины', 45, 1200.00, 'Стрижка с укладкой');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Бритье', 'Мужчины', 20, 600.00, 'Классическое бритье');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Стрижка бороды', 'Мужчины', 15, 500.00, 'Стрижка и оформление бороды');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Стрижка женская', 'Женщины', 60, 1500.00, 'Женская стрижка');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Стрижка + укладка женская', 'Женщины', 90, 2500.00, 'Стрижка с укладкой');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Окрашивание', 'Женщины', 120, 3500.00, 'Окрашивание волос');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Мелирование', 'Женщины', 150, 4500.00, 'Мелирование волос');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Химическая завивка', 'Женщины', 180, 5000.00, 'Химическая завивка волос');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Укладка', 'Женщины', 45, 1200.00, 'Укладка волос');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Мелирование', 'Универсал', 150, 4500.00, 'Мелирование волос (универсальная услуга)');
INSERT INTO Services (name, client_gender, duration_minutes, price, description) VALUES ('Укладка', 'Универсал', 45, 1200.00, 'Укладка волос (универсальная услуга)');

INSERT INTO SalaryRates (employee_id, rate_percent, effective_from) VALUES (1, 35.00, '2023-01-15');
INSERT INTO SalaryRates (employee_id, rate_percent, effective_from) VALUES (2, 40.00, '2023-02-20');
INSERT INTO SalaryRates (employee_id, rate_percent, effective_from) VALUES (3, 38.00, '2023-03-10');
INSERT INTO SalaryRates (employee_id, rate_percent, effective_from) VALUES (6, 36.00, '2023-05-15');
INSERT INTO SalaryRates (employee_id, rate_percent, effective_from) VALUES (7, 35.00, '2022-11-05');

INSERT INTO Appointments (employee_id, appointment_date, appointment_time, client_name, client_phone, client_gender, status) VALUES (1, date('now', '+1 day'), '10:00', 'Смирнова А.В.', '+7-911-111-11-11', 'Женщина', 'Запланировано');
INSERT INTO Appointments (employee_id, appointment_date, appointment_time, client_name, client_phone, client_gender, status) VALUES (1, date('now', '+1 day'), '14:00', 'Кузнецова Б.С.', '+7-911-222-22-22', 'Женщина', 'Запланировано');
INSERT INTO Appointments (employee_id, appointment_date, appointment_time, client_name, client_phone, client_gender, status) VALUES (2, date('now', '+1 day'), '10:30', 'Лебедев В.Д.', '+7-911-333-33-33', 'Мужчина', 'Запланировано');
INSERT INTO Appointments (employee_id, appointment_date, appointment_time, client_name, client_phone, client_gender, status) VALUES (3, date('now', '+1 day'), '11:00', 'Соколова Г.Е.', '+7-911-444-44-44', 'Женщина', 'Запланировано');
INSERT INTO Appointments (employee_id, appointment_date, appointment_time, client_name, client_phone, client_gender, status) VALUES (6, date('now', '+2 days'), '09:00', 'Попова Д.Ж.', '+7-911-555-55-55', 'Женщина', 'Запланировано');
INSERT INTO Appointments (employee_id, appointment_date, appointment_time, client_name, client_phone, client_gender, status) VALUES (2, date('now', '+2 days'), '15:00', 'Васильев Е.З.', '+7-911-666-66-66', 'Мужчина', 'Запланировано');
INSERT INTO Appointments (employee_id, appointment_date, appointment_time, client_name, client_phone, client_gender, status) VALUES (1, date('now', '-1 day'), '10:00', 'Петрова И.И.', '+7-911-777-77-77', 'Женщина', 'Выполнено');
INSERT INTO Appointments (employee_id, appointment_date, appointment_time, client_name, client_phone, client_gender, status) VALUES (3, date('now', '-1 day'), '11:30', 'Иванов К.Л.', '+7-911-888-88-88', 'Мужчина', 'Выполнено');

INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (1, 5);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (1, 10);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (2, 7);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (3, 1);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (3, 3);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (4, 5);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (5, 6);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (6, 1);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (6, 4);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (7, 5);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (7, 10);
INSERT INTO AppointmentServices (appointment_id, service_id) VALUES (8, 1);

INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (7, 1, 5, date('now', '-1 day'), '10:00', 1500.00, 'Стрижка выполнена качественно');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (7, 1, 10, date('now', '-1 day'), '10:45', 1200.00, 'Укладка выполнена');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (8, 3, 1, date('now', '-1 day'), '11:30', 800.00, 'Клиент доволен');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (NULL, 2, 1, date('now', '-2 days'), '14:00', 800.00, 'Работа без предварительной записи');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (NULL, 2, 3, date('now', '-2 days'), '14:30', 600.00, 'Бритье выполнено');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (NULL, 1, 7, date('now', '-3 days'), '16:00', 3500.00, 'Окрашивание выполнено');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (NULL, 6, 5, date('now', '-4 days'), '12:00', 1500.00, 'Первая работа нового мастера');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (NULL, 3, 1, date('now', '-5 days'), '10:00', 800.00, 'Мужская стрижка');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (NULL, 1, 6, date('now', '-6 days'), '13:00', 2500.00, 'Стрижка с укладкой');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (NULL, 2, 1, date('now', '-7 days'), '09:00', 800.00, 'Утренняя стрижка');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (NULL, 3, 5, date('now', '-8 days'), '15:00', 1500.00, 'Женская стрижка');
INSERT INTO WorkRecords (appointment_id, employee_id, service_id, work_date, work_time, actual_price, notes) VALUES (NULL, 6, 10, date('now', '-9 days'), '11:00', 1200.00, 'Укладка');

COMMIT;
