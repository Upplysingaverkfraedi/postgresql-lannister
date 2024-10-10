-- Skref 1: Innsetning í töflu lannister.tables_mapping
WITH cte_location_house_mapping AS (
    SELECT
        l.gid AS location_id,
        l.name AS location_name,
        h.id AS house_id,
        h.name AS house_name
    FROM
        atlas.locations l
    JOIN
        got.houses h ON l.name = ANY(h.seats)
    WHERE
        h.region = 'The North'
)
INSERT INTO lannister.tables_mapping (house_id, location_id)
SELECT
    house_id,
    location_id
FROM
    cte_location_house_mapping
WHERE NOT EXISTS (
    SELECT 1
    FROM lannister.tables_mapping tm
    WHERE tm.house_id = cte_location_house_mapping.house_id
      OR tm.location_id = cte_location_house_mapping.location_id
);

-- Skref 2: Birta niðurstöður fyrir Norðrið
WITH cte_location_house_mapping AS (
    SELECT
        l.gid AS location_id,
        l.name AS location_name,
        h.id AS house_id,
        h.name AS house_name
    FROM
        atlas.locations l
    JOIN
        got.houses h ON l.name = ANY(h.seats)
    WHERE
        h.region = 'The North'
)
SELECT *
FROM cte_location_house_mapping;
