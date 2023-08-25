const express = require('express');
const axios = require('axios');

const app = express();
const port = 3000;
const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:4050';

// Integrate backend with the frontend
app.get('/', async (req, res) => {
    try {
        const response = await axios.get(BACKEND_URL);
        const visits = response.data;

        const html = `
            <!DOCTYPE html>
            <html>
            <head>
                <title>Visit Counter</title>
            </head>
            <body>
                <h1>Visit Counter</h1>
                <p>Number of visits: ${visits}</p>
            </body>
            </html>
        `;

        res.send(html);
    } catch (error) {
        console.error('Error fetching visit count:', error);
        res.status(500).send('Failed to fetch visit count');
    }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
