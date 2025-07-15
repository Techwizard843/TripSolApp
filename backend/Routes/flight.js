
const express = require('express');
const https = require('https');

const router = express.Router();

const API_KEY = '642bcd1296f00c14c124e34534f63553'; 
const HOST = 'api.aviationstack.com';
const PATH = `/v1/flights?access_key=${API_KEY}&limit=10`;

const MAX_RETRIES = 3;
const RETRY_DELAY_MS = 1000;

function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function formatFlightData(data) {
  return data.map(flight => ({
    airline: flight.airline?.name || 'Unknown',
    flight_number: flight.flight?.number || 'N/A',
    departure: flight.departure?.airport || 'Unknown',
    arrival: flight.arrival?.airport || 'Unknown',
    status: flight.flight_status || 'N/A'
  }));
}

async function fetchFlightsWithRetry(retries = MAX_RETRIES) {
  return new Promise((resolve, reject) => {
    function attempt(attemptNumber) {
      const options = {
        hostname: HOST,
        path: PATH,
        method: 'GET'
      };

      const req = https.request(options, res => {
        let rawData = '';
        res.on('data', chunk => rawData += chunk);
        res.on('end', async () => {
          try {
            if (res.statusCode === 200) {
              const parsed = JSON.parse(rawData);
              resolve(parsed);
            } else if ((res.statusCode === 429 || res.statusCode >= 500) && attemptNumber < retries) {
              console.warn(`Retrying flight fetch... Attempt ${attemptNumber + 1}`);
              await delay(RETRY_DELAY_MS);
              attempt(attemptNumber + 1);
            } else {
              reject(new Error(`HTTP Error: ${res.statusCode}`));
            }
          } catch (err) {
            reject(new Error('Parsing Error'));
          }
        });
      });

      req.on('error', err => reject(err));
      req.end();
    }

    attempt(1);
  });
}

router.get('/', async (req, res) => {
  try {
    const result = await fetchFlightsWithRetry();
    if (!result?.data || result.data.length === 0) {
      return res.status(404).json({ message: 'No flight data available' });
    }

    const formatted = formatFlightData(result.data);
    res.json({ count: formatted.length, flights: formatted });
  } catch (error) {
    console.error('Flight fetch failed:', error.message);
    res.status(500).json({ error: 'Oops! Something went wrong.' });
  }
});

module.exports = router;
