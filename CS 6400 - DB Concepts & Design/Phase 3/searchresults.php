<?php  session_start();
  include('lib/common.php'); 
// Page and Query by James Bonifield  
        $currentuser=$_SESSION['userID'];
        $title = "Search Results";

    // DEPLOY_OWN BUTTON
    if (!empty($_GET['deploy_request_rx']) & !empty($_GET['deploy_request_inc'])  ) 
        {
        $rx_id = mysqli_real_escape_string($db, $_GET['deploy_request_rx']);
        $inc_id = mysqli_real_escape_string($db, $_GET['deploy_request_inc']);

        $query_dp1 = "UPDATE Resource
                Set resource_status_id = 2
                WHERE resource_id = $rx_id and user_id = $currentuser;";
        
        $result_dp1 = mysqli_query($db, $query_dp1);
        include('lib/show_queries.php');
        
        if (mysqli_affected_rows($db) == -1) 
            {
            array_push($error_msg,  "DELETE ERROR: cancel request...<br>" . __FILE__ ." line:". __LINE__ );
            header(REFRESH_TIME . 'url=searchresults.php?error=Resource Deployment Failed. Update Resource Failed.');

            }


        $query_dp2 = " INSERT INTO Request 
                        Values ($inc_id, $rx_id, CURDATE(), $currentuser , DATE_ADD(CURDATE(), INTERVAL 30 DAY))";
        
        $result_dp2 = mysqli_query($db, $query_dp2);

        include('lib/show_queries.php');
        
        if (mysqli_affected_rows($db) == -1) 
            {
            array_push($error_msg,  "DELETE ERROR: cancel request...<br>" . __FILE__ ." line:". __LINE__ );
            //If updating the request fails, shouldnt you also then undo the previous update where you set the resource status to 2
            header(REFRESH_TIME . 'url=searchresults.php?error=Resource Deployment Failed. Update Request Failed. ');
            }
            header(REFRESH_TIME . 'url=searchresults.php?msg=Resource Deployed Sucessfully'); 

        }




        if( $_SERVER['REQUEST_METHOD'] == 'GET') {
            $Search_ESF =$_REQUEST['ESF'] ?: -99999;
            $Search_Incident = $_REQUEST['Incident'] ?: -99999;
            $Search_MaxDistance=$_REQUEST['MaxDistance'] ?: pow(10,15);
            $Search_Keywords=strtolower($_REQUEST['Keywords'])?: -99999;
            // $currentuser = 51;
            // $currentuser = 51 ;
            // $Search_ESF = 3 ;
            // $Search_Incident = 51 ;
            // $Search_MaxDistance = 100000;
            // $Search_Keywords = -99999 ;
            // $longitude = 0;
            // $latitude = 0;

            if ($Search_Incident != -99999) {
            
                $query= "
                    select 
                        r.resource_id 'ID', r.resource_name 'Name', u.name 'Owner',
                        concat('$',r.cost_amount,'/',uq.unit) 'Cost', rs.resource_status 'Status',
                        case 
                            when req.return_by > current_date() then Date_Format(req.return_by,'%d / %m / %Y')
                            else 'NOW' END 'Next_Available',
                        concat(cast(round(Haversine(r.latitude,r.longitude,i.latitude,i.longitude),1) AS char), ' km') 'Distance', r.resource_status_id,
                        case when u.user_id = $currentuser then 'Deploy' ELSE 'Request' END 'Action'
                    from Resource r
                        join User u on (u.user_id = r.user_id)
                        join UnitQuantity uq on (uq.unit_quantity_id = r.unit_quantity_id)
                        join ResourceStatus rs on (rs.resource_status_id = r.resource_status_id)
                        left outer join (
                            select resource_id, max(esf_id) esf_id /*max is ok bc only one possible*/
                            from AdditionalESF
                            where esf_id = $Search_ESF
                            group by resource_id) aesf on (r.resource_id = aesf.resource_id)
                        left outer join (
                            select resource_id, capabilities
                            from Capability
                            where lower(trim(capabilities)) like lower(trim('%$Search_Keywords%'))
                            group by resource_id
                            ) c on (r.resource_id = c.resource_id)
                        left outer join Request req on (req.resource_id = r.resource_id and u.user_id = req.user_id)
                        join Incident i
                    where 1=1
                        and (i.incident_id = $Search_Incident)                    
                        and Haversine(r.latitude, r.longitude, i.latitude, i.longitude) < $Search_MaxDistance
                        and (r.primary_esf_id in ($Search_ESF) or aesf.esf_id in ($Search_ESF) or $Search_ESF = -99999)
                        and (
                            lower(trim(r.model)) like '%$Search_Keywords%' or
                            lower(trim(r.resource_name)) like '%$Search_Keywords%' or
                            lower(trim(c.capabilities)) like lower(trim('%$Search_Keywords%')) or                            
                            '$Search_Keywords' = '-99999'
                            )
                order by Haversine(r.latitude,r.longitude,i.latitude,i.longitude) ASC";
                // 'Next Available' ASC, 'Name' ASC";
                }
        else {

                $query= "
                    select 
                        r.resource_id 'ID', r.resource_name 'Name', u.name 'Owner',
                        concat('$',r.cost_amount,'/',uq.unit) 'Cost', rs.resource_status 'Status', r.resource_status_id,
                        case 
                            when req.return_by > current_date() then Date_Format(req.return_by,'%d / %m / %Y')
                            else 'NOW' END 'Next_Available'
                    from Resource r
                        join User u on (u.user_id = r.user_id)
                        join UnitQuantity uq on (uq.unit_quantity_id = r.unit_quantity_id)
                        join ResourceStatus rs on (rs.resource_status_id = r.resource_status_id)
                        left outer join (
                            select resource_id, max(esf_id) esf_id /*max is ok bc only one possible*/
                            from AdditionalESF aesf
                            where aesf.esf_id = $Search_ESF) aesf on (r.resource_id = aesf.resource_id)
                        left outer join (
                            select resource_id, capabilities
                            from Capability
                            where lower(trim(capabilities)) like lower(trim('%$Search_Keywords%'))
                            group by resource_id) c on (r.resource_id = c.resource_id)
                        left outer join Request req on (req.resource_id = r.resource_id and u.user_id = req.user_id)
                    where 1=1
                        and (r.primary_esf_id in ($Search_ESF) or aesf.esf_id in ($Search_ESF) or $Search_ESF = -99999)                        
                        and (
                            lower(trim(r.model)) like '%$Search_Keywords%' or
                            lower(trim(r.resource_name)) like '%$Search_Keywords%' or
                            lower(trim(c.capabilities)) like lower(trim('%$Search_Keywords%')) or
                            '$Search_Keywords' = '-99999'
                            )
                order by 'Next Available' ASC, 'Name' ASC";
        }                 
            $result = mysqli_query($db, $query);
            $count = mysqli_num_rows($result); 

        }


        if( $_SERVER['REQUEST_METHOD'] == 'POST') {
            //Get the Actual Values and Query on them 
            switch($_REQUEST['submitbutton']) {

        case 'Search': 
            if($_POST['MaxDistance']!="" & is_null($_POST['Incident']))
            {
            }else{
            header('Location: searchresults.php?ESF='.$_POST['ESF'].'&Incident='.$_POST['Incident'].'&MaxDistance='.$_POST['MaxDistance'].'&Keywords='.$_POST['S_Capabilities']);
            }break;
    
        case 'jquery': //action for jquery here
                        break;
    }
        }

    $ESF_query = "SELECT esf_id, description FROM ESF";
    $Incident_query =  "SELECT i.incident_id AS IncidentID, concat(d.abbreviation,'-', ic.count) AS IncidentKey, i.description AS Description
                        FROM Incident i
                        JOIN Declaration d on (d.declaration_id = i.declaration_id)
                        JOIN Incident_Count ic on (ic.incident_id = i.incident_id)
                        WHERE i.user_id = $currentuser ";
    $ESFs = mysqli_query($db, $ESF_query);
    $Incidents = mysqli_query($db, $Incident_query." order by i.incident_id");
