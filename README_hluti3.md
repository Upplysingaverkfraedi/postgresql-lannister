# Hluti 3: PostGIS og föll í PostgreSQL

## Verkefnalýsing
Í þessum hluta átti að nota PostGIS sem er viðbót fyrir PostgreSQL sem bætir við geospatial gagnagrunnsföllum og aðgerðum. PostgreSQL með PostGIS gerir okkur leyft að geym það sérhæfðar gagnagrunnstöflur og föll til að vinna með geospatial gögn. Annars vegar átti að finna flatarmál konungsríkja og hins vegar finna sjaldgæfustu staðsetningartegund utan The Seven Kingdoms og heiti þeirra staða sem tilheyrðu þeirri tegund. 

## Möppustrúktur 

```
.
├── hluti3.sql
├── README_hluti3.md
└── utskyring_hluti3.md
```


## Hvernig á að keyra lausnina
Það er mjög einfalt að keyra lausnir fyrir þetta verkefni. Eina sem þarf að gera er að keyra eftirfarandi SQL skipanir.


### Flatarmáls konungsríkja
**Búa til fall sem reiknar út flatarmál konungsríkis út frá landfræðilegum gögnum. Gefið niðurstöðu í ferkílómetrum (þ.e. km²) með engum aukastöfum.**


```
CREATE OR REPLACE FUNCTION lannister.get_kingdom_size(kingdom_id integer)
RETURNS integer AS $$
DECLARE
    area_km2 integer;

    --Kastar villu ef það er ólöglegt gildi
BEGIN
    IF NOT EXISTS (SELECT 1 FROM atlas.kingdoms k WHERE k.gid = kingdom_id) THEN
        RAISE EXCEPTION 'Kingdom with id % not found', kingdom_id;
    END IF;

    SELECT ST_Area(geog)/1e6 INTO area_km2
    FROM atlas.kingdoms
    WHERE gid = kingdom_id;

    RETURN area_km2;
END;
$$ LANGUAGE plpgsql;
```

**Úttakið ætti að vera:**
 ```
2621185
684321
567428
122121
749168
901071
1208509
558293
28180
241016
```

**Skrifaðu eina SQL fyrirspurn sem notar fallið til að finna heildar flatarmál þriðja stærsta konungsríkisins.**

```
SELECT * FROM pg_tables WHERE schemaname IN ('atlas', 'got')
ORDER BY schemaname, tablename;

select name from atlas.kingdoms order by lannister.get_kingdom_size(gid) desc
OFFSET 2
LIMIT 1;

CREATE OR REPLACE FUNCTION lannister.get_kingdom_size(kingdom_id integer)
RETURNS integer AS $$
DECLARE
    area_km2 integer;
BEGIN
    SELECT ST_Area(geog)/1e6
    INTO area_km2
    FROM atlas.kingdoms
    WHERE gid = kingdom_id;

    RETURN area_km2;
END;
$$ LANGUAGE plpgsql;
```


**Úttakið ætti að vera:**

```
Dorne
```

### Fjöldi staðsetninga og staðsetningar af ákveðnum tegundum

**Skrifaðu eina SQL fyrirspurn sem finnur sjaldgæfustu staðsetningategund (location_type) utan The Seven Kingdoms (hér ættu einnig að koma staðir eins og í Essos, þ.e.a.s. utan Westeros), og hvaða heita staðirnir sem tilheyra þeirri tegund?**

```
SELECT
    l.name,
    l.type
FROM atlas.locations l
WHERE l.type = (
    SELECT
        l.type
    FROM atlas.locations l
    LEFT JOIN atlas.kingdoms k on ST_DWithin(k.geog, l.geog, 0)
    WHERE k.name IS NULL OR k.name NOT IN ('Kingdom of the North', 'The Vale', 'The Riverlands', 'Iron Islands', 'The Westerlands', 'The Stormlands', 'The Reach', 'Dorne')
    GROUP BY l.type
    ORDER BY COUNT(*) ASC
    LIMIT 1
);

```
**Úttakið ætti að vera:**

```
Stone Mill,Landmark
Pendric Hills,Landmark
Nagga's Bones,Landmark
Fist of the First Men,Landmark
Hollow Hill,Landmark
Old Stone Bridge Inn,Landmark
Water Gardens,Landmark
Nunn's Deep,Landmark
Tumblers Falls,Landmark
Rushing Falls,Landmark
Mummer's Ford,Landmark
Inn of the Kneeling Man,Landmark
Dagger Lake,Landmark
God's Eye,Landmark
Long Lake,Landmark
Crossroads Inn,Landmark

```
