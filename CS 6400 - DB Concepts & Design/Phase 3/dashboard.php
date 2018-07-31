<?php session_start(); 
//written BY DCARVALLO3
  include('lib/common.php'); 
  if($showQueries){
  array_push($query_msg, "showQueries currently turned ON, to disable change to 'false' in lib/common.php");
}

    $title = "Dashboard";
    //$ESF_query = "SELECT esf_id, description FROM ESF";
    //$unit_query = "SELECT unit_quantity_id, unit FROM UnitQuantity"; 
    //$ResourceID_query= "SELECT max(Resource_id)+1 AS NRID FROM Resource";
    //$Incident_declaration_query="SELECT declaration_id, description, abbreviation, total_count+1 FROM Declaration";
    //$ESFs = mysqli_query($db, $ESF_query);
    //$ESFaddtl = mysqli_query($db, $ESF_query);
    //$units = mysqli_query($db, $unit_query);
    //$RID = mysqli_query($db, $ResourceID_query);
    //$DCLs = mysqli_query($db, $Incident_declaration_query);

        
    if(isset($_GET['msg'])){
        array_push($success_msg, $_GET['msg'] );
    }
    
?>

<?php require_once('header.php'); ?>

<?php require_once('sidebar.php'); ?>
        <div class="main-panel">
            <?php// require_once('nav.php'); ?>
            <div class="content">
                <div class="container-fluid">
                     <?php include('lib/show_queries.php');?>
                     <?php include('lib/error.php'); ?>
                    <div class="row">
                        <div class="col-lg-4 col-md-6 col-sm-6">
                            <div class="card card-stats">
                                <div class="card-header card-header-warning card-header-icon">
                                    <div class="card-icon">
                                        <i class="material-icons">content_copy</i>
                                    </div>
                                    
                                    <!-- <p class="card-category">Add Resource</p> -->
                                    <h3 class="card-title"></h3>
                                   <!-- <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#AddResourcesModal"> Add Resource</button>-->
                                   <a href="addresource.php" class="btn btn-primary" role="button">Add Resource</a> 
                                </div>
                            </div>
                        </div>
                        
                        <!-- Button trigger modal -->
                         <?//php require_once('views/_AddResourceForm.php'); ?>
                    
                        
                        <div class="col-lg-4 col-md-6 col-sm-6">
                            <div class="card card-stats">
                                <div class="card-header card-header-danger card-header-icon">
                                    <div class="card-icon">
                                        <i class="material-icons">perm_scan_wifi</i>
                                    </div>
                                  <!--  <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#AddIncidentModal"> Add Incident</button> -->
                                    <a href="AddIncident.php" class="btn btn-primary" role="button">Add Incident</a>
                                </div>
<!--                                <div class="card-footer">
                                    <div class="stats">
                                        <i class="material-icons">date_range</i> Last 24 Hours
                                    </div>
                                </div>  -->
                            </div>
                        </div>
                        <!-- Button trigger modal -->
                         <?//php require_once('views/_AddIncidentForm.php'); ?>
                        <div class="col-lg-4 col-md-6 col-sm-6">
                            <div class="card card-stats">
                                <div class="card-header card-header-success card-header-icon">
                                    <div class="card-icon">
                                        <i class="material-icons">search</i>
                                    </div>
                                    <a href="searchresults.php" class="btn btn-primary" role="button">Search Resources</a> 
                                     
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-4 col-md-6 col-sm-6">
                            <div class="card card-stats">
                                <div class="card-header card-header-info card-header-icon">
                                    <div class="card-icon">
                                        <i class="material-icons">content_paste</i>
                                    </div>
                                    <a href="resourcestatus.php" class="btn btn-primary" role="button">Resource Status</a>
                                </div>
                                <!-- <div class="card-footer">
                                    <div class="stats">
                                        <i class="material-icons">update</i> Just Updated
                                    </div>
                                </div> -->
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-6 col-sm-6">
                            <div class="card card-stats">
                                <div class="card-header card-header-info card-header-icon">
                                    <div class="card-icon">
                                        <i class="material-icons">assignment</i>
                                    </div>
                                    <!-- <p class="card-category">Resource Report</p> -->   
                                    <a href="resourcereport.php" class="btn btn-primary" role="button">Resource Report</a>
                                </div>
                               
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <?php require_once('footer.php'); ?>
        </div>

<!--https://stackoverflow.com/questions/34999531/how-to-correctly-validate-a-modal-form-->

<?php require_once('scripts.php'); ?>





