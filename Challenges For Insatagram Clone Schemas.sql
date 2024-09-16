USE instagram_clone;

-- Exercise 1: We want to reward our users who have been around the longest.
-- 			   Find the 5 oldest users.
SELECT 
    *
FROM
    users
ORDER BY created_at
LIMIT 5;

-- Exercise 2: What day of the week do most users register on?
-- 			   We need to figure out when to schedule an ad campgain
SELECT 
    DAYNAME(created_at) AS day_name,
    COUNT(*) AS total
FROM
    users
GROUP BY day_name
ORDER BY total DESC;

-- Version 2
SELECT date_format(created_at,'%W') AS 'day of the week', COUNT(*) AS 'total registration'
FROM users
GROUP BY 1
ORDER BY 2 DESC;

-- Excercise 3: We want to target our inactive users with an email campaign.
-- 				Find the users who have never posted a photo
SELECT 
    username
FROM
    users
        LEFT JOIN
    photos ON users.id = photos.user_id
WHERE
    photos.user_id IS NULL;
    
-- Exercise 4: We're running a new contest to see who can get the most likes on a single photo.
-- 			   WHO WON??!!
SELECT 
    username, photos.id, photos.image_url, COUNT(*) AS total
FROM
    photos
        JOIN
    likes ON likes.photo_id = photos.id
        JOIN
    users ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;

-- Version 2
SELECT 
    users.username,
    photos.id,
    photos.image_url,
    COUNT(*) AS Total_Likes
FROM
    likes
        JOIN
    photos ON photos.id = likes.photo_id
        JOIN
    users ON users.id = likes.user_id
GROUP BY photos.id
ORDER BY Total_Likes DESC
LIMIT 1;

-- Exercise 5: Our Investors want to know...
-- 			   How many times does the average user post?
-- 			   total number of photos/total number of users
SELECT ROUND(
	(SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users)
,2) AS avg_posts;

-- Exercise 6:A brand wants to know which hashtags to use in a post
-- 			  What are the top 5 most commonly used hashtags?
SELECT 
    id, tag_name, COUNT(photo_tags.tag_id) AS no_of_times_used
FROM
    tags
        JOIN
    photo_tags ON tags.id = photo_tags.tag_id
GROUP BY photo_tags.tag_id
ORDER BY no_of_times_used DESC
LIMIT 5;

-- Exercise 7: We have a small problem with bots on our site
-- 			   Find users who have liked every single photo on the site
SELECT 
    user_id,username,users.created_at,COUNT(*) AS total
FROM
    users
        INNER JOIN
    likes ON users.id = likes.user_id
GROUP BY likes.user_id
HAVING total = (SELECT 
        COUNT(*)
    FROM
        photos);


-- ADDITIONAL CHALLENGES

/*user ranking by postings higher to lower*/
SELECT users.username,COUNT(photos.image_url)
FROM users
JOIN photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY 2 DESC;


/*Total Posts by users (longer versionof SELECT COUNT(*)FROM photos) */
SELECT SUM(user_posts.total_posts_per_user)
FROM (SELECT users.username,COUNT(photos.image_url) AS total_posts_per_user
		FROM users
		JOIN photos ON users.id = photos.user_id
		GROUP BY users.id) AS user_posts;


/*total numbers of users who have posted at least one time */
SELECT COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
FROM users
JOIN photos ON users.id = photos.user_id;