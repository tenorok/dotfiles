const fs = require('node:fs');

const { PREFS_PATH, CONFIG_PATH } = require('./const');

function exportConfig() {
    try {
        const { vivaldi } = JSON.parse(fs.readFileSync(PREFS_PATH, 'utf-8'));

        const config = {
            tabs: vivaldi.tabs || {},
            keyboard: vivaldi.keyboard || {},
            actions: vivaldi.actions || [],
            theme: vivaldi.theme || {},
            themes: vivaldi.themes || {},
        };

        fs.writeFileSync(CONFIG_PATH, JSON.stringify(config, null, 2));
        console.log(`Preferences exported to ${CONFIG_PATH}`);
    } catch (err) {
        console.error('Error exporting preferences:', err.message);
    }
}

exportConfig();
