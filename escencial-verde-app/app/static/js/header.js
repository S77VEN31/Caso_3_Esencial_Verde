const dropdownBtn = document.querySelector('#dropdown-btn');
const dropdownMenu = document.querySelector('#dropdown-menu');

dropdownBtn.addEventListener('click', () => {
  dropdownMenu.classList.toggle('show');
});