#Pour cette database, nous avons d'abord créé toutes celles qui n'ont pas de 
#clé étrangère afin d'éviter des bugs. 
drop database foody;
create database foody;
use foody;

 CREATE TABLE client( 
   Codecli VARCHAR(50),
   Societe VARCHAR(50),
   Contact VARCHAR(50),
   Fonction VARCHAR(50),
   Adresse VARCHAR(50),
   Ville VARCHAR(50),
   Region VARCHAR(50),
   Codepostal VARCHAR(50),
   Pays VARCHAR(50),
   Tel VARCHAR(50),
   Fax VARCHAR(50)
);

CREATE TABLE produit(
   Refprod INT,
   NomProd VARCHAR(50),
   NoFour INT,
   CodeCateg INT,
   QteParUnit VARCHAR(50),
   PrixUnit DECIMAL(15,2),
   UnitesStock INT,
   UnitesCom INT,
   NiveauReap INT,
   Indisponible INT
);

CREATE TABLE employe(
   NoEmp INT,
   Nom VARCHAR(50),
   Prenom VARCHAR(50),
   Fonction VARCHAR(50),
   TitreCourtoisie VARCHAR(50),
   DateNaissance DATETIME,
   DateEmbauche DATETIME,
   Adresse VARCHAR(50),
   Ville VARCHAR(50),
   Region VARCHAR(50),
   Codepostal VARCHAR(50),
   Pays VARCHAR(50),
   TelDom VARCHAR(50),
   Extension INT,
   RendCompteA INT
   );   

CREATE TABLE fournisseur(
   NoFour INT,
   Societe VARCHAR(50),
   Contact VARCHAR(50),
   Fonction VARCHAR(50),
   Adresse VARCHAR(50),
   Ville VARCHAR(50),
   Region VARCHAR(50),
   CodePostal VARCHAR(50),
   Pays VARCHAR(50),
   Tel VARCHAR(50),
   Fax VARCHAR(50),
   PageAccueil VARCHAR(200)
);  

CREATE TABLE categorie(
   CodeCateg INT,
   NomCateg VARCHAR(50),
   Descriptionn VARCHAR(200)
);

CREATE TABLE messager(
   NoMess INT,
   NomMess VARCHAR(50),
   Tel VARCHAR(50)
   );

CREATE TABLE commande(
   NoCom INT,
   CodeCli VARCHAR(50) not null,
   NoEmp INT not null,
   DateCom DATETIME,
   AlivAvant DATETIME,
   DateEnv DATETIME,
   NoMess INT not null,
   Portt DECIMAL(15,2),
   Destinataire VARCHAR(50),
   AdrLiv VARCHAR(50),
   VilleLiv VARCHAR(50),
   RegionLiv VARCHAR(50),
   CodePostalLIV VARCHAR(50),
   PaysLiv VARCHAR(50)
);

CREATE TABLE detailsCommande(
   NoCom INT, 
   Refprod INT,
   PrixUnit DECIMAL(15,2),
   Qte INT,
   Remise DECIMAL(15,2)
);

#connection avec les données contenues dans des fichiers csv et enregistrées en local afin de les insérer dans mes tables
#j'ai fait un clic droit sur local instance, selection edit connection, selection advanced, dans others écrire 
#OPT_LOCAL_INFILE=1, puis test connection, redemarrage de mysql enfin

SET GLOBAL local_infile=1;
LOAD DATA LOCAL INFILE 'C:\\Users\\Alain NGABO\\Dropbox\\SIMPLON\\Programmation\\SQL\\Projets\\Projet Foody\\data_foody//categorie.csv' 
INTO TABLE categorie
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'C:/Users/Alain NGABO/Dropbox/SIMPLON/Programmation/SQL/Projets/Projet Foody/data_foody/client.csv' 
INTO TABLE client
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'C:/Users/Alain NGABO/Dropbox/SIMPLON/Programmation/SQL/Projets/Projet Foody/data_foody/produit.csv' 
INTO TABLE produit
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'C:/Users/Alain NGABO/Dropbox/SIMPLON/Programmation/SQL/Projets/Projet Foody/data_foody/employe.csv' 
INTO TABLE employe
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'C:/Users/Alain NGABO/Dropbox/SIMPLON/Programmation/SQL/Projets/Projet Foody/data_foody/fournisseur.csv' 
INTO TABLE fournisseur
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'C:/Users/Alain NGABO/Dropbox/SIMPLON/Programmation/SQL/Projets/Projet Foody/data_foody/messager.csv' 
INTO TABLE messager
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'C:/Users/Alain NGABO/Dropbox/SIMPLON/Programmation/SQL/Projets/Projet Foody/data_foody/commande.csv' 
INTO TABLE commande
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'C:/Users/Alain NGABO/Dropbox/SIMPLON/Programmation/SQL/Projets/Projet Foody/data_foody/detailscommande.csv' 
INTO TABLE detailscommande
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

#insertion des clés primaires et clés étrangères

Alter table client add primary key (Codecli);
Alter table employe add primary key (NoEmp);
Alter table fournisseur add primary key (NoFour);
Alter table categorie add primary key (CodeCateg);
Alter table messager add primary key (NoMess); 
Alter table produit add primary key (Refprod);
Alter table commande add primary key (NoCom);
Alter table detailscommande add primary key (NoCom, Refprod);
Alter table employe add  FOREIGN KEY(RendCompteA) REFERENCES employe(NoEmp); 
Alter table produit add FOREIGN KEY(NoFour) REFERENCES fournisseur(NoFour);
Alter table produit add FOREIGN KEY(CodeCateg) REFERENCES categorie(CodeCateg);
Alter table commande add FOREIGN KEY(NoEmp) REFERENCES employe(NoEmp); 
Alter table commande add FOREIGN KEY(NoMess) REFERENCES messager(NoMess);
Alter table commande add FOREIGN KEY(CodeCli) REFERENCES client(Codecli);
Alter table detailscommande add  FOREIGN KEY(NoCom) REFERENCES commande(NoCom);
Alter table detailscommande add FOREIGN KEY(Refprod) REFERENCES produit(Refprod);



