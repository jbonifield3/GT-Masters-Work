<?php  session_start(); 
//WRITTEN BY DCARVALLO3
include('lib/common.php');
    $currentuser=$_SESSION['userID'];
    if(!isset($_SESSION['userName'])or !isset($_SESSION['description']) ) {
     $query= "SELECT
     u.user_id,
     u.name,
     u.username,
     case
     when m.municipality_type_id is not null then concat(mt.municipality_type)
     when ga.agency_name is not null then concat(ga.agency_name)
     when c.headquarters is not null then concat( 'HQ: ', c.headquarters, '  Employee #: ', c.no_of_employee )
     when iu.job_title is not null then concat(iu.job_title)
     end Description
     FROM User u
     left outer join Municipality m on (m.user_id = u.user_id)
     left outer join MunicipalityType mt on (mt.municipality_type_id = m.municipality_type_id)
     left outer join GovernmentAgency ga on (ga.user_id = u.user_id)
     left outer join Company c on (c.user_id = u.user_id)
     left outer join IndividualUser iu on (iu.user_id = u.user_id)
     WHERE u.user_id = '$currentuser'";
     $result = mysqli_query($db, $query);
     $dta = mysqli_fetch_assoc($result);
     $_SESSION['userName'] = $dta['name'];
     $_SESSION['description'] = $dta['Description'];
}
?>
        
        
        <div class="sidebar" data-color="purple" data-background-color="white" data-image="assets/img/sidebar-1.jpg">
            <!--
        Tip 1: You can change the color of the sidebar using: data-color="purple | azure | green | orange | danger"

        Tip 2: you can also add an image using data-image tag
    -->
            <div class="logo">
                <a href="http://www.gatech.edu" class="simple-text logo-normal">
                  <h3>CS6400 TEAM04</h3> 
                </a>
            </div>
            <div class="sidebar-wrapper">
                <ul class="nav">
                    <li class="nav-item ">
                        <div class="row">
                            <div class=" offset-md-2 mol-md-10">
                                <h3><?php echo $_SESSION['userName']; ?></h3>
                            </div>
                        </div>
                        <div class="row"><div class="offset-md-2 col-md-10"><h4><?php echo  $_SESSION['description']; ?></h4></div></div>
                    </li>

                    

                     <li class="nav-item <?php if($current_filename=='dashboard.php') {echo "active";} ?>" > 
                        <a class = "nav-link" href="dashboard.php" >
                    <!-- This is to toggle on/off for active/inactive sidebar menu. why doesnt this work? dthai-->
                            <i class="material-icons">dashboard</i>
                            <p>Dashboard</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="addresource.php">
                            <i class="material-icons">content_copy</i>
                            <p>Add Resource</p>
                        </a>
                    </li>

                    <li class="nav-item">
                        <a class="nav-link" href="AddIncident.php">
                            <i class="material-icons">perm_scan_wifi</i>
                            <p>Add Incident</p>
                        </a>

                    <li class="nav-item">
                        <a class="nav-link" href="searchresults.php">
                            <i class="material-icons">library_books</i>
                            <p>Search Resources</p>
                        </a>
                    </li>

                    
                    </li>

                    <li class="nav-item <?php if($current_filename=='resourcestatus.php') {echo "active";} ?> ">
                        <a class="nav-link" href="resourcestatus.php">
                            <i class="material-icons">content_paste</i>
                            <p>Resource Status</p>
                        </a>
                    </li>
                    <li class="nav-item <?php if($current_filename=='resourcereport.php') {echo "active";} ?> ">
                        <a class="nav-link" href="resourcereport.php">
                            <i class="material-icons">assignment</i>
                            <p>Resources Report</p>
                        </a>
                    </li>
                    <li class="nav-item ">
                        <a class="nav-link" href="logout.php">
                            <i class="material-icons">eject</i>
                            <p>Logout</p>
                        </a>
                    </li>
                </ul>
            </div>
        </div>