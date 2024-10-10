### Útskýring á SQL kóðanum og niðurstöðum töflunnar fyrir Lið 1

#### Kóðinn:
1. **WITH cte_kingdoms_houses AS ...**:
   - Fyrirspurnin byrjar með **CTE** sem sameinar gögn úr tveimur töflum: 
     - **atlas.kingdoms** (ríkisupplýsingar)
     - **got.houses** (upplýsingar um hús/ættir).
   - Hér er notað **FULL OUTER JOIN** til að tryggja að bæði ríkisupplýsingar og hús sem eiga sér ekki samsvörun séu með í niðurstöðunum.
   - Tengingin er gerð með því að passa saman heiti ríkja í **atlas.kingdoms** við svæði í **got.houses**.

2. **INSERT INTO lannister.tables_mapping ... ON CONFLICT**:
   - Gögnunum er bætt inn í töfluna **lannister.tables_mapping** þar sem bæði **kingdom_id** (auðkenni ríkis) og **house_id** (auðkenni húss) eru skráð.
   - **ON CONFLICT** tryggir að ef **house_id** er til staðar fyrir sama hús, þá er **kingdom_id** uppfært í stað þess að búa til nýja línu.
   - **EXCLUDED.kingdom_id** er nýja gildið sem kemur í staðinn ef það er árekstur.

#### Taflan (lannister.tables_mapping):
Taflan **lannister.tables_mapping** inniheldur sambönd á milli húsa og ríkja. Hér eru dæmi úr niðurstöðutöflunni:

1. **house_id**: Þessi dálkur inniheldur auðkenni fyrir hús eða ættir úr **got.houses**. Í þessum hluta töflunnar eru nokkrar línur þar sem **house_id** er `null`, sem þýðir að engin samsvarandi hús eru tengd þessum ríkjum.
2. **kingdom_id**: Dálkurinn fyrir auðkenni ríkis úr **atlas.kingdoms**. Dæmi úr töflunni sýna ríki eins og **kingdom_id** `10`, `3`, og `7`, sem eru tengd húsum eða eru án tengds húss.
3. **location_id**: Þessi dálkur er tómur (`null`) í þessum hluta töflunnar.

#### Niðurstaða:
- Fyrirspurnin sameinar upplýsingar um öll hús og ríki, jafnvel þau sem eiga sér ekki tengingu við hvert annað. Það tryggir að engin gögn séu skilin út undan.
- **ON CONFLICT** setningin tryggir að gögn verði uppfærð í stað þess að búa til afrit þegar **house_id** er nú þegar til í töflunni.

Dæmi úr töflunni sýnir t.d. að **kingdom_id** `10` er ekki tengt við neitt hús, og að **house_id** `17` er tengt við ríki með **kingdom_id** `7`.

### Útskýring á SQL kóðanum og niðurstöðum töflunnar fyrir Lið 2

#### Kóðinn:
1. **WITH cte_location_house_mapping AS ...**:
   - Fyrirspurnin byrjar með **CTE** sem sameinar gögn úr tveimur töflum:
     - **atlas.locations** (upplýsingar um staði).
     - **got.houses** (upplýsingar um hús/ættir).
   - Tengingin er gerð þar sem staðir í **atlas.locations** samsvara sæti húsa í **got.houses** með því að nota **ANY(h.seats)**. Þetta þýðir að ef staðsetning er eitt af sætum hússins, þá tengist það því húsi.
   - Við erum að skoða eingöngu hús sem tilheyra Norðrinu með skilyrðinu **h.region = 'The North'**.

2. **INSERT INTO lannister.tables_mapping ...**:
   - Gögnunum sem eru sótt í **CTE** er bætt inn í **lannister.tables_mapping** töfluna, þar sem **house_id** og **location_id** eru skráð saman.
   - **WHERE NOT EXISTS** tryggir að gögnin séu ekki sett inn ef þau eru nú þegar til (til að koma í veg fyrir afrit).

3. **Birta niðurstöður**:
   - Seinni hluti fyrirspurnarinnar birtir niðurstöðurnar með því að endurnýta **CTE** til að fá staði og hús í Norðrinu sem eru tengd með sætum.

#### Taflan (Niðurstöður fyrir norðurhúsin og staðsetningar þeirra):
Taflan sýnir tengsl milli húsa í Norðrinu og staðsetninga þeirra:

1. **location_id**: Auðkenni staðsetningar úr **atlas.locations**. Dæmi úr töflunni sýna staði eins og `135` (Karhold) og `186` (Torrhen's Square).
2. **location_name**: Nafn staðsetningarinnar (t.d. **Karhold**, **Torrhen's Square**).
3. **house_id**: Auðkenni húss úr **got.houses**. Þetta tengir ættir við staðsetningar. Dæmi úr töflunni eru **house_id** `215` fyrir **House Karstark of Karhold**.
4. **house_name**: Nafn ættarinnar eða hússins. Dæmi úr töflunni sýna **House Karstark of Karhold** og **House Tallhart of Torrhen's Square**.

#### Niðurstaða:
- Taflan sýnir hús í Norðrinu og staðsetningar þeirra, eins og **House Karstark of Karhold** tengt staðnum **Karhold**.
- Fyrirspurnin bætir gögnunum inn í **lannister.tables_mapping** töfluna ef þau eru ekki þegar til staðar, og birtir svo niðurstöðurnar með öllum tengingum milli húsa og staða.



### Útskýring á SQL kóðanum og niðurstöðum töflunnar fyrir Lið 3

#### Kóðinn:
1. **WITH north_houses AS ...**:
   - Fyrirspurnin byrjar með **CTE** sem safnar öllum húsum úr **got.houses** sem tilheyra svæðinu **The North**.
   - Í fyrirspurninni er notað **CARDINALITY()** til að telja fjölda hliðhollra meðlima (sworn_members) fyrir hvert hús. Þetta fylki inniheldur þá sem eru hliðhollir hverri ætt eða húsi.

2. **SELECT ... WHERE sworn_members_count > 5**:
   - Fyrirspurnin velur hús í Norðrinu sem hafa fleiri en 5 hliðholla meðlimi.
   - **ORDER BY** skilyrðið tryggir að niðurstöðurnar séu raðaðar eftir fjölda meðlima í lækkandi röð (frá stærstu ættunum) og eftir **house_name** í stafrófsröð ef fjöldi meðlima er sá sami.

#### Taflan (Niðurstöður fyrir norðurhúsin með fleiri en 5 meðlimi):
Taflan sýnir þau hús í Norðrinu sem hafa fleiri en 5 hliðholla meðlimi, raðað eftir fjölda meðlima:

1. **house_name**: Nafn ættarinnar eða hússins í Norðrinu.
2. **sworn_members_count**: Fjöldi hliðhollra meðlima fyrir hvert hús.

Dæmi úr töflunni:
- **House Stark of Winterfell** er með 88 hliðholla meðlimi, sem gerir það að stærsta húsinu.
- **House Bolton of the Dreadfort** er með 15 hliðholla.
- **House Karstark of Karhold** er með 11 hliðholla.

