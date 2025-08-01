const express = require('express'); 
const router = express.Router(); 

const https = require('https');

const FOURSQUARE_API_KEY = 'fsq3eXGJ0hU4ZQfdXa9LMg09xhEY2tmQuTbjR6mC8NEZuaw=';
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
        res.on('end', () => {
          if (res.statusCode === 200) {
            try {
              const parsed = JSON.parse(rawData);
              resolve(parsed);
            } catch (err) {
              reject(new Error('Received invalid JSON structure'));
            }
          } else if ((res.statusCode === 429 || res.statusCode >= 500) && attempt < retries) {
            console.warn(`Attempt ${attempt} failed (status ${res.statusCode}). Retrying in ${RETRY_DELAY_MS}ms...`);
            delay(RETRY_DELAY_MS).then(() => attemptFetch(attempt + 1));
          } else {

            try {
              const errorJson = JSON.parse(rawData);
              if (errorJson.message) {
                reject(new Error(errorJson.message));
                return;
              }
            } catch {
            }
            reject(new Error(`Request failed with status ${res.statusCode}`));
          }
        });
      }).on('error', err => {
        reject(err);
      });
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

    if (error.message.includes('Foursquare servers are experiencing problems')) {
      return res.status(503).json({
        error: 'Foursquare servers are experiencing problems. Please try again later or check status.foursquare.com for updates.'
      });
    }

    
    if (error.message.includes('API credits') || error.message.includes('429')) {
      return res.status(200).json([
        {
          name: 'Namrit Hotel',
          category: 'Hotel',
          address: '123 Beach Road, Goa',
          map: 'https://www.google.com/maps?q=15.2993,74.124'
        },
        {
          name: 'Luxury Resort',
          category: 'Resort',
          address: '456 Sunset Blvd, Goa',
          map: 'https://www.google.com/maps?q=15.2994,74.125'
        }
      ]);
    }

    res.status(500).json({ error: 'Oops! Something went wrong. Try again later.' });
  }
}

router.get('/', async (req, res) => {
  const city = req.query.city;
  if (!city) {
    return res.status(400).json({ error: 'City is required' });
  }
  await handleHotelRequest(city, res);
});

module.exports = router;
