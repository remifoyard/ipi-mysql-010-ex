DROP DATABASE entreprise;
#EX01 ====================================================================================================
#1) Créer une base de données nommée 'entreprise'.
CREATE DATABASE entreprise;
#2) Mettre la base entreprise par défaut pour la session
USE entreprise;
#3) Voir quel encodage et collation sont utilisés dans cette base
SELECT @@character_set_database, @@collation_database;
#4) Changer l'encodage et la collation pour qu'ils se basent sur UTF8
ALTER DATABASE entreprise CHARACTER SET = 'utf8' COLLATE = 'utf8_general_ci';
#=========================================================================================================


#EX02 ====================================================================================================
#1) Créer un table Employe avec : 
#une clé primaire nommée 'id' qui s'auto-incrémente'
#une date d'embauche 'dateEmbauche' permettant de stocker le jour de l'embauche d'un employé (sans l'heure)
#un matricule 'matricule' permettant de stocker 6 caractères alpha-numériques.
#un nom 'nom' permettant de stocker 50 caractères alpha-numériques.
#un prenom 'prenom' permettant de stocker 10 caractères alpha-numériques.
#un salaire 'salaire' permettant de stocker des salaires jusqu'à 1234567,89 €'
#un champ 'test' permettant de stocker 120 caractères.
CREATE TABLE `Employe` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dateEmbauche` date,
  `matricule` varchar(6),
  `nom` varchar(50),
  `prenom` varchar(10),
  `salaire` DECIMAL(9,2),
  `test` varchar(120),
  PRIMARY KEY (`id`)
);
#=========================================================================================================


#EX03 ====================================================================================================
#Modifier la table Employe : 
#1) Supprimer le champ 'test'
ALTER TABLE `Employe` DROP COLUMN `test`;
#2) Ajouter une colonne 'tempsPartiel' de type booléen avec comme valeur par défaut false, après la date d'embauche'
ALTER TABLE `Employe` ADD COLUMN `tempsPartiel` BOOL DEFAULT FALSE AFTER dateEmbauche;
#3) Ajouter une colonne 'sexe' permettant de stocker 'M'ou 'F' avec comme valeur par défaut 'M', après le prénom
ALTER TABLE `Employe` ADD COLUMN `sexe` ENUM('M', 'F') DEFAULT 'M' AFTER prenom;
#4) Modifier la colonne 'prenom' pour pouvoir stocker 50 caractères et refuser une valeur nulle
ALTER TABLE `Employe` MODIFY COLUMN `prenom` VARCHAR(50) NOT NULL;
#5) Modifier la colonne 'nom' pour refuser une valeur nulle
ALTER TABLE `Employe` MODIFY COLUMN `nom` VARCHAR(50) NOT NULL;
#=========================================================================================================


#EX04 ====================================================================================================
#1) Ajouter une contrainte d'unicité nommée matricule_unique sur la colonne matricule'
ALTER TABLE `Employe` ADD CONSTRAINT matricule_unique UNIQUE(matricule);

#Vérifications
SET sql_mode = 'STRICT_TRANS_TABLES';

#Devrait échouer
INSERT INTO Employe(nom, prenom, matricule, dateEmbauche, salaire) VALUES (null, "Clémence", "T11101", '2006-06-06', 1680.32);
INSERT INTO Employe(nom, prenom, matricule, dateEmbauche, salaire) VALUES ("Roussel", null, "T11101", '2006-06-06', 1680.32);
INSERT INTO Employe(nom, prenom, matricule, dateEmbauche, salaire) VALUES ("Roussel", "Clémence", "T111011", '2006-06-06', 1680.32);
INSERT INTO Employe(nom, prenom, matricule, dateEmbauche, salaire) VALUES ("Roussel", "Clémence", "T11101", 'ABCD-06-06', 1680.32);
#=========================================================================================================


#EX05 ====================================================================================================
#1) Insérer Vincent Scheider, matricule C11106, embauché le 1er janvier 2001 à 1180,27 €
INSERT INTO Employe(nom, prenom, matricule, dateEmbauche, salaire) VALUES ("Schneider", "Vincent", "C11106", '2001-01-01', 1180.27);
#2) Insérer Victor Gaillard, matricule M11109, embauché à temps partiel le 4 avril 2004 à 1480,30 €
INSERT INTO Employe(nom, prenom, matricule, dateEmbauche, salaire, tempsPartiel) VALUES ("Gaillard", "Victor", "M11109", '2004-04-04', 1480.30, true);
#3) Insérer Clémence Roussel, matricule T11101, embauchée le 4 avril 2004 à 1680,32 €
INSERT INTO Employe(nom, prenom, matricule, dateEmbauche, salaire, sexe) VALUES ("Roussel", "Clémence", "T11101", '2006-06-06', 1680.32, 'F');
#=========================================================================================================


#EX06 ====================================================================================================
#1) Exécuter le script d'import des employés employes.sql'
#mysql -u root -proot -D entreprise < employes.sql
#2) Récupérer tous les employés
SELECT * FROM Employe;
#3) Compter le nombre d'employés (2503)'
SELECT count(*) FROM Employe; 
#4) Récupérer les employés qui gagnent plus de 1500 € (1665)
SELECT * FROM Employe WHERE salaire > 1500;
#5) Récupérer les employés dans l'ordre décroissant de leur matricule (Clémence Roussel en premier)'
SELECT * FROM Employe ORDER BY matricule DESC;
#6) Récupérer toutes les femmes de l'entreprise (1254)'
SELECT * FROM Employe WHERE sexe = 'F';
#7) Récupérer tous les employés à temps partiel embauchés après le 1er janvier 2007 (1243)
SELECT * FROM Employe WHERE dateEmbauche > '2007-01-01' AND tempsPartiel = TRUE;
#8) En une seule requête, compter le nombre de femme et d'homme de l'entreprise. (M : 1249, F : 1254)
SELECT sexe, count(*) FROM Employe GROUP BY sexe;
#9) Récupérer le nombre d'embauche par année : '
#2001:1
#2004:1
#2006:1
#2010:420
#2011:435
#2012:413
#2013:439
#2014:408
#2015:385
SELECT YEAR(dateEmbauche), count(*) FROM Employe GROUP BY YEAR(dateEmbauche);
#10) Récupérer le nombre de techniciens (matricule qui commence par T), le nombre de commerciaux (matricule commencant par C) et le nombre de managers (matricule commençant par M)
#C:432
#M:420
#T:1651
SELECT SUBSTRING(matricule, 1,1), count(*) FROM Employe GROUP BY SUBSTRING(matricule, 1, 1);
#11) Récupérer le nombre de personnes à temps partiel et à temps plein
#0:1259
#1:1244
SELECT tempsPartiel, count(*) FROM Employe GROUP BY tempsPartiel;
#12) Récupérer tous les employés dont le prénom contient un M (majuscule ou minuscule) (738)
SELECT * FROM Employe WHERE UPPER(prenom) LIKE '%M%';
#13) Récupérer le salaire minimum, maximum et moyen de tous les employés
#1000.00, 2500.00, 1749.790208
SELECT min(salaire), MAX(salaire), AVG(salaire) FROM Employe;
#=========================================================================================================


#EX07 ====================================================================================================
#1) Faire passer le technicien de matricule T00027 à mi-temps (et donc diviser son salaire par 2...)
#Temps partiel : TRUE, salaire : 511.50
SELECT * FROM Employe WHERE matricule = 'T00027'; 
UPDATE Employe SET salaire = salaire / 2, tempsPartiel = TRUE WHERE matricule = 'T00027';
SELECT * FROM Employe WHERE matricule = 'T00027'; 
#=========================================================================================================


#EX08 ====================================================================================================
#1) Licencier l'employé T00115'
SELECT * FROM Employe WHERE matricule = 'T00115'; 
DELETE FROM Employe WHERE matricule = 'T00115';
SELECT * FROM Employe WHERE matricule = 'T00115'; 

#2) Licencier les 5 commerciaux qui gagnent le plus d'argent'
SELECT * FROM Employe WHERE matricule LIKE 'C%' ORDER BY salaire DESC LIMIT 5; 
#ID: 1540, 1211, 2359, 1668, 1748
DELETE FROM Employe WHERE matricule LIKE 'C%' ORDER BY salaire DESC LIMIT 5;
SELECT * FROM Employe WHERE ID IN (1540, 1211, 2359, 1668, 1748);
#=========================================================================================================


#EX09 ====================================================================================================
#1) Effectuer une recherche sur une date d'embauche existante, noter le temps d'exécution de la requête
SELECT * FROM Employe WHERE dateEmbauche = '2012-06-01'; 
#2) Créer un index sur la table Employe, sur le champ dateEmbauche
CREATE INDEX idx_dateEmbauche ON Employe(dateEmbauche);
#3) Supprimer le cache (RESET QUERY CACHE;) et refaire la recherche et comparer les résultats
RESET QUERY CACHE;
SELECT * FROM Employe WHERE dateEmbauche = '2012-06-01'; 
#=========================================================================================================


#EX10 ====================================================================================================
#1) Créer la table Commercial avec :
#un champ 'id' qui référence l'identifiant de la table Employe et qui ne peut être nul (et permet la suppression en cascade)'
#un champ 'caAnnuel' qui contiendra le chiffre d'affaire annuel du commercial par défaut à 0, max : 99999999,99 €
#un champ 'performance' contenant un entier par défaut à 0'
CREATE TABLE `Commercial` (
  `id` bigint(20) NOT NULL,
  `caAnnuel` DECIMAL(10,2) DEFAULT 0.0,
  `performance` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  CONSTRAINT `commercial_employe_fk` FOREIGN KEY (`id`) REFERENCES `Employe` (`id`) ON DELETE CASCADE
);

#2) Créer la table Manager avec :
#un champ 'id' qui référence l'identifiant de la table Employe et qui ne peut être nul (et permet la suppression en cascade)'
#un champ 'performance' qui permet de stocker un entier
CREATE TABLE `Manager` (
  `id` bigint(20) NOT NULL,
  `performance` TINYINT,
  PRIMARY KEY (`id`),
  CONSTRAINT `manager_employe_fk` FOREIGN KEY (`id`) REFERENCES `Employe` (`id`) ON DELETE CASCADE
);

#3) Créer la table Technicien avec
#un champ 'id' qui référence l'identifiant de la table Employe et qui ne peut être nul (et permet la suppression en cascade)'
#un champ 'grade' contenant un entier par défaut à 1
#un champ manager_id qui référence Manager
CREATE TABLE `Technicien` (
  `id` bigint(20) NOT NULL,
  `grade` int(11) DEFAULT 1,
  `manager_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `technicien_employe_fk` FOREIGN KEY (`id`) REFERENCES `Employe` (`id`) ON DELETE CASCADE,
  CONSTRAINT `technicien_manager_fk` FOREIGN KEY (`manager_id`) REFERENCES `Manager` (`id`)
);
#=========================================================================================================


