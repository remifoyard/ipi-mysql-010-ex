#EX01 ====================================================================================================
#1) Créer une base de données nommée entreprise.
CREATE TABLE entreprise
#2) Mettre la base entreprise par défaut pour la session
USE entreprise
#3) Voir quel encodage et collation sont utilisés dans cette base
SELECT @@character_set_database, @@collation_database
#4) Changer lencodage et la collation pour quils se basent sur UTF8
ALTER DATABASE entreprise CHARACTER SET = utf8 COLLATE = utf8_general_ci
#=========================================================================================================


#EX02 ====================================================================================================
#1) Créer un table Employe avec : 
#une clé primaire nommée id qui sauto-incrémente
#une date dembauche dateEmbauche permettant de stocker le jour de lembauche dun employé (sans lheure)
#un matricule matricule permettant de stocker 6 caractères alpha-numériques.
#un nom nom permettant de stocker 50 caractères alpha-numériques.
#un prenom prenom permettant de stocker 10 caractères alpha-numériques.
#un salaire salaire permettant de stocker des salaires jusquà 1234567,89 €
#un champ test permettant de stocker 120 caractères.

CREATE TABLE employe
(id PRIMARY KEY AUTO_INCREMENT, dateEmbauche date, matricule VARCHAR(6), nom VARCHAR(50), prenom VARCHAR(10),salaire DECIMAL(9,2), test VARCHAR(120) )

#=========================================================================================================


#EX03 ====================================================================================================
#Modifier la table Employe : 
#1) Supprimer le champ test
ALTER TABLE employe DROP test
#2) Ajouter une colonne tempsPartiel de type booléen avec comme valeur par défaut false, après la date dembauche
alter table employe ADD COLUMN tempsPartiel BOOLEAN DEFAULT FALSE
#3) Ajouter une colonne sexe permettant de stocker Mou F avec comme valeur par défaut M, après le prénom
alter table employe ADD COLUMN sexe ENUM(M,F) DEFAULT M
#4) Modifier la colonne prenom pour pouvoir stocker 50 caractères et refuser une valeur nulle
ALTER TABLE employe MODIFY prenom VARCHAR(50) NOT NULL
#5) Modifier la colonne nom pour refuser une valeur nulle
ALTER TABLE employe MODIFY nom VARCHAR(50) NOT NULL

#=========================================================================================================


#EX04 ====================================================================================================
#1) Ajouter une contrainte dunicité nommée matricule_unique sur la colonne matricule
ALTER TABLE employe add CONSTRAINT matricule_unique  UNIQUE  (matricule)

#=========================================================================================================


#EX05 ====================================================================================================
#1) Insérer Vincent Scheider, matricule C11106, embauché le 1er janvier 2001 à 1180,27 €
INSERT INTO Employe(nom, prenom, matricule, dateEmbauche, salaire,  sexe) VALUES ("Scheider", "Vincent", C11106, 2001-01-01, 1180.27,  M);
#2) Insérer Victor Gaillard, matricule M11109, embauché à temps partiel le 4 avril 2004 à 1480,30 €
INSERT INTO Employe(nom, prenom, matricule, dateEmbauche, salaire,tempsPartiel,  sexe) VALUES ("Gaillard", "Victor", M11109, 2004-04-04, 1480.30, TRUE,  M);

#3) Insérer Clémence Roussel, matricule T11101, embauchée le 4 avril 2004 à 1680,32 €
INSERT INTO Employe(nom, prenom, matricule, dateEmbauche, salaire,tempsPartiel,  sexe) VALUES ("Roussel", "Clémence", T11101, 2004-04-04, 1680.32, TRUE,  F);

#=========================================================================================================


