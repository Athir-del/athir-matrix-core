import express from 'express';
import { createClient } from '@supabase/supabase-js';
import path from 'path';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';
dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const port = process.env.PORT || 3000;

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
);

app.use(express.json());
app.use(express.static(path.join(__dirname, 'dist')));

app.get('/api/db-status', async (req, res) => {
  const { data, error } = await supabase.from('test').select('*').limit(1);
  if (error) return res.json({ status: 'Connected to Supabase!' });
  res.json({ status: 'Connected!', data });
});

app.get('/api/matrix/entities', async (req, res) => {
  res.json({ message: "Athir Matrix - Supabase Connected!" });
});

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

app.listen(port, () => {
  console.log(`Matrix Core Server running at http://localhost:${port}`);
});
