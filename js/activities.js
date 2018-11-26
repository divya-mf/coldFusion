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
        $activityHead = $("#activityHead"),
        $actError = $("#actError"),
        $value,$tab;

    /**
     * newActivity
     * function called when add activity button is pressed
     * 
    */
    function newActivity(){
      
      $newActivity.show();
      $activityHead.html("ADD ACTIVITY");
      $msg.html("");
      $('#addActivityform')[0].reset();
      $("#actId").val('');
    }



    /**
     * addActivity
     * adds activities
     * @param {int} uid -user id of the selected user.
     * @returns {list}
    */
    function addActivity(){
      var check = validateAfter();
      if(check == true){
        if($("#actId").val() == "") {
           $.ajax({
                url:"../controllers/activitiesController.cfm?action=addActivity",
                type: "POST",
				        datatype: "json",
                data : $("#addActivityform").serialize(),
                
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
                },
                error:function(){
                  $msg.show();   
                  $msg.html("Failed to add activity");
                }
              });
        } 
        else{
          $.ajax({
            url:"../controllers/activitiesController.cfm?action=updateActivity",
            type: "POST",
            datatype: "json",
            data : $("#addActivityform").serialize(),
            
            success: function(fetch) {
              if( JSON.parse(fetch) == 1){
                $newActivity.hide();
                $('#addActivityform')[0].reset();
                $msg.show();   
                $msg.html("Activity Updated successfully");
                getActivities();
                $activityList.show();
                $addActivity.show();
                $("#actId").val('');
              }
              else{
                $msg.show();   
                $msg.html("Failed to update activity");
                $msg.css({"color": "red"});
              }
            },
            error:function(){
              $msg.show();   
              $msg.html("Failed to update activity");
              $msg.css({"color": "red"});
            }
          });

        }
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

      $.ajax({
              url:"../controllers/activitiesController.cfm?action=getAllUsers",
              type: "POST",
		  	      datatype: "json",
              success: function(users)
              {
				        $.each( JSON.parse(users), function( index, value ) {
                  $("#users").append('<option value='+value.ID+'>'+
                   value.FNAME+' ' +value.LNAME+'</option>')
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
              url:"../controllers/activitiesController.cfm?action=getAllActivities",
              type: "POST",
              success: function(activities)
              {
                $.each( JSON.parse(activities), function( index, value ) {
                  $tab=assignStatus(value.status);
                  $id=value.id;
                  $tag= value.priority;
                  
                  $tab.append('<div class="task" id= '+$id+' draggable="true" ondragstart="activityModule.dragStart(event)"> <div class="priority '+$tag+'" title="Priority">'+$tag+' </div> <div class="creationDate">'+ value.createdOn +'</div> <div class="row spread"><div class="col-md-10"><li> <i class="fa fa-comment" title="Title"></i> '+
                     value.title+'</li> <li> <i class="fa fa-user" title="Assigned to" aria-hidden="true"></i> ' +value.fname+' '+value.lname+'</li></div><div class="col-md-2 edit"> <i class="fa fa-edit" title="edit" onclick="activityModule.editActivity('+$id+')"></i> </div></div><div class="dueDate"> Due Date:'+ value.dueDate +'</div></div>');
                
                });

                
              }
            });
    }


    /**
     * drop
     * drop the selected activity in the selected column of status.
     * @param event - related details of the selected activity to change status.
    */
	  
	  function drop(event) {
      var statusColumn,actStatus, data;

      if(event.target.id == "" && event.target.offsetParent.id == "" )
      {
        statusColumn = event.target.offsetParent.offsetParent.id;
      }
      else{
        if(event.target.id == "")
        statusColumn = event.target.offsetParent.id;
        else
        statusColumn = event.target.id;
      }

      actStatus = assignTabStatus(statusColumn);
      event.preventDefault();
      data = event.dataTransfer.getData("Text");
      event.target.appendChild(document.getElementById(data));

      $.ajax({
        url:"../controllers/activitiesController.cfm?action=updateStatus",
        type: "GET",
        datatype: "json",
        data:{
            id: data,
            status : actStatus
        },
        success: function(fetch){
          if(fetch == 1){
            getActivities();
            $msg.html("Status updated successfully.");
            $msg.show();
            setTimeout(function() { $msg.hide(); }, 3000);
          }
          else
          {
            getActivities();
            $msg.show();   
            $msg.html("Failed to update status");
            $msg.css({"color": "red"});
          } 
          
        },
        error: function(){
          getActivities();
            $msg.show();   
            $msg.html("Failed to update status");
            $msg.css({"color": "red"});
        }
      });
      window.scrollTo(0,0)  
    }
  

    /**
     * dragStart
     * drags the selected activity and updates the event details with the selected activity id.
     * @param event - related details of the selected activity to change status.
    */
	  function dragStart(event) {
      var element;
      event.srcElement.id == "" ? element = event.srcElement.offsetParent.id : element = event.srcElement.id;
      event.dataTransfer.setData("Text",element);
    }
    
    
	  /**
     * allowDrop
     * to prevent the browser default handling of the data 
     * @param event - related details of the selected activity to change status.
    */
	  function allowDrop(event) {
    event.preventDefault();
    }
	  

    /**
     * editActivity
     * opens up the window with details of the selected activity to edit.
     * @param {int} aId - id of the selected activity.
     * @returns {url}
    */
    function editActivity(aId) {
      $newActivity.show();
      $activityHead.html("EDIT ACTIVITY");
      var details;
      $.ajax({
        url:"../controllers/activitiesController.cfm?action=getActivityById",
        type: "GET",
        datatype: "json",
        data : {
                id:aId
                },
        success: function(activityDetails)
        {
          details= JSON.parse(activityDetails);
          $("#title").val(details[0].TITLE);
          $("#aPrioirty").val(details[0].PRIORITY);
          $("#users").val(details[0].USERID);
          $("#date").val(details[0].DUEDATE);
          $("#actId").val(aId);
          
        },
        error: function(){
          $actError.html("Error in fetching activity details.");
        }
      });
      
    }


   /**
     * validateAfter
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
     * validates details of activity in runtime
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
        }
      });

      $date.on('input',function(){
        $errorDate.html(" ");
        if ($date.val() == "") {
           $errorDate.html("Fill in due date");
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
      $('#addActivityform')[0].reset();
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
      $tab=assignStatus(status); 
      var data = {
                      status:status,
                      value:value
	  			};

      $.ajax({
              type: "GET",
              url:"../controllers/activitiesController.cfm?action=getActivitiesBySearch",
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
                    $tab.append('<div class="task" id= '+$id+' draggable="true" ondragstart="activityModule.dragStart(event)"> <div class="priority '+$tag+'" title="Priority">'+$tag+' </div> <div class="creationDate">'+ value.createdOn +'</div> <div class="row spread"><div class="col-md-10"><li> <i class="fa fa-comment" title="Title"></i> '+
                    value.title+'</li> <li> <i class="fa fa-user" title="Assigned to" aria-hidden="true"></i> ' +value.fname+' '+value.lname+'</li></div><div class="col-md-2 edit"> <i class="fa fa-edit" title="edit" onclick="activityModule.editActivity('+$id+')"></i> </div></div><div class="dueDate"> Due Date:'+ value.dueDate +'</div></div>');

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
              window.scrollTo(0,0) 
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
     * assignTabStatus
     * function that is being called to assign the status as per column.
     * @param column - status of the activity
     * 
     * @returns {String}
    */
   function assignTabStatus(column){
    var tabStatus;
    if(column == "todo")
    {
        tabStatus="Todo";
    }
    if(column =="inProgress")
    {
      tabStatus="In Progress";
    }
    if(column =="waiting")
    {
      tabStatus="Awaiting QA";
    }
    if(column =="done")
    {
      tabStatus="Done";
    } 

    return tabStatus;
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
      allowDrop:allowDrop,
      editActivity:editActivity
    	}

  })();