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

setSlider();

function setSlider() {
	var slider = document.getElementById("defaultValue");
	var output = document.getElementById("defaultValueResult");
	if (slider != null) {
		output.value = slider.value;
		slider.oninput = function() {
			output.value = this.value;
		}
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