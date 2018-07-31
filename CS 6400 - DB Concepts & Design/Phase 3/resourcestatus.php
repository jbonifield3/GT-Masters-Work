<?php session_start();
//PHP by dthai8
    $title = "Resource Report";
    include('lib/common.php');
    $currentuser = $_SESSION['userID'];

    // RETURN RESOURCE BUTTON
    if (!empty($_GET['return_resource'])) 
        {
        $rx_id = mysqli_real_escape_string($db, $_GET['return_resource']);

        $query = "UPDATE Resource 
                SET resource_status_id = 1 
                WHERE resource_id = $rx_id ";
        
        $result = mysqli_query($db, $query);
        include('lib/show_queries.php');
        
        if (mysqli_affected_rows($db) == -1) 
            {
            array_push($error_msg,  "DELETE ERROR: cancel request...<br>" . __FILE__ ." line:". __LINE__ );
            header('url=resourcestatus.php?error=Return Resource Failed');
            }
            header('url=resourcestatus.php?error=Resource Returned Sucessfully');
        }

    // CANCEL/REJECT REQUEST BUTTON
    if (!empty($_GET['cancel_request_rx']) & !empty($_GET['cancel_request_inc'])) 
        {
        $rx_id = mysqli_real_escape_string($db, $_GET['cancel_request_rx']);
        $inc_id = mysqli_real_escape_string($db, $_GET['cancel_request_inc']);

        $query = "DELETE FROM Request 
                WHERE resource_id = $rx_id 
                AND incident_id = $inc_id ";
        
        $result = mysqli_query($db, $query);
        include('lib/show_queries.php');
        
        if (mysqli_affected_rows($db) == -1) 
            {
            array_push($error_msg,  "DELETE ERROR: cancel request...<br>" . __FILE__ ." line:". __LINE__ );
            header('url=resourcestatus.php?error=Request Canelation failed. ');
            }
            else{header('url=resourcestatus.php?msg=Resource Request Rejected Sucessfully');}

        }
    // DEPLOY REQUEST BUTTON
    if (!empty($_GET['deploy_request_rx']) & !empty($_GET['deploy_request_inc'])) 
        {
        $rx_id = mysqli_real_escape_string($db, $_GET['deploy_request_rx']);
        $inc_id = mysqli_real_escape_string($db, $_GET['deploy_request_inc']);

        $query = "UPDATE Resource
                Set resource_status_id = 2
                WHERE resource_id = $rx_id and user_id = $currentuser;";
        
        $result = mysqli_query($db, $query);
        include('lib/show_queries.php');
        
        if (mysqli_affected_rows($db) == -1) 
            {
            array_push($error_msg,  "DELETE ERROR: cancel request...<br>" . __FILE__ ." line:". __LINE__ );
            header(REFRESH_TIME . 'url=resourcestatus.php?error=Resource Deployment Failed. Update Resource Failed.');

            }
        

        $query2 = "UPDATE Request
                    SET deployment_date = CURDATE()
                    WHERE resource_id = $rx_id and incident_id = $inc_id;";
        
        $result2 = mysqli_query($db, $query2);
        include('lib/show_queries.php');
        
        if (mysqli_affected_rows($db) == -1) 
            {
            array_push($error_msg,  "DELETE ERROR: cancel request...<br>" . __FILE__ ." line:". __LINE__ );
            //If updating the request fails, shouldnt you also then undo the previous update where you set the resource status to 2
            header(REFRESH_TIME . 'url=resourcestatus.php?error=Resource Deployment Failed. Update Request Failed. ');
            }
            header(REFRESH_TIME . 'url=resourcestatus.php?msg=Resource Deployed Sucessfully'); 

        }

?>

<?php require_once('header.php'); ?>

<?php require_once('sidebar.php'); ?>
        <div class="main-panel">


            <?php require_once('nav.php'); ?>

            <div class="content">
                    <?php include('lib/show_queries.php');
                      include('lib/error.php'); ?>
