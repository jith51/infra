const plugin = require('tailwindcss/plugin')

module.exports = plugin(function ({addComponents}) {
    const test =  {
        '.lavender': {
            'background': '#b67edc'
        },
    }
    addComponents(test)
})