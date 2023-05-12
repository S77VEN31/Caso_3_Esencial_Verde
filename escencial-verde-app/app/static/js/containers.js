function showPopup() {
  document.getElementById("popup").style.display = "block";
}

function hidePopup() {
  document.getElementById("popup").style.display = "none";
}
function showDateTime() {
  var dateTime = new Date();
  var date = dateTime.toLocaleDateString();
  var time = dateTime.toLocaleTimeString();
  document.getElementById("dateTime").innerHTML = date + " " + time;
}
