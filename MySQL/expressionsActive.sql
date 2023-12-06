/* 1) On souhaite obtenir par secteur d’activité la moyenne des charges estimées des projets..*/

SELECT secteur_activite, AVG(charge_estimee_projet) AS MoyenneChargesEstimees
FROM Projet
GROUP BY secteur_activite;

/* 2) On souhaite obtenir la liste des projets (libellé court) sur lesquels un collaborateur est intervenu.
Préciser également sa fonction dans les projets. */

SELECT 
    Projet.libelle_court_projet, 
    Fonction.libelle_fonction
FROM 
    Projet
JOIN 
    Etape ON Projet.code_projet = Etape.code_projet
JOIN 
    Intervention ON Etape.num_lot = Intervention.num_lot
JOIN 
    Collaborateur ON Intervention.matricule = Collaborateur.matricule
JOIN 
    Fonction ON Collaborateur.id_fonction = Fonction.id_fonction
WHERE 
    Collaborateur.matricule = '1337';


SELECT 
    Projet.libelle_court_projet, 
    Fonction.libelle_fonction
FROM 
    Collaborateur
JOIN 
    Intervention ON Collaborateur.matricule = Intervention.matricule
JOIN 
    Etape ON Intervention.num_lot = Etape.num_lot
JOIN 
    Projet ON Etape.code_projet = Projet.code_projet
JOIN 
    Fonction ON Collaborateur.id_fonction = Fonction.id_fonction
WHERE 
    Collaborateur.matricule = '1997';

/* 3) On souhaite obtenir à la date du jour la liste des projets en cours, par secteur d’activité.
Préciser le nombre de collaborateurs associés aux projets et ceci par fonction.*/

/* On souhaite obtenir à la date du jour la liste des projets en cours, par secteur d’activité.
Préciser le nombre de collaborateurs associés aux projets et ceci par fonction */

/* Solution si on recherche tous les projets avec des valeurs nulles pour la fonction ou le décompte du nombre de collaborateurs */
SELECT
    Projet.code_projet,
    Projet.secteur_activite, 
    Projet.libelle_long_projet,
    Fonction.libelle_fonction, 
    COUNT(Collaborateur.matricule) AS NombreCollaborateurs
FROM 
    Projet
LEFT JOIN 
    Etape ON Projet.code_projet = Etape.code_projet
LEFT JOIN 
    Intervention ON Etape.num_lot = Intervention.num_lot
LEFT JOIN 
    Collaborateur ON Intervention.matricule = Collaborateur.matricule
LEFT JOIN 
    Fonction ON Collaborateur.id_fonction = Fonction.id_fonction
WHERE 
    (Projet.date_fin_reelle IS NULL AND Projet.date_debut_reelle <= CURRENT_DATE) OR (Projet.date_fin_reelle >= CURRENT_DATE AND
    Projet.date_debut_reelle <= CURRENT_DATE)
GROUP BY 
    Projet.secteur_activite, Projet.libelle_long_projet, Fonction.libelle_fonction;

/* Le LEFT JOIN va permettre de récupérer les projets associés avec des données manquantes en fonction/collaborateurs, le INNER JOIN
va exclure les projets en cours sans étapes/interventions/collaborateurs/fonctions. 

/* 3.1) Requêtes de mise à jour :
- Augmenter tous les salaires des collaborateurs de :
- 5% si ils ont plus de 5 ans d’ancienneté.*/

/* Requête Update */
UPDATE Contrat
SET salaire = salaire * 1.05
WHERE DATE_ADD(date_debut_contrat, INTERVAL 5 YEAR) < CURRENT_DATE
  AND (date_fin_contrat IS NULL OR date_fin_contrat > CURRENT_DATE);


/* Requête pour trouver les id_contrats qui ont 5 ans d'ancienneté, avec leur salaire le salaire actuel et après augmentation */
SELECT 
    id_contrat,
    contrat.matricule,
    salaire AS salaire_apres_augmentation, 
    salaire / 1.05 AS salaire_actuel
    FROM contrat
WHERE contrat.matricule IN (
        SELECT matricule 
        FROM contrat 
        WHERE date_fin_contrat IS NULL
    )
    GROUP BY contrat.matricule
    HAVING SUM(DATEDIFF(IFNULL(contrat.date_fin_contrat, CURDATE()), contrat.date_debut_contrat)) >= 1825;


/* 3.2) Supprimer de la base de données les projets qui sont terminés et qui n’ont pas eut de charges
(étapes) associées. */
SELECT * FROM Projet
WHERE date_fin_prevue IS NOT NULL 
  AND date_fin_reelle < CURRENT_DATE
  AND code_projet NOT IN (SELECT code_projet FROM Etape);

DELETE FROM Contact WHERE code_projet IN (
    SELECT code_projet FROM Projet
    WHERE date_fin_reelle IS NOT NULL AND 
          date_fin_reelle < CURRENT_DATE AND 
          code_projet NOT IN (SELECT code_projet FROM Etape)
);

DELETE FROM Document WHERE code_projet IN (
    SELECT code_projet FROM Projet
    WHERE date_fin_reelle IS NOT NULL AND 
          date_fin_reelle < CURRENT_DATE AND 
          code_projet NOT IN (SELECT code_projet FROM Etape)
);


DELETE FROM Projet
WHERE date_fin_prevue IS NOT NULL 
  AND date_fin_reelle < CURRENT_DATE
  AND code_projet NOT IN (SELECT code_projet FROM Etape);




