WITH north_houses AS (
    -- Finna öll hús í Norðri og telja fjölda hliðhollra meðlima með CARDINALITY
    SELECT
        h.id AS house_id,
        h.name AS house_name,
        CARDINALITY(h.sworn_members) AS sworn_members_count  -- Notum CARDINALITY til að telja meðlimi í fylkinu
    FROM
        got.houses h
    WHERE
        h.region = 'The North'  -- Einbeitum að norðurhúsum
)
-- Skilyrði til að fá ættir með fleiri en 5 hliðholla meðlimi
SELECT
    house_name,
    sworn_members_count
FROM
    north_houses
WHERE
    sworn_members_count > 5
ORDER BY
    sworn_members_count DESC,  -- Raða eftir fjölda meðlima, stærstu fyrst
    house_name ASC;            -- Ef fjöldi er sá sami, raða í stafrófsröð
