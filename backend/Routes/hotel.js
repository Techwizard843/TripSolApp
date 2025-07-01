const express = require('express');
const router = express.Router();
const https = require('https');

const FOURSQUARE_API_KEY = 'YOUR_API_KEY';
const BASE_URL = 'https://api.foursquare.com/v3/places/search';
const MAX_RETRIES = 3;
const RETRY_DELAY_MS = 1000;

function formatPlaces(data) {
  return data.map(place => ({
    name: place.name,
    category: place.categories?.[0]?.name || 'Unknown',
    address: place.location?.formatted_address || 'Address not available',
    map: `https://www.google.com/maps?q=${place.geocodes?.main?.latitude},${place.geocodes?.main?.longitude}`
  }));
}

function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function fetchWithRetry(url, headers, retries = MAX_RETRIES) {
  return new Promise((resolve, reject) => {
    const attemptFetch = (attempt) => {
      const options = { headers };
      https.get(url, options, (res) => {
        let rawData = '';
        res.on('data', chunk => rawData += chunk);
        res.on('end', async () => {
          if (res.statusCode === 200) {
            try {
              const parsed = JSON.parse(rawData);
              resolve(parsed);
            } catch (err) {
              reject(new Error('Received invalid JSON structure'));
            }
          } else if ((res.statusCode === 429 || res.statusCode >= 500) && attempt < retries) {
            console.warn(`Attempt ${attempt} failed (status ${res.statusCode}). Retrying in ${RETRY_DELAY_MS}ms...`);
            await delay(RETRY_DELAY_MS);
            attemptFetch(attempt + 1);
          } else {
            reject(new Error(`Request failed with status ${res.statusCode}`));
          }
        });
      }).on('error', err => reject(err));
    };
    attemptFetch(1);
  });
}

async function handleHotelRequest(city, res) {
  const url = `${BASE_URL}?query=hotel&near=${encodeURIComponent(city)}&limit=10`;
  const headers = { Authorization: FOURSQUARE_API_KEY };

  try {
    const data = await fetchWithRetry(url, headers);
    if (!data?.results || data.results.length === 0) {
      return res.status(404).json({ message: `No hotels found in ${city}` });
    }

    const formatted = formatPlaces(data.results);
    res.json(formatted);
  } catch (error) {
    console.error('Fetch error:', error.message);
    res.status(500).json({ error: 'Oops! Something went wrong. Try again later.' });
  }
}

router.get('/:city', (req, res) => {
  const city = req.params.city;
  handleHotelRequest(city, res);
});

module.exports = router;
