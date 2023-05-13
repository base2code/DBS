# SQL Queries

### Auswahl aller Produkte mit Bestand größer als 50
```sql
SELECT * 
FROM   mydb.produkt 
WHERE  bestand > 50; 
```

### Berechnung des durchschnittlichen Verkaufspreises aller Produkte.
```sql
SELECT Avg(vkpreis) AS Durchschnittspreis 
FROM   mydb.produkt; 
```

### Ermitteln der Mitarbeitern mit Rolle
```sql
SELECT m.idmitarbeiter AS "Mitarbeiter ID", 
       m.nachname      AS "Nachname", 
       m.vorname       AS "Vorname", 
       r.NAME          AS "Rolle" 
FROM   mydb.mitarbeiter m 
       JOIN mydb.mitarbeiter_hat_rollen mr 
         ON m.idmitarbeiter = mr.mitarbeiter_idmitarbeiter 
       JOIN mydb.rolle r 
         ON mr.rolle_idrolle = r.idrolle; 
```

### Berechnung der Gesamtzahl der Mitarbeiter in jeder Stadt.
```sql
SELECT mydb.plz.stadt, 
       Count(*) AS Anzahl_Mitarbeiter 
FROM   mydb.mitarbeiter 
       INNER JOIN mydb.adresse 
               ON mydb.mitarbeiter.adresse_idadresse = mydb.adresse.idadresse 
       INNER JOIN mydb.plz 
               ON mydb.adresse.plz_idplz = mydb.plz.idplz 
GROUP  BY mydb.plz.stadt; 
```

### Auswahl aller Lieferanten, die mehr als 10 Produkte liefern.
```sql
SELECT mydb.lieferant.idlieferant, 
       mydb.lieferant.NAME, 
       Count(mydb.produkt_hat_lieferant.produkt_produktid) AS AnzahlProdukte 
FROM   mydb.lieferant 
       INNER JOIN mydb.produkt_hat_lieferant 
               ON mydb.lieferant.idlieferant = 
                  mydb.produkt_hat_lieferant.lieferant_idlieferant 
GROUP  BY mydb.lieferant.idlieferant, 
          mydb.lieferant.NAME 
HAVING Count(mydb.produkt_hat_lieferant.produkt_produktid) > 10; 
```

### Aktualisierung des Bestands eines bestimmten Produkts (Auslösung des Triggers zur Bestellung).
```sql
UPDATE mydb.produkt 
SET    bestand = 4
WHERE  idprodukt = 1; 
```
```sql
SELECT * 
FROM   mydb.bestellungen; 
```

### Auswahl aller Produkte, die nicht im Bestand sind
```sql
SELECT * 
FROM   mydb.produkt 
WHERE  bestand = 0; 
```

### Ermittlung der Anzahl der Verkäufe pro Produkt.
```sql
SELECT produkt_produktid, 
       Count(*) AS Anzahl_Verkaeufe 
FROM   mydb.produktverkauf 
GROUP  BY produkt_produktid; 
```

### Rekursive Anfrage zur Ermittlung aller Vertretungen für eine gegebene Vertretung (idVertretung = 1).
```sql
WITH recursive vertretungskette AS 
( 
       SELECT v.idvertretung, 
              v.vertretung_idvertretung, 
              v.vertretungsgrund, 
              m.vorname, 
              m.nachname 
       FROM   mydb.vertretung v 
       JOIN   mydb.mitarbeiter m 
       ON     v.vertretenermitarbeiter_id = m.idmitarbeiter 
       WHERE  v.idvertretung = 1 
       UNION ALL 
       SELECT v.idvertretung, 
              v.vertretung_idvertretung, 
              v.vertretungsgrund, 
              m.vorname, 
              m.nachname 
       FROM   mydb.vertretung v 
       JOIN   vertretungskette 
       ON     v.vertretung_idvertretung = vertretungskette.idvertretung 
       JOIN   mydb.mitarbeiter m 
       ON     v.vertretenermitarbeiter_id = m.idmitarbeiter ) 
SELECT * 
FROM   vertretungskette;
```

### Alle Produkte, welchen einen geringen Bestand haben und noch nicht bestellt sind.
```sql
SELECT * 
FROM   mydb.produkt AS p 
WHERE  bestand <= 5 
       AND NOT EXISTS (SELECT 1 
                       FROM   mydb.bestellung_haben_produkte AS bhp 
                              JOIN mydb.bestellungen AS b 
                                ON b.idbestellungen = 
                                   bhp.bestellungen_idbestellungen 
                       WHERE  bhp.produkt_idprodukt = p.idprodukt 
                              AND b.bestellstatus = 'Bestellt'); 
```

### Alle Kategorien auflisten, welche mehr als 5 Produkte haben und sortiere diese absteigend.
```sql
SELECT Count(idprodukt) AS Menge, 
       kategorie 
FROM   mydb.produkt 
GROUP  BY kategorie 
HAVING Count(idprodukt) >= 5 
ORDER  BY kategorie DESC; 
```

### Sind alle Produkte im Bestand (Allquantor)
```sql
ELECT CASE 
         WHEN NOT EXISTS (SELECT * 
                          FROM   mydb.produkt 
                          WHERE  bestand <= 0) THEN 
         'Ja, alle Produkte sind im Bestand.' 
         ELSE 'Nein, nicht alle Produkte sind im Bestand.' 
       END AS AllquantorErgebnis; 
```
