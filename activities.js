  /**
   * @activities.js
   * Provides different operations related to activity list
   *
   * handles different events fired from the activity page by the user
   */
  var activityModule = (function () {
    
    var $description=$("#description"),
        $date=$("#date"),
        $errorDate=$("#errorDate"),
        $error=$("#error"),
        $activityList=$("#activityList"),
        $todo=$("#todo"),
        $inProgress=$("#inProgress"),
        $waiting=$("#waiting"),
        $done=$("#done"),
        $newActivity=$("#newActivity"),
        $addActivity=$("#addActivity"),
        $msg=$("#msg"),
        $tsearch = $("#todoSearch"),
        $wsearch = $("#waitSearch"),
        $psearch = $("#progSearch"),
        $dsearch = $("#doneSearch"),
        $gsearch = $("#global"),
        $value,$tab;

    /**
     * newActivity
     * function called when add activity button is pressed
     * 
    */
    function newActivity(){
      $activityList.hide();
      $addActivity.hide();
      $newActivity.show();
	  $msg.html("");
    }



    /**
     * addActivity
     * adds activities
     * @param {int} uid -user id of the selected user.
     * @returns {list}
    */
    function addActivity(){
      var check = validateAfter();
	 var data = {
                        "title": $description.val(),
                        "userId":$('#users option:selected').val(),
                        "priority":$('#aPrioirty option:selected').val(),
                        "dueDate":$date.val(),

                      };
      if(check == true){
        $.ajax({
                url:"./controllers/activitiesController.cfm?action=addActivity",
                type: "POST",
				datatype: "json",
                data: data,
                
                success: function(fetch) {
                  if( JSON.parse(fetch) == 1){
                    $newActivity.hide();
                    $('form')[0].reset();
                    $msg.show();   
                    $msg.html("Activity added successfully");
                    getActivities();
                    $activityList.show();
                    $addActivity.show();
                  }
                  else{
                    $msg.show();   
                    $msg.html("Failed to add activity");
                  }
                }
              }); 
      }
      else{
        if( $description.val() == '') {
          $error.html("Fill in description");
        }
        if( $date.val() == '') {
          $errorDate.html("Fill in due date");
        }
      }
    }

    /**
     * getAllUsers
     * function that does ajax call and fetch all users.
     * 
     * @returns {array}
    */
    function getAllUsers(){
      var users=[];

      $.ajax({
              url:"./controllers/activitiesController.cfm?action=getAllUsers",
              type: "POST",
		  	  datatype: "json",
              success: function(users)
              {
                   $.each( JSON.parse(users), function( index, value ) {
                  $("#users").append('<option value='+value.id+'>'+
                   value.fname+' ' +value.lname+'</option>')
                });
                
              }
            });
    }

    /**
     * getAllActivities
     * function that does ajax call and fetch all activities.
     * 
     * @returns {array}
    */
    function getActivities(){
      var activities=[];

      $todo.html("");
      $inProgress.html("");
      $waiting.html("");
      $done.html("");

      $.ajax({
              url:"./controllers/activitiesController.cfm?action=getAllActivities",
              type: "POST",
              success: function(activities)
              {
                $.each( JSON.parse(activities), function( index, value ) {
                  $tab=assignStatus(value.status);
                  $id=value.id;
                  $tag= value.priority;
                  
                  $tab.append('<div class="task" draggable="true" ondragstart="activityModule.dragStart(event)"> <div class="priority" title="Priority" id='+$id+'>'+$tag+' </div> <div class="creationDate">'+ value.createdOn +'</div> <li> <i class="fa fa-comment" title="Title"></i> '+
                     value.title+'</li> <li> <i class="fa fa-user" title="Assigned to" aria-hidden="true"></i> ' +value.fname+' '+value.lname+'</li><div class="dueDate"> Due Date:'+ value.dueDate +'</div></div>');
                  $('#' + $id).addClass($tag);
                });

                
              }
            });
    }
	  
	  function drop(event) {
		  console.log("dropped");
		console.log(event.srcElement.id);
		  console.log( event.dataTransfer.getData("Text"));
		/*event.preventDefault();
		var data = event.dataTransfer.getData("Text");
		event.target.appendChild(document.getElementById(data));
		document.getElementById("demo").innerHTML = "The p element was dropped";*/
	}
	  function dragStart(event) {
		   console.log("drag");
		  console.log(event.srcElement.childNodes[1].id);
    event.dataTransfer.setData("Text",event.srcElement.childNodes[1].id);
    /*document.getElementById("demo").innerHTML = "Started to drag the p element";*/
	  }
	  
	  function allowDrop(ev) {
    ev.preventDefault();
}
	  


    /**
     * getBaseUrl
     * captures the base url.
     * 
     * @returns {url}
    */
    function getBaseUrl() {
      var re = new RegExp(/^.*\//);
      return re.exec(window.location.href);
    }


   /**
     * validate
     * validates description and due date of activity
     * 
     * @returns {boolean value}
    */ 
    function validateAfter(){

      if( $description.val() == '' && $date.val() == ''){
       $error.html("Fill in description");
       $errorDate.html("Fill in due date");
      }
      if( $description.val() == '' || $date.val() == ''){
       return false;
      }
      

      else{ 
        return true;
      }

    }


    /**
     * validate
     * validates description of activity
     * 
     * @returns {boolean value}
    */ 
    function validate(){
      $date.prop('min', function(){
          return new Date().toJSON().split('T')[0];
      });

      $description.on('input',function(){
        $error.html(" ");
        if ($description.val() == "") {
           $error.html("Fill in description");
           //$error.show();
        }
      });

      $date.on('input',function(){
        $errorDate.html(" ");
        if ($date.val() == "") {
           $errorDate.html("Fill in due date");
           //$error.show();
        }
      });
    }  


    /**
     * back
     * cancels adding new activity and brings back to activity list
     * 
     * @returns {boolean value}
    */ 
    function back(){
      $activityList.show();
      $addActivity.show();
      $newActivity.hide();
    } 


    /**
     * search - Operations related to search functionality.
     * 
     *
    */
    
    function search(){
      $tsearch.on("keyup", function() {
        $value = $(this).val().toLowerCase();
        $status="Todo";
        getActivityBySearch($status,$value);
        
      });

      $wsearch.on("keyup", function() {
        $value = $(this).val().toLowerCase();
        $status="Awaiting QA"
        getActivityBySearch($status,$value);
      });

      $psearch.on("keyup", function() {
        $value = $(this).val().toLowerCase();
        $status="In Progress"
        getActivityBySearch($status,$value);
        
      });

      $dsearch.on("keyup", function() {
        $value = $(this).val().toLowerCase();
        $status="Done"
        getActivityBySearch($status,$value);
        
      });

      $gsearch.on("keyup", function() {
        $tsearch.val("");
        $wsearch.val("");
        $psearch.val("");
        $dsearch.val("");
        $value = $(this).val().toLowerCase();
        $status="";
        $value=="" ? getActivities() : getActivityBySearch($status,$value);
        
      });


    }

    function getActivityBySearch(status, value){
      var activities=[];

      $tab=assignStatus(status);  
      var data = {
                      status:status,
                      value:value
	  			};

      $.ajax({
		      type: "GET",
              url:"./controllers/activitiesController.cfm?action=getActivitiesBySearch",
		  	  dataType: "json",
              data: data,
                
              success: function(activities)
              { 

                if(status=="")
                {
                  $todo.html("");
                  $inProgress.html("");
                  $waiting.html("");
                  $done.html("");
                }
                else{
                     $tab.html("");
                }

                if(activities!="")
                  {
                    $.each(activities, function( index, value )
                    {
                        if(status=="")
                        { 
                          $tab=assignStatus(value.status);
                        }

                        $id=value.id;
                        $tag= value.priority;
                        $tab.append('<div class="task"> <div class="priority" title="Priority" id='+$id+'>'+$tag+' </div> <div class="creationDate">'+ value.createdOn +'</div> <li> <i class="fa fa-comment" title="Title"></i> '+
                                   value.title+'</li> <li> <i class="fa fa-user" title="Assigned to" aria-hidden="true"></i> ' +value.fname+' '+value.lname+'</li><div class="dueDate"> Due Date:'+ value.dueDate +'</div></div>');
						
                        $('#' + $id).addClass($tag);
                      });
                }
                else
                {
                  $msg="No Records Found";

                  if(status=="")
                    {
                      $todo.html($msg);
                      $inProgress.html($msg);
                      $waiting.html($msg);
                      $done.html($msg);
                    }
                    else
                    {
                      $tab.html($msg);
                    }
                }
                
              },
            error: function (error) {
              console.log(error);
            }
		  
            });

    }


    /**
     * assignStatus
     * function that is being called to assign the column as per status.
     * @param status - status of the activity
     * 
     * @returns {String}
    */
    function assignStatus($status){
      if($status == "Todo")
      {
          $tab= $todo;
      }
      if($status =="In Progress")
      {
        $tab=$inProgress;
      }
      if($status =="Awaiting QA")
      {
         $tab=$waiting;
      }
      if($status =="Done")
      {
        $tab=$done;
      } 

      return $tab;
    }
	  
	


    /**
     * init
     * function that is being called at the time of loading file.
     * 
     * @returns {boolean value}
    */
    function init(){
     getAllUsers();
     validate();
     getActivities();
     search();


    }

    return{
    		
    	init:init,
        newActivity:newActivity,
        addActivity:addActivity,
        back:back,
		dragStart:dragStart,
		drop:drop,
		allowDrop:allowDrop
		
    	}

  })();