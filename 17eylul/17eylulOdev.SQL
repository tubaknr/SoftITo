PRAGMA foreign_keys=ON;


--- ÖĞRENCİLER
CREATE TABLE IF NOT EXISTS students(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    student_id TEXT UNIQUE NOT NULL,
    phone TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


--- Bölümler
CREATE TABLE IF NOT EXISTS departments(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_name TEXT NOT NULL,
    department_head TEXT NOT NULL
);


--- Dersler
CREATE TABLE IF NOT EXISTS courses(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    department_id INTEGER NOT NULL,
    course_name TEXT NOT NULL,
    course_credit INTEGER NOT NULL CHECK(course_credit>0),
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE RESTRICT
);

--- Öğrenci - ders PİVOTU
CREATE TABLE IF NOT EXISTS enrollments(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    student_note INTEGER CHECK(student_note BETWEEN 0 AND 100),
    enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id,course_id),
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);
