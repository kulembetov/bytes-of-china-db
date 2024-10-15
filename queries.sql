-- Query 1: Retrieve restaurant name, address, and phone number
SELECT r.name, a.street_address, r.phone_number
FROM restaurant r
JOIN address a ON r.restaurant_id = a.restaurant_id;

-- Query 2: Get the best rating the restaurant ever received
SELECT MAX(rating) AS best_rating
FROM review;

-- Query 3: Display dish name, price, and category, sorted by dish name
SELECT d.dish_name, d.price, c.category_name
FROM dish d
JOIN category c ON d.category_id = c.category_id
ORDER BY d.dish_name;

-- Query 4: Display dish name, price, and category, sorted by category name
SELECT c.category_name, d.dish_name, d.price
FROM dish d
JOIN category c ON d.category_id = c.category_id
ORDER BY c.category_name;

-- Query 5: Display all spicy dishes, their prices, and category
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

-- Query 8: Display the best rating along with the corresponding review text
SELECT r.rating AS best_rating, r.review_text
FROM review r
WHERE r.rating = (SELECT MAX(rating) FROM review);
