var createdPLFileOpened = false;

function Toggle() {
	var x = document
			.getElementById("personalizationDivFuzzificationDefaultValues");
	if (x.style.display === "none" || x.style.display == "") {
		x.style.display = "block";
		setSlider();
	} else {
		x.style.display = "none";
	}
}

$(function(){
	setSlider();
});

function setSlider() {
	var slider = document.getElementById("defaultValue");
	var output = document.getElementById("defaultValueResult");
	if (slider != null) {
		output.value = slider.value;
		slider.oninput = function() {
			output.value = this.value;
			$("span#similarityMsg").html(getSimilarityState(output.value));
			$("span#similarityMsg").removeAttr("class");
			$("span#similarityMsg").addClass(getSimilarityStyle(output.value));
		}
	}
}

function getSimilarityState(val) {
	if(val >= 0 && parseFloat(val) <= 0.09) {
		return "Completely different";
	} else if(parseFloat(val) >= 0.1 && parseFloat(val) <= 0.30) {
		return "Very different";
	} else if(parseFloat(val) >= 0.31 && parseFloat(val) <= 0.49) {
		return "Quite different";
	} else if(parseFloat(val) == 0.50) {
		return "Similar";
	} else if(parseFloat(val) >= 0.51 && parseFloat(val) <= 0.99) {
		return "Very similar";
	} else if(parseFloat(val) == 1) {
		return "Completely equal";
	}
}

function getSimilarityStyle(val) {
	if(val >= 0 && parseFloat(val) <= 0.09) {
		return "darkRed";
	} else if(parseFloat(val) >= 0.1 && parseFloat(val) <= 0.30) {
		return "lightRed";
	} else if(parseFloat(val) >= 0.31 && parseFloat(val) <= 0.49) {
		return "lighterRed";
	} else if(parseFloat(val) == 0.50) {
		return "lighterGreen";
	} else if(parseFloat(val) >= 0.51 && parseFloat(val) <= 0.99) {
		return "lightGreen";
	} else if(parseFloat(val) == 1) {
		return "darkGreen";
	}
}

function reloadOtherCombo() {
	var comboOne = document.getElementById("value1");
	var comboTwo = document.getElementById("value2");
	comboTwo.innerHTML = comboOne.innerHTML;
	if (comboOne.value != null && comboOne.value != '---') {
		for (var i = 0; i < comboTwo.options.length; i++) {
			if (comboTwo.options[i].text == comboOne.value) {
				comboTwo.remove(i);
				break;
			}
		}
	}
}

function validateCheckBox() {
	var checkBox = document.getElementById("toggleButton");
	if (checkBox.checked == false) {
		return false;
	} else {
		return true;
	}
}

function showDiv(index, divId) {
    var i, tabcontent, tablinks;
    tabcontent = document.getElementsByClassName("tabcontent");
    for (i = 0; i < tabcontent.length; i++) {
        tabcontent[i].style.display = "none";
    }
    tablinks = document.getElementsByClassName("tablinks");
    for (i = 0; i < tablinks.length; i++) {
        tablinks[i].className = tablinks[i].className.replace(" active", "");
    }
    
    //empty and init  'modifyExisting' tab
    if(divId == "modifyExisting") {
    	$('#modifyExisting select#personalizationSelectComboBoxId1').val('----').trigger("change");
    	$("#modifyExisting div#personalizationFunctionUnderModificationDivId1").html("");
    }
    
    //empty and init 'removeCriteria' tab
    if(divId == "removeCriteria") {
    	$('#defineNew select#personalizationSelectComboBoxId2').removeAttr('data-fromupdate');
    }
    
    //empty and init 'defineNew' tab
    if (!$("div#defineNew select#personalizationSelectComboBoxId2").attr("data-fromupdate")) {
    	$('#defineNew select#personalizationSelectComboBoxId2').removeAttr("data-updatefuzz-url");
    	$('#defineNew select#personalizationSelectComboBoxId2').removeAttr("data-updatesimilarity-url");
    	$('#defineNew select#personalizationSelectComboBoxId2').removeAttr("disabled");
    	$("#defineNew select#personalizationSelectComboBoxId2").val("----").trigger("change");
    	$("#defineNew div#personalizationFunctionUnderModificationDivId2").html("");
    	$('div.tab button.tablinks').eq(1).html("Defining New");
    	$("#defineNew div.personalizationDivSelectFuzzificationTableCell").eq(0).html("Define new &nbsp;");
    }
    
    document.getElementById(divId).style.display = "block";
    $("div.tab button.tablinks[data-index='"+index+"']").addClass("active");
    
}