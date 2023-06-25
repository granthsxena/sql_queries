- BEGIN Q1
select user1 from friendof where whenconfirmed is null and whenrejected is null;
-- END Q1
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q2

select forum.id, forum.topic, count(forum.topic) AS numsubs
from forum
left join subscribe on forum.id = subscribe.forum where whensubscribed is not null
group by forum.topic, forum.id;
-- END Q2
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q3
select forum, id, whenposted
from post
where forum is not null
order by post.whenposted desc limit 1;
-- END Q3
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q4
select  Following, Follower
from following;
-- END Q4
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q5
select CreatedBy, forum, count(post.id) as num from upvote 
left join post ON upvote.post = post.id  
left join forum ON post.forum = forum.id  
where parentpost is null 
group by forum order by num desc limit 1;
-- END Q5
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q6
-- join friendof and following and check for where following and whenconfirmed is null
-- pseudo code
select user1 from friendof
left join friendof.whenconfirmed = follower
where follower = null and whenconfirmed = null;

-- END Q6
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q7
select userID, likes as avgUpvotes from (select likes.userID, avg(likes.likes) as likes from 
(select post.id as postID, user.id as userID, count(post.id) as likes from user inner join post on post.postedby = user.Id
left join upvote on post.id = upvote.post
group by post.id, user.id) likes group by userID) final 
where likes >= 1;
-- END Q7
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q8

select child.id from (select post.id, count(post.id) as likes, parentPost
from post left join upvote on post.id = upvote.post group by post.id, parentPost)child
left join
(select post.id as id, count(post.id) as likes 
from post left join upvote on post.id = upvote.post group by post.id )parent on 
child.parentPost = parent.id
where child.likes > parent.likes;

-- END Q8
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q9
select distinct user.id from post left join user on user.id = post.postedby
left join upvote on user.id = upvote.User and upvote.post = post.id
left join friendof on user.id = friendof.user1 or friendof.user2 = user.id
and whenConfirmed is not null and
(post.postedBy = friendof.user1 or post.postedBy = friendof.user2)
left join admin on post.postedby = admin.id where post is not null;

-- END Q9
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
-- BEGIN Q10
select id as adminId, fid,
(case when SUBS is null then 0 else subs end) as SUBS
from (select adminId, max(forumId) as fid, max(subs.subs) as SUBS
from (select createdby as adminId, forum as forumId, count(user) as SUBS
from subscribe inner join forum on subscribe.forum = forum.id group by adminId, forumId) as subs
  group by adminId) as subs2
right join admin on subs2.adminid = admin.id


-- END Q10
-- ____________________________________________________________________________________________________________________________________________________________________________________________________________
