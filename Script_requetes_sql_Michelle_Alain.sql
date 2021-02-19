
#I - REQUETAGE SIMPLE

#1.Afficher les 10 premiers éléments de la table Produit triés par leur prix unitaire

SELECT * FROM foody.produit order by PrixUnit limit 10;

#2.Afficher les trois produits les plus chers
SELECT * FROM foody.produit order by PrixUnit desc limit 3;

#I-2 RESTRICTION 

#1.Lister les clients français installés à Paris dont le numéro de fax n'est pas renseigné

select * from foody.client where Fax is null and Ville like '%Paris%';

#2.Lister les clients français, allemands et canadiens

select * from foody.client where Pays in ('France', 'Germany', 'Canada');
#deuxième solution 
SELECT * FROM foody.client where pays = 'France' OR pays = 'Germany' or pays = 'Canada';

#3.Lister les clients dont le nom de société contient "restaurant"
select * from foody.client where Societe like '%Restaurant%';

#I-3 PROJECTION

#1.Lister les descriptions des catégories de produits (table Categorie)
select Descriptionn from foody.categorie;

#2.Lister les différents pays et villes des clients, 
#le tout trié par ordre alphabétique croissant du pays et décroissant de la ville
select Pays, Ville from foody.client order by (Pays) asc , (Ville) desc; 

#3 Lister tous les produits vendus en bouteilles (bottle) ou en canettes(can)
select * from foody.produit where QteParUnit like '%bottle%' or QteParUnit like '%can%';

#4.Lister les fournisseurs français, en affichant uniquement le nom, le contact et la ville, triés par ville

select Societe, Contact, Ville from foody.fournisseur where Pays='France' order by Ville asc;

#5 Lister les produits (nom en majuscule et référence) du fournisseur n° 8 dont le prix unitaire 
#est entre 10 et 100 euros, en renommant les attributs pour que ça soit explicite

select  NoFour as "Numero du fournisseur", (upper(NomProd)) as "Produit", Refprod as " Reference du produit", PrixUnit as "prix unitaire"
 from foody.produit where NoFour = 8 and PrixUnit between 10 and 100;
 
#6.Lister les numéros d'employés ayant réalisé une commande (cf table Commande)
 #à livrer en France, à Lille, Lyon ou Nantes
select  distinct NoEmp as "numéro d'employé", VilleLiv, PaysLiv from foody.commande where PaysLiv = 'France' 
and VilleLiv in ("Lille", "Lyon", "Nantes") order by NoEmp;

#pour afficher juste les numéros d'employés sans la mise en forme ci-dessus 
select  distinct NoEmp as "numéro d'employé" from foody.commande where PaysLiv = 'France' 
and VilleLiv in ("Lille", "Lyon", "Nantes") order by NoEmp;

#7.Lister les produits dont le nom contient le terme "tofu" ou le terme "choco", dont le prix est inférieur
# à 100 euros (attention à la condition à écrire)

select Refprod, NomProd, PrixUnit from foody.produit where PrixUnit<100 and NomProd like '%tofu%' or NomProd like '%choco%';

#II CALCULS ET FONCTIONS

#La table DetailsCommande contient l'ensemble des lignes d'achat de chaque commande. 
#Calculer, pour la commande numéro 10251, pour chaque produit acheté dans celle-ci, 
#le montant de la ligne d'achat en incluant la remise (stockée en proportion dans la table).
# Afficher donc (dans une même requête) : le prix unitaire, la remise, la quantité, le montant de la remise,
#le montant à payer pour ce produit

select distinct NoCom as "numéro de commande", 
Refprod as "Référence produit", 
Qte as "Quantité",
PrixUnit as "Prix unitaire", 
Remise as "Remise en %", 
round((PrixUnit * Remise),2) as "Montant de la remise",
round(PrixUnit - (PrixUnit * Remise),2) as "Montant après remise",
Qte * round(PrixUnit - (PrixUnit * Remise),2) as "Montant à payer"
from detailscommande where NoCom=10251;


#II-2 TRAITEMENT CONDITIONNEL

