/*1. Quels sont les fournisseurs situés dans les départements 75 78 92 77 ?
L’affichage (département, nom fournisseur) sera effectué par département décroissant, puis
par ordre alphabétique. */
SELECT *
	FROM fournisseur
    WHERE POSFOU IN ('69000', '31000', '06000', '67000', '21000')
    ORDER BY POSFOU DESC, CONFOU ASC ;

/*2. Lister les commandes dont le total est supérieur à 100€ ; on exclura dans le calcul du
total les articles commandés en quantité supérieure ou égale à 30.
(Affichage numéro de commande et total) */
SELECT ligne.NUMCOM, SUM(ligne.PRIXUNI * ligne.QTECDE) AS TotalCommande
FROM ligne
WHERE ligne.QTECDE < 30
GROUP BY ligne.NUMCOM
HAVING TotalCommande > 100;

/*4. Coder de 2 manières différentes la requête suivante :
Lister les commandes (Numéro et date) dont le fournisseur est celui de la commande
70210.*/
/* Methode 1 : Sous-requête dans la clause WHERE */
SELECT commande.NUMCOM, commande.DATCOM
FROM commande
WHERE commande.NUMFOU = (SELECT commande.NUMFOU FROM commande WHERE commande.NUMCOM = 1010);

/* Methode 2 : Variable */
SET @FournisseurCommande1010 = (SELECT commande.NUMFOU FROM commande WHERE commande.NUMCOM = 1010)
SELECT commande.NUMCOM, commande.DATCOM
FROM commande
WHERE commande.NUMFOU = @FournisseurCommande1010;

/*6. Editer la liste des fournisseurs susceptibles de livrer les produits dont le stock est inférieur
ou égal à 150 % du stock d'alerte. La liste est triée par produit puis fournisseur. */
SELECT produit.CODART, fournisseur.CONFOU
FROM produit
JOIN vendre ON produit.CODART = vendre.CODART
JOIN fournisseur ON vendre.NUMFOU = fournisseur.NUMFOU
WHERE produit.STKPHY <= 1.5 * produit.STKALE
ORDER BY produit.CODART, fournisseur.CONFOU

/*7. Éditer la liste des fournisseurs susceptibles de livrer les produits dont le stock est inférieur
ou égal à 150 % du stock d'alerte et un délai de livraison d'au plus 30 jours. La liste est triée
par fournisseur puis produit.*/
SELECT fournisseur.CONFOU, produit.CODART
FROM fournisseur
JOIN vendre ON fournisseur.NUMFOU = vendre.NUMFOU
JOIN produit ON vendre.CODART = produit.CODART
WHERE produit.STKPHY <= 1.5 * produit.STKALE
AND vendre.DELLIV <= 30
ORDER BY fournisseur.CONFOU, produit.CODART;

/*8. Avec le même type de sélection que ci-dessus, sortir un total des stocks par fournisseur trié
par total décroissant. */
SELECT fournisseur.CONFOU, SUM(produit.STKPHY) AS totalStock
FROM fournisseur
JOIN vendre ON fournisseur.NUMFOU = vendre.NUMFOU
JOIN produit ON vendre.CODART = produit.CODART
WHERE produit.STKPHY <= 1.5 * produit.STKALE
AND vendre.DELLIV <= 30
GROUP BY fournisseur.CONFOU
ORDER BY SUM(produit.STKPHY) DESC;



/*9. En fin d'année, sortir la liste des produits dont la quantité annuelle prévue est inférieure de
10 % à la quantité réellement commandée.  */
SELECT
	produit.CODART,
    produit.QTEANN,
    SUM(ligne.QTECDE) AS totalCommande
FROM
	produit
JOIN
	ligne ON produit.CODART = ligne.CODART
GROUP BY 
	produit.CODART
HAVING
	SUM(ligne.QTECDE) > 1.1 * produit.QTEANN


/*10. Existe-t-il des lignes de commande non cohérentes avec les produits vendus par les
fournisseurs ? */
SELECT ligne.CODART, ligne.NUMCOM,
	commande.NUMFOU AS commandeFournisseur,
    vendre.NUMFOU AS venduParFournisseur
