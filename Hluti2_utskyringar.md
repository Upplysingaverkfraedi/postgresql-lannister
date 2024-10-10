# Hluti 2 

## Verkefnið:
Verkefnið felst í því að búa til sýndartöflu sem byggist á POV persónum úr bókunum A Song of Ice and Fire. Upplýsingarnar í töflunni eru nafn, kyn, foreldrar, makar, fæðingarár, dánarár (ef á við), aldur, hvort persónan sé á lífi eða látin og öll bókaheitin sem hún kemur fyrir. 

## Sýndartaflan: 
`CREATE OR REPLACE VIEW lannister.v_pov_characters_human_readable AS`
Hér er fyrrnefnda sýndartafla búin til og ef hún var nú þegar til þá er hún uppfærð með `replace view`.

## Útfærsla á kóða: 
- Fyrst er notuð `CONCAT(c.titles[1], ' ', c.name) AS full_name` til að skilgreina nafn persónunnar. 

- Síðan er skilgreint kyn og er því breytt í 'M' eða 'F' eftir því sem á við. 

- Næst eru bæði heiti maka og foreldra sótt og passað er að útiloka ekki makalausar og/eða foreldralausar persónur. 

- Svo er notuð reglulega segðin `regexp_matches(c.born, '(\d+) (AC|BC)') AS born` til að finna fæðingarár úr `born` dálknum. Reglulega segðin finnur því tölustafinn og AC eða BC, en útilokar annan texta eins og í 'Between 230 AC and 260 AC'. 

- Síðan er reiknaður aldur persónunnar með því að annaðhvort reikna dánarár-fæðingarár eða -300 ef persónan er á lífi. Einnig er fæðingarárum sem enda á BC breytt í neikvæðatölu. 
Notuð er regluleg segð fyrir `c.died ~ '^\d+$'`. Ef að það eru bara tölustafir og löglegt ár þá skilar segðin gildi c.died, ef svarið er NULL eða einungis texti þá skilar segðin NULL, þ.e.a.s þá er ekkert dánarár. 

- Næst er athugað hvort persónan sé á lífi með `c.died IS NULL AS alive` og er útkoman annaðhvort `TRUE` eða `FALSE`. 

- Svo eru bókunum komið fyrir í lista og raðað eftir útgáfuári með eftirfarandi skipun `ARRAY_AGG(b.name ORDER BY b.released) AS book_titles`.

- Að lokum er Select nitað til að velja gögn úr CTE og er niðurstöðunum raðað svo að lifandi persónur koma fyrst og þeim er raðað í lækkandi röð eftir aldri, svo koma látnu persónurnar einnig raðaðar í lækkandi röð eftir aldri. 