?>



<?php require_once('header.php'); ?>

<?php require_once('sidebar.php'); ?>
        <div class="main-panel">
            <?php require_once('nav.php'); ?>
            <div class="content">
                <div class="container-fluid">
                    <?php include('lib/show_queries.php');?>
                     <?php include('lib/error.php'); ?>
                    <div class="col-lg-12 col-md-12">
                         <div class="card">
                        <form role="form" method="POST" action="searchresults.php"> 
                            <div class="form-group row">
                            <div class="col-sm-3">
                              <input type="text" id="MaxDistance" name='MaxDistance' class="form-control" placeholder="Input Maximum Distance (km)">
                              <label for="myRange">MaxDistance</label>
                            </div>
                             <div class="col-sm-3">
                                <select class="form-control" name="ESF" id="ESF">
                                <option value="" disabled selected>All ESFs</option>
                                <?php
                                    while ($mem = mysqli_fetch_assoc($ESFs)):
                                        echo '<option value='.$mem['esf_id'].'>(#'.$mem['esf_id'].') - '.$mem['description'].'</option>';
                                    endwhile;
                                        $ESFs->close();
                                ?> 
                                </select>
                                <label for="ESF">ESF</label>
                            </div>
                            <div class="col-sm-3">
                                <select class="form-control" name="Incident" id="Incident">
                                <option value="" disabled selected>All Incidents</option>
                                <?php
                                    while ($mem = mysqli_fetch_assoc($Incidents)):
                                        echo '<option value='.$mem['IncidentID'].'>('.$mem['IncidentKey'].') '.$mem['Description'].'</option>';
                                    endwhile;
                                        $Incidents->close();
                                ?> 
                                </select>
                                <label for="Incident">Incident</label>
                            </div>
                            <div class="col-sm-9">
                                <input type="text" id="S_Capabilities" name='S_Capabilities' class="form-control" placeholder="Input Model, Name, or Capabilities">
                                <label for="S_Capabilities">Keywords</label>
                            <div class="col-sm-10"> 
                            <input type="submit" name="submitbutton" value="Search">
                            </div> 
                        </form>
                        
                    </div>
                </div>
                </div>
                </div>
                <div class="container-fluid">
                    <div class="col-lg-12 col-md-12">
                        <div class="card">
                            
                            <div class="card-header card-header-warning">
                                <h4 class="card-title">Search Results for Incident  </h4>
                                <p class="card-category">
                                    <?php 
                                        $Incident_query2 = $Incident_query." where i.incident_id =".$Search_Incident;
                                        $Selected_Incident_Key = mysqli_fetch_assoc(mysqli_query($db, $Incident_query2));
                                        //$key = mysqli_fetch_array($Selected_Incident_Key, MYSQLI_ASSOC);
                                        //echo $Incident_query." where i.incident_id =".$Search_Incident ?: 'No Incident selected'
                                        // echo $Selected_Incident_Key['Description'].' ('.$Selected_Incident_Key['IncidentKey'].')' ?: 'No Incident selected' 
                                        ?> 
                                </p>
                            </div>
                            <div class="card-body table-responsive table-bordered" style="align-self: center;">

                            <?php
                                if (is_bool($result) && (mysqli_num_rows($result) == 0) )
                                    {
                                    array_push($error_msg,"Query ERROR: Failed to get available resources<br>" . __FILE__ ." line:". __LINE__ );
                                    }
                                
                                $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                                echo("Incidents Returned: ".$count);
                               if ($row) 
                               {                         
                                    print '<table class="table" >';
                                    print '<tr bgcolor="#bbbcb5" class="font-weight-bold" >';
                                    print '<td>ID</td>';
                                    print '<td>Name</td>';
                                    print '<td>Owner</td>';
                                    print '<td>Cost</td>';
                                    print '<td>Status</td>';
                                    print '<td>Next Available</td>';
                                   if(!is_null($row['Distance'])){ print '<td>Distance</td>';}
                                    if(!is_null($row['Action'])){print '<td>Action</td>';}
                                    print '</tr>';

                                    while ($row)
                                        {

                                        print '<tr>';

                                        
                                        
                                     

                                        print '<td>' . $row['ID'] . '</td>';
                                        print '<td>' . $row['Name'] . '</td>';
                                        print '<td>' . $row['Owner'] . '</td>';
                                        print '<td>' . $row['Cost'] . '</td>';
                                        print '<td>' . $row['Status'] . '</td>';
                                        print '<td>' . $row['Next_Available'] . '</td>';
                                       if(!is_null($row['Distance'])){ print '<td>' . $row['Distance'] . '</td>';}
                                        

                                        //Create correct button
                                        $rx_x = $row['ID'];
                                        $query_x = "SELECT * FROM Request WHERE incident_id = $Search_Incident AND resource_id = $rx_x";
                                        $result_x = mysqli_query($db, $query_x);
                                        $count_x = mysqli_num_rows($result_x);
                                        // Count_x = 1 -> request exist -> dont show request/ show warning
                                        // count_x = 0 -> show request


                                        if ($row['Action']=="Deploy" and ($row['resource_status_id'] == 1) and $count_x == 0)
                                        {
                                        print '<td><a class="btn btn-primary active" role="button" aria-pressed="true" href="searchresults.php?'. 'deploy_request_rx=' . urlencode($row['ID']) . '&deploy_request_inc=' . urlencode($Search_Incident) . '">Deploy</a>';
                                        } 
                                            elseif ( ($row['Action']=="Request") and ($count_x != 1))
                                            
                                            {
                                            print '<td><button type="button" class="btn btn-primary" data-toggle="modal" name="REQBTN'.$row['ID'].'" data-target="#RequestResourcesModal" onclick="UpdateForm('.$Search_Incident.','.$row['ID'].');">Request</button>  </td>';
                                            } elseif ( $count_x == 1)
                                                {
                                                    print '<td> Cannot request this resource to this incident</td>';
                                                }

                                        print '</tr>';

                                        $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                                        }

                                    //print '<tr bgcolor="#bbbcb5" class="font-weight-bold" >';
                                    //print '<td></td>';
                                    //print '<td>Grand Total</td>';
                                    //print '<td>' . $totalr . '</td>';
                                    //print '<td>' . $totaluse . '</td>';
                                    //print '</tr>';
                                    print '</table>';
                                    
                                }        
                                ?>
                                
