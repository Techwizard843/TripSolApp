const express = require('express');
const axios = require('axios');

const router = express.Router();

router.post('/', async (req, res) => {
  const { destination } = req.body;

  if (!destination) {
    return res.status(400).json({ error: 'Missing destination' });
  }

  try {
    const [weatherRes, hotelRes, foodRes, recoRes] = await Promise.all([
      axios.post('http://localhost:5001/weather', { city: destination }),
      axios.get(`http://localhost:5001/hotel?city=${encodeURIComponent(destination)}`),
      axios.get(`http://localhost:5001/food/${encodeURIComponent(destination)}`),
      axios.post('http://localhost:8000/search', { userinput: destination }), 
    ]);

    res.status(200).json({
      weather: weatherRes.data,
      hotels: hotelRes.data,
      food: foodRes.data,
      recommendations: recoRes.data
    });

  } catch (err) {
  console.error('❌ tripdetails error:', err);

  if (err.response) {
    console.error('❌ Failing sub-call status:', err.response.status);
    console.error('❌ Failing sub-call data:', err.response.data);
    console.error('❌ Failing sub-call config:', err.response.config.url);
  }

  res.status(500).json({ error: 'Could not fetch trip details' });
}

});

module.exports = router;
