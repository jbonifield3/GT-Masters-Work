<?php session_start(); 
//written BY DCARVALLO3
	$title="Add Resource";
  include('lib/common.php'); 
  if($showQueries){
  array_push($query_msg, "showQueries currently turned ON, to disable change to 'false' in lib/common.php");
}
if( $_SERVER['REQUEST_METHOD'] == 'POST') {

		$currentuser=$_SESSION['userID'];
		$ResID = $_POST['ResourceID'];
	    $enteredRName = $_POST['ResourceName'];
		$enteredPESF = $_POST['PrimaryESF'];
		$enteredAESF = $_POST['AdtlESF'];
		$enteredcap = $_POST['R_tags-input'];
		$enteredLat = $_POST['R_Latitude'];
		$enteredLong = $_POST['R_Longitude'];
		$enteredCost = $_POST['R_Cost'];
		$enteredDist = $_POST['R_MaxDistance'];
		$enteredCostPer = $_POST['R_CostPer'];
		$enteredModel = $_POST['ResourceModel'];
		$capabilities  = explode(",", $enteredcap);
	    
	   if($showQueries){
	   		array_push($query_msg, "Current User: ". $currentuser);
            array_push($query_msg, "Resource ID: ". $ResID);
            array_push($query_msg, "Entered Resource Name: ". $enteredRName);
            array_push($query_msg, "Entered Primary ESF:". $enteredPESF);
            array_push($query_msg, "Entered aDTLesf ESF:". $enteredAESF);
            array_push($query_msg, "Entered cOST:". $enteredCost);
            array_push($query_msg, "Capabilities:  ". $capabilities . NEWLINE);  //note: change to storedHash if tables store the plaintext password value
        }
        
        $query = "INSERT INTO Resource (user_id, resource_name, primary_esf_id, latitude ,longitude , max_distance , cost_amount , unit_quantity_id,model) VALUES ('$currentuser', '$enteredRName', '$enteredPESF',' $enteredLat', '$enteredLong', '$enteredDist', '$enteredCost', '$enteredCostPer','$enteredModel')";
	    $queryID = mysqli_query($db, $query);
	    
            

        if ($queryID  == False) {
        		 array_push($query_msg, "Current User: ". $currentuser);
                 array_push($error_msg, "INSERT ERROR: resource: " . $enteredRName.  " user: " . $currentuser ."<br>". __FILE__ ." line:". __LINE__ );
                 header(REFRESH_TIME . 'url=dashboard.php?error=Unable to Add Resource: '. urlencode($enteredRName));
          } 
        else {
        	$resource_id = mysqli_insert_id($db);
        	//Add The Additional ESFs
        	array_push($query_msg, "INSERT SUCCESS. Inserting Additonal ESFs ... ");
			if(count($enteredAESF)>0){
        	foreach ($enteredAESF as $ESFx){
        		array_push($query_msg, "Insert ESF: ". $ESFx. " resource: " . $resource_id);
        		$query = "INSERT INTO `AdditionalESF` (resource_id, esf_id) VALUES ('$resource_id','$ESFx')"; 
	    		$AESFID = mysqli_query($db, $query);
	    		 if ($AESFID   == False) {
        		 array_push($query_msg, "Current User: ". $currentuser);
                 array_push($error_msg, "INSERT ERROR: additional ESF: " . $ESFx.  " resource: " . $resource_id  ."<br>". __FILE__ ." line:". __LINE__ );
                 
                 //DELETE RESOURCE AS ERROR OCCURED
                 $query = "DELETE FROM Resource WHERE resource_id='$resource_id '";
                 $queryID = mysqli_query($db, $query);
	                 if ($queryID  == False) {
	        		 array_push($query_msg, "Current User: ". $currentuser);
	                 array_push($error_msg, "DELETE ERROR: resource: " . $resource_id .  " user: " . $currentuser ."<br>". __FILE__ ." line:". __LINE__ );
	                 header(REFRESH_TIME . 'url=dashboard.php?error=Unable to Add Additional Resource ESFs. Unable to delete resource');
	        		 }else{
	        		 	header(REFRESH_TIME . 'url=dashboard.php?error=Unable to Add Additional Resource ESF. Resource Not Added.');
	        		 }
        		} 
	    		
        	}
			}else{array_push($query_msg, "No Additional ESF Selected");}
        	
        	//Add the capabilities
        	array_push($query_msg, "INSERT SUCCESS. Inserting Capabilties ESFs ... ");
        	array_push($query_msg, "Total Capabilities:".count($capabilities));
        	if($capabilities[0]!=""){
        	foreach ($capabilities as $cap){
        		array_push($query_msg, "Insert CAP: ". $cap. " resource: " . $resource_id);
        		$query = "INSERT INTO `Capability`(`resource_id`, `capabilities`) VALUES ('$resource_id','$cap')";
        		$capID = mysqli_query($db, $query);
        		if ($capID    == False) {
        			array_push($query_msg, "Current User: ". $currentuser);
                	array_push($error_msg, "INSERT ERROR: capability: " . $cap.  " resource: " . $resource_id  ."<br>". __FILE__ ." line:". __LINE__ );
                	
                	
        		 //DELETE RESOURCE AS ERROR OCCURED
        		if(count($enteredAESF)>0){
        		 $query = "DELETE FROM `AdditionalESF` WHERE resource_id='$resource_id '";	 
                 $queryID = mysqli_query($db, $query);
	                 if ($queryID  == False) {
	        		 array_push($query_msg, "Current User: ". $currentuser);
	                 array_push($error_msg, "DELETE ERROR: adtl resource: " . $resource_id .  " user: " . $currentuser ."<br>". __FILE__ ." line:". __LINE__ );
	                 
		            	$query = "DELETE FROM Resource WHERE resource_id='$resource_id '";	 
		        		$queryID = mysqli_query($db, $query);
		        		if ($queryID  == False) {
		        		array_push($query_msg, "Current User: ". $currentuser);
		                 array_push($error_msg, "DELETE ERROR: resource: " . $resource_id .  " user: " . $currentuser ."<br>". __FILE__ ." line:". __LINE__ ); 
		                 header(REFRESH_TIME . 'url=dashboard.php?error=Unable to Add Capabilites. Unable to del ADTL ESF.  Unable to delete resource. ');
		        		}
		        		else{header(REFRESH_TIME . 'url=dashboard.php?error=Unable to Add Capabilites. unable to delete ADTL ESF.  deleted resource. ');}
	        		 
	        		 }else{
	        		$query = "DELETE FROM Resource WHERE resource_id='$resource_id '";	 
	        		$queryID = mysqli_query($db, $query);
	        		if ($queryID  == False) {
	        		array_push($query_msg, "Current User: ". $currentuser);
	                 array_push($error_msg, "DELETE ERROR: resource: " . $resource_id .  " user: " . $currentuser ."<br>". __FILE__ ." line:". __LINE__ ); 
	                 header(REFRESH_TIME . 'url=dashboard.php?error=Unable to Add Capabilites. Deleted ADTL ESF.  Unable to delete resource. ');
	        		}else{header(REFRESH_TIME . 'url=dashboard.php?error=Unable to Add Capabilites. Deleted ADTL ESF.  Deleted resource. ');}
	        		 	
	        		 }
        			
        		}
	        		 else{
	        	     $query = "DELETE FROM Resource WHERE resource_id='$resource_id '";	 
	        	     $queryID = mysqli_query($db, $query);
	        		array_push($query_msg, "Current User: ". $currentuser);
	                 array_push($error_msg, "DELETE ERROR: resource: " . $resource_id .  " user: " . $currentuser ."<br>". __FILE__ ." line:". __LINE__ );
	                 header(REFRESH_TIME . 'url=dashboard.php?error=Unable to Add Capabilites. Unable to delete resource');
	        		 }
        		}else{
        			array_push($query_msg, "Resource Added Successfully");
        			header(REFRESH_TIME . 'url=dashboard.php?msg=Resource Added');
        		}
        	}
        	
        }else{
        	array_push($query_msg, "No capabilities inserted");
        	array_push($query_msg, "Resource Added Successfully");
        	header(REFRESH_TIME . 'url=dashboard.php?msg=Resource Added');
        	
        }
        	
        	
        }
		
		array_push($query_msg, "sending request ... ");
	
}

