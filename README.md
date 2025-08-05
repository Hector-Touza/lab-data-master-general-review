![logo_ironhack_blue 7](https://user-images.githubusercontent.com/23629340/40541063-a07a0a8a-601a-11e8-91b5-2f13e4e6b441.png)

# Lab | Caso Práctico Completo: De Bronze a Silver con Control de Calidad y Seguridad

## 🎯 Objetivo

Aplicar de forma integrada todos los conceptos aprendidos: ingestión de datos crudos, transformación a Silver, creación de vistas Gold y asegurar calidad, consistencia y seguridad del pipeline de datos en Snowflake.

## Requisitos

* Haz un ***fork*** de este repositorio.
* Clona este repositorio.

## Entrega

- Haz Commit y Push
- Crea un Pull Request (PR)
- Copia el enlace a tu PR (con tu solución) y pégalo en el campo de entrega del portal del estudiante – solo así se considerará entregado el lab

## 🧱 Parte 1: Repaso y revisión de la tabla RAW

Usa el dataset trabajado anteriormente: `orders.csv`  
Verifica la tabla RAW: `DEV_BRONZE_DB.RAW.ORDERS_RAW`

### 1.1 Revisión de estructura

```sql
DESC TABLE DEV_BRONZE_DB.RAW.ORDERS_RAW;
SELECT * FROM DEV_BRONZE_DB.RAW.ORDERS_RAW LIMIT 10;
````

🧠 **Preguntas:**

* ¿Qué tipo de errores o inconsistencias observas en los datos crudos?
* ¿Qué columnas son críticas para identificar duplicados o nulos?
* ¿Qué ventajas aporta guardar datos crudos en formato texto o `VARIANT`?

## 🧼 Parte 2: Validación y calidad de datos

Aplica técnicas de control de calidad antes de transformar a Silver.

### 2.1 Validar campos esenciales

```sql
-- Verifica valores no numéricos
SELECT ORDER_ID, QUANTITY, PRICE_TOTAL
FROM DEV_BRONZE_DB.RAW.ORDERS_RAW
WHERE NOT IS_NUMBER(QUANTITY) OR NOT IS_NUMBER(PRICE_TOTAL);

-- Buscar nulos o registros incompletos
SELECT * FROM DEV_BRONZE_DB.RAW.ORDERS_RAW
WHERE ORDER_ID IS NULL OR CUSTOMER_ID IS NULL;
```

### 2.2 Verificar unicidad y duplicados

```sql
SELECT ORDER_ID, COUNT(*) 
FROM DEV_BRONZE_DB.RAW.ORDERS_RAW
GROUP BY ORDER_ID
HAVING COUNT(*) > 1;
```

🧠 **Preguntas:**

* ¿Cómo afectan estos errores al análisis posterior?
* ¿Eliminarías los duplicados o los marcarías como inválidos?

## 🥈 Parte 3: Consolidar tabla Silver

Asegura que tu tabla `ORDERS_CLEAN` en Silver esté limpia, estructurada y bien documentada.

### 3.1 Revisión general

```sql
SELECT * FROM DEV_SILVER_DB.S_SUPPLY_CHAIN.ORDERS_CLEAN LIMIT 10;
```

### 3.2 Añadir restricciones lógicas (Snowflake no las aplica físicamente, pero puedes simularlas)

```sql
-- Simulación de claves primarias y check constraints
SELECT * FROM DEV_SILVER_DB.S_SUPPLY_CHAIN.ORDERS_CLEAN
WHERE ID_ORDER IS NULL OR QTY_ORDERED IS NULL OR AMT_TOTAL < 0;
```

### 3.3 Documenta los campos críticos en `lab-notes.md`

| Campo        | Validación Aplicada                 | Observaciones                         |
| ------------ | ----------------------------------- | ------------------------------------- |
| QTY\_ORDERED | IS\_NUMBER, > 0                     | Algunos registros con "abc"           |
| AMT\_TOTAL   | TRY\_TO\_NUMBER, > 0                | 5% registros tienen valores inválidos |
| ORDER\_DATE  | TRY\_TO\_DATE, formato `YYYY-MM-DD` | 2% fechas mal formateadas             |

## 🔐 Parte 4: Seguridad, trazabilidad y cumplimiento

### 4.1 Añadir columnas de auditoría si no existen

```sql
ALTER TABLE DEV_SILVER_DB.S_SUPPLY_CHAIN.ORDERS_CLEAN
ADD COLUMN IF NOT EXISTS AUD_USR_INSERTED STRING;

UPDATE DEV_SILVER_DB.S_SUPPLY_CHAIN.ORDERS_CLEAN
SET AUD_USR_INSERTED = CURRENT_USER();
```

### 4.2 Aplicar `MASKING POLICY` (sólo si tienes permisos)

```sql
CREATE MASKING POLICY MASK_CUSTOMER_ID AS (val NUMBER) 
  RETURNS STRING ->
  CASE
    WHEN CURRENT_ROLE() IN ('ROLE_ANALYST') THEN TO_VARCHAR(val)
    ELSE '***'
  END;

-- Aplicación (opcional si el entorno lo permite)
-- ALTER TABLE ... MODIFY COLUMN ID_CUSTOMER SET MASKING POLICY MASK_CUSTOMER_ID;
```

🧠 **Preguntas:**

* ¿Qué datos deberían estar enmascarados?
* ¿Por qué es importante la trazabilidad del dato en entornos reales?

## 🔄 Parte 5: Revisión del workflow de datos

Completa este flujo lógico en `lab-notes.md`:

1. Ingesta de datos crudos (`orders.csv`)
2. Validación básica en Bronze
3. Limpieza y normalización en Silver
4. Documentación en SqlDBM
5. Creación de vista Gold (`SALES_SUMMARY`)
6. Consumo en Power BI

### Reflexión escrita:

* ¿Qué decisiones fueron técnicas y cuáles de negocio?
* ¿Dónde aplicarías DBT, Airflow o Tasks para automatizar este flujo?

## 💬 Parte 6: Ejercicios de grupo o discusión en clase

### Ejercicio 1: Diferencias entre datos crudos y limpios

🗣️ **Puntos a discutir:**

* ¿Cuándo conviene preservar datos con errores?
* ¿En qué casos transformar directamente puede ser peligroso?
* ¿Qué coste tiene limpiar de más o de menos?

Documenta ideas en `lab-notes.md`.

### Ejercicio 2: Análisis final del pipeline

Responde en grupo o individualmente:

1. ¿Qué hemos hecho desde la ingestión hasta el modelo final?
2. ¿Qué herramientas hemos usado y por qué (Snowflake, SqlDBM, Power BI)?
3. ¿Qué desafíos técnicos surgieron en el camino?
4. ¿Cómo conectarías este flujo con producción?

## Entregables

* `quality_checks.sql`: scripts de validación y control de calidad
* `audit_columns.sql`: control de trazabilidad y usuario
* `lab-notes.md`: respuestas a reflexiones y ejercicios
* Capturas de pantalla de Power BI o SqlDBM (opcional)

## 🏁 Conclusión

Este caso práctico te ha permitido:

* Consolidar el aprendizaje de los módulos anteriores
* Aplicar técnicas reales de validación y seguridad
* Reflexionar sobre decisiones técnicas y de negocio
* Entender cómo se construye una arquitectura de datos robusta en Snowflake

➡️ Esta es la base para orquestar pipelines automatizados en producción y escalar la solución.