#Q1 A partir de la table Produit, afficher "Produit non disponible" 
#lorsque l'attribut Indisponible vaut 1, et "Produit disponible" sinon.
SELECT * FROM foody.produit;
SELECT NomProd, UnitesStock, UnitesCom, NiveauReap, Indisponible,
	CASE Indisponible
		WHEN  1 THEN "Produit non disponible"
		ELSE "Produit disponible"
	END AS Informations
FROM foody.produit;
#

#Q2 À partir de la table DetailsCommande, indiquer les infos suivantes en fonction de la remise
#si elle vaut 0 : "aucune remise"
#si elle vaut entre 1 et 5% (inclus) : "petite remise"
#si elle vaut entre 6 et 15% (inclus) : "remise modérée"
#sinon :"remise importante"

SELECT Refprod, PrixUnit, Qte, Remise,
	CASE 
		WHEN (Remise = 0) THEN "Aucune remise"
		WHEN (Remise <= 0.05) THEN "Petite Remise"
		WHEN (Remise <= 0.15) THEN "Remise modérée"
		ELSE "Remise importante"
END AS Informations
FROM foody.detailscommande;

#Q3
#Indiquer pour les commandes envoyées si elles ont été envoyées en retard 
#(date d'envoi DateEnv supérieure (ou égale) à la date butoir ALivAvant) ou à temps
#REMARQUE : j'ai mis non livré car il y a des nuls dans DateEnv

SELECT NoCom , DateCom, AlivAvant, DateEnv,
	CASE 
		WHEN (DateEnv >= AlivAvant) THEN " En retard"
        WHEN (DateEnv < AlivAvant) THEN " Dans les temps"
		ELSE " Non livré"
END AS Statutlivraison
FROM foody.commande;

#II-3 FONCTION SUR LES CHAINES DE CARACTERE

#Dans une même requête, sur la table Client : Concaténer les champs Adresse, Ville, CodePostal et Pays 
#dans un nouveau champ nommé Adresse_complète, pour avoir : Adresse, CodePostal, Ville, Pays
#Extraire les deux derniers caractères des codes clients
#Mettre en minuscule le nom des sociétés
#Remplacer le terme "Owner" par "Freelance" dans Fonction
#Indiquer la présence du terme "Manager" dans Fonction


select 
concat(Adresse,"  , ",Codepostal,"   ,",Ville,"   ,",Pays) as Adresse_complète, 
substr(Codecli, 3, 2) as CodeCli_2dernierscaract, 
lower(Societe) as nom_société, 
replace(Fonction, 'Owner', 'Freelance'), 
	case
		When Fonction like '%Manager%' then 'Oui'
        Else 'Non'
END AS Manager
from foody.client ;



#FONCTION SUR LES DATES 

#1 1.Afficher le jour de la semaine en lettre pour toutes les dates de commande, 
#afficher "week-end" pour les samedi et dimanche,

select DateCom, 
	case
		when dayname(DateCom) in ('Saturday','Sunday') then 'week-end'
        else dayname(DateCom)
end as jour_de_commande
 from foody.commande; 

#2 Calculer le nombre de jours entre la date de la commande (DateCom) et la date butoir de livraison (ALivAvant), 
#pour chaque commande, On souhaite aussi contacter les clients 1 mois après leur commande. 
#ajouter la date correspondante pour chaque commande

SELECT DateCom, AlivAvant, DATEDIFF( AlivAvant, DateCom), date_add(DateCom, interval 30 DAY) as "date de contact",
	case 
    when DATEDIFF( AlivAvant, DateCom) = 30 then "Client à contacter"
    when DATEDIFF( AlivAvant, DateCom) > 30 then "vérifier si client à été contacté"
    else "Pas de contact"
end as notification_contact_client
from foody.commande;  

#Bonus
#1.Récupérer l'année de naissance et l'année d'embauche des employés
select Nom, Prenom, DateNaissance, DateEmbauche from foody.employe;