else {
	$ESF_query = "SELECT esf_id, description FROM ESF";
	$unit_query = "SELECT unit_quantity_id, unit FROM UnitQuantity"; 
	$ResourceID_query= "SELECT max(Resource_id)+1 AS NRID FROM Resource";
	$ESFs = mysqli_query($db, $ESF_query);
	$ESFaddtl = mysqli_query($db, $ESF_query);
    $units = mysqli_query($db, $unit_query);
    $RID = mysqli_query($db, $ResourceID_query);
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
                     <form class="form-horizontal" role="form" method="POST" action="addresource.php" id="addform" enctype="multipart/form-data">
				<div class="form-group row">
					<label class="col-sm-2 control-label" for="staticResourceID" class="col-sm-4 col-form-label">Resource ID</label>
					<div class="col-sm-10">
					  <input type="text" readonly class="form-control-plaintext" name="ResourceID" id="ResourceID" value="<?php $mem = mysqli_fetch_assoc($RID); echo $mem['NRID'] ?>">
					</div>
				  </div>
				<div class="form-group row">
					<label class="col-sm-2 control-label" for="staticOwner" class="col-sm-4 col-form-label">Owner</label>
					<div class="col-sm-10">
					  <input type="text" readonly class="form-control-plaintext" id="ResourceOwner" value="<?php echo $_SESSION['userName'] ?>">
					</div>
				 </div>
                  <div class="form-group row">
                    <label  class="col-sm-2 control-label" for="inputResourceName">Resource Name</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="inputResourceName" name="ResourceName" placeholder="This is my resource" required/>
                        <label for="ResourceNameRequirements" id="ResourceNameRequirements"><ul class="input-requirements">
								<li>At least 3 characters long</li>
								<li>Must only contain letters and numbers (no special characters)</li>
					</ul></label>
                    </div>
                  </div>
				  <div class="form-group row">
					<label class="col-sm-2 control-label" for="R_PrimaryESF">Primary ESF</label>
					<div class="col-sm-10">
					<select class="form-control" name="PrimaryESF" id="R_PrimaryESF" onchange="RemoveFromAdtl()" required>
					<option  value="" disabled selected>Choose ESF</option>
					<?php
							while ($mem = mysqli_fetch_assoc($ESFs)):
						        echo '<option value='.$mem['esf_id'].'>(#'.$mem['esf_id'].') - '.$mem['description'].'</option>';
						     endwhile;
								$ESFs->close();
						     ?> 
					</select>
					<label for="PrimaryESFRequirements"><ul class="input-requirements">
								<li>Must have an ESF</li>
					</ul></label>
					</div>
				  </div>
				  <!-- https://silviomoreto.github.io/bootstrap-select/examples/ --> 
				    <div class="form-group row">
					<label class="col-sm-2 control-label" for="R_AddESF">Additional ESFs</label>
					<div class="col-sm-10">
					<select class="mdb-select colorful-select dropdown-primary" name="AdtlESF[]"multiple id="R_AddESF" multiple searchable="Select Additional ESFs..">
					<?php
							while ($mem = mysqli_fetch_assoc($ESFaddtl)):
						        echo '<option value='.$mem['esf_id'].'>(#'.$mem['esf_id'].') - '.$mem['description'].'</option>';
						     endwhile;
						     $ESFaddtl->close();
						     ?> 
					</select>
				 </div>
				  </div>
				 <div class="form-group row">
                    <label  class="col-sm-2 control-label" for="R_Model">Model</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="R_Model" name="ResourceModel" placeholder="Resource Model"/>
                    </div>
                  </div>
				  <div class="form-group row">
				  <label class="col-sm-2 control-label" for="R_Capabilities">Capabilities</label>
				  <div class="col-sm-10">
            <div class="tags-input" data-name="R_tags-input" id="R_capinput">
            </div>
				  </div>
				  </div>
				 <div class="form-group row ">
                    <label  class="col-sm-2 control-label" for="R_HomeLocation">Home Location</label>
					 <div class="col-sm-5">
					<input type="text" class="form-control" name="R_Latitude" id="R_Latitude" placeholder="Latitude" required/>
					<label for="LatitudeRequirements"><ul class="input-requirements">
								<li>Must be between -90 and 90</li>
								<li>Must be a number</li>
					</ul></label>
					</div>
					 <div class="col-sm-5">
					<input type="text" class="form-control" name="R_Longitude" id="R_Longitude" placeholder="Longitude" required/>
					<label for="LongitudeRequirements"><ul class="input-requirements">
								<li>Must be between -180 and 180</li>
								<li>Must be a number</li>
					</ul></label>
					</div>
                  </div>
				 <div class="form-group row ">
                    <label  class="col-sm-2 control-label" for="R_MaxDistance">Max Distance</label>
					 <div class="col-sm-5">
					<input type="text" class="form-control" name="R_MaxDistance" id="R_MaxDistance" placeholder="Distance" />
					<label for="DistanceRequirements"><ul class="input-requirements">
								<li>Must be greater than 0</li>
								<li>Must be a number</li>
					</ul></label>
					</div>
					 <div class="col-sm-5">
					<input type="text" readonly class="form-control-plaintext" id="R_DistMeasure" value="kilometers"/>
					</div>
                  </div>
				 <div class="form-group row ">
                    <label  class="col-sm-2 control-label" for="R_Cost">Cost</label>
					 <div class="col-sm-4">
					<input type="text" class="form-control" name="R_Cost" id="R_Cost" placeholder="Cost" required/>
					<label for="CostRequirements"><ul class="input-requirements">
								<li>Must be greater than 0</li>
								<li>Must be a number</li>
					</ul></label>
					</div>
					 <div class="col-sm-2">
					<input type="text" readonly class="form-control-plaintext" id="R_CostMult" value="per"/>
					</div>
					<div class="col-sm-4">
					<select class="form-control" name="R_CostPer" id="R_CostPer">
					   <?php
							while ($mem = mysqli_fetch_assoc($units)):
						        echo '<option value='.$mem['unit_quantity_id'].'>'.$mem['unit'].'</option>';
						     endwhile;
						     $units->close();
						     ?> 
					</select>
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
<?php require_once('scripts.php'); ?>
<script type="text/javascript">

// Remove Selected Primary ESF from Additional ESF table lsit

function RemoveFromAdtl() {
	//alert("Primary ESF has been CHOSEN");
    var x = document.getElementById('R_PrimaryESF').value;
    //alert("You selected: " + x);
    document.querySelector('label[for="ResourceNameRequirements"] .input-requirements li:nth-child(1)')
    
    var select=document.getElementById('R_AddESF');

	for (i=0;i<select.length;  i++) {
	   if (select.options[i].value==x) {
	     //select.remove(i);
	     select.options[i].style.display = "none";
	   }else{
	   	select.options[i].style.display = "block";
	   }
	}
}
</script>
