function changeText(selectedOption, id) {
    document.getElementById(id).innerHTML = selectedOption;
}

function toggleDropdown(id) {
    var dropdownContent = document.getElementById(id);
    if (dropdownContent.style.display === "block") {
      dropdownContent.style.display = "none";
    } else {
      dropdownContent.style.display = "block";
    }
  }
  