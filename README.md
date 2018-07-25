Demo SQL Data


Create one new user with username: admin and pw: admin 
```
INSERT INTO `User` (`id`, `username`, `password`)
VALUES
    (1, 'admin', '$2b$12$Rzu5qf0SVPRJphYXSmFFru5IJszhX9kHy5H4nR0k5LdN8Dq6ngSDK');
```

Create some posts:
```
INSERT INTO `Post` (`id`, `title`, `text`)
VALUES
    ('1', 'Hot Summer', 'foo bar'),
    ('2', 'It\'s even hotter', 'Great!'),
    ('3', 'Cold Winter ', 'Oh No'),
    ('4', 'Summer Time ', 'Holdiays booked?'),
    ('5', 'Vacation for free', 'Do it now'),
    ('6', 'Party ppl', 'Lets go'),
    ('7', 'It Sounds crazy', 'jeashash');
```

Create some comments:
```
INSERT INTO `Comment` (`id`, `postId`, `text`, `numberOfComments`)
VALUES
    ('1', '1', 'Thumbs Up', NULL),
    ('2', '1', 'juhu', NULL),
    ('3', '1', 'bäm', NULL),
    ('4', '2', 'juhu', NULL);
```