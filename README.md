## SISTEMA HOSPITALARIO DISTRIBUIDO - BASES DE DATOS 

---

## 📋 OBJETIVO DEL PROYECTO

Diseñar una base de datos distribuida para un sistema de gestión hospitalaria que permita:
- **Autonomía departamental** para gestión independiente
- **Compartir recursos** como farmacia y historias clínicas
- **Control de acceso** según roles de empleados
- **Distribución inteligente** entre local y centralizado

---

## 🏗️ ARQUITECTURA SIMPLIFICADA

### **🏥 DATOS LOCALES (Por Departamento)**
Cada departamento mantiene:
- **Personal**: EMPLEADO, ROL_EMPLEADO, USUARIO_SISTEMA
- **Pacientes**: PACIENTE (con réplica)
- **Atención**: CITA, TIPO_CITA
- **Historias**: HISTORIA_CLINICA (con acceso compartido)
- **Equipos**: EQUIPAMIENTO, MANTENIMIENTO_EQUIPO
- **Tratamientos**: PRESCRIPCION, DETALLE_PRESCRIPCION

### **☁️ DATOS CENTRALIZADOS (Compartidos)**
Información común a todos los departamentos:
- **Farmacia**: MEDICAMENTO, LABORATORIO, CATEGORIA_MEDICAMENTO
- **Catálogos**: TIPO_SANGRE, TIPO_EQUIPAMIENTO, PROVEEDOR

---

## 📊 ENTIDADES PRINCIPALES

### **ENTIDADES OPERATIVAS (17 entidades)**

#### **Gestión de Personal**
```sql
DEPARTAMENTO
- Información básica de cada departamento médico
- Campos: nombre, ubicación, especialidad, contacto

ROL_EMPLEADO  
- Define roles como Médico, Administrativo, Farmacéutico
- Incluye permisos del sistema en formato JSON

EMPLEADO
- Personal que trabaja en cada departamento
- Vinculado a un departamento y un rol específico
```

#### **Gestión de Pacientes**
```sql
PACIENTE
- Información demográfica y médica básica
- Puede ser atendido en múltiples departamentos

TIPO_SANGRE
- Catálogo de tipos sanguíneos (A+, B-, O+, etc.)
- Centralizado para uso de todos los departamentos

HISTORIA_CLINICA
- Registro médico principal del paciente
- Accesible entre departamentos con permisos
```

#### **Gestión de Citas**
```sql
TIPO_CITA
- Diferentes tipos de consulta (general, especializada, etc.)
- Define duración y costo base

CITA
- Programación de consultas paciente-médico
- Incluye diagnóstico preliminar y observaciones
```

#### **Gestión de Medicamentos**
```sql
MEDICAMENTO
- Inventario centralizado de farmacia
- Control de stock, vencimientos y precios

LABORATORIO
- Fabricantes de medicamentos
- Información de contacto y registro

CATEGORIA_MEDICAMENTO
- Clasificación farmacológica (antibióticos, analgésicos, etc.)

PRESCRIPCION
- Receta médica vinculada a historia clínica

DETALLE_PRESCRIPCION
- Medicamentos específicos en cada prescripción
- Dosis, frecuencia, duración del tratamiento
```

#### **Gestión de Equipamiento**
```sql
EQUIPAMIENTO
- Equipos médicos de cada departamento
- Control de estado, mantenimiento y calibración

TIPO_EQUIPAMIENTO
- Clasificación de equipos (rayos X, monitores, etc.)

PROVEEDOR
- Empresas que suministran equipamiento

MANTENIMIENTO_EQUIPO
- Historial de mantenimientos preventivos y correctivos
```

#### **Gestión de Seguridad**
```sql
USUARIO_SISTEMA
- Credenciales de acceso para empleados
- Encriptación de contraseñas y recuperación

SESION_USUARIO
- Control de sesiones activas
- Auditoría de accesos al sistema

ACCESO_HISTORIA
- Log de accesos a historias clínicas
- Justificación y trazabilidad completa
```

---

## 🔗 RELACIONES PRINCIPALES

### **Cardinalidades Importantes**

#### **1:1 (Uno a Uno)**
- `PACIENTE` ↔ `HISTORIA_CLINICA`: Un paciente tiene una historia única
- `EMPLEADO` ↔ `USUARIO_SISTEMA`: Un empleado tiene un usuario único

#### **1:N (Uno a Muchos)**
- `DEPARTAMENTO` → `EMPLEADO`: Un departamento tiene muchos empleados
- `PACIENTE` → `CITA`: Un paciente puede tener muchas citas
- `EMPLEADO` → `CITA`: Un empleado atiende muchas citas
- `HISTORIA_CLINICA` → `PRESCRIPCION`: Una historia contiene muchas prescripciones
- `PRESCRIPCION` → `DETALLE_PRESCRIPCION`: Una prescripción tiene muchos medicamentos

#### **N:M (Muchos a Muchos)**
- `EMPLEADO` ↔ `HISTORIA_CLINICA`: A través de `ACCESO_HISTORIA`
  - Un empleado puede acceder a muchas historias
  - Una historia puede ser accedida por muchos empleados (con permisos)

