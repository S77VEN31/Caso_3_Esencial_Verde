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
function addRow(carrier) {
  setMyVar('carrier', carrier);
  // Obtener la tabla y el cuerpo
  var table = document.getElementById("myTable");
  var tbody = table.getElementsByTagName("tbody")[0];

  // Crear una nueva fila y agregar celdas con los datos de currentOperation
  var row = tbody.insertRow();
  var wasteTypeCell = row.insertCell();
  var operationTypeCell = row.insertCell();
  var companyCell = row.insertCell();
  var producerCell = row.insertCell();
  var carrierCell = row.insertCell();
  var plateCell = row.insertCell();
  var locationCell = row.insertCell();
  var quantityCell = row.insertCell();
  var deleteCell = row.insertCell(); // Nueva celda para el botón de eliminar
  
  wasteTypeCell.innerHTML = currentOperation.wasteType;
  operationTypeCell.innerHTML = currentOperation.operationType;
  companyCell.innerHTML = currentOperation.company;
  producerCell.innerHTML = currentOperation.producer;
  carrierCell.innerHTML = currentOperation.carrier;
  plateCell.innerHTML = currentOperation.plate;
  locationCell.innerHTML = currentOperation.location;
  quantityCell.innerHTML = currentOperation.quantity;
  
  // Crear el botón de eliminar y agregarlo a la celda correspondiente
  var deleteButton = document.createElement("button");
  deleteButton.classList.add("delete-button");
  deleteButton.innerHTML = '<i class="fas fa-trash"></i>'
  deleteButton.onclick = function() {
    // Eliminar la fila correspondiente al botón de eliminar
    var rowIndex = this.parentNode.parentNode.rowIndex;
    table.deleteRow(rowIndex);
  };
  deleteCell.appendChild(deleteButton);
  
}




function getAllRows() {
  var table = document.getElementById("myTable");
  var rows = table.getElementsByTagName("tbody")[0].getElementsByTagName("tr");
  var data = [];

  for (var i = 0; i < rows.length; i++) {
    var row = rows[i];
    var cells = row.getElementsByTagName("td");

    var obj = {
      wasteType: cells[0].innerHTML,
      operationType: cells[1].innerHTML,
      company: cells[2].innerHTML,
      producer: cells[3].innerHTML,
      carrier: cells[4].innerHTML,
      plate: cells[5].innerHTML,
      location: cells[6].innerHTML,
      quantity: cells[7].innerHTML
    };
    
    data.push(obj);
  }
  console.log(data)
  return data;
}

function setInputValueAndSubmit(event) {
  event.preventDefault();

  var inputValue = JSON.stringify(getAllRows());
  document.getElementById("my-input").value = inputValue;

  var miFormulario = document.getElementById("mi-formulario");
  console.log(inputValue)
  miFormulario.submit(); 
}



