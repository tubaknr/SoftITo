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

------ SQL TOPLAMA İŞLEMİ ARAŞTIRMASI 
--- SUM() bir sütundaki nümerik toplamı bulur. NULL değerleri görmezden gelir. 
-- Örn:
SELECT SUM(sütun_ismi)
FROM tablo
WHERE şart;

SELECT SUM(student_note) FROM enrollments;
SELECT SUM(quantity) AS total FROM orders WHERE product_id=11;

--- AVG AVERAGE
SELECT AVG(student_notes) FROM enrollments;

--- MAX
SELECT MAX(student_notes) FROM enrollments;

--- MIN
SELECT MIN(student_notes) FROM enrollments;

--- COUNT
SELECT COUNT(*) FROM enrollments --- toplam kaç kişi kayıtlı
SELECT COUNT(student_notes) FROM enrollments --- kaç kişi sınava girdi
SELECT COUNT(*) FROM students --- toplam kaç öğrenci var
SELECT COUNT(*) AS 50_uzeri_notlu_ogrenci_sayisi FROM enrollments WHERE student_notes > 50 --- notu 50 üzerinde olan öğrenci sayısı


