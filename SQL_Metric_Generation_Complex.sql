SELECT contentid1,
       MAX(Content_Type) AS Content_Type,
       MAX(Title),
       COUNT(DISTINCT contentid1) AS UniqueContentIds,
       COUNT(DISTINCT device_id) AS UniqueDevices,
       COUNT(contentid1) AS Clicks,
       AVG(ActBucket)*25 AS Engage,
       SUM(MinutesWatched) AS MinutesWatched,
       (AVG(ActBucket)*25 *COUNT(DISTINCT device_id)) AS MY_OWN_Engagement_Index
FROM (SELECT contentid1,
             event_time,
             DATE (event_time),
             device_id,
             ActBucket,
             MinutesWatched,
             DATE_PART(dow,event_time) AS Day_Of_Week,
             b.*
      FROM (SELECT e_content_id,
                   device_id,
                   event_time,
                   CONVERT(DECIMAL(10,2),e_play_bucket) AS ActBucket,
                   (e_play_duration / 60) AS MinutesWatched
            FROM app140681.video_play
            WHERE event_time > '2016-09-01'
            AND   event_time <= '2016-09-30'
            AND   country = 'India') AS a (contentid1,device_id,event_time,ActBucket,MinutesWatched)
        INNER JOIN (SELECT e_content_id,
                           Title,
                           Duration,
                           Bucket,
                           FinalDuration,
                           CASE
                             WHEN finalduration > 5 THEN 'L'
                             ELSE 'S'
                           END AS Content_Type
                    FROM (SELECT e_content_id,
                                 MAX(e_content_title) AS Title,
                                 (MAX(e_play_duration) / 60) AS Duration,
                                 MAX(CONVERT(DECIMAL(10,2),e_play_bucket)) AS Bucket,
                                 (((4 -MAX(e_play_bucket)) / 4)*(MAX(e_play_duration) / 60) +(MAX(e_play_duration) / 60)) AS FinalDuration
                          FROM app140681.video_play
                          WHERE event_time > '2016-01-01'
                          AND   event_time <= '2016-09-30'
                          AND   country = 'India'
                          AND   e_content_id = 953882638
                          GROUP BY e_content_id
                          ORDER BY duration DESC)) AS b (contentid2,Title,Duration,Bucket,FinalDuration,content_type) ON a.contentid1 = b.contentid2)
GROUP BY contentid1
ORDER BY contentid1;