#EX11 ====================================================================================================
#1) Insérer une ligne dans la table Commercial pour chaque employé dont le matricule correspond à un commercial (427)
INSERT INTO Commercial(id) SELECT id FROM Employe
WHERE SUBSTRING(matricule, 1, 1) = 'C';
#2) Insérer une ligne dans la table Manager pour chaque employé dont le matricule correspond à un manager et avec une performance aléatoire entre 1 et 10 (420)
INSERT INTO Manager(id, performance) SELECT id, FLOOR(1 + RAND() * 10) FROM Employe
WHERE SUBSTRING(matricule, 1, 1) = 'M';
#3) Insérer une ligne dans la table Technicien pour chaque employé dont le matricule correspond à un technicien, 
#un grade en fonction de son salaire:
#<1100 : 1 (98)
#<1200 : 2 (119)
#<1300 : 3 (110)
#<1400 : 4 (105)
#>=1400 : 5 (1218)
INSERT INTO Technicien(id, grade) 
	SELECT id, CASE 
		WHEN salaire < 1100 THEN 1 
		WHEN salaire < 1200 THEN 2
		WHEN salaire < 1300 THEN 3 
		WHEN salaire < 1400 THEN 4 
		ELSE 5 
		END
	FROM Employe
WHERE SUBSTRING(matricule, 1, 1) = 'T';

