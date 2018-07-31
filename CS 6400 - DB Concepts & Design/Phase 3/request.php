<?php session_start();
//PHP by dcarvallo3
$currentuser=$_SESSION['userID'];
  include('lib/common.php'); 
	if( $_SERVER['REQUEST_METHOD'] == 'POST') 
    {
    $enteredRID = $_POST['ReqResourceID'];
		$enteredID = $_POST['ReqIncidentID'];
		$enteredDate = $_POST['ReqIncidentDate'];
  	if( !empty($enteredRID)&& !empty($enteredID) && !empty($enteredDate))
    {

    $insert_query="INSERT INTO Request (incident_id, resource_id, user_id, return_by) Values ('$enteredID','$enteredRID','$currentuser', '$enteredDate')";
	 	$result = mysqli_query($db, $insert_query);
  	if (mysqli_affected_rows($db) == -1) 
      {
      array_push($error_msg,  "INSERT ERROR: deploy request...<br>" . __FILE__ ." line:". __LINE__ );
      header(REFRESH_TIME . 'url=searchresults.php?error=INSERT INTO Request (incident_id, resource_id, return_by) Values ('.$enteredID.','.$enteredRID.', '.$enteredDate.')');

      } else 
        {
          header(REFRESH_TIME . 'url=searchresults.php?msg=Sucessfully requested Resource: '. urlencode($enteredRID).', Incident:'.urlencode($enteredID). ', Due back to us:'.urlencode($enteredDate));
        }
    } else 
      {
        header(REFRESH_TIME . 'url=searchresults.php?error=Not all Inputs provided');
      }
    }
?>