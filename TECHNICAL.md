# Notas para Desarrolladores

## ¿Cómo funciona?

### RegexTool
Esta es la parte principal que maneja las expresiones regulares. Hace dos cosas:

1. **Revisa si la regex es válida**
   - Verifica que la sintaxis sea correcta
   - Revisa que los paréntesis () estén bien cerrados
   - Revisa que los corchetes [] estén bien cerrados

2. **Aplica la regex al texto**
   - Busca todas las coincidencias
   - Devuelve una lista con lo que encontró

### Pantalla Principal

La pantalla del analizador tiene:
- Campo para escribir la regex
- Editor de texto grande
- Lista donde aparecen las coincidencias
- Contador de líneas

## Diseño

### Fuentes
Usamos varias fuentes para que se vea mejor:
- Outfit: Para títulos
- Inter: Para texto normal
- Windpower: Para detalles especiales

### Colores
- Tema azul como base
- Funciona en modo claro y oscuro

## Tips para contribuir

1. **Mantén las cosas separadas**
   - La lógica de regex va en su propia clase
   - La interfaz va en widgets separados

2. **Maneja los errores**
   - Revisa que la regex sea válida
   - Muestra mensajes claros si hay errores

3. **Cuida el rendimiento**
   - No actualices la pantalla sin necesidad
   - Solo usa StatefulWidget cuando lo necesites