/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./templates/**/*.html"],
  theme: {
    extend: {
      screens: {
        'f1': '1115px', // Ajouter un breakpoint pour les petits mobiles
        'f2':'700px',
        'f3': '865px', 
        'f4': '600px',
        'f5':'644px', 
        'f6':'913px',
        'f7':'977px',
        'f8':'687px',
        'f9':'695px',
        'f10':'52px',
        'f11':'939px',
        'f12':'771px',
      },

    },
  },
  plugins: [],
}

