# SQL – Modificaciones de esquema y creación de vista  

Este repositorio contiene ejercicios prácticos de SQL enfocados en **modificación de tablas** y **creación de vistas**.  
El objetivo es consolidar conocimientos sobre `ALTER TABLE`, manejo de claves foráneas y organización de datos para análisis.  

---

## 1. Creación de la tabla `data_user` y relación con `transaction`  

Se creó la tabla `data_user` con la información básica de los usuarios.  
Después, se ajustó la clave primaria `id` a tipo `INT` y se estableció una relación foránea con la tabla `transaction`:  

```sql
ALTER TABLE transaction
ADD FOREIGN KEY (user_id)
REFERENCES data_user(id);
```
Nota: fue necesario insertar previamente un registro faltante (id = 9999) para mantener la consistencia de los datos.

⸻

2. Eliminación de columnas innecesarias

En la tabla company se eliminó la columna website al no ser requerida en el modelo actual:
```
ALTER TABLE company 
DROP COLUMN website;
```

⸻

3. Cambios en la tabla data_user

Se renombró la columna email a personal_email para mejorar la claridad:
```
ALTER TABLE data_user 
CHANGE email personal_email VARCHAR(100);
```

⸻

4. Cambios en la tabla credit_card

Se ajustaron tipos de datos y se añadió una nueva columna para registrar fechas:
```
ALTER TABLE credit_card
MODIFY COLUMN iban VARCHAR(50),
MODIFY COLUMN pin VARCHAR(4),
MODIFY COLUMN cvv INT,
ADD COLUMN fecha_actual DATE;
```

⸻

5. Creación de la vista InformeTecnico

Se creó una vista que centraliza información de varias tablas (transaction, data_user, credit_card, company).
```
CREATE VIEW InformeTecnico AS
SELECT t.id, u.name, u.surname, cc.iban, c.company_name
FROM transaction t
JOIN company c  ON t.company_id = c.id
JOIN data_user u ON t.user_id = u.id
JOIN credit_card cc ON t.credit_card_id = cc.id;
```
La vista simplifica la obtención de información técnica de las transacciones, permitiendo consultas posteriores como:
```
SELECT * 
FROM InformeTecnico
ORDER BY id DESC;
```

⸻

Buenas prácticas
	•	Documentar cada modificación con comentarios.
	•	Evitar SELECT * en vistas y reportes finales.
	•	Asegurar la consistencia de claves foráneas antes de crear relaciones.
