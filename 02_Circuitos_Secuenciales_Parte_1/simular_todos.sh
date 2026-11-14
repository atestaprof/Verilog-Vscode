#!/usr/bin/env bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CATEGORY_NAME="$(basename "$BASE_DIR")"

echo "================================================================================"
echo " INICIANDO SIMULACIÓN POR LOTES: $CATEGORY_NAME"
echo " Directorio base: $BASE_DIR"
echo "================================================================================"

TOTAL=0
PASSED=0
FAILED=0

shopt -s nullglob

for project_dir in "$BASE_DIR"/*/; do
    [ -d "$project_dir" ] || continue
    project_dir="${project_dir%/}"
    project_name="$(basename "$project_dir")"

    v_files=("$project_dir"/*.v)
    if [ "${#v_files[@]}" -eq 0 ]; then
        continue
    fi

    TOTAL=$((TOTAL + 1))
    build_dir="$project_dir/build"
    vvp_file="$build_dir/sim.vvp"

    echo ""
    echo "--------------------------------------------------------------------------------"
    echo " [PROYECTO $TOTAL] Simulando: $project_name"
    echo "--------------------------------------------------------------------------------"

    mkdir -p "$build_dir"

    echo " -> Compilando archivos Verilog con iverilog..."
    iverilog -o "$vvp_file" "${v_files[@]}"
    if [ $? -eq 0 ]; then
        echo " [OK] Compilación exitosa: $vvp_file"
    else
        echo " [ERROR] Falló la compilación en: $project_name"
        FAILED=$((FAILED + 1))
        continue
    fi

    echo " -> Ejecutando simulación con vvp (Directorio de trabajo: build/)..."
    pushd "$build_dir" > /dev/null || {
        echo " [ERROR] No se pudo acceder a: $build_dir"
        FAILED=$((FAILED + 1))
        continue
    }

    vvp "$vvp_file"
    sim_status=$?
    popd > /dev/null || true

    if [ $sim_status -eq 0 ]; then
        vcd_files=("$build_dir"/*.vcd)
        if [ "${#vcd_files[@]}" -gt 0 ]; then
            echo " [OK] Simulación exitosa. Archivo(s) VCD generado(s): $(basename "${vcd_files[0]}")"
            PASSED=$((PASSED + 1))
        else
            echo " [ADVERTENCIA] Simulación finalizó pero no se encontró archivo .vcd en build/"
            FAILED=$((FAILED + 1))
        fi
    else
        echo " [ERROR] Falló la simulación en: $project_name"
        FAILED=$((FAILED + 1))
    fi
done

echo ""
echo "================================================================================"
echo " RESUMEN FINAL ($CATEGORY_NAME)"
echo " Total: $TOTAL | Exitosos: $PASSED | Fallidos: $FAILED"
echo "================================================================================"

[ "$FAILED" -eq 0 ]
