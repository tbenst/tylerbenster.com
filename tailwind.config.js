const plugin = require('tailwindcss/plugin')

module.exports = {
  plugins: [
    require('@tailwindcss/typography'),
  ],
  content: [
    './static/**/*.html',
    './static/**/*.markdown',
    './static/**/*.md',
  ],
  theme: {
    extend: {
      typography: (theme) => ({
        DEFAULT: {
          css: {
            blockquote: {
                fontWeight: '300',
            },
            p: {
              // 'text-align': 'justify',
            },
            figure: {
              img: {
                'margin-left': 'auto', // center
                'display' : 'block',
                'margin-right': 'auto', // center
              },
              figcaption: {
                'text-align': 'center', // center
                'margin-top': '0px', // no gap from photo
                'color': theme('colors.gray.500'),
              },
            },
            '.byline': {
                'color': theme('colors.gray.700'),
                'font-size': '1em',
                'font-style': 'italic',
                'margin-bottom': theme('spacing.2'),
            }
          },
        },
      }),
    },
  },
    // corePlugins: {
    //     preflight: false,
    // }
}