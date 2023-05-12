function changeText(selectedOption) {
    document.getElementById("dropdown-selector-selected").innerHTML = selectedOption;
}

function toggleDropdown() {
    var dropdownContent = document.getElementById("dropdown-selector-menu");
    if (dropdownContent.style.display === "block") {
      dropdownContent.style.display = "none";
    } else {
      dropdownContent.style.display = "block";
    }
  }
  