#2.Calculer à l'aide de la requête précédente l'âge d'embauche et le nombre d'années dans l'entreprise
select Nom, Prenom, DateNaissance, DateEmbauche,
YEAR(DateEmbauche) - YEAR(DateNaissance) as "âge d'embauche",
YEAR(CURRENT_TIMESTAMP()) - YEAR(DateEmbauche) as "nombre d'années dans l'entreprise à ce jour" 
from foody.employe;

#3 Afficher le prix unitaire original, la remise en pourcentage, le montant de la remise et 
#le prix unitaire avec remise (tous deux arrondis aux centimes), pour les lignes de commande 
#dont la remise est strictement supérieure à 10%

select distinct PrixUnit as "Prix unitaire original", Remise as "Remise en %", 
round((PrixUnit * Remise),2) as "Montant de la remise",
round(PrixUnit - (PrixUnit * Remise),2) as "Prix unitaire après remise"
from detailscommande where Remise > 0.10;

#4 Calculer le délai d'envoi (en jours) pour les commandes dont l'envoi est après la date butoir, 
#ainsi que le nombre de jours de retard
select  NoCom, DateCom, AlivAvant, DateEnv,
datediff(DateEnv,DateCom) as "delai d'envoi", 
DATEDIFF( DateEnv,AlivAvant) as "Nombre de jours de retard" 
from commande
where DATEDIFF( DateEnv,AlivAvant) > 0;

#5.Rechercher les sociétés clientes, dont le nom de la société contient le nom du contact de celle-ci
#Non fait

#III- Aggrégats

#1 Calculer le nombre d'employés qui sont "Sales Manager"
select count(*) from employe where Fonction ='Sales Manager';

#2 Calculer le nombre de produits de moins de 50 euros

select count(*) from produit where PrixUnit < 50;

#3 Calculer le nombre de produits de catégorie 2 et avec plus de 10 unités en stocks

select count(distinct Nomprod) from foody.produit where (codecateg = 2 and UnitesStock >10);

#4 Calculer le nombre de produits de catégorie 1, des fournisseurs 1 et 18
select count(distinct Nomprod) from foody.produit where (codecateg = 1 and Nofour IN (1,18));

#5.Calculer le nombre de pays différents de livraison
select count(distinct paysLiv) from foody.commande ;

#6.Calculer le nombre de commandes réalisées le en Aout

select count(distinct NoCom) from foody.commande where DateCom BETWEEN '2006-08-01 00:00:00' AND '2006-08-31 00:00:00';

#III.2- Calculs statistiques simples
#1.Calculer le coût du port minimum et maximum des commandes , ainsi que le coût moyen 
#du port pour les commandes du client dont le code est "QUICK" (attribut CodeCli)

select min(Portt), Max(Portt), round(avg(Portt),2)
from commande where CodeCli="QUICK";

# Pour chaque messager (par leur numéro : 1, 2 et 3),
# donner le montant total des frais de port leur correspondant

SELECT NoMess, sum(NoMess) FROM commande where NoMess in (1,2,3) group by NoMess;

#III.3- Agrégats selon attribut(s)

#1  Donner le nombre d'employés par fonction

SELECT Fonction, COUNT(*) AS "Nb d'employés"
FROM employe
GROUP BY Fonction;

#2.Donner le montant moyen du port par messager(shipper)
SELECT NoMess, round(Avg(Portt),2) as "montant moyen par messager"
FROM commande
GROUP By NoMess;

#3 Donner le nombre de catégories de produits fournis par chaque fournisseur
SELECT  NoFour, CodeCateg, COUNT(*) as "nombre de catégories produits"
FROM produit
GROUP By NoFour, CodeCateg;

#4 Donner le prix moyen des produits pour chaque fournisseur et 
#chaque catégorie de produits fournis par celui-ci
SELECT  NoFour, CodeCateg, COUNT(*) as "nombre de catégories produits",
round(avg(PrixUnit)) as "prix moyen de produits"
FROM produit
GROUP By NoFour, CodeCateg;

#III.4 . 1- Placement des différentes clauses 
#1 Lister les fournisseurs ne fournissant qu'un seul produit

