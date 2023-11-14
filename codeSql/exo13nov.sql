/* Cas test entreprise et prestaires name prestataire2 
Pour calculer le montant des 5 plus grosses prestations effectuées */
SELECT SUM(MONTANT_PRESTATION) FROM (
    SELECT MONTANT_PRESTATION FROM prestation
    ORDER BY MONTANT_PRESTATION DESC
    LIMIT 5
    )
    AS top5
 
/* Pour calculer le nombre total de prestataires  */
SELECT COUNT(ID_PRESTATAIRE) FROM prestataire

/* Idem pour le nombre total d'entreprises */

/*connaître le total de prestations effectuées pour chaque prestataire */
SELECT ID_PRESTATAIRE, COUNT(*) AS nombrePrestation, SUM(MONTANT_PRESTATION) as MontantTotal
FROM prestation
GROUP BY ID_PRESTATAIRE;

/* connaître le total de prestations effectuées pour chaque entreprise */
SELECT ID_ENTREPRISE, COUNT(*) AS nombrePrestation
FROM entreprise
GROUP BY ID_ENTREPRISE;

/* connaître les 5 entreprises qui ont demandé le plus de prestations */
SELECT ID_ENTREPRISE, COUNT(*)AS nombrePrestations
FROM prestation
GROUP BY ID_ENTREPRISE
ORDER BY nombrePrestations DESC
LIMIT 5;

/* connaître les 5 prestataires qui ont effectué le plus de prestations */
SELECT ID_PRESTATAIRE, COUNT(*)AS nombrePrestations
FROM prestation
GROUP BY ID_PRESTATAIRE
ORDER BY nombrePrestations DESC
LIMIT 5;

/* connaître les 5 prestataires qui ont les plus gros "gains" de prestation */
SELECT ID_PRESTATAIRE, SUM(MONTANT_PRESTATION) AS gainTotal
FROM prestation
GROUP BY ID_PRESTATAIRE
ORDER BY gainTotal DESC
LIMIT 5;  


/* connaître les 5 prestataires qui ont effectué le plus de prestations */
SELECT ID_PRESTATAIRE, COUNT(*)AS nombrePrestations
FROM prestation
GROUP BY ID_PRESTATAIRE
ORDER BY nombrePrestations DESC
LIMIT 5;
