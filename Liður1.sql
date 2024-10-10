WITH cte_kingdoms_houses AS (
    SELECT
        k.gid AS kingdom_id,    -- Gildi ríkis úr atlas.kingdoms
        h.id AS house_id       -- Gildi hús úr got.houses
    FROM
        atlas.kingdoms k
    FULL OUTER JOIN
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
ON CONFLICT (house_id) DO UPDATE
    SET
        kingdom_id=EXCLUDED.kingdom_id
;
h.id