select NoFour, count(NomProd) as np
from produit
group by NoFour
having np = 1;

#2 Lister les catégories dont les prix sont en moyenne supérieurs strictement à 50 euros
select CodeCateg, round(avg(PrixUnit)) as "prix moyen des produits"
from produit
group by CodeCateg
having round(avg(PrixUnit))> 50;

#3 Lister les fournisseurs ne fournissant qu'une seule catégorie de produits
select NoFour as "numéro fournisseur", 
count(distinct CodeCateg) as "nombre de catégories de produits"
from produit
group by NoFour
having count( distinct CodeCateg)= 1;


#4 Lister le Products le plus cher pour chaque fournisseur, pour les Products de plus de 50 euro
select NoFour as "numéro fournisseur", 
NomProd as "produit le plus cher",
Max(distinct PrixUnit) as prix
from produit
group by NoFour
having prix > 50;

#IV- Jointures 

#1.Récupérer les informations des fournisseurs pour chaque produit
SELECT * FROM produit NATURAL JOIN fournisseur;

#2 Afficher les informations des commandes du client "Lazy K Kountry Store"
SELECT * FROM client NATURAL JOIN commande where Societe = 'Lazy K Kountry Store';


#3 Afficher le nombre de commande pour chaque messager (en indiquant son nom)
 
SELECT NomMess as "Messager", COUNT(NoMess) AS "Nb commande"
FROM commande NATURAL JOIN messager
GROUP BY NoMess;

#IV - 2 Jointures internes

#1 Récupérer les informations des fournisseurs pour chaque produit, avec une jointure interne
SELECT *
FROM produit P INNER JOIN fournisseur f
ON P.NoFour = f.NoFour;

#2 Afficher les informations des commandes du client "Lazy K Kountry Store" avec une jointure interne
SELECT * FROM client cl 
inner JOIN commande cd 
on cl.Codecli = cd.CodeCli
where Societe = 'Lazy K Kountry Store';

#3 Afficher le nombre de commande pour chaque messager (en indiquant son nom) avec une jointure interne
SELECT NomMess as "Messager", COUNT(NoCom) AS "Nb commande"
FROM commande c inner JOIN messager m
on c.NoMess = m.NoMess
group by NomMess;
;

#IV.3- Jointures externes
#1.Compter pour chaque produit, le nombre de commandes où il apparaît, même pour ceux dans aucune commande
SELECT produit.Refprod, COUNT(detailscommande.NoCom) AS NbCmd FROM produit
	LEFT OUTER JOIN detailscommande ON  produit.Refprod=detailscommande.RefProd
    GROUP BY detailscommande.RefProd;
    
#2.Lister les produits n'apparaissant dans aucune commande
SELECT produit.Refprod, produit.Nomprod, COUNT(detailscommande.NoCom) AS NbCmd FROM produit
	LEFT OUTER JOIN detailscommande ON  produit.Refprod=detailscommande.RefProd
    GROUP BY detailscommande.RefProd
    HAVING NbCmd=0;
#3.Existe-t'il un employé n'ayant enregistré aucune commande ?
SELECT employe.NoEmp, COUNT(commande.NoCom) AS NbCmd FROM employe
	LEFT OUTER JOIN commande ON employe.NoEmp=commande.NoEmp
    GROUP BY commande.NoEmp 
    HAVING NbCmd=0;

# Jointures à la main 

#1.Récupérer les informations des fournisseurs pour chaque produit, avec jointure à la main
SELECT p.Refprod, f.* FROM fournisseur f, produit p
	WHERE f.NoFour=p.NoFour;
    
#2.Afficher les informations des commandes du client "Lazy K Kountry Store", avec jointure à la main
SELECT  co.* FROM commande co, client cl
	WHERE co.CodeCli=cl.Codecli 
    AND cl.Societe='Lazy K Kountry Store';
    
#3.Afficher le nombre de commande pour chaque messager (en indiquant son nom), avec jointure à la main
SELECT  m.NomMess, COUNT(c.NoCom) AS NbCmd FROM commande c, messager m
	WHERE m.NoMess=c.NoMess
    GROUP BY c.NoMess;
    
