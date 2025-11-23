const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './app/components/**/*.{erb,rb,js}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Poppins', ...defaultTheme.fontFamily.sans],
      },
      fontWeight: {
        normal: 400,
        semibold: 500,
        bold: 700,
      },
      colors: {
        'primary50': '#D7F6F9',
        'primary100': '#A3D8E4',
        'primary200': '#7FC5D3',
        'primary300': '#5BA2B9',
        'primary400': '#4C7E8F',
        'primary500': '#3B5E6E',
        'primary600': '#2C4B5A',
        'primary700': '#1C3E4F',
        'primary800': '#0F2A3A',
        'primary900': '#0C1F27',
        'primary1000': '#081414',
        'secondary50': '#FFC990',
        'secondary100': '#E6A06B',
        'secondary200': '#C17D4A',
        'secondary300': '#9F5B29',
        'secondary400': '#7C3A08',
        'secondary500': '#5A1A00',
        'secondary600': '#8C4F2E',
        'secondary700': '#6A2F0D',
        'secondary800': '#4A1A00',
        'secondary900': '#2C0C00',
        'secondary1000': '#1A0800',
        'grey50': '#FFFFFF',
        'grey100': '#F9FAFB',
        'grey200': '#DFDFDF',
        'grey300': '#F2F4F7',
        'grey400': '#EAECF0',
        'grey500': '#D0D5DD',
        'grey600': '#98A2B3',
        'grey700': '#667085',
        'grey800': '#475467',
        'grey900': '#344054',
        'grey1000':'#1D2939',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
