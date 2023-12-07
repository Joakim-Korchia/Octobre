<?php
require ("./db.php");

$db = getDb();

function queryAllCollaborateurs(){
    global $db;
    $request = $db -> query("SELECT * FROM Collaborateur");
    $result = $request -> fetchAll(PDO::FETCH_ASSOC);
    return $result;
};
?>
