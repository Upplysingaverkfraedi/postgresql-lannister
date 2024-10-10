# Hluti 3

Í þessari skrá er nánari útskýring á dæmum fyrir hluta 3 sem finna má á branchinu *Hluti 3* inná Github.

### 1. Flatarmáls konungsríkja

**Búið til PostgreSQL function <teymi>.`get_kingdom_size(int kingdom_id)` sem reiknar út flatarmál konungsríkis út frá landfræðilegum gögnum. Gefið niðurstöðu í ferkílómetrum (þ.e. km²) með engum aukastöfum.**

Fallið lannister `.get_kingdom_size` í PostgreSQL reiknar flatarmál konungsríkis í ferkílómetrum með því að nota landfræðileg gögn. Þegar notandi kallar á fallið með auðkenni konungsríkis (kingdom_id), athugar það fyrst hvort konungsríkið sé til í gagnagrunninum. Ef ekki, þá birtir það villu sem segir að ekki hafi fundist konungsríki með því tiltekna auðkenni.

Ef konungsríkið er til, reiknar fallið flatarmálið út frá landfræðilegum gögnum sem eru geymd í dálknum *geog* í töflunni *atlas.kingdoms*. PostgreSQL fallið ST_Area er notað til að finna flatarmál svæðisins í fermetrum. Til að umbreyta því í ferkílómetra er niðurstöðunni deilt með einni milljón (1.000.000). Að lokum skilar fallið flatarmálinu sem heiltölu.

Þá skilaði úttakið tíu mismunandi flatarmálum konungsríkja í ferkílómetrum í heiltölum (integer).  


**Hvað gerist ef þú setur inn ólöglegt gildi fyrir kingdom_id? Er hægt að koma í veg fyrir það (þ.e.a.s. kasta villu)?**

Ef sett er inn ólöglegt gildi fyrir kingdom_id, til dæmis -1, þá mun fallið leita að konungsríki með kingdom_id = -1 í töflunni *atlas.kingdoms*.
Þar sem slíkt kingdom_id er ekki til, er eftirfarandi skilyrði satt:
*IF NOT EXISTS (SELECT 1 FROM atlas.kingdoms k WHERE k.gid = kingdom_id) THEN*

Þetta leiðir til þess að villan RAISE EXCEPTION 'Kingdom with id % not found', kingdom_id; verður kölluð og fallið kastar villu með skilaboðunum *"Kingdom with id -1 not found"*. Þannig verður úttakið villa, og engin úrvinnsla mun eiga sér stað eftir það.


**Skrifaðu eina SQL fyrirspurn sem notar fallið til að finna heildar flatarmál þriðja stærsta konungsríkisins.**

Eins og sjá má í sjálfri forrituninni inná Github, er konungsríkjunum raðað í röð eftir stærð, frá stærsta til minnsta. Hér er notað fallið lannister`.get_kingdom_size(gid)` til að reikna flatarmál hvers konungsríkis út frá landfræðilegum gögnum.

Þar sem beðið er um aðeins þriðja stærsta konungsríkið, var notað OFFSET 2, sem tók fyrstu tvær línurnar út og þá var þriðja línan sú fyrsta í töflunni. LIMIT 1 tók síðan allar línur út fyrir utan þessa fyrstu og þá var þriðja stærsta konungsríkið aðeins eftir.

Úttakið er Dorne úr töflunni railway.atlas.kingdoms


### 2. Fjöldi staðsetninga og staðsetningar af ákveðnum tegundum
**Skrifaðu eina SQL fyrirspurn sem finnur sjaldgæfustu staðsetningategund (location_type) utan The Seven Kingdoms (hér ættu einnig að koma staðir eins og í Essos, þ.e.a.s. utan Westeros), og hvaða heita staðirnir sem tilheyra þeirri tegund?**

Fyrst finnur SQL fyrirspurnin sjaldgæfustu staðsetningategundina með því að skoða staði sem eru ekki innan landfræðilegs svæðis "The Seven Kingdoms".
Hún flokkar staðsetningarnar eftir tegund *(l.type)*, telur hversu margar tilheyra hverri tegund, og finnur þá tegund sem kemur sjaldnast fyrir.
Að lokum birtir hún nöfnin á þeim stöðum sem tilheyra þessari tegund.

Úttakið er Landmark þar sem það var sjaldgæfasta staðsetningartegundin (type). Landmark kom 16 sinnum fram í töflunni *railway.atlas.locations 2* og hér að neðan eru staðirnir sem tilheyra þeirri tegund í töflunni: 

*Stone Mill, Pendric Hills, Nagga-s Bones, Fist of the First Men, Hollow Hill, Old Stone Bridge Inn, Water Gardens, Nunn's Deep, Tumblers Falls, Rushing Falls, Mummer's Ford, Inn og the Kneeling Man, Dagger Lake, God's Eye Long Lake, Crossroads Inn*. 
