const fs = require('node:fs');

const { PREFS_PATH, CONFIG_PATH } = require('./const');

function importConfig() {
    try {
        if (!fs.existsSync(CONFIG_PATH)) return console.error('Config not found');

        const myConfig = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8'));
        const prefs = JSON.parse(fs.readFileSync(PREFS_PATH, 'utf-8'));

        if (!prefs.vivaldi) prefs.vivaldi = {};

        prefs.vivaldi = {
            ...prefs.vivaldi,
            tabs: { ...prefs.vivaldi.tabs, ...myConfig.tabs },
            keyboard: { ...prefs.vivaldi.keyboard, ...myConfig.keyboard },
            actions: (prefs.vivaldi.actions || []).concat(myConfig.actions),
            theme: myConfig.theme,
            themes: myConfig.themes
        };

        fs.writeFileSync(PREFS_PATH, JSON.stringify(prefs));
        console.log('Configuration successfully imported from dotfiles!');
    } catch (err) {
        console.error('Error importing configuration:', err.message);
    }
}

// Remember to close Vivaldi before running!
importConfig();
