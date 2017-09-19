# MVPA
Código en general e instrucciones para utilizar Neurodebian y PyMVPA

Para instalar la máquina virtual y Neurodebian, seguir las instrucciones en el archivo pdf

## Instalación de pip:

Descargar get-pip.py [en este link] (https://pip.pypa.io/en/stable/installing/)
Poner en el escritorio
Abrir una nueva terminal y acceder al escritorio
Poner en la terminal:

`sudo pip install jupyter`

## Instalación de FSL

`sudo apt-get install fsl-complete`

Abrir una terminal y editar el archivo .bashrc:

`sudo gedit .bashrc`

Agregar al final del archivo:

`FSLDIR=/usr/share/fsl/5.0`

`. ${FSLDIR}/etc/fslconf/fsl.sh`

`PATH=${FSLDIR}/bin:${PATH}`

`export FSLDIR PATH`
