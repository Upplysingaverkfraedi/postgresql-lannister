### Skref 1: Setja upp PostgreSQL tengingu í DataGrip
1. Opnaðu **DataGrip**.
2. Veldu **Add Data Source** í efra vinstra horni og veldu **PostgreSQL**.
3. Sláðu inn eftirfarandi tengingarupplýsingar:
   - **Host**: `junction.proxy.rlwy.net`
   - **Port**: `55303`
   - **Database**: `railway`
   - **User**: Notendanafn (úthlutað á Canvas)
   - **Password**: Uppgefið á Canvas
4. Smelltu á **Test Connection** til að tryggja að tengingin sé í lagi.
5. Þegar tengingin er komin, getur þú keyrt SQL fyrirspurnir í **DataGrip**.

## Möppustrúktúr

### Hluti 1

```
├── sql/ # Mappa með SQL skráum verkefnisins 
│ ├── Liður1.sql # Fyrirspurn fyrir Lið 1 
│ ├── Liður2.sql # Fyrirspurn fyrir Lið 2 
│ └── Liður3.sql # Fyrirspurn fyrir Lið 3 
├── README.md # Leiðbeiningar um hvernig á að keyra verkefnið
```

### Hluti 2

```
/data/ 
├── railway@junction.proxy.rlwy.net 
├── hluti2.sql 
└── readme.md
```

### Hluti 3

```
├── hluti3.sql 
├── README_hluti3.md 
└── utskyring_hluti3.md
```
## Hvernig á að keyra hluta 1

### Liður 1: Tengja ríki og hús
Liður 1 felur í sér að tengja ríki við hús þeirra, jafnvel þó þau séu ekki með hús. Til að keyra þetta:
1. Tengstu við gagnagrunninn **railway** með DataGrip.
2. Opnaðu skjalið `Liður1.sql`, afritaðu kóðann úr skjalinu, og límdu hann inn í SQL Editor í DataGrip.
3. Keyrðu fyrirspurnina til að bæta tengingum á milli ríkja og húsa inn í töfluna `lannister.tables_mapping`.

### Liður 2: Tengja staði í Norðrinu við hús
Liður 2 tengir staði í Norðrinu við hús. Þetta skref setur einnig gögn inn í `lannister.tables_mapping` og birtir tengingarnar.
1. Tengstu við gagnagrunninn **railway**.
2. Opnaðu skjalið `Liður2.sql`, afritaðu kóðann, og límdu hann inn í SQL Editor í DataGrip.
3. Keyrðu fyrirspurnina til að tengja staði í Norðrinu við hús og setja gögn inn í `lannister.tables_mapping` og birta niðurstöðurnar.

### Liður 3: Finna hús með fleiri en 5 hliðholla meðlimi
Liður 3 finnur hús í Norðrinu sem hafa fleiri en 5 hliðholla meðlimi. Til að keyra þetta:
1. Tengstu við gagnagrunninn **railway**.
2. Opnaðu skjalið `Liður3.sql`, afritaðu kóðann, og límdu hann inn í SQL Editor í DataGrip.
3. Keyrðu fyrirspurnina til að fá lista yfir hús í Norðrinu með fleiri en 5 hliðholla meðlimi.


## Hvernig á að keyra hluta 2

### Tengjast gagnasafni
Fyrst þarf að tengjast gagnasafninu Railway með því að fylgja leiðbeiningum úr uppsetningarhlutanum. Þegar þú ert tengdur, geturðu keyrt verkefnið í DataGrip.

### Búa til View
1. Opnaðu **DataGrip** og tengdu þig við gagnagrunninn **railway**.
2. Opnaðu skjalið `hluti2.sql` og límdu kóðann inn í SQL Editor.
3. Keyrðu `CREATE OR REPLACE VIEW lannister.v_pov_characters_human_readable` til að búa til eða endurskapa sýndartöfluna.

### Skoða gögnin
Til að skoða gögnin í sýndartöflunni, keyrðu eftirfarandi fyrirspurn:

```
sql
SELECT * FROM lannister.v_pov_characters_human_readable;
```

## Hvernig á að keyra hluta 3

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