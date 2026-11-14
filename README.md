# Colección de Diseños RTL y Bancos de Pruebas en Verilog (`Verilog-Vscode`)

Repositorio de diseño digital y verificación funcional en **Verilog HDL**, que reúne **29 módulos RTL** acompañados de sus respectivos bancos de pruebas (*testbenches*) autoverificables y volcado de formas de onda (`.vcd`), organizados por nivel de complejidad lógica y equipados con scripts maestros de simulación automatizada multiplataforma para herramientas de código abierto (**Icarus Verilog** y **GTKWave**).

### Principios de Diseño y Verificación del Repositorio
* **Diseño RTL en Verilog:** Implementaciones modulares combinacionales, secuenciales síncronas/asíncronas, máquinas de estados finitos (FSM), memorias y rutas de datos segmentadas (*pipeline*).
* **Testbenches Autoverificables (*Self-Checking*):** Cada diseño cuenta con su propio banco de pruebas (`*_tb.v`) que compara las salidas del dispositivo bajo prueba (*DUT*) contra un modelo de referencia y reporta el resultado en consola.
* **Generación Modular de Estímulos:** Uso de tareas (`task`) en Verilog para inyectar vectores de prueba deterministas y pseudoaleatorios (`$random`).
* **Trazabilidad de Formas de Onda:** Todos los testbenches incluyen las directivas `$dumpfile` y `$dumpvars` para generar archivos `.vcd` listos para inspección temporal en **GTKWave** o **TerosHDL**.

---

## Estructura del Repositorio

El proyecto está clasificado en tres categorías principales según la naturaleza lógica y complejidad arquitectónica de cada circuito. Cada categoría cuenta con scripts maestros de simulación (`simular_todos.sh` para Linux/macOS/WSL y `simular_todos.ps1` para Windows) que compilan y ejecutan cada subproyecto de forma aislada dentro de una subcarpeta temporal `build/` (excluida del control de versiones mediante `.gitignore`):

```text
Verilog-Vscode/
├── .gitignore                                  # Excluye build/, *.vvp, *.vcd y carpetas temporales
├── README.md                                   # Documentación general y catálogo de los 29 circuitos
├── Design Questions.docx                       # Documento complementario de ejercicios de diseño
│
├── 01_Circuitos_Combinacionales/               # 10 proyectos combinacionales (sin reloj ni memoria)
│   ├── simular_todos.sh                        # Script maestro Bash (Linux / macOS / WSL)
│   ├── simular_todos.ps1                       # Script maestro PowerShell (Windows)
│   ├── 1_bit_sumador_completo_usando_mediosumador/
│   ├── 4_bits_SC_usando_ms/
│   ├── ALU/
│   ├── Binary to Gray/
│   ├── Full Adder/
│   ├── Half Adder/
│   ├── Mux Conditional/
│   ├── Mux expresseion/
│   ├── Mux using case/
│   └── Number of 1s/
│
├── 02_Circuitos_Secuenciales_Parte_1/          # 7 circuitos secuenciales básicos (Flip-Flops, registros, divisores)
│   ├── simular_todos.sh                        # Script maestro Bash (Linux / macOS / WSL)
│   ├── simular_todos.ps1                       # Script maestro PowerShell (Windows)
│   ├── 3_bit_up_down_counter/
│   ├── Async_DFF/
│   ├── Clock Divider/
│   ├── Custom Design/
│   ├── PIPO/
│   ├── Sync DFF/
│   └── n bit universal shift register/
│
└── 03_Circuitos_Secuenciales_Parte_2/          # 12 sistemas secuenciales avanzados (FSM, RAM, FIFO, Multiplicadores)
    ├── simular_todos.sh                        # Script maestro Bash (Linux / macOS / WSL)
    ├── simular_todos.ps1                       # Script maestro PowerShell (Windows)
    ├── 4_bit_LFSR/
    ├── 4_bit_counter/
    ├── Async_FIFO/
    ├── Dual Port RAM/
    ├── Mealy Nonoverlap/
    ├── Mealy Overlap/
    ├── Moore Nonoverlap/
    ├── Moore Overlap/
    ├── Pipeline Multiplier/
    ├── Sequential Multiplier/
    ├── Single Port RAM/
    └── Sync FIFO/
```

