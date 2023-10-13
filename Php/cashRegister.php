<?php
$cashFloatFile = 'cashFloat.txt';

$billet500 = 2 * 500;
$billet200 = 1 * 200;
$billet100 = 0 * 100;
$billet50 = 2 * 50;
$billet20 = 3 * 20;
$billet10 = 1 * 10;
$billet5 = 10 * 5;
$piece2 = 20 * 2;
$piece1 = 4 * 1;
$piece50cts = 2 * 0.5;
$piece20cts = 20 * 0.2;
$piece10cts = 15 * 0.1;
$piece5cts = 23 * 0.05;
$piece2cts = 14 * 0.02;
$piece1cts = 30 * 0.01;

$cashFloatTotal = $billet500 + $billet200 + $billet100 +
    $billet50 + $billet20 + $billet10 + $billet5 + $piece2 +
    $piece1 + $piece50cts + $piece20cts + $piece10cts + $piece5cts + $piece2cts + $piece1cts;

file_put_contents($cashFloatFile, $cashFloatTotal);

echo "Le montant de mon fonds de caisse est de " . $cashFloatTotal . " €";
?>

<?php
//la fonction pour rendre la monnaie
function moneyReturned($amountGiven, $cashFloatTotal)
{

    $cashAvailable = array(500, 200, 100, 50, 20, 10, 5, 2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01);
    $amountIsReturned = $amountGiven - $cashFloatTotal;

    $moneyIsReturned = array ();

    if ($amountIsReturned > 0) {
        foreach ($cashAvailable as $billValue) {
            $quotient = floor($amountIsReturned / $billValue);
            if ($quotient > 0) {
                $quotientAvailable = floor($cashFloatTotal / $billValue);
                $quotientIsReturned = min($quotient, $quotientAvailable);

                $amountIsReturned -= $quotientIsReturned * $billValue;
                $cashFloatTotal -= $quotientIsReturned * $billValue;

                if ($quotientIsReturned > 0) {
                    $moneyIsReturned[$billValue] = $quotientIsReturned;
                }
            }
        }
    }
    if ($amountIsReturned > 0) {
        return "Je ne peux pas rendre la monnaie exacte, il manque :" . $moneyIsReturned . " €.";
    }
    return $moneyIsReturned;
}
$amountGiven = 222;
$moneyIsReturned = moneyReturned($amountGiven, $cashFloatTotal);

if (is_array($moneyIsReturned)) {
    echo "Le montant du paiement est de ". $amountGiven . "€";
    echo "Le fonds de caisse disponible est de ". $cashFloatTotal . "€";
    echo "La monnaie à rendre sera :";
    foreach ($moneyIsReturned as $billValue => $quotient) {
        echo "$quotient x $billValue " . $quotient * $billValue . "€";
    }

}
else {
    echo $moneyIsReturned;
}


?>