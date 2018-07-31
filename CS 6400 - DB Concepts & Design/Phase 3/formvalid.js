
/* ----------------------------
	CustomValidation prototype
	- Keeps track of the list of invalidity messages for this input
	- Keeps track of what validity checks need to be performed for this input
	- Performs the validity checks and sends feedback to the front end
---------------------------- */

function validateDate(testdate) {
    var date_regex = /^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(19|20)\d{2}$/ ;
    return date_regex.test(testdate);
}

function CustomValidation(input) {
	this.invalidities = [];
	this.validityChecks = [];
	this.Label="";

	//add reference to the input node
	this.inputNode = input;

	//trigger method to attach the listener
	this.registerListener();
}

CustomValidation.prototype = {
	addInvalidity: function(message) {
		this.invalidities.push(message);
	},
	getInvalidities: function() {
		return this.invalidities.join('. \n');
	},
	checkValidity: function(input) {
		for ( var i = 0; i < this.validityChecks.length; i++ ) {

			var isInvalid = this.validityChecks[i].isInvalid(input);
			if (isInvalid) {
				this.addInvalidity(this.validityChecks[i].invalidityMessage);
			}

			var requirementElement = this.validityChecks[i].element;

			if (requirementElement) {
				if (isInvalid) {
					requirementElement.classList.add('invalid');
					requirementElement.classList.remove('valid');
				} else {
					requirementElement.classList.remove('invalid');
					requirementElement.classList.add('valid');
				}

			} // end if requirementElement
		} // end for
	},
	checkInput: function() { // checkInput now encapsulated

		this.inputNode.CustomValidation.invalidities = [];
		this.checkValidity(this.inputNode);

		if ( this.inputNode.CustomValidation.invalidities.length === 0 && this.inputNode.value !== '' ) {
			this.inputNode.setCustomValidity('');
		} else {
			var message = this.inputNode.CustomValidation.getInvalidities();
			this.inputNode.setCustomValidity(message);
		}
	},
	registerListener: function() { //register the listener here

		var CustomValidation = this;

		this.inputNode.addEventListener('keyup', function() {
			CustomValidation.checkInput();
		});
		this.inputNode.addEventListener('click', function() {
			CustomValidation.checkInput();
		});


	}

};



/* ----------------------------
	Validity Checks
	The arrays of validity checks for each input
	Comprised of three things
		1. isInvalid() - the function to determine if the input fulfills a particular requirement
		2. invalidityMessage - the error message to display if the field is invalid
		3. element - The element that states the requirement
---------------------------- */

var ResourceNameValidityChecks = [
	{
		isInvalid: function(input) {
			return input.value.length < 3;
		},
		invalidityMessage: 'This input needs to be at least 3 characters',
		element: document.querySelector('label[for="ResourceNameRequirements"] .input-requirements li:nth-child(1)')
	},
	{
		isInvalid: function(input) {
			var pattern = input.value.match(/^[a-zA-Z0-9\s]*$/g);
			var m = input.value.match(pattern);
    		if (!m){
    		return true;}else{return false} //it is invalid
		},
		invalidityMessage: 'Only letters and numbers are allowed',
		element: document.querySelector('label[for="ResourceNameRequirements"] .input-requirements li:nth-child(2)')
	}
];
 var PrimaryESFValidityChecks = [
     {
         isInvalid: function(input){
           return input.value=="";  
         },
         invalidityMessage: 'A resource must have an ESF',
         element: document.querySelector('label[for="PrimaryESFRequirements"] .input-requirements li:nth-child(1)')
     }
];

var CapabilityValidityChecks = [
	{
		isInvalid: function(input) {
			return input.value != null;
		},
		invalidityMessage: 'Capabilities must be separated by a comma',
		element: document.querySelector('label[for="CapabilitiesRequirements"] .input-requirements li:nth-child(1)')
	}
];