> **Nota sobre artefactos de compilación (`build/`):** Al ejecutar los scripts de simulación, dentro de cada proyecto se crea automáticamente un directorio `<Proyecto>/build/` donde se almacenan el binario compilado (`sim.vvp`) y el archivo de formas de onda (`*.vcd`), manteniendo limpio el directorio fuente.

---

## Requisitos e Instalación de Herramientas

Para compilar, simular y visualizar las formas de onda de este repositorio se requieren las siguientes herramientas de código abierto:
* **`iverilog`** (*Icarus Verilog*): Compilador y sintetizador para simulación de Verilog (IEEE 1364).
* **`vvp`** (*Icarus Verilog vvp runtime*): Motor de ejecución de simulación (incluido con `iverilog`).
* **`gtkwave`**: Visor gráfico de formas de onda para archivos `.vcd`.

### Linux (Debian / Ubuntu / WSL)
```bash
sudo apt update
sudo apt install -y iverilog gtkwave
```

### macOS (Homebrew)
```bash
brew install icarus-verilog
brew install --cask gtkwave
```
*(Alternativamente, puede utilizarse el paquete precompilado [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build)).*

### Windows (OSS CAD Suite / Scoop / Chocolatey)
* **Opción recomendada (OSS CAD Suite o instalador oficial):** Descargar el instalador de [Icarus Verilog para Windows (bleyer.org)](https://bleyer.org/icarus/) (que incluye GTKWave) o [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build) y agregar la carpeta `bin` a la variable de entorno `PATH`.
* **Con Scoop:**
  ```powershell
  scoop install iverilog gtkwave
  ```
* **Con Chocolatey (PowerShell como Administrador):**
  ```powershell
  choco install iverilog gtkwave -y
  ```

---

## Instrucciones de Ejecución de Simulaciones

### 1. Simulación por Categoría (Scripts Maestros)

Cada carpeta principal contiene dos scripts que recorren automáticamente todos los subproyectos de su categoría, compilan los archivos `.v`, ejecutan el testbench mostrando su salida en consola y verifican la creación del archivo `.vcd` dentro de `build/`.

#### En Linux, macOS o WSL (Bash)
```bash
# Dar permisos de ejecución (solo es necesario la primera vez)
chmod +x ./01_Circuitos_Combinacionales/simular_todos.sh
chmod +x ./02_Circuitos_Secuenciales_Parte_1/simular_todos.sh
chmod +x ./03_Circuitos_Secuenciales_Parte_2/simular_todos.sh

# Ejecutar las simulaciones por categoría
./01_Circuitos_Combinacionales/simular_todos.sh
./02_Circuitos_Secuenciales_Parte_1/simular_todos.sh
./03_Circuitos_Secuenciales_Parte_2/simular_todos.sh
```

#### En Windows (PowerShell)
```powershell
powershell -ExecutionPolicy Bypass -File .\01_Circuitos_Combinacionales\simular_todos.ps1
powershell -ExecutionPolicy Bypass -File .\02_Circuitos_Secuenciales_Parte_1\simular_todos.ps1
powershell -ExecutionPolicy Bypass -File .\03_Circuitos_Secuenciales_Parte_2\simular_todos.ps1
```

### 2. Simulación Individual y Visualización de Ondas

Si deseas compilar, simular e inspeccionar las formas de onda de un circuito individual (por ejemplo, `ALU`), ejecuta los siguientes comandos desde la raíz del repositorio:

```bash
# 1. Crear la carpeta de salida build/ dentro del proyecto
mkdir -p "./01_Circuitos_Combinacionales/ALU/build"

# 2. Compilar el módulo RTL y su testbench con iverilog
iverilog -o "./01_Circuitos_Combinacionales/ALU/build/sim.vvp" \
  "./01_Circuitos_Combinacionales/ALU/alu.v" \
  "./01_Circuitos_Combinacionales/ALU/alu_tb.v"

# 3. Ejecutar la simulación desde la carpeta build/ para generar el archivo .vcd allí dentro
cd "./01_Circuitos_Combinacionales/ALU/build"
vvp sim.vvp

# 4. Visualizar las formas de onda en GTKWave
gtkwave alu_tb.vcd
```

---

## Catálogo Completo de Circuitos (29 Proyectos)

### 1. `01_Circuitos_Combinacionales` (Proyectos 1 al 10)

| # | Proyecto | Módulo Principal / Testbench | Descripción Técnica |
| :-: | :--- | :--- | :--- |
| 1 | [1_bit_sumador_completo_usando_mediosumador](./01_Circuitos_Combinacionales/1_bit_sumador_completo_usando_mediosumador/) | **RTL:** `sumador_completo.v` (`module sumador_completo`), `medio_sumador.v` (`module medio_sumador`)<br>**TB:** `sumador_completo_tb.v` (`module sumador_completo_tb`) | Sumador completo jerárquico de 1 bit construido mediante dos instancias de medio sumador (`medio_sumador`) y asignaciones continuas (`assign`), con salidas directas (`o_sum`, `o_carry`) y negadas (`o_nsum`, `o_ncarry`). |
| 2 | [4_bits_SC_usando_ms](./01_Circuitos_Combinacionales/4_bits_SC_usando_ms/) | **RTL:** `full_add_4bit.v` (`module full_add_4bit`, `full_half_add_1bit`, `half_adder`)<br>**TB:** `full_add_4bit_tb.v` (`module full_add_4bit_tb`) | Sumador de propagación de acarreo (*Ripple Carry Adder*) de 4 bits estructurado jerárquicamente con 4 sumadores completos de 1 bit basados en medios sumadores. |
| 3 | [ALU](./01_Circuitos_Combinacionales/ALU/) | **RTL:** `alu.v` (`module alu`)<br>**TB:** `alu_tb.v` (`module alu_tb`) | Unidad Aritmética Lógica combinacional (`always @(*)`) con operandos de 4 bits, selector de 2 bits para 4 operaciones (`+`, `-`, `*`, `/`) y generación de 5 banderas de estado (`zero`, `carry`, `sign`, `parity`, `overflow`). |
| 4 | [Binary to Gray](./01_Circuitos_Combinacionales/Binary%20to%20Gray/) | **RTL:** `bin_gry.v` (`module bin_gry`)<br>**TB:** `bin_gry_tb.v` (`module bin_gry_tb`) | Conversor de código Binario a Gray parametrizable (`#(parameter N = 8)`) implementado mediante operación XOR bit a bit entre bits adyacentes (`always @(binary)`). |
| 5 | [Full Adder](./01_Circuitos_Combinacionales/Full%20Adder/) | **RTL:** `full_adder_1bit.v` (`module full_adder_1bit`)<br>**TB:** `full_adder_1bit_tb.v` (`module full_adder_1bit_tb`) | Sumador completo combinacional de 1 bit implementado directamente mediante ecuaciones booleanas de flujo de datos (`assign`) para suma (`o_sum`) y acarreo de salida (`o_carry`). |
| 6 | [Half Adder](./01_Circuitos_Combinacionales/Half%20Adder/) | **RTL:** `half_adder.v` (`module half_adder`)<br>**TB:** `half_adder_tb.v` (`module half_adder_tb`) | Medio sumador combinacional de 1 bit implementado mediante compuertas XOR (`i_a ^ i_b`) y AND (`i_a & i_b`) con asignaciones continuas (`assign`). |
| 7 | [Mux Conditional](./01_Circuitos_Combinacionales/Mux%20Conditional/) | **RTL:** `mux_condt.v` (`module mux_condt`)<br>**TB:** `mux_condt_tb.v` (`module mux_condt_tb`) | Multiplexor combinacional 4:1 con canales de datos de 2 bits (`in0`–`in3`) y línea de selección de 2 bits, descrito con operadores condicionales ternarios anidados (`?:`). |
| 8 | [Mux expresseion](./01_Circuitos_Combinacionales/Mux%20expresseion/) | **RTL:** `mux_always.v` (`module mux_always`)<br>**TB:** `mux_always_tb.v` (`module mux_always_tb`) | Multiplexor combinacional 2:1 de 1 bit implementado mediante la ecuación booleana de suma de productos (`(~select & in0) \| (select & in1)`). |
| 9 | [Mux using case](./01_Circuitos_Combinacionales/Mux%20using%20case/) | **RTL:** `mux_case.v` (`module mux_case`)<br>**TB:** `mux_case_tb.v` (`module mux_case_tb`) | Multiplexor combinacional 4:1 con canales de datos de 2 bits implementado mediante un bloque procedimental con estructura de selección `case (select)`. |
| 10 | [Number of 1s](./01_Circuitos_Combinacionales/Number%20of%201s/) | **RTL:** `no_1s.v` (`module no_1s`)<br>**TB:** `no_1s_tb.v` (`module no_1s_tb`) | Contador de unos (*population count*) sobre una palabra de entrada de 16 bits (`i_a`) con salida de 4 bits (`no_ones`), implementado mediante acumulación secuencial bit a bit sincronizada por `posedge clk`. |

---

### 2. `02_Circuitos_Secuenciales_Parte_1` (Proyectos 11 al 17)

| # | Proyecto | Módulo Principal / Testbench | Descripción Técnica |
| :-: | :--- | :--- | :--- |
| 11 | [3_bit_up_down_counter](./02_Circuitos_Secuenciales_Parte_1/3_bit_up_down_counter/) | **RTL:** `cntr_3ud.v` (`module cntr_3ud`)<br>**TB:** `cntr_3ud_tb.v` (`module cntr_3ud_tb`) | Contador binario bidireccional (*Up/Down*) de 3 bits disparado por flanco positivo (`posedge clk`), con reset síncrono, control de dirección (`up_down`) y salidas complementarias (`q`, `nq`). |
| 12 | [Async_DFF](./02_Circuitos_Secuenciales_Parte_1/Async_DFF/) | **RTL:** `dff_async.v` (`module dff_async`)<br>**TB:** `dff_async_tb.v` (`module dff_async_tb`) | Flip-Flop tipo D de 1 bit con disparo por flanco ascendente de reloj y reset asíncrono activo en alto (`always @(posedge clk or posedge reset)`), con salidas `o_q` y `o_qb`. |
| 13 | [Clock Divider](./02_Circuitos_Secuenciales_Parte_1/Clock%20Divider/) | **RTL:** `clkdivider.v` (`module clkdivider`)<br>**TB:** `clkdivider_tb.v` (`module clkdivider_tb`) | Divisor de frecuencia síncrono por factor de 4 basado en un contador interno de 2 bits (`clk_count`) y reset síncrono activo en alto (`posedge clk`). |
| 14 | [Custom Design](./02_Circuitos_Secuenciales_Parte_1/Custom%20Design/) | **RTL:** `custdesign.v` (`module custdesign`, `module srff`)<br>**TB:** `custdesign_tb.v` (`module custdesign_tb`) | Circuito secuencial síncrono compuesto por dos Flip-Flops SR (`srff`, `posedge clk`) interconectados mediante lógica combinacional XOR/NOT con entrada `x` y salida `y`. |
| 15 | [PIPO](./02_Circuitos_Secuenciales_Parte_1/PIPO/) | **RTL:** `pipo_shift.v` (`module pipo_shift`)<br>**TB:** `pipo_shift_tb.v` (`module pipo_shift_tb`) | Registro de entrada y salida paralela (*PIPO*) de 16 bits síncrono (`posedge clk`) con habilitación de carga (`load`) y selector de 2 bits (`shift_en`) para desplazamientos lógicos y aritméticos (`<<`, `>>`, `<<<`, ASR). |
| 16 | [Sync DFF](./02_Circuitos_Secuenciales_Parte_1/Sync%20DFF/) | **RTL:** `dff_sync.v` (`module dff_sync`)<br>**TB:** `dff_sync_tb.v` (`module dff_sync_tb`) | Flip-Flop tipo D de 1 bit con reset síncrono activo en alto (`always @(posedge clk)`) y salidas complementarias (`o_q`, `o_qb`). |
| 17 | [n bit universal shift register](./02_Circuitos_Secuenciales_Parte_1/n%20bit%20universal%20shift%20register/) | **RTL:** `univ_shift.v` (`module univ_shift`)<br>**TB:** `univ_shift_tb.v` (`module univ_shift_tb`) | Registro de desplazamiento universal parametrizable (`#(parameter n = 16)`) con 4 modos de operación controlados por `control[1:0]`: retención (`hold`), desplazamiento izquierdo, desplazamiento derecho y carga paralela (`siso`). |

---

### 3. `03_Circuitos_Secuenciales_Parte_2` (Proyectos 18 al 29)

| # | Proyecto | Módulo Principal / Testbench | Descripción Técnica |
| :-: | :--- | :--- | :--- |
| 18 | [4_bit_LFSR](./03_Circuitos_Secuenciales_Parte_2/4_bit_LFSR/) | **RTL:** `lfsr.v` (`module lfsr`)<br>**TB:** `lfsr_tb.v` (`module lfsr_tb`) | Registro de desplazamiento con realimentación lineal (*LFSR*) de 4 bits síncrono (`posedge clk`), con polinomio de realimentación XOR (`data_out[1] ^ data_out[0]`) y protección contra bloqueo en cero. |
| 19 | [4_bit_counter](./03_Circuitos_Secuenciales_Parte_2/4_bit_counter/) | **RTL:** `counter4bit.v` (`module counter4bit`)<br>**TB:** `counter4bit_tb.v` (`module counter4bit_tb`) | Contador secuencial complejo de 4 bits con secuencia personalizada de 14 estados (`S0`–`S13`), reset asíncrono, habilitación de conteo (`enable`) y control de carga (`load`). |
| 20 | [Async_FIFO](./03_Circuitos_Secuenciales_Parte_2/Async_FIFO/) | **RTL:** `asyncfifo.v` (`module asyncfifo`)<br>**TB:** `asyncfifo_tb.v` (`module asyncfifo_tb`) | Cola FIFO asíncrona de 8 palabras por 8 bits con dominios de reloj independientes de escritura (`write_clk`) y lectura (`read_clk`), punteros de 3 bits y banderas `mem_full` y `mem_empty`. |
| 21 | [Dual Port RAM](./03_Circuitos_Secuenciales_Parte_2/Dual%20Port%20RAM/) | **RTL:** `dualport_ram.v` (`module dualport_ram`)<br>**TB:** `dualportram_tb.v` (`module dualportram_tb`) | Memoria RAM síncrona de doble puerto verdadero (*True Dual-Port RAM*) de 8 palabras de 128 bits (`ram_vector[7:0]`), con buses de direcciones (`addr_a`, `addr_b`), datos y escritura independientes por puerto. |
| 22 | [Mealy Nonoverlap](./03_Circuitos_Secuenciales_Parte_2/Mealy%20Nonoverlap/) | **RTL:** `mealy_nonol.v` (`module mealy_nonol`)<br>**TB:** `mealy_nonol_tb.v` (`module mealy_nonol_tb`) | Máquina de estados finitos (FSM) tipo Mealy de 4 estados (`S0`–`S3`) detectora de la secuencia serie `1101` sin solapamiento, con reset asíncrono activo en alto. |
| 23 | [Mealy Overlap](./03_Circuitos_Secuenciales_Parte_2/Mealy%20Overlap/) | **RTL:** `mealy_ol.v` (`module mealy_ol`)<br>**TB:** `mealy_ol_tb.v` (`module mealy_ol_tb`) | Máquina de estados finitos (FSM) tipo Mealy de 4 estados (`S0`–`S3`) detectora de la secuencia serie `1101` con solapamiento, permitiendo reutilizar el último bit detectado. |
| 24 | [Moore Nonoverlap](./03_Circuitos_Secuenciales_Parte_2/Moore%20Nonoverlap/) | **RTL:** `moore_nonol.v` (`module moore_nonol`)<br>**TB:** `moore_nonol_tb.v` (`module moore_nonol_tb`) | Máquina de estados finitos (FSM) tipo Moore de 5 estados (`S0`–`S4`) detectora de la secuencia serie `1101` sin solapamiento, con salida dependiente únicamente del estado presente. |
| 25 | [Moore Overlap](./03_Circuitos_Secuenciales_Parte_2/Moore%20Overlap/) | **RTL:** `moore_ol.v` (`module moore_ol`)<br>**TB:** `moore_ol_tb.v` (`module moore_ol_tb`) | Máquina de estados finitos (FSM) tipo Moore de 5 estados (`S0`–`S4`) detectora de la secuencia serie `1101` con solapamiento (transición de `S4` a `S2` cuando `in = 1`). |
| 26 | [Pipeline Multiplier](./03_Circuitos_Secuenciales_Parte_2/Pipeline%20Multiplier/) | **RTL:** `pipeline.v` (`module pipeline`), `vdcmul_64b.v`..`vdcmul_2b.v`, `rca64.v`..`rca_4b.v`, `half_adder.v`<br>**TB:** `pipeline_tb.v` (`module pipeline_tb`) | Multiplicador Védico segmentado (*pipelined*) de 64x64 bits con producto de salida de 128 bits (`prod`), estructurado jerárquicamente con multiplicadores Védicos de 2 a 32 bits, sumadores RCA de hasta 64 bits y registros interetapa. |
| 27 | [Sequential Multiplier](./03_Circuitos_Secuenciales_Parte_2/Sequential%20Multiplier/) | **RTL:** `seqmult.v` (`module seqmult`)<br>**TB:** `seqmult_tb.v` (`module seqmult_tb`) | Multiplicador secuencial síncrono de 8x8 bits con resultado de 16 bits (`out_prod`) y bandera de validez (`out_valid`), basado en generación registrada y suma de 8 productos parciales desplazados. |
| 28 | [Single Port RAM](./03_Circuitos_Secuenciales_Parte_2/Single%20Port%20RAM/) | **RTL:** `singleport_ram.v` (`module singleport_ram`)<br>**TB:** `singleportram_tb.v` (`module singleportram_tb`) | Memoria RAM síncrona de puerto único (*Single-Port RAM*) de 8 palabras por 128 bits (`ram_vector[7:0]`), con dirección registrada de 3 bits (`addr`) y control de escritura/lectura (`wr_en`). |
| 29 | [Sync FIFO](./03_Circuitos_Secuenciales_Parte_2/Sync%20FIFO/) | **RTL:** `syncfifo.v` (`module syncfifo`)<br>**TB:** `syncfifo_tb.v` (`module syncfifo_tb`) | Cola FIFO síncrona de 8 palabras por 8 bits controlada por un único reloj (`clk`), con reset asíncrono activo en bajo, punteros de lectura/escritura, contador de ocupación y banderas `full` y `empty`. |

---

## Créditos y Referencias
* Basado inicialmente en la colección de ejemplos [snbk001/Verilog-Design-Examples](https://github.com/snbk001/Verilog-Design-Examples), ampliado con módulos didácticos en español, correcciones RTL, estandarización de volcado `.vcd` y automatización multiplataforma para **VS Code / TerosHDL / Icarus Verilog**.