#EX06 ====================================================================================================
#1) Exécuter le script dimport des employés employes.SQL
#mettre variable denvironnement dans windows parametres avances : le chemin de mysql/bin
#mysql -u root -proot -D entreprise < employes.sql
#2) Récupérer tous les employés
SELECT * FROM employe
#3) Compter le nombre demployés (2503)
select count(*) from employe
#4) Récupérer les employés qui gagnent plus de 1500 € (1665)
SELECT * FROM employe WHERE salaire >= 1500
#5) Récupérer les employés dans lordre décroissant de leur matricule (Clémence Roussel en premier)
SELECT * FROM employe ORDER BY matricule desc
#6) Récupérer toutes les femmes de lentreprise (1254)
SELECT * FROM employe WHERE sexe ='F'
#7) Récupérer tous les employés à temps partiel embauchés après le 1er janvier 2007 (1244)
SELECT * FROM employe WHERE tempsPartiel=TRUE AND date >='2007-01-01'
#8) En une seule requête, compter le nombre de femme et dhomme de lentreprise. (M : 1249, F : 1254)
select (select count(sexe) from employe where sexe = 'M') as M, (select count(sexe) from employe where sexe = 'F') as F from employe
#9) Récupérer le nombre dembauche par année : 
#2001:1
#2004:1
#2006:1
#2010:420
#2011:435
#2012:413
#2013:439
#2014:408
#2015:385
select YEAR(dateEmbauche) as annee, count(YEAR(dateEmbauche)) as nb from employe group by YEAR(dateEmbauche)

#10) Récupérer le nombre de techniciens (matricule qui commence par T), le nombre de commerciaux (matricule commencant par C) et le nombre de managers (matricule commençant par M)
#C:432
#M:420
#T:1651
select count(*) as nb from employe group by substring(matricule,1,1)

#11) Récupérer le nombre de personnes à temps partiel et à temps plein
#0:1259
#1:1244
select count(*) from employe group by tempsPartiel

#12) Récupérer tous les employés dont le prénom contient un M (majuscule ou minuscule) (738)
select * from employe where prenom like 'm%'

#13) Récupérer le salaire minimum, maximum et moyen de tous les employés
#1000.00, 2500.00, 1749.790208
select avg(salaire) as moyenne ,min(salaire) as mini ,max(salaire) as maxi from employe where prenom like 'm%'

#=========================================================================================================


#EX07 ====================================================================================================
#1) Faire passer le technicien de matricule T00027 à mi-temps (et donc diviser son salaire par 2...)
#Temps partiel : TRUE, salaire : 511.50
update employe set tempsPartiel=true, salaire=salaire/2 where matricule = 'T00027'
#=========================================================================================================


#EX08 ====================================================================================================
#1) Licencier lemployé T00115
DELETE from employe WHERE matricule='T00115'
#2) Licencier les 5 commerciaux qui gagnent le plus dargent
DELETE from employe where matricule like 'C%' order by salaire desc limit 5
#ID: 1540, 1211, 2359, 1668, 1748
#=========================================================================================================


#EX09 ====================================================================================================
#1) Effectuer une recherche sur une date dembauche existante, noter le temps dexécution de la requête
select * from employe where dateEmbauche = '2012-08-04' 
4ms

#2) Créer un index sur la table Employe, sur le champ dateEmbauche
create index date_emb on employe(dateEmbauche)

#3) Supprimer le cache (RESET QUERY CACHE;) et refaire la recherche et comparer les résultats
0ms
#=========================================================================================================


#EX10 ====================================================================================================
#1) Créer la table Commercial avec :
#un champ id qui référence lidentifiant de la table Employe et qui ne peut être nul (et permet la suppression en cascade)
#un champ caAnnuel qui contiendra le chiffre daffaire annuel du commercial par défaut à 0, max : 99999999,99 €
#un champ performance contenant un entier par défaut à 0
CREATE TABLE commercial (
	id int  AUTO_INCREMENT PRIMARY KEY,
	id_employe int(11) NOT NULL,
	caAnnuel decimal(10,2) DEFAULT 0,
	performance int DEFAULT 0,
	CONSTRAINT emp_id FOREIGN KEY (id_employe) REFERENCES employe (id) ON DELETE CASCADE
	
)

#2) Créer la table Manager avec :
#un champ id qui référence lidentifiant de la table Employe et qui ne peut être nul (et permet la suppression en cascade)
#un champ performance qui permet de stocker un entier
create TABLE manager (
	id int NOT NULL,
	id_employe int(11) NOT NULL,
	performance int,
	CONSTRAINT emp_id_m FOREIGN KEY (id_employe) REFERENCES employe (id) ON DELETE CASCADE
) 

