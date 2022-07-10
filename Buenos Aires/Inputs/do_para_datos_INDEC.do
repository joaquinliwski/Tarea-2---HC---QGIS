cd  "/Users/camilasury/Desktop/Herramientas computacionales/QGIS"


* Guardar el archivo con .xlsx e Importar desde Stata. 
* Borrar el archivo .xls asi tenemos menos archivos!
erase condicion.xls
import excel "$INPUT/condicion.xlsx", sheet("condicion") firstrow clear

* Generar variable =1 si tiene la palabra desocupado, otra si tiene la palabra AREA
gen d=strpos(Condicindeactividad, "Desocupado")>0
gen a=strpos(Condicindeactividad, "AREA")>0
* Me quedo sólo con esas observaciones
keep if d==1 | a==1
* Elimino variables
drop d a B D
* Achico el tamaño de la columna (compress disminuye el tamaño en MB de la base)
compress
* Divido la variable de un lado y del otro del # para quedarme con el número de área por separado
split Condicindeactividad, p("#")
* Elimino variables
drop Condicindeactividad1 Condicindeactividad
* Pego el número de área al valor que le corresponde
gen area= Condicindeactividad2[_n-1]
* Elimino variable
drop Condicindeactividad2
* Elinimo observaciones vacías
drop if C==""
* Genero código para quedarme con 02 y 06
gen code=substr(area,1,2)
* Me doy cuenta que hay espacios antes de los número, RECALCULANDO...
drop code
gen code=substr(area,1,3)
* Cambio code de string a número
destring code, replace
* Borro los que no son BS AS
drop if code>6
* Renombro
ren C UNEMP
* Cambio a número
destring UNEMP, replace
* Elimino variable
drop code
* Guardo (en general tendría una carpeta que se llama OUTPUT... pero no vamos a tener tantos outputs)
export delimited using "/Users/camilasury/Desktop/Herramientas computacionales/QGIS/act_bsas.csv", replace

* Guardar el archivo con .xlsx e Importar desde Stata. 
* Borrar el archivo .xls asi tenemos menos archivos!
erase nbi.xls
import excel "/Users/camilasury/Desktop/Herramientas computacionales/QGIS/NBI.xlsx", sheet("nbi") clear firstrow case(lower)
** REPEAT
gen d1=strpos(almenosunindicadornbi, "con NBI")>0
gen a1=strpos(almenosunindicadornbi, "AREA")>0
keep if d1==1 | a1==1
drop d1 a1
drop b d
compress
split almenosunindicadornbi, p("#")
drop almenosunindicadornbi1 almenosunindicadornbi
gen area= almenosunindicadornbi[_n-1]
drop almenosunindicadornbi2
drop if c==""
gen code=substr(area,1,3)
destring code, replace
drop if code>6
ren c NBI
destring NBI, replace
drop code
export delimited using "/Users/camilasury/Desktop/Herramientas computacionales/QGIS/nbi_bsas.csv", replace