#V.2- Opérateur EXISTS

#V.1.4- Comparaison dans une sous-requête

#1 Lister les employés n'ayant jamais effectué une commande, via une sous-requête

select NoEmp, Nom, Prenom from employe
where NoEmp not in (select NoEmp From commande);

#2.Nombre de produits proposés par la société fournisseur "Ma Maison", via une sous-requête
select * from produit 
where NoFour = (select NoFour from fournisseur where Societe = "Ma Maison");

#3 Nombre de commandes passées par des employés sous la responsabilité de "Buchanan Steven"
SELECT Count(Nocom) AS "Commandes Passées" FROM commande
WHERE NoEmp IN (SELECT NoEmp FROM employe
WHERE RendCompteA = (SELECT NoEmp FROM employe
WHERE Nom = "Buchanan" AND Prenom = "Steven"));

#Exist
#VI- Opérations Ensemblistes

#1.1.Lister les employés (nom et prénom) étant "Representative" ou étant basé au Royaume-Uni (UK)
select Nom, Prenom, Fonction, Pays from employe where fonction like "%Representative%" 
union 
select Nom, Prenom, Fonction, Pays from employe where Pays = "UK" order by 1;

#2.2.Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel) 
#ou ayant été livré par "Speedy Express"

Select distinct(cl.Codecli), cl.Societe, cl.pays, e.Ville as AVerifie from foody.client as cl join foody.commande as co using(Codecli)
join foody.employe as e using(NoEmp) where e.Ville='London' union
Select distinct(cl.Codecli), cl.Societe, cl.pays, m.NomMess as AVerifie from foody.client as cl join foody.commande as co using(Codecli)
join foody.messager as m using(NoMess) where m.NomMess='Speedy Express'
order by 1;
Select * FROM foody.client as cl join foody.commande as co using(Codecli)
join foody.employe as e using(NoEmp) where e.Ville='London' ;

#VI.2- Intersection
#2 Lister les clients (société et pays) ayant commandés 
#via un employé basé à "Seattle" et ayant commandé des "Desserts"

Select distinct(cl.Codecli), cl.Societe, cl.pays, e.Ville as AVerifie from foody.client as cl join foody.commande as co using(Codecli)
join foody.employe as e using(NoEmp) where e.Ville='Seattle' and cl.Codecli in
(Select distinct(cl.Codecli) as AVerifie from foody.client as cl join foody.commande as co using(Codecli)
join foody.detailscommande as dc using(NoCom) join foody.produit as p using (RefProd) join foody.categorie as ca using (CodeCateg) where ca.NomCateg='Desserts')
order by 1;

####autre code de Manel
select client.societe, client.pays , categorie.CodeCateg, employe.Ville 
 from client
 inner join commande on client.codecli = commande.codeCli
 inner join employe on commande.NoEmp = employe.NoEmp 
 inner join detailscommande on commande.NoCom = detailscommande.NoCom
 inner join produit on detailscommande.RefProd = produit.RefProd 
 inner join categorie on produit.CodeCateg = categorie.CodeCateg 
 where employe.Ville = "Seattle"  and categorie.CodeCateg = 3 
group by client.societe, client.pays;
#####"
#DIFFERENCE 
#11.Lister les employés (nom et prénom) étant "Representative" mais n'étant pas basé au Royaume-Uni (UK)

select Nom, Prenom, Pays from employe a
where Fonction like '%Representative%'and
not exists
(select Nom, Prenom, Pays from employe b where Pays= 'UK'and a.NoEmp=b.NoEmp );

#Lister les clients (société et pays) ayant commandés via un employé situé à Londres ("London" pour rappel)
 #et n'ayant jamais été livré par "United Package"

select Societe, Pays
from client c where  
Codecli in (select CodeCli from commande cd where NoEmp in (select NoEmp from employe where Ville = 'London') 
and NoMess not in (select NoMess from messager where NomMess="United Package"));




