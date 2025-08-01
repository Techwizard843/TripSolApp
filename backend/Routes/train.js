const express = require('express');
const router = express.Router();
const fetch = require('node-fetch');

const API_KEY = '6094f7b6dbmsh2ed9d57bd388470p1c067djsnf6bc725f4bc3';
const BASE_URL = 'https://trains.p.rapidapi.com/';

router.post('/', async (req, res) => {
  const { from, to } = req.body;

  if (!from || !to) {
    return res.status(400).json({ error: 'Both `from` and `to` are required.' });
  }

  const searchTerm = from.length > to.length ? from : to;

  const url = `${BASE_URL}`;
  const options = {
    method: 'POST',
    headers: {
      'content-type': 'application/json',
      'X-RapidAPI-Key': API_KEY,
      'X-RapidAPI-Host': 'trains.p.rapidapi.com'
    },
    body: JSON.stringify({ search: searchTerm })
  };

  try {
    const response = await fetch(url, options);
    const data = await response.json();

    if (!data || !Array.isArray(data)) {
      throw new Error('Invalid data format from API');
    }

    const filtered = data.filter(train =>
      train.train_from.toLowerCase().includes(from.toLowerCase()) &&
      train.train_to.toLowerCase().includes(to.toLowerCase())
    );

    if (filtered.length === 0) {
      throw new Error(`No trains found from ${from} to ${to}`);
    }

    const results = filtered.map(train => ({
      train_number: train.train_num,
      from: train.train_from,
      to: train.train_to,
      name: train.train_name
    }));

    res.status(200).json({ source: from, destination: to, count: results.length, trains: results });

  } catch (error) {
    console.error('Train API failed:', error.message);

    const mockTrainData = [
      {
        train_number: '12345',
        train_name: 'Ambedkar Express',
        from: from,
        to: to,
        departure_time: '06:00',
        arrival_time: '14:00',
      },
      {
        train_number: '67890',
        train_name: 'Veerabhumi Superfast',
        from: from,
        to: to,
        departure_time: '20:00',
        arrival_time: '07:00',
      }
    ];

    res.status(200).json({
      source: from,
      destination: to,
      message: 'Returned mock data due to API failure or no results.',
      trains: mockTrainData
    });
  }
});

module.exports = router;