<?php

class Animaux {
    private int $nbPattes;
    private string $couleur;
    protected int $poids;
    private string $pelage;

    public function __construct(int $nbPattes, string $couleur, int $poids, string $pelage)
    {
        $this->nbPattes = $nbPattes;
        $this->couleur = $couleur;
        $this->poids = $poids;
        $this->pelage = $pelage;

        echo 'Animal créé : ';
    }

    /**
     * @return int
     */
    public function getNbPattes(): int
    {
        return $this->nbPattes;
    }

    /**
     * @param int $nbPattes
     */
    public function setNbPattes(int $nbPattes): void
    {
        $this->nbPattes = $nbPattes;
    }

    /**
     * @return string
     */
    public function getCouleur(): string
    {
        return $this->couleur;
    }

    /**
     * @param string $couleur
     */
    public function setCouleur(string $couleur): void
    {
        $this->couleur = $couleur;
    }

    /**
     * @return int Poids de l'animal en kg
     */
    public function getPoids(): int
    {
        return $this->poids;
    }

    /**
     * @param int $poids Poids de l'animal en kg
     */
    public function setPoids(int $poids): void
    {
        $poidsMin = 1;
        $poidsMax = 150000;

        if ($poids >= $poidsMin && $poids <= $poidsMax){
            $this->poids=$poids;
        } else {
            echo "Le poids n'est pas valide Michel, il doit être entre $poidsMin et $poidsMax kg.\n";
        }
    }

    /**
     * @return string
     */
    public function getPelage(): string
    {
        return $this->pelage;
    }

    /**
     * @param string $pelage
     */
    public function setPelage(string $pelage): void
    {
        $this->pelage = $pelage;
    }

    public function disMoiTout(): void
    {
        echo "Nombre de pattes: " . $this->nbPattes . ", Couleur: " . $this->couleur . ", Poids: " . $this->poids . ", Pelage: " . $this->pelage;
    }
}

class Chien extends Animaux {
    public string $race;

    public function __construct(string $couleur, int $poids, string $pelage, string $race)
    {
        parent::__construct(4, $couleur, 0, $pelage); // Les chiens ont 4 pattes par défaut

        $this->race = $race;

        $this->setPoids($poids);

        echo "Chien de race " .$this->race . " crée\n";
    }

    /**
     * @param int $poids Poids du chien en kg.
     */
    public function setPoids(int $poids): void
    {
        $poidsMin = 1; // poids minimum pour un chien en kg
        $poidsMax = 100; // poids maximum pour un chien en kg

        if ($poids >= $poidsMin && $poids <= $poidsMax) {
            $this->poids = $poids;
        } else {
            echo "Ton chien est soit un microbe, soit un éléphant, réfléchis Michel...Il doit être entre $poidsMin et $poidsMax kg.\n";
        }
    }

    public function disMoiTout(): void
    {
        parent::disMoiTout();
        echo ", Race: " . $this->race;
    }
}

$chien = new Chien('noir', 10, 'ras', 'Doberman');

$chien->disMoiTout();
