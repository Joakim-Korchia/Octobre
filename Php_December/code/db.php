<?php

function getDb(){

    $host = "10.113.28.39";
    $port = "3306";
    $dbName = "afpa";
    $dbUser = "afpa";
    $dbPassword = "afpa2022!";

    try{
        $db = new PDO("mysql:host=$host:$port;dbname=$dbName", $dbUser, $dbPassword);
    }catch (PDOException $e) {
        print ($e->getMessage());
    }

    return $db;
}
?>
