
const express = require('express');
const axios = require('axios');

const router = express.Router();

router.post('/', async (req, res) => {
  const { userinput } = req.body;

  if (!userinput) {
    return res.status(400).json({ error: 'Missing userinput' });
  }

  try {
   
    const response = await axios.post('http://localhost:8000/search', {
      userinput: userinput,
    });

    res.status(200).json({
      message: "Recommendation fetched successfully",
      data: response.data,
    });

  } catch (error) {
    console.error('Error calling Siddhi ML:', error.message);
    res.status(500).json({ error: 'Failed to get recommendation' });
  }
});

module.exports = router;