<!-- Modal for the "Request" button on main page-->
<div class="modal fade" id="RequestResourcesModal" tabindex="-1" role="dialog" aria-labelledby="RequestResourcesModal" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="RequestResourcesModal">Request Resource</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
    <!-- Modal Body -->
            <div class="modal-body">
                
                <form class="form-horizontal" role="form" action="request.php" method="POST" id="RequestResourceForm"><!-- NEED TO UPDATE ACTION TO POINT TO CORRECT PHP FILE -->
                <div class="form-group row">
                      <input type="hidden" readonly class="form-control-plaintext" id="ReqResourceID" name="ReqResourceID" value="Resource ID" required>  <!--make hidden in final version -->
                  </div>

                <div class="form-group row">
                      <input type="hidden" readonly class="form-control-plaintext" id="ReqIncidentID" name="ReqIncidentID" value="Incident ID" required> <!-- make hidden in final version -->
                  </div>
                  
                  <div class="form-group row">
                    <label  class="col-sm-2 control-label"
                              for="inputIncidentDate">Date</label>
                    <div class="col-sm-10">
                        <input type="text" class="form-control" id="ReqIncidentDate" name="ReqIncidentDate" placeholder="Return Date YYYY-MM-DD"/>
                        <label for="RequestDateRequirements"><ul class="input-requirements">
                                <li>Must have a return date</li>
                                <li>Date must be YYYY-MM-DD</li>
                    </ul></label>
                    </div>
                  </div>

                  <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-10">
                      <button type="submit" id="modalsubmit" class="btn btn-default">Save</button>
                      <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                  </div>
            </form>
            </div>
      </div>
    </div>
  </div>
