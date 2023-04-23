# TO DO:
## FIXES
- El capacity de un fleet es algo más que un tamaño, si no también sobre que tipo de desechos es capaz de jalar
- Quitemos fleetxwastetreatmentsites, solo nos ata y no hay control previo de eso
- Unificar zipcodes y locations, eso es lo mismo que la tabla addresses del patrón de addreses
- Countries no está asociado a estates para el patrón y nos faltan las zonas
- No amarren un country a una moneda ni a un idioma
- Quitemos esa tabla de systemcurrency
- Ocupamos un default y un enddate en currencyrates, currencyrates debería ser el PK de varios FKS en pagos y transacciones e invoices
- En invoices no se involucren con el cambio, solo documéntenlo, es decir lo asocian y si quieren lo copian, pero no conviertan
- Mal diseñado el patron de contactinfo, incluso me genera dem desperdicio el modelo que usaron, y separen el name
- Contracts muy pobre, hay mezcla entre la definición de contrato, la planificación de los mismos y la ejecución, tiene muy poco de las cosas que tienen que quedar resueltas en el contrato, ver las preguntas en el documento , es imposible lograr todo lo que está ahí
- No puedo ver que será frecuency pero si es texto estamos mal, veo poca info para poder modelar una recurrencia
- Trainings no se si es el catalogo o el registro de cuando se hizo un training a alguien
- El sponsorship muy pobre
- No se ven los precios de los métodos ni como estos se modelan para el contrato para los lugares
- No se puede mepear productos a lotes de productos y lotes de recursos usados para poder llegar a los contratos y repartir
- No tengo claro invoicing, pago y transacciones
- No es multiidioma 
- Wastetreatmentlog no me muestra 
