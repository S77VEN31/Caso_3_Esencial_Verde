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

var currentOperation = {
  wasteType: "initial value",
  operationType: "initial value",
  company: "initial value",
  producer: "initial value",
  carrier: "initial value",
  plate: "initial value",
  location: "initial value",
  quantity: 'initial value'
};
function setMyVar(key, value) {
  currentOperation[key] = value;
  console.log(currentOperation);
}
function addRow() {
  // Obtener la tabla y el cuerpo
  var table = document.getElementById("myTable");
  var tbody = table.getElementsByTagName("tbody")[0];

  // Crear una nueva fila y agregar celdas con los datos de currentOperation
  var row = tbody.insertRow();
  var wasteTypeCell = row.insertCell();
  var operationTypeCell = row.insertCell();
  var companyCell = row.insertCell();
  var carrierCell = row.insertCell();
  var plateCell = row.insertCell();
  var locationCell = row.insertCell();
  var deleteCell = row.insertCell(); // Nueva celda para el botón de eliminar
  
  wasteTypeCell.innerHTML = currentOperation.wasteType;
  operationTypeCell.innerHTML = currentOperation.operationType;
  companyCell.innerHTML = currentOperation.company;
  carrierCell.innerHTML = currentOperation.carrier;
  plateCell.innerHTML = currentOperation.plate;
  locationCell.innerHTML = currentOperation.location;
  
  // Crear el botón de eliminar y agregarlo a la celda correspondiente
  var deleteButton = document.createElement("button");
  deleteButton.innerHTML = "Eliminar";
  deleteButton.onclick = function() {
    // Eliminar la fila correspondiente al botón de eliminar
    var rowIndex = this.parentNode.parentNode.rowIndex;
    table.deleteRow(rowIndex);
  };
  deleteCell.appendChild(deleteButton);
}
