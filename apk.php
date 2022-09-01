<?php
$downloadURL = 'https://raw.githubusercontent.com/Afdhan/CDN/main/WORLDSSH_base.apk';
$size = filesize($downloadURL);
$fileName = 'WORLDSSH.apk';


if (!empty($downloadURL) && file_exists($downloadURL)) {
	header("Pragma:public");
    header("Expired:0");
    header("Cache-Control:must-revalidate");
    header("Content-Control:public");
    header("Content-Type: application/octet-stream;");
    header("Content-Description: File Transfer");
    header("Content-Disposition: attachment;filename=\"".basename($fileName)."\"");
    header("Content-Transfer-Encoding: binary");
    header("Content-Length:".$size);
    flush();
    readfile($downloadURL);
}else{ die('ERROR'); }