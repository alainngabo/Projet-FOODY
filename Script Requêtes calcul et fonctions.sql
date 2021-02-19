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