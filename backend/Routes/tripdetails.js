const express = require('express');
const axios = require('axios');

const router = express.Router();

router.post('/', async (req, res) => {
  const { destination, from, to, date } = req.body;

  if (!destination || !from || !to) {
    return res.status(400).json({ error: 'Missing required fields: destination, from, to' });
  }

  try {
    const [weatherRes, hotelRes, foodRes, recoRes, flightRes, trainRes] = await Promise.all([
      axios.post('http://localhost:5001/weather', { city: destination }),
      axios.get(`http://localhost:5001/hotel?city=${encodeURIComponent(destination)}`),
      axios.get(`http://localhost:5001/food/${encodeURIComponent(destination)}`),
      axios.post('http://localhost:8000/search', {userinput: destination,from, to, date}),
      axios.post(`http://localhost:5001/flight`, { userinput: destination, from, to, date }),
      axios.post('http://localhost:5001/trains', { from, to })
    ]);

    res.status(200).json({
      weather: weatherRes.data,
      hotels: hotelRes.data,
      food: foodRes.data,
      recommendations: recoRes.data,
      flights: flightRes.data,
      trains: trainRes.data
    });

  } catch (err) {
    console.error('TripDetails error:', err);

    if (err.response) {
      console.error('Failing sub-call status:', err.response.status);
      console.error('Failing sub-call data:', err.response.data);
      console.error('Failing sub-call URL:', err.response.config?.url);
    }

    res.status(500).json({ error: 'Could not fetch full trip details.' });
  }
});

module.exports = router;