/* TRIGGERS
1) Vérifier que la date prévisionnelle de début du projet est inférieure ou égale la date
prévisionnelle de fin du projet.*/
CREATE TRIGGER check_dates
BEFORE INSERT ON Projet
FOR EACH ROW
BEGIN
    IF NEW.date_debut_prevue IS NOT NULL AND NEW.date_fin_prevue IS NOT NULL THEN
        IF NEW.date_debut_prevue > NEW.date_fin_prevue THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La date de début prévisionnelle ne peut pas être postérieure à la date de fin prévisionnelle.';
        END IF;
    END IF;
END


/* 2) Vérifier la cohérence du chiffre d’affaire du client, si supérieur à 1 million d’euros par
personne la valeur du CA est erronée */

CREATE TRIGGER check_ca_before_insert
BEFORE INSERT ON Client
FOR EACH ROW
BEGIN
    IF NEW.chiffre_affaires /NEW.effectifs > 1000000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La valeur du CA par personne est erronée car elle est supérieur à 1 million.';
    END IF;
END

CREATE TRIGGER check_ca_before_update
BEFORE UPDATE ON Client
FOR EACH ROW
BEGIN
    IF NEW.chiffre_affaires /NEW.effectifs > 1000000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La valeur du CA par personne est erronée car elle est supérieur à 1 million.';
    END IF;
END

/* 3)Vérifier la cohérence du code statut,
Passages possibles de :
- S (stagiaire) à D (CDD) ou I (CDI),
- D (CDD) à I (CDI). */



CREATE TRIGGER prevent_invalid_contract_type_change
BEFORE UPDATE ON Contrat
FOR EACH ROW
BEGIN
    -- Empêche de passer de CDI à CDD ou STA
    IF OLD.type = 'CDI' AND NEW.type IN ('CDD', 'STA') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transition invalide : impossible de passer de CDI à CDD ou STA';
    END IF;

    -- Empêche de passer de CDD à STA
    IF OLD.type = 'CDD' AND NEW.type = 'STA' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transition invalide : impossible de passer de CDD à STA';
    END IF;
END






CREATE TRIGGER prevent_project_deletion
BEFORE DELETE ON Projet
FOR EACH ROW
BEGIN
    IF OLD.date_fin_reelle IS NOT NULL AND
       OLD.date_fin_reelle > DATE_SUB(CURDATE(), INTERVAL 2 MONTH) THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Suppression interdite: la fin réelle du projet est inférieure à 2 mois par rapport à la date du jour.';
    END IF;
END





/* Procédures Stockées
Procédure 1 :
 On souhaite obtenir la moyenne des charges estimées sur les projets en cours */


CREATE PROCEDURE AvgChargeEstimeeProjetEnCours()
BEGIN
    SELECT AVG(charge_estimee_projet) AS AvgChargeEstimeeProjetEnCours
    FROM Projet
    WHERE date_debut_reelle IS NOT NULL
      AND date_debut_reelle <= CURDATE()
      AND (date_fin_reelle IS NULL OR date_fin_reelle > CURDATE());
END

CALL AvgChargeEstimeeProjetEnCours();

/* Procédure 2 :
On souhaite obtenir sur un thème technique donné la liste des projets associés et terminés depuis
moins de 2 ans */


CREATE PROCEDURE ProjetsParTheme(THEME VARCHAR(100))
BEGIN
    SELECT *
    FROM Projet
    WHERE infos_techniques_projet LIKE CONCAT('%', THEME, '%')
      AND date_fin_reelle >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
      AND date_fin_reelle <= CURDATE();
END

CALL ProjetsParTheme('pyTHON');

/* Petit problème pour la recherche du langage R qui n'a été entré en BDD que par la lettre R ; en activant la procédure
pour le thème R je retrouve 4 projets contenant la lettre R. Il faudrait jouer avec la concat pour ne trouver que R. */


/* Procédure 3 :
On veut lister les interventions des collaborateurs sur un projet entre deux dates.
La procédure renvoie pour chaque intervention :
- Le nom du collaborateur associé
- La fonction en clair du collaborateur
- Les dates début et fin intervention
- La tâche ou activité associée. */

CREATE PROCEDURE ListeInterventionsParProjet(CodeProjet VARCHAR(10), DateDebut DATE, DateFin DATE)
BEGIN
    SELECT 
        Collaborateur.nom_collaborateur,
        Fonction.libelle_fonction,
        Intervention.date_debut_intervention,
        Intervention.date_fin_intervention,
        Activite.libelle_activite
    FROM 
        Intervention
    INNER JOIN 
        Collaborateur ON Intervention.matricule = Collaborateur.matricule
    INNER JOIN 
        Fonction ON Collaborateur.id_fonction = Fonction.id_fonction
    INNER JOIN 
        Etape ON Intervention.num_lot = Etape.num_lot
    INNER JOIN 
        Activite ON Etape.id_activite = Activite.id_activite
    WHERE 
        Etape.code_projet = CodeProjet
        AND Intervention.date_debut_intervention >= DateDebut
        AND Intervention.date_fin_intervention <= DateFin;
END


CALL ListeInterventionsParProjet('2201', '2023-01-01', '2023-12-31');


UPDATE Projet
SET cycle_vie_projet = CASE
    WHEN date_debut_reelle IS NULL THEN 'études'
    WHEN date_fin_reelle IS NOT NULL AND date_fin_reelle <= CURDATE() THEN 'complet'
    ELSE 'partiel'
END;

