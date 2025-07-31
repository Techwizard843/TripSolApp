import pandas as pd
import numpy as np
import txtai
from txtai.embeddings import Embeddings
from rapidfuzz import process
import os

BASE_DIR = os.path.dirname(__file__)
df2_path = os.path.join(BASE_DIR, "data", "indiadata.csv")
df_path = os.path.join(BASE_DIR, "data", "Destination,Type.csv")

df2 = pd.read_csv(df2_path)
df = pd.read_csv(df_path)

types=df["type"].dropna().astype(str).unique().tolist()
dest=df2["destination"].dropna().astype(str).unique().tolist()

tembedding=Embeddings({"path": "sentence-transformers/all-MiniLM-L6-v2"})
dembedding=Embeddings({"path": "sentence-transformers/all-MiniLM-L6-v2"})
tembedding.index(types)
dembedding.index(dest)


def recommendation(typewise):
    result = tembedding.search(typewise, 1)
    if not result:
            return "No matching category found."

    typematch = types[result[0][0]]
    
    destypes = df[df['type'].str.lower() == typematch.lower()]
    return destypes[['destination']].to_dict(orient="records")

def recommend(citywise):
    result2 = dembedding.search(citywise, 1)
    if not result2 :
        match, score, _ = process.extractOne(citywise, dest)
        if score > 80:
            city = match
        else:
            return "No matching category found."

    city = dest[result2[0][0]]
  
    places = df2[df2['destination'].str.lower()==city.lower()]
    return places[['attraction', 'entry_fee', 'time_required', 'best_time_to_visit']].to_dict(orient="records")

def usersearch(userinput):
    userinput = userinput.strip().lower()

    dres = dembedding.search(userinput, 1)
    tres = tembedding.search(userinput, 1)

    di= dres[0][1] if dres else 0
    ti= tres[0][1] if tres else 0

    if di>ti and di>0.5:
        place = dest[dres[0][0]]
        return recommend(place)

    elif ti>di and ti>0.5:
        tmatch = types[tres[0][0]]
        return recommendation(tmatch)

    else: 
        return {"error"}
        
    

    
    

