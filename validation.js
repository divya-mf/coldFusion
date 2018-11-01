/**
 * @validation.js
 * Provides validations to the data entered in the form fields
 *
 * if validation succeeds proceeds to register user
 */
 
var formModule = (function () {
	var $fName = $('#fname'),
		$lName = $('#lname'),
		$db =$('#db'),
		$email = $('#email'),
		$pw = $('#pw'),
		$pw_c = $('#pw_confirm'),
		$success =$('#success'),
		$fError=$("#fError"),
		$lError=$("#lError"),
		$dbError=$("#dbError"),
		$mailError=$("#mailError"),
		$pwError=$("#pwError"),
		$pwcError=$("#pwcError"),
		$bGroup = $("#bGroup"),
		$submit= $("#submit"),
        $valid;

		
	/**
	 * validates form fields
	 * 
	 * 
	 * @returns {boolean value}
	*/
   function validateForm() {
		var fName = $fName.val(),
			lName =$lName.val(),
			db =$db.val(),
			email = $email.val(),
			pw = $pw.val(),
			pw_c = $pw_c.val(),
			error=0;
			
		clearErrors();
		
		if (fName == "") {
			error=1;
			$fError.html("Fill in your first name");
			$fError.show();
		}
		
		if (lName == "") {
		   $lError.html("Fill in your last name");
		   if(error==1)
		   {
			  $lError.css("margin-left", "110px"); //change in position with respect to the length of the message.
		   }else{
			   $lError.css("margin-left", "224px");
		   }
		   $lError.show();
		    error=1;
		}
	
		if (db == "") {
		   error=1;
		   $dbError.html("Fill in your date of birth");
		}
		
		if (email == "") {
			error=1;
			$mailError.html("Fill in your email");
			$mailError.show();
		}
		
		if (pw == "" ) {
		   error=1;
		   $pwError.html("Please set a password");
		   $pwError.show();
		}
       if (pw != "" && pw_c == "" ) {
		   error=1;
           $pwcError.css("margin-left", "130px");
		   $pwcError.html("Please confirm password");
		   $pwcError.show();
		}
		
		if(error == 1){
			$success.hide();  
			$(window).scrollTop(0);	//scrolls the browser window to the top of the page to show errors.
			return false;
		}
		
		
	    return insertData(fName,lName,db,email,pw);
		

	}
	
	
	/**
	 * Displays the form data in a tabular structure
	 * 
	 * @param {string} fname - first name from the form data
	 * @param {string} lname - last name from the form data
	 * @param {string} db - date of birth from the form data
	 * @param {string} email - email id of the user
	 * @param {string} pw - password of the user
	*/
	
	function insertData(fname,lname,db,email,pw){
       
		var email = emailToLowerCase(email);
		var gender = $("input[name='gender']:checked").val();
		var bGroup = $bGroup.val(); 
		var data = {
		  "fname": fname,
		  "lname" :lname,
		  "db"	: db,
		  "email" :email,
		  "gender" :gender,
		  "blood_group" :bGroup,
		  "password" :pw
		  
		};

		//ajax to call a cf file which adds information of user to database.
		$.ajax({
		  type: "POST",
		  url: "./register.cfm",
          contentType: "application/json",
          data: JSON.stringify( data ),
		 // data: data,
		 // dataType: "json",
		  success: function(fetch) {
			if( jQuery.parseJSON(fetch) == 1){
                $valid = 1;
                clearForm();
                window.location = "http://127.0.0.1:8500/CFAssignments/login.cfm";
				/*var msg ="Registered Successfully";
				$success.html(msg);
				$success.show();
				$(window).scrollTop(1000);*/
                
			}
			else{
				$success.hide();
				$mailError.html("Email already exists");
				$mailError.css("margin-left", "275px");
				$mailError.show();
                $valid = 0;
                return false;
				}
             
		  },
		  error:function(data)
		  {
		  	console.log("error"+data);
            $valid = 0;
		  }
		});  
       
    
	}


	
	/**
	 * clears the form, scrolls to the top of the window, hides the messages.
	 * 
	*/	
	function clearForm(){
		$('form')[0].reset();
		$(window).scrollTop(0); //scrolls the browser window to the top of the page after clearing inputs
		$submit.html("Register");
		$success.hide();
		clearErrors();
	}
	
	
	/**
	 * emailToLowerCase -converts the email id to lower case
	 * @param {string} email - email id entered by the user.
	 *
	 *  @returns {converted email string}
	*/
	function emailToLowerCase(email){
		email = email.toLowerCase();
		return email;
	}
	
	
	/**
	 * clearErrors - clears all the errors.
	 * 
	 *
	*/	
	function clearErrors()
	{	$pwcError.html("");
		$pwError.html("");
		$dbError.html("");
		$mailError.html("");
		$lError.html("");
		$fError.html("");
	}
	
	
	/**
	 * checkErrors - checks all the errors in email and birth date fields.
	 * 
	 *
	*/
	function checkErrors(){
		var error=0; 
		var email =$email.val();
		var at = email.indexOf("@");
		var dot = email.lastIndexOf(".");
		
		$email.on('keyup',function(){
			error=0;
			$mailError.hide();
			if(email != ""){
				if (at < 1  || /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)+$/.test(email)== false){
					$mailError.show();
					$mailError.html("Please enter a valid email ID");
					$mailError.css("margin-left", "230px");
					error=1;
				}
			}
		});
		
		$db.on("focus", function() {
			$dbError.html("");
		});

		//disables the submit button if there are any errors.
		$(".container").on('keyup',function(){
			error == 1 ? $submit.prop('disabled', true):$submit.prop('disabled', false) ; 
		});
	}
	
	/**
	 * checkPasswords - checks all the errors in password fields.
	 * 
	 *
	*/
	function checkPasswords(){
		$pw.on("keyup", function() {
			$pwError.hide();
		});
		
		$pw_c.on('keyup',function(){
			error=0;
			$pwcError.hide();
			var pw= $pw.val();
			var pw_c=$pw_c.val();
			if (pw != pw_c) {
				error=1;
				$pwcError.html("Password mismatch");
				$pwcError.show();
			}
		});
		
	}
	
	/**
	 * checkNames - checks all the errors in name fields.
	 * 
	 *
	*/
	
	function checkNames(){
		$fName.on('input',function(){
			var  status;
			var fName = $fName.val();
			$error=0;
			$fError.hide();
			
			if (fName == "") {
				 $fError.html("Fill in your first name");
				 $fError.show();
				 $lError.css("margin-left", "110px");
				 error=1;
			}
			
			status=validateName(fName);
			
			if(status){
				$fError.html("Invalid name")
				$fError.show();
				$lError.css("margin-left", "110px");
				error=1;
			}

		});
		
		$lName.on('input',function(){
			var lName = $lName.val();
			var  status;
			$error=0;
			$lError.hide();
			if (lName == "") {
				 $lError.css("margin-left", "190px");
				 $lError.html("Fill in your last name");
				 $lError.show();
				  error=1;
				 
			}
			
			status=validateName(lName);
			
			if(status){
				$lError.css("margin-left", "190px");
				$lError.html("Invalid name")
				$lError.show();
				error=1;
			}

		});
	}
	
	
	/**
	* validateName - validates the entered name
	* @param {string} name - first name when called from the
	* event fired when first name is enetered and last name
	* if called from the event fired when last name is entered.
    *
	*  @returns {boolean value}
   */	
	function validateName(name)
	{
		if(name != "" && /^[a-zA-Z]+$/.test( name ) == false){
			error=1;
			return true;
		}
	}

	function init() {
		checkErrors();
		checkNames();
		checkPasswords();
	}
	
	
	
	return{
		validateForm:validateForm,
		clearForm:clearForm,
		init : init
	}
})();
 