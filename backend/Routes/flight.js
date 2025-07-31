const express = require('express');
const https = require('https');

const router = express.Router();

const API_KEY = '642bcd1296f00c14c124e34534f63553';
const HOST = 'api.aviationstack.com';

function buildPath(from, to) {
  let path = `/v1/flights?access_key=${API_KEY}&limit=100`;
  if (from) path += `&dep_iata=${from}`;
  if (to) path += `&arr_iata=${to}`;
  return path;
}

const MAX_RETRIES = 3;
const RETRY_DELAY_MS = 1000;

function delay(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function formatFlightData(data, date) {
  return data
    .filter(flight => {
      if (!date) return true;
      const depDate = flight.departure?.scheduled?.split('T')[0]; // e.g. "2025-08-01"
      return depDate === date;
    })
    .map(flight => ({
      airline: flight.airline?.name || 'Unknown',
      flight_number: flight.flight?.number || 'N/A',
      departure_airport: flight.departure?.airport || 'Unknown',
      arrival_airport: flight.arrival?.airport || 'Unknown',
      departure_time: flight.departure?.scheduled || 'N/A',
      arrival_time: flight.arrival?.scheduled || 'N/A',
      status: flight.flight_status || 'N/A'
    }));
}

async function fetchFlightsWithRetry(path, retries = MAX_RETRIES) {
  return new Promise((resolve, reject) => {
    function attempt(attemptNumber) {
      const options = {
        hostname: HOST,
        path,
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
    const { from, to, date } = req.query;

    if (!from || !to) {
      return res.status(400).json({ error: "Please provide both 'from' and 'to' IATA codes" });
    }

    const path = buildPath(from, to);
    const result = await fetchFlightsWithRetry(path);

    let flights = result?.data;
    const formatted = formatFlightData(flights, date);

    if (!formatted || formatted.length === 0) {
      const mockFlightData = [
        {
          flight_number: 'AI203',
          airline: 'Air India',
          from: from,
          to: to,
          departure_time: '10:00',
          arrival_time: '12:30',
          duration: '2h 30m',
        },
        {
          flight_number: '6E509',
          airline: 'IndiGo',
          from: from,
          to: to,
          departure_time: '15:00',
          arrival_time: '17:30',
          duration: '2h 30m',
        },
      ];

      return res.status(200).json({
        source: from,
        destination: to,
        count: mockFlightData.length,
        flights: mockFlightData,
      });
    }

    res.status(200).json({ count: formatted.length, flights: formatted });

  } catch (error) {
    console.error('Flight fetch failed:', error.message);
    res.status(500).json({ error: 'Oops! Something went wrong.' });
  }
});

module.exports = router;