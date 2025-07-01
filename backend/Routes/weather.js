const express = require('express');
const router = express.Router();

const fetch = require('node-fetch'); // If you're using node-fetch

const API_KEY = '468a4c077643285196266d757b961c70';

function formatWeatherData(weather) {
  return {
    city: weather.name || 'Unknown',
    temperature: weather.main?.temp ? `${weather.main.temp}°C` : 'N/A',
    condition: weather.weather?.[0]?.description || 'N/A',
    humidity: weather.main?.humidity !== undefined ? `${weather.main.humidity}%` : 'N/A',
    wind: weather.wind?.speed !== undefined ? `${weather.wind.speed} m/s` : 'N/A'
  };
}

async function fetchWithRetry(url, options = {}, retries = 2) {
  let attempts = 0;
  let response;

  while (attempts <= retries) {
    try {
      response = await fetch(url, options);
      if (response.ok) {
        return response;
      }
    } catch (err) {
      if (attempts === retries) {
        throw err;
      }
    }
    attempts++;
  }
  return response;
}

router.get('/:city', async (req, res) => {
  const city = req.params.city;
  const url = `https://api.openweathermap.org/data/2.5/weather?q=${city}&units=metric&appid=${API_KEY}`;

  try {
    const response = await fetchWithRetry(url);
    const weather = await response.json();
    if (weather.cod !== 200) {
      return res.status(404).json({ success: false, message: weather.message || 'City not found' });
    }
    res.json({
      success: true,
      data: formatWeatherData(weather),
      message: `Weather data for ${city} now available.`
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Oops! Something went wrong.', error: error.message });
  }
});

router.post('/', async (req, res) => {
  const city = req.body.location;
  if (!city) {
    return res.status(400).json({ success: false, message: 'City name is required in the request body.' });
  }

  const url = `https://api.openweathermap.org/data/2.5/weather?q=${city}&units=metric&appid=${API_KEY}`;

  try {
    const response = await fetchWithRetry(url);
    const weather = await response.json();
    if (weather.cod !== 200) {
      return res.status(404).json({ success: false, message: weather.message || 'City not found' });
    }
    res.json({
      success: true,
      data: formatWeatherData(weather),
      message: `Weather data for ${city} now available.`
    });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Oops! Something went wrong.', error: error.message });
  }
});

module.exports = router;
