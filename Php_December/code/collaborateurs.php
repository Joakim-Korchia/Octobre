<?php
require('./collaborateurTools.php');


$collaborateurArray = queryAllCollaborateurs();
?>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="app.css" type="text/css">
    <title>Document</title>
</head>
<body>
    <table>
        <thead>
            <tr>
                <td>nom_collaborateur</td>
                <td>prenom_collaborateur</td>
                <td>sexe_collaborateur</td>
                <td>etat_civil_collaborateur</td>
            </tr>
        </thead>
        <tbody>
            <?php
                foreach($collaborateurArray as $collaborateurDetails){
                    print("<tr>");
                    foreach($collaborateurDetails as $key => $value){
                        print("<td>$value</td>");
                    }
                    print("</tr>");
                }
            ?>
        </tbody>

    </table>
   

</body>
</html>