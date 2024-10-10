### Útskýring á SQL kóðanum og niðurstöðum töflunnar

#### Kóðinn:
1. **WITH cte_kingdoms_houses AS ...**:
   - Fyrirspurnin byrjar að skilgreina **CTE (Common Table Expression)** sem sameinar gögn úr tveimur töflum: 
     - **atlas.kingdoms** (sem inniheldur upplýsingar um ríki).
     - **got.houses** (sem inniheldur upplýsingar um ættir og hús).
   - Með **LEFT JOIN** eru öll ríki í **atlas.kingdoms** tekin með, jafnvel þótt þau hafi ekki tengt hús (house) í **got.houses**.
   - Tengingin er gerð þar sem nafn ríkis í **atlas.kingdoms** samsvarar svæði í **got.houses**.

2. **INSERT INTO lannister.tables_mapping (kingdom_id, house_id)**:
   - Hér er gögnunum úr **CTE** bætt inn í töfluna **lannister.tables_mapping**. Fyrirspurnin setur inn bæði **kingdom_id** (auðkenni ríkis) og **house_id** (auðkenni ættar/húss).
   - **WHERE NOT EXISTS** tryggir að engin afrit séu sett inn; ef sambandið milli **kingdom_id** og **house_id** er nú þegar til í töflunni, þá er það ekki sett inn aftur.

#### Taflan (lannister.tables_mapping):
Taflan **lannister.tables_mapping** tengir ríki við hús/ættir. Hún hefur eftirfarandi dálka:

1. **house_id**: Þessi dálkur inniheldur auðkenni fyrir hús/ættir úr **got.houses**. Dæmi um hús eru Stark, Lannister o.fl.
2. **kingdom_id**: Þessi dálkur inniheldur auðkenni fyrir ríki úr **atlas.kingdoms**. Það tengir hús við ríki, svo sem The North eða The Reach.
3. **location_id**: Þessi dálkur er notaður til að tengja staðsetningar við húsin, en í þessum hluta töflunnar er hann tómur (`<null>`)

#### Niðurstaða:
- Fyrirspurnin tengir hús/ættir við ríki og setur gögnin inn í **lannister.tables_mapping** töfluna. Taflan inniheldur upplýsingar um hvaða hús tilheyra hvaða ríki, jafnvel þó engin staðsetning sé tengd við húsið.
- Dæmi úr töflunni sýna t.d. að húsið með **house_id** `403` tilheyrir ríkinu með **kingdom_id** `6`, og húsið með **house_id** `430` tilheyrir ríkinu með **kingdom_id** `1`.



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

