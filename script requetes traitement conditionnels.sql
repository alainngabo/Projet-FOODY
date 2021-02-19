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