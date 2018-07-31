<?php session_start();
//PHP by dthai8
    $title = "Resource Report";
    include('lib/common.php');
?>

<?php require_once('header.php'); ?>

<?php require_once('sidebar.php'); ?>
        <div class="main-panel">
            <?php require_once('nav.php'); ?>

            <div class="content">
                    <?php include('lib/show_queries.php');
                      include('lib/error.php'); ?>

                <div class="container-fluid">
                    <div class="col-lg-12 col-md-12">
                        <div class="card">
                            
                            <div class="card-header card-header-warning">
                                <h4 class="card-title">Resource Report for User <?php echo($currentuser);?> </h4>
                                <p class="card-category">Resource Report by Primary ESF</p>
                            </div>

                            <div class="card-body table-responsive table-bordered" style="align-self: center;">

                                <?php
                                $currentuser = $_SESSION['userID'];
                                $query="SELECT e.esf_id, 
                                               e.description, 
                                               COUNT(r.resource_status_id) total_resources,
                                               SUM(IF(r.resource_status_id=2, 1, 0)) resources_in_use 
                                        FROM `ESF` e
                                        LEFT JOIN `Resource` r ON (e.esf_id = r.primary_esf_id) AND (r.user_id = $currentuser) GROUP BY e.esf_id";

                                $result = mysqli_query($db, $query);
                                if (is_bool($result) && (mysqli_num_rows($result) == 0) )
                                    {
                                    array_push($error_msg,"Query ERROR: Failed to get resource report <br>" . __FILE__ ." line:". __LINE__ );
                                    }
                                
                                $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                                $count = mysqli_num_rows($result);
                                $totalr = 0;
                                $totaluse = 0;

                               if ($row) 
                               {                         
                                    print '<table class="table" >';
                                    print '<tr bgcolor="#bbbcb5" class="font-weight-bold" >';
                                    print '<td>ESF#</td>';
                                    print '<td>Primary ESF</td>';
                                    print '<td>Total Resources</td>';
                                    print '<td>Resources in Use</td>';
                                    print '</tr>';

                                    while ($row)
                                        {            
                                        print '<tr>';
                                        print '<td>' . $row['esf_id'] . '</td>';
                                        print '<td>' . $row['description'] . '</td>';
                                        print '<td>' . $row['total_resources'] . '</td>';
                                        $totalr += $row['total_resources'];
                                        print '<td>' . $row['resources_in_use'] . '</td>';
                                        $totaluse += $row['resources_in_use'];
                                        print '</tr>';

                                        $row = mysqli_fetch_array($result, MYSQLI_ASSOC);
                                        }

                                    print '<tr bgcolor="#bbbcb5" class="font-weight-bold" >';
                                    print '<td></td>';
                                    print '<td>Grand Total</td>';
                                    print '<td>' . $totalr . '</td>';
                                    print '<td>' . $totaluse . '</td>';
                                    print '</tr>';
                                    print '</table>';
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