<!-- RESOURCE IN USE -->
                <div class="container-fluid">
                    <div class="col-lg-12 col-md-12">
                        <div class="card">
                            
                            <div class="card-header card-header-warning">
                                <h4 class="card-title font-weight-bold">Resource in use by User #<?php echo($currentuser);?> </h4>
                                <!-- <p class="card-category">Resource Report by Primary ESF</p> -->
                            </div>

                            <div class="card-body table-responsive table-bordered" style="align-self: center;">

                                <?php
                                $query="SELECT rx.resource_id `ID`, rx.resource_name `Resource_Name` , 
                                            i.description `Incident`, u.name `Owner`, 
                                            rq.deployment_date `Start_Date`, rq.return_by `Return_By`,
                                            'Return' AS `Action`
                                            FROM Resource rx
                                            JOIN ResourceStatus rs ON (rs.resource_status_id = rx.resource_status_id)
                                            JOIN User u ON (u.user_id = rx.user_id)
                                            JOIN Request rq ON (rq.resource_id = rx.resource_id)
                                            JOIN Incident i ON (i.incident_id = rq.incident_id)
                                            where (i.user_id = $currentuser) AND (rq.deployment_date IS NOT NULL) AND (rx.resource_status_id = 2);";

                                $result = mysqli_query($db, $query);
                                if (is_bool($result) && (mysqli_num_rows($result) == 0) )
                                    {
                                    
                                    array_push($error_msg,"Query ERROR: Failed to get resource report <br>" . __FILE__ ." line:". __LINE__ );
                                    }
                                
                                $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                                $count = mysqli_num_rows($result);

                               if ($count >0) 
                               {                         
                                    print '<table class="table" >';
                                    print '<tr bgcolor="#bbbcb5" class="font-weight-bold" >';
                                    print '<td>ID</td>';
                                    print '<td>Resource Name</td>';
                                    print '<td>Incident</td>';
                                    print '<td>(Resource) Owner</td>';
                                    print '<td>Start Date</td>';
                                    print '<td>Return By</td>';
                                    print '<td>Action</td>';
                                    print '</tr>';

                                    while ($row)
                                        {
                                        $dep_date = date("Y-m-d", strtotime($row['Start_Date']));
                                        print '<tr>';
                                        print '<td>' . $row['ID'] . '</td>';
                                        print '<td>' . $row['Resource_Name'] . '</td>';
                                        print '<td>' . $row['Incident'] . '</td>';
                                        print '<td>' . $row['Owner'] . '</td>';
                                        print '<td>' . $dep_date . '</td>';
                                        print '<td>' . $row['Return_By'] . '</td>';
                                        print '<td><a class="btn-sm btn btn-primary active" role="button" aria-pressed="true" href="resourcestatus.php?return_resource=' . urlencode($row['ID']) . '">Return</a></td>';
                                        print '</tr>';

                                        $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                                        } 

                                    print '</table>';
                                }        else {
                                                echo "No resource in use";
                                            }
                                ?>
                            </div>
                        </div>
                    </div>
                </div>

<!-- RESOURCES REQUESTED BY ME-->
                <div class="container-fluid">
                    <div class="col-lg-12 col-md-12">
                        <div class="card">
                            
                            <div class="card-header card-header-info">
                                <h4 class="card-title font-weight-bold">Resources requested by User #<?php echo($currentuser);?> </h4>
                                <!-- <p class="card-category">Resource Report by Primary ESF</p> -->
                            </div>

                            <div class="card-body table-responsive table-bordered" style="align-self: center;">

                                <?php
                                $query="SELECT rx.resource_id `ID`, rx.resource_name `Resource_Name` ,
                                            i.description `Incident`, u2.name `Owner`, 
                                            rq.return_by `Return_By`, 'Cancel' as `Action`, i.incident_id
                                    FROM Resource rx
                                    JOIN ResourceStatus rs on (rs.resource_status_id = rx.resource_status_id)
                                    JOIN Request rq on (rq.resource_id = rx.resource_id)
                                    JOIN User u on (u.user_id = rq.user_id)
                                    JOIN Incident i on (i.incident_id = rq.incident_id)
                                    INNER JOIN User u2 on (rx.user_id = u2.user_id)
                                    where i.user_id = $currentuser and rq.deployment_date is NULL";

                                $result = mysqli_query($db, $query);
                                if (is_bool($result) && (mysqli_num_rows($result) == 0) )
                                    {
                                    array_push($error_msg,"Query ERROR: Failed to get resource report <br>" . __FILE__ ." line:". __LINE__ );
                                    }
                                
                                $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                                $count = mysqli_num_rows($result);

                               if ($row) 
                               {                         
                                    print '<table class="table" >';
                                    print '<tr bgcolor="#bbbcb5" class="font-weight-bold" >';
                                    print '<td>ID</td>';
                                    print '<td>Resource Name</td>';
                                    print '<td>Incident</td>';
                                    print '<td>(Resource) Owner</td>';
                                    print '<td>Return By</td>';
                                    print '<td>Action</td>';
                                    print '</tr>';

                                    while ($row)
                                        {            
                                        print '<tr>';
                                        print '<td>' . $row['ID'] . '</td>';
                                        print '<td>' . $row['Resource_Name'] . '</td>';
                                        // print '<td>' . 'id#' . $row['incident_id'] .': '. $row['Incident'] . '</td>'; for debugging purpose
                                        print '<td>' . $row['Incident'] . '</td>';
                                        print '<td>' . $row['Owner'] . '</td>';
                                        print '<td>' . $row['Return_By'] . '</td>';
                                        print '<td><a class="btn-sm btn btn-primary active" role="button" aria-pressed="true" href="resourcestatus.php?'. 'cancel_request_rx=' . 
                                            urlencode($row['ID']) . '&cancel_request_inc=' . urlencode($row['incident_id']) . '">Cancel</a></td>';
                                        print '</tr>';

                                        $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                                        }
                                    print '</table>';
                                }  else  {
                                        echo "No request by you";
                                         }        
                                ?>
                            </div>
                        </div>
                    </div>
                </div>

