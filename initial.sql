-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS mydb;

-- -----------------------------------------------------
-- Table mydb.Schicht
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Schicht (
  idSchicht SERIAL NOT NULL,
  Schichtname VARCHAR(45) NULL,
  Schichtbeginn VARCHAR(45) NULL,
  Schichtende VARCHAR(45) NULL,
  Schichtdauer VARCHAR(45) NULL,
  Schichtstatus VARCHAR(45) NULL,
  PRIMARY KEY (idSchicht))
;


-- -----------------------------------------------------
-- Table mydb.Produkt
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Produkt (
  idProdukt SERIAL NOT NULL,
  Name VARCHAR(45) NULL,
  VKpreis double precision NULL,
  EKpreis double precision NULL,
  Bestand INT NULL,
  Kategorie VARCHAR(45) NULL,
  PRIMARY KEY (idProdukt))
;


-- -----------------------------------------------------
-- Table mydb.PLZ
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.PLZ (
  idPLZ INT NOT NULL,
  Stadt VARCHAR(45) NULL,
  PRIMARY KEY (idPLZ))
;


-- -----------------------------------------------------
-- Table mydb.Adresse
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Adresse (
  idAdresse SERIAL NOT NULL,
  Straße VARCHAR(45) NULL,
  Hausnummer VARCHAR(10) NULL,
  PLZ_idPLZ INT NOT NULL,
  PRIMARY KEY (idAdresse),
  CONSTRAINT fk_Adresse_PLZ1
    FOREIGN KEY (PLZ_idPLZ)
    REFERENCES mydb.PLZ (idPLZ)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table mydb.Mitarbeiter
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Mitarbeiter (
  idMitarbeiter SERIAL NOT NULL,
  Nachname VARCHAR(45) NULL,
  Vorname VARCHAR(45) NULL,
  Adresse_idAdresse INT NOT NULL,
  PRIMARY KEY (idMitarbeiter),
  UNIQUE (idMitarbeiter, Adresse_idAdresse),
  CONSTRAINT fk_Mitarbeiter_Adresse1
    FOREIGN KEY (Adresse_idAdresse)
    REFERENCES mydb.Adresse (idAdresse)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table mydb.Kasse
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Kasse (
  idKasse SERIAL NOT NULL,
  Mitarbeiter_idMitarbeiter INT NOT NULL,
  PRIMARY KEY (idKasse),
  CONSTRAINT fk_Kasse_Mitarbeiter1
    FOREIGN KEY (Mitarbeiter_idMitarbeiter)
    REFERENCES mydb.Mitarbeiter (idMitarbeiter)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table mydb.Vertretung
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Vertretung (
  idVertretung SERIAL PRIMARY KEY,
  Vertretungsgrund VARCHAR(45) NULL,
  Vertretung_idVertretung INT NULL,
  VertretenerMitarbeiter_id INT NULL,
  
  UNIQUE (idVertretung, Vertretung_idVertretung),
  CONSTRAINT fk_Vertretung_Vertretung1
    FOREIGN KEY (Vertretung_idVertretung)
    REFERENCES mydb.Vertretung (idVertretung)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Vertretung_Mitarbeiter1
    FOREIGN KEY (VertretenerMitarbeiter_id)
    REFERENCES mydb.Mitarbeiter (idMitarbeiter)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;

-- -----------------------------------------------------
-- Table mydb.SchichtenZuordnung
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.SchichtenZuordnung (
  Mitarbeiter_idMitarbeiter INT NOT NULL,
  Schicht_idSchicht INT NOT NULL,
  Schichtdatum DATE NULL,
  Vertretung_idVertretung INT NULL,
  PRIMARY KEY (Mitarbeiter_idMitarbeiter, Schicht_idSchicht, Schichtdatum),
  CONSTRAINT fk_Mitarbeiter_has_Schicht_Mitarbeiter1
    FOREIGN KEY (Mitarbeiter_idMitarbeiter)
    REFERENCES mydb.Mitarbeiter (idMitarbeiter)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Mitarbeiter_has_Schicht_Schicht1
    FOREIGN KEY (Schicht_idSchicht)
    REFERENCES mydb.Schicht (idSchicht)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_SchichtenZuordnung_Vertretung1
    FOREIGN KEY (Vertretung_idVertretung)
    REFERENCES mydb.Vertretung (idVertretung)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
;

-- -----------------------------------------------------
-- Table mydb.Lieferant
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Lieferant (
  idLieferant SERIAL NOT NULL,
  Name VARCHAR(45) NULL,
  Adresse_idAdresse INT NOT NULL,
  PRIMARY KEY (idLieferant),
  CONSTRAINT fk_Lieferant_Adresse1
    FOREIGN KEY (Adresse_idAdresse)
    REFERENCES mydb.Adresse (idAdresse)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table mydb.Produkt_hat_Lieferant
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Produkt_hat_Lieferant (
  Produkt_ProduktID INT NOT NULL,
  Lieferant_idLieferant INT NOT NULL,
  PRIMARY KEY (Produkt_ProduktID, Lieferant_idLieferant),
  CONSTRAINT fk_Produkt_has_Lieferant_Produkt1
    FOREIGN KEY (Produkt_ProduktID)
    REFERENCES mydb.Produkt (idProdukt)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Produkt_has_Lieferant_Lieferant1
    FOREIGN KEY (Lieferant_idLieferant)
    REFERENCES mydb.Lieferant (idLieferant)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table mydb.ProduktVerkauf
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.ProduktVerkauf (
  Verkäufe_idVerkäufe INT NOT NULL,
  Produkt_ProduktID INT NOT NULL,
  VKdatum TIMESTAMP NULL,
  VKmenge INT NULL,
  PRIMARY KEY (Verkäufe_idVerkäufe, Produkt_ProduktID),
  CONSTRAINT fk_Verkäufe_has_Produkt_Verkäufe1
    FOREIGN KEY (Verkäufe_idVerkäufe)
    REFERENCES mydb.Kasse (idKasse)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Verkäufe_has_Produkt_Produkt1
    FOREIGN KEY (Produkt_ProduktID)
    REFERENCES mydb.Produkt (idProdukt)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table mydb.Rolle
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Rolle (
  idRolle SERIAL NOT NULL,
  Name VARCHAR(45) NULL,
  PRIMARY KEY (idRolle))
;


-- -----------------------------------------------------
-- Table mydb.Mitarbeiter_hat_Rollen
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Mitarbeiter_hat_Rollen (
  Mitarbeiter_idMitarbeiter INT NOT NULL,
  Rolle_idRolle INT NOT NULL,
  PRIMARY KEY (Mitarbeiter_idMitarbeiter, Rolle_idRolle),
  CONSTRAINT fk_Mitarbeiter_has_Rolle_Mitarbeiter1
    FOREIGN KEY (Mitarbeiter_idMitarbeiter)
    REFERENCES mydb.Mitarbeiter (idMitarbeiter)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Mitarbeiter_has_Rolle_Rolle1
    FOREIGN KEY (Rolle_idRolle)
    REFERENCES mydb.Rolle (idRolle)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table mydb.Bestellungen
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Bestellungen (
  idBestellungen SERIAL NOT NULL,
  Bestellnummer VARCHAR(45) NULL,
  Bestellstatus VARCHAR(45) NULL,
  Datum TIMESTAMP NULL,
  PRIMARY KEY (idBestellungen))
;


-- -----------------------------------------------------
-- Table mydb.Bestellung_haben_Produkte
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Bestellung_haben_Produkte (
  Produkt_idProdukt INT NOT NULL,
  Bestellungen_idBestellungen INT NOT NULL,
  Anzahl INT NULL,
  PRIMARY KEY (Produkt_idProdukt, Bestellungen_idBestellungen),
  CONSTRAINT fk_Produkt_has_Bestellungen_Produkt1
    FOREIGN KEY (Produkt_idProdukt)
    REFERENCES mydb.Produkt (idProdukt)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Produkt_has_Bestellungen_Bestellungen1
    FOREIGN KEY (Bestellungen_idBestellungen)
    REFERENCES mydb.Bestellungen (idBestellungen)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;


-- -----------------------------------------------------
-- Table mydb.Lieferanten_haben_Bestellungen
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Lieferanten_haben_Bestellungen (
  Lieferant_idLieferant INT NOT NULL,
  Bestellungen_idBestellungen INT NOT NULL,
  PRIMARY KEY (Lieferant_idLieferant, Bestellungen_idBestellungen),
  CONSTRAINT fk_Lieferant_has_Bestellungen_Lieferant1
    FOREIGN KEY (Lieferant_idLieferant)
    REFERENCES mydb.Lieferant (idLieferant)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Lieferant_has_Bestellungen_Bestellungen1
    FOREIGN KEY (Bestellungen_idBestellungen)
    REFERENCES mydb.Bestellungen (idBestellungen)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
;



-- Insert sample data for PLZ
INSERT INTO mydb.PLZ (idPLZ, Stadt)
VALUES 
(10115, 'Flussfurt'), 
(20095, 'Bergheim'), 
(50667, 'Wiesenstadt'), 
(30159, 'Waldenburg'), 
(80331, 'Seenland'),
(40000, 'Hügelhafen'), 
(50000, 'Tannental'), 
(60000, 'Steinbrück'), 
(70000, 'Schattenwald'), 
(80000, 'Lichterfeld');


-- Insert sample data for Adresse
INSERT INTO mydb.Adresse (Straße, Hausnummer, PLZ_idPlz)
VALUES 
('Birkenweg', 1, 10115), 
('Tannenstraße', 12, 20095), 
('Fichtenallee', 23, 50667), 
('Eichenplatz', 34, 30159), 
('Ahornring', 45, 80331), 
('Lindenbogen', 56, 40000), 
('Eschenpfad', 67, 50000), 
('Buchensteg', 78, 60000), 
('Ulmenhang', 89, 70000), 
('Erlenstieg', 100, 80000),
('Birkenallee', 2, 10115), 
('Eichenstraße', 13, 20095), 
('Fichtenweg', 24, 50667), 
('Tannenplatz', 35, 30159), 
('Ahornweg', 46, 80331), 
('Lindenstraße', 57, 40000), 
('Eschenweg', 68, 50000), 
('Buchenring', 79, 60000), 
('Ulmenstraße', 90, 70000), 
('Erlenweg', 101, 80000),
('Birkenring', 3, 10115), 
('Eichenallee', 14, 20095), 
('Fichtenplatz', 25, 50667), 
('Tannenweg', 36, 30159), 
('Ahornplatz', 47, 80331), 
('Lindenweg', 58, 40000), 
('Eschenring', 69, 50000), 
('Buchenallee', 80, 60000), 
('Ulmenplatz', 91, 70000), 
('Erlenallee', 102, 80000);

-- Insert sample data for Schicht
INSERT INTO mydb.Schicht (Schichtname, Schichtbeginn, Schichtende, Schichtdauer, Schichtstatus)
VALUES 
('Frühschicht', '06:00:00', '14:00:00', '08:00:00', 'Aktiv'), 
('Spätschicht', '14:00:00', '22:00:00', '08:00:00', 'Aktiv'), 
('Nachtschicht', '22:00:00', '06:00:00', '08:00:00', 'Aktiv');

-- Insert sample data for Produkt
INSERT INTO mydb.Produkt (Name, VKpreis, EKpreis, Bestand, Kategorie)
VALUES 
('Banane', 0.99, 0.50, 300, 'Obst'),
('Apfel', 1.49, 0.80, 250, 'Obst'),
('Orangensaft', 2.99, 1.50, 100, 'Getränke'),
('Brot', 3.49, 2.00, 50, 'Backwaren'),
('Milch', 2.49, 1.30, 120, 'Getränke'),
('Käse', 4.99, 2.50, 70, 'Molkereiprodukte'),
('Wein', 15.99, 10.00, 60, 'Alkohol'),
('Bier', 3.99, 2.00, 150, 'Alkohol'),
('Vodka', 3.99, 2.00, 150, 'Alkohol'),
('Jägermeister', 3.99, 2.00, 150, 'Alkohol'),
('Schokolade', 2.99, 1.50, 200, 'Süßwaren'),
('Chips', 1.99, 1.00, 250, 'Snacks'),
('Erdbeere', 4.99, 2.50, 200, 'Obst'),
('Karotte', 0.79, 0.40, 150, 'Gemüse'),
('Cola', 1.49, 0.75, 500, 'Getränke'),
('Croissant', 1.99, 1.00, 100, 'Backwaren'),
('Joghurt', 1.29, 0.70, 200, 'Molkereiprodukte'),
('Rum', 19.99, 15.00, 0, 'Alkohol'),
('Gummibärchen', 0.99, 0.50, 400, 'Süßwaren'),
('Nüsse', 3.49, 2.00, 180, 'Snacks'),
('Tomate', 0.99, 0.50, 100, 'Gemüse'),
('Wasser', 0.99, 0.25, 1000, 'Getränke');


-- Insert corrected sample data for Mitarbeiter
INSERT INTO mydb.Mitarbeiter (Nachname, Vorname, Adresse_idAdresse)
VALUES 
('Schmidt', 'Stefan', 13), 
('Meier', 'Monika', 22), 
('Müller', 'Martin', 8), 
('Schneider', 'Sandra', 5), 
('Fischer', 'Frank', 18), 
('Schulz', 'Sabine', 12),
('Koch', 'Katja', 26),
('Bauer', 'Benjamin', 4),
('Weber', 'Werner', 16),
('Hoffmann', 'Hannah', 9),
('Lehmann', 'Laura', 25),
('Wagner', 'Wilfried', 7),
('Becker', 'Bianca', 3),
('Hansen', 'Hannes', 21),
('Richter', 'Rosalie', 10);

-- Insert sample data for Kasse
INSERT INTO mydb.Kasse (Mitarbeiter_idMitarbeiter)
VALUES (1), (2), (3), (4), (5);

-- Insert sample data for SchichtenZuordnung
INSERT INTO mydb.SchichtenZuordnung (Mitarbeiter_idMitarbeiter, Schicht_idSchicht, Schichtdatum)
VALUES 
(2, 1, '2023-05-10'), 
(3, 2, '2023-05-10'), 
(4, 3, '2023-05-10'), 
(2, 1, '2023-05-11'), 
(3, 2, '2023-05-11');

-- Insert sample data for Vertretung 1
INSERT INTO mydb.Vertretung (Vertretungsgrund, Vertretung_idVertretung, vertretenermitarbeiter_id)
VALUES 
('Krankheit', null, 2);

UPDATE mydb.SchichtenZuordnung SET mitarbeiter_idmitarbeiter = 3, vertretung_idvertretung = 1 
WHERE mitarbeiter_idmitarbeiter = 2 AND schicht_idschicht = 1 AND schichtdatum = '2023-05-10';
 
-- Insert sample data for Vertretung 2
INSERT INTO mydb.Vertretung (Vertretungsgrund, Vertretung_idVertretung, vertretenermitarbeiter_id)
VALUES ('Urlaub', null, 3);
-- ('Bildungsurlaub', 2, );
-- ('Fortbildung', null)
-- ('Mutterschutz', null)
-- ('Sonderurlaub', null)
-- ('Elternzeit', 1)
-- ('Pflegezeit', 3)
-- ('Sabbatical', 4)
-- ('Politische Tätigkeit', 5)

UPDATE mydb.SchichtenZuordnung SET mitarbeiter_idmitarbeiter = 4, vertretung_idvertretung = 2 
WHERE mitarbeiter_idmitarbeiter = 3 AND schicht_idschicht = 2 AND schichtdatum = '2023-05-10';

-- Insert sample data for Lieferant
INSERT INTO mydb.Lieferant (Name, Adresse_idAdresse)
VALUES 
('Alles AG', 1), 
('Apfelgarten GmbH', 2), 
('Saftige Zitrus Ltd.', 6), 
('Bäckermeister Müller', 11), 
('Frische Kuh Ltd.', 14), 
('Cheesy Delights GmbH', 15), 
('Weinberg Schätze', 17), 
('Brauerei Berg', 19), 
('Süße Versuchung Ltd.', 20), 
('Crunchy Chip Co.', 23), 
('Erdbeerfelder GmbH', 24), 
('Karottenkönig Ltd.', 27), 
('Kohlensäure Classic Co.', 28), 
('Croissant Himmel Ltd.', 29), 
('Joghurtgenuss GmbH', 1), 
('Karibischer Rum Co.', 2), 
('Bunte Bärchen GmbH', 6), 
('Nussknacker AG', 11), 
('Tomatenparadies Ltd.', 14), 
('Wasserwelt GmbH', 15);


INSERT INTO mydb.Produkt_hat_Lieferant (Produkt_ProduktID, Lieferant_idLieferant)
VALUES 
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(2, 2), 
(3, 3), 
(4, 4), 
(5, 5), 
(6, 6), 
(7, 7), 
(8, 8), 
(9, 9), 
(10, 10), 
(11, 11), 
(12, 12), 
(13, 13), 
(14, 14), 
(15, 15), 
(16, 16), 
(17, 17), 
(18, 18), 
(19, 19), 
(20, 20);



-- Insert sample data for Rolle
INSERT INTO mydb.Rolle (name)
VALUES 
('Mitarbeiter'),
('Filialleiter'), 
('Aushilfe');

-- Insert sample data for Mitarbeiter_hat_rollen
INSERT INTO mydb.Mitarbeiter_hat_rollen (mitarbeiter_idmitarbeiter, rolle_idrolle)
VALUES (1,  2), (2, 1), (3, 1), (4, 1), (5, 1);

-- Kasse aktualisieren
UPDATE mydb.Kasse
SET Mitarbeiter_idMitarbeiter = 6
WHERE idKasse = 1;

-- Trigger für automatisches bestellen bei niedrigem Bestand
CREATE OR REPLACE FUNCTION mydb.bestellen() RETURNS TRIGGER AS $example_table$
    DECLARE 
        bestellnummertmp VARCHAR(45);
        idbestellung INT;
    BEGIN
        IF NEW.Bestand < 5 THEN
            IF (SELECT COUNT(*) FROM mydb.Bestellungen, mydb.Bestellung_haben_produkte, mydb.produkt 
                    WHERE mydb.Bestellungen.idbestellungen = mydb.Bestellung_haben_produkte.bestellungen_idbestellungen 
                        AND mydb.Bestellung_haben_produkte.produkt_idprodukt = mydb.produkt.idprodukt 
                        AND mydb.Bestellungen.bestellstatus = 'Bestellt' 
                        AND mydb.produkt.idprodukt = NEW.idprodukt) > 0
            THEN
                RAISE NOTICE 'Bestand unter 5 Produkte. Produkt bereits vorher bestellt';
                RETURN NEW;
            ELSE
                bestellnummertmp := CONCAT('AUTO-', gen_random_uuid());
                INSERT INTO mydb.Bestellungen (Bestellnummer, Bestellstatus, Datum)
                    VALUES (bestellnummertmp, 'Bestellt', NOW());
                idbestellung := (SELECT idbestellungen FROM mydb.bestellungen WHERE bestellnummer=bestellnummertmp);
                INSERT INTO mydb.Bestellung_haben_produkte(produkt_idprodukt, bestellungen_idbestellungen, anzahl) VALUES(NEW.idprodukt, idbestellung, 50);
                RAISE NOTICE 'Bestand unter 5 Produkte. Produkt wird bestellt.';
            END IF;
        END IF;
        RETURN NEW;
   END;
$example_table$ LANGUAGE plpgsql;

CREATE TRIGGER check_and_order_product_stock AFTER UPDATE
ON mydb.Produkt 
FOR EACH ROW
EXECUTE PROCEDURE mydb.bestellen();
