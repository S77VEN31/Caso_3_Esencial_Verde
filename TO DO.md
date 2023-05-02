# TO DO:
- [ ] Hacer la comparacion del select con la vista dinamica y la vista indexada en cuanto a tiempo y efiencia
- [ ] Mega Query
- [ ] Apicar optimizar el MEGA QUERY con CTE
- [ ] Subir todos los archivos al Flyway

# TO FIX
 EMPTY 😎
# PROCEDURES/TRIGGERS TO DO:
- [ ] Hacer el trigered que detecte si se inserta una empresa con un porcentaje mayor a 44 se debe insertar a la tabla de sponsors, entonces basado en el porcentaje de la empresa se debe pagar un monto (Ejem: porcentaje X 100$ = monto a pagar) O bien un select que haga esto en una tabla temporal o vista

- [ ] Hacer un triger que para insertar un wasteType en un container, este debe existir dentro del containersXwastetypes, si no existe no se puede insertar

- [ ] Hacer un triger que para insertar un container en un fleet, este debe existir dentro del fleetXwasteTypes, si no existe no se puede insertar

- [ ] Select para sacar el precio de cada producto reciclado quantity por price + percentage = precio

## DONE
### 15/04
- [x] Quitemos fleetxwastetreatmentsites, solo nos ata y no hay control previo de eso
- [x] Unificar zipcodes y locations, eso es lo mismo que la tabla addresses del patrón de addreses
- [x] Countries no está asociado a estates para el patrón y nos faltan las zonas
- [x] No amarren un country a una moneda ni a un idioma
### 22/04
- [x] Quitemos esa tabla de systemcurrency
- [x] Ocupamos un default y un enddate en currencyrates, 
- [x] En invoices no se involucren con el cambio, solo documéntenlo, es decir lo asocian y si quieren lo copian, pero no conviertan
- [x] El sponsorship muy pobre, hacerlo segun el modelo
- [x] No tengo claro invoicing, pago y transacciones
- [x] Currencyrates debería ser el PK de varios FKS en pagos y transacciones e invoices
- [x] No es multiidioma 
### 29/04
- [x] Contracts muy pobre, hay mezcla entre la definición de contrato, la planificación de los mismos y la ejecución, tiene muy poco de las cosas que tienen que quedar resueltas en el contrato, ver las preguntas en el documento , es imposible lograr todo lo que está ahí
- [x] No se puede mepear productos a lotes de productos y lotes de recursos usados para poder llegar a los contratos y repartir
- [x]  de nuevo esa tabla de wastetreatmentlogs no está haciendo nada, es 1:1 puede desaparecer, la otra tabla le falta info de control, las personas que participaron de ese intercambio, la acción, la cantidad, el costo es irrelevante aquí, podría ser útil el contractid para facilitar luego las transacciones, la planta o site que puede permitir null pues no aplica para todas las acciones. de nuevo no han trabajado en un camión, nosotros los humildes de zona rural si tuvimos que hacerlo jaja, el camionero no sabe que van hacer con eso, solo sabe lo que tiene que recoger y a donde lo tiene que llevar. 
- [x] no estan poniendo atención a mi duda en esa, si ese trainings registra el momento en que hacen el training, etnonces nos hace falta la tabla con el catálogo de los trainings, no puede ser por medio de ese description que tenes ahí, normalicen eso
 - [x] Lo de contacts, es porque no alambramos teléfono , email, etc, o q son los datos, si no q mas bien crean contacttypes con values para que eso sea variable y no de columnas fijas ni tampoco esté limitado a esos fields de contacto
- [x] Sigo viendo problema, y lo empeoraron al poner capacidades por small mid large, no podemos ponernos a controlar eso a nivel de sistema,
- [x] se nota que nunca han trabajado en un camión de carga. Lo que me refiero, no cualquier camión o transporte puede llevar containers con cloro, o con ácido de batería, o con aceite o con combustible, entonces es bueno especificar tal vez si un peso máximo permitido, pero decir cuáles tipos de desechos soporta
- [x] jumm que raro que no haya visto eso, listo, si recuerden que no falta el historial de precios y lo otro falta lo del contrato que les menciono ahí, es decir, puede ser que el método de oxidación para comida valga en CR, 200 colones el kilo, pero cuando la empresa hace el contrato, dado el volumen, el term del contrato y así, ellos podrían llegar a un precio especial y decir, ok hotel riu, le vamos a dejar el kilo de comida por métido de oxidación en 120 colones

