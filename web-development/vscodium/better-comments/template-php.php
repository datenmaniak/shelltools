<?php
// === PHP ===

//  TODO conectar con base de datos usando PDO
try {
    $db = new PDO("mysql:host=localhost;dbname=test", "root", "");
    // LEARN: estudiar manejo de excepciones en PHP
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}

// REMOVE: conexión antigua con mysqli
