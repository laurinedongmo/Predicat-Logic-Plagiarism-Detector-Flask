// ================================= declaration des variables
const startnow = document.querySelector('.animation')
const toggle = document.querySelector('.toggle')
const menu = document.querySelector('.menu')
// ================================== function  qui gerre l'animation de start now

function addRemoveanimation(){
    startnow.classList.add('active')
    setTimeout(()=>{
        startnow.classList.remove('active')
        setTimeout(addRemoveanimation,1000)
    },1000)
}

addRemoveanimation();
// ====================================== partir du code qui met et enleve la div concerner

toggle.addEventListener('click',function(){
    menu.classList.toggle('active')
})
document.addEventListener('click', function (e) {
    if (!toggle.contains(e.target) && !menu.contains(e.target) ) {
        setTimeout(function () {
            menu.classList.remove('active')
        }, 10)

    }

})


