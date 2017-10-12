
# coding: utf-8

# # RSA representational simmilarity analysis

# In[1]:

from mvpa2.suite import *
datapath = '/media/sf_usr/share/data/objetos/data'


# ## Cargando los datos 

# In[ ]:

dhandle = OpenFMRIDataset(datapath) #creates a handle for the data
run_datasets = []
for run_id in [1,2,3,4]:
    # obtiene el path de la máscara

    mask_fname = os.path.join(datapath, 'sub001', 'masks', 'orig', 'L_AIPs.nii.gz')
    # Carga el diseño
    run_events = dhandle.get_bold_run_model(1, 'sub001', run_id)
    # Carga la imagen funcional
    run_ds = dhandle.get_bold_run_dataset('sub001', 1, run_id, chunks=run_id -1, mask=mask_fname)
    # Carga los vectores
    run_ds.sa['targets'] = events2sample_attr(run_events, run_ds.sa.time_coords, noinfolabel='rest')
    # une los datos cargados en un solo array
    run_datasets.append(run_ds)
fds = vstack(run_datasets, a=0)


# ### Muestra lo que contienen los datos cargados

# In[ ]:

print fds.summary()


# ## Preprocesado

# ### Linear detrending

# In[ ]:

detrender = poly_detrend(fds, polyord=1, chunks_attr='chunks')


# ### Conversión a puntaje Z

# In[ ]:

zscore(fds, param_est=('targets', ['rest']))


# ### Remueve los volúmenes asignados a línea base

# In[ ]:

fds = fds[fds.sa.targets != 'rest']


# ### Promedia los volúmenes

# In[ ]:

from mvpa2.mappers.fx import mean_group_sample
mtgs = mean_group_sample(['targets'])
mtds = mtgs(ds)


# ### Mide las distancias entre categorías

# In[ ]:

dsm = rsa.PDist(square=True) 
res = dsm(mtds)


# ### Muestra los resultados en una figura

# In[ ]:

plot_mtx(res, mtds.sa.targets, 'ROI pattern correlation distances')

