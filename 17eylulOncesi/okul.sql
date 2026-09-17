PRAGMA foreign_keys=ON;

CREATE TABLE IF NOT EXISTS students(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_number TEXT UNIQUE NOT NULL,
    full_name TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS courses(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_code TEXT UNIQUE NOT NULL,
    title TEXT NOT NULL,
    credit INTEGER NOT NULL CHECK(credit>0)
);

-- PIVOT TABLE: 
CREATE TABLE IF NOT EXISTS enrollments(
    student_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_code DATETIME DEFAULT CURRENT_TIMESTAMP,
    final_grade INTEGER CHECK(final_grade BETWEEN 0 AND 100),
    PRIMARY KEY(student_id, course_id), -- bir öğrenci aynı derse 2 kere kaydolamaz. 1 öğr-çok ders; 1 ders-çok öğr.  
    FOREIGN KEY(student_id) REFERENCES students(id) ON DELETE CASCADE, --öğrenci silinirse öğrenicinin kurslarını da sil
    FOREIGN KEY(course_id) REFERENCES courses(id) ON DELETE RESTRICT -- kurs silinmek istenirse ve o kursa öğrenci kayıtlıysa silme
);

INSERT INTO students(student_number,full_name) VALUES('OGR001','Abdullah Belli');
INSERT INTO courses(course_code,title,credit) VALUES('MOB101','Flutter Dersi',4);
INSERT INTO enrollments(student_id,course_id,final_grade) VALUES(1,2,85);

--- Test 1 Kursu silmeye çalışalım
DELETE FROM courses WHERE id=1;
--- ÇIKTI: Error:FOREIGN KEY contraint failed! (kurs silinemez  çünkü kayıtlı öğrenci var!)

--- Test 2 Öğrenciyi silelim
DELETE FROM students WHERE id=1;
--- öğrenci silindi

SELECT * FROM enrollments;
--- çıktı: boş. öğrenci silinnce kayıt satırı da silindi. 


