import { Controller } from '@hotwired/stimulus';
const ThemeSwitcherController = class extends Controller {
    initialize() {
        if (localStorage.theme === 'dark' ||
            (!('theme' in localStorage) &&
                window.matchMedia('(prefers-color-scheme: dark)').matches)) {
            this.setDarkMode();
        }
        else {
            this.setLightMode();
        }
    }
    toggle() {
        if (document.documentElement.classList.contains('dark')) {
            this.setLightMode();
        }
        else {
            this.setDarkMode();
        }
    }
    setLightMode() {
        localStorage.theme = 'light';
        document.documentElement.classList.remove('dark');
        document.documentElement.style.colorScheme = '';
    }
    setDarkMode() {
        localStorage.theme = 'dark';
        document.documentElement.classList.add('dark');
        document.documentElement.style.colorScheme = 'dark';
    }
};
export { ThemeSwitcherController };
