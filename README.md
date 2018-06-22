# MVPA
Código en general e instrucciones para utilizar Neurodebian y PyMVPA

Para instalar la máquina virtual y Neurodebian, seguir las instrucciones en el archivo pdf

## Instalación de pip:

Para instalar **pip** de manera nativa se requiere instalar las dependencias:

    sudo apt install libffi-dev libssl-dev

Una vez hecho esto se puede instalar pip con

    sudo apt install pip

La instalación de pip también se puede realizar externa al gestor de paquetes  `apt` descargando
[get-pip.py](https://pip.pypa.io/en/stable/installing/) en el escritorio.
En una nueva terminal y acceder al escritorio e instalar con el comando :

    sudo python get-pip.py

Una vez instalado pip se puede actualizar mediante:

    sudo pip install -U pip

## Insatalación de Jupyter notebook

Poner en la terminal:

    sudo pip install jupyter

## Instalación de FSL

    sudo apt-get install fsl-complete

Abrir una terminal y editar el archivo .bashrc:

    sudo gedit .bashrc

Agregar al final del archivo:

    FSLDIR=/usr/share/fsl/5.0
    . ${FSLDIR}/etc/fslconf/fsl.sh
    PATH=${FSLDIR}/bin:${PATH}
    export FSLDIR PATH

Guardar el archivo y cerrar. Es necesario cerrar la terminal o utilizar

    source ~/.bashrc

Para que los `PATH's` se carguen en la memoria. 
Puedes verificar que sí se escribió editándolo de nuevo y comprobando que el código que agregaste sigue ahí.

