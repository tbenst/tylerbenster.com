module.exports = {
  plugins: [
    require('postcss-import'),
    require('tailwindcss'),
    require('postcss-100vh-fix'),
    require('@fullhuman/postcss-purgecss')({
      content: [
        './static/**/*.html',
        './static/**/*.markdown',
        './static/**/*.md',
      ]
    }),
    require('autoprefixer'),
  ]
}