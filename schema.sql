-- Task 1: Create Tables and Primary Keys

-- Creating the restaurant table
CREATE TABLE restaurant (
    restaurant_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    ratings DECIMAL(2,1),
    review_count INT
);

-- Creating the address table
CREATE TABLE address (
    address_id SERIAL PRIMARY KEY,
    restaurant_id INT REFERENCES restaurant(restaurant_id),
    street_address TEXT NOT NULL,
    city VARCHAR(50),
    state VARCHAR(20),
    postal_code VARCHAR(10)
);

-- Creating the category table
CREATE TABLE category (
    category_id VARCHAR(2) PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Creating the dish table
CREATE TABLE dish (
    dish_id SERIAL PRIMARY KEY,
    dish_name VARCHAR(100) NOT NULL,
    price DECIMAL(5,2) NOT NULL,
    description TEXT,
    is_spicy BOOLEAN DEFAULT FALSE
);

-- Creating the review table
CREATE TABLE review (
    review_id SERIAL PRIMARY KEY,
    rating DECIMAL(2,1),
    review_text TEXT,
    review_date DATE DEFAULT CURRENT_DATE
);

-- Task 2: Define Relationships and Foreign Keys

-- One-to-One relationship between restaurant and address
ALTER TABLE address ADD CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurant(restaurant_id);

-- One-to-Many relationship between category and dish
ALTER TABLE dish ADD COLUMN category_id VARCHAR(2) REFERENCES category(category_id);

-- Many-to-Many relationship between category and dish using a cross-reference table
CREATE TABLE categories_dishes (
    category_id VARCHAR(2),
    dish_id INT,
    price DECIMAL(5,2),
    PRIMARY KEY (category_id, dish_id),
    FOREIGN KEY (category_id) REFERENCES category(category_id),
    FOREIGN KEY (dish_id) REFERENCES dish(dish_id)
);

-- Task 3: Insert Sample Data

-- Insert sample data for restaurant
INSERT INTO restaurant (name, phone_number, ratings, review_count)
VALUES ('Bytes of China', '617-555-1212', 3.9, 200);

-- Insert sample data for address
INSERT INTO address (restaurant_id, street_address, city, state, postal_code)
VALUES (1, '2020 Busy Street', 'Chinatown', 'MA', '02139');

-- Insert sample data for categories
INSERT INTO category (category_id, category_name, description)
VALUES
('AP', 'Appetizers', NULL),
('HS', 'House Specials', NULL),
('LS', 'Luncheon Specials', 'Served between 11:00 AM and 3:00 PM');

-- Insert sample data for dishes
INSERT INTO dish (dish_name, price, description, is_spicy, category_id)
VALUES
('Spring Rolls', 5.50, 'Crispy rolls with veggies', FALSE, 'AP'),
('Spicy Chicken', 8.95, 'Hot and spicy chicken', TRUE, 'HS');

-- Insert sample data for reviews
INSERT INTO review (rating, review_text, review_date)
VALUES
(5.0, 'Awesome service! Would love to come back!', '2020-05-22'),
(4.5, 'Small mix-up but great food.', '2020-04-01');

-- Insert sample data for categories_dishes
INSERT INTO categories_dishes (category_id, dish_id, price)
VALUES
('AP', 1, 5.50),
('HS', 2, 8.95),
('LS', 2, 8.95);

-- Task 4: Make Sample Queries

-- Query 1: Display restaurant name, address, and phone number
SELECT r.name, a.street_address, r.phone_number
FROM restaurant r
JOIN address a ON r.restaurant_id = a.restaurant_id;

-- Query 2: Get the best rating
SELECT MAX(rating) AS best_rating FROM review;

-- Query 3: Display dish name, price, and category sorted by dish name
SELECT d.dish_name, d.price, c.category_name
FROM dish d
JOIN category c ON d.category_id = c.category_id
ORDER BY d.dish_name;

-- Query 4: Display dish name, price, and category sorted by category name
SELECT c.category_name, d.dish_name, d.price
FROM dish d
JOIN category c ON d.category_id = c.category_id
ORDER BY c.category_name;

-- Query 5: Display all spicy dishes
SELECT d.dish_name AS spicy_dish_name, c.category_name, d.price
FROM dish d
JOIN category c ON d.category_id = c.category_id
WHERE d.is_spicy = TRUE;

-- Query 6: Display dish_id and count for dishes in multiple categories
SELECT dish_id, COUNT(dish_id) AS dish_count
FROM categories_dishes
GROUP BY dish_id
HAVING COUNT(dish_id) > 1;

-- Query 7: Display dish name and count for dishes in multiple categories
SELECT d.dish_name, COUNT(cd.dish_id) AS dish_count
FROM categories_dishes cd
JOIN dish d ON cd.dish_id = d.dish_id
GROUP BY d.dish_name
HAVING COUNT(cd.dish_id) > 1;

-- Query 8: Display best rating and the review text
SELECT r.rating AS best_rating, r.review_text
FROM review r
WHERE r.rating = (SELECT MAX(rating) FROM review);
