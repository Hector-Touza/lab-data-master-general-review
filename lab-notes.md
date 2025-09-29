## 1.1 Revisión de estructura
🧠 Preguntas:
### ¿Qué tipo de errores o inconsistencias observas en los datos crudos?
En las 10 primeras filas observo:  
- Quantity contiene valores no numéricos
- price total contiene valores "invalid"
- order type contiene valores "invalid"
### ¿Qué columnas son críticas para identificar duplicados o nulos?
Order ID identifica de forma unívoca cada entrada  
la combinación customer_ID, product_id, price_total, order_date también debería ser única (ningún cliente pide lo mismo dos veces en un mismo día)  
Probablemente deberíamos marcad adecuadamente las entradas con order type invalid y price total invalid, que probablemente corresponden a pedidos que no se cerraron correctamente
### ¿Qué ventajas aporta guardar datos crudos en formato texto o VARIANT?
Entre otras ventajas:  
- Fidelidad: guardas exactamente lo que llegó, sin pérdidas.
- Flexibilidad: no necesitas conocer el esquema de antemano.
- Desacoplamiento: ingestión rápida, modelado después en silver/gold.
- Auditoría: puedes demostrar cómo llegó el dato original.
- Exploración: con VARIANT consultas JSON/semi-estructurados sin normalizar.

## Parte 2
### ¿Cómo afectan estos errores al análisis posterior?
Es importante marcar adecuadamente los pedidos inválidos para poder separarlos adecuadamente en el análisis.
De no ser así desvirtuarían cualquier estadística
### ¿Eliminarías los duplicados o los marcarías como inválidos?
Los marcaría como inválidos, ya que pueden contener en si información útil, como por ejemplo posibles problemas que los usuarios estén encontrando en el proceso de compra o intentar optimizar el funnel de compra, ver donde se quedan abandonados carritos...

## Parte 3
### 3.3 Documenta los campos críticos en lab-notes.md
| Campo       | Validación Aplicada              | Observaciones                          |
|-------------|----------------------------------|----------------------------------------|
| QTY_ORDERED | IS_NUMBER, > 0                  | Algunos registros con "abc"            |
| AMT_TOTAL   | TRY_TO_NUMBER, > 0              | 5% registros tienen valores inválidos  |
| ORDER_DATE  | TRY_TO_DATE, formato YYYY-MM-DD | 2% fechas mal formateadas              |

## Parte 4: Seguridad, trazabilidad y cumplimiento
### ¿Qué datos deberían estar enmascarados?
Toda información de carácter personal debería estar enmascarada.  
En general, la organización debería conceder permisos bajo el principio need-to-know y enmascarar campos especialmente confidenciales.  
En nuestro ejemplo, customer_id debería estarlo.  
### ¿Por qué es importante la trazabilidad del dato en entornos reales?
Puede ser importante, entre otros motivos, por cuestiones de cumplimiento legal / cumplimiento de normas / auditoría.

## Parte 5
### ¿Qué decisiones fueron técnicas y cuáles de negocio?
Técnicas:  
- Definir con cuidado el tipado de los datos en silver  
- Marcar adecuadamente registros inválidos  
De negocio: 
- Enmascarado de datos confidenciales  
- Conservar los registros inválidos  
### ¿Dónde aplicarías DBT, Airflow o Tasks para automatizar este flujo?
DBT: Para transformar los datos  
Airflow: Para coordinar/automatizar la pipeline de datos
Tasks: para programar la ejecución de scripts sql o python dentro de snowflake

## Parte 6: Ejercicios de grupo o discusión en clase
## Ejercicio 1: Diferencias entre datos crudos y limpios
### ¿Cuándo conviene preservar datos con errores?  
Por trazabilidad, por si en el futuro puedes completar los campos faltantes o si los datos con errores contienen información en si que puedas explotar para otra cosa
### ¿En qué casos transformar directamente puede ser peligroso?  
Puedes cometer errores, borrar datos de mas o borrar datos que a otra persona en el futuro le puedan ser útiles
### ¿Qué coste tiene limpiar de más o de menos?  
Si limpias de más, puedes estar falseando tus datos al quitar registros desviados que te ensucian la estadística o puedes estar perdiendo información útil para otros usos.  
Si limpias de menos, puedes estar cargándote la pipeline o dejando la limpieza al criterio de cada consumidor, de manera que no se aplican criterios compatibles.

## Ejercicio 2: Análisis final del pipeline  
### ¿Qué hemos hecho desde la ingestión hasta el modelo final?  
Hemos intentado simular toda la pipeline:  
- definición del modelo bronce  
- la carga de datos raw  
- la definición de silver  
- la transformación y normalización de datos a silver  
- la definición de kpis de negocio para gold  
- el reporting  
### ¿Qué herramientas hemos usado y por qué (Snowflake, SqlDBM, Power BI)?  
Hoy hemos usado Snowflake para modelado e ingesta, dbdiagram para diseño del modelo de datos y powerbi para el reporting.
### ¿Qué desafíos técnicos surgieron en el camino? 
Principalmente he tenido dificultades con la ingesta de datos en el primer laboratorio de 1. Ha costado mucho subir el dataset de viajes de taxis de NYC a staging.
Adicionalmente, he tenido que prestar bastante atención a la hora de normalizar los datos para pasar a silver.
### ¿Cómo conectarías este flujo con producción?  
Le pediría al partner con el que trabajamos que produccionice lo que he prototipado.
