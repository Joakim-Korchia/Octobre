<?php

class Vehicule {
    public int $nbPortes ;
    protected string $couleur;
    private int $vitesseMax;
    public int $nbRoues;


    public function __construct($nbPortes, $couleur, $vitesseMax, $nbRoues )
    {
        $this -> nbPortes = $nbPortes;
        $this -> couleur = $couleur;
        $this -> vitesseMax = $vitesseMax;
        $this -> nbRoues = $nbRoues;

        echo('véhicule crée ');
    }

    public function disMoiTout(): void 
    {
        echo $this -> nbRoues;
    }
}

public function getnbPortes(){
return $this -> nbPortes;
}



class tricycle extends Vehicule {
    public string $marqueDerailleur;

    public function __construct($couleur, $vitesseMax,$marqueDerailleur)
{
    parent::__construct(0, $couleur, $vitesseMax, 3);

    $this -> marqueDerailleur = $marqueDerailleur;
}
}


$tricycle = new Vehicule(nbPortes:4,couleur:'bleue', vitesseMax:75, nbRoues:3);
$vraiTricycle = new tricycle('jaune', 80, 'audi');

$tricycle -> disMoiTout();