#3) Créer la table Technicien avec
#un champ id qui référence lidentifiant de la table Employe et qui ne peut être nul (et permet la suppression en cascade)
#un champ grade contenant un entier par défaut à 1
#un champ manager_id qui référence Manager
create TABLE technicien (
	id int(11) NOT null AUTO_INCREMENT primary KEY,
	id_employe int(11) NOT NULL,
	id_manager int(11) NOT NULL,
	grade int(11) DEFAULT 1,
	constraint man_id_t FOREIGN key (id_manager) REFERENCES manager (id) ON DELETE cascade,
	constraint emp_id_t FOREIGN key (id_employe) REFERENCES employe (id) ON DELETE cascade
)

#=========================================================================================================


#EX11 ====================================================================================================
#1) Insérer une ligne dans la table Commercial pour chaque employé dont le matricule correspond à un commercial (427)
insert into commercial (id_employe) select id as id_employe from employe where matricule like 'M%'
#2) Insérer une ligne dans la table Manager pour chaque employé dont le matricule correspond à un manager et avec une performance aléatoire entre 1 et 10 (420)
insert into manager (id_employe,performance) select id as id_employe, FLOOR(RAND()*(10)+1) from employe where matricule like 'M%'
#3) Insérer une ligne dans la table Technicien pour chaque employé dont le matricule correspond à un technicien, 
#un grade en fonction de son salaire:
#<1100 : 1 (98)
#<1200 : 2 (119)
#<1300 : 3 (110)
#<1400 : 4 (105)
#>=1400 : 5 (1218)
insert
	into
		technicien(
			id_employe,
			grade
		) select
			id,
				case
					when salaire < 1100 then 1
					when salaire < 1200 then 2
					when salaire < 1300 then 3
					when salaire < 1400 then 4
					when salaire >= 1400 then 5
				end
		from
			employe
		where
			matricule like 'T%'
#=========================================================================================================


#EX12 ====================================================================================================
#1) Ecrire de 4 manières différentes une jointure entre Commercial et Employe
SELECT * FROM commercial com, employe emp WHERE emp.id = com.id_employe #dans les 2 tables
SELECT * FROM  employe emp inner join commercial com ON emp.id = com.id_employe #dans les deux tables
SELECT * FROM  employe emp right join commercial com ON emp.id = com.id_employe #seulement dans la TABLE de droite
SELECT * FROM  employe emp left join commercial com ON emp.id = com.id_employe #seulement dans la TABLE de gauche
#=========================================================================================================


#EX13 ====================================================================================================
#1) Récupérer les employés dont le salaire est supérieur au salaire moyen des employés (1247)
select * from employe where salaire>any(select avg(salaire) from employe)
#2) Récupérer les managers sans équipe
SELECT * FROM manager m WHERE NOT EXISTS (SELECT 1 FROM technicien WHERE manager_id=m.id) //ou SELECT * a la place de 1
#3) Licencier les commerciaux sans équipe
#=========================================================================================================


#EX14 ====================================================================================================
#1) Récupérer les informations générales des employés manager et des employés techniciens de grade 5
select * from employe em 
where em.id in (select e.id from employe e inner join manager m on m.id_employe=e.id) 
or em.id in (select emp.id from employe emp inner join technicien t on t.id_employe=emp.id where grade=5)

#=========================================================================================================

#EX15 ====================================================================================================
#1) Supprimer tous les techniciens, commerciaux et managers et refaire lexercice 11 en utilisant une procédure stockée 
#et des curseurs. Affecter aux techniciens un manager en répartissant le plus équitablement possible les équipes...

#=========================================================================================================


#EX16 ====================================================================================================
#1) Supprimer les managers sans équipe (6)
DELETE FROM Employe WHERE SUBSTRING(matricule, 1, 1) = 'M' 
AND id NOT IN (SELECT t.manager_id FROM Technicien t WHERE t.manager_id IS NOT NULL);

#2) Constater la suppression dans la table Employe et Commercial

#Cest fini !