const express = require('express');
const env = require('dotenv');
const app = express();
const cors = require('cors');

// Routers
const nft = require('./routes/nft');


app.use(express.json());
app.use(cors());
app.use("/api", nft);


app.listen(process.env.PORT, () => {
    console.log(`Port Is listening on ${process.env.PORT}`);
})