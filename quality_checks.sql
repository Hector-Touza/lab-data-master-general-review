// 1.1 revisión estructura
DESC TABLE B_ORDERS;
SELECT * FROM B_ORDERS LIMIT 10;

// 2.1 validar campos esenciales
-- Verifica valores no numéricos
SELECT ORDER_ID, QUANTITY, PRICE_TOTAL
FROM B_ORDERS
WHERE TRY_TO_NUMBER(QUANTITY) IS NULL OR  TRY_TO_NUMBER(PRICE_TOTAL) IS NULL;
// -> 129 RESULTADOS

-- Buscar nulos o registros incompletos
SELECT * FROM B_ORDERS
WHERE ORDER_ID IS NULL OR CUSTOMER_ID IS NULL;
// -> NO HAY

// 2.2 Verificar unicidad y duplicados
SELECT ORDER_ID, COUNT(*) 
FROM B_ORDERS
GROUP BY ORDER_ID
HAVING COUNT(*) > 1;
// -> no se detectan duplicados

// 3.1 Revisión general
SELECT * FROM ORDERS_CLEAN LIMIT 10;