var LatitudeValidityChecks =[
	{
		isInvalid: function(input){
			if(input.value >90 || input.value< -90){
			return true}
			else
			{return false}
		},
		invalidityMessage: 'This input needs to be between -90 and 90',
		element: document.querySelector('label[for="LatitudeRequirements"] .input-requirements li:nth-child(1)')
	},
	{
		isInvalid: function(input){
			var pattern = /(?<=^| )(-?)\d+(\.\d+)?(?=$| )|(?<=^| )\.\d+(?=$| )/g
			var m = input.value.match(pattern);
    		if (!m){
    		return true;}else{return false} //it is invalid
		},
		invalidityMessage: 'This input needs to be a number',
		element: document.querySelector('label[for="LatitudeRequirements"] .input-requirements li:nth-child(2)')
	}
	
];
var LongitudeValidityChecks =[
	{
		isInvalid: function(input){
			if(input.value >180 || input.value< -180){
			return true}
			else
			{return false}
		},
		invalidityMessage: 'This input needs to be between -180 and 180',
		element: document.querySelector('label[for="LongitudeRequirements"] .input-requirements li:nth-child(1)')
	},
	{
		isInvalid: function(input){
			var pattern = /(?<=^| )(-?)\d+(\.\d+)?(?=$| )|(?<=^| )\.\d+(?=$| )/g
			var m = input.value.match(pattern);
    		if (!m){
    		return true;}else{return false} //it is invalid
		},
		invalidityMessage: 'This input needs to be a number',
		element: document.querySelector('label[for="LongitudeRequirements"] .input-requirements li:nth-child(2)')
	}
	
];

var MaxDistanceValidityChecks =[
	{
		isInvalid: function(input){
			return input.value < 0;
		},
		invalidityMessage: 'This input needs to be greater than 0',
		element: document.querySelector('label[for="DistanceRequirements"] .input-requirements li:nth-child(1)')
	},
	{
		isInvalid: function(input){
			var pattern = /(?<=^| )\d+(\.\d+)?(?=$| )|(?<=^| )\.\d+(?=$| )/g
			var m = input.value.match(pattern);
    		if (!m){
    		return true;}else{return false} //it is invalid
		},
		invalidityMessage: 'This input needs to be a number',
		element: document.querySelector('label[for="DistanceRequirements"] .input-requirements li:nth-child(2)')
	}
	
];

var CostValidityChecks =[
	{
		isInvalid: function(input){
			return input.value < 0;
		},
		invalidityMessage: 'This input needs to be greater than 0',
		element: document.querySelector('label[for="CostRequirements"] .input-requirements li:nth-child(1)')
	},
	{
		isInvalid: function(input){
			var pattern = /(?<=^| )\d+(\.\d+)?(?=$| )|(?<=^| )\.\d+(?=$| )/g
			var m = input.value.match(pattern);
    		if (!m){
    		return true;}else{return false} //it is invalid
		},
		invalidityMessage: 'This input needs to be a number',
		element: document.querySelector('label[for="CostRequirements"] .input-requirements li:nth-child(2)')
	}
	
];
/* INCIDENT ID VALIDTY CHECKS */


 var IncidentDeclarationValidityChecks = [
     {
         isInvalid: function(input){
           return input.value=="";  
         },
         invalidityMessage: 'An incident must have a declaration',
         element: document.querySelector('label[for="IncidentDeclarationRequirements"] .input-requirements li:nth-child(1)')
     }
];
 var IncidentDateValidityChecks = [
     {
         isInvalid: function(input){
           return input.value=="";  
         },
         invalidityMessage: 'An incident must have a date',
         element: document.querySelector('label[for="IncidentDateRequirements"] .input-requirements li:nth-child(1)')
     },
          {
         isInvalid: function(input){
           var pattern= /^((19|20)\d{2})-((0|1)\d{1})-((0|1|2|3)\d{1})/g
              var m = input.value.match(pattern);
    			if (!m)
    			 return true; //it is invalid
         },
         invalidityMessage: 'An incident must be YYYY-MM-DD',
         element: document.querySelector('label[for="IncidentDateRequirements"] .input-requirements li:nth-child(2)')
     }
];
 var IncidentDescriptionValidityChecks = [
     {
         isInvalid: function(input){
           return input.value=="";  
         },
         invalidityMessage: 'An incident must have a description',
         element: document.querySelector('label[for="IncidentDescriptionRequirements"] .input-requirements li:nth-child(1)')
     }
];
var ILatitudeValidityChecks =[
	{
		isInvalid: function(input){
			if(input.value >90 || input.value< -90){
			return true}
			else
			{return false}

		},
		invalidityMessage: 'This input needs to be between -90 and 90',
		element: document.querySelector('label[for="IncidentLatitudeRequirements"] .input-requirements li:nth-child(1)')
	},
	{
		isInvalid: function(input){
			var pattern = /(?<=^| )(-?)\d+(\.\d+)?(?=$| )|(?<=^| )\.\d+(?=$| )/g
			var m = input.value.match(pattern);
    		if (!m){
    		return true;}else{return false} //it is invalid
		},
		invalidityMessage: 'This input needs to be a number',
		element: document.querySelector('label[for="IncidentLatitudeRequirements"] .input-requirements li:nth-child(2)')
	}
	
];
var ILongitudeValidityChecks =[
	{
		isInvalid: function(input){
			if(input.value >180 || input.value< -180){
			return true}
			else
			{return false}
		},
		invalidityMessage: 'This input needs to be between -180 and 180',
		element: document.querySelector('label[for="IncidentLongitudeRequirements"] .input-requirements li:nth-child(1)')
	},
	{
		isInvalid: function(input){
			var pattern = /(?<=^| )(-?)\d+(\.\d+)?(?=$| )|(?<=^| )\.\d+(?=$| )/g
			var m = input.value.match(pattern);
    		if (!m){
    		return true;}else{return false} //it is invalid
		},
		invalidityMessage: 'This input needs to be a number',
		element: document.querySelector('label[for="IncidentLongitudeRequirements"] .input-requirements li:nth-child(2)')
	}
	
];
/* ----------------------------
	Setup CustomValidation
	Setup the CustomValidation prototype for each input
	Also sets which array of validity checks to use for that input
---------------------------- */