</div>

<!-- END OF MODAL -->                                
                                
                                
                                
                            </div>
                        </div>
                    </div>
                    </div>
                </div>
            </div>
            <?php require_once('footer.php'); ?>
        </div>



<?php require_once('scripts.php'); ?>
<script type="text/javascript">
//JS BY DCARVALLO3
// Remove Selected Primary ESF from Additional ESF table lsit

function UpdateForm(incident, resource) {
    var reqIDField=document.getElementById('ReqResourceID');
    var incIDField=document.getElementById('ReqIncidentID');
    
//Update Modal hidden input
    reqIDField.value=resource;
    incIDField.value=incident;

}
//Modal Validation
 var RequestDateValidityChecks = [
     {
         isInvalid: function(input){
           return input.value=="";  
         },
         invalidityMessage: 'An incident must have a date',
         element: document.querySelector('label[for="RequestDateRequirements"] .input-requirements li:nth-child(1)')
     },
          {
         isInvalid: function(input){
           var pattern= /^((19|20)\d{2})-((0|1)\d{1})-((0|1|2|3)\d{1})/g
              var m = input.value.match(pattern);
                if (!m)
                 return true; //it is invalid
         },
         invalidityMessage: 'An incident must be YYYY-MM-DD',
         element: document.querySelector('label[for="RequestDateRequirements"] .input-requirements li:nth-child(2)')
     }
];

// var RequestDateInput = document.getElementById('ReqIncidentDate');
//var RequestDateInput.CustomValidation = new CustomValidation(RequestDateInput);
//var RequestDateInput.CustomValidation.validityChecks=RequestDateValidityChecks;

// var form = document.getElementById('RequestResourceForm');
// var submit = document.getElementById('modalsubmit');
// submit.addEventListener('click', validate);

</script>