<!-- RESOURCE REQUESTS RECEIVED BY ME-->
                <div class="container-fluid">
                    <div class="col-lg-12 col-md-12">
                        <div class="card">
                            
                            <div class="card-header card-header-primary">
                                <h4 class="card-title font-weight-bold">Resource requests received by User#<?php echo($currentuser);?> </h4>
                                <!-- <p class="card-category">Resource Report by Primary ESF</p> -->
                            </div>

                            <div class="card-body table-responsive table-bordered" style="align-self: center;">

                                <?php
                                $query="SELECT rq.resource_id, rx.resource_name, 
                                            inc.description, u.name `I_Owner`, rq.return_by, 
                                            inc.incident_id, rx.resource_status_id, rq.deployment_date
                                        FROM Request rq 
                                        RIGHT JOIN Resource rx on rq.resource_id = rx.resource_id
                                        RIGHT JOIN Incident inc on rq.incident_id = inc.incident_id
                                        RIGHT JOIN User u on rq.user_id = u.user_id
                                        WHERE rq.incident_id is NOT NULL and rq.deployment_date is NULL and rx.user_id=$currentuser ORDER BY resource_id";

                                $result = mysqli_query($db, $query);
                                if (is_bool($result) && (mysqli_num_rows($result) == 0) )
                                    {
                                    array_push($error_msg,"Query ERROR: Failed to get resource report <br>" . __FILE__ ." line:". __LINE__ );
                                    }
                                
                                $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                                $count = mysqli_num_rows($result);

                               if ($row) 
                               {                         
                                    print '<table class="table" >';
                                    print '<tr bgcolor="#bbbcb5" class="font-weight-bold" >';
                                    print '<td>ID</td>';
                                    print '<td>Resource Name</td>';
                                    print '<td>Incident</td>';
                                    print '<td>(Incident) Owner</td>';
                                    print '<td>Return By</td>';
                                    print '<td>Action</td>';
                                    print '</tr>';

                                    while ($row)
                                        {            
                                        print '<tr>';
                                        print '<td>' . $row['resource_id'] . '</td>';
                                        print '<td>' . $row['resource_name'] . '</td>';
                                        print '<td>' . $row['description'] . '</td>';
                                        print '<td>' . $row['I_Owner'] . '</td>';
                                        print '<td>' . $row['return_by'] . '</td>';
                                        if ( ($row['resource_status_id'] == 1) and ($row['deployment_date'] === NULL) ) 
                                            {                                        
                                            print '<td>
                                                    <a class="btn-sm btn btn-primary active" role="button" aria-pressed="true" href="resourcestatus.php?'. 'deploy_request_rx=' . 
                                                        urlencode($row['resource_id']) . '&deploy_request_inc=' . urlencode($row['incident_id']) . '"> Deploy </a>
                                                    <a class="btn-sm btn btn-primary active" role="button" aria-pressed="true" href="resourcestatus.php?'. 'cancel_request_rx=' . 
                                                        urlencode($row['resource_id']) . '&cancel_request_inc=' . urlencode($row['incident_id']) . '"> Reject </a>
                                                    </td>';
                                            } elseif (($row['resource_status_id'] == 2) and ($row['deployment_date'] === NULL) ) 
                                                {
                                                print '<td>
                                                    <a class="btn-sm btn btn-primary active" role="button" aria-pressed="true" href="resourcestatus.php?'. 'cancel_request_rx=' . 
                                                        urlencode($row['resource_id']) . '&cancel_request_inc=' . urlencode($row['incident_id']) . '"> Reject </a>
                                                    </td>';
                                                } else {print '<td>Already deployed</td>';}

                                        print '</tr>';

                                        $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                                        }
                                    print '</table>';
                                }     else  {
                                        echo "No request to you";
                                         }           
                                ?>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <?php require_once('footer.php'); ?>
        </div>

<?php require_once('scripts.php'); ?>
