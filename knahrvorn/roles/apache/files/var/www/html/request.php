<?php
$file = 'request.txt';

$fileHandle = fopen($file, 'w');
if (!$fileHandle) {
    die("Unable to open file.");
}

fwrite($fileHandle, "=== New Request ===\n");

fwrite($fileHandle, "\nHeaders:\n");
$headers = getallheaders();
foreach ($headers as $key => $value) {
    fwrite($fileHandle, "$key: $value\n");
}

fwrite($fileHandle, "\nGET Parameters:\n");
foreach ($_GET as $key => $value) {
    fwrite($fileHandle, "$key: $value\n");
}

fwrite($fileHandle, "\nPOST Parameters:\n");
foreach ($_POST as $key => $value) {
    fwrite($fileHandle, "$key: $value\n");
}

fwrite($fileHandle, "\nBody:\n");
$body = file_get_contents('php://input');
fwrite($fileHandle, $body . "\n");

fwrite($fileHandle, "\n");
fclose($fileHandle);

echo "Request data has been logged.";
