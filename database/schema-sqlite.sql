-- this schema is for sqlite!

CREATE TABLE contest_entry (
	timestamp numeric, 
	user text, 
	tweet text,
	id numeric); --it's actually a long, but we're not indexing on it ever

--index the usernames for sorting
CREATE INDEX entry_user_asc on contest_entry (user ASC);
CREATE INDEX entry_user_desc on contest_entry (user DESC);

--index the timestamps for sorting
CREATE INDEX entry_timestamp_asc on contest_entry (timestamp ASC);
CREATE INDEX entry_timestamp_desc ON contest_entry (timestamp DESC);

CREATE UNIQUE INDEX tweet_id ON contest_entry (id);

--some views to keep things simple
CREATE VIEW first_entry AS SELECT * FROM contest_entry ORDER BY timestamp ASC LIMIT 1;
CREATE VIEW last_entry AS SELECT * FROM contest_entry ORDER BY timestamp DESC LIMIT 1;

CREATE VIEW users_asc AS SELECT * FROM contest_entry ORDER BY user ASC;
CREATE VIEW users_desc AS SELECT * FROM contest_entry ORDER by user DESC;

CREATE VIEW all_asc AS SELECT * FROM contest_entry ORDER BY timestamp ASC;
CREATE VIEW all_desc AS SELECT * FROM contest_entry ORDER BY timestamp DESC;

CREATE VIEW all_tweets AS SELECT tweet from contest_entry ORDER BY timestamp;
