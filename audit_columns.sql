//3.2 Añadir restricciones lógicas (Snowflake no las aplica físicamente, pero puedes simularlas)
-- Simulación de claves primarias y check constraints
SELECT * FROM ORDERS_CLEAN
WHERE ID_ORDER IS NULL OR QTY_ORDERED IS NULL OR AMT_TOTAL < 0;

// 4.1 Añadir columnas de auditoría si no existen
ALTER TABLE .ORDERS_CLEAN
ADD COLUMN IF NOT EXISTS AUD_USR_INSERTED STRING;

UPDATE ORDERS_CLEAN
SET AUD_USR_INSERTED = CURRENT_USER();
