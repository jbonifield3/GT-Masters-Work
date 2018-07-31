<?php session_start(); 
//check to make sure the user has logged in 
if(!isset($_SESSION['SESSION']) or !isset($_SESSION['userID'])) {
    header('Location: login.php');
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <!-- Favicons -->
    <link rel="apple-touch-icon" href="assets/img/apple-icon.png">
    <link rel="icon" href=".assets/img/favicon.png">
    <title>
        <?php echo $title ?>
    </title>
    <!--     Fonts and icons     -->
    <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:400,700|Material+Icons" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css" />
    <link rel="stylesheet" href="assets/css/material-dashboard.css?v=2.0.0">
<!-- 	<link rel="stylesheet" href="assets/css/tagsinput.css">-->
    <link rel="stylesheet" type="text/css" href="assets/css/inputvalidation.css" />
	<link rel="stylesheet" href="tags.css">
</head>

<body class="">
    <div class="wrapper">