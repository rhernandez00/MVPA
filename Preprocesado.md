# Comandos para realizar el preprocesado

## Obtener el primer volumen de la primera adquisición

`fslroi <input> <output> 0 1`

Ejemplo:

`fslroi 8.nii.gz A0.nii.gz 0 1`

## Alinear una adquisición 

En este paso se alinea una adquisición con el volumen inicial  (extraido en el paso anterior), "referencia" corresponde al archivo extraido en el paso anterior

`mcflirt -in <input> -r <referencia>`

Ejemplo:

`mcflirt -in 60.nii.gz -r A0.nii.gz`
