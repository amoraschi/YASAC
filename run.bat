@echo off

echo -------------------------

iverilog -o code.out src/yasac_tb.v
echo - Compiled successfully

if "%1" == "--out" (
  echo -------------------------
  vvp code.out
  echo -------------------------
  echo - Executed successfully
) else (
  vvp code.out > compiled.log
  echo - Executed successfully
)

echo -------------------------
