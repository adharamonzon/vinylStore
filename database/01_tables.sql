--CREATE TABLE
--Tablas relacionadas con vinilos
CREATE TABLE PRODUCTO (
    id_producto NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL,
    descripcion VARCHAR2(300),
    tipo VARCHAR2(10) NOT NULL,
    CONSTRAINT chk_tipo_producto CHECK (tipo IN (
        'VINILO',
        'LIBRO',
        'MERCH',
        'TECH'
    )),
    precio NUMBER(5,2) NOT NULL,
    fecha_alta DATE DEFAULT SYSDATE,
    --activo 0 = no 1 = si;
    activo NUMBER(1) DEFAULT 1,
    CONSTRAINT chk_producto_activo CHECK (activo in (0, 1))
);
CREATE TABLE ESTADO_VINILO(
    code_condicion VARCHAR2(3) PRIMARY KEY,
    significado VARCHAR2(50)
);
CREATE TABLE ARTISTA (
    id_artista NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2 (100) NOT NULL,
    pais_origen VARCHAR2(100),
    anio_inicio NUMBER(4),
    anio_fin NUMBER(4),
    CONSTRAINT chk_anio_fin CHECK (anio_fin IS NULL OR anio_fin >= anio_inicio),
    --activo 0 = no, 1 = si
    activo NUMBER(1) NOT NULL,
    CONSTRAINT chk_artista_activo CHECK (activo IN (0, 1)),
    fecha_alta DATE DEFAULT SYSDATE
);
CREATE TABLE DISCOGRAFIA (
    id_discografia NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    pais_origen VARCHAR2(100),
    fundacion NUMBER(4),
    --activo 0 = no, 1 = si
    activo NUMBER(1) NOT NULL,
    CONSTRAINT chk_discografia_activo CHECK (activo IN (0, 1)),
    fecha_alta DATE DEFAULT SYSDATE
);
CREATE TABLE VINILO (
    id_vinilo NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_producto NUMBER NOT NULL,
    id_artista NUMBER NOT NULL,
    id_discografia NUMBER NOT NULL, 
    anio NUMBER(4),
    formato VARCHAR2(6)NOT NULL,
    CONSTRAINT chk_formato_vinilo CHECK (formato IN ('SINGLE', 'EP', 'LP')),
    code_condicion VARCHAR2(3) NULL,
    num_discos NUMBER NOT NULL,
    CONSTRAINT chk_num_discos CHECK( num_discos > 0),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto),
    FOREIGN KEY (id_artista) REFERENCES ARTISTA(id_artista),
    FOREIGN KEY (id_discografia) REFERENCES DISCOGRAFIA(id_discografia),
    FOREIGN KEY (code_condicion) REFERENCES ESTADO_VINILO(code_condicion)
        ON DELETE SET NULL
);
CREATE TABLE GENERO (
    id_genero NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(50) NOT NULL UNIQUE
);
CREATE TABLE VINILO_GENERO (
    id_vinilo NUMBER NOT NULL,
    id_genero NUMBER NOT NULL,
    PRIMARY KEY (id_vinilo, id_genero),
    FOREIGN KEY (id_vinilo) REFERENCES VINILO(id_vinilo) ON DELETE CASCADE,
    FOREIGN KEY (id_genero) REFERENCES GENERO(id_genero) ON DELETE CASCADE
);
--tablas relacionadas con clientes y pedidos
CREATE TABLE CLIENTE (
id_cliente NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    telefono VARCHAR2(20),
    direccion VARCHAR2(200),
    fecha_alta DATE DEFAULT SYSDATE,
    --activo 0 = no, 1 = si
    activo NUMBER(1) DEFAULT 1,
    CONSTRAINT chk_cliente_activo CHECK (activo IN (0,1))
);
CREATE TABLE PEDIDO (
    id_pedido NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    fecha_pedido DATE DEFAULT SYSDATE,
    fecha_cancelacion DATE,
    total NUMBER(8,2),
    estado VARCHAR2(20) DEFAULT 'PENDIENTE',
    CONSTRAINT chk_estado_pedido CHECK (estado IN (
        'PENDIENTE',
        'PAGADO',
        'ENVIADO',
        'ENTREGADO',
        'CANCELADO',
        'DEVUELTO'
    )),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);
CREATE TABLE DETALLE_PEDIDO (
    id_detalle NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_pedido NUMBER NOT NULL,
    id_producto NUMBER NOT NULL,
    cantidad NUMBER(5) NOT NULL,
    precio_unitario NUMBER(8,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido) ON DELETE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
);
CREATE TABLE STOCK (
    id_producto NUMBER PRIMARY KEY,
    unidades NUMBER(5) DEFAULT 0,
    CONSTRAINT chk_stock_unidades CHECK (unidades >=0),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto) ON DELETE CASCADE
);