import type { Config } from 'tailwindcss'
import path from 'path'

const config: Config = {
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
    './src/config/**/*.{js,ts,jsx,tsx,mdx}',
    './pages/**/*.{html,js}',
    './components/**/*.{html,js}',
    path.join(path.dirname(require.resolve('@aww-vzc/react')), '**/*.{js,ts,jsx,tsx,mdx}'),
  ],
  theme: {
    extend: {
      backgroundImage: {
        'gradient-radial': 'radial-gradient(var(--tw-gradient-stops))',
        'gradient-conic':
          'conic-gradient(from 180deg at 50% 50%, var(--tw-gradient-stops))',
      },
    },
  },

  plugins: [],
}
export default config
