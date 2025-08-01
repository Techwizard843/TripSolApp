import os
import sys
import json
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

class Recommender:
    def __init__(self, searchdata='searches.txt'):
        self.searchdata = searchdata
        self.searches = self._load_searches()
        self.vectorizer = TfidfVectorizer(stop_words='english')
        self._update_vectors()

    def _load_searches(self):
        if not os.path.exists(self.searchdata):
            return []
        with open(self.searchdata, 'r') as f:
            return [line.strip() for line in f if line.strip()]

    def _save_search(self, query):
        with open(self.searchdata, 'a') as f:
            f.write(query + '\n')

    def _update_vectors(self):
        if self.searches:
            self.vectors = self.vectorizer.fit_transform(self.searches)
        else:
            self.vectors = None

    def add(self, query):
        self.searches.append(query)
        self._save_search(query)
        self._update_vectors()

    def recommend(self, query=None, top_n=5):
        if not self.vectors or not query:
            return []
        vec = self.vectorizer.transform([query])
        scores = cosine_similarity(vec, self.vectors).flatten()
        indices = scores.argsort()[::-1]
        return [self.searches[i] for i in indices if self.searches[i] != query][:top_n]

if __name__ == "__main__":
    action = sys.argv[1]
    query = sys.argv[2]

    r = Recommender()

    if action == 'add':
        r.add(query)
    elif action == 'recommend':
        result = r.recommend(query)
        print(json.dumps(result))
