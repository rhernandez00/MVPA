
# coding: utf-8

# # Análisis por máscara

# In[1]:

from mvpa2.suite import *
datapath = '/media/sf_usr/share/data/objetos/data'


# ## Cargando los datos 

# In[27]:

dhandle = OpenFMRIDataset(datapath) #creates a handle for the data
run_datasets = []
for run_id in [1,2,3,4]:
    # obtiene el path de la máscara

    mask_fname = os.path.join(datapath, 'sub001', 'masks', 'orig', 'L_AIPs.nii.gz')
    # Carga el diseño
    run_events = dhandle.get_bold_run_model(1, '001', run_id)
    # Carga la imagen funcional
    run_ds = dhandle.get_bold_run_dataset('001', 1, run_id, chunks=run_id -1, mask=mask_fname)
    # Carga los vectores
    run_ds.sa['targets'] = events2sample_attr(run_events, run_ds.sa.time_coords, noinfolabel='rest')
    # une los datos cargados en un solo array
    run_datasets.append(run_ds)
fds = vstack(run_datasets, a=0)


# ### Muestra lo que contienen los datos cargados

# In[16]:

print fds.summary()


# ## Preprocesado

# ### Linear detrending

# In[28]:

detrender = poly_detrend(fds, polyord=1, chunks_attr='chunks')


# ### Conversión a puntaje Z

# In[29]:

zscore(fds, param_est=('targets', ['rest']))


# ### Remueve los volúmenes asignados a línea base

# In[30]:

fds = fds[fds.sa.targets != 'rest']


# ### Promedia los volúmenes por cada corrida

# In[31]:

run_averager = mean_group_sample(['targets', 'chunks'])
fds = fds.get_mapped(run_averager)
fds.sa.runtype = ['odd','even','odd','even','odd','even','odd','even','odd','even','odd','even']


# In[39]:

type(fds.sa.chunks)


# ## Clasificación

# ### Crea una instancia del clasificador

# In[32]:

clf = LinearCSVMC()


# ### Hace una selección de los mejores vóxeles de acuerdo a un ANOVA
# 
# 

# In[33]:

fsel = SensitivityBasedFeatureSelection(OneWayAnova(), FractionTailSelector(0.05, mode='select', tail='upper'))
fclf = FeatureSelectionClassifier(clf, fsel)


# ### Validación cruzada

# In[40]:

cvte = CrossValidation(fclf, NFoldPartitioner(), errorfx=lambda p, t: np.mean(p == t), enable_ca=['stats'])


# ### Ejecución del análisis

# In[41]:

cv_results = cvte(fds)


# ## Resultados

# In[42]:

print cvte.ca.stats.as_string(description=True)


# In[47]:

cv_results.samples

