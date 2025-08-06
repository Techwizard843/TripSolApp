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
        seen = set()
        with open(self.searchdata, 'r') as f:
            return [line.strip() for line in f if line.strip() and not (line.strip() in seen or seen.add(line.strip()))]
    
    def _save_search(self, query):
        if query not in self.searches:
            with open(self.searchdata, 'a') as f:
                f.write(query + '\n')

    def _update_vectors(self):
        if self.searches:
            self.vectors = self.vectorizer.fit_transform(self.searches)
        else:
            self.vectors = None

    def clean_query(self, query):
        return ' '.join(query.lower().strip().split())

    def add(self, query):
        query = self.clean_query(query)
        if query not in self.searches:
            self.searches.append(query)
            self._save_search(query)
            self._update_vectors()

    def recommend(self, top_n=5):
        return self.searches[-top_n:][::-1]

if __name__ == "__main__":
    action = sys.argv[1]
    query = sys.argv[2]

    r = Recommender()

    if action == 'add':
        r.add(query)
    elif action == 'recommend':
        top_n = int(query) if query.isdigit() else 5
        result = r.recommend(query)
        print(json.dumps(result))
