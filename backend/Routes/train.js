const fetch = require('node-fetch');
const API_KEY = '6094f7b6dbmsh2ed9d57bd388470p1c067djsnf6bc725f4bc3';
const BASE_URL = 'https://trains.p.rapidapi.com/';

async function getTrainData(req, res) {
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
      return res.status(404).json({ message: 'No train data found.' });
    }

    const filtered = data.filter(train =>
      train.train_from.toLowerCase().includes(from.toLowerCase()) &&
      train.train_to.toLowerCase().includes(to.toLowerCase())
    );

    if (filtered.length === 0) {
      return res.status(404).json({ message: `No trains found from ${from} to ${to}.` });
    }

    const results = filtered.map(train => ({
      train_number: train.train_num,
      from: train.train_from,
      to: train.train_to,
      name: train.train_name
    }));

    res.status(200).json({ count: results.length, trains: results });

  } catch (error) {
    console.error('Train API error:', error);
    res.status(500).json({ error: 'Something went wrong while fetching train data.' });
  }
}

module.exports = { getTrainData };
