-- Skref 1: Tengja staði í Norðrinu við hús
WITH cte_location_house_mapping AS (
    SELECT
        l.gid AS location_id,   -- Nota l.gid sem location_id úr atlas.locations
        l.name AS location_name, -- Nafn staðar úr atlas.locations (t.d. Winterfell)
        h.id AS house_id,       -- Húsa id úr got.houses
        h.name AS house_name    -- Nafn húss úr got.houses
    FROM
        atlas.locations l
    JOIN
        got.houses h ON l.name = ANY(h.seats)   -- Tengjum saman stað við sæti hússins (seats)
    WHERE
        h.region = 'The North'  -- Hús sem tilheyra Norðrinu
)
-- Skref 2: Upserta gögnin í töflu <teymi>.tables_mapping
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

-- Skref 3: Birta niðurstöður fyrir Norðrið (Kingdom of the North)
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
        h.region = 'The North'  -- Sækja gögn fyrir Norðrið
)
SELECT *
FROM cte_location_house_mapping;
