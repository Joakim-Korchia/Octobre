<?php
//Création d'une fonction pour mettre le tableau de fonds de caisse à jour après paiement du client
function updateCashFloat ($centsTotal, $detailedGiven) {
    foreach ($detailedGiven as $billValue => $quantity) {
        if (isset($centsTotal[$billValue])) {
            $centsTotal[$billValue] += $quantity;
        } else {
            $centsTotal[$billValue] = $quantity;
        }
    }
    return $centsTotal;
}

$centsTotal = updateCashFloat($centsTotal, $detailedGiven);
echo "Le fonds de caisse après paiement est " .PHP_EOL;
foreach ($centsTotal as $billValue => $quantity);
    echo "$quant"
