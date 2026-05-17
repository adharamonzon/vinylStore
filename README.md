# 🎵 VinylStore — Sistema de Gestión de Vinilos, Productos y Pedidos
Base de datos Oracle para un futuro sistema completo (Backend + Frontend).

## 👩‍🚀 Motivación 
Este proyecto es un proyecto personal que nace de mi pasión por la música y de las ganas de seguir aprendiendo y mejorando como programadora. Quiero crear una aplicación real desde cero siendo capaz de diseñar y construir una aplicación real completa, abarcando todas sus capas: base de datos, backend y frontend. Para mí, este reto no es solo un ejercicio técnico, sino una oportunidad para demostrarme que puedo llevar una idea desde su concepto inicial hasta un producto funcional.

## 📌 Descripción del proyecto
VinylStore es una base de datos diseñada para gestionar:
- Catálogo de productos (vinilos, libros, merch, tecnología)
- Artistas, discográficas y géneros musicales
- Pedidos y clientes
- Stock en tiempo real
- Estados de conservación de vinilos

Relación N:N entre vinilos y géneros

### Incluye triggers inteligentes que mantienen la integridad del sistema:
- Actualización automática del stock
- Recalcular totales de pedido
- Devolver stock al cancelar o devolver un pedido

## 📂 Estructura SQL necesaria para inicializar la base de datos.
/database
 ├── 01_tables.sql
 ├── 02_inserts.sql
 ├── 03_triggers.sql
 └── README.md
/backend
/frontend

### ✔️ 01_tables.sql
Contiene todas las tablas con sus constraints internos:
- PRODUCTO
- ARTISTA
- DISCOGRAFIA
- VINILO
- GENERO
- VINILO_GENERO
- CLIENTE
- PEDIDO
- DETALLE_PEDIDO
- STOCK
- 
### ✔️ 02_inserts.sql
Datos iniciales:
- Estados de vinilo (Mint, Near Mint, VG+, etc.)
- Datos de prueba opcionales
  
### ✔️ 03_triggers.sql
Incluye los triggers:
- Trigger de stock
- Trigger de total del pedido
- Trigger de cancelación

## 💻 Instalación base de datos:
1.Ejecutar los comandos: 
git clone https://github.com/adharamonzon/vinylstore.git
cd vinylstore/database
2. Ejecutar los scripts en orden (Oracle SQL Developer): 
@01_tables.sql
@02_inserts.sql
@03_triggers.sql

## 🚀 siguientes pasos: 
🔧 Backend (API)
- Endpoints REST para productos, vinilos, pedidos y stock
- Autenticación y roles
- Validación de datos
- Integración con Oracle

🎨 Frontend (Web)
- Panel de administración
- Gestión de catálogo
- Carrito y pedidos
- Dashboard de stock

🧪 Tests automáticos
- Pruebas unitarias de triggers
- Pruebas de integración con la API

📦 CI/CD
- Scripts de despliegue
- Versionado de la base de datos