FROM ligne
JOIN commande ON ligne.NUMCOM = commande.NUMCOM /* cette jointure lie les lignes de commande aux commandes pour obtenir le fournisseur associé à chaque commande */
LEFT JOIN vendre ON ligne.CODART = vendre.CODART AND commande.NUMFOU = vendre.NUMFOU
/* ceci vérifie si le produit commandé (CODART) est vendu par le fournisseur de la commande (NUMFOU). Le Left garantit que toutes les lignes 
sont incluses même si le produit n'est pas trouvé dans vendre. */
WHERE vendre.CODART IS NULL OR vendre.NUMFOU IS NULL;
/* cette condition sélectionne les lignes où il n'y a pas de correspondance dans vendre, indiquant une incohérence.
Tout cette requête retournera les lignes de la table ligne pour lesquelles il n'y a pas de correspondance dans la table vendre, ce qui signifie
que le produit commandé n'est pas vendu par le fournisseur indiqué dans la commande. */


/*11. Lister les chiffres d’affaires par fournisseur en ordre décroissant
(CA Fournisseur = somme des quantités d’articles en commande * prix unitaires des articles
présents dans les tables des commandes passées aux fournissseurs). */
SELECT fournisseur.NUMFOU, fournisseur.CONFOU,
SUM(ligne.QTECDE * ligne.PRIXUNI) AS chiffreAffaire
FROM fournisseur
JOIN commande ON fournisseur.NUMFOU = commande.NUMFOU
JOIN ligne ON commande.NUMCOM = ligne.NUMCOM
GROUP BY fournisseur.NUMFOU, fournisseur.CONFOU
ORDER BY chiffreAffaire DESC;

/*12. Et maintenant quel est le plus grand chiffre d’affaires par fournisseur ?*/

SELECT fournisseur.NUMFOU, fournisseur.CONFOU,
SUM(ligne.QTECDE * ligne.PRIXUNI) AS chiffreAffaire
FROM fournisseur
JOIN commande ON fournisseur.NUMFOU = commande.NUMFOU
JOIN ligne ON commande.NUMCOM = ligne.NUMCOM
GROUP BY fournisseur.NUMFOU, fournisseur.CONFOU
ORDER BY chiffreAffaire DESC
LIMIT 1; /* rajout juste de la limite pour n'afficher qu'un seul résultat */

/* 13. Mettre à jour le champ obscom en positionnant '*****' pour toutes les commandes dont le
fournisseur a un indice de satisfaction <5 */
UPDATE commande
JOIN fournisseur ON commande.NUMFOU = fournisseur.NUMFOU
SET commande.OBSCOM = '*****'
WHERE fournisseur.SATISD < 80;

/* Pour pouvoir randomiser une table avec des notes aléatoires à cause de la question 13 */
UPDATE commande 
SET OBSCOM = floor(rand()*10)+1;


/* la fonction : */
CREATE DEFINER=root@localhost FUNCTION initial_prestataire(nom VARCHAR(50), prenom VARCHAR(50)) RETURNS varchar(2) CHARSET utf8mb4
BEGIN

SET @initiale = LEFT(nom, 1);
SET @initiale_deux = LEFT(prenom, 1);
SET @initiale_trois = CONCAT(@initiale, @initiale_deux);
    return @initiale_trois;
END


/* la procédure : */
CREATE DEFINER=root@localhost PROCEDURE maj_initial_prestataire()
UPDATE prestataire
SET prestataire.prestataire_initiale = initial_prestataire(prestataire.prestataire_nom, prestataire.prestataire_prenom)
WHERE prestataire.prestataire_initiale IS NULL


/* le TRIGGER : */
CREATE TRIGGER update_prestataire AFTER UPDATE ON prestataire
 FOR EACH ROW INSERT INTO prestas_logs (entry, prestas_logs_date, prestas_logs_user) VALUES ("nouvelle modification de la table prestation", NOW(),USER())