# TO DO:
cree usuarios en la base de datos que le permita probar lo siguiente: 
[x] a) es posible negar todo acceso a las tablas de la base de datos y operarla únicamente por medio de ejecución de stored procedures 
[x] b) es posible restringir la visibilidad de columnas a ciertos usuarios 
[x] c) se pueden crear roles, y que usuarios pertenezcan a roles, dichos roles podrían tener restricciones de tablas y columnas que aplican a los usuarios que pertenecen a dicho roles
[x] d) como resuelve sql server prioridades de permisos en la jerarquía, por ejemplo que un nivel superior niego acceso a algo y un nivel inferior se le asigne

[ ] - de manera práctica demuestre como funciona un backup con su restore respectivo, usando método full e incremental

[ ] - usando una herramienta de reporting, por ejemplo microsoft reporting services (se puede usar en docker), powerbi, tableau o kibana, cree un reporte del sistema con la siguiente especificación:

[ ]     - titulo del reporte
[ ]     - subtitulo del reporte es el rango de fechas de los datos del reporte
[ ]     - columnas: país o región, industria, tipo de residuo, costo, venta y ganancia, estas últimas en la moneda base, por ejemplo $
[ ]     - contenido: seleccionando el país o una región de forma exclusiva y un rango de fechas, despliegue para todos los tipos de residuos el total recolectado por industria, lo que ha costado procesar dicho total de residuo, lo que se ha cobrado por procesarlo y la diferencia o ganancia neta.
[ ]     - ordenado ascendente por país o región, industria y tipo de residuo
[ ]     - ordenado descendente por ganancia
[ ]     - deberá tener un subtotal por industria y un total al final del reporte
[ ]     - finalmente, la gerencia quiere poder visualizar gráficamente cuáles ciudades o localidades están enviando sus desechos a cuáles centros de recolección, pudiendo observar dicha relación y su volumen acumulado a la fecha. También se quiere ver dicha relación por empresa productora y por empresas recolectoras. Para ello cree las consultas necesarias o bien haga el data export que genere un CSV que pueda ser cargado a neo4J para visualizar dicha relación.

[ ] - finalmente, la gerencia quiere poder visualizar gráficamente cuáles ciudades o localidades están enviando sus desechos a cuáles centros de recolección, pudiendo observar dicha relación y su volumen acumulado a la fecha. También se quiere ver dicha relación por empresa productora y por empresas recolectoras. Para ello cree las consultas necesarias o bien haga el data export que genere un CSV que pueda ser cargado a neo4J para visualizar dicha relación.

# PREGUNTAS
Cuando mencionas en el punto:
d) como resuelve sql server prioridades de permisos en la jerarquía, por ejemplo que un nivel superior niego acceso a algo y un nivel inferior se le asigne

Te refieres a que sepamos que pasa cuando asigno a un objeto un permiso DENY pero por debajo hay un GRANT, que en este caso se queda el DENY, algo así es lo que quieres que reconozcamos o estoy muy perdido?
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

### 03/05
- [x] Hacer la comparacion del select con la vista dinamica y la vista indexada en cuanto a tiempo y efiencia
- [x] Mega Query
- [x] Apicar optimizar el MEGA QUERY con CTE
- [x] Aplicar normas justo como en Quiz 10
- [x] Ver si hay mejoría al aplicar index en las vistas
- [x] Llenado de las tablas que requieren del MEGA QUERY
- [x] Subir todos los archivos al Flyway