if(document.title=="Add Resource"){
var ResourceNameInput = document.getElementById('inputResourceName');
var PrimaryESFInput = document.getElementById('R_PrimaryESF');
//var CapabilityInput = document.getElementById('main-input');
var LatitudeInputs = document.getElementById('R_Latitude');
var LongitudeInputs = document.getElementById('R_Longitude');
var MaxDistanceInputs = document.getElementById('R_MaxDistance');
var CostInputs = document.getElementById('R_Cost');

ResourceNameInput.CustomValidation = new CustomValidation(ResourceNameInput);
ResourceNameInput.CustomValidation.validityChecks = ResourceNameValidityChecks;

PrimaryESFInput.CustomValidation = new CustomValidation(PrimaryESFInput);
PrimaryESFInput.CustomValidation.validityChecks=PrimaryESFValidityChecks;

//CapabilityInput.CustomValidation = new CustomValidation(CapabilityInput);
//CapabilityInput.CustomValidation.validityChecks=CapabilityValidityChecks;
LatitudeInputs.CustomValidation = new CustomValidation(LatitudeInputs);
LatitudeInputs.CustomValidation.validityChecks=LatitudeValidityChecks;

LongitudeInputs.CustomValidation = new CustomValidation(LongitudeInputs);
LongitudeInputs.CustomValidation.validityChecks=LongitudeValidityChecks;

MaxDistanceInputs.CustomValidation = new CustomValidation(MaxDistanceInputs);
MaxDistanceInputs.CustomValidation.validityChecks=MaxDistanceValidityChecks;

CostInputs.CustomValidation = new CustomValidation(CostInputs);
CostInputs.CustomValidation.validityChecks=CostValidityChecks;


var form = document.getElementById('addform');
};

if(document.title=="Add Incident"){
var IncidentDeclarationInput = document.getElementById('I_Declaration');
var IncidentDateInput = document.getElementById('inputIncidentDate');
var LatitudeInputs = document.getElementById('I_Latitude');
var LongitudeInputs = document.getElementById('I_Longitude');
var IncidentDescription=document.getElementById('inputIncidentDescription');

IncidentDeclarationInput.CustomValidation = new CustomValidation(IncidentDeclarationInput);
IncidentDeclarationInput.CustomValidation.validityChecks=IncidentDeclarationValidityChecks;

IncidentDateInput.CustomValidation = new CustomValidation(IncidentDateInput);
IncidentDateInput.CustomValidation.validityChecks=IncidentDateValidityChecks;

IncidentDescription.CustomValidation = new CustomValidation(IncidentDescription);
IncidentDescription.CustomValidation.validityChecks=IncidentDescriptionValidityChecks;

LatitudeInputs.CustomValidation = new CustomValidation(LatitudeInputs);
LatitudeInputs.CustomValidation.validityChecks=ILatitudeValidityChecks;

LongitudeInputs.CustomValidation = new CustomValidation(LongitudeInputs);
LongitudeInputs.CustomValidation.validityChecks=ILongitudeValidityChecks;

//set form name 
var form = document.getElementById('AddIncidentForm');
};







/* ----------------------------
	Event Listeners
---------------------------- */
if(document.title=="Add Resource" |document.title=="Add Incident"){
var inputs = document.querySelectorAll('input:not([type="submit"])');


var submit = document.querySelector('input[type="submit"]');
var submit = document.getElementById('sub_btn');

function validate() {
	for (var i = 0; i < inputs.length; i++) {
		inputs[i].CustomValidation.checkInput();
	}
}

submit.addEventListener('click', validate);
form.addEventListener('submit', validate);


}