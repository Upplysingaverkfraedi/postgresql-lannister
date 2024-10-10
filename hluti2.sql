CREATE OR REPLACE VIEW lannister.v_pov_characters_human_readable AS
WITH characters AS (
    SELECT
        CONCAT(c.titles[1], ' ', c.name) AS full_name,

        CASE WHEN c.gender = 'Male' THEN 'M' WHEN c.gender = 'Female' THEN 'F' END AS gender,

        father.name AS father,
        mother.name AS mother,
        spouse.name AS spouse,

        regexp_matches(c.born, '(\d+) (AC|BC)') AS born,
        c.died,

        COALESCE(
            CAST(CASE WHEN c.died ~ '^\d+$' THEN c.died ELSE NULL END AS INTEGER), 300) -
        CASE
            WHEN (regexp_match(c.born, '(\d+) (AC|BC)'))[2] = 'AC' THEN (regexp_match(c.born, '(\d+) (AC|BC)'))[1]::int
            WHEN (regexp_match(c.born, '(\d+) (AC|BC)'))[2] = 'BC' THEN -(regexp_match(c.born, '(\d+) (AC|BC)'))[1]::int
            ELSE NULL
        END AS age,

        c.died IS NULL AS alive,

        ARRAY_AGG(b.name ORDER BY b.released) AS book_titles
    FROM
        got.characters c
    LEFT JOIN got.characters father ON father.id = c.father
    LEFT JOIN got.characters mother ON mother.id = c.mother
    LEFT JOIN got.characters spouse ON spouse.id = c.spouse
    LEFT JOIN got.character_books cb ON cb.character_id = c.id
    LEFT JOIN got.books b ON b.id = cb.book_id
    WHERE
        cb.pov = TRUE
    GROUP BY
        c.id, father.name, mother.name, spouse.name
)

SELECT
    full_name,
    gender,
    father,
    mother,
    spouse,
    (CASE
        WHEN born[2] = 'AC' THEN born[1]::int
        WHEN born[2] = 'BC' THEN -born[1]::int
        ELSE NULL
    END) AS born,
    died,
    age,
    alive,
    book_titles
FROM
    characters
ORDER BY
    alive DESC,
    age DESC;
