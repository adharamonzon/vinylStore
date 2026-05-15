--Trigger Actualizar STOCK
CREATE OR REPLACE TRIGGER trg_stock_trigger
    AFTER INSERT OR UPDATE OR DELETE ON DETALLE_PEDIDO
    FOR EACH ROW
    BEGIN
        -- Se inserta un pedido = baja sctock
        IF INSERTING THEN
            UPDATE STOCK SET unidades = unidades - :NEW.cantidad
                WHERE id_producto = :NEW.id_producto;
        -- Se elimina pedido = sube el stock
        ELSIF DELETING THEN
            UPDATE STOCK SET unidades = unidades + :OLD.cantidad
                WHERE id_producto = :OLD.id_producto;
        ELSIF UPDATING THEN
            -- Cambia el producto 
            IF :OLD.id_producto <> :NEW.id_producto THEN
                --devolvemos el stock al producto antiguo
                UPDATE STOCK SET unidades = unidades + :OLD.cantidad
                    WHERE id_producto = :OLD.id_producto;
                --restamos el stock del producto nuevo
                UPDATE STOCK SET unidades = unidades - :NEW.cantidad
                    WHERE id_producto = :NEW.id_producto;
            --cambia la cantidad del mismo producto 
            ELSIF :OLD.cantidad <> :NEW.cantidad THEN 
                UPDATE STOCK SET unidades = unidades + (:OLD.cantidad - :NEW.cantidad)
                WHERE id_producto = :OLD.id_producto;
            END IF;
        END IF;
    END;

--Trigger para recalcular el total del pedido 
CREATE OR REPLACE TRIGGER trg_total_pedido
    AFTER INSERT OR UPDATE OR DELETE ON DETALLE_PEDIDO
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN
        --suma el total al pedido
        --FN NVL (null-value-logic) remplaza automáticamente los valores null por lo que encuentre
            UPDATE PEDIDO SET total = NVL(total, 0) + (:NEW.cantidad * :NEW.precio_unitario)
                WHERE id_pedido = :NEW.id_pedido;
        ELSIF DELETING THEN 
        --resta del total del pedido 
            UPDATE PEDIDO SET total = NVL(total,0) - (:OLD.cantidad * :OLD.precio_unitario)
                WHERE id_pedido = :OLD.id_pedido;
        ELSIF UPDATING THEN 
        --cambiar cantidad / precio o ambos
            UPDATE PEDIDO SET total = NVL(total, 0)
                - (:OLD.cantidad * :OLD.precio_unitario)
                + (:NEW.cantidad * :NEW.precio_unitario)
                WHERE id_pedido = :NEW.id_pedido;
        END IF;
    END;
    --Trigger para cancelación de pedido 
    CREATE OR REPLACE TRIGGER trg_cancelar_pedido
    AFTER UPDATE OF estado ON PEDIDO
    FOR EACH ROW
    WHEN (
        NEW.estado IN ('CANCELADO', 'DEVUELTO')
        AND
        OLD.estado NOT IN ('CANCELADO', 'DEVUELTO')
    )
    BEGIN
        --1. devolver stock de todos los productos del pedido cancelado
        UPDATE STOCK s SET s.unidades = s.unidades + (
            SELECT dp.cantidad FROM DETALLE_PEDIDO dp 
                WHERE dp.id_producto = s.id_producto
                    AND dp.id_pedido = :NEW.id_pedido
        ) WHERE EXISTS (
            SELECT 1 FROM DETALLE_PEDIDO dp
                WHERE dp.id_producto = s.id_producto
                    AND dp.id_pedido = :NEW.id_pedido
        );
        --2. Poner el total del pedido a 0 y fecha de cancelación
        UPDATE PEDIDO SET total = 0, fecha_cancelacion = SYSDATE
        WHERE id_pedido = :NEW.id_pedido;
    END;