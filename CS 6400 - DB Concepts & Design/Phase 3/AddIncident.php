<?php session_start(); 
//written BY DCARVALLO3
 $title="Add Incident";
  include('lib/common.php'); 
  if($showQueries){
  array_push($query_msg, "showQueries (Incident) currently turned ON, to disable change to 'false' in lib/common.php");}
  
if( $_SERVER['REQUEST_METHOD'] == 'POST') {
    $currentuser=$_SESSION['userID'];
    $inp_declaration = $_POST['I_Declaration'];
    $inp_lat=$_POST['I_Latitude'];
    $inp_long=$_POST['I_Longitude'];
    $inp_description=$_POST['inputIncidentDescription'];
    $inp_date=$_POST['inputIncidentDate'];
    
    $query="INSERT INTO `Incident` ( `declaration_id`, `user_id`, `latitude`, `longitude`, `description`, `incident_date`) VALUES ('$inp_declaration', '$currentuser', '$inp_lat', '$inp_long', '$inp_description', '$inp_date')";
    $queryID = mysqli_query($db, $query);
        
            
//  
        if ($queryID  == False) {
        		 array_push($query_msg, "Current User: ". $currentuser);
                 array_push($error_msg, "INSERT ERROR: Incident: " . $inp_declaration.  " user: " . $currentuser ."<br>". __FILE__ ." line:". __LINE__ );
                 header(REFRESH_TIME . 'url=dashboard.php?error=Unable to Add Incident: '. urlencode($inp_description));
          }
          else{
              array_push($query_msg, "ADDED INCIDENT SUCCESSFULLY");
              header(REFRESH_TIME . 'url=dashboard.php?msg=Incident Added');
          }
          
          
}else{
  
  $Incident_declaration_query="SELECT declaration_id, description, abbreviation, total_count+1 FROM Declaration";
  $DCLs = mysqli_query($db, $Incident_declaration_query);
  
  
}

?>

<?php require_once('header.php'); ?>

<?php require_once('sidebar.php');?>

        <div class="main-panel">
            <?php require_once('nav.php'); ?>
            <div class="content">
                <?php include('lib/show_queries.php');
                      include('lib/error.php'); ?>
                <div class="container-fluid">
                 <div class="row">
                   <div class="col-lg-8 col-md-6 col-sm-6">
                   	<div class="card">
                   	<div class="card-header card-header-primary">
                                <h4 class="card-title">Add Incident</h4>
                                <p class="card-category">Hola amigo, report an incident</p>
                    </div>
                        <form class="form-horizontal" role="form" action="" method="POST" id="AddIncidentForm">
                        <div class="form-group row">
        					<label class="col-sm-2 control-label" for="I_Declaration">Declaration</label>
        					<div class="col-sm-10">
        					<select class="form-control" id="I_Declaration" name="I_Declaration" required>
        					  <option value="" disabled selected>Choose Declaration</option>
        					<?php
        							while ($mem = mysqli_fetch_assoc($DCLs)):
        						        echo '<option value='.$mem['declaration_id'].'>('.$mem['abbreviation'].') - '.$mem['description'].'</option>';
        						     endwhile;
        								$DCLs->close();
        						     ?> 
        					</select>
        				 <label for="IncidentDeclarationRequirements"><ul class="input-requirements">
								<li>Must have a declaration</li>
					</ul></label>
        					</div>
				      </div>
				<div class="form-group row">
					<label class="col-sm-2 control-label" for="staticIncidentID" class="col-sm-4 col-form-label">Incident ID</label>
					<div class="col-sm-10">
					  <input type="text" readonly class="form-control-plaintext" id="IncidentID" value="Assigned Automatically" required>
					</div>
				  </div>
                  <div class="form-group row">
                    <label  class="col-sm-2 control-label"for="inputIncidentDate">Date</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="inputIncidentDate" name="inputIncidentDate" placeholder="Incident Date YYYY-MM-DD" required/>
                        <label for="IncidentDateRequirements"><ul class="input-requirements">
								<li>Must have a date</li>
								<li>Date must be YYYY-MM-DD</li>
					</ul></label>
                    </div>
                  </div>
                  <div class="form-group row">
                    <label  class="col-sm-2 control-label"
                              for="inputIncidentDescription">Description</label>
                    <div class="col-sm-10">
                        <textarea class="form-control" id="inputIncidentDescription" rows="1" name="inputIncidentDescription" required></textarea>
                        <label for="IncidentDescriptionRequirements"><ul class="input-requirements">
								<li>Must have a description</li>
					</ul></label>
                    </div>
                  </div>

				 <div class="form-group row ">
                    <label  class="col-sm-2 control-label" for="I_HomeLocation">Home Location</label>
					 <div class="col-sm-5">
					<input type="text" class="form-control" id="I_Latitude" name="I_Latitude" placeholder="Latitude" required/>
					<label for="IncidentLatitudeRequirements"><ul class="input-requirements">
								<li>Must be between -90 and 90</li>
								<li>Must be a number</li>
					</ul></label>
					</div>
					 <div class="col-sm-5">
					<input type="text" class="form-control" id="I_Longitude" name="I_Longitude" placeholder="Longitude" required/>
										<label for="IncidentLongitudeRequirements"><ul class="input-requirements">
								<li>Must be between -180 and 180</li>
								<li>Must be a number</li>
					</ul></label>
					</div>
                  </div>
                  <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                      <button type="submit" id="sub_btn" class="btn btn-default">Save</button>
                      <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                  </div>
            </form>
                </div>
                </div>
                </div>
                  </div>
                </div>
                </div>
                </div>

<?php require_once('scripts.php'); ?>


