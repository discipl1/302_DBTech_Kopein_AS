INSERT INTO users (name, email, gender, register_date, occupation_id)
VALUES 
('Копеин Александр', 'aboba@mail.ru', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'administrator')),
('Кармазов Никита', 'karmazovna@gmail.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'student')),
('Китаев Евгений', 'kitaevev@gmail.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'engineer')),
('Лоханов Иван', 'loxanov@gmail.com', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'student')),
('Лукьянов Роман', 'lukanovromocka@mail.ru', 'male', date('now'), 
    (SELECT id FROM occupations WHERE name = 'programmer'));


INSERT INTO movies (title, year)
VALUES 
('Хищник', 1987),
('Терминатор', 1984),
('Один дома', 1990);


INSERT INTO movies_genres (movie_id, genre_id)
VALUES 
((SELECT id FROM movies WHERE title = 'Хищник'), 
 (SELECT id FROM genres WHERE name = 'Thriller')),
((SELECT id FROM movies WHERE title = 'Хищник'), 
 (SELECT id FROM genres WHERE name = 'Horror')),
((SELECT id FROM movies WHERE title = 'Хищник'), 
 (SELECT id FROM genres WHERE name = 'Fantasy')),

((SELECT id FROM movies WHERE title = 'Терминатор'), 
 (SELECT id FROM genres WHERE name = 'Fantasy')),
((SELECT id FROM movies WHERE title = 'Терминатор'), 
 (SELECT id FROM genres WHERE name = 'Thriller')),
((SELECT id FROM movies WHERE title = 'Терминатор'), 
 (SELECT id FROM genres WHERE name = 'Action')),

((SELECT id FROM movies WHERE title = 'Один дома'), 
 (SELECT id FROM genres WHERE name = 'Сomedy')),
((SELECT id FROM movies WHERE title = 'Один дома'), 
 (SELECT id FROM genres WHERE name = 'Family'));

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES 
((SELECT id FROM users WHERE email = 'aboba@bk.ru'), 
 (SELECT id FROM movies WHERE title = 'Хищник'), 5.0, strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'aboba@bk.ru'), 
 (SELECT id FROM movies WHERE title = 'Терминатор'), 4.9, strftime('%s', 'now')),
((SELECT id FROM users WHERE email = 'aboba@bk.ru'), 
 (SELECT id FROM movies WHERE title = 'Один дома'), 4.8, strftime('%s', 'now'));
