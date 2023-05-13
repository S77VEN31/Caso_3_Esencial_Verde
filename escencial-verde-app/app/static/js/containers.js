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
function addRow(carrier, plate, location) {
  setMyVar('carrier', carrier);
  setMyVar('plate', plate);
  setMyVar('location', location);
  var table = document.getElementById("myTable");
  var tbody = table.getElementsByTagName("tbody")[0];

  var row = tbody.insertRow();
  var carrierCell = row.insertCell();
  var plateCell = row.insertCell();
  var locationCell = row.insertCell();
  var companyCell = row.insertCell();
  var producerCell = row.insertCell();
  var wasteTypeCell = row.insertCell();
  var operationTypeCell = row.insertCell();
  var quantityCell = row.insertCell();
  var deleteCell = row.insertCell(); 
  carrierCell.innerHTML = currentOperation.carrier;
  plateCell.innerHTML = currentOperation.plate;
  locationCell.innerHTML = currentOperation.location.substring(1, currentOperation.location.length - 1).split(", ")[4];
  companyCell.innerHTML = currentOperation.company;
  producerCell.innerHTML = currentOperation.producer;
  wasteTypeCell.innerHTML = currentOperation.wasteType;
  operationTypeCell.innerHTML = currentOperation.operationType;
  quantityCell.innerHTML = currentOperation.quantity;
  

  var deleteButton = document.createElement("button");
  deleteButton.classList.add("delete-button");
  deleteButton.innerHTML = '<i class="fas fa-trash"></i>'
  deleteButton.onclick = function() {
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
      carrier: cells[0].innerHTML,
      plate: cells[1].innerHTML,
      location: cells[2].innerHTML,
      company: cells[3].innerHTML,
      producer: cells[4].innerHTML,
      wasteType: cells[5].innerHTML,
      operationType: cells[6].innerHTML,
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



