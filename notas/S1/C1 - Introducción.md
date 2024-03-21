### Dependencias

nasm:
```
sudo apt get install nasm
nasm
```
qemu:
```
sudo apt get install qemu
qemu-system-x86_64
```

### Arquitecturas x86 y Von Neumann
#### Registros
([ref](https://i.imgur.com/nHMUcng.png))
- Generales
- De instrucción
- De estado
- De propósito específico
- MSRs (depurado)
#### Unidad de Control
Gestiona el bucle de ejecución (pipeline).
 IF - ID - EX - MEM - WB
#### PIC
Se encarga de gestionar las interrupciones. Antiguamente 2x 8259 en cascada. Actualmente APIC (multiprocesador).
#### Memoria virtual
Cada proceso tiene un mapa de memoria propio. Las direcciones se traducen mediante la tabla de páginas. Tiene hardware dedicado (mmu) y caché (TLB).

Ej: Segmentation fault es el resultadod euna señal/interrupción del mmu. Te dice que has intentado acceder a una dirección que "no existe". Sin mapeo mediante mmap o malloc la memoria virtual no tiene correlación con memoria real.
### Fase 0 - Hello World!
Ejecutar boot.asm. Se copia al Floppy Disk Adapter (como `dd if boot of`).
```
nasm -fbin boot.asm
qemu-system-x86_64 -fda
```
##### Llamadas al sistema

##### Subrutinas
`call` es equivalente a 
```
push 0x11
jmp func
```
y `ret` es equivalente a 
```
pop dir_retorno_de_la_pila
jmp dir_retorno_de_la_pila
```

##### Funciones
**Diferencia importante respecto subrutinas**: cuando bp y sp son iguales significa que la pila está vacía. Cuando llamamos a una función **y no a una subrutina** se crea un marco nuevo en la pila.

```
push %rbp           ; guardamos el puntero de la pila anterior
mov %rsp, %rbp
...
pop %rbp
ret
```
El archivo ejecutable tiene `AA55` al final que es la marca (signature) del MBR. [link](https://stackoverflow.com/a/53921270)