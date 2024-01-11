<?php

class Animaux {
    private int $nbPattes ;
    private string $couleur;
    private int $poids;
    private string $pelage;


    public function __construct($nbPattes, $couleur, $poids, $pelage )
    {
        $this -> nbPattes = $nbPattes;
        $this -> couleur = $couleur;
        $this -> poids = $poids;
        $this -> pelage = $pelage;

        echo('animal crée ');
    }

    public function disMoiTout(): void
    {
        echo $this -> $race;
    }
}

class chien extends Animaux {
    public string $race;
    public function __construct($couleur, $poids,$pelage, $race)
    {
        parent::__construct(4, $couleur, $poids, $pelage);

        $this -> race = $race;
    }
}

$chien = new chien('noir', 35, 'ras', 'doberman');

$chien -> disMoiTout();