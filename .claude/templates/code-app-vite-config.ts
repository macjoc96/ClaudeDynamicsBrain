import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import * as path from 'path'

// https://vite.dev/config/
export default defineConfig({
  // CRITICAL: Must be "./" for Power Apps Code App deployment
  base: "./",

  server: {
    // :: means listen on all interfaces
    host: "::",
    // CRITICAL: Power Apps Code Apps require port 3000
    port: 3000,
  },

  plugins: [react()],

  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
});