SELECT grade, count(*) FROM Technicien GROUP BY grade;
#=========================================================================================================


#EX12 ====================================================================================================
#1) Ecrire de 4 manières différentes une jointure entre Commercial et Employe
SELECT * FROM Commercial c INNER JOIN Employe e USING (id); 
SELECT * FROM Commercial c INNER JOIN Employe e ON c.id = e.id;
SELECT * FROM Commercial c NATURAL JOIN Employe ;
SELECT * FROM Commercial c, Employe e WHERE c.id = e.id;
#=========================================================================================================


#EX13 ====================================================================================================
#1) Récupérer les employés dont le salaire est supérieur au salaire moyen des employés (1247)
SELECT count(*) FROM Employe WHERE salaire > (SELECT avg(e2.salaire) FROM Employe e2);
#2) Récupérer les managers sans équipe
SELECT * FROM Manager c WHERE NOT EXISTS (SELECT 1 FROM Technicien WHERE manager_id = c.id);
#3) Licencier les commerciaux sans équipe
DELETE FROM Manager c WHERE NOT EXISTS (SELECT 1 FROM Technicien WHERE manager_id = c.id);
#=========================================================================================================


#EX14 ====================================================================================================
#1) Récupérer les informations générales des employés manager et des employés techniciens de grade 5
SELECT e.* FROM Employe e INNER JOIN Manager m on m.id_employe=e.id
UNION
SELECT e.* FROM Employe e INNER JOIN Technicien t on t.id_employe=e.id
WHERE t.grade = 5;
#=========================================================================================================

