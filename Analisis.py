
# coding: utf-8

# In[1]:

from mvpa2.suite import *
import os.path


# # Variables iniciales

# In[12]:

datapath = '/media/sf_usr/share/data/objetos/data' #depending on the experiment to be run

subj = 1 #participante
maskName = 'L_AIPs' #nombre de la mascara a cargar
maskFolder = 'orig' #folder del cual se debe obtener la mascara
runsToTrain = [1,3,5] #corridas para entrenar
runsToTest = [2,4,6] #corridas para probar
HemoCor = 6
model = 1
task = 1
dhandle = OpenFMRIDataset(datapath) #crea un handle del sitio donde se encuentran los datos
subjString = 'sub' + '%03d' % n #string que denota el participante a cargar





# # Cargar los datos para entrenar al clasificador

# In[ ]:

run_datasets = [] #array donde se meteran los datos
for run_id in runsToTrain: #Se mueve corrida por corrida para cargar cada dato
    # genera path de la mascara
    mask_fname = os.path.join(datapath, 'sub001', 'masks', 'orig', 'L_AIPs' + '.nii.gz')
    # carga los vectores 
    run_events = dhandle.get_bold_run_model(model, subj, run_id)
    # carga la corrida pero solamente el volumen comprendido dentro de la mascara
    run_ds = dhandle.get_bold_run_dataset(subj, task, run_id, chunks=run_id -1, mask=mask_fname)
    #correccion hemodinamica
    if HemoCor != 0:
        for i, ar in enumerate(run_events):
            run_events[i]['onset'] = run_events[i]['onset'] + HemoCor
    # convierte run_events y lo asigna a targets
    run_ds.sa['targets'] = events2sample_attr(
                run_events, run_ds.sa.time_coords, noinfolabel='rest')
    #asigna del dataset al array que contiene todos
    run_datasets.append(run_ds)
fdsTrain = vstack(run_datasets, a=0)


# # Cargar los datos para probar al clasificador

# In[ ]:

run_datasets2 = [] #array donde se meteran los datos
for run_id in runsToTest: #Se mueve corrida por corrida para cargar cada dato
    # genera path de la mascara
    mask_fname = os.path.join(datapath, subjString, 'masks', maskFolder, maskName + '.nii.gz')
    # carga los vectores 
    run_events = dhandle.get_bold_run_model(model, subj, run_id)
    # carga la corrida pero solamente el volumen comprendido dentro de la mascara
    run_ds = dhandle.get_bold_run_dataset(subj, task, run_id, chunks=run_id -1, mask=mask_fname)
    #correccion hemodinamica
    if HemoCor != 0:
        for i, ar in enumerate(run_events):
            run_events[i]['onset'] = run_events[i]['onset'] + HemoCor
    # convierte run_events y lo asigna a targets
    run_ds.sa['targets'] = events2sample_attr(
                run_events, run_ds.sa.time_coords, noinfolabel='rest')
    #asigna del dataset al array que contiene todos
    run_datasets2.append(run_ds)
fdsTest = vstack(run_datasets2, a=0)


# # Procesado previo a la clasificación

# In[ ]:

#Correccion
detrender = poly_detrend(fdsTrain, polyord=1, chunks_attr='chunks')

#conversion a puntaje z
zscore(fdsTrain, param_est=('targets', ['rest']))

#Remueve los volumenes asociados a la linea base
fdsTrain = fdsTrain[fds.sa.targets != 'rest']

#promedia los targets en cada chunk
run_averager = mean_group_sample(['targets', 'chunks'])
fdsTrain = fdsTrain.get_mapped(run_averager)


# In[ ]:

#Correccion
poly_detrend(fdsTest, polyord=1, chunks_attr='chunks')

#conversion a puntaje z
zscore(fdsTest, param_est=('targets', ['rest']))

#Remueve los volumenes asociados a la linea base
fdsTest = fdsTest[fdsTest.sa.targets != 'rest']

#promedia los targets en cada chunk
run_averager = mean_group_sample(['targets', 'chunks'])
fdsTest = fdsTest.get_mapped(run_averager)


# # Clasificación

# In[ ]:

#Crea un objeto del clasificador
clf = LinearCSVMC()
clf.train(fdsTrain)
err = clf(ds_split1)
print np.asscalar(err)




