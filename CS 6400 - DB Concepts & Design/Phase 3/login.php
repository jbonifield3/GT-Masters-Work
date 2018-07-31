<?php
//WRITTEN BY CS6400 SAMPLE USER
//MODIFIED BY DCARVALLO3
include('lib/common.php');

if($showQueries){
  array_push($query_msg, "showQueries currently turned ON, to disable change to 'false' in lib/common.php");
}

if( $_SERVER['REQUEST_METHOD'] == 'POST') {

	$enteredUsername = mysqli_real_escape_string($db, $_POST['username']);
	$enteredPassword = mysqli_real_escape_string($db, $_POST['password']);

    if (empty($enteredUsername)) {
            array_push($error_msg,  "Please enter a username.");
    }

	if (empty($enteredPassword)) {
			array_push($error_msg,  "Please enter a password.");
	}
	
    if ( !empty($enteredUsername) && !empty($enteredPassword) )   { 

        $query = "SELECT password, user_id, name FROM User WHERE username='$enteredUsername'";
        
        $result = mysqli_query($db, $query);
        include('lib/show_queries.php');
        $count = mysqli_num_rows($result); 
        
        if (!empty($result) && ($count > 0) ) {
            $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
            $storedPassword = $row['password']; 
            $storedUser = $row['user_id'];
            $storedName = $row['name'];
            $options = [
                'cost' => 8,
            ];
             //convert the plaintext passwords to their respective hashses
             // 'michael123' = $2y$08$kr5P80A7RyA0FDPUa8cB2eaf0EqbUay0nYspuajgHRRXM9SgzNgZO
            $storedHash = password_hash($storedPassword, PASSWORD_DEFAULT , $options);   //may not want this if $storedPassword are stored as hashes (don't rehash a hash)
            $enteredHash = password_hash($enteredPassword, PASSWORD_DEFAULT , $options); 
            
            if($showQueries){
                array_push($query_msg, "Plaintext entered password: ". $enteredPassword);
                //Note: because of salt, the entered and stored password hashes will appear different each time
                array_push($query_msg, "Entered Hash:". $enteredHash);
                array_push($query_msg, "Stored Hash:  ". $storedHash . NEWLINE);  //note: change to storedHash if tables store the plaintext password value
                array_push($query_msg, "userID:  ".$storedUser);
                //unsafe, but left as a learning tool uncomment if you want to log passwords with hash values
                //error_log('email: '. $enteredEmail  . ' password: '. $enteredPassword . ' hash:'. $enteredHash);
            }
            
            //depends on if you are storing the hash $storedHash or plaintext $storedPassword 
            if (password_verify($enteredPassword, $storedHash) ) {
              session_start();
              session_destroy();
              session_start();
                array_push($query_msg, "Password is Valid! ");
                $_SESSION['userID'] = $storedUser;
                $_SESSION['SESSION']=$storedUser."LoggedIn";
                array_push($query_msg, "logging in... ");
                header(REFRESH_TIME . 'url=dashboard.php');		//to view the password hashes and login success/failure
                
            } else {
                array_push($error_msg, "Login failed: " . $enteredUsername . NEWLINE);
                array_push($error_msg, "To demo enter: ". NEWLINE . "lmosdell0". NEWLINE ."uT4U9cc");
            }
            
        } else {
                array_push($error_msg, "The username entered does not exist: " . $enteredUsername);
            }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<!-- WRITTEN BY: CREATIVE TIM
     MODIFIED BY: DCARVALLO3 -->
<head>
  <meta charset="utf-8" />
  <link rel="apple-touch-icon" sizes="76x76" href="../assets/img/apple-icon.png">
  <link rel="icon" type="image/png" href="../assets/img/favicon.png">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <title>
    CS6400
  </title>
  <meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0, shrink-to-fit=no' name='viewport' />
  <!--     Fonts and icons     -->
  <link rel="stylesheet" type="text/css" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Roboto+Slab:400,700|Material+Icons" />
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/latest/css/font-awesome.min.css">
  <!-- CSS Files -->
  <link href="assets/css/material-kit.css?v=2.0.3" rel="stylesheet" />
</head>


<body class="signup-page sidebar-collapse">
  <nav class="navbar navbar-transparent navbar-color-on-scroll fixed-top navbar-expand-lg" color-on-scroll="100" id="sectionsNav">
    <div class="container">
      <div class="navbar-translate">
        <button class="navbar-toggler" type="button" data-toggle="collapse" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
          <span class="navbar-toggler-icon"></span>
          <span class="navbar-toggler-icon"></span>
        </button>
      </div>
      <div class="collapse navbar-collapse">
      </div>
    </div>
  </nav>
  <div class="page-header header-filter" filter-color="purple" style="background-image: url('../assets/img/bg7.jpg')">
    <div class="container">
      <div class="row">
        <div class="col-md-5 ml-auto mr-auto">
          <div class="card card-signup">
            <h2 class="card-title text-center">Login</h2>
            <div class="card-body">
              <div class="row">
                <div class="col-md-12 mr-auto">
<!--                   <div class="social text-center">
                    <button class="btn btn-just-icon btn-round btn-twitter">
                      <i class="fa fa-twitter"></i>
                    </button>
                    <button class="btn btn-just-icon btn-round btn-dribbble">
                      <i class="fa fa-dribbble"></i>
                    </button>
                    <button class="btn btn-just-icon btn-round btn-facebook">
                      <i class="fa fa-facebook"> </i>
                    </button>
                    <h4> or be classical </h4>
                  </div> -->
                  <form class="form" method="POST" action="login.php" enctype="multipart/form-data">
                    <div class="form-group">
                      <div class="input-group">
                        <div class="input-group-prepend">
                          <span class="input-group-text">
                            <i class="material-icons">account_box</i>
                          </span>
                        </div>
                        <input type="text" name="username" class="form-control" placeholder="Username...">
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <div class="input-group-prepend">
                          <span class="input-group-text">
                            <i class="material-icons">lock_outline</i>
                          </span>
                        </div>
                        <input type="password" name="password" placeholder="Password..." class="form-control" />
                      </div>
                    </div>
                    <div class="text-center">
                      <button type="submit" class="btn btn-primary btn-round">Login</button>
                    </div>
                  </form>
                </div>
                <?php include("lib/error.php"); ?>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <!--   Core JS Files   -->
  <script src="../assets/js/core/jquery.min.js" type="text/javascript"></script>
  <script src="../assets/js/core/popper.min.js" type="text/javascript"></script>
  <script src="../assets/js/core/bootstrap-material-design.min.js" type="text/javascript"></script>
  <script src="../assets/js/plugins/moment.min.js"></script>
  <!--	Plugin for the Datepicker, full documentation here: https://github.com/Eonasdan/bootstrap-datetimepicker -->
  <script src="../assets/js/plugins/bootstrap-datetimepicker.js" type="text/javascript"></script>
  <!--  Plugin for the Sliders, full documentation here: http://refreshless.com/nouislider/ -->
  <script src="../assets/js/plugins/nouislider.min.js" type="text/javascript"></script>
  <!-- Control Center for Now Ui Kit: parallax effects, scripts for the example pages etc -->
  <script src="../assets/js/material-kit.js?v=2.0.3" type="text/javascript"></script>
</body>

</html>
