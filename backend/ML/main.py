import os
os.environ["KMP_DUPLICATE_LIB_OK"] = "TRUE"

from fastapi import FastAPI
from pydantic import BaseModel, Field
from recommender import Recommender
import pandas as pd
from txtai.embeddings import Embeddings
from rapidfuzz import process
import requests

# Hardcoded ML server URL (no environment variable)
ML_SERVER_URL = "https://tripsolapp-ml.onrender.com"

app = FastAPI()
recommender = Recommender()

BASE_DIR = os.path.dirname(__file__)
df2_path = os.path.join(BASE_DIR, "data", "indiadata.csv")
df_path = os.path.join(BASE_DIR, "data", "Destination,Type.csv")

df2 = pd.read_csv(df2_path)
df = pd.read_csv(df_path)

types = df["type"].dropna().astype(str).unique().tolist()
dest = df2["destination"].dropna().astype(str).unique().tolist()

tembedding = Embeddings({"path": "sentence-transformers/all-MiniLM-L6-v2"})
dembedding = Embeddings({"path": "sentence-transformers/all-MiniLM-L6-v2"})
tembedding.index(types)
dembedding.index(dest)

def recommendation(typewise):
    result = tembedding.search(typewise, 1)
    if not result:
        return {"error": "No matching category found."}

    typematch = types[result[0][0]]
    destypes = df[df['type'].str.lower() == typematch.lower()]
    return destypes[['destination']].to_dict(orient="records")

def recommend(citywise):
    result2 = dembedding.search(citywise, 1)
    if not result2:
        match, score, _ = process.extractOne(citywise, dest)
        if score > 80:
            city = match
        else:
            return {"error": "No matching category found."}
    else:
        city = dest[result2[0][0]]

    places = df2[df2['destination'].str.lower() == city.lower()]
    return places[['attraction', 'entry_fee', 'time_required', 'best_time_to_visit']].to_dict(orient="records")

class Query(BaseModel):
    userinput: str
    from_: str = Field(..., alias="from")
    to: str
    date: str

@app.post("/search")
def usersearch(query: Query):
    userinput = query.userinput.strip().lower()
    recommender.add(userinput)

    try:
        ml_response = requests.post(
            f"{ML_SERVER_URL}/search",
            json={"userinput": userinput},
            timeout=5
        )
        if ml_response.status_code == 200:
            return ml_response.json()
    except Exception:
        pass  # fallback to local processing if ML server unreachable

    dres = dembedding.search(userinput, 1)
    tres = tembedding.search(userinput, 1)

    di = dres[0][1] if dres else 0
    ti = tres[0][1] if tres else 0

    if di > ti and di > 0.5:
        place = dest[dres[0][0]]
        return recommend(place)
    elif ti > di and ti > 0.5:
        tmatch = types[tres[0][0]]
        return recommendation(tmatch)
    else:
        return {"error": "No confident match found."}

@app.get("/recommend")
def recommend_home():
    results = recommender.recommend()
    return {"recommendations": results}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=int(os.environ.get("PORT", 8000)))
