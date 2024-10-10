## Inngangur
Þetta verkefni felur í sér að vinna með PostgreSQL gagnagrunn til að útfæra SQL fyrirspurnir tengdar "Game of Thrones" heiminum. Verkefnið er skipt í þrjá liði þar sem við framkvæmum ýmsar fyrirspurnir og setjum gögn í töflur.

## Möppustrúktúr
Verkefnið fylgir eftirfarandi möppustrúktúr:

├── sql/ # Mappa með SQL skráum verkefnisins 
│ ├── Liður1.sql # Fyrirspurn fyrir Lið 1 
│ ├── Liður2.sql # Fyrirspurn fyrir Lið 2 
│ └── Liður3.sql # Fyrirspurn fyrir Lið 3 
├── README.md # Leiðbeiningar um hvernig á að keyra verkefnið 
└── gagnagrunnur/ # Gögnin sem þarf að hlaða inn fyrir verkefnið 
├── houses_data.sql # Gögn fyrir got.houses töflu
├── kingdoms_data.sql # Gögn fyrir atlas.kingdoms töflu 
└── locations_data.sql # Gögn fyrir atlas.locations töflu


### Möppulýsing:
- **sql/**: Inniheldur allar SQL fyrirspurnirnar fyrir verkefnið.
- **gagnagrunnur/**: Inniheldur SQL skrár fyrir gögnin sem þarf að hlaða inn í töflurnar fyrir verkefnið.

## PostgreSQL tenging
Gagnagrunnurinn er hýstur á **Railway** og er aðgengilegur með eftirfarandi tengingarupplýsingum:

- **Host**: `junction.proxy.rlwy.net`
- **Port**: `55303`
- **Database**: `railway`
- **Username**: Teymisnafn (úthlutað á Canvas)
- **Password**: Uppgefið í Canvas

Teymi fá upplýsingar um notendanafn og lykilorð til að tengjast gagnagrunnum á Canvas.

### Tengjast með IDE
Notið IDE til að tengjast PostgreSQL gagnagrunninum með þessum tengingarupplýsingum. Þið getið notað **VSCode** með PostgreSQL viðbótinni. Betra er að nota IDE sem sérhæfir sig fyrir SQL, eins og **DataGrip** (með frítt stúdentaleyfi), en **DBeaver** er líka góður kostur og er frjáls og opinn hugbúnaður.

Til að sjá hvaða töflur standa ykkur til boða getið þið keyrt eftirfarandi SQL fyrirspurn:

   ```sql
   SELECT *
   FROM pg_tables
   WHERE schemaname IN ('atlas', 'got')
   ORDER BY schemaname, tablename;
   ```

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

### Skref 2: Hvernig á að keyra liði verkefnisins

#### Liður 1: Tengja ríki og hús
Liður 1 felur í sér að tengja ríki við hús þeirra, jafnvel þó þau séu ekki með hús. Til að keyra þetta:
1. Tengstu við gagnagrunninn **railway** með DataGrip.
2. Opnaðu skjalið `Liður1.sql`, afritaðu kóðann úr skjalinu, og límdu hann inn í SQL Editor í DataGrip.
3. Keyrðu fyrirspurnina til að bæta tengingum á milli ríkja og húsa inn í töfluna `lannister.tables_mapping`.

#### Liður 2: Tengja staði í Norðrinu við hús
Liður 2 tengir staði í Norðrinu við hús. Þetta skref setur einnig gögn inn í `lannister.tables_mapping` og birtir tengingarnar.

1. Tengstu við gagnagrunninn **railway**.
2. Opnaðu skjalið `Liður2.sql`, afritaðu kóðann, og límdu hann inn í SQL Editor í DataGrip.
3. Keyrðu fyrirspurnina til að tengja staði í Norðrinu við hús og setja gögn inn í `lannister.tables_mapping` og birta niðurstöðurnar.

#### Liður 3: Finna hús með fleiri en 5 hliðholla meðlimi
Liður 3 finnur hús í Norðrinu sem hafa fleiri en 5 hliðholla meðlimi. Til að keyra þetta:
1. Tengstu við gagnagrunninn **railway**.
2. Opnaðu skjalið `Liður3.sql`, afritaðu kóðann, og límdu hann inn í SQL Editor í DataGrip.
3. Keyrðu fyrirspurnina til að fá lista yfir hús í Norðrinu með fleiri en 5 hliðholla meðlimi.

### Skref 3: Villuleit og öryggismál

- **Ef þú lendir í vandræðum með tengingar**, vertu viss um að rétt gagnagrunnsheiti, notendanafn og lykilorð séu rétt stillt í tengingarupplýsingum. Athugaðu einnig að rétt netfang og port séu notuð í tengingu við Railway.
  
- **Ef SQL fyrirspurnir keyra ekki**, athugaðu hvort gögnin í töflunum séu rétt hlaðin inn. Þú getur keyrt eftirfarandi fyrirspurn til að sjá hvaða töflur og gögn eru til staðar í gagnagrunninum:

   ```sql
   SELECT *
   FROM pg_tables
   WHERE schemaname IN ('atlas', 'got')
   ORDER BY schemaname, tablename;
