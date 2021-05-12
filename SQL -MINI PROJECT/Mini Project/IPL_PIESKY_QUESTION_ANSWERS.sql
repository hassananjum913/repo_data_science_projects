use ipl;

-- 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.
SELECT 
    ibd.bidder_id AS bidder_id,
    ibd.bidder_name AS bidder_name,
    (SUM(CASE
        WHEN ibnd.BID_STATUS = 'Won' THEN 1
        ELSE 0
    END) / COUNT(ibnd.BID_STATUS)) * 100 AS win_percentage
FROM
    ipl_bidder_details AS ibd
        JOIN
    ipl_bidding_details AS ibnd USING (bidder_id)
GROUP BY ibd.bidder_id
ORDER BY win_percentage DESC; 




-- 2.	Display the number of matches conducted at each stadium with stadium name, city from the database.
SELECT 
    st.stadium_id AS stadium_id,
    st.stadium_name AS stadium_name,
    st.city AS city,
    COUNT(ms.schedule_id) AS total_matches
FROM
    ipl_stadium AS st
        JOIN
    ipl_match_schedule AS ms USING (stadium_id)
GROUP BY stadium_id
ORDER BY stadium_id;



-- 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?
SELECT 
    ims.stadium_id AS stadium_id,
    im.team_id1 AS team_id,
    ((SUM(CASE
        WHEN im.toss_winner = im.match_winner THEN 1
        ELSE 0
    END) / COUNT(match_id)) * 100) AS perct_win_of_winner
FROM
    ipl_match AS im
        JOIN
    ipl_match_Schedule AS ims USING (match_id)
GROUP BY stadium_id , team_id
ORDER BY stadium_id , team_id;

-- 4.	Show the total bids along with bid team and team name.
SELECT 
    ibd.bidder_id AS bidder_id,
    ibd.bid_team AS bid_team,
    it.team_name AS team_name,
    SUM(ibp.no_of_bids) AS total_bid_counts
FROM
    ipl_bidding_details AS ibd
        JOIN
    ipl_team AS it ON ibd.bid_team = it.team_id
        JOIN
    ipl_bidder_points AS ibp USING (bidder_id)
GROUP BY ibd.bidder_id
ORDER BY bidder_id , bid_team;



-- 5.	Show the team id who won the match as per the win details.
SELECT 
    match_id,
    CASE
        WHEN match_winner = 1 THEN team_id1
        WHEN match_winner = 2 THEN team_id2
    END AS winning_team_id,
    win_details
FROM
    ipl_match;


-- 6.	Display total matches played, total matches won and total matches lost by team along with its team name.
SELECT 
    it.team_id AS team_id,
    it.team_name AS team_name,
    SUM(its.matches_played) AS total_matches_played,
    SUM(its.matches_won) AS total_matches_won,
    SUM(its.matches_lost) AS total_matches_lost
FROM
    ipl_team_standings AS its
        JOIN
    ipl_team AS it USING (team_id)
GROUP BY team_id , team_name
;



-- 7.	Display the bowlers for Mumbai Indians team.
SELECT 
    it.team_name AS team_name, itp.player_role AS player_role
FROM
    ipl_team AS it
        JOIN
    ipl_team_players AS itp USING (team_id)
WHERE
    team_name = 'Mumbai Indians'
        AND player_role = 'Bowler'
;



-- 8.	How many all-rounders are there in each team, Display the teams with more than 4 
--      all-rounder in descending order.
SELECT 
    team_id, team_name, COUNT(player_role) AS total_all_rounder
FROM
    ipl_team AS it
        JOIN
    ipl_team_players AS itp USING (team_id)
WHERE
    player_role = 'All-Rounder'
GROUP BY team_id , team_name
HAVING total_all_rounder > 4
ORDER BY total_all_rounder DESC
;