#EX15 ====================================================================================================
#1) Supprimer tous les techniciens, commerciaux et managers et refaire l'exercice 11 en utilisant une procédure stockée '
#et des curseurs. Affecter aux techniciens un manager en répartissant le plus équitablement possible les équipes...

DELETE FROM Technicien;
DELETE FROM Commercial;
DELETE FROM Manager;

DROP PROCEDURE IF EXISTS fill_db;
DELIMITER |
CREATE PROCEDURE fill_db()
BEGIN
	DECLARE v_id INT;
	DECLARE v_nb_techniciens INT;
	DECLARE v_nb_managers INT;
	DECLARE v_taille_equipe INT;
	DECLARE v_id_m INT;
	DECLARE v_salaire DECIMAL;
	DECLARE v_nb_tech_manager INT DEFAULT 0;
	DECLARE v_code VARCHAR(1);
	DECLARE done TINYINT(1) DEFAULT FALSE;

	DECLARE all_employes CURSOR FOR SELECT id, SUBSTRING(matricule, 1, 1), salaire FROM Employe ORDER BY matricule ASC;
	DECLARE all_managers CURSOR FOR SELECT id FROM Employe WHERE SUBSTRING(matricule, 1, 1) = 'M';
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	OPEN all_employes;
	OPEN all_managers;
	
	SELECT count(*) INTO v_nb_techniciens FROM Employe WHERE SUBSTRING(matricule, 1, 1) = 'T';
	SELECT count(*) INTO v_nb_managers FROM Employe WHERE SUBSTRING(matricule, 1, 1) = 'M';
	
	SET v_taille_equipe = CEIL(v_nb_techniciens / v_nb_managers);
	
	boucle: LOOP
		FETCH all_employes INTO v_id, v_code, v_salaire;
		IF done = TRUE THEN
			LEAVE boucle;
		END IF;
		IF v_code = 'M' THEN
			INSERT INTO Manager(id) VALUES(v_id);
		ELSEIF v_code = 'C' THEN
			INSERT INTO Commercial(id, performance) VALUES(v_id, FLOOR(1 + RAND() * 10));
		ELSEIF v_code = 'T' THEN
			IF v_nb_tech_manager = 0 AND NOT done THEN
				FETCH all_managers INTO v_id_m;
			ELSEIF v_nb_tech_manager = v_taille_equipe - 1 THEN
				SET v_nb_tech_manager = -1;
			END IF;
			INSERT INTO Technicien(id, manager_id, grade) VALUES(v_id, v_id_m, CASE 
				WHEN v_salaire < 1100 THEN 1 
				WHEN v_salaire < 1200 THEN 2
				WHEN v_salaire < 1300 THEN 3 
				WHEN v_salaire < 1400 THEN 4 
				ELSE 5 
				END
			);
			SET v_nb_tech_manager = v_nb_tech_manager + 1;
		END IF;
		
	END LOOP;
	CLOSE all_employes;
	CLOSE all_managers;
END|
DELIMITER ;

DELETE FROM Technicien;
DELETE FROM Commercial;
DELETE FROM Manager;

CALL fill_db();
#=========================================================================================================


#EX16 ====================================================================================================
#1) Supprimer les managers sans équipe (6)
DELETE FROM Employe WHERE SUBSTRING(matricule, 1, 1) = 'M' 
AND id NOT IN (SELECT t.manager_id FROM Technicien t WHERE t.manager_id IS NOT NULL);

#2) Constater la suppression dans la table Employe et Commercial

#C'est fini !