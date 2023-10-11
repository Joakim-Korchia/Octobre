<?php

$recipes = [
[
    'title' => 'Cassoulet',
    'recipe' => 'Etape 1: des flageolets etc fais ta vie',
    'author' => 'mickael.andrieu@exemple.com',
    'is_enabled' => true,
],
[
    'title' => 'Couscous',
    'recipe' => 'Etape 1: de la semoule etc fais ta vie',
    'author' => 'laurene.castor@exemple.com',
    'is_enabled' => false,
],
[
    'title' => 'Escalope Milaise',
    'recipe' => 'Etape 1: prends une belle escalope etc fais ta vie',
    'author' => 'mathieu.nebra@exemple.com',
    'is_enabled' => true,
],
];
?>
<!DOCTYPE html>
<html>
<head>
    <title>Affichage des recettes</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css">  
</head>
<body>
    <div class="container">
        <h1>Affichage des recettes</h1>
        <?php foreach($recipes as $recipe) : ?>
            <?php if (array_key_exists('is_enabled', $recipe) && $recipe['is_enabled'] == true ) : ?>

                <article>
                    <h3> <?php echo $recipe ['title']; ?> </h3>
                    <div><?php echo $recipe ['recipe']; ?> </div>
                    <i><?php echo $recipe ['author']; ?>  </i>
                </article>
            <?php endif ?> 
        <?php endforeach ?>
    </div>
</body>
</html>