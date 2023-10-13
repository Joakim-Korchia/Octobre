<?php
//Total en centimes pour éviter les divisions par 0
$centsTotal = (500 * 100) + (200 * 100) + (100 * 0) + (50 * 2 * 100) + (20 * 3 * 100) + (10 * 1 * 100) + (5 * 10 * 100) + (2 * 20 * 100) + (1 * 4 * 100) + (0.5 * 2 * 100) + (0.2 * 20 * 100)
    + (0.1 * 15 * 100) + (0.05 * 23 * 100) + (0.02 * 14 * 100) + (0.01 * 30 * 100);

//floor pour arrondir à l'entier inférieur
$euros = round($centsTotal / 100);
$cents =  ($centsTotal % 100);

echo "Le fonds de caisse initial est de : " . $euros . " € et " . $cents . " centimes.";
?>

<?php
//Dans le cas où le client paie 100.20 € un produit qui coûte 60.18 €
$amountGiven = 100 * 100 + 20; //montant donné par le client converti en centimes
$amountToPay = 60 * 100 + 18; //montant à payer converti en centimes
$moneyReturned = $amountGiven - $amountToPay; //montant à rendre
$moneyAvailable = array(50000, 20000, 10000, 5000, 2000, 1000, 500, 200, 100, 50, 20, 10, 5, 2, 1); //Valeur des billets et pièces du fonds de caisse converti en centimes
$toReturn = array(); //tableau pour stocker les billets et pièces que l'on va rendre

//Calcul avec foreach pour passer en revue chaque ligne du tableau + stockage dans une variable temporaire
foreach ($moneyAvailable as $billValue) {
    while ($moneyReturned >= $billValue) {
        $moneyReturned -= $billValue;
        array_push($toReturn, $billValue);
    }
}

echo "La monnaie rendu sera : ";
foreach ($toReturn as $billValue) {
    echo ($billValue / 100) . " euros ";
}
?>