---

## 🎯 DISTRIBUCIÓN DE DATOS

### **Criterios de Distribución**

#### **DATOS LOCALES (Alta Frecuencia)**
✅ **EMPLEADO**: Personal específico del departamento  
✅ **CITA**: Agenda departamental  
✅ **EQUIPAMIENTO**: Recursos físicos del departamento  
✅ **USUARIO_SISTEMA**: Acceso rápido y seguro  

#### **DATOS REPLICADOS (Local + Central)**
🔄 **PACIENTE**: Local para acceso rápido + Central para compartir  
🔄 **HISTORIA_CLINICA**: Local para consulta + Central para acceso transversal  
🔄 **PRESCRIPCION**: Local para crear + Central para auditoría  

#### **DATOS CENTRALIZADOS (Compartidos)**
☁️ **MEDICAMENTO**: Inventario único de farmacia  
☁️ **LABORATORIO**: Catálogo global de proveedores  
☁️ **TIPO_SANGRE**: Clasificación estándar  

---

## 🔒 CONTROL DE ACCESO SIMPLIFICADO

### **Roles Básicos**
```sql
MEDICO:
- Crear/modificar historias clínicas
- Prescribir medicamentos
- Consultar pacientes de cualquier departamento
- Crear/modificar citas

ADMINISTRATIVO:
- Registrar pacientes
- Programar citas
- Consultar información básica
- Generar reportes

FARMACEUTICO:
- Gestionar inventario de medicamentos
- Consultar prescripciones
- Actualizar stock y precios

DIRECTOR_DEPARTAMENTO:
- Acceso completo a su departamento
- Consultar reportes interdepartamentales
- Gestionar personal del departamento
```

### **Permisos Inter-departamentales**
- **Médicos**: Pueden consultar historias de otros departamentos
- **Directores**: Acceso a reportes consolidados
- **Emergencias**: Acceso temporal sin restricciones
- **Auditoría**: Log completo de accesos externos

---

## 🛠️ IMPLEMENTACIÓN POSTGRESQL

### **Configuración Básica**
```sql
-- Base de datos por departamento
CREATE DATABASE hospital_cardiologia;
CREATE DATABASE hospital_neurologia;
CREATE DATABASE hospital_urgencias;

-- Base de datos central
CREATE DATABASE hospital_central;

-- Esquema idéntico en todas las instancias
-- Solo difieren los datos almacenados
```

### **Sincronización Básica**
```sql
-- Replicación de catálogos (maestro → locales)
MEDICAMENTO, LABORATORIO, CATEGORIA_MEDICAMENTO
TIPO_SANGRE, TIPO_EQUIPAMIENTO, PROVEEDOR

-- Consolidación de datos (locales → central)
PACIENTE, HISTORIA_CLINICA, PRESCRIPCION
ACCESO_HISTORIA (para auditoría global)
```

---

## 📈 BENEFICIOS DEL DISEÑO

### **Operacionales**
✅ **Autonomía**: Cada departamento opera independientemente  
✅ **Compartir**: Acceso controlado a información de otros departamentos  
✅ **Farmacia**: Inventario centralizado evita duplicación  
✅ **Trazabilidad**: Auditoría completa de accesos  

### **Técnicos**
✅ **Rendimiento**: Datos locales = acceso rápido  
✅ **Disponibilidad**: Operación offline garantizada  
✅ **Escalabilidad**: Fácil agregar nuevos departamentos  
✅ **Seguridad**: Control granular por roles  

### **Académicos**
✅ **Normalización**: Cumple 3FN (Tercera Forma Normal)  
✅ **Integridad**: Constraints y foreign keys apropiadas  
✅ **Distribución**: Ejemplo real de BD distribuida  
✅ **Complejidad**: Nivel apropiado para BD1  

---

## 🎓 CUMPLIMIENTO DE REQUERIMIENTOS

### **✅ Requerimientos Académicos Cumplidos**

| Requerimiento | Implementación |
|---------------|----------------|
| **Autonomía departamental** | Tablas locales por departamento |
| **Recursos compartidos** | MEDICAMENTO, LABORATORIO centralizados |
| **Acceso por roles** | ROL_EMPLEADO con permisos JSON |
| **Historias transversales** | ACCESO_HISTORIA con justificación |
| **PostgreSQL homogéneo** | Esquema idéntico, datos distribuidos |
| **Encriptación contraseñas** | password_hash + salt en USUARIO_SISTEMA |
| **Recuperación contraseñas** | token_recuperacion con expiración |

### **📚 Conceptos Aplicados**
- **Modelo Entidad-Relación**: Diseño completo con cardinalidades
- **Normalización**: Eliminación de redundancias hasta 3FN
- **Integridad Referencial**: Foreign keys apropiadas
- **Constraints**: Primary keys, unique, check constraints
- **Distribución**: Estrategia de datos local vs centralizado
- **Seguridad**: Encriptación básica y control de acceso

---

