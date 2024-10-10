# Hluti 2 

## Möppustrúktúr: 
```bash
/data/ 
— railway@junction.proxy.rlwy.net
— hluti2.sql 
	— lannister.v_pov_characters_human_readable
— readme.md
```

## Vinnsla: 

### Tengjast gagnasafni:
Fyrst þarf að tengjast gagnasafninu Railway og hlaða því niður (sjá upplýsingar fyrir ofan)

### Búa til View:
Það þarf að búa til view, inn í Datagrip þá er grænn hnappur sem er notaður til að keyra kóðann og þar er hægt að ýta á `CREATE OR REPLACE VIEW lannister….`

### Keyra kóðann: 
Næst er hægt að keyra kóðann inn í Datagrip og þá kemur upp sýndartaflan. 

Einnig er hægt að nota eftirfarandi skipun: 
`SELECT * FROM lausn.v_pov_characters_human_readable;`