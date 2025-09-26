# Nivell 1

# Exercici 1
# La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials 
# sobre les targetes de crèdit. La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir 
# una relació adequada amb les altres dues taules ("transaction" i "company"). Després de crear la taula serà 
# necessari que ingressis la informació del document denominat "dades_introduir_credit". Recorda mostrar el diagrama
# i realitzar una breu descripció d'aquest.

   -- Creamos la tabla credit_card
    CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(20) PRIMARY KEY,
    iban VARCHAR(34) NOT NULL,
    pan CHAR(19) NOT NULL,
    pin CHAR(4) NOT NULL,
    cvv CHAR(3) NOT NULL,
    expiring_date VARCHAR(8) NOT NULL   -- formato mm/dd/yy, lo lee como string y mo como fecha
);
# Establecemos la relación entre las tablas credit_card y transaction

ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

# Exercici 2
# El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit 
# amb ID CcU-2938. La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. 
# Recorda mostrar que el canvi es va realitzar.

# Mostramos el registro antes del cambio
SELECT * 
FROM credit_card
WHERE id = 'CcU-2938';

# Actualizamos el IBAN
UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

# Mostramos el registro después del cambio para confirmar
SELECT * 
FROM credit_card
WHERE id = 'CcU-2938';

# Exercici 3
# En la taula "transaction" ingressa una nova transacció amb la següent informació:

# Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
# credit_card_id	CcU-9999
# company_id	b-9999
# user_id	9999
# lat	829.999
# longitude	-117.999
# amount	111.11
# declined	0

SHOW COLUMNS FROM transaction; # mostramos las columnas de "transaction" para verificar tipos y NULL

INSERT INTO `transaction` # ponemos backticks, MySQL interpreta transaction como parte de su sintaxis de transacciones
(id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);

SELECT *
FROM company
WHERE id = 'b-9999';

# nos devuelve NULL, insertamos los datos que están en las Foreign Keys

SHOW COLUMNS FROM credit_card; # no acepta NULL así que hago que lo acepte

ALTER TABLE credit_card 
MODIFY COLUMN iban VARCHAR(34) NULL,
MODIFY COLUMN pan CHAR(19) NULL,
MODIFY COLUMN pin CHAR(4) NULL,
MODIFY COLUMN cvv CHAR(3) NULL,
MODIFY COLUMN expiring_date VARCHAR(8) NULL;

# insertamos los datos en las tablas

INSERT INTO credit_card (id) VALUES ('CcU-9999');
INSERT INTO company (id) VALUES ('b-9999');

INSERT INTO `transaction` # ponemos backticks, MySQL interpreta transaction como parte de su sintaxis de transacciones
(id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);

# Mostramos el registro después del cambio para confirmar
SELECT *
FROM company
WHERE id = 'b-9999';

# Exercici 4
# Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. 
# Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card 
DROP COLUMN pan;

SELECT *
FROM credit_card;

# Nivell 2

# Exercici 1
# Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

# miramos si existe
SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

# eliminamos
DELETE FROM transaction WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

# comprovamos
SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

# Exercici 2
# anàlisi i estratègies efectives. S'ha sol·licitat crear una vista que proporcioni detalls clau sobre 
# les companyies i les seves transaccions. Serà necessària que creïs una vista anomenada VistaMarketing que 
# contingui la següent informació: Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de 
# compra realitzat per cada companyia. Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS
SELECT c.company_name, c.phone, c.country, AVG(t.amount) AS mitjana_compres
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY c.id;

SELECT * 
FROM VistaMarketing
ORDER BY mitjana_compres DESC;

# Exercici 3
# Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT *
FROM VistaMarketing
WHERE country = 'Germany'
ORDER BY mitjana_compres DESC;

# Nivell 3

# Exercici 1
# La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. Un company del teu equip va realitzar 
# modificacions en la base de dades, però no recorda com les va realitzar. Et demana que l'ajudis a deixar els 
# comandos executats per a obtenir el següent diagrama:

# excluimos el VIEW
DROP VIEW VistaMarketing; 

# creamos la tabla data_user
CREATE TABLE IF NOT EXISTS data_user (
	id CHAR(10) PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(150),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR(150),
	postal_code VARCHAR(100),
	address VARCHAR(255)    
);

# cargamos los datos, pero hay que cambiar el mombre de la tabla data_user para user para cargarlos
RENAME TABLE data_user TO user;

# ya cargados le cambiamos el nombre para data_user
RENAME TABLE user TO data_user;

# Establecemos la relación entre las tablas data_user y transaction, pero primero hay que cambiar id en la tabla data_user
# a un INT
ALTER TABLE data_user 
MODIFY COLUMN id INT;

ALTER TABLE transaction
ADD FOREIGN KEY (user_id)
REFERENCES data_user(id);

# no me deja por que hay datos en transaction.user_id que no existen en data_user.id
SELECT DISTINCT user_id
FROM transaction
WHERE user_id NOT IN (SELECT id FROM data_user);

# nos devuelve el registro 9999, hay que ponerlo en la tabla data_user
INSERT INTO data_user (id, name) VALUES (9999, 'Dragos');

# Ahora si establecemos la relación entre las tablas
ALTER TABLE transaction
ADD FOREIGN KEY (user_id)
REFERENCES data_user(id);

# En la tabla company eliminamos la columna website 
ALTER TABLE company 
DROP COLUMN website;

# en la tabla data_user cambiamos email por personal_email

ALTER TABLE data_user CHANGE email personal_email VARCHAR(100);

# En la tabla credit_card: el iban la cambiamos para in VARCHAR(50), el pin para un VARCHAR(4)
# el CVV lo cambiamos a INT y hay que crear la columna fecha_actual como un DATE.
ALTER TABLE credit_card MODIFY COLUMN iban VARCHAR(50);
ALTER TABLE credit_card MODIFY COLUMN pin VARCHAR(4);
ALTER TABLE credit_card MODIFY COLUMN cvv INT;
ALTER TABLE credit_card ADD fecha_actual DATE;

# se puede hacer así, de una sola vez
ALTER TABLE credit_card
MODIFY COLUMN iban VARCHAR(50),
MODIFY COLUMN pin VARCHAR(4),
MODIFY COLUMN cvv INT,
ADD COLUMN fecha_actual DATE;

# Exercici 2
# L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:

# ID de la transacció
# Nom de l'usuari/ària
# Cognom de l'usuari/ària
# IBAN de la targeta de crèdit usada.
# Nom de la companyia de la transacció realitzada.
# Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de nom 
# columnes segons calgui.

# Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.

CREATE OR REPLACE VIEW InformeTecnico AS # le he adicionado declined a la original, por eso pongo OR REPLACE
SELECT t.id, u.name, u.surname, cc.iban, c.company_name, t.amount, t.timestamp, t.declined
FROM transaction t
JOIN company c  ON t.company_id = c.id
JOIN data_user u ON t.user_id = u.id
JOIN credit_card cc ON t.credit_card_id = cc.id;

SELECT id, name, surname, iban, company_name, amount, timestamp, declined
FROM InformeTecnico
ORDER BY id DESC;
