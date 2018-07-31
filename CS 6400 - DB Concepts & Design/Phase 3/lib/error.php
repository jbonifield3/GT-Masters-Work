 
 	<?php if($error_msg) {  ?>
		<div class='alert alert-danger alert-dismissible fade show' role="alert">
		      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
			 <div class='error_msg'>
				<?php
					foreach ($error_msg as $error) {
						echo $error . NEWLINE;
					 }
				?>
			</div>
		</div>
	<?php  } ?>
	
    <?php if($query_msg) {  ?>
    <div class='alert alert-info alert-dismissible fade show' role="alert">
          <button type="button" class="close" data-dismiss="alert" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
         <div class='query_msg'>
            <?php
                foreach ($query_msg as $query) {
                    echo $query . NEWLINE;
                 }
            ?>
        </div>
    </div>
	<?php } ?>
	
            <?php if($_REQUEST['msg']!=null) {  ?>
                <div class='alert alert-success alert-dismissible fade show' role="alert">
                      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                      </button>
                     <div class='query_msg'>
                        <?php

                                echo $_REQUEST['msg'];
                             
                        ?>
                    </div>
                </div>
	            <?php } ?> 
	            <?php if($_REQUEST['error']!=null) {  ?>
                <div class='alert alert-danger alert-dismissible fade show' role="alert">
                      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                      </button>
                     <div class='query_msg'>
                        <?php

                                echo $_REQUEST['error'];
                             
                        ?>
                    </div>
                </div>
	            <?php } ?>