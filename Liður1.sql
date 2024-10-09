WITH cte_kingdoms_houses AS (
    SELECT
        k.gid AS kingdom_id,    -- Gildar ríki úr atlas.kingdoms
        k.name AS kingdom_name, -- Nafn ríkisins úr atlas.kingdoms
        h.id AS house_id,       -- Gildar hús úr got.houses
        h.name AS house_name    -- Nafn hússins úr got.houses
    FROM
        atlas.kingdoms k
    LEFT JOIN
        got.houses h
    ON
        k.name = h.region       -- Tengjum ríkisheitið við svæðið í got.houses
)
INSERT INTO lannister.tables_mapping (kingdom_id, house_id)
SELECT
    kingdom_id,
    house_id
FROM
    cte_kingdoms_houses
WHERE NOT EXISTS (
    SELECT 1
    FROM lannister.tables_mapping tm
    WHERE tm.kingdom_id = cte_kingdoms_houses.kingdom_id
      AND tm.house_id = cte_kingdoms_houses.house_id
);