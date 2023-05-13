# SQL Queries

### Auswahl aller Produkte mit Bestand größer als 50
```sql
SELECT * FROM mydb.Produkt WHERE Bestand > 50;
```

### Berechnung des durchschnittlichen Verkaufspreises aller Produkte.
```sql
SELECT AVG(VKpreis) AS Durchschnittspreis FROM mydb.Produkt;
```

### Ermitteln der Mitarbeitern mit Rolle
```sql
SELECT m.idMitarbeiter AS "Mitarbeiter ID", m.Nachname AS "Nachname", m.Vorname AS "Vorname", r.Name AS "Rolle"
FROM mydb.Mitarbeiter m
JOIN mydb.Mitarbeiter_hat_Rollen mr ON m.idMitarbeiter = mr.Mitarbeiter_idMitarbeiter
JOIN mydb.Rolle r ON mr.Rolle_idRolle = r.idRolle;
```

### Berechnung der Gesamtzahl der Mitarbeiter in jeder Stadt.
```sql
SELECT mydb.PLZ.Stadt, COUNT(*) AS Anzahl_Mitarbeiter 
FROM mydb.Mitarbeiter 
INNER JOIN mydb.Adresse ON mydb.Mitarbeiter.Adresse_idAdresse = mydb.Adresse.idAdresse 
INNER JOIN mydb.PLZ ON mydb.Adresse.PLZ_idPLZ = mydb.PLZ.idPLZ 
GROUP BY mydb.PLZ.Stadt;
```

### Auswahl aller Lieferanten, die mehr als 10 Produkte liefern.
```sql
SELECT mydb.Lieferant.idLieferant, mydb.Lieferant.Name, COUNT(mydb.Produkt_hat_Lieferant.Produkt_ProduktID) AS AnzahlProdukte
FROM mydb.Lieferant 
INNER JOIN mydb.Produkt_hat_Lieferant ON mydb.Lieferant.idLieferant = mydb.Produkt_hat_Lieferant.Lieferant_idLieferant 
GROUP BY mydb.Lieferant.idLieferant, mydb.Lieferant.Name
HAVING COUNT(mydb.Produkt_hat_Lieferant.Produkt_ProduktID) > 10;
```

### Aktualisierung des Bestands eines bestimmten Produkts (Auslösung des Triggeres.
```sql
UPDATE mydb.Produkt SET Bestand = Bestand - 1 WHERE idProdukt = 1;
```
```sql
SELECT * FROM mydb.Bestellungen;
```

### Auswahl aller Produkte, die nicht im Bestand sind
```sql
SELECT * FROM mydb.Produkt WHERE Bestand = 0;
```

### Ermittlung der Anzahl der Verkäufe pro Produkt.
```sql
SELECT Produkt_ProduktID, COUNT(*) AS Anzahl_Verkaeufe 
FROM mydb.ProduktVerkauf 
GROUP BY Produkt_ProduktID;
```

### Rekursive Anfrage zur Ermittlung aller Vertretungen für eine gegebene Vertretung (idVertretung = 1).
```sql
WITH RECURSIVE vertretungskette AS (
  SELECT idVertretung, Vertretung_idVertretung 
  FROM mydb.Vertretung 
  WHERE idVertretung = 1
  UNION ALL
  SELECT v.idVertretung, v.Vertretung_idVertretung 
  FROM mydb.Vertretung v
  JOIN vertretungskette ON v.Vertretung_idVertretung = vertretungskette.idVertretung
)
SELECT * FROM vertretungskette;
```

### Alle Produkte, welchen einen geringen Bestand haben und noch nicht bestellt sind.
```sql
SELECT * FROM mydb.produkt AS p WHERE bestand <= 5 AND NOT EXISTS (SELECT 1
  FROM mydb.Bestellung_haben_Produkte AS bhp
  JOIN mydb.Bestellungen AS b ON b.idBestellungen = bhp.Bestellungen_idBestellungen
  WHERE bhp.Produkt_idProdukt = p.idProdukt
  AND b.Bestellstatus = 'Bestellt');
```


