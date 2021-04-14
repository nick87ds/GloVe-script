#!/usr/bin/env python3
# coding: utf-8

# In[1]:


# In[2]:


from glob import glob, iglob
import json
import re
import sys

# In[139]:


def get_data():

    for file in iglob('output/*/*'):
        for documents in open(file).readlines():
            
                jdata = json.loads(documents)
            
                article = jdata['title'] + " "+ jdata['text']
                
                if len(article) > 100:
                    yield article
                else:
                    pass


# In[140]:


def cleaner(text):
        
    text = re.sub(r'\W|\d', "  ", text)
    text = re.sub('[ ]+', ' ', text)
    text = re.sub(r'\n', ' ', text)
    
    return text.lower()


# In[141]:


datas = get_data()


# In[146]:


print(cleaner(next(datas)))


# In[147]:


# dati


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[225]:


# json_files = iter(glob('output/*/*'))

# json_files = iter(glob('output/*/*'))


# In[540]:


# files = (file for file in glob('output/*/*'))


# In[100]:


# next(files)


# In[548]:


# lines = (open_files(file) for file in files)


# In[99]:


# next(lines)


# In[556]:


# estrai_articolo = (json.loads(line) for line in lines)


# In[101]:


# estrai_articolo


# In[459]:


# next(json_files)


# In[458]:


# with open('output/AK/wiki_31') as f:
#     lines = f.readlines()


# In[457]:


# for line in lines:
#     print(line)
#     print("__________________________")


# In[102]:


# def open_files(file):
        
#     with open(file, encoding='utf-8') as f:
#         lines = f.readlines()
        
#         for line in lines:
#             yield line


# In[537]:


# estrai_articolo = (json.loads(line) for line in lines)


# In[103]:


# next(estrai_articolo)


# In[ ]:





# In[ ]:





# In[104]:


# next(estrai_articolo(open_files(json_files)))


# In[ ]:





# In[ ]:





# In[105]:


# def open_json(file):
    
#     with open(file, encoding='utf-8') as f:
    
#         jdata = f.readlines()

#         yield jdata


# In[106]:


# json_data = (open_json(json_file) for json_file in json_files)


# In[107]:


# def estrai_json(jdatas):
    
#     for jdata in jdatas:
        
#         yield jdata
        
# #         text = json.loads(jdata)
# #         title = text['title']
# #         article = text['text']
        
# #         text = title + " " + article
        
# #         if len(text) > 100:
# #             yield text
        
# #         else:            
# #             pass


# In[108]:


# articoli = (estrai_json(json_file) for json_file in json_data)


# In[109]:


# def estrai_articolo(articoli_json):
    
#         text = json.loads(articoli_json)
#         title = text['title']
#         article = text['text']
        
#         text = title + " " + article
        
#         if len(text) > 100:
#             yield text
        
#         else:            
#             pass


# In[110]:


# text = (estrai_articolo(articolo) for articolo in articoli)


# In[158]:


# next(text)


# In[ ]:





# In[159]:


# articoli = (estrai_articolo(articolo) for articolo in json_data)


# In[160]:


# next(articoli)


# In[111]:


# text = (cleaner(articolo) for articolo in text)


# In[112]:


# next(text)


# In[149]:


import concurrent.futures


# In[150]:


with concurrent.futures.ProcessPoolExecutor() as ppe:
    
    while True:
        
        try:
            ppe.submit(print(cleaner(next(datas))))
        except StopIteration:
            sys.exit()
    

